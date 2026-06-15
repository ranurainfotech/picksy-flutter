import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { logger } from "firebase-functions/v2";

import { FUNCTIONS_REGION } from "./region";

const rapidApiKey = defineSecret("RAPIDAPI_KEY");
const RAPIDAPI_HOST = "google-map-places-new-v2.p.rapidapi.com";
const RAPIDAPI_BASE = `https://${RAPIDAPI_HOST}`;

type SearchRestaurantsRequest = {
  lat?: number;
  lng?: number;
  radiusMeters?: number;
  minRating?: number;
  priceLevels?: number[];
  cuisineTypes?: string[];
  openNow?: boolean;
  pageToken?: string;
  excludedPlaceIds?: string[];
};

type PlaceRecord = {
  placeId: string;
  name: string;
  rating: number;
  priceLevel: number | null;
  shortAddress: string;
  types: string[];
  photoUrl: string | null;
  googleMapsUri: string | null;
};

function requireAuth(request: { auth?: { uid: string } | null }) {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }
}

function requireRapidApiKey(apiKey: string) {
  if (!apiKey) {
    throw new HttpsError(
      "failed-precondition",
      "RapidAPI key is not configured on the server.",
    );
  }
}

async function rapidPlacesRequest<T>(
  path: string,
  init: RequestInit,
  fieldMask: string,
  apiKey: string,
): Promise<T> {
  const response = await fetch(`${RAPIDAPI_BASE}${path}`, {
    ...init,
    headers: {
      "Content-Type": "application/json",
      "X-Goog-FieldMask": fieldMask,
      "x-rapidapi-key": apiKey,
      "x-rapidapi-host": RAPIDAPI_HOST,
      ...(init.headers as Record<string, string> | undefined),
    },
  });

  if (!response.ok) {
    const body = await response.text();
    logger.error("RapidAPI Places request failed", {
      path,
      status: response.status,
      body,
    });
    throw new HttpsError("internal", "Places request failed.");
  }

  return (await response.json()) as T;
}

async function resolvePhotoUrl(
  photoName: string,
  apiKey: string,
): Promise<string | null> {
  if (!photoName) {
    return null;
  }

  const normalizedName = photoName.startsWith("places/")
    ? photoName
    : `places/${photoName}`;
  const mediaPath = `/v1/${normalizedName}/media?maxHeightPx=800&skipHttpRedirect=true`;

  try {
    const response = await fetch(`${RAPIDAPI_BASE}${mediaPath}`, {
      headers: {
        "x-rapidapi-key": apiKey,
        "x-rapidapi-host": RAPIDAPI_HOST,
      },
    });

    if (!response.ok) {
      logger.warn("Place photo media request failed", {
        photoName,
        status: response.status,
      });
      return null;
    }

    const payload = (await response.json()) as { photoUri?: string };
    return payload.photoUri ?? null;
  } catch (error) {
    logger.warn("Failed to resolve place photo", { photoName, error });
    return null;
  }
}

function normalizePlaceId(rawId: string | undefined): string {
  if (!rawId) {
    return "";
  }
  return rawId.startsWith("places/") ? rawId.slice("places/".length) : rawId;
}

function parsePriceLevel(value: unknown): number | null {
  if (typeof value === "number" && value >= 1 && value <= 4) {
    return value;
  }
  if (typeof value === "string") {
    const parsed = Number.parseInt(value, 10);
    if (!Number.isNaN(parsed) && parsed >= 1 && parsed <= 4) {
      return parsed;
    }
    switch (value) {
      case "PRICE_LEVEL_INEXPENSIVE":
        return 1;
      case "PRICE_LEVEL_MODERATE":
        return 2;
      case "PRICE_LEVEL_EXPENSIVE":
        return 3;
      case "PRICE_LEVEL_VERY_EXPENSIVE":
        return 4;
      default:
        return null;
    }
  }
  return null;
}

function parseRating(value: unknown): number {
  if (typeof value === "number") {
    return value;
  }
  if (typeof value === "string") {
    const parsed = Number.parseFloat(value);
    return Number.isNaN(parsed) ? 0 : parsed;
  }
  return 0;
}

function normalizePlace(place: Record<string, unknown>): Omit<PlaceRecord, "photoUrl"> & {
  photoName: string | null;
} {
  const photoName =
    ((place.photos as Array<{ name?: string }> | undefined)?.[0]?.name as
      | string
      | undefined) ?? null;

  return {
    placeId: normalizePlaceId(
      (place.id as string | undefined) ??
        (place.name as string | undefined)?.replace(/^places\//, ""),
    ),
    name:
      ((place.displayName as { text?: string } | undefined)?.text as
        | string
        | undefined) ?? "Restaurant",
    rating: parseRating(place.rating),
    priceLevel: parsePriceLevel(place.priceLevel),
    shortAddress:
      (place.shortFormattedAddress as string | undefined) ??
      (place.formattedAddress as string | undefined) ??
      "",
    types: (place.types as string[] | undefined) ?? [],
    photoName,
    googleMapsUri: (place.googleMapsUri as string | undefined) ?? null,
  };
}

export const geocodeLocation = onCall(
  { region: FUNCTIONS_REGION, secrets: [rapidApiKey] },
  async (request) => {
    requireAuth(request);
    const apiKey = rapidApiKey.value();
    requireRapidApiKey(apiKey);

    const query = (request.data?.query as string | undefined)?.trim();
    if (!query) {
      throw new HttpsError("invalid-argument", "query is required.");
    }

    const result = await rapidPlacesRequest<{ places?: Array<Record<string, unknown>> }>(
      "/v1/places:searchText",
      {
        method: "POST",
        body: JSON.stringify({
          textQuery: query,
          maxResultCount: 1,
        }),
      },
      "places.displayName,places.location,places.formattedAddress,places.shortFormattedAddress",
      apiKey,
    );

    const place = result.places?.[0];
    const location = place?.location as
      | { latitude?: number; longitude?: number }
      | undefined;

    if (!location?.latitude || !location?.longitude) {
      throw new HttpsError("not-found", "Could not find that area.");
    }

    return {
      lat: location.latitude,
      lng: location.longitude,
      label:
        (place?.formattedAddress as string | undefined) ??
        (place?.shortFormattedAddress as string | undefined) ??
        query,
    };
  },
);

export const searchRestaurants = onCall(
  { region: FUNCTIONS_REGION, secrets: [rapidApiKey] },
  async (request) => {
    requireAuth(request);
    const apiKey = rapidApiKey.value();
    requireRapidApiKey(apiKey);

    const data = (request.data ?? {}) as SearchRestaurantsRequest;
    const lat = data.lat;
    const lng = data.lng;

    if (typeof lat !== "number" || typeof lng !== "number") {
      throw new HttpsError("invalid-argument", "lat and lng are required.");
    }

    const radiusMeters = Math.min(
      Math.max(data.radiusMeters ?? 5000, 500),
      50000,
    );
    const includedTypes =
      data.cuisineTypes && data.cuisineTypes.length > 0
        ? data.cuisineTypes
        : ["restaurant"];

    const body: Record<string, unknown> = {
      includedTypes,
      maxResultCount: 20,
      locationRestriction: {
        circle: {
          center: { latitude: lat, longitude: lng },
          radius: radiusMeters,
        },
      },
    };

    if (data.minRating && data.minRating > 0) {
      body.minRating = data.minRating;
    }
    if (data.openNow) {
      body.openNow = true;
    }

    const fieldMask = [
      "places.id",
      "places.displayName",
      "places.rating",
      "places.priceLevel",
      "places.formattedAddress",
      "places.shortFormattedAddress",
      "places.types",
      "places.photos.name",
      "places.googleMapsUri",
    ].join(",");

    const result = await rapidPlacesRequest<{
      places?: Array<Record<string, unknown>>;
      nextPageToken?: string;
    }>(
      "/v1/places:searchNearby",
      {
        method: "POST",
        body: JSON.stringify(body),
      },
      fieldMask,
      apiKey,
    );

    const excluded = new Set(data.excludedPlaceIds ?? []);
    let places = (result.places ?? [])
      .map(normalizePlace)
      .filter((place) => place.placeId.length > 0 && !excluded.has(place.placeId));

    if (data.priceLevels && data.priceLevels.length > 0) {
      const allowed = new Set(data.priceLevels);
      places = places.filter(
        (place) => place.priceLevel == null || allowed.has(place.priceLevel),
      );
    }

    const withPhotos: PlaceRecord[] = await Promise.all(
      places.slice(0, 20).map(async (place) => {
        const photoUrl = place.photoName
          ? await resolvePhotoUrl(place.photoName, apiKey)
          : null;
        return {
          placeId: place.placeId,
          name: place.name,
          rating: place.rating,
          priceLevel: place.priceLevel,
          shortAddress: place.shortAddress,
          types: place.types,
          photoUrl,
          googleMapsUri: place.googleMapsUri,
        };
      }),
    );

    return {
      places: withPhotos,
      nextPageToken: null,
    };
  },
);

export const getPlaceDetails = onCall(
  { region: FUNCTIONS_REGION, secrets: [rapidApiKey] },
  async (request) => {
    requireAuth(request);
    const apiKey = rapidApiKey.value();
    requireRapidApiKey(apiKey);

    const placeId = normalizePlaceId(request.data?.placeId as string | undefined);
    if (!placeId) {
      throw new HttpsError("invalid-argument", "placeId is required.");
    }

    const fieldMask = [
      "id",
      "displayName",
      "rating",
      "priceLevel",
      "formattedAddress",
      "shortFormattedAddress",
      "types",
      "photos.name",
      "googleMapsUri",
      "regularOpeningHours.weekdayDescriptions",
      "editorialSummary.text",
      "websiteUri",
    ].join(",");

    const place = await rapidPlacesRequest<Record<string, unknown>>(
      `/v1/places/${encodeURIComponent(placeId)}`,
      { method: "GET" },
      fieldMask,
      apiKey,
    );

    const normalized = normalizePlace(place);
    const photoUrl = normalized.photoName
      ? await resolvePhotoUrl(normalized.photoName, apiKey)
      : null;

    return {
      placeId: normalized.placeId,
      name: normalized.name,
      rating: normalized.rating,
      priceLevel: normalized.priceLevel,
      shortAddress: normalized.shortAddress,
      types: normalized.types,
      photoUrl,
      googleMapsUri: normalized.googleMapsUri,
      overview:
        ((place.editorialSummary as { text?: string } | undefined)?.text as
          | string
          | undefined) ?? "",
      openingHours:
        ((place.regularOpeningHours as { weekdayDescriptions?: string[] } | undefined)
          ?.weekdayDescriptions as string[] | undefined) ?? [],
      websiteUri: (place.websiteUri as string | undefined) ?? null,
    };
  },
);

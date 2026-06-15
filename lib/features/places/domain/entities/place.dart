class Place {
  const Place({
    required this.placeId,
    required this.name,
    required this.rating,
    this.priceLevel,
    this.shortAddress = '',
    this.types = const <String>[],
    this.photoUrl,
    this.photoName,
    this.googleMapsUri,
  });

  final String placeId;
  final String name;
  final double rating;
  final int? priceLevel;
  final String shortAddress;
  final List<String> types;
  final String? photoUrl;
  final String? photoName;
  final String? googleMapsUri;

  String get priceLabel {
    return switch (priceLevel) {
      1 => '\$',
      2 => '\$\$',
      3 => '\$\$\$',
      4 => '\$\$\$\$',
      _ => '—',
    };
  }

  String get cuisineLabel {
    for (final type in types) {
      if (type.endsWith('_restaurant')) {
        return type
            .replaceAll('_restaurant', '')
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (part) => part.isEmpty
                  ? part
                  : '${part[0].toUpperCase()}${part.substring(1)}',
            )
            .join(' ');
      }
    }
    return 'Restaurant';
  }

  String get subtitle =>
      '$cuisineLabel • $priceLabel • ⭐ ${rating.toStringAsFixed(1)}';

  Map<String, dynamic> toCacheJson() {
    return <String, dynamic>{
      'placeId': placeId,
      'name': name,
      'rating': rating,
      if (priceLevel != null) 'priceLevel': priceLevel,
      'shortAddress': shortAddress,
      'types': types,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (photoName != null) 'photoName': photoName,
      if (googleMapsUri != null) 'googleMapsUri': googleMapsUri,
    };
  }

  factory Place.fromCacheJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['placeId'] as String? ?? '',
      name: json['name'] as String? ?? 'Restaurant',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      priceLevel: (json['priceLevel'] as num?)?.toInt(),
      shortAddress: json['shortAddress'] as String? ?? '',
      types: (json['types'] as List?)
              ?.map((entry) => '$entry')
              .toList(growable: false) ??
          const <String>[],
      photoUrl: json['photoUrl'] as String?,
      photoName: json['photoName'] as String?,
      googleMapsUri: json['googleMapsUri'] as String?,
    );
  }
}

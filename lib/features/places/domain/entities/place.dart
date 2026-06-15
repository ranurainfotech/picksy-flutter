class Place {
  const Place({
    required this.placeId,
    required this.name,
    required this.rating,
    this.priceLevel,
    this.shortAddress = '',
    this.types = const <String>[],
    this.photoUrl,
    this.googleMapsUri,
  });

  final String placeId;
  final String name;
  final double rating;
  final int? priceLevel;
  final String shortAddress;
  final List<String> types;
  final String? photoUrl;
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
}

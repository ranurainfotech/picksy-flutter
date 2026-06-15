class RestaurantCuisineOption {
  const RestaurantCuisineOption({
    required this.placesType,
    required this.label,
    required this.emoji,
  });

  final String placesType;
  final String label;
  final String emoji;

  String get displayLabel => '$label $emoji';
}

const restaurantCuisineOptions = <RestaurantCuisineOption>[
  RestaurantCuisineOption(
    placesType: 'restaurant',
    label: 'All',
    emoji: '🍽️',
  ),
  RestaurantCuisineOption(
    placesType: 'indian_restaurant',
    label: 'Indian',
    emoji: '🍛',
  ),
  RestaurantCuisineOption(
    placesType: 'italian_restaurant',
    label: 'Italian',
    emoji: '🍝',
  ),
  RestaurantCuisineOption(
    placesType: 'chinese_restaurant',
    label: 'Chinese',
    emoji: '🥡',
  ),
  RestaurantCuisineOption(
    placesType: 'japanese_restaurant',
    label: 'Japanese',
    emoji: '🍣',
  ),
  RestaurantCuisineOption(
    placesType: 'mexican_restaurant',
    label: 'Mexican',
    emoji: '🌮',
  ),
  RestaurantCuisineOption(
    placesType: 'cafe',
    label: 'Cafe',
    emoji: '☕',
  ),
  RestaurantCuisineOption(
    placesType: 'pizza_restaurant',
    label: 'Pizza',
    emoji: '🍕',
  ),
  RestaurantCuisineOption(
    placesType: 'fast_food_restaurant',
    label: 'Fast Food',
    emoji: '🍔',
  ),
];

const restaurantPriceLevelOptions = <({int level, String label})>[
  (level: 1, label: '\$'),
  (level: 2, label: '\$\$'),
  (level: 3, label: '\$\$\$'),
  (level: 4, label: '\$\$\$\$'),
];

enum SwipeDecision {
  disliked,
  maybe,
  liked;

  String get wireValue {
    switch (this) {
      case SwipeDecision.disliked:
        return 'disliked';
      case SwipeDecision.maybe:
        return 'maybe';
      case SwipeDecision.liked:
        return 'liked';
    }
  }
}

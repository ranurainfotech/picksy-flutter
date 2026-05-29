class SwipeSubmitOutcome {
  const SwipeSubmitOutcome({
    this.matchCreated = false,
    this.matchType,
    this.memberCount = 0,
    this.likeCount = 0,
  });

  final bool matchCreated;
  final String? matchType;
  final int memberCount;
  final int likeCount;

  bool get isPerfectMatch => matchType == 'perfect';
  bool get isMajorityMatch => matchType == 'majority';
}

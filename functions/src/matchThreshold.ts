/** Mirrors `matchLikeThreshold` in swipe_repository.dart */
export function matchLikeThreshold(memberCount: number): number {
  if (memberCount < 2) {
    return memberCount + 1;
  }
  if (memberCount === 2) {
    return 2;
  }
  return Math.max(2, Math.min(memberCount, Math.floor(memberCount * 0.75)));
}

export function matchJustCrossedThreshold(
  beforeLikes: number,
  afterLikes: number,
  memberCount: number,
): boolean {
  if (memberCount < 2) {
    return false;
  }
  const threshold = matchLikeThreshold(memberCount);
  return beforeLikes < threshold && afterLikes >= threshold;
}

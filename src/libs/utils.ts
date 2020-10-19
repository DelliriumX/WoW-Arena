export function AngleBetweenPoints(x1: number, y1: number, x2: number, y2: number) {
  return bj_RADTODEG * Atan2(y2 - y1, x2 - x1)
}

export function DistanceBetweenPoints(x1: number, y1: number, x2: number, y2: number) {
  const dx = x2 - x1
  const dy = y2 - y1
  return SquareRoot(dx * dx + dy * dy)
}

export const Math = {

}
export function AngleBetweenPoints(x1: number, y1: number, x2: number, y2: number): number {
  return bj_RADTODEG * Atan2(y2 - y1, x2 - x1)
}

export function DistanceBetweenPoints(x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1
  const dy = y2 - y1
  return SquareRoot(dx * dx + dy * dy)
}

export const uid = (function () {
  let released: number[] = []
  let max = 0
  function get(): number {
    let id;
    if (released.length === 0) {
      id = max
      max = max + 1
    } else {
      id = released[released.length - 1]
      delete released[released.length]
    }
    return id
  }
  function release(i: number) {
    released[released.length] = i
  }
  return { get, release }
})()
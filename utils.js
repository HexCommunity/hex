const UNITS = {
  HEART: 1,
  HEX: 1e8
}

module.exports = {
  toHeart,
  fromHeart,
  unit
}

function toHeart(int, unit) {
  return unit(unit, int, 'heart')
}

function fromHeart(int, unit) {
  return unit('heart', int, unit)
}

function toBN(int) {
  switch(typeof int) {
    case 'string':
      return new BN(int)
    case 'number':
      return new BN(int)
    case 'object':
      return new BN(int.toString())
  }
}

function unit(current, int, future) {
  const intBN = toBN(int)
  const start = UNITS[current.toUpperCase()]
  const end = UNITS[future.toUpperCase()]
  return intBN.mul(start).div(end)
}

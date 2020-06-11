const BN = require('bn.js')
const UNITS = {
  HEART: new BN(1),
  MICROHEX: new BN(1e2),
  MILLIHEX: new BN(1e5),
  HEX: new BN(1e8),
  HECTOHEX: new BN(1e10),
  KILOHEX: new BN(1e11),
  MEGAHEX: new BN(1e14),
  GIGAHEX: new BN(1e17),
  TERAHEX: new BN(1e20)
}

module.exports = {
  UNITS,
  toHeart,
  fromHeart,
  convert
}

function toHeart(int, unit = 'hex') {
  return convert(unit, int, 'heart')
}

function fromHeart(int, unit = 'hex') {
  return convert('heart', int, unit)
}

function toBN(int) {
  switch(typeof int) {
    case 'string':
      return new BN(int)
    case 'number':
      return new BN(int)
    case 'object':
      // .toString must resolve to a string
      return new BN(int.toString())
  }
}

function convert(current, int, future) {
  const intBN = toBN(int)
  const start = UNITS[current.toUpperCase()]
  const end = UNITS[future.toUpperCase()]
  return intBN.mul(start).div(end)
}

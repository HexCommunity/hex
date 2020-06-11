# HEX
a repo for all things hex solidity / truffle development

## *WARNING*
this package is untested

need tests for all code (`.sol` + `.js`)

# contracts
use `contracts/*` to test the contracts you plan to build on hex.

# utils

```js
const { UNITS, fromHeart, toHeart, convert } = require('@hexcommunity/hex/utils')
```

### `UNITS`
an object with the units as keys and the factor (1e8) as values.
```
heart
microhex
millihex
hex
hectohex
kilohex
megahex
gigahex
terahex
```

### `convert`
convert any unit into any other unit returns a BN.js value
```js
convert('heart', 200000000, 'hex') // 2<BN>
```

### `fromHeart`
convert `heart` unit to any other unit, default destination `hex`
```js
fromHeart(200000000)             // 2<BN>
fromHeart(200000000, 'hex')      // 2<BN>
fromHeart(200000000, 'millihex') // 2000<BN>
```

### `toHeart`
convert from any other unit to `heart`, default source `hex`
```js
fromHeart(2)                // 200000000<BN>
fromHeart(2, 'hex')         // 200000000<BN>
fromHeart(2000, 'millihex') // 200000000<BN>
```

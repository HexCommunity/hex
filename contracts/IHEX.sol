/**
 * SPDX-License-Identifier: NO LICENSE
 */
pragma solidity ^0.8.9;

contract HEXData {
    /* Origin address */
    address public constant ORIGIN_ADDR = 0x9A6a414D6F3497c05E3b1De90520765fA1E07c03;

    /* Flush address */
    address payable public constant FLUSH_ADDR = payable(0xDEC9f2793e3c17cd26eeFb21C4762fA5128E0399);

    /* ERC20 constants */
    string public constant name = "HEX";
    string public constant symbol = "HEX";
    uint8 public constant decimals = 8;

    /* Hearts per Satoshi = 10,000 * 1e8 / 1e8 = 1e4 */
    uint256 public constant HEARTS_PER_HEX = 10 ** uint256(decimals); // 1e8
    uint256 public constant HEX_PER_BTC = 1e4;
    uint256 public constant SATOSHIS_PER_BTC = 1e8;
    uint256 public constant HEARTS_PER_SATOSHI = HEARTS_PER_HEX / SATOSHIS_PER_BTC * HEX_PER_BTC;

    /* Time of contract launch (2019-12-03T00:00:00Z) */
    uint256 public constant LAUNCH_TIME = 1575331200;

    /* Size of a Hearts or Shares uint */
    uint256 public constant HEART_UINT_SIZE = 72;

    /* Size of a transform lobby entry index uint */
    uint256 public constant XF_LOBBY_ENTRY_INDEX_SIZE = 40;
    uint256 public constant XF_LOBBY_ENTRY_INDEX_MASK = (1 << XF_LOBBY_ENTRY_INDEX_SIZE) - 1;

    /* Seed for WAAS Lobby */
    uint256 public constant WAAS_LOBBY_SEED_HEX = 1e9;
    uint256 public constant WAAS_LOBBY_SEED_HEARTS = WAAS_LOBBY_SEED_HEX * HEARTS_PER_HEX;

    /* Start of claim phase */
    uint256 public constant PRE_CLAIM_DAYS = 1;
    uint256 public constant CLAIM_PHASE_START_DAY = PRE_CLAIM_DAYS;

    /* Length of claim phase */
    uint256 public constant CLAIM_PHASE_WEEKS = 50;
    uint256 public constant CLAIM_PHASE_DAYS = CLAIM_PHASE_WEEKS * 7;

    /* End of claim phase */
    uint256 public constant CLAIM_PHASE_END_DAY = CLAIM_PHASE_START_DAY + CLAIM_PHASE_DAYS;

    /* Number of words to hold 1 bit for each transform lobby day */
    uint256 public constant XF_LOBBY_DAY_WORDS = (CLAIM_PHASE_END_DAY + 255) >> 8;

    /* BigPayDay */
    uint256 public constant BIG_PAY_DAY = CLAIM_PHASE_END_DAY + 1;

    /* Root hash of the UTXO Merkle tree */
    bytes32 public constant MERKLE_TREE_ROOT = 0x4e831acb4223b66de3b3d2e54a2edeefb0de3d7916e2886a4b134d9764d41bec;

    /* Size of a Satoshi claim uint in a Merkle leaf */
    uint256 public constant MERKLE_LEAF_SATOSHI_SIZE = 45;

    /* Zero-fill between BTC address and Satoshis in a Merkle leaf */
    uint256 public constant MERKLE_LEAF_FILL_SIZE = 256 - 160 - MERKLE_LEAF_SATOSHI_SIZE;
    uint256 public constant MERKLE_LEAF_FILL_BASE = (1 << MERKLE_LEAF_FILL_SIZE) - 1;
    uint256 public constant MERKLE_LEAF_FILL_MASK = MERKLE_LEAF_FILL_BASE << MERKLE_LEAF_SATOSHI_SIZE;

    /* Size of a Satoshi total uint */
    uint256 public constant SATOSHI_UINT_SIZE = 51;
    uint256 public constant SATOSHI_UINT_MASK = (1 << SATOSHI_UINT_SIZE) - 1;

    /* Total Satoshis from all BTC addresses in UTXO snapshot */
    uint256 public constant FULL_SATOSHIS_TOTAL = 1807766732160668;

    /* Total Satoshis from supported BTC addresses in UTXO snapshot after applying Silly Whale */
    uint256 public constant CLAIMABLE_SATOSHIS_TOTAL = 910087996911001;

    /* Number of claimable BTC addresses in UTXO snapshot */
    uint256 public constant CLAIMABLE_BTC_ADDR_COUNT = 27997742;

    /* Largest BTC address Satoshis balance in UTXO snapshot (sanity check) */
    uint256 public constant MAX_BTC_ADDR_BALANCE_SATOSHIS = 25550214098481;

    /* Percentage of total claimed Hearts that will be auto-staked from a claim */
    uint256 public constant AUTO_STAKE_CLAIM_PERCENT = 90;

    /* Stake timing parameters */
    uint256 public constant MIN_STAKE_DAYS = 1;
    uint256 public constant MIN_AUTO_STAKE_DAYS = 350;

    uint256 public constant MAX_STAKE_DAYS = 5555; // Approx 15 years

    uint256 public constant EARLY_PENALTY_MIN_DAYS = 90;

    uint256 public constant LATE_PENALTY_GRACE_WEEKS = 2;
    uint256 public constant LATE_PENALTY_GRACE_DAYS = LATE_PENALTY_GRACE_WEEKS * 7;

    uint256 public constant LATE_PENALTY_SCALE_WEEKS = 100;
    uint256 public constant LATE_PENALTY_SCALE_DAYS = LATE_PENALTY_SCALE_WEEKS * 7;

    /* Stake shares Longer Pays Better bonus constants used by _stakeStartBonusHearts() */
    uint256 public constant LPB_BONUS_PERCENT = 20;
    uint256 public constant LPB_BONUS_MAX_PERCENT = 200;
    uint256 public constant LPB = 364 * 100 / LPB_BONUS_PERCENT;
    uint256 public constant LPB_MAX_DAYS = LPB * LPB_BONUS_MAX_PERCENT / 100;

    /* Stake shares Bigger Pays Better bonus constants used by _stakeStartBonusHearts() */
    uint256 public constant BPB_BONUS_PERCENT = 10;
    uint256 public constant BPB_MAX_HEX = 150 * 1e6;
    uint256 public constant BPB_MAX_HEARTS = BPB_MAX_HEX * HEARTS_PER_HEX;
    uint256 public constant BPB = BPB_MAX_HEARTS * 100 / BPB_BONUS_PERCENT;

    /* Share rate is scaled to increase precision */
    uint256 public constant SHARE_RATE_SCALE = 1e5;

    /* Share rate max (after scaling) */
    uint256 public constant SHARE_RATE_UINT_SIZE = 40;
    uint256 public constant SHARE_RATE_MAX = (1 << SHARE_RATE_UINT_SIZE) - 1;

    /* Constants for preparing the claim message text */
    uint8 public constant ETH_ADDRESS_BYTE_LEN = 20;
    uint8 public constant ETH_ADDRESS_HEX_LEN = ETH_ADDRESS_BYTE_LEN * 2;

    uint8 public constant CLAIM_PARAM_HASH_BYTE_LEN = 12;
    uint8 public constant CLAIM_PARAM_HASH_HEX_LEN = CLAIM_PARAM_HASH_BYTE_LEN * 2;

    uint8 public constant BITCOIN_SIG_PREFIX_LEN = 24;
    bytes24 public constant BITCOIN_SIG_PREFIX_STR = "Bitcoin Signed Message:\n";

    bytes public constant STD_CLAIM_PREFIX_STR = "Claim_HEX_to_0x";
    bytes public constant OLD_CLAIM_PREFIX_STR = "Claim_BitcoinHEX_to_0x";

    bytes16 public constant HEX_DIGITS = "0123456789abcdef";

    /* Claim flags passed to btcAddressClaim()  */
    uint8 public constant CLAIM_FLAG_MSG_PREFIX_OLD = 1 << 0;
    uint8 public constant CLAIM_FLAG_BTC_ADDR_COMPRESSED = 1 << 1;
    uint8 public constant CLAIM_FLAG_BTC_ADDR_P2WPKH_IN_P2SH = 1 << 2;
    uint8 public constant CLAIM_FLAG_BTC_ADDR_BECH32 = 1 << 3;
    uint8 public constant CLAIM_FLAG_ETH_ADDR_LOWERCASE = 1 << 4;
    
    /* Globals expanded for memory (except _latestStakeId) and compact for storage */
    struct GlobalsCache {
        // 1
        uint256 _lockedHeartsTotal;
        uint256 _nextStakeSharesTotal;
        uint256 _shareRate;
        uint256 _stakePenaltyTotal;
        // 2
        uint256 _dailyDataCount;
        uint256 _stakeSharesTotal;
        uint40 _latestStakeId;
        uint256 _unclaimedSatoshisTotal;
        uint256 _claimedSatoshisTotal;
        uint256 _claimedBtcAddrCount;
        //
        uint256 _currentDay;
    }

    struct GlobalsStore {
        // 1
        uint72 lockedHeartsTotal;
        uint72 nextStakeSharesTotal;
        uint40 shareRate;
        uint72 stakePenaltyTotal;
        // 2
        uint16 dailyDataCount;
        uint72 stakeSharesTotal;
        uint40 latestStakeId;
        uint128 claimStats;
    }

    GlobalsStore public globals;

    /* Claimed BTC addresses */
    mapping(bytes20 => bool) public btcAddressClaims;

    /* Daily data */
    struct DailyDataStore {
        uint72 dayPayoutTotal;
        uint72 dayStakeSharesTotal;
        uint56 dayUnclaimedSatoshisTotal;
    }

    mapping(uint256 => DailyDataStore) public dailyData;

    /* Stake expanded for memory (except _stakeId) and compact for storage */
    struct StakeCache {
        uint40 _stakeId;
        uint256 _stakedHearts;
        uint256 _stakeShares;
        uint256 _lockedDay;
        uint256 _stakedDays;
        uint256 _unlockedDay;
        bool _isAutoStake;
    }

    struct StakeStore {
        uint40 stakeId;
        uint72 stakedHearts;
        uint72 stakeShares;
        uint16 lockedDay;
        uint16 stakedDays;
        uint16 unlockedDay;
        bool isAutoStake;
    }

    mapping(address => StakeStore[]) public stakeLists;

    /* Temporary state for calculating daily rounds */
    struct DailyRoundState {
        uint256 _allocSupplyCached;
        uint256 _mintOriginBatch;
        uint256 _payoutTotal;
    }

    struct XfLobbyEntryStore {
        uint96 rawAmount;
        address referrerAddr;
    }

    struct XfLobbyQueueStore {
        uint40 headIndex;
        uint40 tailIndex;
        mapping(uint256 => XfLobbyEntryStore) entries;
    }

    mapping(uint256 => uint256) public xfLobby;
    mapping(uint256 => mapping(address => XfLobbyQueueStore)) public xfLobbyMembers;
}

/**
 * @dev contract of the HEX contract
 */
interface IHEXGlobalsAndUtility {
    /**
     * @dev PUBLIC FACING: Optionally update daily data for a smaller
     * range to reduce gas cost for a subsequent operation
     * @param beforeDay Only update days before this day number (optional; 0 for current day)
     */
    function dailyDataUpdate(uint256 beforeDay)
        external;
    /**
     * @dev PUBLIC FACING: External helper to return multiple values of daily data with
     * a single call. Ugly implementation due to limitations of the standard ABI encoder.
     * @param beginDay First day of data range
     * @param endDay Last day (non-inclusive) of data range
     * @return list Fixed array of packed values
     */
    function dailyDataRange(uint256 beginDay, uint256 endDay)
        external
        view
        returns (uint256[] memory list);
    /**
     * @dev PUBLIC FACING: External helper to return most global info with a single call.
     * Ugly implementation due to limitations of the standard ABI encoder.
     * @return Fixed array of values
     */
    function globalInfo()
        external
        view
        returns (uint256[13] memory);
    /**
     * @dev PUBLIC FACING: External helper for the current day number since launch time
     * @return Current day number (zero-based)
     */
    function currentDay()
        external
        view
        returns (uint256);
    /**
     * @dev PUBLIC FACING: ERC20 totalSupply() is the circulating supply and does not include any
     * staked Hearts. allocatedSupply() includes both.
     * @return Allocated Supply in Hearts
     */
    function allocatedSupply()
        external
        view
        returns (uint256);
} 

interface IHEXStakeableToken is IHEXGlobalsAndUtility {
    /**
     * @dev PUBLIC FACING: Open a stake.
     * @param newStakedHearts Number of Hearts to stake
     * @param newStakedDays Number of days to stake
     */
    function stakeStart(uint256 newStakedHearts, uint256 newStakedDays)
        external;
    /**
     * @dev PUBLIC FACING: Unlocks a completed stake, distributing the proceeds of any penalty
     * immediately. The staker must still call stakeEnd() to retrieve their stake return (if any).
     * @param stakerAddr Address of staker
     * @param stakeIndex Index of stake within stake list
     * @param stakeIdParam The stake's id
     */
    function stakeGoodAccounting(address stakerAddr, uint256 stakeIndex, uint40 stakeIdParam)
        external;
    /**
     * @dev PUBLIC FACING: Closes a stake. The order of the stake list can change so
     * a stake id is used to reject stale indexes.
     * @param stakeIndex Index of stake within stake list
     * @param stakeIdParam The stake's id
     */
    function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam)
        external;
    /**
     * @dev PUBLIC FACING: Return the current stake count for a staker address
     * @param stakerAddr Address of staker
     */
    function stakeCount(address stakerAddr)
        external
        view
        returns (uint256);
}

interface IHEXUTXOClaimValidation is IHEXStakeableToken {
    /**
     * @dev PUBLIC FACING: Verify a BTC address and balance are unclaimed and part of the Merkle tree
     * @param btcAddr Bitcoin address (binary; no base58-check encoding)
     * @param rawSatoshis Raw BTC address balance in Satoshis
     * @param proof Merkle tree proof
     * @return True if can be claimed
     */
    function btcAddressIsClaimable(bytes20 btcAddr, uint256 rawSatoshis, bytes32[] calldata proof)
        external
        view
        returns (bool);
    /**
     * @dev PUBLIC FACING: Verify a BTC address and balance are part of the Merkle tree
     * @param btcAddr Bitcoin address (binary; no base58-check encoding)
     * @param rawSatoshis Raw BTC address balance in Satoshis
     * @param proof Merkle tree proof
     * @return True if valid
     */
    function btcAddressIsValid(bytes20 btcAddr, uint256 rawSatoshis, bytes32[] calldata proof)
        external
        pure
        returns (bool);
    /**
     * @dev PUBLIC FACING: Verify a Merkle proof using the UTXO Merkle tree
     * @param merkleLeaf Leaf asserted to be present in the Merkle tree
     * @param proof Generated Merkle tree proof
     * @return True if valid
     */
    function merkleProofIsValid(bytes32 merkleLeaf, bytes32[] calldata proof)
        external
        pure
        returns (bool);
    /**
     * @dev PUBLIC FACING: Verify that a Bitcoin signature matches the claim message containing
     * the Ethereum address and claim param hash
     * @param claimToAddr Eth address within the signed claim message
     * @param claimParamHash Param hash within the signed claim message
     * @param pubKeyX First  half of uncompressed ECDSA public key
     * @param pubKeyY Second half of uncompressed ECDSA public key
     * @param claimFlags Claim flags specifying address and message formats
     * @param v v parameter of ECDSA signature
     * @param r r parameter of ECDSA signature
     * @param s s parameter of ECDSA signature
     * @return True if matching
     */
    function claimMessageMatchesSignature(
        address claimToAddr,
        bytes32 claimParamHash,
        bytes32 pubKeyX,
        bytes32 pubKeyY,
        uint8 claimFlags,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        external
        pure
        returns (bool);
    /**
     * @dev PUBLIC FACING: Derive an Ethereum address from an ECDSA public key
     * @param pubKeyX First  half of uncompressed ECDSA public key
     * @param pubKeyY Second half of uncompressed ECDSA public key
     * @return Derived Eth address
     */
    function pubKeyToEthAddress(bytes32 pubKeyX, bytes32 pubKeyY)
        external
        pure
        returns (address);
    /**
     * @dev PUBLIC FACING: Derive a Bitcoin address from an ECDSA public key
     * @param pubKeyX First  half of uncompressed ECDSA public key
     * @param pubKeyY Second half of uncompressed ECDSA public key
     * @param claimFlags Claim flags specifying address and message formats
     * @return Derived Bitcoin address (binary; no base58-check encoding)
     */
    function pubKeyToBtcAddress(bytes32 pubKeyX, bytes32 pubKeyY, uint8 claimFlags)
        external
        pure
        returns (bytes20);
}

interface IHEXUTXORedeemableToken is IHEXUTXOClaimValidation {
    /**
     * @dev PUBLIC FACING: Claim a BTC address and its Satoshi balance in Hearts
     * crediting the appropriate amount to a specified Eth address. Bitcoin ECDSA
     * signature must be from that BTC address and must match the claim message
     * for the Eth address.
     * @param rawSatoshis Raw BTC address balance in Satoshis
     * @param proof Merkle tree proof
     * @param claimToAddr Destination Eth address to credit Hearts to
     * @param pubKeyX First  half of uncompressed ECDSA public key for the BTC address
     * @param pubKeyY Second half of uncompressed ECDSA public key for the BTC address
     * @param claimFlags Claim flags specifying address and message formats
     * @param v v parameter of ECDSA signature
     * @param r r parameter of ECDSA signature
     * @param s s parameter of ECDSA signature
     * @param autoStakeDays Number of days to auto-stake, subject to minimum auto-stake days
     * @param referrerAddr Eth address of referring user (optional; 0x0 for no referrer)
     * @return Total number of Hearts credited, if successful
     */
    function btcAddressClaim(
        uint256 rawSatoshis,
        bytes32[] calldata proof,
        address claimToAddr,
        bytes32 pubKeyX,
        bytes32 pubKeyY,
        uint8 claimFlags,
        uint8 v,
        bytes32 r,
        bytes32 s,
        uint256 autoStakeDays,
        address referrerAddr
    )
        external
        returns (uint256);
    
}

interface IHEXTransformableToken is IHEXUTXORedeemableToken {
    /**
     * @dev PUBLIC FACING: Enter the tranform lobby for the current round
     * @param referrerAddr Eth address of referring user (optional; 0x0 for no referrer)
     */
    function xfLobbyEnter(address referrerAddr)
        external
        payable;
    /**
     * @dev PUBLIC FACING: Leave the transform lobby after the round is complete
     * @param enterDay Day number when the member entered
     * @param count Number of queued-enters to exit (optional; 0 for all)
     */
    function xfLobbyExit(uint256 enterDay, uint256 count)
        external;
    /**
     * @dev PUBLIC FACING: Release any value that has been sent to the contract
     */
    function xfLobbyFlush()
        external;
    /**
     * @dev PUBLIC FACING: External helper to return multiple values of xfLobby[] with
     * a single call
     * @param beginDay First day of data range
     * @param endDay Last day (non-inclusive) of data range
     * @return list Fixed array of values
     */
    function xfLobbyRange(uint256 beginDay, uint256 endDay)
        external
        view
        returns (uint256[] memory list);
    /**
     * @dev PUBLIC FACING: Return a current lobby member queue entry.
     * Only needed due to limitations of the standard ABI encoder.
     * @param memberAddr Eth address of the lobby member
     * @param entryId 49 bit compound value. Top 9 bits: enterDay, Bottom 40 bits: entryIndex
     * @return rawAmount uint256 Raw amount that was entered with
     * @return referrerAddr address Referring Eth addr (optional; 0x0 for no referrer)
     */
    function xfLobbyEntry(address memberAddr, uint256 entryId)
        external
        view
        returns (uint256 rawAmount, address referrerAddr);
    /**
     * @dev PUBLIC FACING: Return the lobby days that a user is in with a single call
     * @param memberAddr Eth address of the user
     * @return words Bit vector of lobby day numbers
     */
    function xfLobbyPendingDays(address memberAddr)
        external
        view
        returns (uint256[(1 + (50 * 7) + 255) >> 8] memory words);
}

interface IHEX is IHEXTransformableToken {}

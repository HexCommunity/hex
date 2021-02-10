import "./ISimpleStaking.sol";
import "./IHEX.sol";

contract HexSimpleStaking is ISimpleStaking {
  /* Holds the HEX contract address */
  address public targetContract;
  struct Stake {
    uint256 amount;
    bool unstaked;
    uint16 lockedDay;
    uint16 unlockedDay;
  }
  mapping(address => Stake[]) public stakes;
  /* 
  Staked
    address user   indexed
    uint256 amount
    uint256 total
    bytes   data
  */
  event Staked(address indexed user, uint256 amount, uint256 total, bytes data);

  /* 
  Staked
    address user   indexed
    uint256 amount
    uint256 total
    bytes   data
  */
  event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
  
  /**
   * @dev fallback fails to keep accounting tight
   */
  function() external payable {
    require("HexSimpleStaking: FALLBACK_NOT_SUPPORTED");
  }

  /**
   * @dev Creates the Hex SimpleStaking interface
   * @param _targetContract to point to the root implementation of HEX
   */
  constructor(
    address _targetContract
  ) 
    public 
  {
    targetContract = _targetContract;
  }

  /**
   * @dev Stakes the tokens
   * @param amount Number of hearts to stake
   * @param data Bytes to store arbitrary data
   */
  function stake(uint256 amount, bytes data) external {
    bytes newStakedDays;
    bytes leftovers;
    (newStakedDays, leftovers) = this.splitBytes(data, 256);
    IHEX(targetContract).delegatecall(
      abi.encodeWithSignature(
        "stakeStart(uint256,uint256)", 
        amount,
        uint256(newStakedDays)
      )
    );
    emit Staked(
      msg.sender, 
      amount, 
      this.totalStakedForAt(
        msg.sender, 
        IHEX(targetContract).currentDay()
      ),
      leftovers
    );
  }

  /**
   * @dev HEX does not allow staking for tokens you do not hold so we have to setup a quick layer to assist
   * @param user The address to attribute tokens to when they are unstaked
   * @param amount The number of tokens to transfer to this proxy contract and stake
   * @param data holds arbitrary data for the stake event
   */
  function stakeFor(address user, uint256 amount, bytes data) external {
    // stake for someone else
    bytes newStakedDays;
    (newStakedDays, _) = this.splitBytes(data, 256);
    IHEX(targetContract).transferFrom(msg.sender, address(this), amount);
    stakes[user].push(Stake({
      amount: amount,
      unstaked: false,
      lockedDay: IHEX(targetContract).currentDay(),
      unlockedDay: uint16(newStakedDays)
    }));
    this.stake(amount, data);
  }

  /**
   * @dev unstake tokens either held against this contract or held against sender
   * @param amount The number of tokens to transfer to this proxy contract and stake. Do not use if staked your own tokens
   * @param data holds data for the stake event such as the stakeIndex and Id. Arbitrary data can be tacked onto the end
   */
  function unstake(uint256 amount, bytes data) external {
    bytes stakeIndexBytes;
    bytes stakeIdBytes;
    bytes leftover;
    (stakeIndexBytes, stakeIdBytes) = this.splitBytes(data, 256);
    (stakeIdBytes, leftover) = this.splitBytes(stakeIdBytes, 40);
    IHEX IHEXContract = IHEX(targetContract);
    if (amount > 0) {
      // if you did not setup the stake yourself
      Stakes[] storage userStakes = stakes[user];
      uint256 stakeIndex = 0;
      for (uint256 i = 0; i < userStakes; i += 1) {
        Stake memory userStake = userStakes[i];
        if (!userStake.unstaked && userStake.amount == amount) {
          stakeIndex = i + 1;
          break;
        }
      }
      require(stakeIndex > 0, "HexSimpleStaking: UNABLE_TO_UNSTAKE");
      Stake storage stake = userStakes[stakeIndex - 1];
      IHEXContract.balanceOf(address(this));
      IHEXContract.call(
        abi.encodeWithSignature(
          "stakeEnd(uint256,uint40)",
          uint256(stakeIndexBytes),
          uint40(stakeIdBytes)
        )
      );
      IHEXContract.balanceOf(address(this));
      IHEXContract.transfer(msg.sender, balanceAfter.sub(balanceBefore));
      stake.unstaked = true;
    } else {
      IHEXContract.delegatecall(
        abi.encodeWithSignature(
          "stakeEnd(uint256,uint40)",
          uint256(stakeIndexBytes),
          uint40(stakeIdBytes)
        )
      );
    }
    emit Unstaked(
      msg.sender, 
      amount, 
      this.totalStakedForAt(
        msg.sender,
        IHEXContract.currentDay()
      ),
      leftover
    );
  }

  function splitBytes(bytes data, uint midpoint) internal returns(bytes, bytes) {
    if (data.length == midpoint) {
      return (data, new bytes());
    }
    bytes memory data1 = new bytes(midpoint);
    for (uint256 i = 0; i < midpoint; i++) {
      data1[i] = data[i];
    }
    bytes memory data2 = new bytes(data.length - midpoint);
    for (i = 0; i < data.length - midpoint; i++) {
      data2[i] = data[i + midpoint];
    }

    return (data1, data2);
  }

  /**
   * @dev computes the total tokens staked for an address
   * @param addr checks against this address
   * @return the amount of the tokens staked for the address
   */
  function totalStakedFor(address addr) external view returns (uint256) {
    StakeStore[] memory lists = HEXData(targetContract).stakeLists[addr];
    uint256 amount = 0;
    for (uint256 i = 0; i < lists.length; i += 1) {
      amount = amount.add(lists[i].stakedHearts);
    }
    Stake[] memory userStakes = stakes[addr];
    for (i = 0; i < userStakes.length; i += 1) {
      if (!userStakes[i].unstaked) {
        amount = amount.add(userStakes[i].amount);
      }
    }
    return amount;
  }
  /**
   * @dev computes the total tokens staked for the sender
   * @return the amount of the tokens staked for the sender
   */
  function totalStaked() external view returns (uint256) {
    return totalStakedFor(msg.sender);
  }
  /**
   * @dev returns the targeted contract
   * @return the target contract address
   */
  function token() external view returns (address) {
    return targetContract;
  }
  /**
   * @dev check whether or not we support history. False is used because HEX does not support it in the way that others may expect, using a day based system rather than block as specified.
   * @return false always
   */
  function supportsHistory() external pure returns (bool) {
    return false;
  }

  /**
   * @dev checks for the last stake
   * @param addr which address to check for
   */
  function lastStakedFor(address addr) external view returns (uint256) {
    StakeStore[] memory lists = HEXData(targetContract).stakeLists[addr];
    Stake[] memory userStakes = stakes[addr];
    uint256 userStakesLength = userStakes.length;
    uint256 listsLength = lists.length;
    if (listsLength > 0 || userStakesLength > 0) {
      if (userStakesLength == 0) {
        return lists[listsLength - 1].lockedDay;
      } else if (listsLength == 0) {
        return userStakes[userStakesLength - 1].lockedDay;
      } else {
        Stake memory lastUserStake = userStakes[userStakesLength - 1];
        uint256 listLockedDay = lists[listsLength - 1].lockedDay;
        if (lastUserStake.lockedDay > listLockedDay) {
          return lastUserStake.lockedDay;
        }
        return listLockedDay;
      }
    } else {
      return 0;
    }
    return lists[lists.length - 1].lockedDay;
  }

  function totalStakedForAt(address addr, uint256 _targetDay) external view returns (uint256) {
    uint16 targetDay = uint16(_targetDay);
    StakeStore[] memory lists = HEXData(targetContract).stakeLists[addr];
    uint256 total = 0;
    for (uint256 i = 0; i < lists.length; i += 1) {
      StakeStore memory store = lists[i];
      if (store.lockedDay <= targetDay && targetDay < store.unlockedDay) {
        total = total.add(store.stakedHearts);
      }
    }
    Stake[] memory userStakes = stakes[addr];
    for (i = 0; i < userStakes.length; i += 1) {
      Stake memory userStake = userStakes[i];
      if (userStake.lockedDay <= targetDay && targetDay < userStake.unlockedDay) {
        total = total.add(userStake.amount);
      }
    }
    return total;
  }

  function totalStakedAt(uint256 blockNumber) external view returns (uint256) {
    require(false, "HexSimpleStaking: TOTAL_STAKED_AT_NOT_SUPPORTED");
  }
}

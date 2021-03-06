//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import './IMyStaking.sol';

contract MyStaking is IMyStaking {
  using SafeERC20 for IERC20;

  IERC20 rewardTokens;
  IERC20 lPTokens;

  // in second
  uint public override rewardPeriod;
  // in second
  uint public override lockPeriod;
  uint256 public override rewardProcents;

  /**
   * @dev Record about user's staking.
   * amount is total amount of staked tokens
   * frozen_amount is of frozen tokens
   * start_lock_period beginning of lock period
   * start_reward_period beginning of reward period
   */
  struct Stake {
    uint256 amount;
    uint256 frozen_amount;
    uint start_lock_period;
    uint start_reward_period;
  }

  mapping(address => Stake) public override stakes;

  /**
   * @dev constructor
   * @param _uniswap_contract_address of uniswap contract.
   * @param _erc20_reward_contract_address address of tokens for reward.
   * @param _reward_period.
   * @param _lock_period.
   * @param _reward_procents.
   */
  constructor(address _uniswap_contract_address,
              address _erc20_reward_contract_address,
              uint _reward_period,
              uint _lock_period,
              uint256 _reward_procents
              ) {
    require(_uniswap_contract_address != address(0),
      "Uniswap contract address can not be zero");
    require(_erc20_reward_contract_address != address(0),
      "Reward tokens contract address can not be zero");
    require(_reward_period != 0, "Reward period can not be zero");
    rewardTokens = IERC20(_erc20_reward_contract_address);
    lPTokens = IERC20(_uniswap_contract_address);
    rewardPeriod = _reward_period * 1 days;
    lockPeriod = _lock_period * 1 days;
    rewardProcents = _reward_procents;
  }

  // See IMyStaking-stake
  function stake(uint256 _amount) public virtual override {
    uint _now_ = block.timestamp;
    Stake storage st = stakes[msg.sender];
    require(_now_ >=  st.start_lock_period + lockPeriod,
      "You cannot stake in lock period");
    if (st.amount != 0) {
      _claim(msg.sender, _now_);
    } else {
      st.start_reward_period = _now_;
    }
    st.frozen_amount = _amount;
    st.amount += _amount;
    st.start_lock_period = _now_;
    lPTokens.safeTransferFrom(msg.sender, address(this), _amount);
    emit StakeDone(msg.sender, _amount);
  }

  // See IMyStaking-claim
  function claim() public virtual override {
    uint _now_ = block.timestamp;
    Stake storage st = stakes[msg.sender];
    uint reward_times = (_now_ - st.start_reward_period) / (rewardPeriod);
    require(reward_times != 0, "Nothing to claim now");
    uint256 reward = st.amount * rewardProcents * reward_times / 100;
    st.start_reward_period = _now_- (_now_ - st.start_reward_period) % rewardPeriod;
    rewardTokens.safeTransfer(msg.sender, reward);
    emit Claim(msg.sender, reward);
  }

  /**
   * @dev The function is called when additional stake or unstake is made.
   * @param _sender address to transfer.
   * @param _now_ syncronize new lock and reward periods.
   */
  function _claim(address _sender, uint _now_) private {
    uint reward_times = (_now_ - stakes[msg.sender].start_reward_period) / (rewardPeriod);
    if (reward_times != 0) {
      uint256 reward = stakes[msg.sender].amount * rewardProcents * reward_times / 100;
      stakes[msg.sender].start_reward_period =
        _now_- (_now_ - stakes[msg.sender].start_reward_period) % rewardPeriod;
      rewardTokens.safeTransfer(_sender, reward);
      emit Claim(_sender, reward);
    }
  }

  // See IMyStaking-unstake
  function unstake(uint256 _amount) public virtual override {
    uint _now_ = block.timestamp;
    Stake storage st = stakes[msg.sender];
    if (_now_ <= st.start_lock_period + lockPeriod) {
      require(st.amount - st.frozen_amount  >= _amount,
        "Amount of tokens exceeds available amount");
    } else {
      require(st.amount >= _amount,
        "Amount of tokens exceeds staked amount");
    }
    _claim(msg.sender, _now_);
    st.amount -= _amount;
    lPTokens.safeTransfer(msg.sender, _amount);
    emit Unstake(msg.sender, _amount);
  }
}

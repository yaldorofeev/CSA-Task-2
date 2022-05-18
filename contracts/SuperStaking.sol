//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract SuperStaking {

    /* using SafeERC20 for IERC20; */

    /* SuperToken rewardTokens;
    IUniswapV2ERC20 lPTokens; */

    IERC20 rewardTokens;
    IERC20 lPTokens;

    uint public reward_period_minutes;
    uint public lock_period_minutes;
    uint256 public reward_procents;
    address public owner;

    /* UniswapV2Factory router; */

    struct Stake {
      uint256 stakeId;
      uint256 amount;
      uint start_time;
    }

    struct Stake_account {
      Stake[] stakes;
      uint256 total_amount;
      uint256 total_reward;
    }

    mapping(address => Stake_account) private stakeAccounts;

    constructor(address _uniswap_contract_address,
                address _erc20_reward_contract_address,
                uint _reward_period_minutes,
                uint _lock_period_minutes,
                uint256 _reward_procents
                ) {
      require(address(_uniswap_contract_address) != address(0),
      "Contract address can not be zero");
      require(address(_erc20_reward_contract_address) != address(0),
      "Contract address can not be zero");
      require(_reward_period_minutes != 0, "Reward period can not be zero");
      rewardTokens = IERC20(_erc20_reward_contract_address);
      lPTokens = IERC20(_uniswap_contract_address);
      reward_period_minutes = _reward_period_minutes;
      lock_period_minutes = _lock_period_minutes;
      reward_procents = _reward_procents;
    }

    /* function stake(uint256 _amount) public {
      require(lPTokens.balanceOf(msg.sender) >= _amount, "Not enaught tokens");
      lPTokens.approve(address(this), _amount);
      lPTokens.transferFrom(msg.sender, address(this), _amount);
      Stake_account storage sk = stakeAccounts[msg.sender];
      if (sk.stakes.length == 0) {
        sk.total_reward = 0;
      }
      sk.total_amount += _amount;
      Stake memory st = Stake(
        {
          stakeId: sk.stakes.length,
          amount: _amount,
          start_time: block.timestamp
        }
      );
      sk.stakes.push(st);
    }

    function claim() public {
      uint _now_ = block.timestamp;
      uint256 total_reward;
      Stake_account storage sk = stakeAccounts[msg.sender];
      for (uint i = 0; i < sk.stakes.length; i++){
        uint reward_times = (_now_ - sk.stakes[i].start_time) / (reward_period_minutes * 1 minutes);
        uint256 reward = sk.stakes[i].amount * reward_procents * reward_times / 100;
        total_reward += reward;
        sk.stakes[i].start_time = _now_- (_now_ - sk.stakes[i].start_time) % (reward_period_minutes * 1 minutes);
      }
      require(rewardTokens.balanceOf(address(this)) >= total_reward, "Sorry, but it is not enougth tokens on the contract");
      rewardTokens.transfer(msg.sender, total_reward);
    }

    function claimOneStake(uint256 stakeId) public {
      uint _now_ = block.timestamp;
      Stake_account storage sk = stakeAccounts[msg.sender];
      uint reward_times = (_now_ - sk.stakes[stakeId].start_time) / (reward_period_minutes * 1 minutes);
      uint256 reward = sk.stakes[stakeId].amount * reward_procents * reward_times / 100;
      sk.stakes[stakeId].start_time = _now_- (_now_ - sk.stakes[stakeId].start_time) % (reward_period_minutes * 1 minutes);
      require(rewardTokens.balanceOf(address(this)) >= reward, "Sorry, but it is not enougth tokens on the contract");
      rewardTokens.transfer(msg.sender, reward);
    }

    function unstake(uint256 stakeId, uint256 _amount) public {
      uint _now_ = block.timestamp;
      Stake_account storage sk = stakeAccounts[msg.sender];
      require(stakeId < sk.stakes.length, "Invalid ID of stake");
      require(_now_ >=  sk.stakes[stakeId].start_time + lock_period_minutes * 1 minutes, "Its not time to unstake");
      require(sk.stakes[stakeId].amount >= _amount, "Amount of tokens exceeds staked amount");
      claimOneStake(stakeId);
      sk.stakes[stakeId].amount -= _amount;
      lPTokens.transfer(msg.sender, _amount);
      sk.total_amount -= _amount;
    } */
}

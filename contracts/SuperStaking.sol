//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/* import '@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2ERC20.sol'; */
import '@uniswap/v2-core/contracts/UniswapV2ERC20.sol';

contract SuperStaking is Ownable {

    using SafeERC20 for IERC20;

    IERC20 public forRewardTokens;
    UniswapV2ERC20 LPTokens;

    uint public reward_peiod_minuts;
    uint public lock_period;
    uint256 public reward_procents;
    address public owner;

    /* UniswapV2Factory router; */

    struct Stake {
      uint256 amount;
      uint start_time;
    }

    struct Stake_account {
      Stake[] stakes;
      uint256 total_amount;
      uint256 total_reward;
    }

    mapping(address => Stake_account) private stakeAccounts;

    constructor(IERC20 _erc20_reward_contract_address,
                uint _reward_peiod_minuts,
                uint _lock_period,
                address _uniswap_factory
                ) {
      require(address(IERC20 _erc20_reward_contract_address) != address(0),
      "Contract address can not be zero");
      require(reward_peiod_minuts != 0, "Reward period can not be zero");
      erc20Reward = _erc20_reward_contract_address;
      owner = msg.sender;
    }

    function stake(uint256 amount) public {
      require(LPTokens.balanceOf(msg.sender) >= amount, "Not enaught tokens");
      LPTokens.approve(address(this), amount);
      LPTokens.transferFrom(msg.sender, address(this), amount);
      Stake st = Stake {
        amount: amount;
        start_time: block.timestamp;
      }
      Stake_account storage sk = stakeAccounts[msg.sender];
      if (sk.stakes.length == 0) {
        sk.total_reward = 0;
      }
      sk.total_amount += amount;
      sk.stakes.push(st);
    }



    function claim() public {
      uint now = block.timestamp;
      uint256 total_reward;
      Stake_account storage sk = stakeAccounts[msg.sender];
      for (uint i = 0; i < sk.stakes.length; i++){
        uint reward_times = (now - sk.stakes[i]["start_time"]) / (reward_peiod_minuts * 1 minuts);
        uint256 reward = sk.stakes[i]["amount"] * reward_procents * reward_times / 100;
        total_reward += reward;
        sk.stakes[i]["start_time"] = now - (now - sk.stakes[i]["start_time"]) % (reward_peiod_minuts * 1 minuts)
      }
      
    }

    function unstake(uint256 amount) public {

    }

}

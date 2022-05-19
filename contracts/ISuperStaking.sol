//SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.0;

interface ISuperToken {
  event StakeDone(address indexed _from, uint _value);
  event Claim(address indexed _to, uint _value);
  event Unstake(address indexed _to, uint _value);

  function reward_period_minutes() external view returns (uint);
  function lock_period_minutes() external view returns (uint);
  function reward_procents() external view returns (uint256);
  /* function getStakerState() external view returns (uint256, Stake[] memory); */

  function stake(uint256 _amount) external;
  function claim() external;
  function claimOneStake(uint256 _stakeId) external;
  function unstake(uint256 _stakeId, uint256 _amount) external;
}

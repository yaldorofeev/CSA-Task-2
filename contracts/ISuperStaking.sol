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

  /**
   * @dev Moves `_amount` lp tokens from the caller's account to this contract.
   *
   * Emits a {StakeDone} event.
   */
  function stake(uint256 _amount) external;

  /**
   * @dev Calculate rewards of each user's stake and transfer resulted amount
   * of tokens to user. In each stake's timestamp for reward estimation is updated.
   *
   * Emits a {Claim} event.
   */
  function claim() external;
  function claimOneStake(uint256 _stakeId) external;
  function unstake(uint256 _stakeId, uint256 _amount) external;
}

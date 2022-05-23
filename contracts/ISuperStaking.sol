//SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.0;

interface ISuperToken {

  /**
   * @dev Emitted when stake done.
   *
   * `_from` is the account that made this stake.
   * '__value' is amount of lp tokens staked.
   */
  event StakeDone(address indexed _from, uint _value);

  /**
   * @dev Emitted when claim done.
   *
   * `_to` is the account that made this claim reward.
   * '__value' is amount of reward tokens transfered.
   */
  event Claim(address indexed _to, uint _value);

  /**
   * @dev Emitted when unstake done.
   *
   * `_to` is the account that made this unstake.
   * '__value' is amount of lp tokens to return.
   */
  event Unstake(address indexed _to, uint _value);

  /**
   * @dev Return the period of reward in minuts.
   */
  function reward_period_minutes() external view returns (uint);

  /**
   * @dev Return the period of lock of lp tokens in minuts.
   */
  function lock_period_minutes() external view returns (uint);

  /**
   * @dev Return the reward procents.
   */
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

  /**
   * @dev Calculate rewards of each user's stake and transfer resulted amount
   * of tokens to user. In each stake's timestamp for reward estimation is updated.
   *
   * Emits a {Claim} event.
   */
  function claimOneStake(uint256 _stakeId) external;

  /**
   * @dev Unstake lp tokens. Function become available after lock period expire.
   *
   * Emits a {Unstake} event.
   */
  function unstake(uint256 _stakeId, uint256 _amount) external;
}

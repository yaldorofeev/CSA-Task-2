One user can make any number of stakes at any time in this contract. For this reasons claimOneStake() and getStakerState() functions was added.
To avoid confusions with claims of rewards user can not add tokens to already created stake.
Instead of this he can create a new stake.
The claim() function get rewards from all stakes of user.
The claimOneStake() function get reward from only one stake by its id.
The getStakerState() function get total amount of stakes and array of information about all user's stakes.

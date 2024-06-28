// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title STAKING CONTRACT
 * @author MOHAMMAD RAAZY
 * @notice this contract is not test it yet, will be test it in the future
 */

import { IERC20 } from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract Staking {
    // ---------------------- ERRORS --------------------------
    error Staking_BalanceShouldBeMoreThanAmount();
    error Staking_ZeroAddress();
    
    // --------------------- STATE VARIABLES -------------------------
    uint256 private constant DECIMALS = 1e18;
    uint256 private constant USDT_DECIMALS = 1e6;
    // uint256 private rewardPercentage = 200; // 200%
    uint256 private s_rewardPerToken = 1_000 wei; // equal to 0.1 usdt 

    IERC20 private s_stakeToken;
    IERC20 private s_rewardToken;

    // ----------------------- MAPPINGS -----------------------------
    mapping(address staker => StakeInfo) private s_staker;

    // ----------------------- STRUCT -----------------------------
    struct StakeInfo {
        address staker;
        uint256 duration;
        uint256 amount;
        uint256 totalRewards;
    }

    constructor(address stakeToken_, address rewardToken_) {
        s_stakeToken = IERC20(stakeToken_);
        s_rewardToken = IERC20(rewardToken_);
    }

    // ------------------------------ MODIFIERS ----------------------------
    modifier NotZeroAddr() {
       if(msg.sender == address(0)) revert Staking_ZeroAddress();
        _;
    }

    // ------------------------------ EXTERNAL & INTERNAL FUNCTIONS -----------------------
    /**
     * @dev calculate the staker rewards
     * @param amount -> amount to stake
     * @param duration_ => how long they want to stake
     */
    // totalSupply / (amount )
    function _calculateReward(uint256 amount, uint256 duration_) internal view returns(uint256 rewards) {
        uint256 reward = (amount * DECIMALS ) * USDT_DECIMALS;
        return reward;
    }

     /**@dev stake the token
     * @param amount -> amount to stake
     * @param duration_ => how long they want to stake
     */
    function stake(uint256 amount, uint256 duration_) external NotZeroAddr {
        // user send amount to stake to this contract
        // user set how long they want to stake
        // 
        uint256 balance = s_stakeToken.balanceOf(msg.sender);

        if(balance <= amount) {
            revert Staking_BalanceShouldBeMoreThanAmount();
        }

        s_stakeToken.transferFrom(msg.sender, address(this), amount);
        uint256 _totalRewards = _calculateReward(amount, duration_);
        s_staker[msg.sender] = StakeInfo({ staker: msg.sender, duration: duration_, amount: amount, totalRewards: _totalRewards });

    }

     function unStake() external {
        
    }

    function claimReward() external {

    }

    function getUserRewards(address staker_) external returns(uint256 rewards) {
        return s_staker[staker_].rewards;
    }

    receive() external payable {}

}




// This is what is needed 

// A backend system to handle the Spice Distribution for Users Interacting on our Project . Interactions are kept track with RP (points ) and Registrations needs to be Indexed  from the txs done on the Account Creation Contracts (there are multiple of those) , then distribute the Project Spice to the Indexed Users.

// 1: Index & Keep track of Users Registered for Rampage.
// 2: Distribute x% of Total Project Spice on every y time interval
// 3: The Past Distributions are tracked by the API , so also need to verify on the distribution function loop that the transfers are not being double sent or failing (if api call fails then it should handle it to not fail)
// 4: ENV & Variable Secuirity from Injection attacks & should have Limiters set on calls so it matches bob's apis rate limits.


// Budget - 500$ + 2 SKIBIDI NFTs for Completion .

// Time frame - 1 week at most , earlier the better.
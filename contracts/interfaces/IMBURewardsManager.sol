// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

interface IMBURewardsManager {

    function getReward(address _owner) view external returns (uint256 _amount);

    function addReward(uint256 _amount, address _owner) external  returns (uint256 _balance);
    
    function addPenalty(uint256 _amount, address _owner) external returns (uint256 _balance);
}
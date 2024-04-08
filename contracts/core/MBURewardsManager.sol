// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IMBURegister.sol";
import "../interfaces/IMBUVersion.sol";
import "../interfaces/IMBURewardsManager.sol";

contract MBURewardsManager is IMBURewardsManager, IMBUVersion { 

    uint256 constant version = 1; 
    string constant name = "RESERVED_REWARDS_MANAGER";

    modifier mbuOnly() { 
        require(register.isRegistered(msg.sender), " MBU only ");
        _;
    }

    mapping(address=>uint256) rewardByOwner; 

    IMBURegister register; 

    constructor(IMBURegister _register){
        register = _register; 
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getReward(address _owner) view external returns (uint256 _amount){
        return rewardByOwner[_owner];
    }

    function addReward(uint256 _amount, address _owner) external returns (uint256 _balance){
        _balance = rewardByOwner[_owner] += _amount;
        return _balance; 
    }
}
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IMBURegister.sol";
import "../interfaces/IMBUVersion.sol";
import "../interfaces/IMBURewardsManager.sol";
import "../interfaces/IMBUToken.sol";

contract MBURewardsManager is IMBURewardsManager, IMBUVersion { 

    uint256 constant version = 1; 
    string constant name = "RESERVED_REWARDS_MANAGER";

    string constant MBU_TOKEN = "RESERVED_MBU_TOKEN";

    modifier mbuOnly() { 
        require(register.isRegistered(msg.sender), " MBU only ");
        _;
    }

    mapping(address=>uint256) rewardByOwner; 

    IMBURegister register; 
    IMBUToken token; 

    constructor(address _register){
        register = IMBURegister(_register); 
        initialize();
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

    function addReward(uint256 _amount, address _owner) external mbuOnly returns (uint256 _balance){
        _balance = rewardByOwner[_owner] += _amount;
        return _balance; 
    }

    function addPenalty(uint256 _amount, address _owner) external mbuOnly returns (uint256 _balance) {
        if(rewardByOwner[_owner]> 0){
            if(rewardByOwner[_owner] > _amount){
                _balance = rewardByOwner[_owner] -= _amount;
            }
            else {
                _balance = 0; 
            }
        }
        else {
            _balance = 0; 
        }
    }

    function claimReward() external returns (uint256 _payout, uint256 _balance) {
        _payout = rewardByOwner[msg.sender]; 
        _balance = rewardByOwner[msg.sender] = 0;
        token.mint(_payout, msg.sender);
        return (_payout, _balance);
    }

    //============================== INTERNAL =====================================

    function initialize() internal returns (bool _initialized) {
        token = IMBUToken(register.getAddress(MBU_TOKEN));
        return true; 
    }
}
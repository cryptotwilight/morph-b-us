// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IMBUFeedManager.sol";
import "../interfaces/IMBURegister.sol";
import "../interfaces/IMBUVersion.sol";
import "../interfaces/IMBURewardsManager.sol";

import {Trim, Share} from "../interfaces/IMBUStructs.sol";


contract MBUFeedManager {

    uint256 constant version = 3; 
    
    string constant name = "RESERVED_FEED_MANAGER";

    string constant MBU_ADMIN = "RESERVED_MBU_ADMIN";
    string constant MBU_REGISTER = "RESERVED_MBU_REGISTER";
    string constant REWARD_MANAGER = "RESERVED_REWARDS_MANAGER";

    modifier adminOnly() { 
        require(register.getAddress(MBU_ADMIN) == msg.sender, " admin only ");
        _;
    }

    modifier mbuOnly() { 
        require(register.isRegistered(msg.sender), " MBU only ");
        _;
    }

    IMBURegister register;
    IMBURewardsManager rewards; 

    uint256 Share_Reward = 1 * 1e15; 

    uint256 index;  
    mapping(address=>uint256[]) feedByOwner;
    mapping(uint256=>Share) shareById; 
    uint256 [] shares; 
    mapping(uint256=>Trim) trimById; 


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

    function getFeed(address _feedOwner) view external returns (uint256 [] memory _contentIds){
        return feedByOwner[_feedOwner];
    }

    function trimFeed(uint256 [] memory _contentIds, address _feedOwner) external mbuOnly returns (uint256 _trimId){
        _trimId = getIndex(); 
        trimById[_trimId] = Trim({
                                    id : _trimId, 
                                    oldIds : feedByOwner[_feedOwner],
                                    newIds : _contentIds,
                                    date : block.timestamp,
                                    trimmer : msg.sender
                                });
        feedByOwner[_feedOwner] = _contentIds;
        return _trimId; 
    }

    function addToFeed(uint256 _contentId, address _feedOwner) external mbuOnly returns (bool _added ){
        feedByOwner[_feedOwner].push(_contentId);
        return true; 
    }
    
    function getAllShares() view adminOnly external returns (uint256 [] memory _shares) {
        return shares;
    }

    function share(uint256 _contentId, address [] memory _users, address _sharer) external returns (uint256 _shareId){
        for(uint256 x = 0; x < _users.length; x++){
            feedByOwner[_users[x]].push(_contentId);
        }
        uint256 reward_ = Share_Reward * _users.length; 

        rewards.addReward(reward_, _sharer);

        _shareId = getIndex(); 
        shareById[_shareId] = Share({
                                        id : _shareId,
                                        contentId : _contentId,
                                        users : _users,  
                                        date : block.timestamp, 
                                        sharer : _sharer 
                                    });
        return _shareId; 
    }

    function getShare(uint256 _shareId) view external returns (Share memory _share){
        return shareById[_shareId];
    }

    function notifyChangeOfAddress() external returns (bool _acknowledged){
        register = IMBURegister(register.getAddress(MBU_REGISTER));
        return true; 
    }

    //==================================== INTERNAL ==============================

    function initialize() internal returns (bool _initialized) {
        rewards = IMBURewardsManager(register.getAddress(REWARD_MANAGER));
        return true; 
    }

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
        return _index; 
    }
}
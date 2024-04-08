// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IMBUVersion.sol";
import "../interfaces/IMBURegister.sol";
import "../interfaces/IMBUFollowsManager.sol";
import "../interfaces/IMBUNameManager.sol";

import {Mute} from "../interfaces/IMBUStructs.sol";

contract MBUFollowsManager is IMBUFollowsManager, IMBUVersion { 

    uint256 constant version = 1; 
    string constant name = "RESERVED_FOLLOWS_MANAGER";

    modifier mbuOnly() { 
        require(register.isRegistered(msg.sender), " MBU only ");
        _;
    }

    IMBURegister register; 
    uint256 index; 
    IMBUNameManager names; 
    mapping(address=>mapping(string=>bool)) muted; 
    mapping(uint256=>Mute) muteById; 
    mapping(uint256=>Follow) followById; 
    mapping(address=>uint256[]) followingByOwner;
    mapping(address=>uint256[]) followsByFollower;
    mapping(address=>mapping(address=>uint256)) followIdByFollowerByOwner;

    constructor(IMBURegister _register){
        register = _register; 
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getFollows(address _follower) view external returns (uint256 [] memory followIds){
        return followsByFollower[_follower];
    }

    function getFollowingCount(address _followingOwner) view external returns (uint256 _count){
        return followsByFollower[_followingOwner].length;
    }

    function getFollow(uint256 _followId) view external returns (Follow memory _follow){
        return followById[_followId];
    }

    function follow(string memory _name, address _follower) external returns (uint256 _followId){
        address user_ = names.getMorphAddress(_name);
        _followId = getIndex();
        followById[_followId] = Follow({
            id : _followId,
            followedUser : user_,
            follower : _follower,
            date : block.timestamp

        });
        followingByOwner[user_].push(_followId);
        followsByFollower[_follower].push(_followId);
        followIdByFollowerByOwner[user_][_follower] = _followId;
        return _followId;
    }

    function unfollow(string memory _name, address _follower) external returns (bool _unfollowed){
        address user_ = names.getMorphAddress(_name);
        uint256 followId_ = followIdByFollowerByOwner[user_][_follower];
        delete followIdByFollowerByOwner[user_][_follower];
        delete followById[followId_];
        followingByOwner[user_] = remove(followId_, followingByOwner[user_]);
        followsByFollower[_follower] = remove(followId_, followsByFollower[_follower]);
        return true; 
    }

    function isMuted(string memory _name, address _followingOwner) view external returns (bool _isMuted){
        return muted[_followingOwner][_name];
    }

    function mute(string memory _name, address _followingOwner) external mbuOnly returns (uint256 _muteId){
        muted[_followingOwner][_name] = true;
        _muteId = getIndex();
        muteById[_muteId] = Mute({
                                    id: _muteId,  
                                    user: names.getMorphAddress(_name), 
                                    date : block.timestamp 
                                });
        return _muteId; 
    }

    function unmute(string memory _name, address _followingOwner) external mbuOnly returns (bool _unmuted){
        muted[_followingOwner][_name] = false;
        return true; 
    }

        //==================================== INTERNAL ==============================

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
    return _index; 
    }

    function remove(uint256 c, uint256 [] memory a) internal returns (uint256 [] memory b) {

    }
} 
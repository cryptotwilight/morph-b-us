// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IMBURegister.sol";
import "../interfaces/IMorphBUs.sol";
import "../interfaces/IMBUNameManager.sol";
import "../interfaces/IMBUContentManager.sol";
import "../interfaces/IMBUMessageManager.sol";
import "../interfaces/IMBUFeedManager.sol";
import "../interfaces/IMBUFollowsManager.sol";
import "../interfaces/IMBURewardsManager.sol";


contract MorphBUs is IMorphBUs { 

    uint256 constant version = 2; 
    string constant name = "RESERVED_MORPH_B_US_CORE";

    string constant MBU_ADMIN = "RESERVED_MBU_ADMIN";

    modifier adminOnly() { 
        require(register.getAddress(MBU_ADMIN) == msg.sender, "MBU admin only ");
        _; 
    }
    string constant MBU_REGISTER    = "RESERVED_MBU_REGISTER";
    string constant NAME_MANAGER    = "RESERVED_NAME_MANAGER";
    string constant CONTENT_MANAGER = "RESERVED_CONTENT_MANAGER";
    string constant MESSAGE_MANAGER = "RESERVED_MESSAGE_MANAGER";
    string constant FEED_MANAGER    = "RESERVED_FEED_MANAGER";
    string constant FOLLOWS_MANAGER = "RESERVED_FOLLOWS_MANAGER";
    string constant REWARDS_MANAGER = "RESERVED_REWARDS_MANAGER";

    IMBURegister register; 
    IMBUNameManager names;
    IMBUContentManager contentManager; 
    IMBUMessageManager messages; 
    IMBUFeedManager feed; 
    IMBUFollowsManager follows; 
    IMBURewardsManager rewards; 

    constructor(IMBURegister _register) {
        register = _register;
        initialize(); 
    }
    
    function isMorphNameAvailable(string memory _name) view external returns (bool _isAvailable){
        return names.isMorphNameAvailable(_name);
    } 

    function setMorphName(string memory _name, string memory _ipfsProfile) external returns (bool _set){
        return names.setMorphName(_name, msg.sender, _ipfsProfile);
    }

    function post(Content memory _content) external returns (uint256 _contentId){
        _contentId = contentManager.post(_content); 
        feed.addToFeed(_contentId, msg.sender);
        return _contentId; 
    }

    function share(uint256 _contentId, address [] memory _users) external returns (uint256 _shareId){
        return feed.share( _contentId, _users, msg.sender);
    }

    function getShare(uint256 _shareId) view external returns (Share memory _share){
        return feed.getShare(_shareId);
    }

    function getReward() view external returns (uint256 _rewardAmount){
        return rewards.getReward(msg.sender);
    }

    function getFeed() view external returns (uint256 [] memory _contentIds){
        return feed.getFeed(msg.sender);
    }

    function trimFeed(uint256 [] memory _contentIds) external returns (uint256 _trimId){
        return feed.trimFeed(_contentIds, msg.sender);
    }

    function getContent(uint256 _contentId) view external returns (Content memory _content){
        return contentManager.getContent(_contentId);
    }

    function getFollowingCount() view external returns (uint256 _count){
        return follows.getFollowingCount(msg.sender); 
    }

    function getFollows() view external returns (uint256 [] memory _followIds){
        return follows.getFollows(msg.sender); 
    }

    function getFollow(uint256 _followId) view external returns (Follow memory _follow){
        return follows.getFollow(_followId);
    }

    function follow(string memory _name) external returns (uint256 _followId){
        return follows.follow(_name, msg.sender);
    }

    function unfollow(string memory _name) external returns (bool _unfollowed){
        return follows.unfollow(_name, msg.sender);
    }

    function isMuted(string memory _name) view external returns (bool _isMuted){
        return follows.isMuted(_name, msg.sender);
    }

    function mute(string memory _name) external returns (uint256 _muteId){
        return follows.mute(_name, msg.sender);
    }

    function unmute(string memory _name) external returns (bool _unmuted){
        return follows.unmute(_name, msg.sender);
    }

    function getMessages() view external returns (uint256 [] memory messageIds){
        return messages.getMessages(msg.sender);
    }

    function getMessage(uint256 _messageId) view external returns (Message memory _message){
        return messages.getMessage(_messageId);
    }

    function sendMessage(Message memory _message) external returns (uint256 _messageId){
        return messages.sendMessage(_message);
    }

    function trimMessages(uint256 [] memory _messageIds) external returns (bool _trimmed){
        return messages.trimMessages(_messageIds);
    }

    function notifyChangeOfAddress() external adminOnly returns (bool _acknowledged) {
        return initialize();
    }

    //============================== INITIALIZE =================================================

    function initialize() internal returns (bool _initialized) {
        register = IMBURegister(register.getAddress(MBU_REGISTER));
        names = IMBUNameManager(register.getAddress(NAME_MANAGER));
        contentManager = IMBUContentManager(register.getAddress(CONTENT_MANAGER)); 
        messages = IMBUMessageManager(register.getAddress(MESSAGE_MANAGER)); 
        feed = IMBUFeedManager(register.getAddress(FEED_MANAGER)); 
        follows = IMBUFollowsManager(register.getAddress(FOLLOWS_MANAGER)); 
        return true; 
    }

}
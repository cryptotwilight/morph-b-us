// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./IMBUStructs.sol";

interface IMorphBUs { 

    function isMorphNameAvailable(string memory _name) view external returns (bool _isAvailable); 

    function setMorphName(string memory _name) external returns (uint256 _id);

    function post(Content memory _content) external returns (uint256 _contentId);
    
    function getContent(uint256 _contentId) view external returns (Content memory _content);

    function share(uint256 _contentId, uint256 [] memory _ids) external returns (uint256 _shareId);

    function getShare(uint256 _shareId) view external returns (Share memory _share);

    function getReward() external returns (uint256 _rewardAmount);

    function getFeed() view external returns (uint256 [] memory _contentIds);

    function trimFeed(uint256 [] memory _contentIds) external returns (uint256 _trimId);


    function getFollows() view external returns (uint256 [] memory _followIds);

    function getFollow(uint256 _followId) view external returns (Follow memory _follow);

    function follow(string memory _name) external returns (uint256 _followId);

    function unfollow(string memory _name) external returns (bool _unfollowed);

    function isMuted(string memory _name) view external returns (bool _isMuted);

    function mute(string memory _name) external returns (uint256 _muteId);

    function unmute(string memory _name) external returns (bool _unmuted);

    function getMessages() view external returns (uint256 [] memory messageIds);

    function getMessage(uint256 _messageId) view external returns (Message memory _message);

    function sendMessage(Message memory _message) external returns (uint256 _messageId);

    function trimMessages(uint256 [] memory _messageIds) external returns (bool _trimmed);
}
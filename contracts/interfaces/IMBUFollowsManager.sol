// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {Follow} from "./IMBUStructs.sol";

interface IMBUFollowsManager { 

    function getFollows(address _followsOwner) view external returns (uint256 [] memory _followIds);

    function getFollowingCount(address _followingOwner) view external returns (uint256 _count);

    function getFollow(uint256 _followId) view external returns (Follow memory _follow);

    function follow(string memory _name, address _followsOwner) external returns (uint256 _followId);

    function unfollow(string memory _name, address _followsOwner) external returns (bool _unfollowed);

    function isMuted(string memory _name, address _followingOwner) view external returns (bool _isMuted);

    function mute(string memory _name, address _followingOwner) external returns (uint256 _muteId);

    function unmute(string memory _name, address _followingOwner) external returns (bool _unmuted);
}
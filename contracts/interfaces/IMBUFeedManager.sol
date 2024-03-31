// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {Share} from "../interfaces/IMBUStructs.sol";

interface IMBUFeedManager { 

    function getFeed(address _feedOwner) view external returns (uint256 [] memory _contentIds);

    function trimFeed(uint256 [] memory _contentIds, address _feedOwner) external returns (uint256 _trimId);

    function addToFeed(uint256 _contentId, address _feedOwner) external returns (bool _added );
    
    function share(uint256 _contentId, uint256 [] memory _ids, address _sharer) external returns (uint256 _shareId);

    function getShare(uint256 _shareId) view external returns (Share memory _share);

}
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {Content} from "../interfaces/IMBUStructs.sol";

interface IMBUContentManager { 

    function post(Content memory _content) external returns (uint256 _contentId);
    
    function getContent(uint256 _contentId) view external returns (Content memory _content);
}
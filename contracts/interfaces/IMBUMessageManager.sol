// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {Message} from "./IMBUStructs.sol";

interface IMBUMessageManager { 

    function getMessages(address _messageRecipient) view external returns (uint256 [] memory messageIds);

    function getMessage(uint256 _messageId) view external returns (Message memory _message);

    function sendMessage(Message memory _message) external returns (uint256 _messageId);

    function trimMessages(uint256 [] memory _messageIds) external returns (bool _trimmed);

}
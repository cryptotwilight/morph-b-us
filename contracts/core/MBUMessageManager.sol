// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IMBUVersion.sol";
import "../interfaces/IMBURegister.sol";
import "../interfaces/IMBUMessageManager.sol";

contract MBUMessageManager is IMBUMessageManager, IMBUVersion {

    uint256 constant version = 2; 
    string constant name = "RESERVED_MESSAGE_MANAGER";

    string constant MBU_ADMIN = "RESERVED_MBU_ADMIN";
    string constant MBU_REGISTER = "RESERVED_MBU_REGISTER";
    
    mapping(address=>uint256[]) messagesByRecipient;
    mapping(address=>uint256[]) sentMessagesBySender; 
    mapping(address=>mapping(address=>uint256[])) messagesByRecipientBySender;
    mapping(uint256=>Message) messageById; 

    modifier adminOnly() { 
        require(register.getAddress(MBU_ADMIN) == msg.sender, "MBU admin only ");
        _; 
    }

    modifier mbuOnly() { 
        require(register.isRegistered(msg.sender), " MBU only ");
        _;
    }

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

    function getMessages(address _messageRecipient) view external returns (uint256 [] memory messageIds){
        return messagesByRecipient[_messageRecipient];
    }

    function getMessage(uint256 _messageId) view external returns (Message memory _message){
        _message = messageById[_messageId];
        require((msg.sender == _message.sender) || (msg.sender == _message.recipient), " MBU conversants only ");
        return _message;
    }

    function sendMessage(Message memory _message) external returns (uint256 _messageId){
        _messageId = getIndex();
        messageById[_messageId] = Message({ 
                                            id : _messageId,  
                                            sender : _message.sender,
                                            recipient : _message.recipient, 
                                            ipfsHash : _message.ipfsHash,
                                            date : block.timestamp
                                        });
        messagesByRecipient[_message.recipient].push(_messageId);
        sentMessagesBySender[_message.sender].push(_messageId);
        messagesByRecipientBySender[_message.recipient][_message.sender].push(_messageId);

        return _messageId;
    }

    function trimMessages(uint256 [] memory _messageIds) external returns (bool _trimmed){
        messagesByRecipient[msg.sender] = _messageIds; 
        return true; 
    }

    function notifyChangeOfAddress() external adminOnly returns (bool _acknowledged) {
        register = IMBURegister(register.getAddress(MBU_REGISTER));
        return true;
    }

    //================================== INTERNAL==================================

    uint256 index; 

    function getIndex() internal returns (uint256 _index){
        _index = index++;
        return _index; 
    }
}
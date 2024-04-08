// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IMBUContentManager.sol";
import "../interfaces/IMBUVersion.sol";
import "../interfaces/IMBURegister.sol";
import "../interfaces/IMBUNameManager.sol";

contract MBUContentManager is IMBUContentManager, IMBUVersion { 

    uint256 constant version = 1; 
    string constant name = "RESERVED_CONTENT_MANAGER";

    string constant NAME_MANAGER = "RESERVED_MBU_NAME_MANAGER";
    string constant MBU_ADMIN = "RESERVED_MBU_ADMIN";
    string constant MBU_REGISTER = "RESERVED_MBU_REGISTER";

    modifier adminOnly() { 
        require(register.getAddress(MBU_ADMIN) == msg.sender, "MBU admin only ");
        _; 
    }

    modifier mbuOnly() { 
        require(register.isRegistered(msg.sender), " MBU only ");
        _;
    }
    modifier mbuUserOnly()  {
        require(register.isRegistered(msg.sender) || names.hasMorphName(msg.sender), " MBU Users Only");
        _;
    }

    IMBURegister register; 
    IMBUNameManager names; 
    
    uint256 index; 
    uint256 [] contentList; 
    mapping(uint256=>Content) contentById; 

    constructor(IMBURegister _register){
        register = _register; 
        names = IMBUNameManager(register.getAddress(NAME_MANAGER));
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function post(Content memory _content) external mbuUserOnly returns (uint256 _contentId){
        _contentId = getIndex(); 
        contentList.push(_contentId);
        contentById[_contentId] = Content({
                                            id : _contentId,  
                                            ipfsHash : _content.ipfsHash, 
                                            author : _content.author, 
                                            authorName : names.getMorphName(_content.author), 
                                            date : block.timestamp  
                                        });

        return _contentId; 
    }
    
    function getContent(uint256 _contentId) view external returns (Content memory _content){
        return contentById[_contentId];
    }

    function notifyChangeOfAddress() external adminOnly returns (bool _acknowledged) {
        register = IMBURegister(register.getAddress(MBU_REGISTER));
        names = IMBUNameManager(register.getAddress(NAME_MANAGER));

        return true;
    }
    //==================================== INTERNAL ==============================

    function getIndex() internal returns (uint256 _index) {
        _index = index++; 
        return _index; 
    }

    
}
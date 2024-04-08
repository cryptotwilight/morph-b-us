// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IMBURegister.sol";
import "../interfaces/IMBUVersion.sol"; 
import "../interfaces/IMBUNameManager.sol";

contract MBUNameManager is IMBUNameManager, IMBUVersion { 

    uint256 constant version = 1; 
    string constant name = "RESERVED_NAME_MANAGER";

    modifier mbuOnly() { 
        require(register.isRegistered(msg.sender), " MBU only ");
        _;
    }

    mapping(string=>bool) knownMorphName;
    mapping(string=>address) addressByMorphName;
    mapping(address=>string) morphNameByAddress;
    mapping(address=>bool) hasMorphNameByAddress;
    mapping(uint256=>address) userById; 
    mapping(address=>uint256) idByUser; 

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

    function isMorphNameAvailable(string memory _name) view external returns (bool _isAvailable){
        return knownMorphName[_name]?false:true;
    }

    function getMorphAddress(string memory _name) view external returns (address _owner){
        return addressByMorphName[_name];
    }

    function getMorphName(address _address) view external returns (string memory _name){
        return morphNameByAddress[_address];
    }

    function hasMorphName(address _address) view external returns (bool _hasMorphName){
        return hasMorphNameByAddress[_address];
    }

    function setMorphName(string memory _name, address _owner) external mbuOnly returns (uint256 _id){
        require(!knownMorphName[_name], "name already set");
        require(!hasMorphNameByAddress[_owner], "has morph name");
        knownMorphName[_name] = true; 
        addressByMorphName[_name] = _owner;
        morphNameByAddress[_owner] = _name;
        hasMorphNameByAddress[_owner] = true;
        _id = getIndex(); 
        userById[_id] = _owner;
        idByUser[_owner] = _id; 
        return _id; 
    }

    //========================================== INTERNAL ============================================

    uint256 index; 

    function getIndex() internal returns (uint256 _index){
        _index = index++;
        return _index; 
    }
}
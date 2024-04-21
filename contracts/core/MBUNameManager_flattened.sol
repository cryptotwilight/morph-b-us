// SPDX-License-Identifier: GPL-3.0
// File: contracts/interfaces/IMBUNameManager.sol



pragma solidity >=0.8.2 <0.9.0;

interface IMBUNameManager {

    function isMorphNameAvailable(string memory _name) view external returns (bool _isAvailable); 

    function setMorphName(string memory _name, address _owner, string memory _profile) external returns (bool _nameSet);

    function updateMorphProfile(string memory _name, string memory _profile) external returns (bool _updated);

    function getMorphAddress(string memory _name) view external returns (address _owner);

    function getMorphName(address _address) view external returns (string memory _name);

    function hasMorphName(address _address) view external returns (bool _hasMorphName);
}
// File: contracts/interfaces/IMBUVersion.sol



pragma solidity >=0.8.2 <0.9.0;

interface IMBUVersion {

    function getName() view external returns (string memory _name);

    function getVersion() view external returns (uint256 _version);
    
}
// File: contracts/interfaces/IMBURegister.sol



pragma solidity >=0.8.2 <0.9.0;

interface IMBURegister { 

    function getAddress(string memory _name) view external returns (address _address);

    function getName(address _address) view external returns (string memory _name);

    function isRegistered(address _address) view external returns (bool _isRegistered);
}
// File: contracts/core/MBUNameManager.sol



pragma solidity >=0.8.2 <0.9.0;




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
    mapping(address=>string) profileByUser; 

    IMBURegister register; 

    constructor( address _register){
        register = IMBURegister(_register); 
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

    function setMorphName(string memory _name, address _owner, string memory _profile) external mbuOnly returns (bool _nameSet){
        require(!knownMorphName[_name], "name already set");
        require(!hasMorphNameByAddress[_owner], "has morph name");
        knownMorphName[_name] = true; 
        addressByMorphName[_name] = _owner;
        morphNameByAddress[_owner] = _name;
        hasMorphNameByAddress[_owner] = true;
       
        profileByUser[_owner] = _profile;
        return true; 
    }

    function updateMorphProfile(string memory _name, string memory _profile) external returns (bool _updated) {
        require(msg.sender == addressByMorphName[_name], "profile owner only ");
        require(knownMorphName[_name], "unknown Morph name");
        profileByUser[addressByMorphName[_name]] = _profile; 
        return true;    
    }

    //========================================== INTERNAL ============================================


}
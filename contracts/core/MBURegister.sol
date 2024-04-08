// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IMBURegister.sol";
import "../interfaces/IMBUVersion.sol";

struct Config {
    string name; 
    uint256 version; 
    address address_; 
}

contract MBURegister is IMBURegister, IMBUVersion { 

    modifier adminOnly() { 
        require(msg.sender == admin, "admin only");
        _;
    }

    string constant name = "RESERVED_MBU_REGISTER";
    uint256 constant version = 3;  
    address immutable self;

    string [] names; 
    
    mapping(string=>bool) knownName;
    mapping(address=>bool) knownAddress; 
    mapping(string=>bool) hasAddress; 
    mapping(address=>bool) hasName; 
    mapping(string=>address) addressByName; 
    mapping(address=>string) nameByAddress; 
    

    address admin; 
     

    constructor(address _admin) {
        admin = _admin; 
        self = address(this);  
        addAddressInternal(name, self);
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }

    function getVersion() pure external returns (uint256 _version){
        return version; 
    }
    function getAddress(string memory _name) view external returns (address _address) {
        require(hasAddress[_name], "address not found");
        return addressByName[_name];
    }

    function getName(address _address) view external returns (string memory _name){
        require(hasName[_address], "unknown address");
        return nameByAddress[_address]; 
    }

    function isRegistered(address _address) view external returns (bool _isRegistered) {
        return hasName[_address];
    }

    function getAddresses() view external adminOnly returns (Config [] memory _config) {
        _config = new Config[](names.length);
        for(uint256 x = 0; x < _config.length; x++) {
            string memory name_ = names[x];
            IMBUVersion v_ = IMBUVersion(addressByName[name_]);
            _config[x] = Config({
                                    name : names[x],
                                    version : v_.getVersion(),
                                    address_ : address(v_)
                                });
        }
        return _config; 
    }

    function addVersionAddress(address _address) adminOnly external returns (bool _added) {
       IMBUVersion v_ = IMBUVersion(_address);
       return addAddressInternal(v_.getName(), _address);
    }

    function addAddress(string memory _name, address _address) adminOnly external returns (bool _added) {
        return addAddressInternal(_name, _address); 
    }
    //============================ INTERNAL ===========================

    function addAddressInternal(string memory _name, address _address) internal returns (bool _added) {
        if(!knownName[_name]){
            names.push(_name);
            knownName[_name] = true; 
        }
        nameByAddress[_address] = _name;  
        addressByName[_name] = _address; 
        knownAddress[_address] = true;  
        return true; 
    }
}
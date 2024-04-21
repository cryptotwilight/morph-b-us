// SPDX-License-Identifier: GPL-3.0

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
// File: contracts/core/MBURegister.sol



pragma solidity >=0.8.2 <0.9.0;



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
    uint256 constant version = 4;  
    address immutable self;

    string constant MBU_ADMIN = "RESERVED_MBU_ADMIN";

    string [] names; 
    
    mapping(string=>bool) knownName;
    mapping(address=>bool) knownAddress; 
 
    mapping(address=>bool) hasName; 
    mapping(string=>address) addressByName; 
    mapping(address=>string) nameByAddress; 
    mapping(address=>uint256) versionByAddress;

    address admin; 
     

    constructor(address _admin) {
        admin = _admin; 
        self = address(this);  
        addAddressInternal(name, self, version);
        addAddressInternal(MBU_ADMIN, _admin, 0);
    }

    function getName() pure external returns (string memory _name){
        return name; 
    }

    function getVersion() pure external returns (uint256 _version){
        return version; 
    }
    function getAddress(string memory _name) view external returns (address _address) {
        require(knownName[_name], "address not found");
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
                                    version : versionByAddress[address(v_)],
                                    address_ : address(v_)
                                });
        }
        return _config; 
    }

    function addVersionAddress(address _address) adminOnly external returns (bool _added) {
       IMBUVersion v_ = IMBUVersion(_address);
       return addAddressInternal(v_.getName(), _address, v_.getVersion());
    }

    function addAddress(string memory _name, address _address, uint56 _version) adminOnly external returns (bool _added) {
        return addAddressInternal(_name, _address, _version); 
    }
    //============================ INTERNAL ===========================

    function addAddressInternal(string memory _name, address _address, uint256 _version) internal returns (bool _added) {
        if(!knownName[_name]){
            names.push(_name);
            knownName[_name] = true; 
        }
        hasName[_address] = true;
        
        nameByAddress[_address] = _name;  
        addressByName[_name] = _address; 
        knownAddress[_address] = true;  
        versionByAddress[_address] = _version;
        return true; 
    }
}
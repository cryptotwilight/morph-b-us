// SPDX-License-Identifier: GPL-3.0
// File: contracts/interfaces/IMBUToken.sol



pragma solidity >=0.8.2 <0.9.0;


interface IMBUToken { 

    function mint(uint256 _amount, address _to) external returns (uint256 _totalCirculatingSupply);

    function burn(uint256 _amount) external returns (uint256 _totalCirculatingSupply);

}
// File: contracts/interfaces/IMBURewardsManager.sol



pragma solidity >=0.8.2 <0.9.0;

interface IMBURewardsManager {

    function getReward(address _owner) view external returns (uint256 _amount);

    function addReward(uint256 _amount, address _owner) external  returns (uint256 _balance);
    
    function addPenalty(uint256 _amount, address _owner) external returns (uint256 _balance);
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
// File: contracts/core/MBURewardsManager.sol



pragma solidity >=0.8.2 <0.9.0;





contract MBURewardsManager is IMBURewardsManager, IMBUVersion { 

    uint256 constant version = 1; 
    string constant name = "RESERVED_REWARDS_MANAGER";

    string constant MBU_TOKEN = "RESERVED_MBU_TOKEN";

    modifier mbuOnly() { 
        require(register.isRegistered(msg.sender), " MBU only ");
        _;
    }

    mapping(address=>uint256) rewardByOwner; 

    IMBURegister register; 
    IMBUToken token; 

    constructor(address _register){
        register = IMBURegister(_register); 
        initialize();
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getReward(address _owner) view external returns (uint256 _amount){
        return rewardByOwner[_owner];
    }

    function addReward(uint256 _amount, address _owner) external mbuOnly returns (uint256 _balance){
        _balance = rewardByOwner[_owner] += _amount;
        return _balance; 
    }

    function addPenalty(uint256 _amount, address _owner) external mbuOnly returns (uint256 _balance) {
        if(rewardByOwner[_owner]> 0){
            if(rewardByOwner[_owner] > _amount){
                _balance = rewardByOwner[_owner] -= _amount;
            }
            else {
                _balance = 0; 
            }
        }
        else {
            _balance = 0; 
        }
    }

    function claimReward() external returns (uint256 _payout, uint256 _balance) {
        _payout = rewardByOwner[msg.sender]; 
        _balance = rewardByOwner[msg.sender] = 0;
        token.mint(_payout, msg.sender);
        return (_payout, _balance);
    }

    //============================== INTERNAL =====================================

    function initialize() internal returns (bool _initialized) {
        token = IMBUToken(register.getAddress(MBU_TOKEN));
        return true; 
    }
}
// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "../interfaces/IMBUToken.sol";
import "../interfaces/IMBUVersion.sol";
import "../interfaces/IMBURegister.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MorphBeUsToken is IMBUToken, IMBUVersion, ERC20, ERC20Pausable, ERC20Permit {

    modifier adminOnly(){
        require(msg.sender == register.getAddress(MBU_ADMIN), "admin only");
        _;
    }

    string constant MBU_ADMIN = "RESERVED_MBU_ADMIN";
    string constant REWARD_MANAGER = "RESERVED_REWARD_MANAGER";

    string constant mname = "RESERVED_MBU_TOKEN";
    uint256 constant version = 1; 
    address immutable self; 

    uint256 circulatingSupply; 

    IMBURegister register;

    constructor(address _register)
        ERC20("Morph Be Us Token", "MBUT")
        ERC20Permit("Morph Be Us Token")
    {
        register = IMBURegister(_register);
        self = address(this);

    }

    function getName() pure external returns (string memory _name) {
        return mname; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function pause() public adminOnly {
        _pause();
    }

    function unpause() public adminOnly {
        _unpause();
    }

    function mint(uint256 _amount, address _to) external returns (uint256 _totalCirculatingSupply){
        require(msg.sender == register.getAddress(REWARD_MANAGER), "reward manager only");
        _mint( _to, _amount);
        circulatingSupply +=_amount;
        return circulatingSupply;
    }

    function burn(uint256 _amount) external returns (uint256 _totalCirculatingSupply){
        transferFrom(msg.sender, self, _amount);
        _burn(self, _amount);
        circulatingSupply -=_amount;
        return circulatingSupply; 
    }


    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }
}

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


interface IMBUToken { 

    function mint(uint256 _amount, address _to) external returns (uint256 _totalCirculatingSupply);

    function burn(uint256 _amount) external returns (uint256 _totalCirculatingSupply);

}
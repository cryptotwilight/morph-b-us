// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

interface IMBUNameManager {

    function isMorphNameAvailable(string memory _name) view external returns (bool _isAvailable); 

    function setMorphName(string memory _name, address _owner) external returns (uint256 _id);

}
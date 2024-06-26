// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

interface IMBUNameManager {

    function isMorphNameAvailable(string memory _name) view external returns (bool _isAvailable); 

    function setMorphName(string memory _name, address _owner, string memory _profile) external returns (bool _nameSet);

    function updateMorphProfile(string memory _name, string memory _profile) external returns (bool _updated);

    function getMorphAddress(string memory _name) view external returns (address _owner);

    function getMorphName(address _address) view external returns (string memory _name);

    function hasMorphName(address _address) view external returns (bool _hasMorphName);
}
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
// File: contracts/interfaces/IMBUStructs.sol



pragma solidity >=0.8.2 <0.9.0;


struct Content { 
    uint256 id; 
    string ipfsHash; 
    address author; 
    string authorName;
    uint256 date;  
}

struct Message { 
    uint256 id; 
    address sender; 
    address recipient; 
    string ipfsHash;
    uint256 date; 
}

struct Follow { 
    uint256 id; 
    address followedUser;
    address follower;
    uint256 date; 
}

struct Share { 
    uint256 id; 
    uint256 contentId; 
    address [] users; 
    uint256 date; 
    address sharer; 
}

struct Trim { 
    uint256 id; 
    uint256 [] oldIds; 
    uint256 [] newIds; 
    uint256 date; 
    address trimmer;
}

struct Mute { 
    uint256 id; 
    address user; 
    uint256 date; 
}


// File: contracts/interfaces/IMBUFeedManager.sol



pragma solidity >=0.8.2 <0.9.0;


interface IMBUFeedManager { 

    function getFeed(address _feedOwner) view external returns (uint256 [] memory _contentIds);

    function trimFeed(uint256 [] memory _contentIds, address _feedOwner) external returns (uint256 _trimId);

    function addToFeed(uint256 _contentId, address _feedOwner) external returns (bool _added );
    
    function share(uint256 _contentId, address [] memory _users, address _sharer) external returns (uint256 _shareId);

    function getShare(uint256 _shareId) view external returns (Share memory _share);

}
// File: contracts/core/MBUFeedManager.sol



pragma solidity >=0.8.2 <0.9.0;






contract MBUFeedManager {

    uint256 constant version = 1; 
    string constant name = "RESERVED_FEED_MANAGER";
    string constant MBU_ADMIN = "RESERVED_MBU_ADMIN";

    modifier adminOnly() { 
        require(register.getAddress(MBU_ADMIN) == msg.sender, " admin only ");
        _;
    }

    modifier mbuOnly() { 
        require(register.isRegistered(msg.sender), " MBU only ");
        _;
    }

    IMBURegister register;
    uint256 index;  
    mapping(address=>uint256[]) feedByOwner;
    mapping(uint256=>Share) shareById; 
    uint256 [] shares; 
    mapping(uint256=>Trim) trimById; 


    constructor(IMBURegister _register){
        register = _register; 
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getFeed(address _feedOwner) view external returns (uint256 [] memory _contentIds){
        return feedByOwner[_feedOwner];
    }

    function trimFeed(uint256 [] memory _contentIds, address _feedOwner) external mbuOnly returns (uint256 _trimId){
        _trimId = getIndex(); 
        trimById[_trimId] = Trim({
                                    id : _trimId, 
                                    oldIds : feedByOwner[_feedOwner],
                                    newIds : _contentIds,
                                    date : block.timestamp,
                                    trimmer : msg.sender
                                });
        feedByOwner[_feedOwner] = _contentIds;
        return _trimId; 
    }

    function addToFeed(uint256 _contentId, address _feedOwner) external mbuOnly returns (bool _added ){
        feedByOwner[_feedOwner].push(_contentId);
        return true; 
    }
    
    function getAllShares() view adminOnly external returns (uint256 [] memory _shares) {
        return shares;
    }

    function share(uint256 _contentId, address [] memory _users, address _sharer) external returns (uint256 _shareId){
        for(uint256 x = 0; x < _users.length; x++){
            feedByOwner[_users[x]].push(_contentId);
        }
        _shareId = getIndex(); 
        shareById[_shareId] = Share({
                                        id : _shareId,
                                        contentId : _contentId,
                                        users : _users,  
                                        date : block.timestamp, 
                                        sharer : _sharer 
                                    });
        return _shareId; 
    }

    function getShare(uint256 _shareId) view external returns (Share memory _share){
        return shareById[_shareId];
    }

    //==================================== INTERNAL ==============================

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
        return _index; 
    }
}
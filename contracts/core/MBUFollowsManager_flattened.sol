// SPDX-License-Identifier: GPL-3.0

// File: contracts/interfaces/IMBURewardsManager.sol



pragma solidity >=0.8.2 <0.9.0;

interface IMBURewardsManager {

    function getReward(address _owner) view external returns (uint256 _amount);
    
    function addPenalty(uint256 _amount, address _owner) external returns (uint256 _balance);
}
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


// File: contracts/interfaces/IMBUFollowsManager.sol



pragma solidity >=0.8.2 <0.9.0;


interface IMBUFollowsManager { 

    function getFollows(address _followsOwner) view external returns (uint256 [] memory _followIds);

    function getFollowingCount(address _followingOwner) view external returns (uint256 _count);

    function getFollow(uint256 _followId) view external returns (Follow memory _follow);

    function follow(string memory _name, address _followsOwner) external returns (uint256 _followId);

    function unfollow(string memory _name, address _followsOwner) external returns (bool _unfollowed);

    function isMuted(string memory _name, address _followingOwner) view external returns (bool _isMuted);

    function mute(string memory _name, address _followingOwner) external returns (uint256 _muteId);

    function unmute(string memory _name, address _followingOwner) external returns (bool _unmuted);
}
// File: contracts/interfaces/IMBURegister.sol



pragma solidity >=0.8.2 <0.9.0;

interface IMBURegister { 

    function getAddress(string memory _name) view external returns (address _address);

    function getName(address _address) view external returns (string memory _name);

    function isRegistered(address _address) view external returns (bool _isRegistered);
}
// File: contracts/interfaces/IMBUVersion.sol



pragma solidity >=0.8.2 <0.9.0;

interface IMBUVersion {

    function getName() view external returns (string memory _name);

    function getVersion() view external returns (uint256 _version);
    
}
// File: contracts/core/MBUFollowsManager.sol



pragma solidity >=0.8.2 <0.9.0;







contract MBUFollowsManager is IMBUFollowsManager, IMBUVersion { 

    uint256 constant version = 1; 
    string constant name = "RESERVED_FOLLOWS_MANAGER";

    string constant MBU_ADMIN = "RESERVED_MBU_ADMIN";

    modifier adminOnly() { 
        require(msg.sender == register.getAddress(MBU_ADMIN), "admin only");
        _;
    }

    modifier mbuOnly() { 
        require(register.isRegistered(msg.sender), " MBU only ");
        _;
    }

    uint256 Mute_Penalty; 

    IMBURegister register; 
    IMBURewardsManager rewards; 

    uint256 index; 
    IMBUNameManager names; 
    mapping(address=>mapping(string=>bool)) muted; 
    mapping(uint256=>Mute) muteById; 
    mapping(uint256=>Follow) followById; 
    mapping(address=>uint256[]) followingByOwner;
    mapping(address=>uint256[]) followsByFollower;
    mapping(address=>mapping(address=>uint256)) followIdByFollowerByOwner;

    constructor(IMBURegister _register){
        register = _register; 
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getFollows(address _follower) view external returns (uint256 [] memory followIds){
        return followsByFollower[_follower];
    }

    function getFollowingCount(address _followingOwner) view external returns (uint256 _count){
        return followsByFollower[_followingOwner].length;
    }

    function getFollow(uint256 _followId) view external returns (Follow memory _follow){
        return followById[_followId];
    }

    function follow(string memory _name, address _follower) external returns (uint256 _followId){
        address user_ = names.getMorphAddress(_name);
        _followId = getIndex();
        followById[_followId] = Follow({
            id : _followId,
            followedUser : user_,
            follower : _follower,
            date : block.timestamp
        });
        followingByOwner[user_].push(_followId);
        followsByFollower[_follower].push(_followId);
        followIdByFollowerByOwner[user_][_follower] = _followId;
        return _followId;
    }

    function unfollow(string memory _name, address _follower) external returns (bool _unfollowed){
        address user_ = names.getMorphAddress(_name);
        uint256 followId_ = followIdByFollowerByOwner[user_][_follower];
        delete followIdByFollowerByOwner[user_][_follower];
        delete followById[followId_];
        followingByOwner[user_] = remove(followId_, followingByOwner[user_]);
        followsByFollower[_follower] = remove(followId_, followsByFollower[_follower]);
        return true; 
    }

    function isMuted(string memory _name, address _followingOwner) view external returns (bool _isMuted){
        return muted[_followingOwner][_name];
    }

    function mute(string memory _name, address _followingOwner) external mbuOnly returns (uint256 _muteId){
        muted[_followingOwner][_name] = true;
        _muteId = getIndex();
        muteById[_muteId] = Mute({
                                    id: _muteId,  
                                    user: names.getMorphAddress(_name), 
                                    date : block.timestamp 
                                });

        rewards.addPenalty(Mute_Penalty, muteById[_muteId].user);
        return _muteId; 
    }

    function unmute(string memory _name, address _followingOwner) external mbuOnly returns (bool _unmuted){
        muted[_followingOwner][_name] = false;
        return true; 
    }
    
    function updateMutePenalty(uint256 _penalty) external adminOnly returns (bool _updated) {
        Mute_Penalty = _penalty; 
        return true; 
    }


    //==================================== INTERNAL ==============================

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
    return _index; 
    }

    function remove(uint256 c, uint256 [] memory a) pure internal returns (uint256 [] memory b) {
        b = new uint256[](a.length-1);
        uint256 y = 0;
        for(uint256 x = 0; x < a.length;x++) {
            if(a[x] != c) {
                b[y] = a[x];
                y++;
            }
        }
        return b; 
    }
} 
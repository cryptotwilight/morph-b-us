// SPDX-License-Identifier: GPL-3.0

// File: contracts/interfaces/IMBURewardsManager.sol



pragma solidity >=0.8.2 <0.9.0;

interface IMBURewardsManager {

    function getReward(address _owner) view external returns (uint256 _amount);

    function addReward(uint256 _amount, address _owner) external  returns (uint256 _balance);
    
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


// File: contracts/interfaces/IMBUContentManager.sol



pragma solidity >=0.8.2 <0.9.0;


interface IMBUContentManager { 

    function post(Content memory _content) external returns (uint256 _contentId);
    
    function getContent(uint256 _contentId) view external returns (Content memory _content);
}
// File: contracts/core/MBUContentManager.sol



pragma solidity >=0.8.2 <0.9.0;






contract MBUContentManager is IMBUContentManager, IMBUVersion { 

    uint256 constant version = 2; 
    string constant name = "RESERVED_CONTENT_MANAGER";

    string constant NAME_MANAGER = "RESERVED_NAME_MANAGER";
    string constant MBU_ADMIN = "RESERVED_MBU_ADMIN";
    string constant MBU_REGISTER = "RESERVED_MBU_REGISTER";
    string constant REWARDS_MANAGER = "RESERVED_REWARDS_MANAGER";

    modifier adminOnly() { 
        require(register.getAddress(MBU_ADMIN) == msg.sender, "MBU admin only ");
        _; 
    }

    modifier mbuOnly() { 
        require(register.isRegistered(msg.sender), " MBU only ");
        _;
    }
    modifier mbuUserOnly()  {
        require(register.isRegistered(msg.sender) || names.hasMorphName(msg.sender), " MBU Users Only");
        _;
    }

    IMBURegister register; 
    IMBUNameManager names; 
    IMBURewardsManager rewards;

    uint256 Post_Reward = 1 * 1e14; 
    
    uint256 index; 
    uint256 [] contentList; 
    mapping(uint256=>Content) contentById; 

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

    function post(Content memory _content) external mbuUserOnly returns (uint256 _contentId){
        _contentId = getIndex(); 
        contentList.push(_contentId);
        contentById[_contentId] = Content({
                                            id : _contentId,  
                                            ipfsHash : _content.ipfsHash, 
                                            author : _content.author, 
                                            authorName : names.getMorphName(_content.author), 
                                            date : block.timestamp  
                                        });
        rewards.addReward(Post_Reward, msg.sender);
        return _contentId; 
    }
    
    function getContent(uint256 _contentId) view external returns (Content memory _content){
        return contentById[_contentId];
    }

    function notifyChangeOfAddress() external adminOnly returns (bool _acknowledged) {
        register = IMBURegister(register.getAddress(MBU_REGISTER));
        initialize();

        return true;
    }

    function updatePostReward(uint256 _postReward) external adminOnly returns (bool _updated) {
        Post_Reward = _postReward;
        return true; 
    }
    //==================================== INTERNAL ==============================

    function initialize() internal returns (bool _initialized) {
        names = IMBUNameManager(register.getAddress(NAME_MANAGER));
        rewards = IMBURewardsManager(register.getAddress(REWARDS_MANAGER));
        return true; 
    }

    function getIndex() internal returns (uint256 _index) {
        _index = index++; 
        return _index; 
    }
}
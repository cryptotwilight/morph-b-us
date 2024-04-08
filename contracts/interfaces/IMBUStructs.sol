// SPDX-License-Identifier: GPL-3.0

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


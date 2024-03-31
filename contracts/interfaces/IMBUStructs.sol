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
    string fromName; 
    string toName; 
    string ipfsHash;
    uint256 date; 
}

struct Follow { 
    uint256 id; 
    string targetName;
    uint256 date; 
}

struct Share { 
    uint256 id; 
    uint256 contentId; 
    uint256 [] userIds; 
    uint256 date; 
}


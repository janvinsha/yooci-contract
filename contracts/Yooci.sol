// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

contract Yooci is ERC721URIStorage {
 using Counters for Counters.Counter;
    address payable owner;
     Counters.Counter private _tokenIds;
 mapping(address => Record) private records;

struct Record{
     address recordOwner;
    string tokenURI;
      uint256 tokenID;
      bool isValue;
}

    event RecordCreated (
    address recordOwner,
    string tokenURI,
      uint256 tokenID,
      bool isValue
    );

    event RecordUpdated (
   address recordOwner,
    string tokenURI,
      uint256 tokenID,
      bool isValue
    );

    constructor() ERC721("Yooci", "YOO") {
      owner = payable(msg.sender);
    }

    /* Mints a token */
    function createToken(string memory tokenURI, uint newTokenId
    ) private returns (uint) {
      _mint(msg.sender, newTokenId);
      _setTokenURI(newTokenId, tokenURI);
      return newTokenId;
    }
    function updateRecord(string memory tokenURI
    ) public payable {
        require(getRecord(msg.sender).isValue==true);
      uint256 _tokenID=getRecord(msg.sender).tokenID;
      records[msg.sender].tokenURI=tokenURI;
      _setTokenURI(_tokenID, tokenURI);
      emit RecordUpdated(msg.sender,tokenURI,_tokenID,true);
    }
      function createRecord(string memory tokenURI
    ) public payable {
      _tokenIds.increment();
      uint256 newTokenId = _tokenIds.current();
         createToken(tokenURI,newTokenId);
           records[msg.sender] =Record(
        msg.sender,
       tokenURI ,
        newTokenId,
        true
    );
        emit RecordCreated(msg.sender,tokenURI,newTokenId,true);
    }

    function getRecord(address id) public view returns(Record memory){
    return records[id];
}
  
}


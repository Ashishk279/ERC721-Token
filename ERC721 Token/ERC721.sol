// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract MyERC721Token is ERC721, Ownable {
    constructor (string memory name , string memory symbol) ERC721(name, symbol) {}
      // Mapping to store token metadata IPFS hashes
    mapping(uint256 => string) private tokenURIs;

    // Function to set the metadata URI for a token
    function _setTokenURI(uint256 tokenId, string memory metadataIpfsHash) internal {
        tokenURIs[tokenId] = metadataIpfsHash;
    }

    // Function to get the metadata URI for a token
    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        return tokenURIs[tokenId];
    }
    
    // Mint a new token with tokenID and owner

    function _mint(address owner, uint256 tokenId,string memory metadataIpfsHash) public onlyOwner{
        _mint(owner , tokenId);
        _setTokenURI(tokenId, metadataIpfsHash);
    }
     
     function _burn(uint256 tokenId) internal override{
         _burn(tokenId);
     }

  
 

}

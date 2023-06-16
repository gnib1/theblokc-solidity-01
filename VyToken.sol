// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.9.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.9.1/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.9.1/security/Pausable.sol";
import "@openzeppelin/contracts@4.9.1/access/Ownable.sol";
import "@openzeppelin/contracts@4.9.1/utils/Counters.sol";

contract VyToken is ERC721, ERC721Enumerable, Pausable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public MintPrice = 0.05 ether;
    uint public  max_ = 100;
    uint private balance = max_;

    constructor() ERC721("VyToken", "vt") {
         _tokenIdCounter.increment();
    }


    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://VyTokenBaseURI";
    }
    
   
    function setPrice(uint256 price) public onlyOwner{
        //We declare that the current price is similar to what is inputted
        MintPrice = price; 
    }

    function getPrice() public view returns (uint256){
        //declares the current placed file
        return MintPrice;
    }

    //Minting methods
   function safeMint(address to) public payable 
    {
          // ❌ Check that totalSupply is less than MAX_SUPPLY
        require(totalSupply() < max_, "Can't mint anymore tokens.");

        // ❌ Check if ether value is correct
        require(msg.value >= MintPrice, "Not enough ether sent.");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function withdraw() public onlyOwner() {
        require(address(this).balance > 0, "Balance is zero");
        payable(owner()).transfer(address(this).balance);
    }
   
        function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

  
    
    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, Ownable {
    uint256 private _nextTokenId;
    uint256 public immutable maxSupply;

    constructor(address initialOwner, uint256 _supply)
        ERC721("SolidityDev", "SD")
        Ownable(initialOwner)
    {
        maxSupply = _supply;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmPMc4tcBsMqLRuCQtPmPe84bpSjrC3Ky7t3JWuHXYB4aS/";
    }

    function mint() external payable {
        require(_nextTokenId < maxSupply, "max supply reached");

        // Extend logic here

        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "nothing to withdraw");

        payable(owner()).transfer(balance);
    }
}

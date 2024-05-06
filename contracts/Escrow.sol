//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0

interface IERC721 {
    function transferFrom {
        address _from,
        address _to,
        uint256 _id
    } external;
}

contract Escrow {
    address public nftAddress;
    address payable public seller;
    address public inspector;
    address public lender;

    modifier onlyInspector() {
        require(msg.sender == inspector, "Only inspector call this method");
        _;
    }
    
	modifier onlyBuyer(uint256 _nftID){
        require(msg.sender == buyer[_nftID], "Only buyer call this method");
        _;
    }
}
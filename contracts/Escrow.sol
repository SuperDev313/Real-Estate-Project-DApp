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

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller call this method");
        _;
    }

    constructor(address _nftAddress, address payable _seller, address _inspector, address _lender) {
        nftAddress = _nftAddress;
        seller = _seller;
        inspector = _inspector;
        lender = _lender;
    }

    function list (uint256 _nftID, address _buyer, uint256 _purchasePrice, uint256 _escrowAmount) public payable onlySeller {
        // Transfer NFT from seller to this contract
        IERC721(nftAddress).transferFrom(msg.sender, address(this), _nftID);

        isListed[_nftID] = true;
        purchasePrice[_nftID] = _purchasePrice;
        escrowAmount[_nftID] = _escrowAmount;
        buyer[_nftID] = _buyer;
    }

    // Put Under Contract (only buyer - payable escrow)   
    function depositEarnest(uint256 _nftID) onlyBuyer(_nftID) public payable {
		require(msg.value >= escrowAmount[_nftID]);
	}

    // Update Inspection Status (only inspector)
    function updateInspectionStatus (uint256 _nftID, bool _passed) public onlyInspector {
        inspectionPassed[_nftID] = _passed;
    }
}
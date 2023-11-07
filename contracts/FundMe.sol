// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8; 

import "./PriceConverter.sol";

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    uint256 public constant MIN_USD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmount;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable { 

        require(msg.value.getConversionRate() >= MIN_USD, "Didnt send enough"); // 1e18 == 1 * 10 ** 18 == 1000000000000000000
        funders.push(msg.sender);
        addressToAmount[msg.sender] = msg.value;
    }

   

    function withdraw() public onlyOwner {
        
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex = funderIndex++){
            address funder = funders[funderIndex];
            addressToAmount[funder] = 0;

            funders = new address[](0);

            // payable(msg.sender).transfer(address(this).balance);

            // bool sendSuccess = payable(msg.sender).send(address(this).balance);
            // require(sendSuccess, "Send failed");

            (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
            require(callSuccess, "Call failed");
        }
    }

    modifier onlyOwner {
        // require(msg.sender == i_owner, "Sender is not owner!");
        if(msg.sender != i_owner){ revert NotOwner();}
        _;
        }

        // what happens if someone sends us eth without calling the fund function

         receive() external payable {
        fund();
     }

     fallback() external payable { 
        fund();
     }
        
}
//"SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

interface IOpenPricing { 

    function getPrice(uint256 _productId, string memory _denomination) external returns (uint256 _price);

}
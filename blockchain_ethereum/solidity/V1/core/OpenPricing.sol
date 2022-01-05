//"SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.8.0 <0.9.0;

import "../imports/IOpenRoles.sol";
import "../imports/IOpenOracle.sol";
import "../imports/IOpenProduct.sol"; 
import "../imports/IOpenProductManager.sol";

import "../interfaces/IOpenPricing.sol";



contract OpenPricing is IOpenPricing { 

        IOpenOracle oracleManager; 
        IOpenProductManager productManager;         
        IOpenRoles roleManager; 
        address self_openPricing; 

        constructor(address _roleManagerAddress, address _productManagerAddress, address _oracleManagerAddress) {
                oracleManager = IOpenOracle(_oracleManagerAddress);
                productManager = IOpenProductManager(_productManagerAddress);
                roleManager = IOpenRoles(_roleManagerAddress);
                self_openPricing = address(this);
        }

        function getPrice(uint256 _productId, string memory _toDenomination) override external returns (uint256 _price){
                require(roleManager.isAllowed(self_openPricing, "USER", "setRoleManager", msg.sender)," OPENPRICING - setRoleManager - 00 : admin only ") ;
                IOpenProduct product = IOpenProduct(productManager.getProduct(_productId));
                (uint256 price_, string memory fromDenomination_, address erc20_) = product.getPrice(); 
                return oracleManager.getPrice(price_, fromDenomination_, _toDenomination );
        }

        function setRoleManager(address _roleManagerAddress)  external returns (bool _set){
                require(roleManager.isAllowed(self_openPricing, "ADMIN", "setRoleManager", msg.sender)," OPENPRICING - setRoleManager - 00 : admin only ") ;
                roleManager = IOpenRoles(_roleManagerAddress);
                return true; 
        }

        function setProductManager(address _productManagerAddress)  external returns (bool _set) {
                require(roleManager.isAllowed(self_openPricing, "ADMIN", "setProjectManager", msg.sender)," OPENPRICING - setProductManager - 00 : admin only ") ;
                productManager = IOpenProductManager(_productManagerAddress);
                return true; 
        }

        function setOracleManager(address _oracleManagerAddress)  external returns (bool _set) {
                require(roleManager.isAllowed(self_openPricing, "ADMIN", "setOracleManager", msg.sender)," OPENPRICING - setOracleManager - 00 : admin only ") ;
                oracleManager = IOpenOracle(_oracleManagerAddress);
                return true;
        }

}
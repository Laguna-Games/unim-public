// SPDX-License-Identifier: UNLICENSED


pragma solidity ^0.8.0;

import "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "@moonstream/contracts/diamond/libraries/LibDiamond.sol";
import "@moonstream/contracts/moonstream/LibERC20.sol";

contract ERC20Initializer {
    function init() external {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.supportedInterfaces[type(IERC20).interfaceId] = true;

        LibERC20.ERC20Storage storage es = LibERC20.erc20Storage();
        es.controller = msg.sender;
        es.name = "Unicorn Milk";
        es.symbol = "UNIM";
    }
}
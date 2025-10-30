// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title GreenToken Carbon Credit Marketplace
 * @dev A decentralized platform for trading carbon credits using GreenTokens.
 */
contract GreenTokenCarbonCreditMarketplace {
    address public admin;

    struct CarbonCredit {
        uint id;
        address owner;
        uint256 amount; // represents the value of carbon credits
        uint256 price;  // price in wei per unit
        bool isListed;
    }

    uint256 public nextCreditId;
    mapping(uint256 => CarbonCredit) public credits;
    mapping(address => uint256) public balances;

    event CreditC

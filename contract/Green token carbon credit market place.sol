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

    event CreditCreated(uint256 indexed id, address indexed owner, uint256 amount);
    event CreditListed(uint256 indexed id, uint256 price);
    event CreditPurchased(uint256 indexed id, address indexed buyer, uint256 amount);

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Create new carbon credits (only admin)
     * @param _to The address receiving the credits
     * @param _amount The number of credits
     */
    function createCarbonCredit(address _to, uint256 _amount) external {
        require(msg.sender == admin, "Only admin can create credits");
        credits[nextCreditId] = CarbonCredit(nextCreditId, _to, _amount, 0, false);
        emit CreditCreated(nextCreditId, _to, _amount);
        nextCreditId++;
    }

    /**
     * @notice List carbon credits for sale
     * @param _id The credit ID
     * @param _price Price per credit in wei
     */
    function listCreditForSale(uint256 _id, uint256 _price) external {
        CarbonCredit storage credit = credits[_id];
        require(msg.sender == credit.owner, "Only owner can list");
        require(!credit.isListed, "Already listed");
        credit.price = _price;
        credit.isListed = true;
        emit CreditListed(_id, _price);
    }

    /**
     * @notice Buy carbon credits listed for sale
     * @param _id The credit ID
     */
    function buyCredit(uint256 _id) external payable {
        CarbonCredit storage credit = credits[_id];
        require(credit.isListed, "Not listed for sale");
        uint256 totalCost = credit.amount * credit.price;
        require(msg.value == totalCost, "Incorrect payment");

        payable(credit.owner).transfer(msg.value);
        credit.owner = msg.sender;
        credit.isListed = false;

        emit CreditPurchased(_id, msg.sender, credit.amount);
    }
}


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Store is Ownable {
    struct Product {
        string name;
        uint256 stock;
        uint256 price;
        bool exists;
    }

    /// @notice id => product
    mapping(uint256 => Product) public products;

    /// @notice buyer => product_id => quantity
    mapping(address => mapping(uint256 => uint256)) public userPurchase;

    /// @notice product_id => total quantity sold
    mapping(uint256 => uint256) public productSold;

    event Purchase(address indexed buyer, uint256 indexed id, uint256 quantity);

    constructor() Ownable(msg.sender) {}

    // ============ OWNER (STORE MANAGER) ============

    function addProduct(
        uint256 id,
        string calldata name,
        uint256 stock,
        uint256 price
    ) external onlyOwner {
        require(!products[id].exists, "Product exists");
        products[id] = Product({
            name: name,
            stock: stock,
            price: price,
            exists: true
        });
    }

    function updatePrice(uint256 id, uint256 price) external onlyOwner {
        Product storage p = products[id];
        require(p.exists, "Product not found");
        p.price = price;
    }

    function updateStock(uint256 id, uint256 stock) external onlyOwner {
        Product storage p = products[id];
        require(p.exists, "Product not found");
        p.stock = stock;
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Zero balance");
        payable(owner()).transfer(balance);
    }

    // ============ BUY ============

    function buy(uint256 id, uint256 quantity) external payable {
        require(quantity > 0, "Zero quantity");

        Product storage p = products[id];
        require(p.exists, "Product not found");
        require(p.stock >= quantity, "Out of stock");

        uint256 totalPrice = p.price * quantity;
        require(msg.value >= totalPrice, "Not enough funds");

        // update state
        p.stock -= quantity;
        userPurchase[msg.sender][id] += quantity;
        productSold[id] += quantity;

        // refund change
        if (msg.value > totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }

        emit Purchase(msg.sender, id, quantity);
    }

    // ============ VIEWS ============

    function getPrice(uint256 id) external view returns (uint256) {
        Product storage p = products[id];
        require(p.exists, "Product not found");
        return p.price;
    }

    function getStock(uint256 id) external view returns (uint256) {
        Product storage p = products[id];
        require(p.exists, "Product not found");
        return p.stock;
    }
}

// DO HOMEWORK HERE ==> https://challenges.solidity.university/store-challenge

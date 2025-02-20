// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Vault {
    uint256 public amount;
    address public owner;
    address public withdrawer;

    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(address indexed receiver, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyWithdrawer() {
        require(msg.sender == withdrawer, "Only withdrawer can call this function");
        _;
    }

    function setWithdrawer(address selectedAddress) public onlyOwner {
        withdrawer = selectedAddress;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        amount += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw() public onlyWithdrawer {
        require(amount > 0, "No funds available for withdrawal");
        
        uint256 withdrawAmount = amount;
        amount = 0; 
        (bool success, ) = payable(msg.sender).call{value: withdrawAmount}("");
        require(success, "Transfer failed");

        emit Withdrawn(msg.sender, withdrawAmount);
    }
}

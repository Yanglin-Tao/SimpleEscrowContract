// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleEscrowContract {
    address public alice;
    address public bob = payable(0xECf74C19215C8DD2BAF16AD3a6eC1A25386d813c); 
    uint256 public depositTime;
    uint256 public depositAmount;
    bool public isDeposited;

    event Deposit(address sender, uint256 amount, uint256 depositTime);
    event Withdraw(address receiver, uint256 amount);

    constructor() {
        alice = msg.sender;
    }

    function deposit() public payable {
        require(alice == msg.sender, "Only alice can deposit");
        require(!isDeposited, "Already deposited");
        require(msg.value > 0, "Deposit amount must be greater than 0 ether");
        depositAmount = msg.value;
        depositTime = block.timestamp;
        isDeposited = true;
        emit Deposit(alice, depositAmount, depositTime);
    }

    function withdraw(uint256 withdrawAmount) public {
        require(msg.sender == bob, "Only bob can withdraw");
        require(isDeposited, "No amount has been deposited");
        require(block.timestamp >= depositTime + 1 days, "Deposit can only be withdrawn after 1 day of deposit"); 
        require(withdrawAmount <= depositAmount, "No sufficient amount to withdraw");
        payable(bob).transfer(withdrawAmount);
        depositAmount -= withdrawAmount; 
        if (depositAmount == 0) {
            isDeposited = false; 
        }
        emit Withdraw(bob, withdrawAmount);
    }
}
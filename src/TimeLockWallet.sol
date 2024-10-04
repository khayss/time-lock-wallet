// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimeLockWallet {
    address public owner;
    uint256 public unlockTime;

    event Deposited(address indexed sender, uint256 amount, uint256 timestamp);
    event Withdrawn(address indexed owner, uint256 amount, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the wallet owner");
        _;
    }

    modifier lockExpired() {
        require(block.timestamp >= unlockTime, "Funds are still locked");
        _;
    }

    constructor(address _owner, uint256 _unlockTime) {
        require(_owner != address(0), "Invalid owner address");
        require(_unlockTime > block.timestamp, "Unlock time must be in the future");

        owner = _owner;
        unlockTime = _unlockTime;
    }

    // Allow the owner to deposit funds into the wallet
    receive() external payable {
        emit Deposited(msg.sender, msg.value, block.timestamp);
    }

    // Allow the owner to withdraw funds after the lock period expires
    function withdraw() external onlyOwner lockExpired {
        uint256 amount = address(this).balance;
        require(amount > 0, "No funds to withdraw");

        payable(owner).transfer(amount);
        emit Withdrawn(owner, amount, block.timestamp);
    }

    // Allow the owner to check the balance of the wallet
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Extend the lock period
    function extendLock(uint256 newUnlockTime) external onlyOwner {
        require(newUnlockTime > unlockTime, "New unlock time must be in the future");
        unlockTime = newUnlockTime;
    }
}

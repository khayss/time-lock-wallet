// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {TimeLockWallet} from "../src/TimeLockWallet.sol";

contract TimeLockWalletScript is Script {
    TimeLockWallet public wallet;
    address public owner = 0xDaB8892C07FB4C362Dd99D9a2fBFf8B555D39Cb5;
    uint256 public unlockTime = block.timestamp + 1000;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        wallet = new TimeLockWallet(owner, unlockTime);

        vm.stopBroadcast();
    }
}

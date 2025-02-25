// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {GameVault} from "../src/GameVault.sol";

contract DeployGameVault is Script {
    function run() public {
        address deployer = vm.envAddress("DEPLOYER");

        vm.startBroadcast(deployer);
        GameVault gameVault = new GameVault();
        vm.stopBroadcast();

        console.log("GameVault deployed at:", address(gameVault));
    }
}

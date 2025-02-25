// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Test, console} from "forge-std/Test.sol";
import {GameVault} from "../src/GameVault.sol";

contract GameVaultTest is Test {
    GameVault public gameVault;
    address public player = address(0x1);
    address public withdrawer = address(0x2);
    address public nonWithdrawer = address(0x3);

    function setUp() public {
        gameVault = new GameVault();
        vm.deal(player, 10 ether);
    }

    function testOwner() public view {
        assertEq(gameVault.owner(), address(this), "Owner should be deployer");
    }

    function testPlay() public {
        vm.startPrank(player);
        for (uint256 i = 0; i < 5; i++) {
            gameVault.play{value: 1 ether}();
        }
        vm.stopPrank();
        
        assertEq(gameVault.amount(), 5 ether, "Vault should have 5 ETH");
        assertEq(gameVault.attempByPlayer(player), 5, "Player should have 5 attempts");
    }

    function testPlayFailsAfter5Attempts() public {
        vm.startPrank(player);
        for (uint256 i = 0; i < 5; i++) {
            gameVault.play{value: 1 ether}();
        }
        vm.expectRevert("Play limit: 5 times");
        gameVault.play{value: 1 ether}();
        vm.stopPrank();
    }

    function testWithdrawOnlyByWithdrawer() public {
        vm.prank(gameVault.owner());
        gameVault.setWithdrawer(withdrawer);

        vm.startPrank(player);
        gameVault.play{value: 1 ether}();
        vm.stopPrank();

        vm.expectRevert("Only withdrawer can call this function");
        vm.prank(nonWithdrawer);
        gameVault.withdraw(); 

        vm.prank(withdrawer);
        gameVault.withdraw();

        assertEq(gameVault.amount(), 0, "Vault should be empty after withdrawal");
        assertEq(gameVault.withdrawer(), address(0));
    }

    function testSetWithdrawer() public {
        vm.prank(gameVault.owner());
        gameVault.setWithdrawer(withdrawer);
        assertEq(gameVault.withdrawer(), withdrawer, "Withdrawer should be set correctly");
    }
}

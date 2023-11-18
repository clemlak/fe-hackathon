// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

interface FeContract {
    error GiftEnded();
    error NotWhitelisted();
    error NotAdmin();

    event Gift(address indexed gifter, address collectible, uint256 tokenId);

    function get() external view returns (uint256);
    function get_admin() external view returns (address);
    function gift(address collectible, uint256 tokenId) external;
    function whitelist(address collectible) external;
}

contract Collectible {
    function transferFrom(address from, address to, uint256 tokenId) external returns (bool) {
        return true;
    }
}

contract CounterTest is Test {
    Counter public counter;
    FeContract public fe;
    Collectible public collectible;

    function setUp() public {
        string[] memory inputs = new string[](4);
        inputs[0] = "fe";
        inputs[1] = "build";
        inputs[2] = "./";
        inputs[3] = "--overwrite";
        vm.ffi(inputs);
        string memory bin = vm.readFile("./output/Main/Main.bin");
        bytes memory bytecode = vm.parseBytes(bin);
        address deployed;

        assembly {
            deployed := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        fe = FeContract(deployed);
        collectible = new Collectible();
    }

    function test_admin() public {
        assertEq(fe.get_admin(), address(this));
    }

    function test_fe() public {
        fe.whitelist(address(collectible));
        fe.gift(address(collectible), 0);
    }
}

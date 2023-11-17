// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

interface FeContract {
    function get() external view returns (uint256);
}

contract CounterTest is Test {
    Counter public counter;
    FeContract public fe;

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
    }

    function test_fe() public {
        assertEq(fe.get(), 42);
    }
}

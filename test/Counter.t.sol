// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import "solmate/test/utils/mocks/MockERC721.sol";
import {ERC721TokenReceiver} from "solmate/tokens/ERC721.sol";
import "solmate/test/utils/mocks/MockERC1155.sol";
import {ERC1155TokenReceiver} from "solmate/tokens/ERC1155.sol";

interface FeContract {
    error GiftNotStarted();
    error GiftEnded();
    error NotWhitelisted();
    error NotAdmin();
    error NoSelfGift();

    event Gift(address indexed gifter, address indexed receiver, address collectible, uint256 tokenId);

    function get_admin() external view returns (address);
    function get_start_time() external view returns (uint256);
    function get_end_time() external view returns (uint256);
    function get_last_santa() external view returns (address);
    function gift(address collectible, uint256 tokenId) external;
    function whitelist(address collectible) external;
    function check_whitelist(address collectible) external view returns (bool);
    function transfer(address collectible, uint256 tokenId, address from, address to) external;
}

contract CounterTest is Test, ERC1155TokenReceiver, ERC721TokenReceiver {
    FeContract public fe;
    MockERC721 public collectibleERC721;
    MockERC1155 public collectibleERC1155;

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
        bytes memory deploymentBytecode = abi.encodePacked(bytecode);

        assembly {
            deployed := create(0, add(bytecode, 0x20), mload(deploymentBytecode))
        }

        fe = FeContract(deployed);
        collectibleERC721 = new MockERC721("MockERC721", "MOCK721");
        collectibleERC1155 = new MockERC1155();
        vm.warp(1701388800);
    }

    function test_getters() public {
        assertEq(fe.get_start_time(), 1701388800);
        assertEq(fe.get_end_time(), 1703505600);
        assertEq(fe.get_admin(), address(this));
        assertEq(fe.get_last_santa(), address(this));
    }

    function test_whitelist() public {
        fe.whitelist(address(collectibleERC721));
        assertTrue(fe.check_whitelist(address(collectibleERC721)));
        assertFalse(fe.check_whitelist(address(collectibleERC1155)));
    }

    function test_whitelist_RevertsWhenNotAdmin() public {
        vm.expectRevert(FeContract.NotAdmin.selector);
        vm.prank(address(0xbeef));
        fe.whitelist(address(collectibleERC721));
    }

    function test_gift_RevertsWhenNotWhitelisted() public {
        vm.prank(address(0xbeef));
        vm.expectRevert(FeContract.NotWhitelisted.selector);
        fe.gift(address(collectibleERC721), 0);
    }

    function test_gift_RevertsWhenGiftNotStart() public {
        vm.warp(0);
        fe.whitelist(address(collectibleERC721));
        vm.prank(address(0xbeef));
        vm.expectRevert(FeContract.GiftNotStarted.selector);
        fe.gift(address(collectibleERC721), 0);
    }

    function test_gift_RevertsWhenGiftEnded() public {
        vm.warp(1703505600 + 1);
        fe.whitelist(address(collectibleERC721));
        vm.prank(address(0xbeef));
        vm.expectRevert(FeContract.GiftEnded.selector);
        fe.gift(address(collectibleERC721), 0);
    }

    function test_gift_erc721() public {
        fe.whitelist(address(collectibleERC721));
        collectibleERC721.mint(address(0xbeef), 0);
        vm.startPrank(address(0xbeef));
        collectibleERC721.approve(address(fe), 0);
        fe.gift(address(collectibleERC721), 0);
        vm.stopPrank();
        assertEq(collectibleERC721.ownerOf(0), address(this));
    }

    function test_gift_erc1155() public {
        fe.whitelist(address(collectibleERC1155));
        collectibleERC1155.mint(address(0xbeef), 0, 1, "");
        vm.startPrank(address(0xbeef));
        collectibleERC1155.setApprovalForAll(address(fe), true);
        fe.gift(address(collectibleERC1155), 0);
        vm.stopPrank();
        assertEq(collectibleERC1155.balanceOf(address(this), 0), 1);
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.34;

import {Test, console} from "forge-std/Test.sol";

import {FundMe} from "../src/FundMe.sol";

import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarsIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        if (block.chainid == 11155111) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 4);
        } else if (block.chainid == 1) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 6);
        }
    }

    function testFundingFailsWithoutEnoughETH() public {
        vm.expectRevert(); //hey the next line should revert or assert that the text in next line fails
        fundMe.fund(); //this means fundMe.fund{value: 0}(), same thing as that syntax,i.e this is how we send value. so it will as we send 0 value which is lower than min usd, i.e the test will pass.
    }

    function testFundingUpdatesFundedDataStructure() public {
        fundMe.fund{value: 10e18}();
    }
}

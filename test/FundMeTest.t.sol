// SPDX-License-Identifier: MIT

pragma solidity ^0.8.34;

import {Test, console} from "forge-std/Test.sol";

import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function testMinimumDollarsIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), address(this));
    }

    //function testPriceFeedVersionIsAccurate() public view {
    // assertEq(fundMe.getVersion(), 4);
    // }
}

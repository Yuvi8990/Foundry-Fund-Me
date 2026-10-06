// SPDX-License-Identifier: MIT

pragma solidity ^0.8.34;

import {Test, console} from "forge-std/Test.sol";

import {FundMe} from "../src/FundMe.sol";

import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user"); // here makeAddr is also cheatcode from another family living in forge std. it takes a string input from us,here user, and then converts that into an address; which we can store in another variable,here USER.
    uint256 constant SEND_VALUE = 0.1 ether; //decimals usually dont work in solidity, but saying ether makes it 0.1 * 1e18
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
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
        vm.prank(USER); //the next line or text will be sent by USER.
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }
}

// v.I => everytime we call a function or even call them together, first setup runs and a test is executed, then setup runs again and a test is executed again.
// so after one test setup runs again and RESETS evrything including address and stuff for every test.

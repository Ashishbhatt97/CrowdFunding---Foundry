// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Test, console} from "forge-std/Test.sol";
import {CrowdFunding} from "../src/CrowdFunding.sol";

contract CrowdFundingTest is Test {
    CrowdFunding public CrowdFundingInstance;

    function setUp() public {
        CrowdFundingInstance = new CrowdFunding(3600, 100);
    }

    //transfer ether test function
    function testTransferEth() public {
        uint256 initialRaisedAmount = CrowdFundingInstance.raisedAmount();
        uint256 initialNoOfContributors = CrowdFundingInstance
            .noOfContributors();

        // Lets send 1 Eth to the contract
        vm.deal(address(this), 1 ether);
        CrowdFundingInstance.transferEth{value: 1 ether}();

        assertEq(
            CrowdFundingInstance.noOfContributors(),
            initialNoOfContributors + 1
        );
        assertEq(
            CrowdFundingInstance.raisedAmount(),
            initialRaisedAmount + 1 ether
        );

        assertEq(CrowdFundingInstance.contributedMoney(address(this)), 1 ether);
    }
}

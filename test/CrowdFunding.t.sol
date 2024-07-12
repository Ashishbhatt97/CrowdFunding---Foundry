// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Test, console} from "forge-std/Test.sol";
import {CrowdFunding} from "../src/CrowdFunding.sol";

contract CrowdFundingTest is Test {
    CrowdFunding public CrowdFundingInstance;

    function setUp() public {
        CrowdFundingInstance = new CrowdFunding(3600, 100);
    }
}

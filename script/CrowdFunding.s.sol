// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Script, console} from "forge-std/Script.sol";
import {CrowdFunding} from "../src/CrowdFunding.sol";

contract CounterScript is Script {
    CrowdFunding public crowdFundingInstance;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        crowdFundingInstance = new CrowdFunding(3600, 100);

        vm.stopBroadcast();
    }
}

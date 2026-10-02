//SPDX-License-Identifier: MIT

// it does two things, first it deploy mocks when we are on a local anvil chain.
// second; it keep track of contract addresses across different chains
// so it will help us work with a mock price or any eth based price feed with modularity without any problem.
// if we are on local anvil we can deploy mocks, otherwise can grab the existing addresses from live network

pragma solidity ^0.8.34;

import {Script} from "forge-std/Script.sol";

import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed; //ETH/USD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainNetEthConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return mainNetEthConfig;
    }

    function getAnvilEthConfig() public returns (NetworkConfig memory) {
        vm.startBroadcast();
        MockV3Aggregator mockAnvilPriceFeed = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();
        NetworkConfig memory anvilEthConfig = NetworkConfig({priceFeed: address(mockAnvilPriceFeed)});
        return anvilEthConfig;
    }
}

// these functions will return configs by taking in the data required to do so as inputs, which is just the address of the respective price feed

// for now we need one,but what if we need a ton stuff in here like vrf address, gas price and others later. so its best to create custom data types for this which can be updated later.

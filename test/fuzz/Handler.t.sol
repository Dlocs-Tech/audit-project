// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {EnumerableSet} from "@openzeppelin/utils/structs/EnumerableSet.sol";

import {StakingDiamond} from "../../src/StakingDiamond.sol";
import {StakingFacet} from "../../src/facets/StakingFacet.sol";
import {TimestampStore} from "./store/TimestampStore.t.sol";

contract Handler is Test {
    using EnumerableSet for EnumerableSet.AddressSet;

    // Deployed contracts to interact with
    StakingDiamond public diamond;

    // Track time
    TimestampStore public timestampStore;

    constructor(StakingDiamond _diamond, TimestampStore _timestampStore) {
        diamond = _diamond;
        timestampStore = _timestampStore;
    }

    /////////////////////////////////////////////
    //              Time Updates
    /////////////////////////////////////////////

    /// @dev Simulates the passage of time. The time jump is upper bounded so that streams don't settle too quickly.
    /// See https://github.com/foundry-rs/foundry/issues/4994.
    /// @param timeJumpSeed A fuzzed value needed for generating random time warps.
    modifier advanceTime(uint256 timeJumpSeed) {
        uint256 timeJump = (timeJumpSeed % 600) + 1 minutes;
        timestampStore.increaseCurrentTimestamp(timeJump);
        vm.warp(timestampStore.currentTimestamp());
        _;
    }

    /////////////////////////////////////////////
    //              Staking Facet
    /////////////////////////////////////////////

    function migrateFrens(uint seed) public advanceTime(seed) {
        address user = _getUserFromSeed(seed);
        address targetAccount = _getUserFromSeed(seed / 2);

        vm.startPrank(user);
        StakingFacet(address(diamond)).migrateFrens(targetAccount);
        vm.stopPrank();
    }

    /////////////////////////////////////////////
    //              Helpers
    /////////////////////////////////////////////
    function _getUserFromSeed(uint256 userSeed) public pure returns (address) {
        return address(uint160(userSeed % 5) + 1);
    }
}

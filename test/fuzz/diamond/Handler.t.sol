// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {EnumerableSet} from "@openzeppelin/utils/structs/EnumerableSet.sol";

import {StakingDiamond} from "../../../src/StakingDiamond.sol";
import {StakingFacet, IERC20} from "../../../src/facets/StakingFacet.sol";
import {OwnershipFacet} from "../../../src/facets/OwnershipFacet.sol";
import {TimestampStore} from "./store/TimestampStore.t.sol";

contract Handler is Test {
    using EnumerableSet for EnumerableSet.AddressSet;

    /// @dev Deployed contracts to interact with
    StakingDiamond public diamond;

    /// @dev Track time
    TimestampStore public timestampStore;

    /// @dev  ERC20 token to stake
    address public stakingToken;

    /// @dev Ghost Variables
    uint public totalClaims;
    uint public totalStakes;
    uint public totalWithdrawals;

    constructor(
        StakingDiamond _diamond,
        TimestampStore _timestampStore,
        address _stakingToken
    ) {
        diamond = _diamond;
        timestampStore = _timestampStore;

        stakingToken = _stakingToken;

        address owner = OwnershipFacet(address(diamond)).owner();
        vm.startPrank(owner);
        StakingFacet(address(diamond)).updatePoolTokenContract(stakingToken);
        OwnershipFacet(address(diamond)).transferOwnership(address(1));
        vm.stopPrank();
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

    function updateAccounts(uint seed) public advanceTime(seed) {
        if (seed > type(uint256).max - 2) return;

        address[] memory accounts = new address[](3);
        accounts[0] = _getUserFromSeed(seed);
        accounts[1] = _getUserFromSeed(seed + 1);
        accounts[2] = _getUserFromSeed(seed + 2);

        vm.startPrank(accounts[0]);
        if (accounts[0] != address(1)) vm.expectRevert();
        StakingFacet(address(diamond)).updateAccounts(accounts);
        vm.stopPrank();
    }

    function claimTickets(uint seed) public advanceTime(seed) {
        address user = _getUserFromSeed(seed);

        uint[] memory ids = new uint[](6);
        uint[] memory values = new uint[](6);

        uint totalFrens;

        for (uint i = 0; i < values.length; i++) {
            values[i] = seed % (27 - i * 5); // id=5 gets max 1 ticket and id=0 gets max 27 tickets
            ids[i] = i;

            totalFrens +=
                StakingFacet(address(diamond)).ticketCost(i) *
                values[i];
        }

        if (totalFrens <= StakingFacet(address(diamond)).frens(user)) {
            vm.startPrank(user);
            StakingFacet(address(diamond)).claimTickets(ids, values);
            vm.stopPrank();

            totalClaims++;
        }
    }

    function migrateFrens(uint seed) public advanceTime(seed) {
        address user = _getUserFromSeed(seed);
        address targetAccount = _getUserFromSeed(seed / 2);

        vm.startPrank(user);
        StakingFacet(address(diamond)).migrateFrens(targetAccount);
        vm.stopPrank();
    }

    function stakePoolTokens(uint seed) public advanceTime(seed) {
        address user = _getUserFromSeed(seed);

        uint256 amount = _bound(seed, 1, 100_000 ether);

        deal(stakingToken, user, amount);

        vm.startPrank(user);
        IERC20(stakingToken).approve(address(diamond), amount);
        StakingFacet(address(diamond)).stakePoolTokens(amount);
        vm.stopPrank();

        totalStakes++;
    }

    function withdrawPoolStake(uint seed) public advanceTime(seed) {
        address user = _getUserFromSeed(seed);

        uint balance = StakingFacet(address(diamond)).staked(user);

        uint256 amount = _bound(seed, 0, balance);

        vm.startPrank(user);
        StakingFacet(address(diamond)).withdrawPoolStake(amount);
        vm.stopPrank();

        totalWithdrawals++;
    }

    /////////////////////////////////////////////
    //              Helpers
    /////////////////////////////////////////////

    /// @dev get user address 1-5
    function _getUserFromSeed(uint256 userSeed) public pure returns (address) {
        return address(uint160(userSeed % 5) + 1);
    }
}

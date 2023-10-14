// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {StakingDiamond} from "../../src/StakingDiamond.sol";
import {StakingFacet} from "../../src/facets/StakingFacet.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {DeployDiamond} from "../../script/DeployDiamond.s.sol";
import {Handler} from "./Handler.t.sol";
import {TimestampStore} from "./store/TimestampStore.t.sol";
import {console} from "forge-std/console.sol";

contract StopOnRevertInvariants is StdInvariant, Test {
    StakingDiamond public diamond;
    HelperConfig public helperConfig;
    TimestampStore internal timestampStore;

    Handler public handler;

    address stakingToken;

    /*//////////////////////////////////////////////////////////////////////////
                                     MODIFIERS
    //////////////////////////////////////////////////////////////////////////*/

    modifier useCurrentTimestamp() {
        vm.warp(timestampStore.currentTimestamp());
        _;
    }

    /*//////////////////////////////////////////////////////////////////////////
                                     SETUP
    //////////////////////////////////////////////////////////////////////////*/

    function setUp() external {
        timestampStore = new TimestampStore();

        DeployDiamond deployer = new DeployDiamond();
        (diamond, stakingToken) = deployer.run();

        console.log("diamond: %s", address(diamond));

        handler = new Handler(diamond, timestampStore, stakingToken);
        targetContract(address(handler));
    }

    /*//////////////////////////////////////////////////////////////////////////
                                     INVARIANTS
    //////////////////////////////////////////////////////////////////////////*/

    // function invariant_xxxx() public useCurrentTimestamp {}

    function invariant_gettersCantRevert() public useCurrentTimestamp {
        StakingFacet(address(diamond)).poolTokensRate();
        StakingFacet(address(diamond)).frens(msg.sender);

        address[] memory accounts = new address[](3);
        accounts[0] = address(0);
        accounts[1] = address(1);
        accounts[2] = address(2);

        StakingFacet(address(diamond)).bulkFrens(accounts);
        StakingFacet(address(diamond)).staked(msg.sender);
        StakingFacet(address(diamond)).ticketCost(0);
    }
}

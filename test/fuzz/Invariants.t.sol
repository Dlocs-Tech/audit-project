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

    /*//////////////////////////////////////////////////////////////////////////
                                     MODIFIERS
    //////////////////////////////////////////////////////////////////////////*/

    modifier useCurrentTimestamp() {
        vm.warp(timestampStore.currentTimestamp());
        _;
    }

    function setUp() external {
        timestampStore = new TimestampStore();

        DeployDiamond deployer = new DeployDiamond();
        (diamond) = deployer.run();

        handler = new Handler(diamond, timestampStore);
        // targetContract(address(handler));
        targetContract(address(diamond));
    }

    // function invariant_xxxx() public useCurrentTimestamp {}

    function invariant_gettersCantRevert() public useCurrentTimestamp {
        StakingFacet(address(diamond)).poolTokensRate();
    }
}

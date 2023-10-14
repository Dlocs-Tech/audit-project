// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * \
 * Authors: Timo Neumann <timo@fyde.fi>, Rohan Sundar <rohan@fyde.fi>
 * EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
 *
 * Script to deploy template diamond with Cut, Loupe and facets
 * /*****************************************************************************
 */

import "forge-std/Script.sol";
import {StakingDiamond} from "../src/StakingDiamond.sol";
import {DiamondCutFacet} from "../src/facets/DiamondCutFacet.sol";
import {DiamondLoupeFacet} from "../src/facets/DiamondLoupeFacet.sol";
import {OwnershipFacet} from "../src/facets/OwnershipFacet.sol";
import {StakingFacet} from "../src/facets/StakingFacet.sol";
import {TicketsFacet} from "../src/facets/TicketsFacet.sol";
import {IDiamondCut} from "../src/interfaces/IDiamondCut.sol";
import {HelperContract} from "../test/HelperContract.t.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployDiamond is Script, HelperContract {
    uint256 public DEFAULT_ANVIL_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    function run() external returns (StakingDiamond diamond) {
        HelperConfig helperConfig = new HelperConfig();
        (uint256 deployerKey, ) = helperConfig.activeNetworkConfig();

        vm.startBroadcast(deployerKey);

        //deploy facets and init contract
        DiamondCutFacet dCutF = new DiamondCutFacet();
        DiamondLoupeFacet dLoupeF = new DiamondLoupeFacet();
        OwnershipFacet ownerF = new OwnershipFacet();
        StakingFacet stakingF = new StakingFacet();
        TicketsFacet ticketsF = new TicketsFacet();

        // diamod arguments
        StakingDiamond.ConstructorArgs memory _args = StakingDiamond
            .ConstructorArgs({owner: msg.sender});

        // FacetCut array which contains the three standard facets to be added
        FacetCut[] memory cut = new FacetCut[](5);

        cut[0] = FacetCut({
            facetAddress: address(dCutF),
            action: FacetCutAction.Add,
            functionSelectors: generateSelectors("DiamondCutFacet")
        });

        cut[1] = (
            FacetCut({
                facetAddress: address(dLoupeF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("DiamondLoupeFacet")
            })
        );

        cut[2] = (
            FacetCut({
                facetAddress: address(ownerF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("OwnershipFacet")
            })
        );

        cut[3] = (
            FacetCut({
                facetAddress: address(stakingF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("StakingFacet")
            })
        );

        cut[4] = (
            FacetCut({
                facetAddress: address(ticketsF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("TicketsFacet")
            })
        );

        // deploy diamond
        diamond = new StakingDiamond(cut, _args);

        vm.stopBroadcast();
    }
}

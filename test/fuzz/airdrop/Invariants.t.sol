// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.18;

import { Test } from "forge-std/Test.sol";
import { Airdrop } from "../../../src/Airdrop.sol";
import { MockERC20 } from "../../mocks/MockERC20.sol";

contract AirdropTest is Test {
    Airdrop public airdrop;
    MockERC20 public mockToken; 

    uint256 constant public MAX_UINT_TYPE = type(uint256).max;

    function setUp() public {
        airdrop = new Airdrop();
        mockToken = new MockERC20();
    }

    function tokens_distribution(address[] memory _recivers, uint8[] memory _amounts) public {
        mockToken.approve(address(airdrop), MAX_UINT_TYPE);

        if (_recivers.length != _amounts.length) {
            return;
        }

        uint256[] memory _parsedAmounts = new uint256[](_amounts.length);

        for (uint256 i; i < _amounts.length;) {
            _parsedAmounts[i] = uint256(_amounts[i]);
            unchecked {
                i++;
            }
        }

        airdrop.airdropToken(address(mockToken), _recivers, _parsedAmounts);

        for (uint256 i; i < _recivers.length;) {
            uint256 balance = mockToken.balanceOf(_recivers[i]);
            assertTrue(balance == _amounts[i], "balance should be equal to amount");
            unchecked {
                i++;
            }
        }
    }
}
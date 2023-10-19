// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.18;

import { Test } from "forge-std/Test.sol";
import { Airdrop } from "../../../src/Airdrop.sol";
import { MockERC20 } from "../../mocks/MockERC20.sol";

contract AirdropTest is Test {
    Airdrop public airdrop;
    MockERC20 public mockToken;

    function setUp() public {
        airdrop = new Airdrop();
        mockToken = new MockERC20();
    }

    function test_tokens_distribution(address[] memory _recivers, uint8[] memory _amounts) public {
        if (_recivers.length != _amounts.length) {
            return;
        }

        uint256 _totalAmountToApprove;
        uint256[] memory _parsedAmounts = new uint256[](_amounts.length);

        for (uint256 i; i < _amounts.length;) {
            _parsedAmounts[i] = uint256(_amounts[i]);
            unchecked {
                _totalAmountToApprove += _parsedAmounts[i];
                i++;
            }
        }

        mockToken.approve(address(airdrop), _totalAmountToApprove);
        airdrop.airdropToken(address(mockToken), _recivers, _parsedAmounts);

        for (uint256 i; i < _recivers.length;) {
            uint256 balance = mockToken.balanceOf(_recivers[i]);
            assertTrue(balance == _amounts[i], "balance should be equal to amount");
            unchecked {
                i++;
            }
        }
    }

    function test_native_distribution(address payable[] memory _recivers, uint8[] memory _amounts) public payable {
        if (_recivers.length != _amounts.length) {
            return;
        }

        uint256 _totalAmountToDistribute;
        uint256[] memory _parsedAmounts = new uint256[](_amounts.length);

        for (uint256 i; i < _amounts.length;) {
            _parsedAmounts[i] = uint256(_amounts[i]);
            unchecked {
                _totalAmountToDistribute += _parsedAmounts[i];
                i++;
            }
        }

        assertTrue(_totalAmountToDistribute == msg.value, "balance provided should be equal to amount to distribute");
        airdrop.airdropMatic(_recivers, _parsedAmounts);

        for (uint256 i; i < _recivers.length;) {
            uint256 balance = mockToken.balanceOf(_recivers[i]);
            assertTrue(balance == _amounts[i], "balance should be equal to amount");
            unchecked {
                i++;
            }
        }
    }
}
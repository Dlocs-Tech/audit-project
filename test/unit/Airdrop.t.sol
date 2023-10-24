// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";
import {Airdrop} from "../../src/Airdrop.sol";
import {MockERC20} from "../mocks/MockERC20.sol";

contract AirdropTest is Test {
    Airdrop public airdrop;
    MockERC20 public mockToken;

    function setUp() public {
        airdrop = new Airdrop();
        mockToken = new MockERC20();
    }

    function test_tokens_distribution(bytes32[] memory seeds) public {
        uint256 _totalAmountToApprove;
        uint256[] memory _amounts = new uint256[](seeds.length);
        address[] memory _receivers = new address[](seeds.length);

        for (uint256 i; i < seeds.length; ) {
            _amounts[i] = _bound(uint(seeds[i]), 0, 1 ether); // 0 - 1 ether airdrop
            _receivers[i] = address(uint160(uint(seeds[i])) + 1);
            unchecked {
                _totalAmountToApprove += _amounts[i];
                i++;
            }
        }

        deal(address(mockToken), tx.origin, _totalAmountToApprove);

        vm.startPrank(tx.origin);

        mockToken.approve(address(airdrop), _totalAmountToApprove);
        airdrop.airdropToken(address(mockToken), _receivers, _amounts);

        vm.stopPrank();

        for (uint256 i; i < _receivers.length; ) {
            uint256 balance = mockToken.balanceOf(_receivers[i]);

            // Addresses can be repeated, so balance wont match the amount
            assertGe(balance, _amounts[i], "balance should be equal to amount");
            unchecked {
                i++;
            }
        }
    }

    function test_native_distribution(
        address payable[] memory _receivers,
        uint8[] memory _amounts
    ) public payable {
        if (_receivers.length != _amounts.length) {
            return;
        }

        uint256 _totalAmountToDistribute;
        uint256[] memory _parsedAmounts = new uint256[](_amounts.length);

        for (uint256 i; i < _amounts.length; ) {
            _parsedAmounts[i] = uint256(_amounts[i]);
            unchecked {
                _totalAmountToDistribute += _parsedAmounts[i];
                i++;
            }
        }

        // assertEq(
        //     _totalAmountToDistribute,
        //     msg.value,
        //     "balance provided should be equal to amount to distribute"
        // );

        vm.prank(tx.origin);
        airdrop.airdropMatic{value: _totalAmountToDistribute}(
            _receivers,
            _parsedAmounts
        );

        for (uint256 i; i < _receivers.length; ) {
            assertEq(
                _receivers[i].balance,
                _amounts[i],
                "balance should be equal to amount"
            );
            unchecked {
                i++;
            }
        }
    }
}

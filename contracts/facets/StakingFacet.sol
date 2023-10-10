// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/AppStorage.sol";
import "../libraries/LibDiamond.sol";
import "../interfaces/IERC20.sol";
import "../interfaces/IERC1155TokenReceiver.sol";

contract StakingFacet {
    AppStorage internal s;
    bytes4 internal constant ERC1155_BATCH_ACCEPTED = 0xbc197c81; // Return value from `onERC1155BatchReceived` call if a contract accepts receipt (i.e `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))).
    
    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values); // Event emitted when a batch of tokens is transferred
    event Transfer(address indexed _from, address indexed _to, uint256 _value); // Event emitted when a single token is transferred
    event PoolTokensRate(uint256 _newRate); // Event emitted when the pool tokens rate is updated

    // ISSUE: Integer Underflow/Overflow: The code uses simple arithmetic operations without using SafeMath library, which could lead to integer underflow/overflow vulnerabilities.
    function frens(address _account) public view returns (uint256 frens_) {
        Account storage account = s.accounts[_account]; // Get the account for the specified address
        uint256 timePeriod = block.timestamp - account.lastFrensUpdate; // Calculate the time period since the last update
        frens_ = account.frens; // Get the current frens balance for the account
        frens_ += ((account.poolTokens * s.poolTokensRate) * timePeriod) / 24 hours; // Calculate the frens earned during the time period and add it to the current balance
    }

    function bulkFrens(address[] calldata _accounts) external view returns (uint256[] memory frens_) {
        frens_ = new uint256[](_accounts.length); // Create a new array to store the frens balances
        for (uint256 i; i < _accounts.length; i++) {
            frens_[i] = frens(_accounts[i]); // Get the frens balance for each account and store it in the array
        }
    }

    // ISSUE: Lack of Access Control: There is no access control mechanism to restrict the execution of certain functions to specific users or roles. This could lead to unauthorized access or manipulation of the contract state.
    // ISSUE: Reentrancy: The code uses external contract calls without checking for reentrancy vulnerabilities. This could allow an attacker to repeatedly call the same function and drain the contract's funds.
    function updateFrens() internal {        
        Account storage account = s.accounts[msg.sender]; // Get the account for the sender's address
        account.frens = frens(msg.sender); // Update the sender's frens balance
        account.lastFrensUpdate = uint40(block.timestamp); // Update the timestamp for the last frens update
    }

    // ISSUE: Unchecked Return Values: The code uses external contract calls without checking the return values, which could lead to unexpected behavior if the external call fails for some reason.
    function updateAccounts(address[] calldata _accounts) external {
        LibDiamond.enforceIsContractOwner(); // Check that the sender is the contract owner
        for (uint256 i; i < _accounts.length; i++) {
            address accountAddress = _accounts[i];
            Account storage account = s.accounts[accountAddress];
            account.frens = frens(accountAddress); // Update the frens balance for each account
            account.lastFrensUpdate = uint40(block.timestamp); // Update the timestamp for the last frens update for each account
        }
    }

    // ISSUE: Front Running: The code uses the block.timestamp variable to calculate time periods, which could be manipulated by miners to front run transactions.
    function setPoolTokensRate(uint256 _newRate) external {
        LibDiamond.enforceIsContractOwner(); // Check that the sender is the contract owner
        s.poolTokensRate = _newRate; // Set the new pool tokens rate
        emit PoolTokensRate(_newRate); // Emit an event to signal that the pool tokens rate has been updated
    }
}


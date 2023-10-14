// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/AppStorage.sol";
import "../libraries/LibDiamond.sol";
import "../interfaces/IERC20.sol";
import "../interfaces/IERC1155TokenReceiver.sol";

contract StakingFacet {
    AppStorage internal s;
    bytes4 internal constant ERC1155_BATCH_ACCEPTED = 0xbc197c81; // Return value from `onERC1155BatchReceived` call if
    // a contract accepts receipt (i.e
    // `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`).

    event TransferBatch(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256[] _ids,
        uint256[] _values
    );
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event PoolTokensRate(uint256 _newRate);
    event PoolTokensAddress(address _newPoolContract);

    function frens(address _account) public view returns (uint256 frens_) {
        Account storage account = s.accounts[_account];
        uint256 timePeriod = block.timestamp - account.lastFrensUpdate;
        frens_ = account.frens;
        frens_ +=
            ((account.poolTokens * s.poolTokensRate) * timePeriod) /
            24 hours;
    }

    function bulkFrens(
        address[] calldata _accounts
    ) external view returns (uint256[] memory frens_) {
        frens_ = new uint256[](_accounts.length);
        for (uint256 i; i < _accounts.length; i++) {
            frens_[i] = frens(_accounts[i]);
        }
    }

    function updateFrens() internal {
        Account storage account = s.accounts[msg.sender];
        account.frens = frens(msg.sender);
        account.lastFrensUpdate = uint40(block.timestamp);
    }

    function updateAccounts(address[] calldata _accounts) external {
        LibDiamond.enforceIsContractOwner();
        for (uint256 i; i < _accounts.length; i++) {
            address accountAddress = _accounts[i];
            Account storage account = s.accounts[accountAddress];
            account.frens = frens(accountAddress);
            account.lastFrensUpdate = uint40(block.timestamp);
        }
    }

    // @audit-issue this function did not exist, so pool contract could not be set
    function updatePoolTokenContract(address _newPoolContract) external {
        LibDiamond.enforceIsContractOwner();
        s.poolContract = _newPoolContract;
        emit PoolTokensAddress(_newPoolContract);
    }

    // @audit-issue this function did not exist, so pool contract could not be set
    function getPoolContract() external view returns (address) {
        return s.poolContract;
    }

    // Used to change the rate of frens produced
    function updatePoolTokensRate(uint256 _newRate) external {
        LibDiamond.enforceIsContractOwner();
        s.poolTokensRate = _newRate;
        emit PoolTokensRate(_newRate);
    }

    function poolTokensRate() external view returns (uint256) {
        return s.poolTokensRate;
    }

    // Transfer all frens from user's account to another account
    function migrateFrens(address _otherAccount) external {
        Account storage account = s.accounts[tx.origin];
        Account storage otherAccount = s.accounts[_otherAccount];
        otherAccount.frens += account.frens;
        account.frens = 0;
        account.lastFrensUpdate = uint40(block.timestamp);
    }

    function stakePoolTokens(uint256 _poolTokens) external {
        updateFrens();
        Account storage account = s.accounts[msg.sender];
        account.poolTokens += _poolTokens;
        IERC20(s.poolContract).transferFrom(
            msg.sender,
            address(this),
            _poolTokens
        );
    }

    function staked(
        address _account
    ) external view returns (uint256 poolTokens_) {
        poolTokens_ = s.accounts[_account].poolTokens;
    }

    function withdrawPoolStake(uint256 _poolTokens) external {
        updateFrens();
        uint256 accountPoolTokens = s.accounts[msg.sender].poolTokens;
        require(
            accountPoolTokens >= _poolTokens,
            "Can't withdraw more poolTokens than in account"
        );
        s.accounts[msg.sender].poolTokens = accountPoolTokens - _poolTokens;
        IERC20(s.poolContract).transfer(msg.sender, _poolTokens);
    }

    function claimTickets(
        uint256[] calldata _ids,
        uint256[] calldata _values
    ) external {
        require(
            _ids.length == _values.length,
            "Staking: _ids not the same length as _values"
        );
        updateFrens();
        uint256 frensBal = s.accounts[msg.sender].frens;
        // gas optimization
        unchecked {
            for (uint256 i; i < _ids.length; i++) {
                uint256 id = _ids[i];
                uint256 value = _values[i];
                require(id < 6, "Staking: Ticket not found");
                uint256 l_ticketCost = ticketCost(id);
                uint256 cost = l_ticketCost * value;
                require(frensBal >= cost, "Staking: Not enough frens points");
                frensBal -= cost;
                s.tickets[id].accountBalances[msg.sender] += value;
                s.tickets[id].totalSupply += value;
            }
        }
        s.accounts[msg.sender].frens = frensBal;
        emit TransferBatch(msg.sender, address(0), msg.sender, _ids, _values);
        uint256 size;
        address sender = msg.sender;
        assembly {
            size := extcodesize(sender)
        }
        if (size > 0) {
            require(
                ERC1155_BATCH_ACCEPTED ==
                    IERC1155TokenReceiver(msg.sender).onERC1155BatchReceived(
                        msg.sender,
                        address(0),
                        _ids,
                        _values,
                        new bytes(0)
                    ),
                "Staking: Ticket transfer rejected/failed"
            );
        }
    }

    function ticketCost(uint256 _id) public pure returns (uint256 _frensCost) {
        if (_id == 0) {
            _frensCost = 50e18;
        } else if (_id == 1) {
            _frensCost = 250e18;
        } else if (_id == 2) {
            _frensCost = 500e18;
        } else if (_id == 3) {
            _frensCost = 2_500e18;
        } else if (_id == 4) {
            _frensCost = 10_000e18;
        } else if (_id == 5) {
            _frensCost = 50_000e18;
        } else {
            revert("Staking: _id does not exist");
        }
    }
}

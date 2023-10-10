// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IERC20.sol";

contract Airdrop {
    function airdropToken(
        address _token,
        address[] calldata _receivers,
        uint256[] calldata _amounts
    ) external {
        require(_receivers.length == _amounts.length, "_receivers.length not the same as _amounts.length");        
        for (uint256 i; i < _receivers.length; i++) {
          // ISSUE: some erc20 like (usdt) dont fullfille the standard and dont return a boolean so it could fail. 
          // TODO: replace IERC20 for SafeERC  

          // ISSUE: tx.origin could be manipulated by attackers to perform unauthorized actions
          // INFO: it returns the address of the original sender of a transaction, which may not be the same as the immediate sender of the transaction. This means that if a contract relies on tx.origin to authenticate the sender of a transaction, an attacker could manipulate this value by using a proxy contract or other means to send a transaction with a different tx.origin value.
          // TODO: use msg.sender

          // ISSUE: have external call on a loop could cause gas exhaustion and it could be used by attacker to perform reentrancy vulnerability
          // TODO: for reentrancy: add nonReentrancy modifier. for ags cost: could add a limit of length

            require(IERC20(_token).transferFrom(tx.origin, _receivers[i], _amounts[i]), "Token send failed");
        }
    }

    function airdropMatic(address payable[] calldata _receivers, uint256[] calldata _amounts) external payable {
        require(_receivers.length == _amounts.length, "_receivers.length not the same as _amounts.length");
        for (uint256 i; i < _receivers.length; i++) {
          // ISSUE: is deprecated and you dont have protection about how much and to who you are sending
          // TODO: Add access control and replace transfer for send ot low level call  
            _receivers[i].transfer(_amounts[i]);
        }
    }
}

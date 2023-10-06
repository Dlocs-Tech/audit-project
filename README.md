# Audit Test Instructions

This test audit is done to evaulate your ability in the following areas: 

1. How well you know Solidity.
2. How well you understand state variable layout management in Solidity and proxy contracts.
3. How well you can understand the logic of an existing smart contract system.
4. How well you can research and learn.
5. How well you can find smart contract bugs and security vulnerabilities.
6. How clearly you can communicate and professionally present your findings and recommendations.
7. How well you can follow instructions.

Note that for this test you can use resources on the Internet for help.
Some resources: 
* https://eips.ethereum.org/EIPS/eip-2535
* https://eip2535diamonds.substack.com/
* https://dev.to/mudgen
* https://eip2535diamonds.substack.com/p/introduction-to-the-diamond-standard
* https://github.com/mudgen/awesome-diamonds
* https://google.com
* https://eips.ethereum.org/EIPS/eip-721
* https://eips.ethereum.org/EIPS/eip-1155
* Other resources you find

### Time Limit

There is no time limit on the test, but the sooner it is done the sooner it can be evaulated.

## Part 1
1. Fork this private repo. Add mudgen and nesbitta to your version of the private repo. Do all the activity/work in your private repo.
1. Go to Settings in your private repo and turn on Issues.
1. Create and use the following Issue labels:
    * High Risk (red)
    * Medium Risk (brown)
    * Low Risk (yellow)
    * Informational (blue)    

1. Audit the following Solidity files:
    * [StakingFacet.sol](contracts/facets/StakingFacet.sol)
    * [TicketsFacet.sol](contracts/facets/TicketsFacet.sol)
    * [Airdop.sol](contracts/Airdop.sol)
    * [StakingDiamond.sol](contracts/StakingDiamond.sol)
    * [AppStorage.sol](contracts/libraries/AppStorage.sol)
    * [LibStrings.sol](contracts/libraries/LibStrings.sol)

    Ignore the rest of the Solidity files for this audit. You do not need to look at the source code for any other Solidity files than these that are listed.
    
    Find and report any/all bugs and security vulnerabilities. Find and report any code or gas deficiencies.
    
    For each issue found create a separate issue in your private repo. Give a clear description of what the concern/issue is and give a recommendation on how to fix it. Use the issue labels. Your issues should look good, be properly formatted and be easy to read. 
    
## Part 2

Create the file `ERC721Facet.sol` in the `facets` directory and implement ERC721. This should be your own implementation, do not copy someone elses. This facet should work correctly with the [StakingDiamond](contracts/StakingDiamond.sol). Add it to the [deploy.js](scripts/deploy.js) file so that it gets deployed as part of the StakingDiamond.

Add an external function to `ERC721Facet.sol` that enables someone to purchase ERC721 tokens with tickets that are implemented in `TicketsFacet.sol`.

Any new state variables you want to add may not be added to the existing AppStorage struct and may not be added to the Account and Ticket structs. There is no reason for this condition other than to test your ability to find a good solution that works. Also, your solution should not prevent adding new state variables to the AppStorage struct in future upgrades.

`ERC721Facet.sol` should work and have no bugs or security vulnerabilities. 

# Passing Standard

*To **pass this test** you must show excellence and professionalism. Also you must find and report all major bugs and security vulnerabilities. You must write clearly, with enough detail about what is wrong and possible solutions. The issues must look good and be easy to read. The titles of the issues must make clear what the issues are about. Your custom ERC721 facet must work and the diamond must fully implement ERC721. Your deployment of the diamond with the new ERC721 facet must deploy successfully. Both Part 1 and Part 2 need to be completed to pass the test.*

While finding bugs and security vulnerabilities is critical, another very important aspect of any audit report is how well written the report is. The purpose of an audit report is to help the client. An item in an audit should be written in such a way that it clearly describes what the bug or security vulnerability is. It should also make clear how the bug or vulnerability applies specifically to the client's code base. If the bug or vulnerability can be used to steal or reduce the value of assets or anything else bad then the issues should explain how it can be done with the client's code base. The severity of the issue should be made clear to the client by the description of the bad thing(s) that can be done that is relevant to the client's specific code base. Sometimes giving a simple step by step example can help do that. The description of an issue in an audit shouldn't include unnecessary data that won't help the client and it should not omit useful data that would help the client or cause the client additional work to find out. The best audit report is one that helps the client the most. As much as possible a report should give specifics and avoid generalities like "many", "some", "often" etc.

Most people that have taken this test have not passed. We only hire smart contract auditors that do a thorough job. Attention to details matters in smart contract auditing and this test shows your attention to details or not. Do this test like it is a real smart contract audit for a real client. This test proves to us what you can do.

## Common ways people fail the test
1. Missed a bug or security vulnerability.
2. Said something technically incorrect in an issue.
3. Created an irrelevant/unimportant/unnecessary issue. For example an issue about something that is a developer preference.
4. Did not follow or violated the test instructions in some way.
5. Deployment fails.
6. One or more issues were not well written or professional looking.
7. Contract storage not handled correctly in the ERC721Facet as per test instructions.

# Advice

Advice on how to write a great audit report is here: [How to Write a Great Audit Report](https://perfectabstractions.slab.com/public/posts/how-to-write-a-great-audit-report-2oj0sxv3)

# Project Info

These contracts use [EIP-2535 Diamond Standard](https://eips.ethereum.org/EIPS/eip-2535).

Uses the [diamond-1](https://github.com/mudgen/diamond-1) implementation of EIP-2535 Diamond Standard, but is updated to use Solidity 0.8.

Note that the most recent EIP2535 Diamond reference implementations are here https://github.com/mudgen/diamond.  Note that their deployment is a little different than this project.

### Overview

This repository implements `contracts/StakingDiamond.sol`. This is a diamond that utilizes the facets found in `contracts/facets/`.

`TicketsFacet.sol` implements simple ERC1155 token functionality. The ERC1155 tokens are called 'tickets'. There are six different kinds of 'tickets'.

 `StakingFacet.sol` implements functions that enable people to stake [Uniswap V2 pool/pair tokens](https://docs.uniswap.org/protocol/V2/reference/smart-contracts/pair-erc-20). Staking these earns people frens or frens points which are a non-transferable points system. The frens points are calculated with the `frens` function. The `claimTickets` function enables people to claim or mint up to six different kinds of tokens.  Each different ticket kind has a different frens price which is specified in the `ticketCost` function.
 
 Diamonds are used to organize smart contract functionality in a modular and flexible way, and they are used for upgradeable systems and they overcome the max-contract size limitation. 

`StakingDiamond` is deployed using the `scripts/deploy.js` script.




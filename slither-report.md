Summary
 - [arbitrary-send-erc20](#arbitrary-send-erc20) (1 results) (High)
 - [arbitrary-send-eth](#arbitrary-send-eth) (1 results) (High)
 - [encode-packed-collision](#encode-packed-collision) (1 results) (High)
 - [tx-origin](#tx-origin) (1 results) (Medium)
 - [calls-loop](#calls-loop) (2 results) (Low)
 - [assembly](#assembly) (8 results) (Informational)
 - [dead-code](#dead-code) (1 results) (Informational)
 - [solc-version](#solc-version) (20 results) (Informational)
 - [low-level-calls](#low-level-calls) (1 results) (Informational)
 - [missing-inheritance](#missing-inheritance) (1 results) (Informational)
 - [naming-convention](#naming-convention) (57 results) (Informational)
 - [similar-names](#similar-names) (1 results) (Informational)
 - [unused-state](#unused-state) (1 results) (Informational)
## arbitrary-send-erc20
Impact: High
Confidence: High
 - [ ] ID-0
[Airdrop.airdropToken(address,address[],uint256[])](contracts/Airdrop.sol#L7-L16) uses arbitrary from in transferFrom: [require(bool,string)(IERC20(_token).transferFrom(tx.origin,_receivers[i],_amounts[i]),Token send failed)](contracts/Airdrop.sol#L14)

contracts/Airdrop.sol#L7-L16


## arbitrary-send-eth
Impact: High
Confidence: Medium
 - [ ] ID-1
[Airdrop.airdropMatic(address[],uint256[])](contracts/Airdrop.sol#L18-L23) sends eth to arbitrary user
	Dangerous calls:
	- [_receivers[i].transfer(_amounts[i])](contracts/Airdrop.sol#L21)

contracts/Airdrop.sol#L18-L23


## encode-packed-collision
Impact: High
Confidence: High
 - [ ] ID-2
[TicketsFacet.uri(uint256)](contracts/facets/TicketsFacet.sol#L23-L26) calls abi.encodePacked() with multiple dynamic arguments:
	- [string(abi.encodePacked(s.ticketsBaseUri,LibStrings.uintStr(_id)))](contracts/facets/TicketsFacet.sol#L25)

contracts/facets/TicketsFacet.sol#L23-L26


## tx-origin
Impact: Medium
Confidence: Medium
 - [ ] ID-3
[Airdrop.airdropToken(address,address[],uint256[])](contracts/Airdrop.sol#L7-L16) uses tx.origin for authorization: [require(bool,string)(IERC20(_token).transferFrom(tx.origin,_receivers[i],_amounts[i]),Token send failed)](contracts/Airdrop.sol#L14)

contracts/Airdrop.sol#L7-L16


## calls-loop
Impact: Low
Confidence: Medium
 - [ ] ID-4
[Airdrop.airdropToken(address,address[],uint256[])](contracts/Airdrop.sol#L7-L16) has external calls inside a loop: [require(bool,string)(IERC20(_token).transferFrom(tx.origin,_receivers[i],_amounts[i]),Token send failed)](contracts/Airdrop.sol#L14)

contracts/Airdrop.sol#L7-L16


 - [ ] ID-5
[Airdrop.airdropMatic(address[],uint256[])](contracts/Airdrop.sol#L18-L23) has external calls inside a loop: [_receivers[i].transfer(_amounts[i])](contracts/Airdrop.sol#L21)

contracts/Airdrop.sol#L18-L23


## assembly
Impact: Informational
Confidence: High
 - [ ] ID-6
[TicketsFacet.safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)](contracts/facets/TicketsFacet.sol#L85-L117) uses assembly
	- [INLINE ASM](contracts/facets/TicketsFacet.sol#L108-L110)

contracts/facets/TicketsFacet.sol#L85-L117


 - [ ] ID-7
[LibDiamond.enforceHasContractCode(address,string)](contracts/libraries/LibDiamond.sol#L152-L158) uses assembly
	- [INLINE ASM](contracts/libraries/LibDiamond.sol#L154-L156)

contracts/libraries/LibDiamond.sol#L152-L158


 - [ ] ID-8
[DiamondLoupeFacet.facetFunctionSelectors(address)](contracts/facets/DiamondLoupeFacet.sol#L78-L96) uses assembly
	- [INLINE ASM](contracts/facets/DiamondLoupeFacet.sol#L93-L95)

contracts/facets/DiamondLoupeFacet.sol#L78-L96


 - [ ] ID-9
[TicketsFacet.safeTransferFrom(address,address,uint256,uint256,bytes)](contracts/facets/TicketsFacet.sol#L42-L67) uses assembly
	- [INLINE ASM](contracts/facets/TicketsFacet.sol#L58-L60)

contracts/facets/TicketsFacet.sol#L42-L67


 - [ ] ID-10
[DiamondLoupeFacet.facetAddresses()](contracts/facets/DiamondLoupeFacet.sol#L100-L131) uses assembly
	- [INLINE ASM](contracts/facets/DiamondLoupeFacet.sol#L128-L130)

contracts/facets/DiamondLoupeFacet.sol#L100-L131


 - [ ] ID-11
[LibDiamond.diamondStorage()](contracts/libraries/LibDiamond.sol#L27-L32) uses assembly
	- [INLINE ASM](contracts/libraries/LibDiamond.sol#L29-L31)

contracts/libraries/LibDiamond.sol#L27-L32


 - [ ] ID-12
[DiamondLoupeFacet.facets()](contracts/facets/DiamondLoupeFacet.sol#L24-L73) uses assembly
	- [INLINE ASM](contracts/facets/DiamondLoupeFacet.sol#L65-L67)
	- [INLINE ASM](contracts/facets/DiamondLoupeFacet.sol#L70-L72)

contracts/facets/DiamondLoupeFacet.sol#L24-L73


 - [ ] ID-13
[StakingDiamond.fallback()](contracts/StakingDiamond.sol#L60-L80) uses assembly
	- [INLINE ASM](contracts/StakingDiamond.sol#L63-L65)
	- [INLINE ASM](contracts/StakingDiamond.sol#L68-L79)

contracts/StakingDiamond.sol#L60-L80


## dead-code
Impact: Informational
Confidence: Medium
 - [ ] ID-14
[StakingFacet.updateFrens()](contracts/facets/StakingFacet.sol#L34-L38) is never used and should be removed

contracts/facets/StakingFacet.sol#L34-L38


## solc-version
Impact: Informational
Confidence: High
 - [ ] ID-15
Pragma version[^0.8.0](contracts/interfaces/IERC173.sol#L2) allows old versions

contracts/interfaces/IERC173.sol#L2


 - [ ] ID-16
Pragma version[^0.8.0](contracts/interfaces/IERC1155.sol#L2) allows old versions

contracts/interfaces/IERC1155.sol#L2


 - [ ] ID-17
Pragma version[^0.8.0](contracts/interfaces/IERC20.sol#L2) allows old versions

contracts/interfaces/IERC20.sol#L2


 - [ ] ID-18
Pragma version[^0.8.0](contracts/facets/StakingFacet.sol#L2) allows old versions

contracts/facets/StakingFacet.sol#L2


 - [ ] ID-19
Pragma version[^0.8.0](contracts/libraries/LibDiamond.sol#L2) allows old versions

contracts/libraries/LibDiamond.sol#L2


 - [ ] ID-20
Pragma version[^0.8.0](contracts/interfaces/IERC1155TokenReceiver.sol#L2) allows old versions

contracts/interfaces/IERC1155TokenReceiver.sol#L2


 - [ ] ID-21
Pragma version[^0.8.0](contracts/interfaces/IERC165.sol#L2) allows old versions

contracts/interfaces/IERC165.sol#L2


 - [ ] ID-22
Pragma version[^0.8.0](contracts/libraries/AppStorage.sol#L2) allows old versions

contracts/libraries/AppStorage.sol#L2


 - [ ] ID-23
Pragma version[^0.8.0](contracts/Airdrop.sol#L2) allows old versions

contracts/Airdrop.sol#L2


 - [ ] ID-24
Pragma version[^0.8.0](contracts/facets/TicketsFacet.sol#L2) allows old versions

contracts/facets/TicketsFacet.sol#L2


 - [ ] ID-25
Pragma version[^0.8.0](contracts/libraries/LibStrings.sol#L2) allows old versions

contracts/libraries/LibStrings.sol#L2


 - [ ] ID-26
Pragma version[^0.8.0](contracts/StakingDiamond.sol#L2) allows old versions

contracts/StakingDiamond.sol#L2


 - [ ] ID-27
Pragma version[^0.8.0](contracts/facets/DiamondCutFacet.sol#L2) allows old versions

contracts/facets/DiamondCutFacet.sol#L2


 - [ ] ID-28
Pragma version[^0.8.0](contracts/facets/DiamondLoupeFacet.sol#L2) allows old versions

contracts/facets/DiamondLoupeFacet.sol#L2


 - [ ] ID-29
Pragma version[^0.8.0](contracts/interfaces/IDiamondLoupe.sol#L2) allows old versions

contracts/interfaces/IDiamondLoupe.sol#L2


 - [ ] ID-30
Pragma version[^0.8.0](contracts/interfaces/IERC1155Metadata_URI.sol#L2) allows old versions

contracts/interfaces/IERC1155Metadata_URI.sol#L2


 - [ ] ID-31
Pragma version[^0.8.0](contracts/interfaces/IDiamondCut.sol#L2) allows old versions

contracts/interfaces/IDiamondCut.sol#L2


 - [ ] ID-32
Pragma version[^0.8.0](contracts/facets/OwnershipFacet.sol#L2) allows old versions

contracts/facets/OwnershipFacet.sol#L2


 - [ ] ID-33
Pragma version[^0.8.0](contracts/interfaces/IUniswapV2Pair.sol#L2) allows old versions

contracts/interfaces/IUniswapV2Pair.sol#L2


 - [ ] ID-34
solc-0.8.9 is not recommended for deployment

## low-level-calls
Impact: Informational
Confidence: High
 - [ ] ID-35
Low level call in [LibDiamond.initializeDiamondCut(address,bytes)](contracts/libraries/LibDiamond.sol#L132-L150):
	- [(success,error) = _init.delegatecall(_calldata)](contracts/libraries/LibDiamond.sol#L140)

contracts/libraries/LibDiamond.sol#L132-L150


## missing-inheritance
Impact: Informational
Confidence: High
 - [ ] ID-36
[TicketsFacet](contracts/facets/TicketsFacet.sol#L10-L205) should inherit from [IERC1155Metadata_URI](contracts/interfaces/IERC1155Metadata_URI.sol#L7-L15)

contracts/facets/TicketsFacet.sol#L10-L205


## naming-convention
Impact: Informational
Confidence: High
 - [ ] ID-37
Parameter [DiamondLoupeFacet.supportsInterface(bytes4)._interfaceId](contracts/facets/DiamondLoupeFacet.sol#L143) is not in mixedCase

contracts/facets/DiamondLoupeFacet.sol#L143


 - [ ] ID-38
Parameter [LibDiamond.initializeDiamondCut(address,bytes)._init](contracts/libraries/LibDiamond.sol#L132) is not in mixedCase

contracts/libraries/LibDiamond.sol#L132


 - [ ] ID-39
Parameter [TicketsFacet.balanceOfBatch(address[],uint256[])._owners](contracts/facets/TicketsFacet.sol#L154) is not in mixedCase

contracts/facets/TicketsFacet.sol#L154


 - [ ] ID-40
Parameter [TicketsFacet.balanceOf(address,uint256)._id](contracts/facets/TicketsFacet.sol#L144) is not in mixedCase

contracts/facets/TicketsFacet.sol#L144


 - [ ] ID-41
Parameter [DiamondLoupeFacet.facetAddress(bytes4)._functionSelector](contracts/facets/DiamondLoupeFacet.sol#L137) is not in mixedCase

contracts/facets/DiamondLoupeFacet.sol#L137


 - [ ] ID-42
Parameter [StakingFacet.bulkFrens(address[])._accounts](contracts/facets/StakingFacet.sol#L25) is not in mixedCase

contracts/facets/StakingFacet.sol#L25


 - [ ] ID-43
Parameter [Airdrop.airdropMatic(address[],uint256[])._receivers](contracts/Airdrop.sol#L18) is not in mixedCase

contracts/Airdrop.sol#L18


 - [ ] ID-44
Parameter [DiamondCutFacet.diamondCut(IDiamondCut.FacetCut[],address,bytes)._diamondCut](contracts/facets/DiamondCutFacet.sol#L20) is not in mixedCase

contracts/facets/DiamondCutFacet.sol#L20


 - [ ] ID-45
Parameter [DiamondCutFacet.diamondCut(IDiamondCut.FacetCut[],address,bytes)._init](contracts/facets/DiamondCutFacet.sol#L21) is not in mixedCase

contracts/facets/DiamondCutFacet.sol#L21


 - [ ] ID-46
Parameter [TicketsFacet.setBaseURI(string)._value](contracts/facets/TicketsFacet.sol#L15) is not in mixedCase

contracts/facets/TicketsFacet.sol#L15


 - [ ] ID-47
Parameter [TicketsFacet.balanceOfAll(address)._owner](contracts/facets/TicketsFacet.sol#L131) is not in mixedCase

contracts/facets/TicketsFacet.sol#L131


 - [ ] ID-48
Parameter [LibDiamond.addFunctions(address,bytes4[])._facetAddress](contracts/libraries/LibDiamond.sol#L75) is not in mixedCase

contracts/libraries/LibDiamond.sol#L75


 - [ ] ID-49
Parameter [LibDiamond.enforceHasContractCode(address,string)._contract](contracts/libraries/LibDiamond.sol#L152) is not in mixedCase

contracts/libraries/LibDiamond.sol#L152


 - [ ] ID-50
Parameter [TicketsFacet.safeTransferFrom(address,address,uint256,uint256,bytes)._from](contracts/facets/TicketsFacet.sol#L43) is not in mixedCase

contracts/facets/TicketsFacet.sol#L43


 - [ ] ID-51
Parameter [LibDiamond.removeFunctions(address,bytes4[])._functionSelectors](contracts/libraries/LibDiamond.sol#L108) is not in mixedCase

contracts/libraries/LibDiamond.sol#L108


 - [ ] ID-52
Parameter [LibDiamond.initializeDiamondCut(address,bytes)._calldata](contracts/libraries/LibDiamond.sol#L132) is not in mixedCase

contracts/libraries/LibDiamond.sol#L132


 - [ ] ID-53
Parameter [TicketsFacet.totalSupply(uint256)._id](contracts/facets/TicketsFacet.sol#L126) is not in mixedCase

contracts/facets/TicketsFacet.sol#L126


 - [ ] ID-54
Parameter [LibDiamond.diamondCut(IDiamondCut.FacetCut[],address,bytes)._init](contracts/libraries/LibDiamond.sol#L56) is not in mixedCase

contracts/libraries/LibDiamond.sol#L56


 - [ ] ID-55
Parameter [LibDiamond.replaceFunctions(address,bytes4[])._functionSelectors](contracts/libraries/LibDiamond.sol#L91) is not in mixedCase

contracts/libraries/LibDiamond.sol#L91


 - [ ] ID-56
Parameter [TicketsFacet.uri(uint256)._id](contracts/facets/TicketsFacet.sol#L23) is not in mixedCase

contracts/facets/TicketsFacet.sol#L23


 - [ ] ID-57
Parameter [OwnershipFacet.transferOwnership(address)._newOwner](contracts/facets/OwnershipFacet.sol#L8) is not in mixedCase

contracts/facets/OwnershipFacet.sol#L8


 - [ ] ID-58
Parameter [TicketsFacet.isApprovedForAll(address,address)._owner](contracts/facets/TicketsFacet.sol#L179) is not in mixedCase

contracts/facets/TicketsFacet.sol#L179


 - [ ] ID-59
Function [IUniswapV2Pair.PERMIT_TYPEHASH()](contracts/interfaces/IUniswapV2Pair.sol#L34) is not in mixedCase

contracts/interfaces/IUniswapV2Pair.sol#L34


 - [ ] ID-60
Parameter [TicketsFacet.balanceOfBatch(address[],uint256[])._ids](contracts/facets/TicketsFacet.sol#L154) is not in mixedCase

contracts/facets/TicketsFacet.sol#L154


 - [ ] ID-61
Function [IUniswapV2Pair.MINIMUM_LIQUIDITY()](contracts/interfaces/IUniswapV2Pair.sol#L53) is not in mixedCase

contracts/interfaces/IUniswapV2Pair.sol#L53


 - [ ] ID-62
Parameter [TicketsFacet.setApprovalForAll(address,bool)._operator](contracts/facets/TicketsFacet.sol#L168) is not in mixedCase

contracts/facets/TicketsFacet.sol#L168


 - [ ] ID-63
Parameter [StakingFacet.updateAccounts(address[])._accounts](contracts/facets/StakingFacet.sol#L41) is not in mixedCase

contracts/facets/StakingFacet.sol#L41


 - [ ] ID-64
Parameter [TicketsFacet.migrateTickets(TicketsFacet.TicketOwner[])._ticketOwners](contracts/facets/TicketsFacet.sol#L189) is not in mixedCase

contracts/facets/TicketsFacet.sol#L189


 - [ ] ID-65
Parameter [TicketsFacet.isApprovedForAll(address,address)._operator](contracts/facets/TicketsFacet.sol#L179) is not in mixedCase

contracts/facets/TicketsFacet.sol#L179


 - [ ] ID-66
Parameter [Airdrop.airdropToken(address,address[],uint256[])._token](contracts/Airdrop.sol#L8) is not in mixedCase

contracts/Airdrop.sol#L8


 - [ ] ID-67
Parameter [TicketsFacet.safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)._values](contracts/facets/TicketsFacet.sol#L89) is not in mixedCase

contracts/facets/TicketsFacet.sol#L89


 - [ ] ID-68
Parameter [TicketsFacet.safeTransferFrom(address,address,uint256,uint256,bytes)._data](contracts/facets/TicketsFacet.sol#L47) is not in mixedCase

contracts/facets/TicketsFacet.sol#L47


 - [ ] ID-69
Parameter [LibDiamond.enforceHasContractCode(address,string)._errorMessage](contracts/libraries/LibDiamond.sol#L152) is not in mixedCase

contracts/libraries/LibDiamond.sol#L152


 - [ ] ID-70
Function [IUniswapV2Pair.DOMAIN_SEPARATOR()](contracts/interfaces/IUniswapV2Pair.sol#L32) is not in mixedCase

contracts/interfaces/IUniswapV2Pair.sol#L32


 - [ ] ID-71
Parameter [TicketsFacet.safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)._from](contracts/facets/TicketsFacet.sol#L86) is not in mixedCase

contracts/facets/TicketsFacet.sol#L86


 - [ ] ID-72
Parameter [LibDiamond.diamondCut(IDiamondCut.FacetCut[],address,bytes)._diamondCut](contracts/libraries/LibDiamond.sol#L55) is not in mixedCase

contracts/libraries/LibDiamond.sol#L55


 - [ ] ID-73
Parameter [TicketsFacet.safeTransferFrom(address,address,uint256,uint256,bytes)._to](contracts/facets/TicketsFacet.sol#L44) is not in mixedCase

contracts/facets/TicketsFacet.sol#L44


 - [ ] ID-74
Parameter [TicketsFacet.safeTransferFrom(address,address,uint256,uint256,bytes)._value](contracts/facets/TicketsFacet.sol#L46) is not in mixedCase

contracts/facets/TicketsFacet.sol#L46


 - [ ] ID-75
Parameter [LibDiamond.replaceFunctions(address,bytes4[])._facetAddress](contracts/libraries/LibDiamond.sol#L91) is not in mixedCase

contracts/libraries/LibDiamond.sol#L91


 - [ ] ID-76
Parameter [TicketsFacet.setApprovalForAll(address,bool)._approved](contracts/facets/TicketsFacet.sol#L168) is not in mixedCase

contracts/facets/TicketsFacet.sol#L168


 - [ ] ID-77
Parameter [LibDiamond.setContractOwner(address)._newOwner](contracts/libraries/LibDiamond.sol#L36) is not in mixedCase

contracts/libraries/LibDiamond.sol#L36


 - [ ] ID-78
Parameter [LibDiamond.diamondCut(IDiamondCut.FacetCut[],address,bytes)._calldata](contracts/libraries/LibDiamond.sol#L57) is not in mixedCase

contracts/libraries/LibDiamond.sol#L57


 - [ ] ID-79
Parameter [Airdrop.airdropToken(address,address[],uint256[])._receivers](contracts/Airdrop.sol#L9) is not in mixedCase

contracts/Airdrop.sol#L9


 - [ ] ID-80
Parameter [Airdrop.airdropMatic(address[],uint256[])._amounts](contracts/Airdrop.sol#L18) is not in mixedCase

contracts/Airdrop.sol#L18


 - [ ] ID-81
Parameter [DiamondLoupeFacet.facetFunctionSelectors(address)._facet](contracts/facets/DiamondLoupeFacet.sol#L78) is not in mixedCase

contracts/facets/DiamondLoupeFacet.sol#L78


 - [ ] ID-82
Parameter [Airdrop.airdropToken(address,address[],uint256[])._amounts](contracts/Airdrop.sol#L10) is not in mixedCase

contracts/Airdrop.sol#L10


 - [ ] ID-83
Parameter [TicketsFacet.safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)._to](contracts/facets/TicketsFacet.sol#L87) is not in mixedCase

contracts/facets/TicketsFacet.sol#L87


 - [ ] ID-84
Parameter [LibDiamond.addFunctions(address,bytes4[])._functionSelectors](contracts/libraries/LibDiamond.sol#L75) is not in mixedCase

contracts/libraries/LibDiamond.sol#L75


 - [ ] ID-85
Parameter [TicketsFacet.balanceOf(address,uint256)._owner](contracts/facets/TicketsFacet.sol#L144) is not in mixedCase

contracts/facets/TicketsFacet.sol#L144


 - [ ] ID-86
Parameter [StakingFacet.frens(address)._account](contracts/facets/StakingFacet.sol#L18) is not in mixedCase

contracts/facets/StakingFacet.sol#L18


 - [ ] ID-87
Contract [IERC1155Metadata_URI](contracts/interfaces/IERC1155Metadata_URI.sol#L7-L15) is not in CapWords

contracts/interfaces/IERC1155Metadata_URI.sol#L7-L15


 - [ ] ID-88
Parameter [LibDiamond.removeFunctions(address,bytes4[])._facetAddress](contracts/libraries/LibDiamond.sol#L108) is not in mixedCase

contracts/libraries/LibDiamond.sol#L108


 - [ ] ID-89
Parameter [StakingFacet.setPoolTokensRate(uint256)._newRate](contracts/facets/StakingFacet.sol#L52) is not in mixedCase

contracts/facets/StakingFacet.sol#L52


 - [ ] ID-90
Parameter [TicketsFacet.safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)._data](contracts/facets/TicketsFacet.sol#L90) is not in mixedCase

contracts/facets/TicketsFacet.sol#L90


 - [ ] ID-91
Parameter [TicketsFacet.safeTransferFrom(address,address,uint256,uint256,bytes)._id](contracts/facets/TicketsFacet.sol#L45) is not in mixedCase

contracts/facets/TicketsFacet.sol#L45


 - [ ] ID-92
Parameter [DiamondCutFacet.diamondCut(IDiamondCut.FacetCut[],address,bytes)._calldata](contracts/facets/DiamondCutFacet.sol#L22) is not in mixedCase

contracts/facets/DiamondCutFacet.sol#L22


 - [ ] ID-93
Parameter [TicketsFacet.safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)._ids](contracts/facets/TicketsFacet.sol#L88) is not in mixedCase

contracts/facets/TicketsFacet.sol#L88


## similar-names
Impact: Informational
Confidence: Medium
 - [ ] ID-94
Variable [DiamondLoupeFacet.facetFunctionSelectors(address)._facetFunctionSelectors](contracts/facets/DiamondLoupeFacet.sol#L78) is too similar to [IDiamondLoupe.facetFunctionSelectors(address).facetFunctionSelectors_](contracts/interfaces/IDiamondLoupe.sol#L22)

contracts/facets/DiamondLoupeFacet.sol#L78


## unused-state
Impact: Informational
Confidence: High
 - [ ] ID-95
[StakingFacet.ERC1155_BATCH_ACCEPTED](contracts/facets/StakingFacet.sol#L11) is never used in [StakingFacet](contracts/facets/StakingFacet.sol#L9-L57)

contracts/facets/StakingFacet.sol#L11



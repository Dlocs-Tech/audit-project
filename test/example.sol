pragma solidity 0.8.9;

import "forge-std/Test.sol";
// take a look https://book.getfoundry.sh/forge/writing-tests
// cheatcode to prank accounts and change timestamp https://book.getfoundry.sh/forge/cheatcodes

contract ContractBTest is Test {
    uint256 testNumber;

    function setUp() public {
        testNumber = 42;
    }

    function test_NumberIs42() public {
        assertEq(testNumber, 42);
    }

    function testFail_Subtract43() public {
        testNumber -= 43;
    }
}

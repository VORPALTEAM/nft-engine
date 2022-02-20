// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


contract RandomGenerator {
    /// Probability distribution
    uint8 public constant COMMON = 50;
    uint8 public constant RARE = 70;
    uint8 public constant MYTHIC = 90;
    uint8 public constant LEGENDARY = 98;

    enum Rarity { 
        Common, 
        Rare, 
        Mythic, 
        Legendary, 
        Vorpal
    }

    function generateRarity() public returns(Rarity) {
        uint256 random_number = randomSeed() % 100;
        Rarity item;
        if (random_number <= COMMON) {
            item = Rarity.Common;
        } else if (random_number <= RARE) {
            item = Rarity.Rare;
        } else if (random_number <= MYTHIC) {
            item = Rarity.Mythic;
        } else if (random_number <= LEGENDARY) {
            item = Rarity.Legendary;
        } else {
            item = Rarity.Vorpal;
        }
        return item;
    }
    /// Generates a random number of stats or values for these stats
    function randomStatValueGenerator(uint256 lower, uint256 upper) public returns (uint256) {
        return (randomSeed() % (upper - lower + 1)) + lower;
    }

    function randomSeed() internal returns (uint256) {
        bytes32[1] memory value;

        assembly {
            let ret := call(gas(), 0xc104f4840573bed437190daf5d2898c2bdf928ac, 0, 0, 0, value, 32)
        }

        return uint256(value[0]);
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


contract NFTCoreEngine is ERC1155 {
    // Probability distribution
    uint8 public constant COMMON = 50;
    uint8 public constant RARE = 70;
    uint8 public constant MYTHIC = 90;
    uint8 public constant LEGENDARY = 98;

    uint256 public constant SCROLLS = 0;
    uint256 public constant GEMS = 1;
    uint256 public constant PARTS = 2;

    enum Rarity { 
      Common, 
      Rare, 
      Mythic, 
      Legendary, 
      Arcane
    }

    struct PlayerInfo {
        Rarity[] scrolls;
        Rarity[] gems;
        Rarity[] parts;
    }
    mapping(address => PlayerInfo) private players;

    constructor()  ERC1155("") {

    }

    /// * - `ids` and `amounts` must have the same length.
    function mint_games_items(
        uint256[] memory ids,
        uint256[] memory amounts
    ) public {
        uint256 random_number;
        for (uint256 i = 0; i < ids.length; i++) {
            for (uint256 j = 0; j < amounts[i]; j++) {
                random_number = randomSeed() % 100;
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
                    item = Rarity.Arcane;
                }
                if (i == SCROLLS) {
                    players[msg.sender].scrolls.push(item);
                }
                if (i == GEMS) {
                    players[msg.sender].scrolls.push(item);
                }
                if (i == PARTS) {
                    players[msg.sender].scrolls.push(item);
                }
            }
        }
        _mintBatch(msg.sender, ids, amounts, "");
    }

    function randomSeed() public returns (uint256) {
        bytes32[1] memory value;

        assembly {
            let ret := call(gas(), 0xc104f4840573bed437190daf5d2898c2bdf928ac, 0, 0, 0, value, 32)
        }

        return uint256(value[0]);
    }
}
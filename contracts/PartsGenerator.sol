// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./RandomGenerator.sol";


contract PartsGenerator is RandomGenerator {  

    struct Player {
        mapping(Rarity => Part[]) parts;
        mapping(Rarity => Piece[]) pieces;
    }

    // add Skills
    struct Part {
        Rarity rarity;
        BaseStats[] baseStats;
        AdditionalStats[] additionalStats;
    }

    struct Piece {
        Rarity rarity;
    }

    enum BaseStats { 
      War, 
      Social, 
      Invisible, 
      HP, 
      MoveSpeed,
      Experiance,
      Resists
    }

    enum AdditionalStats { 
        Damage, 
        Crit, 
        AttackSpeed, 
        MiningSpeed, 
        MiningCrit,
        Mining
      }

    mapping(address => Player) internal partsOfPlayers;
    Part part;
    Piece piece;
    function generatePart() public {
        _generatePart(generateRarity());
    }

    function generatePieceOfPart() public {
        piece.rarity = generateRarity();
        partsOfPlayers[msg.sender].pieces[piece.rarity].push(piece);
    }

    function craft(Rarity rarity) public {
        uint256 length = partsOfPlayers[msg.sender].pieces[rarity].length;
        Piece[] storage pieces = partsOfPlayers[msg.sender].pieces[rarity];
        if (rarity == Rarity.Common && length >= 40) {
            // deletes 40 pieces 
            for (uint256 i = 0; i < 40; i++) {
                pieces.pop();
            }
            _generatePart(rarity);
        } else if (rarity == Rarity.Rare && length >= 100) {
            // deletes 100 pieces 
            for (uint256 i = 0; i < 100; i++) {
                pieces.pop();
            }
            _generatePart(rarity);
        } else if (rarity == Rarity.Mythic && length >= 400) {
            // deletes 400 pieces 
            for (uint256 i = 0; i < 400; i++) {
                pieces.pop();
            }
            _generatePart(rarity);
        } else if (rarity == Rarity.Legendary && length >= 1600) {
            // deletes 1600 pieces 
            for (uint256 i = 0; i < 1600; i++) {
                pieces.pop();
            }
            _generatePart(rarity);
        } else if (rarity == Rarity.Vorpal && length >= 6400) {
            // deletes 1600 pieces 
            for (uint256 i = 0; i < 6400; i++) {
                pieces.pop();
            }
            _generatePart(rarity);
        } else {
            revert("Not enough piece for crafting");
        }
    }

    function disenchant(Rarity rarity) public {
        uint256 length = partsOfPlayers[msg.sender].parts[rarity].length;
        Part[] storage parts = partsOfPlayers[msg.sender].parts[rarity];
        require(length >= 1, "has no necessary part");
        parts.pop();
        piece.rarity = rarity;
        if (rarity == Rarity.Common) {
            for (uint256 i = 0; i < 10; i++) {
                partsOfPlayers[msg.sender].pieces[piece.rarity].push(piece);
            }
        } else if (rarity == Rarity.Rare) {
            for (uint256 i = 0; i < 25; i++) {
                partsOfPlayers[msg.sender].pieces[piece.rarity].push(piece);
            }
        } else if (rarity == Rarity.Mythic) {
            for (uint256 i = 0; i < 100; i++) {
                partsOfPlayers[msg.sender].pieces[piece.rarity].push(piece);
            }
        } else if (rarity == Rarity.Legendary) {
            for (uint256 i = 0; i < 400; i++) {
                partsOfPlayers[msg.sender].pieces[piece.rarity].push(piece);
            }
        } else if (rarity == Rarity.Vorpal) {
            for (uint256 i = 0; i < 1600; i++) {
                partsOfPlayers[msg.sender].pieces[piece.rarity].push(piece);
            }
        } 
    }
    function upgrade(Rarity rarity) public {
        require(rarity != Rarity.Vorpal, "Cannot upgrade vorpal part");
        uint256 length = partsOfPlayers[msg.sender].parts[rarity].length;
        require(length >= 4, "not enough parts for upgrade");
        Piece[] storage parts = partsOfPlayers[msg.sender].pieces[rarity];
        for (uint256 i = 0; i < 4; i++) {
            parts.pop();
        }
        _generatePart(Rarity(uint(rarity)+1));
    }

    function upgrade_with_pieces(Rarity rarity) public {
        require(rarity != Rarity.Vorpal, "Cannot upgrade vorpal part");
        uint256 length = partsOfPlayers[msg.sender].pieces[rarity].length;
        Piece[] storage pieces = partsOfPlayers[msg.sender].pieces[rarity];
        if (rarity == Rarity.Common && length >= 400) {
            for (uint256 i = 0; i < 400; i++) {
                pieces.pop();
            }
            _generatePart(Rarity.Rare);
        } else if (rarity == Rarity.Rare && length >= 1600) {
            for (uint256 i = 0; i < 1600; i++) {
                pieces.pop();
            }
            _generatePart(Rarity.Mythic);
        } else if (rarity == Rarity.Mythic && length >= 6400) {
            for (uint256 i = 0; i < 6400; i++) {
                pieces.pop();
            }
            _generatePart(Rarity.Legendary);
        } else if (rarity == Rarity.Legendary && length >= 25600) {
            // deletes 1600 pieces 
            for (uint256 i = 0; i < 25600; i++) {
                pieces.pop();
            }
            _generatePart(Rarity.Vorpal);
        } else {
            revert("Not enough piece for updating");
        }
    }

    function _generatePart(Rarity rarity) internal {
        part.rarity = rarity;
        if (part.rarity == Rarity.Common || part.rarity == Rarity.Rare) {
            // generates 1-3 base stats
            uint256 num_stats = randomStatValueGenerator(1, 3);
            // generates values for base stats
            for (uint256 i = 0; i < num_stats; i++) {
                part.baseStats.push(
                    BaseStats(randomStatValueGenerator(0, 6))
                );
            }
            // if rarity is `Rare` generates 1 additional value
            if (part.rarity == Rarity.Rare) {
                part.additionalStats.push(
                    AdditionalStats(randomStatValueGenerator(0, 5))
                );
            }
        }
        if (part.rarity == Rarity.Mythic || part.rarity == Rarity.Legendary) {
            // generates 2-3 base stats
            uint256 num_stats = randomStatValueGenerator(2, 3);
            // generates values for base stats
            for (uint256 i = 0; i < num_stats; i++) {
                part.baseStats.push(
                    BaseStats(randomStatValueGenerator(0, 6))
                );
            }
            // generates 2 additional value
            for (uint256 i = 0; i < 2; i++) {
                part.additionalStats.push(
                    AdditionalStats(randomStatValueGenerator(0, 5))
                );
            }
             // if rarity is `Legendary` add 1 additional value
             if (part.rarity == Rarity.Rare) {
                part.additionalStats.push(
                    AdditionalStats(randomStatValueGenerator(0, 5))
                );
            }
        }
        if (part.rarity == Rarity.Vorpal) {
            // generates 3 values for base stats
            for (uint256 i = 0; i < 3; i++) {
                part.baseStats.push(
                    BaseStats(randomStatValueGenerator(0, 6))
                );
            }
            // generates 4 additional values
            for (uint256 i = 0; i < 4; i++) {
                part.additionalStats.push(
                    AdditionalStats(randomStatValueGenerator(0, 5))
                );
            }
        }
        partsOfPlayers[msg.sender].parts[part.rarity].push(part);
    }

}
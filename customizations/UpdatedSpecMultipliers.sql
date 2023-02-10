# Updated specialization multipliers to match live

UPDATE `CharacterClass` SET `SpecPointMultiplier`=29 WHERE CharacterClass.ID IN (9); # Infiltrator
UPDATE `CharacterClass` SET `SpecPointMultiplier`=28 WHERE CharacterClass.ID IN (23,49); # Shadowblade, Nightshade
UPDATE `CharacterClass` SET `SpecPointMultiplier`=18 WHERE CharacterClass.ID IN (60,61,62); # Maulers
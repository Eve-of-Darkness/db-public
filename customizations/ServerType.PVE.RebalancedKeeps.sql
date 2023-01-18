# A more intuitive approach to PvE keeps than Gaheris
# Keeps progress in difficulty as you get further into the frontiers
# Keep difficulty progresses through 10, 20, 30, and 40 seals

UPDATE `ServerProperty` SET `Value`=8  WHERE `Key`='max_keep_level';
UPDATE `Keep` SET `Realm`=0, `OriginalRealm`=0 WHERE `Name` LIKE '%Caer%' OR `Name` LIKE 'Faste%' OR `Name` LIKE '%Dun%'
	OR `Name` LIKE '%Brolorn%' OR `Name` LIKE '%Leonis%' OR `Name` LIKE '%Leirvik%' OR `Name` LIKE '% tower';

# Set difficulties to keeps, each level is worth 5 dreaded seals
UPDATE `Keep` SET `Level`=2
	WHERE `Name` LIKE '%Renaris%' OR `Name` LIKE '%Hurbury%' OR `Name` LIKE '%Arvakr%' OR `Name` LIKE '%Fensalir%' OR `Name` LIKE '%Ailinne%' OR `Name` LIKE '%Scathaig%';
UPDATE `Keep` SET `Level`=4
	WHERE `Name` LIKE '%Sursbrooke%' OR `Name` LIKE '%Boldiam%' OR `Name` LIKE '%Blendrake%' OR `Name` LIKE '%Hlidskidalf%' OR `Name` LIKE '%nGed%' OR `Name` LIKE '%Da Behnn%';
UPDATE `Keep` SET `Level`=6
	WHERE `Name` LIKE '%Berkstead%' OR `Name` LIKE '%Erasleigh%' OR `Name` LIKE '%Glenlock%' OR `Name` LIKE '%Nottmoor%' OR `Name` LIKE '%Bolg%' OR `Name` LIKE '%Crimthainn%';
UPDATE `Keep` SET `Level`=8
	WHERE `Name` LIKE '%Benowyc%' OR `Name` LIKE '%Bledmeer%' OR `Name` LIKE '%Crauchon%';
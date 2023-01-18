# Make keeps PvE, Gaheris-like.

UPDATE `ServerProperty` SET `Value`=8  WHERE `Key`='max_keep_level';
UPDATE `Keep` SET `Realm`=0, `OriginalRealm`=0 WHERE `Name` LIKE '%Caer%' OR `Name` LIKE 'Faste%' OR `Name` LIKE '%Dun%'
	OR `Name` LIKE '%Brolorn%' OR `Name` LIKE '%Leonis%' OR `Name` LIKE '%Leirvik%' OR `Name` LIKE '% tower';

# Set difficulties to keeps, each level is worth 5 dreaded seals
UPDATE `Keep` SET `Level`=3
	WHERE `Name` LIKE '%Renaris%' OR `Name` LIKE '%Arvakr%' OR `Name` LIKE '%Ailinne%';
UPDATE `Keep` SET `Level`=5
	WHERE `Name` LIKE '%Berkstead%' OR `Name` LIKE '%Erasleigh%' OR `Name` LIKE '%Hurbury%' OR `Name` LIKE '%Sursbrooke%'
	OR `Name` LIKE '%Blendrake%' OR `Name` LIKE '%Fensalir%' OR `Name` LIKE '%Hlidskidalf%' OR `Name` LIKE '%Nottmoor%'
	OR `Name` LIKE '%Scathaig%' OR `Name` LIKE '%Crimthainn%' OR `Name` LIKE '%Bolg%' OR `Name` LIKE '%Da Behnn%';
UPDATE `Keep` SET `Level`=8
	WHERE `Name` LIKE '%Benowyc%' OR `Name` LIKE '%Boldiam%'
	OR `Name` LIKE '%Glenlock%' OR  `Name` LIKE '%Bledmeer%'
	OR `Name` LIKE '%Crauchon%' OR  `Name` LIKE '%nGed%';

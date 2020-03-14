# Set max keep level to 10
UPDATE `ServerProperty` SET `Value`="10" WHERE `Key`="max_keep_level";

# Set keeps to PvE
UPDATE `Keep` SET `Realm`=0, `OriginalRealm`=0 WHERE `Name` LIKE "%Caer%" OR `Name` LIKE "%Faste%" OR `Name` LIKE "%Dun%";

# Set difficulties to keeps
UPDATE `Keep` SET `Level`=3 WHERE `Name` LIKE "%Renaris%" OR
`Name` LIKE "%Arvakr%" OR
`Name` LIKE "%Ailinne%";
UPDATE `Keep` SET `Level`=5 WHERE `Name` LIKE "%Berkstead%" OR
`Name` LIKE "%Erasleigh%" OR
`Name` LIKE "%Hurbury%" OR
`Name` LIKE "%Sursbrooke%" OR
`Name` LIKE "%Blendrake%" OR
`Name` LIKE "%Fensalir%" OR
`Name` LIKE "%Hlidskidalf%" OR
`Name` LIKE "%Nottmoor%" OR
`Name` LIKE "%Scathaig%" OR
`Name` LIKE "%Crimthainn%" OR
`Name` LIKE "%Bolg%" OR
`Name` LIKE "%Da Behnn%";
UPDATE `Keep` SET `Level`=8 WHERE `Name` LIKE "%Benowyc%" OR
`Name` LIKE "%Boldiam%" OR
`Name` LIKE "%Glenlock%" OR
`Name` LIKE "%Bledmeer%" OR
`Name` LIKE "%Crauchon%" OR
`Name` LIKE "%nGed%";

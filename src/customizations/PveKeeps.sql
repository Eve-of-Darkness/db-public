# Set keeps to PvE
UPDATE `Keep` SET Realm=0, OriginalRealm=0 WHERE `Name` LIKE "%Caer%" OR `Name` LIKE "%Faste%" OR `Name` LIKE "%Dun%";
DROP TABLE IF EXISTS `Ability`;

CREATE TABLE `Ability` (`AbilityID` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
`KeyName` VARCHAR(100) NOT NULL DEFAULT '' COLLATE NOCASE, 
`Name` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
`InternalID` INT(11) NOT NULL DEFAULT 0, 
`Description` TEXT NOT NULL DEFAULT '' COLLATE NOCASE, 
`IconID` INT(11) NOT NULL DEFAULT 0, 
`Implementation` VARCHAR(255) DEFAULT NULL COLLATE NOCASE, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00');
CREATE UNIQUE INDEX `U_Ability_KeyName` ON `Ability` (`KeyName`);
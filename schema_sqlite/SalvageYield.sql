DROP TABLE IF EXISTS `SalvageYield`;

CREATE TABLE `SalvageYield` (`ID` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
`ObjectType` INT(11) NOT NULL DEFAULT 0, 
`SalvageLevel` INT(11) NOT NULL DEFAULT 0, 
`MaterialId_nb` TEXT NOT NULL DEFAULT '' COLLATE NOCASE, 
`Count` INT(11) NOT NULL DEFAULT 0, 
`Realm` INT(11) NOT NULL DEFAULT 0, 
`PackageID` TEXT DEFAULT NULL COLLATE NOCASE, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00');
CREATE INDEX `I_SalvageYield_ObjectType` ON `SalvageYield` (`ObjectType`);
CREATE INDEX `I_SalvageYield_SalvageLevel` ON `SalvageYield` (`SalvageLevel`);
CREATE INDEX `I_SalvageYield_Realm` ON `SalvageYield` (`Realm`);

DROP TABLE IF EXISTS `Salvage`;

CREATE TABLE `Salvage` (`ObjectType` INT(11) NOT NULL DEFAULT 0, 
`SalvageLevel` INT(11) NOT NULL DEFAULT 0, 
`Id_nb` TEXT NOT NULL DEFAULT '' COLLATE NOCASE, 
`Realm` INT(11) NOT NULL DEFAULT 0, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00', 
`Salvage_ID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
PRIMARY KEY (`Salvage_ID`));
CREATE INDEX `I_Salvage_ObjectType` ON `Salvage` (`ObjectType`);
CREATE INDEX `I_Salvage_SalvageLevel` ON `Salvage` (`SalvageLevel`);
CREATE INDEX `I_Salvage_Realm` ON `Salvage` (`Realm`);

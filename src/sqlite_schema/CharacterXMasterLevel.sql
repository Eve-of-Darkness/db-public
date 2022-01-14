CREATE TABLE IF NOT EXISTS `CharacterXMasterLevel` (`Character_ID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
`MLLevel` INT(11) NOT NULL DEFAULT 0, 
`MLStep` INT(11) NOT NULL DEFAULT 0, 
`StepCompleted` TINYINT(1) NOT NULL DEFAULT 0, 
`ValidationDate` DATETIME DEFAULT NULL, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00', 
`CharacterXMasterLevel_ID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
PRIMARY KEY (`CharacterXMasterLevel_ID`));
CREATE INDEX `I_CharacterXMasterLevel_Character_ID` ON `CharacterXMasterLevel` (`Character_ID`);

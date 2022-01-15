DROP TABLE IF EXISTS `FactionAggroLevel`;

CREATE TABLE `FactionAggroLevel` (`CharacterID` VARCHAR(100) NOT NULL DEFAULT '' COLLATE NOCASE, 
`FactionID` INT(11) NOT NULL DEFAULT 0, 
`AggroLevel` INT(11) NOT NULL DEFAULT 0, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00', 
`FactionAggroLevel_ID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
PRIMARY KEY (`FactionAggroLevel_ID`));
CREATE INDEX `I_FactionAggroLevel_CharacterID` ON `FactionAggroLevel` (`CharacterID`);

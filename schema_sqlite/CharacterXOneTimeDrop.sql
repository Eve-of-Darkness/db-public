CREATE TABLE IF NOT EXISTS `CharacterXOneTimeDrop` (`CharacterID` VARCHAR(100) NOT NULL DEFAULT '' COLLATE NOCASE, 
`ItemTemplateID` VARCHAR(100) NOT NULL DEFAULT '' COLLATE NOCASE, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00', 
`CharacterXOneTimeDrop_ID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
PRIMARY KEY (`CharacterXOneTimeDrop_ID`));
CREATE INDEX `I_CharacterXOneTimeDrop_CharacterID` ON `CharacterXOneTimeDrop` (`CharacterID`);
CREATE INDEX `I_CharacterXOneTimeDrop_ItemTemplateID` ON `CharacterXOneTimeDrop` (`ItemTemplateID`);

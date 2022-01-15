CREATE TABLE IF NOT EXISTS `SinglePermission` (`PlayerID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
`Command` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00', 
`SinglePermission_ID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
PRIMARY KEY (`SinglePermission_ID`));
CREATE INDEX `I_SinglePermission_PlayerID` ON `SinglePermission` (`PlayerID`);
CREATE INDEX `I_SinglePermission_Command` ON `SinglePermission` (`Command`);

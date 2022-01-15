DROP TABLE IF EXISTS `KeepPosition`;

CREATE TABLE `KeepPosition` (`ComponentSkin` INT(11) NOT NULL DEFAULT 0, 
`ComponentRotation` INT(11) NOT NULL DEFAULT 0, 
`TemplateID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
`Height` INT(11) NOT NULL DEFAULT 0, 
`XOff` INT(11) NOT NULL DEFAULT 0, 
`YOff` INT(11) NOT NULL DEFAULT 0, 
`ZOff` INT(11) NOT NULL DEFAULT 0, 
`HOff` INT(11) NOT NULL DEFAULT 0, 
`ClassType` VARCHAR(255) DEFAULT NULL COLLATE NOCASE, 
`TemplateType` INT(11) NOT NULL DEFAULT 0, 
`KeepType` INT(11) NOT NULL DEFAULT 0, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00', 
`KeepPosition_ID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
PRIMARY KEY (`KeepPosition_ID`));
CREATE INDEX `I_KeepPosition_ComponentSkin` ON `KeepPosition` (`ComponentSkin`);
CREATE INDEX `I_KeepPosition_TemplateID` ON `KeepPosition` (`TemplateID`);
CREATE INDEX `I_KeepPosition_Height` ON `KeepPosition` (`Height`);
CREATE INDEX `I_KeepPosition_ClassType` ON `KeepPosition` (`ClassType`);

DROP TABLE IF EXISTS `househookpointitem`;

CREATE TABLE `househookpointitem` (`ID` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
`HouseNumber` INT(11) NOT NULL DEFAULT 0, 
`HookpointID` UNSIGNED INT(10) NOT NULL DEFAULT 0, 
`Heading` UNSIGNED SMALLINT(5) NOT NULL DEFAULT 0, 
`ItemTemplateID` TEXT DEFAULT NULL COLLATE NOCASE, 
`Index` UNSIGNED TINYINT(3) NOT NULL DEFAULT 0, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00');
CREATE INDEX `I_househookpointitem_HouseNumber` ON `househookpointitem` (`HouseNumber`);
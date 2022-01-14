CREATE TABLE IF NOT EXISTS `KeepHookPointItem` (`KeepID` INT(11) NOT NULL DEFAULT 0, 
`ComponentID` INT(11) NOT NULL DEFAULT 0, 
`HookPointID` INT(11) NOT NULL DEFAULT 0, 
`ClassType` TEXT NOT NULL DEFAULT '' COLLATE NOCASE, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00', 
`KeepHookPointItem_ID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
PRIMARY KEY (`KeepHookPointItem_ID`));
CREATE INDEX `I_KeepHookPointItem_KeepID` ON `KeepHookPointItem` (`KeepID`);
CREATE INDEX `I_KeepHookPointItem_ComponentID` ON `KeepHookPointItem` (`ComponentID`);
CREATE INDEX `I_KeepHookPointItem_HookPointID` ON `KeepHookPointItem` (`HookPointID`);

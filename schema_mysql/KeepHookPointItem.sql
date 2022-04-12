CREATE TABLE IF NOT EXISTS `KeepHookPointItem` (
  `KeepID` int(11) NOT NULL DEFAULT '0',
  `ComponentID` int(11) NOT NULL DEFAULT '0',
  `HookPointID` int(11) NOT NULL DEFAULT '0',
  `ClassType` text NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `KeepHookPointItem_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`KeepHookPointItem_ID`),
  KEY `I_KeepHookPointItem_KeepID` (`KeepID`),
  KEY `I_KeepHookPointItem_ComponentID` (`ComponentID`),
  KEY `I_KeepHookPointItem_HookPointID` (`HookPointID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS `KeepHookPoint` (
  `HookPointID` int(11) NOT NULL DEFAULT '0',
  `KeepComponentSkinID` int(11) NOT NULL DEFAULT '0',
  `Z` int(11) NOT NULL DEFAULT '0',
  `Y` int(11) NOT NULL DEFAULT '0',
  `X` int(11) NOT NULL DEFAULT '0',
  `Heading` int(11) NOT NULL DEFAULT '0',
  `Height` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `KeepHookPoint_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`KeepHookPoint_ID`),
  KEY `I_KeepHookPoint_HookPointID` (`HookPointID`),
  KEY `I_KeepHookPoint_Height` (`Height`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

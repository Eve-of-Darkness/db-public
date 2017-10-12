DROP TABLE IF EXISTS `KeepHookPoint`;

CREATE TABLE `KeepHookPoint` (
  `HookPointID` int(11) NOT NULL,
  `KeepComponentSkinID` int(11) NOT NULL,
  `Z` int(11) DEFAULT NULL,
  `Y` int(11) DEFAULT NULL,
  `X` int(11) DEFAULT NULL,
  `Heading` int(11) DEFAULT NULL,
  `Height` int(11) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `KeepHookPoint_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`KeepHookPoint_ID`),
  KEY `I_KeepHookPoint_HookPointID` (`HookPointID`),
  KEY `I_KeepHookPoint_Height` (`Height`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

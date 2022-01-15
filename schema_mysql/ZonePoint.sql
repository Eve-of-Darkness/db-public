DROP TABLE IF EXISTS `ZonePoint`;

CREATE TABLE `ZonePoint` (
  `Id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `TargetX` int(11) NOT NULL DEFAULT '0',
  `TargetY` int(11) NOT NULL DEFAULT '0',
  `TargetZ` int(11) NOT NULL DEFAULT '0',
  `TargetRegion` smallint(5) unsigned NOT NULL DEFAULT '0',
  `TargetHeading` smallint(5) unsigned NOT NULL DEFAULT '0',
  `SourceX` int(11) NOT NULL DEFAULT '0',
  `SourceY` int(11) NOT NULL DEFAULT '0',
  `SourceZ` int(11) NOT NULL DEFAULT '0',
  `SourceRegion` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Realm` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ClassType` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `ZonePoint_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`ZonePoint_ID`),
  KEY `I_ZonePoint_Id` (`Id`),
  KEY `I_ZonePoint_Realm` (`Realm`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

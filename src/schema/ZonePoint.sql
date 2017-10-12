CREATE TABLE `ZonePoint` (
  `Id` smallint(5) unsigned NOT NULL,
  `TargetX` int(11) DEFAULT NULL,
  `TargetY` int(11) DEFAULT NULL,
  `TargetZ` int(11) DEFAULT NULL,
  `TargetRegion` smallint(5) unsigned DEFAULT NULL,
  `TargetHeading` smallint(5) unsigned DEFAULT NULL,
  `SourceX` int(11) DEFAULT NULL,
  `SourceY` int(11) DEFAULT NULL,
  `SourceZ` int(11) DEFAULT NULL,
  `SourceRegion` smallint(5) unsigned DEFAULT NULL,
  `Realm` smallint(5) unsigned DEFAULT NULL,
  `ClassType` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `ZonePoint_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`ZonePoint_ID`),
  KEY `I_ZonePoint_Id` (`Id`),
  KEY `I_ZonePoint_Realm` (`Realm`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

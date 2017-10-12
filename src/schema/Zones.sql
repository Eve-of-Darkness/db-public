DROP TABLE IF EXISTS `Zones`;

CREATE TABLE `Zones` (
  `ZoneID` int(11) NOT NULL,
  `RegionID` smallint(5) unsigned NOT NULL,
  `Name` text NOT NULL,
  `IsLava` tinyint(1) NOT NULL,
  `DivingFlag` tinyint(3) unsigned NOT NULL,
  `WaterLevel` int(11) NOT NULL,
  `OffsetY` int(11) NOT NULL,
  `OffsetX` int(11) NOT NULL,
  `Width` int(11) NOT NULL,
  `Height` int(11) NOT NULL,
  `Experience` int(11) DEFAULT NULL,
  `Realmpoints` int(11) DEFAULT NULL,
  `Bountypoints` int(11) DEFAULT NULL,
  `Coin` int(11) DEFAULT NULL,
  `Realm` tinyint(3) unsigned DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Zones_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ZoneID`),
  UNIQUE KEY `U_Zones_Zones_ID` (`Zones_ID`),
  KEY `I_Zones_RegionID` (`RegionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

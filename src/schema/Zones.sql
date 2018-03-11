DROP TABLE IF EXISTS `Zones`;

CREATE TABLE `Zones` (
  `ZoneID` int(11) NOT NULL DEFAULT '0',
  `RegionID` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Name` text NOT NULL,
  `IsLava` tinyint(1) NOT NULL DEFAULT '0',
  `DivingFlag` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `WaterLevel` int(11) NOT NULL DEFAULT '0',
  `OffsetY` int(11) NOT NULL DEFAULT '0',
  `OffsetX` int(11) NOT NULL DEFAULT '0',
  `Width` int(11) NOT NULL DEFAULT '0',
  `Height` int(11) NOT NULL DEFAULT '0',
  `Experience` int(11) NOT NULL DEFAULT '0',
  `Realmpoints` int(11) NOT NULL DEFAULT '0',
  `Bountypoints` int(11) NOT NULL DEFAULT '0',
  `Coin` int(11) NOT NULL DEFAULT '0',
  `Realm` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Zones_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ZoneID`),
  UNIQUE KEY `U_Zones_Zones_ID` (`Zones_ID`),
  KEY `I_Zones_RegionID` (`RegionID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

DROP TABLE IF EXISTS `Regions`;

CREATE TABLE `Regions` (
  `RegionID` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Name` text NOT NULL,
  `Description` text NOT NULL,
  `IP` text NOT NULL,
  `Port` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Expansion` int(11) NOT NULL DEFAULT '0',
  `HousingEnabled` tinyint(1) NOT NULL DEFAULT '0',
  `DivingEnabled` tinyint(1) NOT NULL DEFAULT '0',
  `WaterLevel` int(11) NOT NULL DEFAULT '0',
  `ClassType` varchar(200) NOT NULL,
  `IsFrontier` tinyint(1) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Regions_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RegionID`),
  UNIQUE KEY `U_Regions_Regions_ID` (`Regions_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

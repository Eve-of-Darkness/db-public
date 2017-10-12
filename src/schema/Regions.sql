CREATE TABLE `Regions` (
  `RegionID` smallint(5) unsigned NOT NULL,
  `Name` text NOT NULL,
  `Description` text NOT NULL,
  `IP` text NOT NULL,
  `Port` smallint(5) unsigned NOT NULL,
  `Expansion` int(11) NOT NULL,
  `HousingEnabled` tinyint(1) NOT NULL,
  `DivingEnabled` tinyint(1) NOT NULL,
  `WaterLevel` int(11) NOT NULL,
  `ClassType` varchar(200) NOT NULL,
  `IsFrontier` tinyint(1) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Regions_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RegionID`),
  UNIQUE KEY `U_Regions_Regions_ID` (`Regions_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

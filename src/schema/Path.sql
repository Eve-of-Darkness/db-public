CREATE TABLE `Path` (
  `PathID` varchar(255) NOT NULL,
  `PathType` int(11) NOT NULL,
  `RegionID` smallint(5) unsigned DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Path_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Path_ID`),
  UNIQUE KEY `U_Path_PathID` (`PathID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

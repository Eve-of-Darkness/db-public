CREATE TABLE IF NOT EXISTS `PlayerBoats` (
  `BoatID` text NOT NULL,
  `BoatOwner` text NOT NULL,
  `BoatName` varchar(255) NOT NULL,
  `BoatModel` smallint(5) unsigned NOT NULL DEFAULT '0',
  `BoatMaxSpeedBase` smallint(6) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `PlayerBoats_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`BoatName`),
  UNIQUE KEY `U_PlayerBoats_PlayerBoats_ID` (`PlayerBoats_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

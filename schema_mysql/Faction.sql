DROP TABLE IF EXISTS `Faction`;

CREATE TABLE `Faction` (
  `ID` int(11) NOT NULL DEFAULT '0',
  `Name` text,
  `BaseAggroLevel` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Faction_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `U_Faction_Faction_ID` (`Faction_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

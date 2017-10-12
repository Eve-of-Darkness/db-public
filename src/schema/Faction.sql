/*Table structure for table `faction` */

DROP TABLE IF EXISTS `faction`;

CREATE TABLE `faction` (
  `ID` int(11) NOT NULL,
  `Name` text,
  `BaseAggroLevel` int(11) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Faction_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `U_Faction_Faction_ID` (`Faction_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

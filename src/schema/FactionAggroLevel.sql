/*Table structure for table `factionaggrolevel` */

DROP TABLE IF EXISTS `factionaggrolevel`;

CREATE TABLE `factionaggrolevel` (
  `CharacterID` varchar(100) NOT NULL,
  `FactionID` int(11) NOT NULL,
  `AggroLevel` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `FactionAggroLevel_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`FactionAggroLevel_ID`),
  KEY `I_FactionAggroLevel_CharacterID` (`CharacterID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

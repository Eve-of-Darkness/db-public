DROP TABLE IF EXISTS `Race`;

CREATE TABLE `Race` (
  `ID` int(11) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `ResistBody` tinyint(3) DEFAULT NULL,
  `ResistCold` tinyint(3) DEFAULT NULL,
  `ResistCrush` tinyint(3) DEFAULT NULL,
  `ResistEnergy` tinyint(3) DEFAULT NULL,
  `ResistHeat` tinyint(3) DEFAULT NULL,
  `ResistMatter` tinyint(3) DEFAULT NULL,
  `ResistNatural` tinyint(3) DEFAULT NULL,
  `ResistSlash` tinyint(3) DEFAULT NULL,
  `ResistSpirit` tinyint(3) DEFAULT NULL,
  `ResistThrust` tinyint(3) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Race_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Race_ID`),
  UNIQUE KEY `U_Race_ID` (`ID`),
  UNIQUE KEY `U_Race_Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

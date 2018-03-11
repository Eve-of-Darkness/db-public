DROP TABLE IF EXISTS `Race`;

CREATE TABLE `Race` (
  `ID` int(11) NOT NULL DEFAULT '0',
  `Name` varchar(255) NOT NULL,
  `ResistBody` tinyint(3) NOT NULL,
  `ResistCold` tinyint(3) NOT NULL,
  `ResistCrush` tinyint(3) NOT NULL,
  `ResistEnergy` tinyint(3) NOT NULL,
  `ResistHeat` tinyint(3) NOT NULL,
  `ResistMatter` tinyint(3) NOT NULL,
  `ResistNatural` tinyint(3) NOT NULL,
  `ResistSlash` tinyint(3) NOT NULL,
  `ResistSpirit` tinyint(3) NOT NULL,
  `ResistThrust` tinyint(3) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Race_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Race_ID`),
  UNIQUE KEY `U_Race_ID` (`ID`),
  UNIQUE KEY `U_Race_Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

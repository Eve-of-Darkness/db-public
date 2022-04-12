CREATE TABLE IF NOT EXISTS `KeepComponent` (
  `X` int(11) NOT NULL DEFAULT '0',
  `Y` int(11) NOT NULL DEFAULT '0',
  `Heading` int(11) NOT NULL DEFAULT '0',
  `Health` int(11) NOT NULL DEFAULT '0',
  `Skin` int(11) NOT NULL DEFAULT '0',
  `KeepID` int(11) NOT NULL DEFAULT '0',
  `ID` int(11) NOT NULL DEFAULT '0',
  `CreateInfo` varchar(255) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `KeepComponent_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`KeepComponent_ID`),
  KEY `I_KeepComponent_KeepID` (`KeepID`),
  KEY `I_KeepComponent_ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

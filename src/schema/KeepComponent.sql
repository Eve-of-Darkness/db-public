CREATE TABLE `KeepComponent` (
  `X` int(11) DEFAULT NULL,
  `Y` int(11) DEFAULT NULL,
  `Heading` int(11) DEFAULT NULL,
  `Health` int(11) NOT NULL,
  `Skin` int(11) DEFAULT NULL,
  `KeepID` int(11) DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `CreateInfo` varchar(255) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `KeepComponent_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`KeepComponent_ID`),
  KEY `I_KeepComponent_KeepID` (`KeepID`),
  KEY `I_KeepComponent_ID` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `Teleport`;

CREATE TABLE `Teleport` (
  `Type` text NOT NULL,
  `TeleportID` varchar(255) NOT NULL,
  `Realm` int(11) NOT NULL,
  `RegionID` int(11) NOT NULL,
  `X` int(11) NOT NULL,
  `Y` int(11) NOT NULL,
  `Z` int(11) NOT NULL,
  `Heading` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Teleport_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Teleport_ID`),
  KEY `I_Teleport_TeleportID` (`TeleportID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

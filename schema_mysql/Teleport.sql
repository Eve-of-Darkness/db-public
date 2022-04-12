DROP TABLE IF EXISTS `Teleport`;

CREATE TABLE `Teleport` (
  `Type` text NOT NULL,
  `TeleportID` varchar(255) NOT NULL,
  `Realm` int(11) NOT NULL DEFAULT '0',
  `RegionID` int(11) NOT NULL DEFAULT '0',
  `X` int(11) NOT NULL DEFAULT '0',
  `Y` int(11) NOT NULL DEFAULT '0',
  `Z` int(11) NOT NULL DEFAULT '0',
  `Heading` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Teleport_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Teleport_ID`),
  KEY `I_Teleport_TeleportID` (`TeleportID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

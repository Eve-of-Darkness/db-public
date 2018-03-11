CREATE TABLE IF NOT EXISTS `SinglePermission` (
  `PlayerID` varchar(255) NOT NULL,
  `Command` varchar(255) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `SinglePermission_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`SinglePermission_ID`),
  KEY `I_SinglePermission_PlayerID` (`PlayerID`),
  KEY `I_SinglePermission_Command` (`Command`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

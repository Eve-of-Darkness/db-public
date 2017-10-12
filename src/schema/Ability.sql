DROP TABLE IF EXISTS `Ability`;

CREATE TABLE `Ability` (
  `AbilityID` int(11) NOT NULL AUTO_INCREMENT,
  `KeyName` varchar(100) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `InternalID` int(11) DEFAULT NULL,
  `Description` text NOT NULL,
  `IconID` int(11) NOT NULL,
  `Implementation` varchar(255) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`AbilityID`),
  UNIQUE KEY `U_Ability_KeyName` (`KeyName`)
) ENGINE=InnoDB AUTO_INCREMENT=241 DEFAULT CHARSET=latin1;

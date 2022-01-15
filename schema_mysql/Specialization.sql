DROP TABLE IF EXISTS `Specialization`;

CREATE TABLE `Specialization` (
  `SpecializationID` int(11) NOT NULL AUTO_INCREMENT,
  `KeyName` varchar(100) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Icon` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Description` text,
  `Implementation` varchar(255) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`SpecializationID`),
  UNIQUE KEY `U_Specialization_KeyName` (`KeyName`)
) ENGINE=InnoDB AUTO_INCREMENT=225 DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

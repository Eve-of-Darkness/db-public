/*Table structure for table `specialization` */

DROP TABLE IF EXISTS `specialization`;

CREATE TABLE `specialization` (
  `SpecializationID` int(11) NOT NULL AUTO_INCREMENT,
  `KeyName` varchar(100) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Icon` smallint(5) unsigned NOT NULL,
  `Description` text,
  `Implementation` varchar(255) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`SpecializationID`),
  UNIQUE KEY `U_Specialization_KeyName` (`KeyName`)
) ENGINE=InnoDB AUTO_INCREMENT=225 DEFAULT CHARSET=latin1;

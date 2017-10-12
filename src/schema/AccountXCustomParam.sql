/*Table structure for table `accountxcustomparam` */

DROP TABLE IF EXISTS `accountxcustomparam`;

CREATE TABLE `accountxcustomparam` (
  `Name` varchar(255) NOT NULL,
  `KeyName` varchar(100) NOT NULL,
  `Value` varchar(255) DEFAULT NULL,
  `CustomParamID` int(11) NOT NULL AUTO_INCREMENT,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`CustomParamID`),
  KEY `I_AccountXCustomParam_Name` (`Name`),
  KEY `I_AccountXCustomParam_KeyName` (`KeyName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

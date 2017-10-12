DROP TABLE IF EXISTS `Account`;

CREATE TABLE `Account` (
  `Name` varchar(255) NOT NULL,
  `Password` text NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `LastLogin` datetime DEFAULT NULL,
  `Realm` int(11) DEFAULT NULL,
  `PrivLevel` int(10) unsigned DEFAULT NULL,
  `Status` int(11) DEFAULT NULL,
  `Mail` text,
  `LastLoginIP` varchar(255) DEFAULT NULL,
  `LastClientVersion` text,
  `Language` text,
  `IsMuted` tinyint(1) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Account_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Name`),
  UNIQUE KEY `U_Account_Account_ID` (`Account_ID`),
  KEY `I_Account_LastLoginIP` (`LastLoginIP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

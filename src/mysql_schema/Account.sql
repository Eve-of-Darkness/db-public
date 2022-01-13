CREATE TABLE IF NOT EXISTS `Account` (
  `Name` varchar(255) NOT NULL,
  `Password` text NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `LastLogin` datetime DEFAULT NULL,
  `Realm` int(11) NOT NULL DEFAULT '0',
  `PrivLevel` int(10) unsigned NOT NULL DEFAULT '0',
  `Status` int(11) NOT NULL DEFAULT '0',
  `Mail` text,
  `LastLoginIP` varchar(255) DEFAULT NULL,
  `LastClientVersion` text,
  `Language` text,
  `IsMuted` tinyint(1) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Account_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Name`),
  UNIQUE KEY `U_Account_Account_ID` (`Account_ID`),
  KEY `I_Account_LastLoginIP` (`LastLoginIP`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS `Ban` (
  `Author` text NOT NULL,
  `Type` varchar(255) NOT NULL,
  `Ip` varchar(255) NOT NULL,
  `Account` varchar(255) NOT NULL,
  `DateBan` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Reason` text NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Ban_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Ban_ID`),
  KEY `I_Ban_Type` (`Type`),
  KEY `I_Ban_Ip` (`Ip`),
  KEY `I_Ban_Account` (`Account`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

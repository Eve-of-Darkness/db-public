CREATE TABLE IF NOT EXISTS `Appeal` (
  `Name` varchar(255) NOT NULL,
  `Account` varchar(255) NOT NULL,
  `Severity` int(11) NOT NULL DEFAULT '0',
  `Status` text NOT NULL,
  `Timestamp` text NOT NULL,
  `Text` text NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Appeal_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Appeal_ID`),
  KEY `I_Appeal_Name` (`Name`),
  KEY `I_Appeal_Account` (`Account`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS `ServerProperty` (
  `Category` text NOT NULL,
  `Key` varchar(255) NOT NULL,
  `Description` text NOT NULL,
  `DefaultValue` text NOT NULL,
  `Value` text NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `ServerProperty_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Key`),
  UNIQUE KEY `U_ServerProperty_ServerProperty_ID` (`ServerProperty_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

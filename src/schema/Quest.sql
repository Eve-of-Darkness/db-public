DROP TABLE IF EXISTS `Quest`;

CREATE TABLE `Quest` (
  `Name` text NOT NULL,
  `Step` int(11) NOT NULL DEFAULT '0',
  `Character_ID` varchar(255) NOT NULL,
  `CustomPropertiesString` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Quest_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Quest_ID`),
  KEY `I_Quest_Character_ID` (`Character_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

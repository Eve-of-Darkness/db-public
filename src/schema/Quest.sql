/*Table structure for table `quest` */

DROP TABLE IF EXISTS `quest`;

CREATE TABLE `quest` (
  `Name` text NOT NULL,
  `Step` int(11) NOT NULL,
  `Character_ID` varchar(255) NOT NULL,
  `CustomPropertiesString` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Quest_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Quest_ID`),
  KEY `I_Quest_Character_ID` (`Character_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

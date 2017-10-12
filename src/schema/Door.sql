/*Table structure for table `door` */

DROP TABLE IF EXISTS `door`;

CREATE TABLE `door` (
  `Name` text,
  `Type` int(11) DEFAULT NULL,
  `Z` int(11) DEFAULT NULL,
  `Y` int(11) DEFAULT NULL,
  `X` int(11) DEFAULT NULL,
  `Heading` int(11) DEFAULT NULL,
  `InternalID` int(11) DEFAULT NULL,
  `Guild` text,
  `Level` tinyint(3) unsigned NOT NULL,
  `Realm` tinyint(3) unsigned NOT NULL,
  `Flags` int(10) unsigned DEFAULT NULL,
  `Locked` int(11) NOT NULL,
  `Health` int(11) NOT NULL,
  `MaxHealth` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Door_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Door_ID`),
  KEY `I_Door_InternalID` (`InternalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

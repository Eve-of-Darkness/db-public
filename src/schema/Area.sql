/*Table structure for table `area` */

DROP TABLE IF EXISTS `area`;

CREATE TABLE `area` (
  `TranslationId` text,
  `Description` text NOT NULL,
  `X` int(11) DEFAULT NULL,
  `Y` int(11) NOT NULL,
  `Z` int(11) NOT NULL,
  `Radius` int(11) NOT NULL,
  `Region` smallint(5) unsigned NOT NULL,
  `ClassType` text,
  `CanBroadcast` tinyint(1) DEFAULT NULL,
  `Sound` tinyint(3) unsigned DEFAULT NULL,
  `CheckLOS` tinyint(1) DEFAULT NULL,
  `Points` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Area_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Area_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

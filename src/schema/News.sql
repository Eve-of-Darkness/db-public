/*Table structure for table `news` */

DROP TABLE IF EXISTS `news`;

CREATE TABLE `news` (
  `CreationDate` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Type` tinyint(3) unsigned NOT NULL,
  `Realm` tinyint(3) unsigned DEFAULT NULL,
  `Text` text NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `News_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`News_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

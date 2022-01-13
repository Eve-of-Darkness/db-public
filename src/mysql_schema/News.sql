CREATE TABLE IF NOT EXISTS `News` (
  `CreationDate` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Realm` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Text` text NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `News_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`News_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

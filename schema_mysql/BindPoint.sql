DROP TABLE IF EXISTS `BindPoint`;

CREATE TABLE `BindPoint` (
  `X` int(11) NOT NULL DEFAULT '0',
  `Y` int(11) NOT NULL DEFAULT '0',
  `Z` int(11) NOT NULL DEFAULT '0',
  `Radius` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Region` int(11) NOT NULL DEFAULT '0',
  `Realm` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `BindPoint_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`BindPoint_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

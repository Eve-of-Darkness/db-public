CREATE TABLE `BindPoint` (
  `X` int(11) NOT NULL,
  `Y` int(11) NOT NULL,
  `Z` int(11) NOT NULL,
  `Radius` smallint(5) unsigned NOT NULL,
  `Region` int(11) NOT NULL,
  `Realm` int(11) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `BindPoint_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`BindPoint_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

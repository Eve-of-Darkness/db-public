DROP TABLE IF EXISTS `Battleground`;

CREATE TABLE `Battleground` (
  `RegionID` smallint(5) unsigned NOT NULL DEFAULT '0',
  `MinLevel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MaxLevel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `MaxRealmLevel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Battleground_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Battleground_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

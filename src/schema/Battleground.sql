CREATE TABLE `Battleground` (
  `RegionID` smallint(5) unsigned NOT NULL,
  `MinLevel` tinyint(3) unsigned NOT NULL,
  `MaxLevel` tinyint(3) unsigned NOT NULL,
  `MaxRealmLevel` tinyint(3) unsigned NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Battleground_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Battleground_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

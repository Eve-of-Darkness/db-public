CREATE TABLE IF NOT EXISTS `PvPKillsLog` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DateKilled` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `KilledName` text NOT NULL,
  `KillerName` text NOT NULL,
  `KillerIP` text NOT NULL,
  `KilledIP` text NOT NULL,
  `KilledRealm` text NOT NULL,
  `KillerRealm` text NOT NULL,
  `RPReward` int(11) NOT NULL DEFAULT '0',
  `SameIP` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `RegionName` text,
  `IsInstance` tinyint(1) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

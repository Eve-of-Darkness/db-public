DROP TABLE IF EXISTS `PvPKillsLog`;

CREATE TABLE `PvPKillsLog` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DateKilled` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `KilledName` text NOT NULL,
  `KillerName` text NOT NULL,
  `KillerIP` text NOT NULL,
  `KilledIP` text NOT NULL,
  `KilledRealm` text NOT NULL,
  `KillerRealm` text NOT NULL,
  `RPReward` int(11) NOT NULL,
  `SameIP` tinyint(3) unsigned NOT NULL,
  `RegionName` text,
  `IsInstance` tinyint(1) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

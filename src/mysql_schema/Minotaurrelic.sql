DROP TABLE IF EXISTS `Minotaurrelic`;

CREATE TABLE `Minotaurrelic` (
  `relicSpell` int(11) NOT NULL DEFAULT '0',
  `SpawnLocked` tinyint(1) NOT NULL DEFAULT '0',
  `ProtectorClassType` text NOT NULL,
  `relicTarget` text NOT NULL,
  `Name` text NOT NULL,
  `Model` smallint(5) unsigned NOT NULL DEFAULT '0',
  `SpawnX` int(11) NOT NULL DEFAULT '0',
  `SpawnY` int(11) NOT NULL DEFAULT '0',
  `SpawnZ` int(11) NOT NULL DEFAULT '0',
  `SpawnHeading` int(11) NOT NULL DEFAULT '0',
  `SpawnRegion` int(11) NOT NULL DEFAULT '0',
  `Effect` int(11) NOT NULL DEFAULT '0',
  `RelicID` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Minotaurrelic_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RelicID`),
  UNIQUE KEY `U_Minotaurrelic_Minotaurrelic_ID` (`Minotaurrelic_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

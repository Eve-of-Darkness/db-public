CREATE TABLE `Minotaurrelic` (
  `relicSpell` int(11) NOT NULL,
  `SpawnLocked` tinyint(1) NOT NULL,
  `ProtectorClassType` text NOT NULL,
  `relicTarget` text NOT NULL,
  `Name` text NOT NULL,
  `Model` smallint(5) unsigned NOT NULL,
  `SpawnX` int(11) NOT NULL,
  `SpawnY` int(11) NOT NULL,
  `SpawnZ` int(11) NOT NULL,
  `SpawnHeading` int(11) NOT NULL,
  `SpawnRegion` int(11) NOT NULL,
  `Effect` int(11) NOT NULL,
  `RelicID` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Minotaurrelic_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RelicID`),
  UNIQUE KEY `U_Minotaurrelic_Minotaurrelic_ID` (`Minotaurrelic_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

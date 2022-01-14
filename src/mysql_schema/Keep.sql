DROP TABLE IF EXISTS `Keep`;

CREATE TABLE `Keep` (
  `KeepID` int(11) NOT NULL DEFAULT '0',
  `Name` text NOT NULL,
  `Region` smallint(5) unsigned NOT NULL DEFAULT '0',
  `X` int(11) NOT NULL DEFAULT '0',
  `Y` int(11) NOT NULL DEFAULT '0',
  `Z` int(11) NOT NULL DEFAULT '0',
  `Heading` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Realm` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Level` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `ClaimedGuildName` text,
  `AlbionDifficultyLevel` int(11) NOT NULL DEFAULT '0',
  `MidgardDifficultyLevel` int(11) NOT NULL DEFAULT '0',
  `HiberniaDifficultyLevel` int(11) NOT NULL DEFAULT '0',
  `OriginalRealm` int(11) NOT NULL DEFAULT '0',
  `KeepType` int(11) NOT NULL DEFAULT '0',
  `BaseLevel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `SkinType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `CreateInfo` varchar(255) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Keep_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`KeepID`),
  UNIQUE KEY `U_Keep_Keep_ID` (`Keep_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

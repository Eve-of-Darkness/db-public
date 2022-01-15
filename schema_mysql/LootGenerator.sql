DROP TABLE IF EXISTS `LootGenerator`;

CREATE TABLE `LootGenerator` (
  `MobName` text,
  `MobGuild` text,
  `MobFaction` text,
  `RegionID` smallint(5) unsigned NOT NULL DEFAULT '0',
  `LootGeneratorClass` text NOT NULL,
  `ExclusivePriority` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `LootGenerator_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`LootGenerator_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

/*Table structure for table `lootgenerator` */

DROP TABLE IF EXISTS `lootgenerator`;

CREATE TABLE `lootgenerator` (
  `MobName` text,
  `MobGuild` text,
  `MobFaction` text,
  `RegionID` smallint(5) unsigned NOT NULL,
  `LootGeneratorClass` text NOT NULL,
  `ExclusivePriority` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `LootGenerator_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`LootGenerator_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

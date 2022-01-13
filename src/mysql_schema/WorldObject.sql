DROP TABLE IF EXISTS `WorldObject`;

CREATE TABLE `WorldObject` (
  `ClassType` text,
  `TranslationId` text,
  `Name` text NOT NULL,
  `ExamineArticle` text,
  `X` int(11) NOT NULL DEFAULT '0',
  `Y` int(11) NOT NULL DEFAULT '0',
  `Z` int(11) NOT NULL DEFAULT '0',
  `Heading` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Region` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Model` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Emblem` int(11) NOT NULL DEFAULT '0',
  `Realm` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `RespawnInterval` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `WorldObject_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`WorldObject_ID`),
  KEY `I_WorldObject_Region` (`Region`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

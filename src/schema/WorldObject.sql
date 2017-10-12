CREATE TABLE `WorldObject` (
  `ClassType` text,
  `TranslationId` text,
  `Name` text NOT NULL,
  `ExamineArticle` text,
  `X` int(11) NOT NULL,
  `Y` int(11) NOT NULL,
  `Z` int(11) NOT NULL,
  `Heading` smallint(5) unsigned NOT NULL,
  `Region` smallint(5) unsigned NOT NULL,
  `Model` smallint(5) unsigned NOT NULL,
  `Emblem` int(11) NOT NULL,
  `Realm` tinyint(3) unsigned NOT NULL,
  `RespawnInterval` int(11) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `WorldObject_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`WorldObject_ID`),
  KEY `I_WorldObject_Region` (`Region`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

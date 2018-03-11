DROP TABLE IF EXISTS `Area`;

CREATE TABLE `Area` (
  `TranslationId` text,
  `Description` text NOT NULL,
  `X` int(11) NOT NULL DEFAULT '0',
  `Y` int(11) NOT NULL DEFAULT '0',
  `Z` int(11) NOT NULL DEFAULT '0',
  `Radius` int(11) NOT NULL DEFAULT '0',
  `Region` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ClassType` text,
  `CanBroadcast` tinyint(1) NOT NULL DEFAULT '0',
  `Sound` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `CheckLOS` tinyint(1) NOT NULL DEFAULT '0',
  `Points` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Area_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Area_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

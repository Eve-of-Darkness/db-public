DROP TABLE IF EXISTS `Door`;
CREATE TABLE `Door` (
  `Name` text,
  `Type` int(11) NOT NULL DEFAULT '0',
  `Z` int(11) NOT NULL DEFAULT '0',
  `Y` int(11) NOT NULL DEFAULT '0',
  `X` int(11) NOT NULL DEFAULT '0',
  `Heading` int(11) NOT NULL DEFAULT '0',
  `InternalID` int(11) NOT NULL DEFAULT '0',
  `Guild` text,
  `Level` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Realm` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Flags` int(10) unsigned NOT NULL DEFAULT '0',
  `Locked` int(11) NOT NULL DEFAULT '0',
  `Health` int(11) NOT NULL DEFAULT '0',
  `MaxHealth` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Door_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Door_ID`),
  KEY `I_Door_InternalID` (`InternalID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

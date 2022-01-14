DROP TABLE IF EXISTS `InstanceXElement`;

CREATE TABLE `InstanceXElement` (
  `InstanceID` varchar(255) NOT NULL,
  `ClassType` text,
  `X` int(11) NOT NULL DEFAULT '0',
  `Y` int(11) NOT NULL DEFAULT '0',
  `Z` int(11) NOT NULL DEFAULT '0',
  `Heading` smallint(5) unsigned NOT NULL DEFAULT '0',
  `NPCTemplate` varchar(255) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `InstanceXElement_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`InstanceXElement_ID`),
  KEY `I_InstanceXElement_InstanceID` (`InstanceID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

CREATE TABLE `InstanceXElement` (
  `InstanceID` varchar(255) NOT NULL,
  `ClassType` text,
  `X` int(11) NOT NULL,
  `Y` int(11) NOT NULL,
  `Z` int(11) NOT NULL,
  `Heading` smallint(5) unsigned NOT NULL,
  `NPCTemplate` varchar(255) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `InstanceXElement_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`InstanceXElement_ID`),
  KEY `I_InstanceXElement_InstanceID` (`InstanceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

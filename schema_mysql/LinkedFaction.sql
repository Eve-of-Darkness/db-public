DROP TABLE IF EXISTS `LinkedFaction`;

CREATE TABLE `LinkedFaction` (
  `FactionID` int(11) NOT NULL DEFAULT '0',
  `LinkedFactionID` int(11) NOT NULL DEFAULT '0',
  `IsFriend` tinyint(1) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `LinkedFaction_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`LinkedFaction_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

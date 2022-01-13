DROP TABLE IF EXISTS `FactionAggroLevel`;

CREATE TABLE `FactionAggroLevel` (
  `CharacterID` varchar(100) NOT NULL,
  `FactionID` int(11) NOT NULL DEFAULT '0',
  `AggroLevel` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `FactionAggroLevel_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`FactionAggroLevel_ID`),
  KEY `I_FactionAggroLevel_CharacterID` (`CharacterID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

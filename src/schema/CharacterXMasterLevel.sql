CREATE TABLE IF NOT EXISTS `CharacterXMasterLevel` (
  `Character_ID` varchar(255) NOT NULL,
  `MLLevel` int(11) NOT NULL DEFAULT '0',
  `MLStep` int(11) NOT NULL DEFAULT '0',
  `StepCompleted` tinyint(1) NOT NULL DEFAULT '0',
  `ValidationDate` datetime DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `CharacterXMasterLevel_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`CharacterXMasterLevel_ID`),
  KEY `I_CharacterXMasterLevel_Character_ID` (`Character_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

CREATE TABLE IF NOT EXISTS `CharacterXDataQuest` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` varchar(100) NOT NULL,
  `DataQuestID` int(11) NOT NULL DEFAULT '0',
  `Step` smallint(6) NOT NULL DEFAULT '0',
  `Count` smallint(6) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `I_CharacterXDataQuest_Character_ID` (`DataQuestID`,`Character_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

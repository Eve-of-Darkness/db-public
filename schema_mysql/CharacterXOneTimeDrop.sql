CREATE TABLE IF NOT EXISTS `CharacterXOneTimeDrop` (
  `CharacterID` varchar(100) NOT NULL,
  `ItemTemplateID` varchar(100) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `CharacterXOneTimeDrop_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`CharacterXOneTimeDrop_ID`),
  KEY `I_CharacterXOneTimeDrop_CharacterID` (`CharacterID`),
  KEY `I_CharacterXOneTimeDrop_ItemTemplateID` (`ItemTemplateID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

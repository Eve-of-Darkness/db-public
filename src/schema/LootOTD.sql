DROP TABLE IF EXISTS `LootOTD`;

CREATE TABLE `LootOTD` (
  `MobName` varchar(100) NOT NULL,
  `ItemTemplateID` varchar(100) NOT NULL,
  `MinLevel` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `LootOTD_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`LootOTD_ID`),
  KEY `I_LootOTD_MobName` (`MobName`),
  KEY `I_LootOTD_ItemTemplateID` (`ItemTemplateID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

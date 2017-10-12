CREATE TABLE `LootTemplate` (
  `TemplateName` varchar(255) NOT NULL,
  `ItemTemplateID` text NOT NULL,
  `Chance` int(11) NOT NULL,
  `Count` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `LootTemplate_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`LootTemplate_ID`),
  KEY `I_LootTemplate_TemplateName` (`TemplateName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

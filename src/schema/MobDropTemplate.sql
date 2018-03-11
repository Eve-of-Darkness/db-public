DROP TABLE IF EXISTS `MobDropTemplate`;

CREATE TABLE `MobDropTemplate` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `MobName` varchar(255) NOT NULL,
  `LootTemplateName` varchar(255) NOT NULL,
  `DropCount` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `I_MobDropTemplate_MobName` (`MobName`),
  KEY `I_MobDropTemplate_LootTemplateName` (`LootTemplateName`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

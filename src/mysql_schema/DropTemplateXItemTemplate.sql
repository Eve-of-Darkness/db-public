DROP TABLE IF EXISTS `DropTemplateXItemTemplate`;

CREATE TABLE `DropTemplateXItemTemplate` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `TemplateName` varchar(255) NOT NULL,
  `ItemTemplateID` text NOT NULL,
  `Chance` int(11) NOT NULL DEFAULT '0',
  `Count` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `I_DropTemplateXItemTemplate_TemplateName` (`TemplateName`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

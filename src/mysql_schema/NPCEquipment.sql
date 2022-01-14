DROP TABLE IF EXISTS `NPCEquipment`;

CREATE TABLE `NPCEquipment` (
  `TemplateID` varchar(255) NOT NULL,
  `Slot` int(11) NOT NULL DEFAULT '0',
  `Model` int(11) NOT NULL DEFAULT '0',
  `Color` int(11) NOT NULL DEFAULT '0',
  `Effect` int(11) NOT NULL DEFAULT '0',
  `Extension` int(11) NOT NULL DEFAULT '0',
  `Emblem` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `NPCEquipment_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`NPCEquipment_ID`),
  KEY `I_NPCEquipment_TemplateID` (`TemplateID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

/*Table structure for table `npcequipment` */

DROP TABLE IF EXISTS `npcequipment`;

CREATE TABLE `npcequipment` (
  `TemplateID` varchar(255) NOT NULL,
  `Slot` int(11) NOT NULL,
  `Model` int(11) NOT NULL,
  `Color` int(11) DEFAULT NULL,
  `Effect` int(11) DEFAULT NULL,
  `Extension` int(11) DEFAULT NULL,
  `Emblem` int(11) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `NPCEquipment_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`NPCEquipment_ID`),
  KEY `I_NPCEquipment_TemplateID` (`TemplateID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

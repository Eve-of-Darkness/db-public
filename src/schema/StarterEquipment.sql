DROP TABLE IF EXISTS `StarterEquipment`;

CREATE TABLE `StarterEquipment` (
  `StarterEquipmentID` int(11) NOT NULL AUTO_INCREMENT,
  `Class` text NOT NULL,
  `TemplateID` varchar(255) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`StarterEquipmentID`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

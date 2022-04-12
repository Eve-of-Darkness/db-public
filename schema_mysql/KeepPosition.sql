DROP TABLE IF EXISTS `KeepPosition`;

CREATE TABLE `KeepPosition` (
  `ComponentSkin` int(11) NOT NULL DEFAULT '0',
  `ComponentRotation` int(11) NOT NULL DEFAULT '0',
  `TemplateID` varchar(255) NOT NULL,
  `Height` int(11) NOT NULL DEFAULT '0',
  `XOff` int(11) NOT NULL DEFAULT '0',
  `YOff` int(11) NOT NULL DEFAULT '0',
  `ZOff` int(11) NOT NULL DEFAULT '0',
  `HOff` int(11) NOT NULL DEFAULT '0',
  `ClassType` varchar(255) DEFAULT NULL,
  `TemplateType` int(11) NOT NULL DEFAULT '0',
  `KeepType` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `KeepPosition_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`KeepPosition_ID`),
  KEY `I_KeepPosition_ComponentSkin` (`ComponentSkin`),
  KEY `I_KeepPosition_TemplateID` (`TemplateID`),
  KEY `I_KeepPosition_Height` (`Height`),
  KEY `I_KeepPosition_ClassType` (`ClassType`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

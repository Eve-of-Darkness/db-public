/*Table structure for table `keepposition` */

DROP TABLE IF EXISTS `keepposition`;

CREATE TABLE `keepposition` (
  `ComponentSkin` int(11) DEFAULT NULL,
  `ComponentRotation` int(11) DEFAULT NULL,
  `TemplateID` varchar(255) DEFAULT NULL,
  `Height` int(11) DEFAULT NULL,
  `XOff` int(11) DEFAULT NULL,
  `YOff` int(11) DEFAULT NULL,
  `ZOff` int(11) DEFAULT NULL,
  `HOff` int(11) DEFAULT NULL,
  `ClassType` varchar(255) DEFAULT NULL,
  `TemplateType` int(11) DEFAULT NULL,
  `KeepType` int(11) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `KeepPosition_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`KeepPosition_ID`),
  KEY `I_KeepPosition_ComponentSkin` (`ComponentSkin`),
  KEY `I_KeepPosition_TemplateID` (`TemplateID`),
  KEY `I_KeepPosition_Height` (`Height`),
  KEY `I_KeepPosition_ClassType` (`ClassType`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `SpellLine`;

CREATE TABLE `SpellLine` (
  `SpellLineID` int(11) NOT NULL AUTO_INCREMENT,
  `KeyName` varchar(255) NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Spec` varchar(100) DEFAULT NULL,
  `IsBaseLine` tinyint(1) NOT NULL DEFAULT '0',
  `ClassIDHint` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`SpellLineID`),
  UNIQUE KEY `U_SpellLine_KeyName` (`KeyName`),
  KEY `I_SpellLine_Spec` (`Spec`)
) ENGINE=InnoDB AUTO_INCREMENT=1463 DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

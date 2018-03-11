DROP TABLE IF EXISTS `SpecXAbility`;

CREATE TABLE `SpecXAbility` (
  `SpecXabilityID` int(11) NOT NULL AUTO_INCREMENT,
  `Spec` varchar(100) NOT NULL,
  `SpecLevel` int(11) NOT NULL DEFAULT '0',
  `AbilityKey` varchar(100) NOT NULL,
  `AbilityLevel` int(11) NOT NULL DEFAULT '0',
  `ClassId` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`SpecXabilityID`),
  KEY `I_SpecXAbility_Spec` (`Spec`),
  KEY `I_SpecXAbility_AbilityKey` (`AbilityKey`)
) ENGINE=InnoDB AUTO_INCREMENT=367 DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

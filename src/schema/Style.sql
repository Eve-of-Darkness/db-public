DROP TABLE IF EXISTS `Style`;

CREATE TABLE `Style` (
  `StyleID` int(11) NOT NULL AUTO_INCREMENT,
  `ID` int(11) NOT NULL DEFAULT '0',
  `ClassId` int(11) NOT NULL DEFAULT '0',
  `Name` varchar(255) NOT NULL,
  `SpecKeyName` varchar(100) NOT NULL,
  `SpecLevelRequirement` int(11) NOT NULL DEFAULT '0',
  `Icon` int(11) NOT NULL DEFAULT '0',
  `EnduranceCost` int(11) NOT NULL DEFAULT '0',
  `StealthRequirement` tinyint(1) NOT NULL DEFAULT '0',
  `OpeningRequirementType` int(11) NOT NULL DEFAULT '0',
  `OpeningRequirementValue` int(11) NOT NULL DEFAULT '0',
  `AttackResultRequirement` int(11) NOT NULL DEFAULT '0',
  `WeaponTypeRequirement` int(11) NOT NULL DEFAULT '0',
  `GrowthOffset` double NOT NULL DEFAULT '0',
  `GrowthRate` double NOT NULL DEFAULT '0',
  `BonusToHit` int(11) NOT NULL DEFAULT '0',
  `BonusToDefense` int(11) NOT NULL DEFAULT '0',
  `TwoHandAnimation` int(11) NOT NULL DEFAULT '0',
  `RandomProc` tinyint(1) NOT NULL DEFAULT '0',
  `ArmorHitLocation` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`StyleID`),
  KEY `I_Style_SpecKeyName` (`SpecKeyName`)
) ENGINE=InnoDB AUTO_INCREMENT=50014 DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

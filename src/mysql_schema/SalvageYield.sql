DROP TABLE IF EXISTS `SalvageYield`;

CREATE TABLE `SalvageYield` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ObjectType` int(11) NOT NULL DEFAULT '0',
  `SalvageLevel` int(11) NOT NULL DEFAULT '0',
  `MaterialId_nb` text NOT NULL,
  `Count` int(11) NOT NULL DEFAULT '0',
  `Realm` int(11) NOT NULL DEFAULT '0',
  `PackageID` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `I_SalvageYield_ObjectType` (`ObjectType`),
  KEY `I_SalvageYield_SalvageLevel` (`SalvageLevel`),
  KEY `I_SalvageYield_Realm` (`Realm`)
) ENGINE=InnoDB AUTO_INCREMENT=366 DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

/*Table structure for table `salvage` */

DROP TABLE IF EXISTS `salvage`;

CREATE TABLE `salvage` (
  `ObjectType` int(11) NOT NULL,
  `SalvageLevel` int(11) NOT NULL,
  `Id_nb` text NOT NULL,
  `Realm` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Salvage_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Salvage_ID`),
  KEY `I_Salvage_ObjectType` (`ObjectType`),
  KEY `I_Salvage_SalvageLevel` (`SalvageLevel`),
  KEY `I_Salvage_Realm` (`Realm`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `DBOutdoorItem`;

CREATE TABLE `DBOutdoorItem` (
  `HouseNumber` int(11) NOT NULL DEFAULT '0',
  `Model` int(11) NOT NULL DEFAULT '0',
  `Position` int(11) NOT NULL DEFAULT '0',
  `Rotation` int(11) NOT NULL DEFAULT '0',
  `BaseItemID` text NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `DBOutdoorItem_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`DBOutdoorItem_ID`),
  KEY `I_DBOutdoorItem_HouseNumber` (`HouseNumber`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

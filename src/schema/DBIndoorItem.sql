DROP TABLE IF EXISTS `DBIndoorItem`;
CREATE TABLE `DBIndoorItem` (
  `HouseNumber` int(11) NOT NULL DEFAULT '0',
  `Model` int(11) NOT NULL DEFAULT '0',
  `Position` int(11) NOT NULL DEFAULT '0',
  `Placemode` int(11) NOT NULL DEFAULT '0',
  `X` int(11) NOT NULL DEFAULT '0',
  `Y` int(11) NOT NULL DEFAULT '0',
  `BaseItemID` text NOT NULL,
  `Color` int(11) NOT NULL DEFAULT '0',
  `Emblem` int(11) NOT NULL DEFAULT '0',
  `Rotation` int(11) NOT NULL DEFAULT '0',
  `Size` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `DBIndoorItem_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`DBIndoorItem_ID`),
  KEY `I_DBIndoorItem_HouseNumber` (`HouseNumber`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

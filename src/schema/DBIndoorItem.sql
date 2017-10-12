CREATE TABLE `DBIndoorItem` (
  `HouseNumber` int(11) NOT NULL,
  `Model` int(11) NOT NULL,
  `Position` int(11) NOT NULL,
  `Placemode` int(11) NOT NULL,
  `X` int(11) NOT NULL,
  `Y` int(11) NOT NULL,
  `BaseItemID` text NOT NULL,
  `Color` int(11) DEFAULT NULL,
  `Emblem` int(11) DEFAULT NULL,
  `Rotation` int(11) DEFAULT NULL,
  `Size` int(11) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `DBIndoorItem_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`DBIndoorItem_ID`),
  KEY `I_DBIndoorItem_HouseNumber` (`HouseNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `PathPoints`;

CREATE TABLE `PathPoints` (
  `PathID` varchar(255) NOT NULL,
  `Step` int(11) NOT NULL DEFAULT '0',
  `X` int(11) NOT NULL DEFAULT '0',
  `Y` int(11) NOT NULL DEFAULT '0',
  `Z` int(11) NOT NULL DEFAULT '0',
  `MaxSpeed` int(11) NOT NULL DEFAULT '0',
  `WaitTime` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `PathPoints_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`PathPoints_ID`),
  KEY `I_PathPoints_PathID` (`PathID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

DROP TABLE IF EXISTS `PathPoints`;

CREATE TABLE `PathPoints` (
  `PathID` varchar(255) NOT NULL,
  `Step` int(11) NOT NULL,
  `X` int(11) NOT NULL,
  `Y` int(11) NOT NULL,
  `Z` int(11) NOT NULL,
  `MaxSpeed` int(11) DEFAULT NULL,
  `WaitTime` int(11) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `PathPoints_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`PathPoints_ID`),
  KEY `I_PathPoints_PathID` (`PathID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

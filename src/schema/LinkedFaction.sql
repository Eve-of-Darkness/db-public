/*Table structure for table `linkedfaction` */

DROP TABLE IF EXISTS `linkedfaction`;

CREATE TABLE `linkedfaction` (
  `FactionID` int(11) NOT NULL,
  `LinkedFactionID` int(11) DEFAULT NULL,
  `IsFriend` tinyint(1) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `LinkedFaction_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`LinkedFaction_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

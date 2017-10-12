/*Table structure for table `startuplocation` */

DROP TABLE IF EXISTS `startuplocation`;

CREATE TABLE `startuplocation` (
  `StartupLoc_ID` int(11) NOT NULL AUTO_INCREMENT,
  `XPos` int(11) NOT NULL,
  `YPos` int(11) NOT NULL,
  `ZPos` int(11) NOT NULL,
  `Heading` int(11) NOT NULL,
  `Region` int(11) NOT NULL,
  `MinVersion` int(11) NOT NULL,
  `RealmID` int(11) NOT NULL,
  `RaceID` int(11) NOT NULL,
  `ClassID` int(11) NOT NULL,
  `ClientRegionID` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`StartupLoc_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=latin1;

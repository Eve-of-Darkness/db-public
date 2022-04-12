DROP TABLE IF EXISTS `StartupLocation`;

CREATE TABLE `StartupLocation` (
  `StartupLoc_ID` int(11) NOT NULL AUTO_INCREMENT,
  `XPos` int(11) NOT NULL DEFAULT '0',
  `YPos` int(11) NOT NULL DEFAULT '0',
  `ZPos` int(11) NOT NULL DEFAULT '0',
  `Heading` int(11) NOT NULL DEFAULT '0',
  `Region` int(11) NOT NULL DEFAULT '0',
  `MinVersion` int(11) NOT NULL DEFAULT '0',
  `RealmID` int(11) NOT NULL DEFAULT '0',
  `RaceID` int(11) NOT NULL DEFAULT '0',
  `ClassID` int(11) NOT NULL DEFAULT '0',
  `ClientRegionID` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`StartupLoc_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

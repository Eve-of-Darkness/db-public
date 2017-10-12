DROP TABLE IF EXISTS `househookpointoffset`;

CREATE TABLE `househookpointoffset` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `HouseModel` int(11) NOT NULL,
  `HookpointID` int(11) NOT NULL,
  `X` int(11) NOT NULL,
  `Y` int(11) NOT NULL,
  `Z` int(11) NOT NULL,
  `Heading` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=latin1;

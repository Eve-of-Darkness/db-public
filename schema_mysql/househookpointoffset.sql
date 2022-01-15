DROP TABLE IF EXISTS `househookpointoffset`;

CREATE TABLE `househookpointoffset` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `HouseModel` int(11) NOT NULL DEFAULT '0',
  `HookpointID` int(11) NOT NULL DEFAULT '0',
  `X` int(11) NOT NULL DEFAULT '0',
  `Y` int(11) NOT NULL DEFAULT '0',
  `Z` int(11) NOT NULL DEFAULT '0',
  `Heading` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

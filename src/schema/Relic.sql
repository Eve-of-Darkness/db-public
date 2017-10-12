DROP TABLE IF EXISTS `Relic`;

CREATE TABLE `Relic` (
  `RelicID` int(11) NOT NULL,
  `Region` int(11) NOT NULL,
  `X` int(11) NOT NULL,
  `Y` int(11) NOT NULL,
  `Z` int(11) NOT NULL,
  `Heading` int(11) NOT NULL,
  `Realm` int(11) NOT NULL,
  `OriginalRealm` int(11) NOT NULL,
  `LastRealm` int(11) NOT NULL,
  `relicType` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Relic_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RelicID`),
  UNIQUE KEY `U_Relic_Relic_ID` (`Relic_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `Relic` (
  `RelicID` int(11) NOT NULL DEFAULT '0',
  `Region` int(11) NOT NULL DEFAULT '0',
  `X` int(11) NOT NULL DEFAULT '0',
  `Y` int(11) NOT NULL DEFAULT '0',
  `Z` int(11) NOT NULL DEFAULT '0',
  `Heading` int(11) NOT NULL DEFAULT '0',
  `Realm` int(11) NOT NULL DEFAULT '0',
  `OriginalRealm` int(11) NOT NULL DEFAULT '0',
  `LastRealm` int(11) NOT NULL DEFAULT '0',
  `relicType` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Relic_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`RelicID`),
  UNIQUE KEY `U_Relic_Relic_ID` (`Relic_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

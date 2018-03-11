DROP TABLE IF EXISTS `househookpointitem`;

CREATE TABLE `househookpointitem` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `HouseNumber` int(11) NOT NULL DEFAULT '0',
  `HookpointID` int(10) unsigned NOT NULL DEFAULT '0',
  `Heading` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ItemTemplateID` text,
  `Index` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `I_househookpointitem_HouseNumber` (`HouseNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=10019 DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

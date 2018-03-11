DROP TABLE IF EXISTS `TownCrierMessages`;

CREATE TABLE `TownCrierMessages` (
  `TownCrierID` varchar(255) NOT NULL,
  `Message` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `TownCrierMessages_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`TownCrierID`),
  UNIQUE KEY `U_TownCrierMessages_TownCrierMessages_ID` (`TownCrierMessages_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

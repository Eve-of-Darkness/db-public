CREATE TABLE IF NOT EXISTS `HouseConsignmentMerchant` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `OwnerID` varchar(128) NOT NULL,
  `HouseNumber` int(11) NOT NULL DEFAULT '0',
  `Money` bigint(20) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `I_HouseConsignmentMerchant_OwnerID` (`OwnerID`),
  KEY `I_HouseConsignmentMerchant_HouseNumber` (`HouseNumber`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

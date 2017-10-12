/*Table structure for table `houseconsignmentmerchant` */

DROP TABLE IF EXISTS `houseconsignmentmerchant`;

CREATE TABLE `houseconsignmentmerchant` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `OwnerID` varchar(128) NOT NULL,
  `HouseNumber` int(11) NOT NULL,
  `Money` bigint(20) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `I_HouseConsignmentMerchant_OwnerID` (`OwnerID`),
  KEY `I_HouseConsignmentMerchant_HouseNumber` (`HouseNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `autoxmlupdate` */

DROP TABLE IF EXISTS `autoxmlupdate`;

CREATE TABLE `autoxmlupdate` (
  `AutoXMLUpdateID` int(11) NOT NULL AUTO_INCREMENT,
  `FilePackage` varchar(255) NOT NULL,
  `FileHash` varchar(255) NOT NULL,
  `LoadResult` varchar(255) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`AutoXMLUpdateID`),
  KEY `I_AutoXMLUpdate_FilePackage` (`FilePackage`),
  KEY `I_AutoXMLUpdate_FileHash` (`FileHash`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `autoxmlupdate` */

insert  into `autoxmlupdate`(`AutoXMLUpdateID`,`FilePackage`,`FileHash`,`LoadResult`,`LastTimeRowUpdated`) values 
(1,'insert/Regions.xml','77694BCEF178910963CA4AAB8A2F2C4BB516F2D806CA45A2C6507E7A40E48D90','SUCCESS','2015-07-15 14:21:34'),
(2,'insert/StartupLocation.xml','FEE54D03B3DEF5E2200F001A6CAB53262B2274826AA9098407AADB1F60E98D3B','SUCCESS','2017-03-19 02:39:38'),
(3,'insert/Zones.xml','BF0F75876DAB29BAFBA98F06DF4B401089ED5425498EF099588EEC9CA9B8ECA7','SUCCESS','2015-07-15 14:21:35');

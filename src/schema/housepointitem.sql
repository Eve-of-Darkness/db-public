/*Table structure for table `housepointitem` */

DROP TABLE IF EXISTS `housepointitem`;

CREATE TABLE `housepointitem` (
  `housepointitem_ID` varchar(255) NOT NULL,
  `HouseID` int(11) NOT NULL,
  `Position` int(10) unsigned NOT NULL,
  `ItemTemplateID` mediumtext,
  `Index` tinyint(3) unsigned DEFAULT NULL,
  `Heading` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`housepointitem_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

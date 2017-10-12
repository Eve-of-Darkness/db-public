/*Table structure for table `craftedxitem` */

DROP TABLE IF EXISTS `craftedxitem`;

CREATE TABLE `craftedxitem` (
  `CraftedItemId_nb` varchar(255) NOT NULL,
  `IngredientId_nb` text NOT NULL,
  `Count` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `CraftedXItem_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`CraftedXItem_ID`),
  KEY `I_CraftedXItem_CraftedItemId_nb` (`CraftedItemId_nb`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

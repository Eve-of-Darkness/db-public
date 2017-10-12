/*Table structure for table `inventory` */

DROP TABLE IF EXISTS `inventory`;

CREATE TABLE `inventory` (
  `OwnerID` varchar(255) NOT NULL,
  `OwnerLot` smallint(5) unsigned DEFAULT NULL,
  `ITemplate_Id` varchar(255) DEFAULT NULL,
  `UTemplate_Id` varchar(255) DEFAULT NULL,
  `IsCrafted` tinyint(1) DEFAULT NULL,
  `Creator` text,
  `SlotPosition` int(11) DEFAULT NULL,
  `Count` int(11) DEFAULT NULL,
  `SellPrice` int(11) DEFAULT NULL,
  `Experience` bigint(20) DEFAULT NULL,
  `Color` int(11) DEFAULT NULL,
  `Emblem` int(11) DEFAULT NULL,
  `Extension` tinyint(3) unsigned DEFAULT NULL,
  `Condition` int(11) NOT NULL,
  `Durability` int(11) NOT NULL,
  `PoisonSpellID` int(11) DEFAULT NULL,
  `PoisonMaxCharges` int(11) DEFAULT NULL,
  `PoisonCharges` int(11) DEFAULT NULL,
  `Charges` int(11) DEFAULT NULL,
  `Charges1` int(11) DEFAULT NULL,
  `Cooldown` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Inventory_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Inventory_ID`),
  KEY `I_Inventory_OwnerID` (`OwnerID`),
  KEY `I_Inventory_ITemplate_Id` (`ITemplate_Id`),
  KEY `I_Inventory_UTemplate_Id` (`UTemplate_Id`),
  KEY `I_Inventory_SlotPosition` (`SlotPosition`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

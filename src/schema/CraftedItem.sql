DROP TABLE IF EXISTS `CraftedItem`;

CREATE TABLE `CraftedItem` (
  `CraftedItemID` varchar(255) NOT NULL,
  `Id_nb` varchar(255) NOT NULL,
  `CraftingLevel` int(11) NOT NULL,
  `CraftingSkillType` int(11) NOT NULL,
  `MakeTemplated` tinyint(1) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `CraftedItem_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CraftedItemID`),
  UNIQUE KEY `U_CraftedItem_CraftedItem_ID` (`CraftedItem_ID`),
  KEY `I_CraftedItem_Id_nb` (`Id_nb`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

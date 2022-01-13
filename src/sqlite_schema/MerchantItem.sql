DROP TABLE IF EXISTS `MerchantItem`;

CREATE TABLE `MerchantItem` (`ItemListID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
`ItemTemplateID` TEXT NOT NULL DEFAULT '' COLLATE NOCASE, 
`PageNumber` INT(11) NOT NULL DEFAULT 0, 
`SlotPosition` INT(11) NOT NULL DEFAULT 0, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00', 
`MerchantItem_ID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
PRIMARY KEY (`MerchantItem_ID`));
CREATE INDEX `I_MerchantItem_ItemListID` ON `MerchantItem` (`ItemListID`);
CREATE INDEX `I_MerchantItem_PageNumber` ON `MerchantItem` (`PageNumber`);
CREATE INDEX `I_MerchantItem_SlotPosition` ON `MerchantItem` (`SlotPosition`);

CREATE TABLE IF NOT EXISTS `HouseConsignmentMerchant` (`ID` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
`OwnerID` VARCHAR(128) NOT NULL DEFAULT '' COLLATE NOCASE, 
`HouseNumber` INT(11) NOT NULL DEFAULT 0, 
`Money` BIGINT(20) NOT NULL DEFAULT 0, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00');
CREATE INDEX `I_HouseConsignmentMerchant_OwnerID` ON `HouseConsignmentMerchant` (`OwnerID`);
CREATE INDEX `I_HouseConsignmentMerchant_HouseNumber` ON `HouseConsignmentMerchant` (`HouseNumber`);

DROP TABLE IF EXISTS `MobXLootTemplate`;

CREATE TABLE `MobXLootTemplate` (`MobName` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
`LootTemplateName` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
`DropCount` INT(11) NOT NULL DEFAULT 0, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00', 
`MobXLootTemplate_ID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
PRIMARY KEY (`MobXLootTemplate_ID`));
CREATE INDEX `I_MobXLootTemplate_MobName` ON `MobXLootTemplate` (`MobName`);
CREATE INDEX `I_MobXLootTemplate_LootTemplateName` ON `MobXLootTemplate` (`LootTemplateName`);

DROP TABLE IF EXISTS `MobDropTemplate`;

CREATE TABLE `MobDropTemplate` (`ID` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
`MobName` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
`LootTemplateName` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
`DropCount` INT(11) NOT NULL DEFAULT 0, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00');
CREATE INDEX `I_MobDropTemplate_MobName` ON `MobDropTemplate` (`MobName`);
CREATE INDEX `I_MobDropTemplate_LootTemplateName` ON `MobDropTemplate` (`LootTemplateName`);

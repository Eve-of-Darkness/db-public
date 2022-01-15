DROP TABLE IF EXISTS `LanguageSystem`;

CREATE TABLE `LanguageSystem` (`Text` TEXT NOT NULL DEFAULT '' COLLATE NOCASE, 
`TranslationId` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
`Language` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
`Tag` TEXT DEFAULT NULL COLLATE NOCASE, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00', 
`LanguageSystem_ID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
PRIMARY KEY (`LanguageSystem_ID`));
CREATE INDEX `I_LanguageSystem_TranslationId` ON `LanguageSystem` (`TranslationId`);
CREATE INDEX `I_LanguageSystem_Language` ON `LanguageSystem` (`Language`);

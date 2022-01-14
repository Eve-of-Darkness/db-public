DROP TABLE IF EXISTS `LanguageGameObject`;

CREATE TABLE `LanguageGameObject` (`Name` TEXT DEFAULT NULL COLLATE NOCASE, 
`ExamineArticle` TEXT DEFAULT NULL COLLATE NOCASE, 
`TranslationId` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
`Language` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
`Tag` TEXT DEFAULT NULL COLLATE NOCASE, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00', 
`LanguageGameObject_ID` VARCHAR(255) NOT NULL DEFAULT '' COLLATE NOCASE, 
PRIMARY KEY (`LanguageGameObject_ID`));
CREATE INDEX `I_LanguageGameObject_TranslationId` ON `LanguageGameObject` (`TranslationId`);
CREATE INDEX `I_LanguageGameObject_Language` ON `LanguageGameObject` (`Language`);

DROP TABLE IF EXISTS `LanguageSystem`;

CREATE TABLE `LanguageSystem` (
  `Text` text NOT NULL,
  `TranslationId` varchar(255) NOT NULL,
  `Language` varchar(255) NOT NULL,
  `Tag` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `LanguageSystem_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`LanguageSystem_ID`),
  KEY `I_LanguageSystem_TranslationId` (`TranslationId`),
  KEY `I_LanguageSystem_Language` (`Language`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

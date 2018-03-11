DROP TABLE IF EXISTS `LanguageArea`;

CREATE TABLE `LanguageArea` (
  `Description` text NOT NULL,
  `ScreenDescription` text NOT NULL,
  `TranslationId` varchar(255) NOT NULL,
  `Language` varchar(255) NOT NULL,
  `Tag` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `LanguageArea_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`LanguageArea_ID`),
  KEY `I_LanguageArea_TranslationId` (`TranslationId`),
  KEY `I_LanguageArea_Language` (`Language`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

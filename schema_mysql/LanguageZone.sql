DROP TABLE IF EXISTS `LanguageZone`;

CREATE TABLE `LanguageZone` (
  `Description` text NOT NULL,
  `ScreenDescription` text NOT NULL,
  `TranslationId` varchar(255) NOT NULL,
  `Language` varchar(255) NOT NULL,
  `Tag` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `LanguageZone_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`LanguageZone_ID`),
  KEY `I_LanguageZone_TranslationId` (`TranslationId`),
  KEY `I_LanguageZone_Language` (`Language`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

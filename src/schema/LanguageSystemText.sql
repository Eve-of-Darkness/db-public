/* TODO: Possible delete - LT 10/2017 */

DROP TABLE IF EXISTS `languagesystemtext`;

CREATE TABLE `languagesystemtext` (
  `TranslationId` varchar(255) CHARACTER SET latin1 NOT NULL,
  `Text` text CHARACTER SET latin1 NOT NULL,
  `TranslationUnique` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `Language` varchar(255) CHARACTER SET latin1 NOT NULL,
  `LanguageSystemText_ID` varchar(255) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`LanguageSystemText_ID`),
  KEY `TranslationId` (`TranslationId`),
  KEY `TranslationUnique` (`TranslationUnique`),
  KEY `Language` (`Language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

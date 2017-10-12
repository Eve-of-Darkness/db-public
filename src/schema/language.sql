/* TODO: Possible delete - LT 10/2017 */

CREATE TABLE `language` (
  `TranslationID` varchar(255) NOT NULL,
  `EN` text NOT NULL,
  `ES` text,
  `DE` text,
  `CZ` text,
  `FR` text,
  `IT` text,
  `CU` text,
  `PackageID` text,
  `Language_ID` varchar(255) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`Language_ID`),
  UNIQUE KEY `TranslationID` (`TranslationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

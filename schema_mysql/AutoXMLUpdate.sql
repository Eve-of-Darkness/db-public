CREATE TABLE IF NOT EXISTS `AutoXMLUpdate` (
  `AutoXMLUpdateID` int(11) NOT NULL AUTO_INCREMENT,
  `FilePackage` varchar(255) NOT NULL,
  `FileHash` varchar(255) NOT NULL,
  `LoadResult` varchar(255) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`AutoXMLUpdateID`),
  KEY `I_AutoXMLUpdate_FilePackage` (`FilePackage`),
  KEY `I_AutoXMLUpdate_FileHash` (`FileHash`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

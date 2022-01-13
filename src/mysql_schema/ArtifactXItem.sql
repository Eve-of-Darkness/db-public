DROP TABLE IF EXISTS `ArtifactXItem`;

CREATE TABLE `ArtifactXItem` (
  `ArtifactID` text NOT NULL,
  `ItemID` text NOT NULL,
  `Version` text NOT NULL,
  `Realm` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `ArtifactXItem_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`ArtifactXItem_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

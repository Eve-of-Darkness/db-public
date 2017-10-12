/*Table structure for table `artifactxitem` */

DROP TABLE IF EXISTS `artifactxitem`;

CREATE TABLE `artifactxitem` (
  `ArtifactID` text NOT NULL,
  `ItemID` text NOT NULL,
  `Version` text NOT NULL,
  `Realm` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `ArtifactXItem_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`ArtifactXItem_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

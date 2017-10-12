DROP TABLE IF EXISTS `ArtifactBonus`;

CREATE TABLE `ArtifactBonus` (
  `ArtifactID` text NOT NULL,
  `BonusID` int(11) NOT NULL,
  `Level` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `ArtifactBonus_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`ArtifactBonus_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

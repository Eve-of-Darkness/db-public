/*Table structure for table `classxspecialization` */

DROP TABLE IF EXISTS `classxspecialization`;

CREATE TABLE `classxspecialization` (
  `ClassXSpecializationID` int(11) NOT NULL AUTO_INCREMENT,
  `ClassID` int(11) DEFAULT NULL,
  `SpecKeyName` varchar(100) NOT NULL,
  `LevelAcquired` int(11) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ClassXSpecializationID`),
  KEY `I_ClassXSpecialization_ClassID` (`ClassID`),
  KEY `I_ClassXSpecialization_SpecKeyName` (`SpecKeyName`),
  KEY `I_ClassXSpecialization_LevelAcquired` (`LevelAcquired`)
) ENGINE=InnoDB AUTO_INCREMENT=538 DEFAULT CHARSET=latin1;

/*Table structure for table `dataquest` */

DROP TABLE IF EXISTS `dataquest`;

CREATE TABLE `dataquest` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `StartType` tinyint(3) unsigned NOT NULL,
  `StartName` varchar(100) NOT NULL,
  `StartRegionID` smallint(5) unsigned NOT NULL,
  `AcceptText` varchar(100) DEFAULT NULL,
  `Description` text,
  `SourceName` text,
  `SourceText` text,
  `StepType` text,
  `StepText` text,
  `StepItemTemplates` text,
  `AdvanceText` text,
  `TargetName` text,
  `TargetText` text,
  `CollectItemTemplate` text,
  `MaxCount` smallint(5) unsigned NOT NULL,
  `MinLevel` tinyint(3) unsigned NOT NULL,
  `MaxLevel` tinyint(3) unsigned NOT NULL,
  `RewardMoney` text,
  `RewardXP` text,
  `RewardCLXP` text,
  `RewardRP` text,
  `RewardBP` text,
  `OptionalRewardItemTemplates` text,
  `FinalRewardItemTemplates` text,
  `FinishText` text,
  `QuestDependency` text,
  `AllowedClasses` varchar(200) DEFAULT NULL,
  `ClassType` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

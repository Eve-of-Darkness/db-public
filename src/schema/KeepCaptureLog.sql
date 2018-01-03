CREATE TABLE `KeepCaptureLog` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `DateTaken` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `KeepName` text NOT NULL,
  `KeepType` text NOT NULL,
  `NumEnemies` int(11) NOT NULL,
  `CombatTime` int(11) NOT NULL,
  `RPReward` int(11) NOT NULL,
  `BPReward` int(11) NOT NULL,
  `XPReward` bigint(20) NOT NULL,
  `MoneyReward` bigint(20) NOT NULL,
  `CapturedBy` text NOT NULL,
  `RPGainerList` text NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

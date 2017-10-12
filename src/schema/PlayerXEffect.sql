/*Table structure for table `playerxeffect` */

DROP TABLE IF EXISTS `playerxeffect`;

CREATE TABLE `playerxeffect` (
  `IsHandler` tinyint(1) DEFAULT NULL,
  `Var6` int(11) DEFAULT NULL,
  `Var5` int(11) DEFAULT NULL,
  `Var4` int(11) DEFAULT NULL,
  `Var3` int(11) DEFAULT NULL,
  `Var2` int(11) DEFAULT NULL,
  `Var1` int(11) DEFAULT NULL,
  `Duration` int(11) DEFAULT NULL,
  `EffectType` text,
  `SpellLine` text,
  `ChardID` varchar(255) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `PlayerXEffect_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`PlayerXEffect_ID`),
  KEY `I_PlayerXEffect_ChardID` (`ChardID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

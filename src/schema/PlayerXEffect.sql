CREATE TABLE IF NOT EXISTS `PlayerXEffect` (
  `IsHandler` tinyint(1) NOT NULL DEFAULT '0',
  `Var6` int(11) NOT NULL DEFAULT '0',
  `Var5` int(11) NOT NULL DEFAULT '0',
  `Var4` int(11) NOT NULL DEFAULT '0',
  `Var3` int(11) NOT NULL DEFAULT '0',
  `Var2` int(11) NOT NULL DEFAULT '0',
  `Var1` int(11) NOT NULL DEFAULT '0',
  `Duration` int(11) NOT NULL DEFAULT '0',
  `EffectType` text,
  `SpellLine` text,
  `ChardID` varchar(255) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `PlayerXEffect_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`PlayerXEffect_ID`),
  KEY `I_PlayerXEffect_ChardID` (`ChardID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

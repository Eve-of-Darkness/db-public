DROP TABLE IF EXISTS `StyleXSpell`;

CREATE TABLE `StyleXSpell` (
  `SpellID` int(11) NOT NULL DEFAULT '0',
  `ClassID` int(11) NOT NULL DEFAULT '0',
  `StyleID` int(11) NOT NULL DEFAULT '0',
  `Chance` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `StyleXSpell_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`StyleXSpell_ID`),
  KEY `I_StyleXSpell_StyleID` (`StyleID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

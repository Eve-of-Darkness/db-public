CREATE TABLE `StyleXSpell` (
  `SpellID` int(11) NOT NULL,
  `ClassID` int(11) NOT NULL,
  `StyleID` int(11) NOT NULL,
  `Chance` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `StyleXSpell_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`StyleXSpell_ID`),
  KEY `I_StyleXSpell_StyleID` (`StyleID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

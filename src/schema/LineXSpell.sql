CREATE TABLE `LineXSpell` (
  `LineName` varchar(255) NOT NULL,
  `SpellID` int(11) NOT NULL,
  `Level` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `LineXSpell_ID` varchar(255) NOT NULL,
  `PackageID` text,
  PRIMARY KEY (`LineXSpell_ID`),
  KEY `I_LineXSpell_LineName` (`LineName`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

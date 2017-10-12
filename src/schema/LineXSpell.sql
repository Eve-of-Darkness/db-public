/*Table structure for table `linexspell` */

DROP TABLE IF EXISTS `linexspell`;

CREATE TABLE `linexspell` (
  `LineName` varchar(255) NOT NULL,
  `SpellID` int(11) NOT NULL,
  `Level` int(11) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `LineXSpell_ID` varchar(255) NOT NULL,
  `PackageID` text,
  PRIMARY KEY (`LineXSpell_ID`),
  KEY `I_LineXSpell_LineName` (`LineName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

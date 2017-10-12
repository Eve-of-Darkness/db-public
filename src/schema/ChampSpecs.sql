/* TODO: may need deleted LT: 10/2017 *//

DROP TABLE IF EXISTS `ChampSpecs`;

CREATE TABLE `ChampSpecs` (
  `Cost` int(11) NOT NULL,
  `IdLine` int(11) NOT NULL,
  `SkillIndex` int(11) NOT NULL,
  `Index` int(11) NOT NULL,
  `SpellID` int(11) NOT NULL,
  `ChampSpecs_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`ChampSpecs_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

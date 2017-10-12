/*Table structure for table `champspecs` */

DROP TABLE IF EXISTS `champspecs`;

CREATE TABLE `champspecs` (
  `Cost` int(11) NOT NULL,
  `IdLine` int(11) NOT NULL,
  `SkillIndex` int(11) NOT NULL,
  `Index` int(11) NOT NULL,
  `SpellID` int(11) NOT NULL,
  `ChampSpecs_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`ChampSpecs_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

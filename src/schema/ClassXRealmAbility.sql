/*Table structure for table `classxrealmability` */

DROP TABLE IF EXISTS `classxrealmability`;

CREATE TABLE `classxrealmability` (
  `CharClass` int(11) NOT NULL,
  `AbilityKey` text NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `ClassXRealmAbility_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`ClassXRealmAbility_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

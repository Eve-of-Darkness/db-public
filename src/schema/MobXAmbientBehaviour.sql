/*Table structure for table `mobxambientbehaviour` */

DROP TABLE IF EXISTS `mobxambientbehaviour`;

CREATE TABLE `mobxambientbehaviour` (
  `Source` varchar(255) NOT NULL,
  `Trigger` text NOT NULL,
  `Emote` smallint(5) unsigned DEFAULT NULL,
  `Text` text NOT NULL,
  `Chance` smallint(5) unsigned NOT NULL,
  `Voice` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `MobXAmbientBehaviour_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`MobXAmbientBehaviour_ID`),
  KEY `I_MobXAmbientBehaviour_Source` (`Source`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

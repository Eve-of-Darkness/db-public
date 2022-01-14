DROP TABLE IF EXISTS `ClassXRealmAbility`;

CREATE TABLE `ClassXRealmAbility` (
  `CharClass` int(11) NOT NULL DEFAULT '0',
  `AbilityKey` text NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `ClassXRealmAbility_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`ClassXRealmAbility_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

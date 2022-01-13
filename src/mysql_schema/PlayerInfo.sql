CREATE TABLE IF NOT EXISTS `PlayerInfo` (
  `Name` text,
  `LastName` text,
  `Guild` text,
  `Race` text,
  `Class` text,
  `Alive` text,
  `Realm` text,
  `Region` text,
  `Level` int(11) NOT NULL DEFAULT '0',
  `X` int(11) NOT NULL DEFAULT '0',
  `Y` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `PlayerInfo_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`PlayerInfo_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

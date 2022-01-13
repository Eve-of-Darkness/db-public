CREATE TABLE IF NOT EXISTS `GuildAlliance` (
  `AllianceName` text,
  `Motd` text,
  `LeaderGuildID` varchar(255) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `GuildAlliance_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`GuildAlliance_ID`),
  UNIQUE KEY `U_GuildAlliance_LeaderGuildID` (`LeaderGuildID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

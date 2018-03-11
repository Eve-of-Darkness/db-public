CREATE TABLE IF NOT EXISTS `serverstats` (
  `StatDate` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Clients` int(11) NOT NULL DEFAULT '0',
  `CPU` double NOT NULL,
  `Upload` int(11) NOT NULL DEFAULT '0',
  `Download` int(11) NOT NULL DEFAULT '0',
  `Memory` bigint(20) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `serverstats_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`serverstats_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

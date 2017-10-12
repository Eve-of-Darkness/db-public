/*Table structure for table `dbhousecharsxperms` */

DROP TABLE IF EXISTS `dbhousecharsxperms`;

CREATE TABLE `dbhousecharsxperms` (
  `HouseNumber` int(11) NOT NULL,
  `PermissionType` int(11) NOT NULL,
  `TargetName` text NOT NULL,
  `DisplayName` text NOT NULL,
  `PermissionLevel` int(11) NOT NULL,
  `CreationTime` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `DBHouseCharsXPerms_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`DBHouseCharsXPerms_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `AuditEntry` (
  `AuditTime` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `AccountID` text,
  `RemoteHost` text,
  `AuditType` int(11) NOT NULL DEFAULT '0',
  `AuditSubtype` int(11) NOT NULL DEFAULT '0',
  `OldValue` text,
  `NewValue` text NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `AuditEntry_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`AuditEntry_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

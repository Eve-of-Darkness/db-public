CREATE TABLE IF NOT EXISTS `BugReport` (
  `ID` int(11) NOT NULL DEFAULT '0',
  `Message` text NOT NULL,
  `Submitter` text NOT NULL,
  `DateSubmitted` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `ClosedBy` text NOT NULL,
  `DateClosed` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Category` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `BugReport_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `U_BugReport_BugReport_ID` (`BugReport_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

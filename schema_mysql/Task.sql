CREATE TABLE IF NOT EXISTS `Task` (
  `Character_ID` varchar(255) NOT NULL,
  `TimeOut` datetime DEFAULT NULL,
  `TaskType` text,
  `TasksDone` int(11) NOT NULL DEFAULT '0',
  `CustomPropertiesString` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Task_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Character_ID`),
  UNIQUE KEY `U_Task_Task_ID` (`Task_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

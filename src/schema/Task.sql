DROP TABLE IF EXISTS `Task`;

CREATE TABLE `Task` (
  `Character_ID` varchar(255) NOT NULL,
  `TimeOut` datetime DEFAULT NULL,
  `TaskType` text,
  `TasksDone` int(11) DEFAULT NULL,
  `CustomPropertiesString` text,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `Task_ID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Character_ID`),
  UNIQUE KEY `U_Task_Task_ID` (`Task_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

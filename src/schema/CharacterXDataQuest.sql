/*Table structure for table `characterxdataquest` */

DROP TABLE IF EXISTS `characterxdataquest`;

CREATE TABLE `characterxdataquest` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` varchar(100) NOT NULL,
  `DataQuestID` int(11) NOT NULL,
  `Step` smallint(6) NOT NULL,
  `Count` smallint(6) NOT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  PRIMARY KEY (`ID`),
  KEY `I_CharacterXDataQuest_Character_ID` (`DataQuestID`,`Character_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

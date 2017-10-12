DROP TABLE IF EXISTS `ServerInfo`;

CREATE TABLE `ServerInfo` (
  `Time` text,
  `ServerName` text,
  `AAC` text,
  `ServerType` text,
  `ServerStatus` text,
  `NumClients` int(11) DEFAULT NULL,
  `NumAccounts` int(11) DEFAULT NULL,
  `NumMobs` int(11) DEFAULT NULL,
  `NumInventoryItems` int(11) DEFAULT NULL,
  `NumPlayerChars` int(11) DEFAULT NULL,
  `NumMerchantItems` int(11) DEFAULT NULL,
  `NumItemTemplates` int(11) DEFAULT NULL,
  `NumWorldObjects` int(11) DEFAULT NULL,
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `ServerInfo_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`ServerInfo_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

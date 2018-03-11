CREATE TABLE IF NOT EXISTS `ServerInfo` (
  `Time` text,
  `ServerName` text,
  `AAC` text,
  `ServerType` text,
  `ServerStatus` text,
  `NumClients` int(11) NOT NULL DEFAULT '0',
  `NumAccounts` int(11) NOT NULL DEFAULT '0',
  `NumMobs` int(11) NOT NULL DEFAULT '0',
  `NumInventoryItems` int(11) NOT NULL DEFAULT '0',
  `NumPlayerChars` int(11) NOT NULL DEFAULT '0',
  `NumMerchantItems` int(11) NOT NULL DEFAULT '0',
  `NumItemTemplates` int(11) NOT NULL DEFAULT '0',
  `NumWorldObjects` int(11) NOT NULL DEFAULT '0',
  `LastTimeRowUpdated` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `ServerInfo_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`ServerInfo_ID`)
) ENGINE=InnoDB DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

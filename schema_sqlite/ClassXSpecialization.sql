DROP TABLE IF EXISTS `ClassXSpecialization`;

CREATE TABLE `ClassXSpecialization` (`ClassXSpecializationID` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
`ClassID` INT(11) NOT NULL DEFAULT 0, 
`SpecKeyName` VARCHAR(100) NOT NULL DEFAULT '' COLLATE NOCASE, 
`LevelAcquired` INT(11) NOT NULL DEFAULT 0, 
`LastTimeRowUpdated` DATETIME NOT NULL DEFAULT '2000-01-01 00:00:00');
CREATE INDEX `I_ClassXSpecialization_ClassID` ON `ClassXSpecialization` (`ClassID`);
CREATE INDEX `I_ClassXSpecialization_SpecKeyName` ON `ClassXSpecialization` (`SpecKeyName`);
CREATE INDEX `I_ClassXSpecialization_LevelAcquired` ON `ClassXSpecialization` (`LevelAcquired`);

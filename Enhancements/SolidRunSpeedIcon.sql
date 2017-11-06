# Changes run speed songs to give solid rather than flashing icons when active
UPDATE `spell` SET `Duration`=11, `Frequency`=1 WHERE `Type`='SpeedEnhancement' AND `Pulse`=1;
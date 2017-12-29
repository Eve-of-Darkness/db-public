# Changes run speed songs to give solid rather than flashing icons when active
UPDATE `Spell` SET `Duration`=15 WHERE `Type`='SpeedEnhancement' AND `Pulse`=1;
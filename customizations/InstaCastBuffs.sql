# Changes most buff spells to insta-cast
# Note that this will make it much easier in PVP
#	to rebuff after having buffs sheared.

UPDATE `Spell` SET `CastTime`=0 WHERE `Type` LIKE '%buff%' AND `Concentration`>0;
UPDATE `Spell` SET `CastTime`=0 WHERE `Type` LIKE '%buff%' AND `Type`!='HealthRegenBuff' AND `Duration`>=600;
UPDATE `Spell` SET `CastTime`=0 WHERE `Type`='petspell' AND `Duration`='1200'; -- Necro spec buffs

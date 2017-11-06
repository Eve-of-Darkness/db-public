# Changes most buff spells to insta-cast
# Note that this will make it much easier in PVP
#	to rebuff after having buffs sheared.

UPDATE `spell` SET `casttime`=0 WHERE `Type` LIKE '%buff%' AND `Concentration`>0;
UPDATE `spell` SET `casttime`=0 WHERE `Type` LIKE '%buff%' AND `Type`!='HealthRegenBuff' AND `duration`>=600;
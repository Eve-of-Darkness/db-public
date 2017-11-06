# Changes necromancer heal over time and damage shield spells to display an
#	icon at the top of the screen with character buffs.
#
# The icons will start flashing shortly before the spell on the pet expires,
#	to remind you to recast the spell.

UPDATE `spell` SET `Target`='self', `Value`=0, `Frequency`=0, `Description`='Pet regenerates health during the duration of the spell.  Icon at the top vanishes early to account for recast time.', `Type`='HealOverTime', `Duration`=22, `PackageID`='GUI_Enhancements' WHERE `SpellID` BETWEEN 9461 AND 9468;
UPDATE `spell` SET `Target`='pet', `Range`=2000, `PackageID`='GUI_Enhancements' WHERE `SpellID` BETWEEN 309461 AND 309468;
UPDATE `spell` SET `Target`='self', `Damage`=0, `Description`='Enemies who strike you pet take damage in retaliation.  Icon at the top vanishes early to account for recast time.', `Type`='DamageShield', `Duration`=36, `PackageID`='GUI_Enhancements' WHERE `SpellID` BETWEEN 9511 AND 9518;
UPDATE `spell` SET `Target`='pet', `Range`=2000, `PackageID`='GUI_Enhancements' WHERE `SpellID` BETWEEN 309511 AND 309518;
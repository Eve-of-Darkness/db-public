### Adds Dreaded Seal content, including the seals themselves, crafting recipes, and collectors.

# Add Dreaded Seal Collectors to mob
INSERT INTO `Mob` (`Name`,`ClassType`,`Guild`,`X`,`Y`,`Z`,`Speed`,`Strength`,`Constitution`,`Dexterity`,`Quickness`,`Intelligence`,`Piety`,`Empathy`,`Charisma`,`RespawnInterval`,`OwnerID`,`VisibleWeaponSlots`,`HouseNumber`,`Heading`,`Region`,`Model`,`Size`,`Level`,`EquipmentTemplateID`,`PackageID`,`Realm`,`Mob_ID`)
	VALUES ('Lady Nina','DOL.GS.DreadedSealCollector','Dreaded Seal Collector',33505,22668,8479,0,0,0,0,0,0,0,0,0,0,0,0,0,1035,10,283,49,30,'LadyNina','DreadedSeal',1,'Dreaded_Seal_Lady_Nina');
INSERT INTO `Mob` (`Name`,`ClassType`,`Guild`,`X`,`Y`,`Z`,`Speed`,`Strength`,`Constitution`,`Dexterity`,`Quickness`,`Intelligence`,`Piety`,`Empathy`,`Charisma`,`RespawnInterval`,`OwnerID`,`VisibleWeaponSlots`,`HouseNumber`,`Heading`,`Region`,`Model`,`Size`,`Level`,`EquipmentTemplateID`,`PackageID`,`Realm`,`Mob_ID`)
	VALUES ('Fiana','DOL.GS.DreadedSealCollector','Dreaded Seal Collector',31613,33839,8030,0,0,0,0,0,0,0,0,0,0,0,0,0,3231,101,162,48,30,'Fiana','DreadedSeal',2,'Dreaded_Seal_Fiana');
INSERT INTO `Mob` (`Name`,`ClassType`,`Guild`,`X`,`Y`,`Z`,`Speed`,`Strength`,`Constitution`,`Dexterity`,`Quickness`,`Intelligence`,`Piety`,`Empathy`,`Charisma`,`RespawnInterval`,`OwnerID`,`VisibleWeaponSlots`,`HouseNumber`,`Heading`,`Region`,`Model`,`Size`,`Level`,`EquipmentTemplateID`,`PackageID`,`Realm`,`Mob_ID`)
	VALUES ('Relena','DOL.GS.DreadedSealCollector','Dreaded Seal Collector',32263,33049,7998,0,0,0,0,0,0,0,0,0,0,0,0,0,2150,201,388,52,30,'Relena','DreadedSeal',3,'Dreaded_Seal_Relena');

# Add Dreaded Seal Collectors stuff to NPCEquipment
INSERT INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('LadyNina',25,98,40,'LadyNina1');
INSERT INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('LadyNina',26,96,43,'LadyNina2');
INSERT INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Fiana',22,137,9,'Fiana1');
INSERT INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Fiana',23,138,9,'Fiana2');
INSERT INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Fiana',25,134,9,'Fiana3');
INSERT INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Fiana',26,96,72,'Fiana4');
INSERT INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Fiana',27,152,73,'Fiana5');
INSERT INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Fiana',28,141,73,'Fiana6');
INSERT INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Relena',23,143,43,'Relena1');
INSERT INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Relena',25,58,43,'Relena2');
INSERT INTO `NPCEquipment` (`TemplateID`,`Slot`,`Model`,`Color`,`NPCEquipment_ID`)
	VALUES ('Relena',26,57,0,'Relena3');

# Add Dreaded Seals to ItemTemplate
INSERT INTO `ItemTemplate` (`Id_nb`,`Name`,`Level`,`Item_Type`,`Model`,`CanDropAsLoot`,`IsTradable`,`IsIndestructible`,`Object_Type`,`IsDropable`,`Quality`,`Weight`,`MaxCondition`,`MaxDurability`,`Condition`,`Durability`,`MaxCount`,`Description`,`Price`)
	VALUES ('glowing_dreaded_seal','Glowing Dreaded Seal',30,14,483,1,1,0,0,1,70,0,100,100,100,100,10,'To show appreciation for service fighting these enemies -\nthe lords of the land will award Realm points and Realm abilities to those who defeat them.\nThe people who accept these seals are in the 3 major cities:\nRelena in Tir Na Nog\nLady Nina in Camelot\nand Fiana in Jordheim.',3000);
INSERT INTO `ItemTemplate` (`Id_nb`,`Name`,`Level`,`Item_Type`,`Model`,`CanDropAsLoot`,`IsTradable`,`IsIndestructible`,`Object_Type`,`IsDropable`,`Quality`,`Weight`,`MaxCondition`,`MaxDurability`,`Condition`,`Durability`,`MaxCount`,`Description`,`Price`)
	VALUES ('sanguine_dreaded_seal','Sanguine Dreaded Seal',30,14,484,1,1,0,0,1,70,0,100,100,100,100,5,'To show appreciation for service fighting these enemies -\nthe lords of the land will award Realm points and Realm abilities to those who defeat them.\nThe people who accept these seals are in the 3 major cities:\nRelena in Tir Na Nog\nLady Nina in Camelot\nand Fiana in Jordheim.',3000);
INSERT INTO `ItemTemplate` (`Id_nb`,`Name`,`Level`,`Item_Type`,`Model`,`CanDropAsLoot`,`IsTradable`,`IsIndestructible`,`Object_Type`,`IsDropable`,`Quality`,`Weight`,`MaxCondition`,`MaxDurability`,`Condition`,`Durability`,`MaxCount`,`Description`,`Price`)
	VALUES ('lambent_dreaded_seal','Lambent Dreaded Seal',30,14,485,1,1,0,0,1,70,0,100,100,100,100,5,'To show appreciation for service fighting these enemies -\nthe lords of the land will award Realm points and Realm abilities to those who defeat them.\nThe people who accept these seals are in the 3 major cities:\nRelena in Tir Na Nog\nLady Nina in Camelot\nand Fiana in Jordheim.\n\nThis seal is worth 10 times the Glowing variety.',30000);
INSERT INTO `ItemTemplate` (`Id_nb`,`Name`,`Level`,`Item_Type`,`Model`,`CanDropAsLoot`,`IsTradable`,`IsIndestructible`,`Object_Type`,`IsDropable`,`Quality`,`Weight`,`MaxCondition`,`MaxDurability`,`Condition`,`Durability`,`MaxCount`,`Description`,`Price`)
	VALUES ('lambent_dreaded_seal2','Lambent Dreaded Seal',30,14,485,1,1,0,0,1,70,0,100,100,100,100,5,'To show appreciation for service fighting these enemies -\nthe lords of the land will award Realm points and Realm abilities to those who defeat them.\nThe people who accept these seals are in the 3 major cities:\nRelena in Tir Na Nog\nLady Nina in Camelot\nand Fiana in Jordheim.\n\nThis seal is worth 10 times the Glowing variety.',3000);
INSERT INTO `ItemTemplate` (`Id_nb`,`Name`,`Level`,`Item_Type`,`Model`,`CanDropAsLoot`,`IsTradable`,`IsIndestructible`,`Object_Type`,`IsDropable`,`Quality`,`Weight`,`MaxCondition`,`MaxDurability`,`Condition`,`Durability`,`MaxCount`,`Description`,`Price`)
	VALUES ('fulgent_dreaded_seal','Fulgent Dreaded Seal',30,14,486,1,1,0,0,1,70,0,100,100,100,100,1,'To show appreciation for service fighting these enemies -\nthe lords of the land will award Realm points and Realm abilities to those who defeat them.\nThe people who accept these seals are in the 3 major cities:\nRelena in Tir Na Nog\nLady Nina in Camelot\nand Fiana in Jordheim.\n\nThis seal is worth 50 times the Glowing variety.',3000);
INSERT INTO `ItemTemplate` (`Id_nb`,`Name`,`Level`,`Item_Type`,`Model`,`CanDropAsLoot`,`IsTradable`,`IsIndestructible`,`Object_Type`,`IsDropable`,`Quality`,`Weight`,`MaxCondition`,`MaxDurability`,`Condition`,`Durability`,`MaxCount`,`Description`,`Price`)
	VALUES ('effulgent_dreaded_seal','Effulgent Dreaded Seal',30,14,487,1,1,0,0,1,70,0,100,100,100,100,5,'To show appreciation for service fighting these enemies -\nthe lords of the land will award Realm points and Realm abilities to those who defeat them.\nThe people who accept these seals are in the 3 major cities:\nRelena in Tir Na Nog\nLady Nina in Camelot\nand Fiana in Jordheim.\n\nThis seal is worth 250 times the Glowing variety.',3000);

# Add crafting recipes to CraftedItem
INSERT INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('lambent_dreaded_seal',4894,1,15,1);
INSERT INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('lambent_dreaded_seal2',4895,1,15,1);
INSERT INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('fulgent_dreaded_seal',4896,1,15,1);
INSERT INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('effulgent_dreaded_seal',4897,1,15,1);
INSERT INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('lambent_dreaded_seal',11834,1,15,1);
INSERT INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('lambent_dreaded_seal2',11835,1,15,1);
INSERT INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('fulgent_dreaded_seal',11836,1,15,1);
INSERT INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('effulgent_dreaded_seal',11837,1,15,1);
INSERT INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('lambent_dreaded_seal',16564,1,15,1);
INSERT INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('lambent_dreaded_seal2',16565,1,15,1);
INSERT INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('fulgent_dreaded_seal',16566,1,15,1);
INSERT INTO `CraftedItem` (`Id_nb`,`CraftedItemID`,`CraftingLevel`,`CraftingSkillType`,`MakeTemplated`)
	VALUES ('effulgent_dreaded_seal',16567,1,15,1);

# Add crafting recipes to CraftedXItem
INSERT INTO `CraftedXItem` (`CraftedItemId_nb`,`IngredientId_nb`,`Count`,`CraftedXItem_ID`)
	VALUES ('lambent_dreaded_seal','glowing_dreaded_seal',10,'craft_lambent_dreaded_seal');
INSERT INTO `CraftedXItem` (`CraftedItemId_nb`,`IngredientId_nb`,`Count`,`CraftedXItem_ID`)
	VALUES ('lambent_dreaded_seal2','sanguine_dreaded_seal',10,'craft_sanguine_dreaded_seal');
INSERT INTO `CraftedXItem` (`CraftedItemId_nb`,`IngredientId_nb`,`Count`,`CraftedXItem_ID`)
	VALUES ('fulgent_dreaded_seal','lambent_dreaded_seal2',5,'craft_fulgent_dreaded_seal');	
INSERT INTO `CraftedXItem` (`CraftedItemId_nb`,`IngredientId_nb`,`Count`,`CraftedXItem_ID`)
	VALUES ('effulgent_dreaded_seal','fulgent_dreaded_seal',10,'craft_effulgent_dreaded_seal');	

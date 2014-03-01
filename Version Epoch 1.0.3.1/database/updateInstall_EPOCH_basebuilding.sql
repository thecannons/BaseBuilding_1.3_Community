--
-- Creates a temporary table
--
CREATE TABLE IF NOT EXISTS `object_data_old` (
  `ObjectID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ObjectUID` bigint(24) NOT NULL DEFAULT '0',
  `Instance` int(11) unsigned NOT NULL,
  `Classname` varchar(50) DEFAULT NULL,
  `Datestamp` datetime NOT NULL,
  `LastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CharacterID` int(11) unsigned NOT NULL DEFAULT '0',
  `Worldspace` varchar(128) NOT NULL DEFAULT '[]',
  `Inventory` longtext,
  `Hitpoints` varchar(512) NOT NULL DEFAULT '[]',
  `Fuel` double(13,5) NOT NULL DEFAULT '1.00000',
  `Damage` double(13,5) NOT NULL DEFAULT '0.00000',
  PRIMARY KEY (`ObjectID`),
  KEY `ObjectUID` (`ObjectUID`) USING BTREE,
  KEY `Instance` (`Instance`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Copies all Base Building 1.2 data to the new table from the existing one
--
INSERT INTO object_data_old
SELECT *
FROM object_data
WHERE Classname IN ('Misc_Cargo1Bo_military','Ins_WarfareBContructionSite','Land_pumpa','Hhedgehog_concrete','Misc_cargo_cont_small_EP1','Land_prebehlavka','Fence_corrugated_plate','ZavoraAnim','Land_tent_east','Land_CamoNetB_EAST','Land_CamoNetB_NATO','Land_CamoNetVar_EAST','Land_CamoNetVar_NATO','Land_CamoNet_EAST','Land_CamoNet_NATO','Fence_Ind_long','Fort_RazorWire','Fence_Ind','Land_fort_bagfence_long','Grave','WarfareBDepot','Base_WarfareBBarrier10xTall','Concrete_Wall_EP1','Infostand_2_EP1','Land_BagFenceRound','CamoNet','DeerStand','Land_CncBlock','WatchTower','SandBagNest','Wire2','HBarrier','Scaffolding','Sandbag2_DZ','Sandbag3_DZ','LadderSmall','Gate1_DZ','WarfareBCamp','Base_WarfareBBarrier10x','Land_fortified_nest_big','Land_Fort_Watchtower','Land_fort_rampart_EP1','Land_HBarrier_large','Land_fortified_nest_small','Land_Misc_Cargo2E');

--
-- Removes the Base Building 1.2 items from the original table
--
DELETE FROM object_data
WHERE Classname IN ('Misc_Cargo1Bo_military','Ins_WarfareBContructionSite','Land_pumpa','Hhedgehog_concrete','Misc_cargo_cont_small_EP1','Land_prebehlavka','Fence_corrugated_plate','ZavoraAnim','Land_tent_east','Land_CamoNetB_EAST','Land_CamoNetB_NATO','Land_CamoNetVar_EAST','Land_CamoNetVar_NATO','Land_CamoNet_EAST','Land_CamoNet_NATO','Fence_Ind_long','Fort_RazorWire','Fence_Ind','Land_fort_bagfence_long','Grave','WarfareBDepot','Base_WarfareBBarrier10xTall','Concrete_Wall_EP1','Infostand_2_EP1','Land_BagFenceRound','CamoNet','DeerStand','Land_CncBlock','WatchTower','SandBagNest','Wire2','HBarrier','Scaffolding','Sandbag2_DZ','Sandbag3_DZ','LadderSmall','Gate1_DZ','WarfareBCamp','Base_WarfareBBarrier10x','Land_fortified_nest_big','Land_Fort_Watchtower','Land_fort_rampart_EP1','Land_HBarrier_large','Land_fortified_nest_small','Land_Misc_Cargo2E');

--
-- Copies Base Building 1.2 items from the new table, to the original with the new array system
--
INSERT INTO `object_data`(`ObjectID`, `ObjectUID`, `Instance`, `Classname`, `Datestamp`, `LastUpdated`, `CharacterID`, `Worldspace`, `Inventory`, `Hitpoints`, `Fuel`, `Damage`)
SELECT o.ObjectID, o.ObjectUID, o.Instance, o.Classname, o.Datestamp, o.LastUpdated, o.CharacterID, CONCAT(SUBSTRING_INDEX(o.Worldspace,',',3), ',0]]'), CONCAT("[[""", o.ObjectUID, """],[""", c.PlayerUID, """]]" ), o.Hitpoints, o.Fuel, o.Damage
FROM object_data_old o
INNER JOIN character_data c ON o.CharacterID = c.CharacterID
WHERE Classname IN ('Misc_Cargo1Bo_military','Ins_WarfareBContructionSite','Land_pumpa','Hhedgehog_concrete','Misc_cargo_cont_small_EP1','Land_prebehlavka','Fence_corrugated_plate','ZavoraAnim','Land_tent_east','Land_CamoNetB_EAST','Land_CamoNetB_NATO','Land_CamoNetVar_EAST','Land_CamoNetVar_NATO','Land_CamoNet_EAST','Land_CamoNet_NATO','Fence_Ind_long','Fort_RazorWire','Fence_Ind','Land_fort_bagfence_long','Grave','WarfareBDepot','Base_WarfareBBarrier10xTall','Concrete_Wall_EP1','Infostand_2_EP1','Land_BagFenceRound','CamoNet','DeerStand','Land_CncBlock','WatchTower','SandBagNest','Wire2','HBarrier','Scaffolding','Sandbag2_DZ','Sandbag3_DZ','LadderSmall','Gate1_DZ','WarfareBCamp','Base_WarfareBBarrier10x','Land_fortified_nest_big','Land_Fort_Watchtower','Land_fort_rampart_EP1','Land_HBarrier_large','Land_fortified_nest_small','Land_Misc_Cargo2E');

--
-- Deletes the temporary table
--
DROP TABLE object_data_old;

--
-- Creates a temporary table
--
CREATE TABLE IF NOT EXISTS `object_data_old` (
  `ObjectID` int(11) NOT NULL AUTO_INCREMENT,
  `ObjectUID` bigint(20) NOT NULL DEFAULT '0',
  `Instance` int(11) NOT NULL,
  `Classname` varchar(50) DEFAULT NULL,
  `Datestamp` datetime NOT NULL,
  `CharacterID` int(11) NOT NULL DEFAULT '0',
  `Worldspace` varchar(70) NOT NULL DEFAULT '[]',
  `Inventory` longtext,
  `Hitpoints` varchar(500) NOT NULL DEFAULT '[]',
  `Fuel` double(13,5) NOT NULL DEFAULT '1.00000',
  `Damage` double(13,5) NOT NULL DEFAULT '0.00000',
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ObjectID`),
  KEY `ObjectUID` (`ObjectUID`),
  KEY `Instance` (`Damage`,`Instance`),
  KEY `CheckUID` (`ObjectUID`,`Instance`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Copies all data to the new table from the existing one
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
-- Copies Base Building items from the new table, to the original with the new array system
--
INSERT INTO `object_data`(`ObjectID`, `ObjectUID`, `Instance`, `Classname`, `Datestamp`, `CharacterID`, `Worldspace`, `Inventory`, `Hitpoints`, `Fuel`, `Damage`, `last_updated`)
SELECT o.ObjectID, o.ObjectUID, o.Instance, o.Classname, o.Datestamp, o.CharacterID, CONCAT(SUBSTRING_INDEX(o.Worldspace,',',3), ',0]]'), CONCAT("[[""", o.ObjectUID, """],[""", c.PlayerUID, """]]" ), o.Hitpoints, o.Fuel, o.Damage, o.last_updated
FROM object_data_old o
INNER JOIN character_data c ON o.CharacterID = c.CharacterID
WHERE Classname IN ('Misc_Cargo1Bo_military','Ins_WarfareBContructionSite','Land_pumpa','Hhedgehog_concrete','Misc_cargo_cont_small_EP1','Land_prebehlavka','Fence_corrugated_plate','ZavoraAnim','Land_tent_east','Land_CamoNetB_EAST','Land_CamoNetB_NATO','Land_CamoNetVar_EAST','Land_CamoNetVar_NATO','Land_CamoNet_EAST','Land_CamoNet_NATO','Fence_Ind_long','Fort_RazorWire','Fence_Ind','Land_fort_bagfence_long','Grave','WarfareBDepot','Base_WarfareBBarrier10xTall','Concrete_Wall_EP1','Infostand_2_EP1','Land_BagFenceRound','CamoNet','DeerStand','Land_CncBlock','WatchTower','SandBagNest','Wire2','HBarrier','Scaffolding','Sandbag2_DZ','Sandbag3_DZ','LadderSmall','Gate1_DZ','WarfareBCamp','Base_WarfareBBarrier10x','Land_fortified_nest_big','Land_Fort_Watchtower','Land_fort_rampart_EP1','Land_HBarrier_large','Land_fortified_nest_small','Land_Misc_Cargo2E');

--
-- Deletes the temporary table
--
DROP TABLE object_data_old;

--
-- Adds New BB Objects to Database
--
INSERT IGNORE INTO 'object_classes'('Classname', 'Type') VALUES
('Land_sara_hasic_zbroj','Land_sara_hasic_zbroj'),
('Land_Shed_wooden','Land_Shed_wooden'),
('Land_Barrack2','Land_Barrack2'),
('Land_vez','Land_vez'),
('FlagCarrierBAF','FlagCarrierBAF'),
('FlagCarrierBIS_EP1','FlagCarrierBIS_EP1'),
('FlagCarrierBLUFOR_EP1','FlagCarrierBLUFOR_EP1'),
('FlagCarrierCDF_EP1','FlagCarrierCDF_EP1'),
('FlagCarrierCDFEnsign_EP1','FlagCarrierCDFEnsign_EP1'),
('FlagCarrierCzechRepublic_EP1','FlagCarrierCzechRepublic_EP1'),
('FlagCarrierGermany_EP1','FlagCarrierGermany_EP1'),
('FlagCarrierINDFOR_EP1','FlagCarrierINDFOR_EP1'),
('FlagCarrierUSA_EP1','FlagCarrierUSA_EP1'),
('Land_Ind_Shed_01_main','Land_Ind_Shed_01_main'),
('Land_Fire_barrel','Land_Fire_barrel'),
('Land_WoodenRamp','Land_WoodenRamp'),
('Land_House_L_1_EP1','Land_House_L_1_EP1'),
('Land_ConcreteRamp','Land_ConcreteRamp'),
('RampConcrete','RampConcrete'),
('HeliH','HeliH'),
('HeliHCivil','HeliHCivil'),
('Land_ladder','Land_ladder'),
('Land_ladder_half','Land_ladder_half'),
('Land_Misc_Scaffolding','Land_Misc_Scaffolding'),
('Land_Ind_TankSmall2_EP1','Land_Ind_TankSmall2_EP1'),
('PowerGenerator_EP1','PowerGenerator_EP1'),
('Land_Ind_IlluminantTower','Land_Ind_IlluminantTower'),
('Land_A_Castle_Bergfrit','Land_A_Castle_Bergfrit'),
('Land_A_Castle_Stairs_A','Land_A_Castle_Stairs_A'),
('Land_A_Castle_Bastion','Land_A_Castle_Bastion'),
('Land_A_Castle_Wall1_20','Land_A_Castle_Wall1_20'),
('Land_A_Castle_Wall1_20_Turn','Land_A_Castle_Wall1_20_Turn'),
('Land_A_Castle_Wall2_30','Land_A_Castle_Wall2_30'),
('Land_A_Castle_Gate','Land_A_Castle_Gate'),
('CDF_WarfareBUAVterminal'),('CDF_WarfareBUAVterminal');

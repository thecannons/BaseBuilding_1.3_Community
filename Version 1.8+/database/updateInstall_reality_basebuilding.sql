--
-- Creates a temporary table
--
CREATE TABLE IF NOT EXISTS `instance_deployable_old` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `unique_id` varchar(60) NOT NULL,
  `deployable_id` smallint(5) unsigned NOT NULL,
  `owner_id` int(10) unsigned NOT NULL,
  `instance_id` bigint(20) unsigned NOT NULL DEFAULT '1',
  `worldspace` varchar(60) NOT NULL DEFAULT '[0,[0,0,0]]',
  `inventory` varchar(2048) NOT NULL DEFAULT '[]',
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Hitpoints` varchar(500) NOT NULL DEFAULT '[]',
  `Fuel` double(13,0) NOT NULL DEFAULT '0',
  `Damage` double(13,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx1_instance_deployable_old` (`deployable_id`),
  KEY `idx2_instance_deployable_old` (`owner_id`),
  KEY `idx3_instance_deployable_old` (`instance_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT AUTO_INCREMENT=1 ;

--
-- Copies all data to the new table from the existing one
--
INSERT INTO instance_deployable_old
SELECT *
FROM instance_deployable
WHERE deployable_id >= 6 and deployable_id <= 52;

--
-- Removes the Base Building 1.2 items from the original table
--
DELETE FROM instance_deployable
WHERE deployable_id >= 6 and deployable_id <= 52;

--
-- Copies Base Building items from the new table, to the original with the new array system
--
INSERT INTO `instance_deployable`(`id`, `unique_id`, `deployable_id`, `owner_id`, `instance_id`, `worldspace`, `inventory`, `last_updated`, `created`, `Hitpoints`, `Fuel`, `Damage`)
SELECT d.id, d.unique_id, d.deployable_id, d.owner_id, d.instance_id, CONCAT(SUBSTRING_INDEX(d.worldspace,',',3), ',0]]'), CONCAT("[[""", d.unique_id, """],[""", s.unique_id, """]]" ), d.last_updated, d.created, d.Hitpoints, d.Fuel, d.Damage
FROM instance_deployable_old d
INNER JOIN survivor s ON d.owner_id = s.id
WHERE deployable_id >= 6 and deployable_id <= 52;

--
-- Deletes the temporary table
--
DROP TABLE instance_deployable_old;

--
-- Adds New BB Objects to Database
--
INSERT IGNORE INTO `deployable` (`class_name`) VALUES
('Land_sara_hasic_zbroj'),
('Land_Shed_wooden'),
('Land_Barrack2'),
('Land_vez'),
('FlagCarrierBAF'),
('FlagCarrierBIS_EP1'),
('FlagCarrierBLUFOR_EP1'),
('FlagCarrierCDF_EP1'),
('FlagCarrierCDFEnsign_EP1'),
('FlagCarrierCzechRepublic_EP1'),
('FlagCarrierGermany_EP1'),
('FlagCarrierINDFOR_EP1'),
('FlagCarrierUSA_EP1'),
('Land_Ind_Shed_01_main'),
('Land_Fire_barrel'),
('Land_WoodenRamp'),
('Land_House_L_1_EP1'),
('Land_ConcreteRamp'),
('RampConcrete'),
('HeliH'),
('HeliHCivil'),
('Land_ladder'),
('Land_ladder_half'),
('Land_Misc_Scaffolding'),
('Land_Ind_TankSmall2_EP1'),
('PowerGenerator_EP1'),
('Land_Ind_IlluminantTower'),
('Land_A_Castle_Bergfrit'),
('Land_A_Castle_Stairs_A'),
('Land_A_Castle_Bastion'),
('Land_A_Castle_Wall1_20'),
('Land_A_Castle_Wall1_20_Turn'),
('Land_A_Castle_Wall2_30'),
('Land_A_Castle_Gate'),
('CDF_WarfareBUAVterminal');

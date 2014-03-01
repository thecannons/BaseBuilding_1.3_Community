
//####----####----####---- Base Building 1.3 Start ----####----####----####

/****************************************************** These Settings Can Be Edited ******************************************************/
/********************************** For more information on these settings, view 'Configuration ReadMe' ***********************************/
/***************************************************************** Admins *****************************************************************/
	BBSuperAdminAccess			= ["####","#####"]; //Replace with your high level admin playerUIDs for base building (High level admins have access to all functions of all BB items, even if they don't belong to them)
	BBLowerAdminAccess			= ["####","####"]; //Replace with your lower level admin playerUIDs for base building (Low level admins can only remove items that don't belong to them)

/************************************************************* Flag Settings **************************************************************/
	BBTypeOfFlag				= "FlagCarrierBIS_EP1"; //Type of flag Base Building 1.3 will use, you can select any of the flags from the BBAllFlagTypes array (default is FlagCarrierBIS_EP1)
	BBAllFlagTypes				= ["FlagCarrierBAF","FlagCarrierBIS_EP1","FlagCarrierBLUFOR_EP1","FlagCarrierCDF_EP1","FlagCarrierCDFEnsign_EP1","FlagCarrierCzechRepublic_EP1","FlagCarrierGermany_EP1","FlagCarrierINDFOR_EP1","FlagCarrierUSA_EP1"];//DO NOT REMOVE ITEMS FROM THIS ARRAY, you can ADD a flag type if you want a different flag, you will also need to add a picture for it to missionFolder\buildRecipeBook\images\buildable\! You will also need to add it to the safeObjects array below and to your database!
	BBMaxPlayerFlags			= 3; //This sets how many flags a player can be added to, default is 3
	BBFlagRadius				= 200; //This sets the build radius around a flag, default is 200

/********************************************************* Removal Chance Settings ********************************************************/
	BBtblProb					= 30; //Base chance level for loosing toolbox
	BBlowP						= 35; //Base lower chance level for failing to remove item
	BBmedP						= 70; //Base medium chance level for failing to remove item
	BBhighP						= 95; //Base high chance level for failing to remove item
	
/**************************************************** Zombie Shield Generator Settings ****************************************************/
	BBEnableZShield				= 1; //Enable toggleable zombie shield generator/ 1 = Enabled // 0 = Disabled (If disabled, players can still build shield generators, they just wont do anything)
	BBTypeOfZShield				= "CDF_WarfareBUAVterminal"; //Type of object used for Zombie Shield, included this only in case some maps have this object banned
	BBAllZShieldTypes			= ["CDF_WarfareBUAVterminal"]; //DO NOT REMOVE ITEMS FROM THIS ARRAY, you can ADD an object class if you want a different building to be used as a Zombie Shield Generator!
	BBMaxZShields				= 1; //Maximum number of zombie shield generators a player can be added to, default is 1
	BBZShieldRadius				= 50; //Radius for Base Build zombie shield generator, default is 50
	BBZShieldClean				= 0; //Delete Zombies when they enter active shield radius/ 1 = Enabled // 0 = Disabled (If disabled, zombies will be killed but not deleted, could lead to zombie loot farming)
	BBZShieldDis				= 1; //Limits the distance shield generators can be built from flags to (BBFlagRadius - BBZShieldRadius)/ 1 = Enabled // 0 = Disabled (If you reduce the flag radius, you may need to disable this)

/********************************************************* Miscellaneous Settings *********************************************************/
	BBAIGuards					= 0; //Sarge AI Base Guards/ 1 = Enabled // 0 = Disabled (Requires Sarge AI)
	BBUseTowerLights			= 1; //Enable toggleable tower lighting/ 1 = Enabled // 0 = Disabled (If you run AxeMan's tower lighting on your server, read the instructions on how to modify it)
	BBTowerLightsNGen			= true; //Require generator for base building tower lighting?
	BBCustomDebug				= "debugMonitor"; //Change debugMonitor to whatever variable your custom debug uses, this allows Base Building to hide the debug monitor where needed
	//BBCustomDebugS				= [] spawn fnc_debug; //Change to whatever your debug monitor uses to activate, this allows Base Building to restore the debug monitor if it closed it
	
	//If you add items to the build list, you also need to add them to the SafeObjects array. Remember you will also need to add them to your database for them to be saved.
	SafeObjects = ["Land_Fire_DZ", "TentStorage", "Wire_cat1", "Sandbag1_DZ", "Hedgehog_DZ", "StashSmall", "StashMedium", "BearTrap_DZ", "DomeTentStorage", "CamoNet_DZ", "Trap_Cans", "TrapTripwireFlare", "TrapBearTrapSmoke", "TrapTripwireGrenade", "TrapTripwireSmoke", "TrapBearTrapFlare", "Grave", "Concrete_Wall_EP1", "Infostand_2_EP1", "WarfareBDepot", "Base_WarfareBBarrier10xTall", "WarfareBCamp", "Base_WarfareBBarrier10x", "Land_fortified_nest_big", "Land_Fort_Watchtower", "Land_fort_rampart_EP1", "Land_HBarrier_large", "Land_fortified_nest_small", "Land_BagFenceRound", "Land_fort_bagfence_long", "Land_Misc_Cargo2E", "Misc_Cargo1Bo_military", "Ins_WarfareBContructionSite", "Land_pumpa", "Land_CncBlock", "Hhedgehog_concrete", "Misc_cargo_cont_small_EP1", "Land_prebehlavka", "Fence_corrugated_plate", "ZavoraAnim", "Land_tent_east", "Land_CamoNetB_EAST", "Land_CamoNetB_NATO", "Land_CamoNetVar_EAST", "Land_CamoNetVar_NATO", "Land_CamoNet_EAST", "Land_CamoNet_NATO", "Fence_Ind_long", "Fort_RazorWire", "Fence_Ind","Land_sara_hasic_zbroj","Land_Shed_wooden","Land_Barrack2","Land_vez","FlagCarrierBAF","FlagCarrierBIS_EP1","FlagCarrierBLUFOR_EP1","FlagCarrierCDF_EP1","FlagCarrierCDFEnsign_EP1","FlagCarrierCzechRepublic_EP1","FlagCarrierGermany_EP1","FlagCarrierINDFOR_EP1","FlagCarrierUSA_EP1","Land_Ind_Shed_01_main","Land_Fire_barrel","Land_WoodenRamp","Land_Ind_TankSmall2_EP1","PowerGenerator_EP1","Land_Ind_IlluminantTower","Land_A_Castle_Stairs_A","Land_A_Castle_Bergfrit","Land_A_Castle_Bastion","Land_A_Castle_Wall1_20","Land_A_Castle_Wall1_20_Turn","Land_A_Castle_Wall2_30","Land_A_Castle_Gate","Land_House_L_1_EP1","Land_ConcreteRamp","RampConcrete","HeliH","HeliHCivil","Land_ladder","Land_ladder_half","Land_Misc_Scaffolding","CDF_WarfareBUAVterminal","Land_Ind_Shed_01_end","Land_Ind_SawMillPen"];
/******************************************************** END OF EDITABLE SETTINGS ********************************************************/

//Daimyo Custom Variables
	//Strings
	globalSkin 			= "";
	//Arrays
	allbuildables_class = [];
	allbuildables 		= [];
	allbuild_notowns 	= [];
	allremovables 		= [];
	wallarray 			= [];
	structures			= [];
	CODEINPUT 			= [];
	keyCode 			= [];
	globalAuthorizedUID = [];
	//Booleans
	remProc 			= false;
	procBuild 			= false;
	hasBuildItem 		= false;
	keyValid 			= false;
	removeObject		= false;
	addUIDCode			= false;
	removeUIDCode		= false;
	buildReposition		= false;
	//Other
	currentBuildRecipe 	= 0;
	bbCDReload			= 0; //This is used to reload custom debug monitors where needed

//EXTENDED BASE BUILDING
        baseBuildingExtended=true;
        rotateDir = 0;
        objectHeight=0;
        objectDistance=0;
        objectParallelDistance=0;
        rotateIncrement=30;
		rotateIncrementSmall=10;
        objectIncrement=0.3;
		objectIncrementSmall=0.1;
        objectTopHeight=8;
        objectLowHeight=-10;
        maxObjectDistance=6;
        minObjectDistance=-1;
		
//Base Building Keybinds
	DZ_BB_E  = false; //Elevate
	DZ_BB_L  = false; //Lower
	DZ_BB_Es = false; //Elevate Small
	DZ_BB_Ls = false; //Lower Small
	DZ_BB_Rl = false; //Rotate Left
	DZ_BB_Rr = false; //Rotate Right
	DZ_BB_Rls= false; //Rotate Left Small
	DZ_BB_Rrs= false; //Rotate Right Small
	DZ_BB_A  = false; //Push Away
	DZ_BB_N  = false; //Pull Near
	DZ_BB_Le = false; //Move Left
	DZ_BB_Ri = false; //Move Right
//####----####----####---- Base Building 1.3 End ----####----####----####

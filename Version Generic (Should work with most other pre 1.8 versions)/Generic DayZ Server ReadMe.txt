All of these edits are to be made in the dayz_server.pbo

****STEP 1 (Modifying compile\server_publishObject.sqf)****
**A**
Find

_charID =		_this select 0;
_object = 		_this select 1;
_worldspace = 	_this select 2;
_class = 		_this select 3;

After that, add

_inventory = 	[];
_fuel = [];
if (count _this > 4) then {
	_fuel = 		_this select 4;
	if (count _fuel > 0) then {
	_inventory = _fuel;
	} else {
		_inventory = [];
	};
};

**B**
Now Find

if (!(_object isKindOf "Building")) exitWith {
	deleteVehicle _object;
};

Change that to

//if (!(_object isKindOf "Building")) exitWith {
//	deleteVehicle _object;
//};

**C**
Then Find

//Send request
_key = format["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:",dayZ_instance, _class, 0 , _charID, _worldspace, [], [], 0,_uid];
//diag_log ("HIVE: WRITE: "+ str(_key));
_key call server_hiveWrite;

Change that to

if (typeOf(_object) in allbuildables_class) then {
	_key = format["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:",dayZ_instance, _class, 0 , _charID, _worldspace, [[_uid],_inventory], [], 0,_uid];
} else {
	_key = format["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:",dayZ_instance, _class, 0 , _charID, _worldspace, [], [], 0,_uid];
};
//diag_log ("HIVE: WRITE: "+ str(_key));
_key call server_hiveWrite;

if (typeOf(_object) in allbuildables_class) then { //Forces the variable to be updated so server doesn't need to be restarted to allow interaction
	_updatedAuthorizedUID = ([[_uid],_inventory]);
	_object setVariable ["AuthorizedUID", _updatedAuthorizedUID, true]; //sets variable with full useable array
};
	
Save and Close	

****STEP 2 (Modifying compile\server_updateNearbyObjects.sqf)****
**A**
Find

private["_pos"];

Change that to

private["_pos","_object","_isBuildable"];

**B**
Now Find

_pos = _this select 0;

Add after that

blarg

**C**
Then, at the bottom of the file, add this

//####----####----####---- Base Building 1.3 Start ----####----####----####
if (_isBuildable) then {
[_object, "gear"] call server_updateObject;
_isBuildable = false;
};
//####----####----####---- Base Building 1.3 End ----####----####----####

Save and Close

****STEP 3 (Modifying compile\server_updateObject.sqf)****
Find

_object_inventory = {
Load of code inside
};

Change that to

//####----####----####---- Base Building 1.3 Start ----####----####----####
_object_inventory = {
	private["_inventory","_previous","_key"];
	if (typeOf(_object) in allbuildables_class) then
	{
		_inventory = _object getVariable ["AuthorizedUID", []]; //Shouldn't need to specify which array since it's all being updated here
		_authorizedOUID = (_inventory select 0) select 0;
		_key = format["CHILD:309:%1:%2:",_authorizedOUID,_inventory]; //was _uid,_inventory
		diag_log ("HIVE: WRITE: "+ str(_key));
		_key call server_hiveWrite;
	} else {
		_inventory = [
			getWeaponCargo _object,
			getMagazineCargo _object,
			getBackpackCargo _object
		];
		_previous = str(_object getVariable["lastInventory",[]]);
		if (str(_inventory) != _previous) then {
			_object setVariable["lastInventory",_inventory];
			if (_objectID == "0") then {
				_key = format["CHILD:309:%1:%2:",_uid,_inventory];
			} else {
				_key = format["CHILD:303:%1:%2:",_objectID,_inventory];
			};
			diag_log ("HIVE: WRITE: "+ str(_key));
			_key call server_hiveWrite;
		};
	};
};
//####----####----####---- Base Building 1.3 End ----####----####----####

Save and Close

****STEP 4 (Modifying init\server_functions.sqf)****
**A**
Find

	if ((typeOf _object) in _allowedObjects) then {
	
Change that to

	if ((typeOf _object) in _allowedObjects || (typeOf _object) in allbuildables_class) then {

**B**
Now, at the bottom of the file, add this

//####----####----####---- Base Building 1.3 Start ----####----####----####
build_baseBuilding_arrays = {

//####----####----####---- BUILD LIST ARRAY SERVER SIDE Start ----####----####----####
/*
Build list by Daimyo for SERVER side
Add and remove recipes, Objects(classnames), requirments to build, and town restrictions + extras
This method is used because we are referencing magazines from player inventory as buildables.
Main array (_buildlist) consist of 34 arrays within. These arrays contains parameters for player_build.sqf
From left to right, each array contains 3 elements, 1st: Recipe Array, 2nd: "Classname", 3rd: Requirements array. 
Check comments below for more info on parameters
*/
private["_isDestructable","_classname","_isSimulated","_disableSims","_objectSims","_objectSim","_requirements","_isStructure","_structure","_wallType","_removable","_buildlist","_build_townsrestrict"];
// Count is 34
// Info on Parameters (Copy and Paste to add more recipes and their requirments!):
//[TankTrap, SandBags, Wires, Logs, Scrap Metal, Grenades, scrapelectronics, crate, camonets, bricks, string, duct tape], "Classname", [_attachCoords, _startPos, _modDir, _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown, _removable, _isStructure, _isSimulated, _isDestructable, _requireFlag];
									//[_attachCoords, _startPos, _modDir, _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown, _removable, _isStructure, _isSimulated, _isDestructable, _requireFlag];
_buildlist = [
//t, s, w, L, m, g
[[3, 0, 1, 0, 2, 0], BBTypeOfFlag,  			[[0,6,1], 	[0,8,0], 	0, 	true, true, true, true, false, false, false, false, true, false, false, false]], //FlagCarrierUSA 	--1 
[[0, 1, 0, 0, 1, 1], "Grave", 						[[0,2.5,.1],[0,2,0], 	0, 	true, true, true, false, true, true, true, false, false, false, false, false]],//Booby Traps --2
[[2, 0, 0, 3, 1, 0], "Concrete_Wall_EP1", 			[[0,5,1.75],[0,2,0], 	0, 	true, false, true, false, true, true, false, false, false, false, false, true]],//Gate Concrete Wall --3
[[1, 0, 1, 0, 1, 0], "Infostand_2_EP1",				[[0,2.5,.6],[0,2,0], 	0, 	true, false, true, false, true, false, false, false, false, false, false, true]],//Gate Panel w/ KeyPad --4
[[3, 3, 2, 2, 0, 0], "WarfareBDepot",					[[0,18,2], 	[0,15,0], 	90, true, true, false, true, false, false, false, true, true, false, false, true]],//WarfareBDepot --5
[[4, 1, 2, 2, 0, 0], "Base_WarfareBBarrier10xTall", 	[[0,10,1], 	[0,10,0], 	0, 	true, true, false, true, false, false, false, true, false, false, false, true]],//Base_WarfareBBarrier10xTall --6 
[[2, 1, 2, 1, 0, 0], "WarfareBCamp",					[[0,12,1], 	[0,10,0], 	180, 	true, true, false, true, false, false, false, true, true, false, false, true]],//WarfareBCamp --7
[[2, 1, 1, 1, 0, 0], "Base_WarfareBBarrier10x", 		[[0,10,.6], [0,10,0], 	0, 	true, true, false, true, false, false, false, true, false, false, false, true]],//Base_WarfareBBarrier10x --8
[[2, 2, 0, 2, 0, 0], "Land_fortified_nest_big", 		[[0,12,1], 	[2,8,0], 	180,true, true, false, true, false, false, false, true, true, false, false, true]],//Land_fortified_nest_big --9
[[2, 1, 2, 2, 0, 0], "Land_Fort_Watchtower",			[[0,10,2.2],[0,8,0], 	90, true, true, false, true, false, false, false, true, true, false, false, true]],//Land_Fort_Watchtower --10
[[1, 3, 0, 2, 0, 0], "Land_fort_rampart_EP1", 		[[0,7,.2], 	[0,8,0], 	180, 	true, true, false, true, true, false, false, true, false, false, false, true]],//Land_fort_rampart_EP1 --11
[[2, 1, 1, 0, 0, 0], "Land_HBarrier_large", 			[[0,7,1], 	[0,4,0], 	0, 	true, true, true, false, true, false, false, true, false, false, false, true]],//Land_HBarrier_large --12
[[2, 1, 0, 1, 0, 0], "Land_fortified_nest_small",		[[0,7,1], 	[0,3,0], 	90, true, true, true, false, true, false, false, true, true, false, false, true]],//Land_fortified_nest_small --13
[[0, 1, 1, 0, 0, 0], "Land_BagFenceRound",			[[0,4,.5], 	[0,2,0], 	180,true, true, false, false, true, false, false, true, false, false, false, true]],//Land_BagFenceRound --14
[[0, 1, 0, 0, 0, 0], "Land_fort_bagfence_long", 		[[0,4,.3], 	[0,2,0], 	0, 	true, true, false, false, true, false, false, true, false, false, false, true]],//Land_fort_bagfence_long --15
[[6, 0, 0, 0, 2, 0], "Land_Misc_Cargo2E",				[[0,7,2.6], [0,5,0], 	90, true, false, false, true, true, false, false, true, false, false, false, true]],//Land_Misc_Cargo2E --16
[[5, 0, 0, 0, 1, 0], "Misc_Cargo1Bo_military",		[[0,7,1.3], [0,5,0], 	90, true, false, false, true, true, false, false, true, false, false, false, true]],//Misc_Cargo1Bo_military --17
[[3, 0, 0, 0, 1, 0], "Ins_WarfareBContructionSite",	[[0,7,1.3], [0,5,0], 	90, true, false, false, true, true, false, false, true, false, false, false, true]],//Ins_WarfareBContructionSite --18
[[1, 1, 0, 2, 1, 0], "Land_pumpa",					[[0,3,.4], 	[0,3,0], 	0, 	true, true, true, false, true, false, false, true, false, false, false, true]],//Land_pumpa --19
[[1, 0, 1, 0, 0, 0], "Land_CncBlock",					[[0,3,.4], 	[0,2,0], 	0, 	true, false, false, false, true, true, true, true, false, false, false, true]],//Land_CncBlock --20
[[2, 0, 0, 0, 1, 0], "Hhedgehog_concrete",			[[0,5,.6], 	[0,4,0], 	0, 	true, true, false, true, false, true, false, true, false, false, false, true]],//Hhedgehog_concrete --21
[[1, 0, 0, 0, 2, 0], "Misc_cargo_cont_small_EP1",		[[0,5,1.3], [0,4,0], 	90, true, false, false, false, true, false, false, true, false, false, false, true]],//Misc_cargo_cont_small_EP1 --22
[[1, 0, 0, 2, 0, 0], "Land_prebehlavka",				[[0,6,.7], 	[0,3,0], 	90, true, false, false, false, true, false, false, true, false, true, true, true]],//Land_prebehlavka(Ramp) --23
[[2, 0, 0, 0, 0, 0], "Fence_corrugated_plate",		[[0,4,.6], 	[0,3,0], 	0,	true, true, true, false, true, false, false, false, false, false, false, true]],//Fence_corrugated_plate --24
[[2, 0, 1, 0, 0, 0], "ZavoraAnim", 					[[0,5,4.0], [0,5,0], 	180, 	true, false, false, false, false, true, false, true, false, true, true, true]],//ZavoraAnim --25
[[0, 0, 3, 1, 1, 0], "Land_tent_east", 				[[0,8,1.7], [0,6,0], 	0, 	true, false, false, true, false, false, false, true, true, true, true, true]],//Land_tent_east --26
[[0, 0, 6, 0, 1, 0], "Land_CamoNetB_EAST",			[[0,10,2], 	[0,10,0], 	0, 	true, false, false, true, false, false, false, true, true, true, true, true]],//Land_CamoNetB_EAST --27
[[0, 0, 5, 0, 1, 0], "Land_CamoNetB_NATO", 			[[0,10,2], 	[0,10,0], 	0, 	true, false, false, true, false, false, false, true, true, true, true, true]],//Land_CamoNetB_NATO --28
[[0, 0, 4, 0, 1, 0], "Land_CamoNetVar_EAST",			[[0,10,1.2],[0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true, true]],//Land_CamoNetVar_EAST --29
[[0, 0, 3, 0, 1, 0], "Land_CamoNetVar_NATO", 			[[0,10,1.2],[0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true, true]],//Land_CamoNetVar_NATO --30
[[0, 0, 2, 0, 1, 0], "Land_CamoNet_EAST",				[[0,8,1.2], [0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true, true]],//Land_CamoNet_EAST --31
[[0, 0, 1, 0, 1, 0], "Land_CamoNet_NATO",				[[0,8,1.2], [0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true, true]],//Land_CamoNet_NATO --32
[[0, 0, 2, 2, 0, 0], "Fence_Ind_long",				[[0,5,.6], 	[-4,1.5,0], 0, 	true, false, true, false, true, false, false, true, false, true, true, true]], //Fence_Ind_long --33
[[0, 0, 1, 0, 0, 0], "Fort_RazorWire",				[[0,5,.8], 	[0,4,0], 	0, 	true, false, false, false, true, false, false, true, false, true, true, true]],//Fort_RazorWire --34
[[0, 0, 2, 0, 0, 0], "Fence_Ind",  					[[0,4,.7], 	[0,2,0], 	0, 	true, false, false, false, true, false, true, true, false, true, true, true]], //Fence_Ind --35
[[2, 1, 0, 0, 0, 0], "Land_sara_hasic_zbroj",  		[[0,10,2.4], [0,10,2.4], 	0, 	true, true, true, true, false, false, false, true, true, false, false, true]], //Land_sara_hasic_zbroj --36
[[1, 2, 1, 2, 0, 0], "Land_Shed_wooden",  			[[0,8,1], 	[0,10,0], 	0, 	true, true, true, true, true, false, false, true, true, false, false, true]], //Land_Shed_wooden --37
[[1, 1, 1, 2, 0, 0], "Land_Barrack2",  				[[0,10,1], 	[0,12,0], 	0, 	true, true, true, true, false, false, false, true, true, false, false, true]], //Land_Barrack2 --38
[[2, 0, 0, 0, 2, 0], "Land_vez",  					[[0,6,1], 	[0,8,0], 	0, 	true, true, true, true, true, false, false, true, true, false, false, true]], //Land_vez --39
[[3, 0, 0, 0, 2, 0], "Land_Ind_Shed_01_main",  		[[0,10,1], 	[0,10,0], 	0, 	true, false, false, true, true, false, false, false, false, false, false, true]], //Land_Ind_Shed_01_main --40
[[2, 1, 0, 0, 2, 0], "Land_Ind_Shed_01_end",  		[[0,10,1], 	[0,10,0], 	0, 	true, false, false, false, true, false, false, true, false, false, false, true]], //Land_Ind_Shed_01_main --40
[[4, 0, 0, 0, 2, 0], "Land_Ind_SawMillPen",  			[[0,10,1], 	[0,10,0], 	0, 	true, false, false, true, true, false, false, true, false, false, false, true]], //Land_Ind_Shed_01_main --40
[[1, 0, 0, 0, 1, 0], "Land_Fire_barrel",  			[[0,3,0.6], [0,4,0], 	0, 	true, false, false, false, true, false, false, true, false, true, true, true]], //Land_Fire_barrel --41 
[[0, 1, 0, 2, 0, 0], "Land_WoodenRamp",  				[[0,5,0.4], [0,4,0], 	0, 	true, false, false, false, true, false, false, true, false, false, false, true]], //Land_WoodenRamp --42 
[[2, 0, 2, 0, 2, 0], "Land_Ind_TankSmall2_EP1",  		[[0,6,1.3], [0,5,1.3], 	90, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_Ind_TankSmall2_EP1 --43 
[[2, 0, 2, 2, 0, 0], "PowerGenerator_EP1",  			[[0,5,0.9], [0,5,0.9], 	90, true, true, true, true, false, false, false, true, true, false, false, true]], //PowerGenerator_EP1 --44 
[[1, 2, 0, 0, 3, 0], "Land_Ind_IlluminantTower",  	[[0,10,9.6], [0,10,9.6], 0, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_Ind_IlluminantTower --45 
[[0, 0, 0, 4, 0, 0], "Land_A_Castle_Stairs_A",  		[[-5,10,3.5], [-5,10,3.5],90, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_A_Castle_Stairs_A --46 
[[3, 2, 0, 0, 2, 0], "Land_A_Castle_Bergfrit",		[[0,20,15], [0,20,15], -90, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[3, 3, 0, 0, 0, 0], "Land_A_Castle_Bastion",			[[0,16,10], [0,16,10], 180, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[2, 2, 0, 0, 2, 0], "Land_A_Castle_Wall1_20",		[[0,16,10], [0,16,10], 180, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[2, 2, 0, 0, 1, 0], "Land_A_Castle_Wall1_20_Turn",	[[0,16,10], [0,16,10], 180, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[3, 2, 0, 0, 1, 0], "Land_A_Castle_Wall2_30",		[[0,16,10], [0,16,10], 180, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[2, 0, 0, 2, 2, 0], "Land_A_Castle_Gate",  			[[0,17,6], [0,17,6], 	0, 	true, true, true, true, false, false, false, true, true, false, false, true]], //Land_A_Castle_Gate --47 
[[1, 1, 1, 1, 0, 0], "Land_House_L_1_EP1",  			[[0,20,2], [0,20,2], 	0, 	true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_L_1_EP1 --48 
[[5, 1, 0, 0, 2, 0], "Land_ConcreteRamp",  			[[0,12,0.5],[0,12,0], 	0, 	true, true, true, true, false, true, false, true, false, false, false, true]], //Land_ConcreteRamp --49 
[[3, 1, 0, 0, 1, 0], "RampConcrete",  				[[0,10,0.5],[0,10,0], 	0, 	true, true, true, false, false, true, false, true, false, false, false, true]], //RampConcrete --50
[[1, 1, 1, 0, 0, 0], "HeliH",  						[[0,8,0.5], [0,8,0], 	0, 	false, false, false, false, true, false, false, true, false, true, false, true]], //HeliH --51 
[[1, 2, 1, 0, 0, 0], "HeliHCivil",  					[[0,8,0.5], [0,8,0], 	0, 	false, false, false, false, true, false, false, true, false, true, false, true]], //HeliHCivil --52 
[[2, 0, 0, 0, 3, 0], "Land_ladder",  					[[0,5,0.8], [0,5,0], 	0, 	true, false, true, false, true, false, false, true, false, false, false, true]], //Land_ladder --54 
[[1, 0, 0, 0, 3, 0], "Land_ladder_half",  			[[0,5,1], 	[0,5,0], 	0, 	true, false, true, false, true, false, false, true, false, false, false, true]], //Land_ladder_half --55 
[[0, 0, 0, 3, 0, 0], "Land_Misc_Scaffolding",  		[[0,12,0.5],[0,12,0], 	0, 	true, true, true, false, true, false, false, true, false, false, false, true]], //Land_Misc_Scaffolding --56
[[1, 0, 0, 0, 0, 0], "Hedgehog_DZ",  					[[0,2,0.4],[0,2,0.4], 	0, 	true, true, true, false, true, false, false, true, false, false, false, true]], //Land_Misc_Scaffolding --57 *** Remember that the last element in array does not get comma ***
[[2, 0, 2, 1, 2, 0], BBTypeOfZShield,  				[[0,4.5,2],[0,4.5,2], 	0, 	true, true, true, false, true, false, false, true, false, false, false, true]] //Land_Misc_Scaffolding --57 *** Remember that the last element in array does not get comma ***
];
//t, s, w, L, m, g, e, cr, c, b, s, d														// _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown, _removable, _isStructure, _isSimulated, _isDestructable, _requireFlag];

//Extendable object have the option to elevate/lower when positioning. They DO NOT follow ground contours and will always remain perfectly vertical.
allExtendables = ["Concrete_Wall_EP1","Infostand_2_EP1","Land_HBarrier_large","Land_fortified_nest_small","Land_BagFenceRound","Land_fort_bagfence_long",
					"Land_Misc_Cargo2E","Misc_Cargo1Bo_military","Ins_WarfareBContructionSite","Land_CncBlock","Misc_cargo_cont_small_EP1","Land_prebehlavka",
					"Fence_corrugated_plate","Land_CamoNet_EAST","Land_CamoNet_NATO","Fence_Ind_long","Fort_RazorWire","Fence_Ind","Land_Shed_wooden","Land_vez",
					"Land_Ind_Shed_01_main","Land_Ind_Shed_01_end","Land_Ind_SawMillPen","Land_Fire_barrel","Land_WoodenRamp","Land_ConcreteRamp","RampConcrete",
					"Land_ladder","Land_ladder_half","Land_Misc_Scaffolding","Land_Ind_TankSmall2_EP1","PowerGenerator_EP1","Land_Ind_IlluminantTower",
					"Land_A_Castle_Bergfrit","Land_A_Castle_Stairs_A","Land_A_Castle_Gate","Land_A_Castle_Bastion","Land_A_Castle_Wall1_20","Land_A_Castle_Wall1_20_Turn",
					"Land_A_Castle_Wall2_30","Land_sara_hasic_zbroj",BBTypeOfZShield];

// Build allremovables array for remove action
for "_i" from 0 to ((count _buildlist) - 1) do
{
	_removable = (_buildlist select _i) select _i - _i + 1;
	if (_removable != "Grave") then { // Booby traps have disarm bomb
	allremovables set [count allremovables, _removable];
	};
};
// Build classnames array for use later
for "_i" from 0 to ((count _buildlist) - 1) do
{
	_classname = (_buildlist select _i) select _i - _i + 1;
	allbuildables_class set [count allbuildables_class, _classname];
};


/*
*** Remember that the last element in ANY array does not get comma ***
Notice lines 47 and 62
*/

	antiBuildables = ["Hhedgehog_concrete"];
// Towns to restrict from building in. (Type exact name as shown on map, NOT Case-Sensitive but spaces important)
// ["Classname", range restriction];
// NOT REQUIRED SERVER SIDE, JUST ADDED IN IF YOU NEED TO USE IT
_build_townsrestrict = [
/*["Lyepestok", 1000],
["Sabina", 900],
["Branibor", 600],
["Bilfrad na moru", 400],
["Mitrovice", 350],
["Seven", 300],
["Blato", 300]*/
];
// Here we are filling the global arrays with this local list
allbuildables = _buildlist;
allbuild_notowns = _build_townsrestrict;

/*
This Area is for extra arrays that need to be built, some using above arrays
*/
};
//####----####----####---- BUILD LIST ARRAY SERVER SIDE End ----####----####----####
//####----####----####---- Base Building 1.3 End ----####----####----####

Save and Close

****STEP 5 (Modifying system\server_monitor.sqf)****
**A**
Find

waitUntil{initialized}; //means all the functions are now defined

After that, add

//####----####----####---- Base Building 1.3 Start ----####----####----####
call build_baseBuilding_arrays; // build BB 1.2 arrays
//####----####----####---- Base Building 1.3 End ----####----####----####

**B**
Now find

				_object setdir _dir;
				_object setDamage _damage;
				
ABOVE that, add

				//####----####----####---- Base Building 1.3 Start ----####----####----####
				//Check to make sure all current flags match the set flag type, if not then change them
				if ((typeOf(_object) in BBAllFlagTypes) && (typeOf(_object) != BBTypeOfFlag)) then {
				deleteVehicle _object;
				_object = createVehicle [BBTypeOfFlag, _pos, [], 0, "CAN_COLLIDE"];
				_object setVariable ["CharacterID", _ownerID, true];
				};
				
				//Check to make sure all current shield generators match the set shield generator type, if not then change them
				if ((typeOf(_object) in BBAllZShieldTypes) && (typeOf(_object) != BBTypeOfZShield)) then {
				deleteVehicle _object;
				_object = createVehicle [BBTypeOfZShield, _pos, [], 0, "CAN_COLLIDE"];
				_object setVariable ["CharacterID", _ownerID, true];
				};
				
				// Give objects all custom UID
				if (typeOf(_object) in allbuildables_class) then {
				_object setVariable ["AuthorizedUID", _intentory, true]; //Sets the AuthorizedUID for build objects
				_object setVariable ["ObjectUID", ((_intentory select 0) select 0), true]; //Sets Object UID using array value
				};

				//Handle Traps (Graves)
				if (typeOf(_object) == "Grave") then {
					_object setVariable ["isBomb", 1, true];//this will be known as a bomb instead of checking with classnames in player_bomb
					_object setpos [(getposATL _object select 0),(getposATL _object select 1), -0.12];
					_object addEventHandler ["HandleDamage", {false}];
				};
				
				//Restore extendable objects to whatever their position is supposed to be
				if (typeOf(_object) in allExtendables && typeOf(_object) != "Grave") then {
					_object setposATL [(getposATL _object select 0),(getposATL _object select 1), (getposATL _object select 2)];
				};
				
				//Restore non extendable objects and make sure they follow the land contours
				if (!(typeOf(_object) in allExtendables) && (_object isKindOf "Static") && !(_object isKindOf "TentStorage") && typeOf(_object) != "Grave") then {
					_object setpos [(getposATL _object select 0),(getposATL _object select 1), 0];
				};
				//Set Variable
				_codePanels = ["Infostand_2_EP1", "Fence_corrugated_plate", BBTypeOfFlag];
				if (typeOf(_object) in _codePanels && (typeOf(_object) != "Infostand_1_EP1")) then {
					_object addEventHandler ["HandleDamage", {false}];
				};
				
				/*******************************************This Section Handles Objects Which Move Excessively During the Build Process***********************************************/
				/*******************************If added build objects move excessively, you can add a condition for them here and adjust as needed!***********************************/
				if (typeOf(_object) == "Land_sara_hasic_zbroj") then {
					_object setPosATL [((getPosATL _object select 0)+5.5),((getPosATL _object select 1)-1),(getPosATL _object select 2)];
				};
				if (typeOf(_object) == "Fence_Ind_long") then {
					_object setPosATL [((getPosATL _object select 0)-3.5),((getPosATL _object select 1)-0),(getPosATL _object select 2)];
				};
				if (typeOf(_object) == "Fort_RazorWire" || typeOf(_object) == "Land_Shed_wooden") then {
					_object setPosATL [((getPosATL _object select 0)-1.5),((getPosATL _object select 1)-0.5),(getPosATL _object select 2)];
				};
				if (typeOf(_object) == "Land_vez") then {
					_object setPosATL [((getPosATL _object select 0)-3.5),((getPosATL _object select 1)+1.5),(getPosATL _object select 2)];
				};
				if (typeOf(_object) == "Land_Misc_Scaffolding") then {
					_object setPosATL [((getPosATL _object select 0)-0.5),((getPosATL _object select 1)+3),(getPosATL _object select 2)];
				};
				/**************************************************************End of Excessive Movement Section***********************************************************************/

				// Set whether or not buildable is destructable
				if (typeOf(_object) in allbuildables_class) then {
					diag_log ("SERVER: in allbuildables_class:" + typeOf(_object) + "!");
					for "_i" from 0 to ((count allbuildables) - 1) do
					{
						_classname = (allbuildables select _i) select _i - _i + 1;
						_result = [_classname,typeOf(_object)] call BIS_fnc_areEqual;
						if (_result) exitWith {
							_requirements = (allbuildables select _i) select _i - _i + 2;
							_isDestructable = _requirements select 13;
							diag_log ("SERVER: " + typeOf(_object) + " _isDestructable = " + str(_isDestructable));
							if (!_isDestructable) then {
								diag_log("Spawned: " + typeOf(_object) + " Handle Damage False");
								_object addEventHandler ["HandleDamage", {false}];
							};
						};
					};
				};
				//####----####----####---- Base Building 1.3 End ----####----####----####

**c**
Now, Find

				if (count _intentory > 0) then {
				
Change that to

				if ((count _intentory > 0) && !(typeOf(_object) in allbuildables_class) && !(typeOf(_object) in BBAllFlagTypes) && !(typeOf(_object) in BBAllZShieldTypes)) then {
				
Save and Close

****Now reference the BE Filter Changes.txt****
#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"
waituntil {!isnil "bis_fnc_init"};

BIS_MPF_remoteExecutionServer = {
	if ((_this select 1) select 2 == "JIPrequest") then {
		[nil,(_this select 1) select 0,"loc",rJIPEXEC,[any,any,"per","execVM","ca\Modules\Functions\init.sqf"]] call RE;
	};
};

BIS_Effects_Burn =			{};
server_playerLogin =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerLogin.sqf";
server_playerSetup =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerSetup.sqf";
server_onPlayerDisconnect = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_onPlayerDisconnect.sqf";
server_updateObject =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_updateObject.sqf";
server_playerDied =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerDied.sqf";
server_publishObj = 		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishObject.sqf";	//Creates the object in DB
server_deleteObj =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_deleteObj.sqf"; 	//Removes the object from the DB
server_playerSync =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerSync.sqf";
zombie_findOwner =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\zombie_findOwner.sqf";
server_updateNearbyObjects =	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_updateNearbyObjects.sqf";
server_spawnCrashSite  =    compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_spawnCrashSite.sqf";
server_sendToClient =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_sendToClient.sqf";
server_Wildgenerate =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\zombie_Wildgenerate.sqf";
server_plantSpawner =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_plantSpawner.sqf";

spawnComposition = compile preprocessFileLineNumbers "ca\modules\dyno\data\scripts\objectMapper.sqf"; //"\z\addons\dayz_code\compile\object_mapper.sqf";
fn_bases = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\fn_bases.sqf";

vehicle_handleServerKilled = {
	private["_unit","_killer"];
	_unit = _this select 0;
	_killer = _this select 1;
		
	[_unit, "killed"] call server_updateObject;
	
	_unit removeAllMPEventHandlers "MPKilled";
	_unit removeAllEventHandlers "Killed";
	_unit removeAllEventHandlers "HandleDamage";
	_unit removeAllEventHandlers "GetIn";
	_unit removeAllEventHandlers "GetOut";
};

check_publishobject = {
	private ["_allowed","_allowedObjects","_object","_playername"];

	_object = _this select 0;
	_playername = _this select 1;
	_allowedObjects = ["TentStorage", "Hedgehog_DZ", "Sandbag1_DZ", "BearTrap_DZ", "Wire_cat1", "StashSmall", "StashMedium", "DomeTentStorage", "CamoNet_DZ", "Trap_Cans", "TrapTripwireFlare", "TrapBearTrapSmoke", "TrapTripwireGrenade", "TrapTripwireSmoke", "TrapBearTrapFlare"];
	_allowed = false;

#ifdef OBJECT_DEBUG
	diag_log format ["DEBUG: Checking if Object: %1 is allowed published by %2", _object, _playername];
#endif

	if ((typeOf _object) in _allowedObjects || (typeOf _object) in allbuildables_class) then {
#ifdef OBJECT_DEBUG
		diag_log format ["DEBUG: Object: %1 published by %2 is Safe",_object, _playername];
#endif
		_allowed = true;
	};

	_allowed;
};

//event Handlers
eh_localCleanup = {
	
private ["_object","_type","_unit"];
_object = _this select 0;
	_object addEventHandler ["local", {
		if(_this select 1) then {
			_unit = _this select 0;
			_type = typeOf _unit;
			 _myGroupUnit = group _unit;
 			_unit removeAllMPEventHandlers "mpkilled";
 			_unit removeAllMPEventHandlers "mphit";
 			_unit removeAllMPEventHandlers "mprespawn";
 			_unit removeAllEventHandlers "FiredNear";
			_unit removeAllEventHandlers "HandleDamage";
			_unit removeAllEventHandlers "Killed";
			_unit removeAllEventHandlers "Fired";
			_unit removeAllEventHandlers "GetOut";
			_unit removeAllEventHandlers "GetIn";
			_unit removeAllEventHandlers "Local";
			clearVehicleInit _unit;
			deleteVehicle _unit;
			deleteGroup _myGroupUnit;
			_unit = nil;
			diag_log ("CLEANUP: DELETED A " + str(_type) );
		};
	}];
};

server_hiveWrite = {
	private["_data"];
	//diag_log ("ATTEMPT WRITE: " + _this);
	_data = "HiveExt" callExtension _this;
	//diag_log ("WRITE: " +str(_data));
};

server_hiveReadWrite = {
	private["_key","_resultArray","_data"];
	_key = _this;
	//diag_log ("ATTEMPT READ/WRITE: " + _key);
	_data = "HiveExt" callExtension _key;
	//diag_log ("READ/WRITE: " +str(_data));
	_resultArray = call compile format ["%1",_data];
	_resultArray;
};

onPlayerDisconnected 		"[_uid,_name] call server_onPlayerDisconnect;";

server_getDiff =	{
	private["_variable","_object","_vNew","_vOld","_result"];
	_variable = _this select 0;
	_object = 	_this select 1;
	_vNew = 	_object getVariable[_variable,0];
	_vOld = 	_object getVariable[(_variable + "_CHK"),_vNew];
	_result = 	0;
	if (_vNew < _vOld) then {
		//JIP issues
		_vNew = _vNew + _vOld;
		_object getVariable[(_variable + "_CHK"),_vNew];
	} else {
		_result = _vNew - _vOld;
		_object setVariable[(_variable + "_CHK"),_vNew];
	};
	_result;
};

server_getDiff2 =	{
	private["_variable","_object","_vNew","_vOld","_result"];
	_variable = _this select 0;
	_object = 	_this select 1;
	_vNew = 	_object getVariable[_variable,0];
	_vOld = 	_object getVariable[(_variable + "_CHK"),_vNew];
	_result = _vNew - _vOld;
	_object setVariable[(_variable + "_CHK"),_vNew];
	_result;
};

dayz_objectUID2 = {
	private["_position","_dir","_key"];
	_dir = _this select 0;
	_key = "";
	_position = _this select 1;
	{
		_x = _x * 10;
		if ( _x < 0 ) then { _x = _x * -10 };
		_key = _key + str(round(_x));
	} forEach _position;
	_key = _key + str(round(_dir));
	_key;
};

dayz_recordLogin = {
	private["_key"];
	_key = format["CHILD:103:%1:%2:%3:",_this select 0,_this select 1,_this select 2];
	_key call server_hiveWrite;
};
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
//																	[_attachCoords, _startPos, _modDir, _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown, _removable, _isStructure, _isSimulated, _isDestructable, _requireFlag];
_buildlist = [
//t, s, w, L, m, g, e, cr, c, b, s, d
[[2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 1, 1], BBTypeOfFlag,  			[[0,6,1], 	[0,8,0], 	0, 	true, true, true, true, false, false, false, false, true, false, false, false]], //FlagCarrierUSA 	--1 
[[0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0], "Grave", 						[[0,2.5,.1],[0,2,0], 	0, 	true, true, true, false, true, true, true, false, false, false, false, false]],//Booby Traps --2
[[2, 0, 0, 3, 1, 0, 0, 0, 0, 0, 0, 0], "Concrete_Wall_EP1", 			[[0,5,1.75],[0,2,0], 	0, 	true, false, true, false, true, true, false, true, false, false, false, true]],//Gate Concrete Wall --3
[[0, 0, 1, 0, 1, 0, 2, 0, 0, 0, 0, 1], "Infostand_2_EP1",				[[0,2.5,.6],[0,2,0], 	0, 	true, false, true, false, true, false, false, false, false, false, false, true]],//Gate Panel w/ KeyPad --4
[[3, 3, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0], "WarfareBDepot",					[[0,18,2], 	[0,15,0], 	90, true, true, false, true, false, false, false, true, true, false, false, true]],//WarfareBDepot --5
[[4, 1, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0], "Base_WarfareBBarrier10xTall", 	[[0,10,1], 	[0,10,0], 	0, 	true, true, false, true, false, false, false, true, false, false, false, true]],//Base_WarfareBBarrier10xTall --6 
[[2, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0], "WarfareBCamp",					[[0,12,1], 	[0,10,0], 	180, 	true, true, false, true, false, false, false, true, true, false, false, true]],//WarfareBCamp --7
[[2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0], "Base_WarfareBBarrier10x", 		[[0,10,.6], [0,10,0], 	0, 	true, true, false, true, false, false, false, true, false, false, false, true]],//Base_WarfareBBarrier10x --8
[[2, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0], "Land_fortified_nest_big", 		[[0,12,1], 	[2,8,0], 	180,true, true, false, true, false, false, false, true, true, false, false, true]],//Land_fortified_nest_big --9
[[2, 1, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0], "Land_Fort_Watchtower",			[[0,10,2.2],[0,8,0], 	90, true, true, false, true, false, false, false, true, true, false, false, true]],//Land_Fort_Watchtower --10
[[1, 3, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0], "Land_fort_rampart_EP1", 		[[0,7,.2], 	[0,8,0], 	180, 	true, true, false, true, true, false, false, true, false, false, false, true]],//Land_fort_rampart_EP1 --11
[[2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0], "Land_HBarrier_large", 			[[0,7,1], 	[0,4,0], 	0, 	true, true, true, false, true, false, false, true, false, false, false, true]],//Land_HBarrier_large --12
[[2, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0], "Land_fortified_nest_small",		[[0,7,1], 	[0,3,0], 	90, true, true, true, false, true, false, false, true, true, false, false, true]],//Land_fortified_nest_small --13
[[0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0], "Land_BagFenceRound",			[[0,4,.5], 	[0,2,0], 	180,true, true, false, false, true, false, false, true, false, false, false, true]],//Land_BagFenceRound --14
[[0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], "Land_fort_bagfence_long", 		[[0,4,.3], 	[0,2,0], 	0, 	true, true, false, false, true, false, false, true, false, false, false, true]],//Land_fort_bagfence_long --15
[[6, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0], "Land_Misc_Cargo2E",				[[0,7,2.6], [0,5,0], 	90, true, false, false, true, true, false, false, true, false, false, false, true]],//Land_Misc_Cargo2E --16
[[5, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0], "Misc_Cargo1Bo_military",		[[0,7,1.3], [0,5,0], 	90, true, false, false, true, true, false, false, true, false, false, false, true]],//Misc_Cargo1Bo_military --17
[[3, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0], "Ins_WarfareBContructionSite",	[[0,7,1.3], [0,5,0], 	90, true, false, false, true, true, false, false, true, false, false, false, true]],//Ins_WarfareBContructionSite --18
[[1, 1, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0], "Land_pumpa",					[[0,3,.4], 	[0,3,0], 	0, 	true, true, true, false, true, false, false, true, false, false, false, true]],//Land_pumpa --19
[[1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0], "Land_CncBlock",					[[0,3,.4], 	[0,2,0], 	0, 	true, false, false, false, true, true, true, true, false, false, false, true]],//Land_CncBlock --20
[[2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0], "Hhedgehog_concrete",			[[0,5,.6], 	[0,4,0], 	0, 	true, true, false, true, false, true, false, true, false, false, false, true]],//Hhedgehog_concrete --21
[[1, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0], "Misc_cargo_cont_small_EP1",		[[0,5,1.3], [0,4,0], 	90, true, false, false, false, true, false, false, true, false, false, false, true]],//Misc_cargo_cont_small_EP1 --22
[[1, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0], "Land_prebehlavka",				[[0,6,.7], 	[0,3,0], 	90, true, false, false, false, true, false, false, true, false, true, true, true]],//Land_prebehlavka(Ramp) --23
[[2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], "Fence_corrugated_plate",		[[0,4,.6], 	[0,3,0], 	0,	true, true, true, false, true, false, false, true, false, false, false, true]],//Fence_corrugated_plate --24
[[2, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0], "ZavoraAnim", 					[[0,5,4.0], [0,5,0], 	180, 	true, false, false, false, false, true, false, true, false, true, true, true]],//ZavoraAnim --25
[[0, 0, 3, 1, 1, 0, 0, 0, 0, 0, 0, 0], "Land_tent_east", 				[[0,8,1.7], [0,6,0], 	0, 	true, false, false, true, false, false, false, true, true, true, true, true]],//Land_tent_east --26
[[0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 2, 0], "Land_CamoNetB_EAST",			[[0,10,2], 	[0,10,0], 	0, 	true, false, false, true, false, false, false, true, true, true, true, true]],//Land_CamoNetB_EAST --27
[[0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 1, 0], "Land_CamoNetB_NATO", 			[[0,10,2], 	[0,10,0], 	0, 	true, false, false, true, false, false, false, true, true, true, true, true]],//Land_CamoNetB_NATO --28
[[0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0], "Land_CamoNetVar_EAST",			[[0,10,1.2],[0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true, true]],//Land_CamoNetVar_EAST --29
[[0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0], "Land_CamoNetVar_NATO", 			[[0,10,1.2],[0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true, true]],//Land_CamoNetVar_NATO --30
[[0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 1], "Land_CamoNet_EAST",				[[0,8,1.2], [0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true, true]],//Land_CamoNet_EAST --31
[[0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2], "Land_CamoNet_NATO",				[[0,8,1.2], [0,7,0], 	0, 	true, false, true, false, false, false, false, true, false, true, true, true]],//Land_CamoNet_NATO --32
[[0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0], "Fence_Ind_long",				[[0,5,.6], 	[-4,1.5,0], 0, 	true, false, true, false, true, false, false, true, false, true, true, true]], //Fence_Ind_long --33
[[0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0], "Fort_RazorWire",				[[0,5,.8], 	[0,4,0], 	0, 	true, false, false, false, true, false, false, true, false, true, true, true]],//Fort_RazorWire --34
[[0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0], "Fence_Ind",  					[[0,4,.7], 	[0,2,0], 	0, 	true, false, false, false, true, false, true, true, false, true, true, true]], //Fence_Ind --35
[[2, 1, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0], "Land_sara_hasic_zbroj",  		[[0,10,2.4], [0,10,2.4], 	0, 	true, true, true, true, false, false, false, true, true, false, false, true]], //Land_sara_hasic_zbroj --36
[[2, 1, 1, 0, 0, 0, 0, 2, 0, 0, 0, 1], "Land_Shed_wooden",  			[[0,8,1], 	[0,10,0], 	0, 	true, true, true, true, true, false, false, true, true, false, false, true]], //Land_Shed_wooden --37
[[1, 1, 1, 0, 0, 0, 0, 0, 1, 3, 1, 0], "Land_Barrack2",  				[[0,10,1], 	[0,12,0], 	0, 	true, true, true, true, false, false, false, true, true, false, false, true]], //Land_Barrack2 --38
[[2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1], "Land_vez",  					[[0,6,1], 	[0,8,0], 	0, 	true, true, true, true, true, false, false, true, true, false, false, true]], //Land_vez --39
[[3, 0, 0, 0, 2, 0, 0, 2, 0, 0, 0, 0], "Land_Ind_Shed_01_main",  		[[0,10,1], 	[0,10,0], 	0, 	true, false, false, true, true, false, false, true, false, false, false, true]], //Land_Ind_Shed_01_main --40
[[2, 0, 0, 0, 1, 0, 0, 2, 0, 0, 0, 0], "Land_Ind_Shed_01_end",  		[[0,10,1], 	[0,10,0], 	0, 	true, false, false, false, true, false, false, true, false, false, false, true]], //Land_Ind_Shed_01_main --40
[[4, 0, 0, 0, 2, 0, 0, 2, 0, 0, 0, 0], "Land_Ind_SawMillPen",  			[[0,10,1], 	[0,10,0], 	0, 	true, false, false, true, true, false, false, true, false, false, false, true]], //Land_Ind_Shed_01_main --40
[[1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0], "Land_Fire_barrel",  			[[0,3,0.6], [0,4,0], 	0, 	true, false, false, false, true, false, false, true, false, true, true, true]], //Land_Fire_barrel --41 
[[0, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0], "Land_WoodenRamp",  				[[0,5,0.4], [0,4,0], 	0, 	true, false, false, false, true, false, false, true, false, false, false, true]], //Land_WoodenRamp --42 
[[2, 0, 2, 0, 2, 0, 2, 0, 0, 0, 0, 0], "Land_Ind_TankSmall2_EP1",  		[[0,6,1.3], [0,5,1.3], 	90, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_Ind_TankSmall2_EP1 --43 
[[2, 0, 2, 2, 0, 0, 2, 0, 0, 0, 0, 0], "PowerGenerator_EP1",  			[[0,5,0.9], [0,5,0.9], 	90, true, true, true, true, false, false, false, true, true, false, false, true]], //PowerGenerator_EP1 --44 
[[1, 0, 0, 0, 3, 0, 2, 0, 0, 0, 0, 0], "Land_Ind_IlluminantTower",  	[[0,10,9.6], [0,10,9.6], 0, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_Ind_IlluminantTower --45 
[[0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 2, 2], "Land_A_Castle_Stairs_A",  		[[-5,10,3.5], [-5,10,3.5],90, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_A_Castle_Stairs_A --46 
[[3, 2, 0, 0, 0, 0, 0, 2, 0, 5, 0, 0], "Land_A_Castle_Bergfrit",		[[0,20,15], [0,20,15], -90, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[3, 3, 0, 0, 0, 0, 0, 2, 0, 4, 0, 0], "Land_A_Castle_Bastion",			[[0,16,10], [0,16,10], 180, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[2, 2, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0], "Land_A_Castle_Wall1_20",		[[0,16,10], [0,16,10], 180, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[2, 2, 0, 0, 0, 0, 0, 2, 0, 4, 0, 0], "Land_A_Castle_Wall1_20_Turn",	[[0,16,10], [0,16,10], 180, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[3, 2, 0, 0, 0, 0, 0, 2, 0, 4, 0, 0], "Land_A_Castle_Wall2_30",		[[0,16,10], [0,16,10], 180, true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_C_9_EP1         --48 
[[2, 0, 0, 2, 0, 0, 0, 0, 0, 6, 0, 0], "Land_A_Castle_Gate",  			[[0,17,6], [0,17,6], 	0, 	true, true, true, true, false, false, false, true, true, false, false, true]], //Land_A_Castle_Gate --47 
[[1, 1, 1, 1, 0, 0, 0, 1, 0, 4, 1, 1], "Land_House_L_1_EP1",  			[[0,20,2], [0,20,2], 	0, 	true, true, true, true, false, false, false, true, true, false, false, true]], //Land_House_L_1_EP1 --48 
[[5, 1, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0], "Land_ConcreteRamp",  			[[0,12,0.5],[0,12,0], 	0, 	true, true, true, true, false, true, false, true, false, false, false, true]], //Land_ConcreteRamp --49 
[[3, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0], "RampConcrete",  				[[0,10,0.5],[0,10,0], 	0, 	true, true, true, false, false, true, false, true, false, false, false, true]], //RampConcrete --50
[[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3], "HeliH",  						[[0,8,0.5], [0,8,0], 	0, 	false, false, false, false, true, false, false, true, false, true, false, true]], //HeliH --51 
[[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3], "HeliHCivil",  					[[0,8,0.5], [0,8,0], 	0, 	false, false, false, false, true, false, false, true, false, true, false, true]], //HeliHCivil --52 
[[1, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 2], "Land_ladder",  					[[0,5,0.8], [0,5,0], 	0, 	true, false, true, false, true, false, false, true, false, false, false, true]], //Land_ladder --54 
[[2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1], "Land_ladder_half",  			[[0,5,1], 	[0,5,0], 	0, 	true, false, true, false, true, false, false, true, false, false, false, true]], //Land_ladder_half --55 
[[0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 1, 3], "Land_Misc_Scaffolding",  		[[0,12,0.5],[0,12,0], 	0, 	true, true, true, false, true, false, false, true, false, false, false, true]], //Land_Misc_Scaffolding --56
[[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], "Hedgehog_DZ",  					[[0,2,0.4],[0,2,0.4], 	0, 	true, true, false, false, true, false, false, true, false, false, false, true]], //Land_Misc_Scaffolding --57 *** Remember that the last element in array does not get comma ***
[[2, 0, 2, 1, 2, 0, 0, 0, 0, 0, 0, 0], BBTypeOfZShield,  				[[0,4.5,2],[0,4.5,2], 	0, 	true, true, true, true, true, false, false, true, false, false, false, true]] //Land_Misc_Scaffolding --57 *** Remember that the last element in array does not get comma ***
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
["Chernogorsk", 700],
["Elektrozavodsk", 700],
["Solnichniy", 700],
["Berezino", 700],
["Krasnostav", 300],
["Stary Sobor", 700],
["Balota", 300],
["Orlovets", 300],
["Gvozdno", 300],
["Staroye", 300],
["Sosnovka", 300],
["Komarovo", 300],
["Tulga", 300],
["Nizhnoye", 300],
["Devils Castle", 300],
["Novy Sobor", 300],
["International Airfield", 300],
["Zub Castle", 300],
["Vybor", 300],
["Msta", 300],
["Polana", 300],
["Olsha", 300],
["Kamenka", 300],
["Krutoy Cap", 500],
["Otmel", 300],
["Drakon", 300],
["Kamyshovo", 300],
["Gorka", 300],
["Zub", 300],
["Rog", 300]
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
call compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\fa_hiveMaintenance.sqf";

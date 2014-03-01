private["_playerPos","_adminRemoval","_authorizedGateCodes","_authorizedUID","_authorizedOUID","_authorizedPUID","_playerNearby","_func_ownerRemove","_qtyE","_qtyCr","_qtyC","_qtyB","_qtySt","_qtyDT","_qtyS","_qtyW","_qtyL","_qtyM","_qtyG","_qtyT","_removable","_eTool","_result","_building","_dialog","_classname","_requirements","_objectID","_objectUID","_obj","_cnt","_id","_tblProb","_locationPlayer","_randNum2","_smallWloop","_medWloop","_longWloop","_wait","_longWait","_medWait","_highP","_medP","_lowP","_failRemove","_canRemove","_randNum","_text","_dir","_pos","_isWater","_inVehicle","_onLadder","_hasToolbox","_canDo","_hasEtool"];
disableserialization;
remProc = true;
player removeAction s_player_deleteCamoNet;
s_player_deleteCamoNet = -1;
player removeAction s_player_deleteBuild;
s_player_deleteBuild = -1;
player removeAction s_player_removeFlag;
s_player_removeFlag = -1;
player removeAction s_player_deleteLightTower;
s_player_deleteLightTower = -1;
_obj = objNull;
_obj = _this select 3;
if (_obj isKindof "Grave") then {
_text = "Bomb";
cutText [format["You can only disarm %1 to remove it",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit";
};
// Get ObjectID or UID
if (!isNull _obj) then {
_objectID = _obj getVariable["ObjectID","0"];
_authorizedUID = _obj getVariable ["AuthorizedUID", []]; //Retrieve the object's stored array
_authorizedOUID = (_authorizedUID select 0) select 0; //Get the objectUID from the array so it doesn't miscalculate
};
// Anti dupe 
_playerNearby = (nearestObjects [player, ["AllPlayers","CAManBase"], 12] select 0);
if (!isNull _playerNearby && _playerNearby distance player <= 10 && _playerNearby != player && isPlayer _playerNearby && alive _playerNearby) exitwith 
{
	cutText ["Other players need to be > 10 meters away to remove object", "PLAIN DOWN"];	
	remProc = false;
};
_ownerID = _obj getVariable ["characterID","0"];
// Pre-Checks
_dir = direction _obj;
_pos = getposATL _obj;
_locationPlayer = player modeltoworld [0,0,0];
_onLadder 		= (getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_isWater 		= (surfaceIsWater _locationPlayer) or dayz_isSwimming;
_inVehicle 		= (vehicle player != player);
_building 		= nearestObject [player, "Building"];
_onLadder 		=		(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_hasToolbox 	= 	"ItemToolbox" in items player;
_canDo 			= (!r_drag_sqf and !r_player_unconscious and !_onLadder); //USE!!
_hasEtool 		= 	"ItemEtool" in weapons player;
_authorizedUID = _obj getVariable ["AuthorizedUID", []];
_authorizedPUID = _authorizedUID select 1; //Defines only the second element of the array which contains playerUIDs
_authorizedGateCodes = ((getPlayerUid player) in _authorizedPUID);
_adminRemoval = ((getPlayerUID player) in BBSuperAdminAccess || (getPlayerUID player) in BBLowerAdminAccess);	
_flagRadius 	= BBFlagRadius;
	
//Booleans
_canRemove 		= false;
_failRemove		= false;
_result 		= false;
adminChooses 	= false;
adminRemoval 	= false;

//Integers
_longWloop 		= 6; // time to remove object * 10 = time in seconds.  6 = 60 seconds
_medWloop 		= 4;
_smallWloop 	= 3;
_tblProb 		= BBtblProb;
_lowP 			= BBlowP;
_medP 			= BBmedP;
_highP 			= BBhighP;
_cnt 			= 0;
_wait 			= 10;

_qtyT = 0;
_qtyS = 0; //144752844454260
_qtyW = 0;
_qtyL = 0;
_qtyM = 0;
_qtyG = 0;
// Do percentages
_randNum = round(random 100);
_randNum2 = round(random 100);

//Others
if(_isWater) then {cutText [localize "str_player_26", "PLAIN DOWN"];remProc = false;breakOut "exit";};
if(_onLadder) then {cutText [localize "str_player_21", "PLAIN DOWN"];remProc = false;breakOut "exit";};
if (_inVehicle) then {cutText [localize "Can't do this in vehicle", "PLAIN DOWN"];remProc = false;breakOut "exit";};

// This function is for owner removal either by code (line 109) or by ownerID (line 112)
_func_ownerRemove = {

for "_i" from 0 to ((count allbuildables) - 1) do
	{
		_classname = (allbuildables select _i) select _i - _i + 1;
		_result = [typeOf(_obj),_classname] call BIS_fnc_areEqual;
			if (_result) exitwith {
				_recipe = (allbuildables select _i) select _i - _i;
				//[_qtyT, _qtyS, _qtyW, _qtyL, _qtyM, _qtyG]
				_qtyT = _recipe select 0;
				_qtyS = _recipe select 1;
				_qtyW = _recipe select 2;
				_qtyL = _recipe select 3;
				_qtyM = _recipe select 4;
				_qtyG = _recipe select 5;
			};
	};
	if (_qtyT > 0) then {
		for "_i" from 1 to _qtyT do { _result = [player,"ItemTankTrap"] call BIS_fnc_invAdd;  };
	};
	if (_qtyS > 0) then {
		for "_i" from 1 to _qtyS do { _result = [player,"ItemSandbag"] call BIS_fnc_invAdd;  };
	};
	if (_qtyW > 0) then {
		for "_i" from 1 to _qtyW do { _result = [player,"ItemWire"] call BIS_fnc_invAdd;  };
	};
	if (_qtyL > 0) then {
		for "_i" from 1 to _qtyL do { _result = [player,"PartWoodPile"] call BIS_fnc_invAdd; };
	};
	if (_qtyM > 0) then {
		for "_i" from 1 to _qtyM do { _result = [player,"PartGeneric"] call BIS_fnc_invAdd;  };
	};
	if (_qtyG > 0) then {
		for "_i" from 1 to _qtyG do { _result = [player,"HandGrenade_west"] call BIS_fnc_invAdd;  };
	};
	cutText [format["Owner refunded for object %1",typeof(_obj)], "PLAIN DOWN",1];
		dayzDeleteObj = [_objectID,_authorizedOUID];
	publicVariableServer "dayzDeleteObj";
	if (isServer) then { 
		dayzDeleteObj call server_deleteObj; 
	};
		deletevehicle _obj;
		remProc = false;
		breakout "exit";
};


//Admin remove option
if (_adminRemoval) then {
	s_admin_removal 	= player addAction ["ADMIN: Removal(Logged)", "dayz_code\actions\adminActions\admin_removal.sqf",_obj, 1, true, true, "", ""];
	s_normal_removal 	= player addAction ["ADMIN: Normal Removal", "dayz_code\actions\adminActions\normal_removal.sqf",_obj, 1, true, true, "", ""];
	waitUntil {adminChooses};
	player removeaction s_normal_removal;
	player removeaction s_admin_removal;
	s_normal_removal = -1;
	s_admin_removal = -1;
	if (adminRemoval) exitWith {
		call _func_ownerRemove;
	};
};

// Flag removal special
if (typeOf(_obj) == BBTypeOfFlag && (_authorizedGateCodes)) then {
	_baseObjects = nearestObjects [_obj, allbuildables_class,  BBFlagRadius];
	if (count _baseObjects > 1) then { //Flags count as an item so we have to check for >1
		cutText [format["You need to remove all existing base objects in %1 meters in order to move your base and delete your base flagpole",_flagRadius], "PLAIN DOWN",1];
		remProc = false;
		breakOut "exit";
	};
};

//Owner ID or PlayerUID removal
_playerPos = getPosATL player;
if (_authorizedGateCodes) then { 
	_cnt = 5;
	while {true} do {
		cutText [format["Removing object %1 in %2 seconds.\nMove position to cancel",typeOf(_obj), _cnt], "PLAIN DOWN",1];

		if ((getposATL player) distance _playerPos > 1) exitWith {
			cutText [format["You moved and canceled build for %1", typeOf(_obj)], "PLAIN DOWN",1];
			remProc = false;
			breakOut "exit";
		};
		if (_cnt <= 0) exitwith {call _func_ownerRemove;};
		sleep 1;
		_cnt = _cnt - 1;	
	};
};

remProc = true;
// Check what object is returned from global array, then return classname
	for "_i" from 0 to ((count allbuildables) - 1) do
	{
		_classname = (allbuildables select _i) select _i - _i + 1;
		_result = [typeOf(_obj),_classname] call BIS_fnc_areEqual;
			if (_result) exitWith {
				//_text = _classname;
				_text = getText (configFile >> "CfgVehicles" >> typeOf(_obj) >> "displayName");
				_requirements = (allbuildables select _i) select _i - _i + 2;
			};
	};
if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
		
//Get Requirements from build_list.sqf global array [_attachCoords, _startPos, _modDir, _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown];
_eTool 			= _requirements select 4;
_medWait 		= _requirements select 5;
_longWait 		= _requirements select 6;
_removable 		= _requirements select 10;
if (!_removable) then {cutText [format["%1 is not allowed to be removed!",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
switch (true) do
{
	case(_longWait):
	{
		if (_eTool) then {
			if (!_hasEtool) then {cutText [format["You need an entrenching tool to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
		};
		if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
		if (_randNum > _highP) then {_tblProb = _tblProb + 40;_canRemove = true;} else {_tblProb = _tblProb + 40;_failRemove = true;_longWait = true; };
	};
	case(_medWait):
	{
		if (_eTool) then {
			if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
		};
		if (!_hasEtool) then {cutText [format["You need an entrenching tool to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
		if (_randNum > _medP) then {_tblProb = _tblProb + 20;_canRemove = true;} else {_tblProb = _tblProb + 20; _failRemove = true; _medWait = true;};
	};
	case(!_medWait && !_longWait):
	{
		if (_eTool) then {
			if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
		};
		if (!_hasEtool) then {cutText [format["You need an entrenching tool to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
		if (_randNum > _lowP) then {_canRemove = true;} else { _failRemove = true;};
	};
};


//BuiltItems = ["Land_CncBlock","Land_ladder_half","Land_prebehlavka","Misc_cargo_cont_small_EP1","Land_fort_rampart_EP1","Hhedgehog_concrete","Land_ladder_half","Land_A_Castle_Stairs_A","Ins_WarfareBContructionSite","Misc_Cargo1Bo_military","Land_Misc_Cargo2E","Barrack2","Land_rails_bridge_40","Land_HBarrier1","Land_BagFenceRound","Land_fortified_nest_small","Land_HBarrier_large","Base_WarfareBBarrier10x","bunkerMedium02","Base_WarfareBBarrier10xTall","Land_Fort_Watchtower","Land_fortified_net_big","Fence_Ind","Fort_RazorWire","Land_podlejzacka","Land_camoNet_Nato","Land_camoNetB_Nato","Land_camoNetVar_Nato"];

switch (true) do
{
	case(_longWait && _canRemove):
	{
		_cnt = _longWloop;
		_cnt = _cnt * 10;
		for "_i" from 0 to _longWloop do
		{
			cutText [format["Attempting to deconstruct %1  %2 seconds left.  \nMove from current position to cancel\n %3 percent chance to fail, %4 percent chance to lose toolbox",_text,_cnt + 10,_highP,_tblProb], "PLAIN DOWN",1];
			if (player distance _locationPlayer > 0.2) then {cutText [format["Removal canceled for %1, position of player moved",_text], "PLAIN DOWN",1]; remProc = false; breakOut "exit";};
			if (!_canDo || _onLadder || _inVehicle) then {cutText [format["Removal canceled for %1, player is unable to continue",_text], "PLAIN DOWN",1]; remProc = false; breakOut "exit";};
			player playActionNow "Medic";
			_dialog = findDisplay 106;
			sleep 1;
			[player,"repair",0,false] call dayz_zombieSpeak;
			_id = [player,50,true,(getPosATL player)] spawn player_alertZombies;
			sleep _wait;
			_hasToolbox = 	"ItemToolbox" in items player;
			if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			if (!(isNull _dialog)) then {cutText [format["Removal canceled for %1, you opened your gear menu.",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			_cnt = _cnt - 10;
		};
		_hasToolbox = 	"ItemToolbox" in items player;
		if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
		if (!isNull _obj && _randNum2 < _tblProb) then {player removeWeapon "ItemToolbox"; cutText ["Your toolbox was used up!", "PLAIN DOWN"];};
			sleep 1.5;
	};
	case(_medWait && _canRemove):
	{
		_cnt = _medWloop;
		_cnt = _cnt * 10;
		for "_i" from 0 to _medWloop do
		{
			cutText [format["Attempting to deconstruct %1  %2 seconds left.  \nMove from current position to cancel\n %3 percent chance to fail, %4 percent chance to lose toolbox",_text,_cnt + 10,_medP,_tblProb], "PLAIN DOWN",1];
			if (player distance _locationPlayer > 0.2) then {cutText [format["Removal canceled for %1, position of player moved",_text], "PLAIN DOWN",1]; remProc = false; breakOut "exit";};
			if (!_canDo || _onLadder || _inVehicle) then {cutText [format["Removal canceled for %1, player is unable to continue",_text], "PLAIN DOWN",1]; remProc = false; breakOut "exit";};
			player playActionNow "Medic";
			_dialog = findDisplay 106;
			sleep 1;
			[player,"repair",0,false] call dayz_zombieSpeak;
			_id = [player,50,true,(getPosATL player)] spawn player_alertZombies;
			sleep _wait;
			_hasToolbox = 	"ItemToolbox" in items player;
			if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			if (!(isNull _dialog)) then {cutText [format["Removal canceled for %1, you opened your gear menu.",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			_cnt = _cnt - 10;
	};
			_hasToolbox = 	"ItemToolbox" in items player;
			if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			if (!isNull _obj && _randNum2 < _tblProb) then {player removeWeapon "ItemToolbox"; cutText ["Your toolbox was used up!", "PLAIN DOWN"];};
			sleep 1.5;
	};
	case((!_medWait && !_longWait) && _canRemove):
	{
		_cnt = _smallWloop;
		_cnt = _cnt * 10;
		for "_i" from 0 to _smallWloop do
		{
			cutText [format["Attempting to deconstruct %1  %2 seconds left.  \nMove from current position to cancel\n %3 percent chance to fail, %4 percent chance to lose toolbox",_text,_cnt + 10,_lowP,_tblProb], "PLAIN DOWN",1];
			if (player distance _locationPlayer > 0.2) then {cutText [format["Removal canceled for %1, position of player moved",_text], "PLAIN DOWN",1]; remProc = false; breakOut "exit";};
			if (!_canDo || _onLadder || _inVehicle) then {cutText [format["Removal canceled for %1, player is unable to continue",_text], "PLAIN DOWN",1]; remProc = false; breakOut "exit";};
			player playActionNow "Medic";
			_dialog = findDisplay 106;
			sleep 1;
			[player,"repair",0,false] call dayz_zombieSpeak;
			_id = [player,50,true,(getPosATL player)] spawn player_alertZombies;
			sleep _wait;
			_hasToolbox = 	"ItemToolbox" in items player;
			if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			if (!(isNull _dialog)) then {cutText [format["Removal canceled for %1, you opened your gear menu.",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			_cnt = _cnt - 10;
		};
			_hasToolbox = 	"ItemToolbox" in items player;
			if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			if (!isNull _obj && _randNum2 < _tblProb) then {player removeWeapon "ItemToolbox"; cutText ["Your toolbox was used up!", "PLAIN DOWN"];};
			sleep 1.5;
	};
	case(_longWait && _failRemove):
	{
		_cnt = _longWloop;
		_cnt = _cnt * 10;
		for "_i" from 0 to _longWloop do
		{
			cutText [format["Attempting to deconstruct %1  %2 seconds left.  \nMove from current position to cancel\n %3 percent chance to fail, %4 percent chance to lose toolbox",_text,_cnt + 10,_highP,_tblProb], "PLAIN DOWN",1];
			if (player distance _locationPlayer > 0.2) then {cutText [format["Removal canceled for %1, position of player moved",_text], "PLAIN DOWN",1]; remProc = false; breakOut "exit";};
			if (!_canDo || _onLadder || _inVehicle) then {cutText [format["Removal canceled for %1, player is unable to continue",_text], "PLAIN DOWN",1]; remProc = false; breakOut "exit";};
			player playActionNow "Medic";
			_dialog = findDisplay 106;
			sleep 1;
			[player,"repair",0,false] call dayz_zombieSpeak;
			_id = [player,50,true,(getPosATL player)] spawn player_alertZombies;
			sleep _wait;
			_hasToolbox = 	"ItemToolbox" in items player;
			if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			if (!(isNull _dialog)) then {cutText [format["Removal canceled for %1, you opened your gear menu.",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			_cnt = _cnt - 10;
		};
			_hasToolbox = 	"ItemToolbox" in items player;
			if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			if (!isNull _obj && _randNum2 < _tblProb) then {player removeWeapon "ItemToolbox"; cutText ["Your toolbox was used up!", "PLAIN DOWN"];};
			sleep 1.5;
			cutText [format["You failed to remove %1!",_text], "PLAIN DOWN",6]; remProc = false; breakOut "exit";
	};
	case(_medWait && _failRemove):
	{
		_cnt = _medWloop;
		_cnt = _cnt * 10;
		for "_i" from 0 to _medWloop do
		{
			cutText [format["Attempting to deconstruct %1  %2 seconds left.  \nMove from current position to cancel\n %3 percent chance to fail, %4 percent chance to lose toolbox",_text,_cnt + 10,_medP,_tblProb], "PLAIN DOWN",1];
			if (player distance _locationPlayer > 0.2) then {cutText [format["Removal canceled for %1, position of player moved",_text], "PLAIN DOWN",1]; remProc = false; breakOut "exit";};
			if (!_canDo || _onLadder || _inVehicle) then {cutText [format["Removal canceled for %1, player is unable to continue",_text], "PLAIN DOWN",1]; remProc = false; breakOut "exit";};
			player playActionNow "Medic";
			_dialog = findDisplay 106;
			sleep 1;
			[player,"repair",0,false] call dayz_zombieSpeak;
			_id = [player,50,true,(getPosATL player)] spawn player_alertZombies;
			sleep _wait;
			_hasToolbox = 	"ItemToolbox" in items player;
			if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			if (!(isNull _dialog)) then {cutText [format["Removal canceled for %1, you opened your gear menu.",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			_cnt = _cnt - 10;
		};
			_hasToolbox = 	"ItemToolbox" in items player;
			if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			if (!isNull _obj && _randNum2 < _tblProb) then {player removeWeapon "ItemToolbox"; cutText ["Your toolbox was used up!", "PLAIN DOWN"];};
			sleep 1.5;
			cutText [format["You failed to remove %1!",_text], "PLAIN DOWN",6]; remProc = false; breakOut "exit";
	};
	case((!_medWait && !_longWait) && _failRemove):
	{
		_cnt = _smallWloop;
		_cnt = _cnt * 10;
		for "_i" from 0 to _smallWloop do
		{
			cutText [format["Attempting to deconstruct %1  %2 seconds left.  \nMove from current position to cancel\n %3 percent chance to fail, %4 percent chance to lose toolbox",_text,_cnt + 10,_lowP,_tblProb], "PLAIN DOWN",1];
			if (player distance _locationPlayer > 0.2) then {cutText [format["Removal canceled for %1, position of player moved",_text], "PLAIN DOWN",1]; remProc = false; breakOut "exit";};
			if (!_canDo || _onLadder || _inVehicle) then {cutText [format["Removal canceled for %1, player is unable to continue",_text], "PLAIN DOWN",1]; remProc = false; breakOut "exit";};
			player playActionNow "Medic";
			_dialog = findDisplay 106;
			sleep 1;
			[player,"repair",0,false] call dayz_zombieSpeak;
			_id = [player,50,true,(getPosATL player)] spawn player_alertZombies;
			sleep _wait;
			_hasToolbox = 	"ItemToolbox" in items player;
			if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			if (!(isNull _dialog)) then {cutText [format["Removal canceled for %1, you opened your gear menu.",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			_cnt = _cnt - 10;
		};
			_hasToolbox = 	"ItemToolbox" in items player;
			if (!_hasToolbox) then {cutText [format["You need a tool box to remove %1",_text], "PLAIN DOWN",1];remProc = false; breakOut "exit"; };
			if (!isNull _obj && _randNum2 < _tblProb) then {player removeWeapon "ItemToolbox"; cutText ["Your toolbox was used up!", "PLAIN DOWN"];};
			sleep 1.5;
			cutText [format["You failed to remove %1!",_text], "PLAIN DOWN",6]; remProc = false; breakOut "exit";
	};

};

//Player removes object successfully
if (!isNull _obj) then {
cutText [format["You removed a %1 successfully!",_text], "PLAIN DOWN"];
	dayzDeleteObj = [_objectID,_authorizedOUID];
	publicVariableServer "dayzDeleteObj";
if (isServer) then { 
	dayzDeleteObj call server_deleteObj; 
};

sleep .1;
deleteVehicle _obj;
};
remProc = false;
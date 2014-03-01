/*
Base Building DayZ by Daimyo
*/
private["_authorizedUID","_allFlags","_newAttachCoords","_startingPos","_buildables","_flagradius","_okToBuild","_allowedExtendedMode","_flagNearest","_flagNearby","_requireFlag","_funcExitScript","_playerCombat","_isSimulated","_isDestructable","_townRange","_longWloop","_medWloop","_smallWloop","_inTown","_inProgress","_modDir","_startPos","_tObjectPos","_buildable","_chosenRecipe","_cnt","_cntLoop","_dialog","_buildCheck","_isInCombat","_playerCombat","_check_town","_eTool","_toolBox","_town_pos","_town_name","_closestTown","_roadAllowed","_toolsNeeded","_inBuilding","_attachCoords","_requirements","_result","_alreadyBuilt","_uidDir","_p1","_p2","_uid","_worldspace","_panelNearest2","_staticObj","_onRoad","_itemL","_itemM","_itemG","_qtyL","_qtyM","_qtyG","_cntLoop","_finished","_checkComplete","_objectTemp","_locationPlayer","_object","_id","_isOk","_text","_mags","_hasEtool","_canDo","_hasToolbox","_inVehicle","_isWater","_onLadder","_building","_medWait","_longWait","_location","_isOk","_dir","_classname","_item","_itemT","_itemS","_itemW","_qtyT","_qtyS","_qtyW","_qtyE","_qtyCr","_qtyC","_qtyB","_qtySt","_qtyDT","_itemE","_itemCr","_itemC","_itemB","_itemSt","_itemDT","_authorizedPUID","_canUseFlag"];

//Used for repositioning later
builderChooses	= false;
buildCancel		= false;
if (buildReposition) then {
_repoObjectPos	= _this select 0;
_repoObjectDirR	= _this select 1;
} else {
_repoObjectPos	= [];
_repoObjectDirR	= 0;
};

// Location placement declarations
_locationPlayer = player modeltoworld [0,0,0];
_location 		= player modeltoworld [0,0,0]; // Used for object start location and to keep track of object position throughout
_attachCoords = [0,0,0];
_dir 			= getDir player;
_building 		= nearestObject [player, "Building"];
_staticObj 		= nearestObject [player, "Static"];

// Restriction Checks

_hasEtool 		= "ItemEtool" in weapons player;
_hasToolbox 	= 	"ItemToolbox" in items player;
_onLadder 		=	(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_canDo 			= (!r_drag_sqf and !r_player_unconscious and !_onLadder); //USE!!
_isWater 		= 	(surfaceIsWater _locationPlayer) or dayz_isSwimming;
_inVehicle 		= (vehicle player != player);
_isOk = [player,_building] call fnc_isInsideBuilding;
_closestTown = (nearestLocations [player,["NameCityCapital","NameCity","NameVillage","Airport"],25600]) select 0;
_town_name = text _closestTown;
_town_pos = position _closestTown;

// Booleans  Some not used, possibly use later
_roadAllowed 	= false;
_medWait 		= false;
_longWait 		= false;
_checkComplete 	= false;
_finished 		= false;
_eTool 			= false;
_toolBox 		= false;
_alreadyBuilt 	= false;
_inBuilding 	= false;
_inTown 		= false;
_inProgress 	= false;
_result 		= false;
_isSimulated 	= false;
_isDestructable = false;
_requireFlag 	= false;
_flagNearby 	= false;
_okToBuild 		= false;
// Strings
_classname 		= "";
_check_town		= "";

// Other
_flagRadius 	= BBFlagRadius; //Meters around flag that players can build
_cntLoop 		= 0;
_chosenRecipe 	= [];
_requirements 	= [];
_buildable 		= [];
_buildables		= [];
_longWloop		= 2;
_medWloop		= 1;
_smallWloop 	= 0;
_cnt 			= 0;
_playerCombat 	= player;

	// Function to exit script without combat activate
	_funcExitScript = {
		player removeAction attachGroundAction;
		player removeAction previewAction;
		player removeAction restablishAction;
		player removeAction repositionAction;
		player removeAction finishAction;
		player removeAction cancelAction;
		procBuild = false;
		if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",BBCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};//Reload Debug Monitor if it was active before
		breakOut "exit";
	};
	// Do first checks to see if player can build before counting
	if (procBuild) then {cutText ["You're already building!", "PLAIN DOWN"];call _funcExitScript;};
	if(_isWater) then {cutText [localize "str_player_26", "PLAIN DOWN"];call _funcExitScript;};
	if(_onLadder) then {cutText [localize "str_player_21", "PLAIN DOWN"];call _funcExitScript;};
	if (_inVehicle) then {cutText ["Can't do this in vehicle", "PLAIN DOWN"];call _funcExitScript;};
	disableSerialization;
	closedialog 1;
	// Ashfor Fix: Did player try to drop mag and keep action active (not really needed but leave here just in case)
	//_item = _this;
	//if (_item in (magazines player) ) then { // needs }; 
	// Global variables for loop method, procBuild may not be needed if implemented in fn_selfactions.sqf
		if (dayz_combat == 1) then {
			cutText ["You're currently in combat, time reduced to 3 seconds. \nCanceling/escaping will set you back into combat", "PLAIN DOWN"];
			sleep 3;
			_playerCombat setVariable["combattimeout", 0, true];
			dayz_combat = 0;
		};
	r_interrupt = false;
	r_doLoop = true;
	procBuild = true;
	//Global build_list reference params:
	//[_qtyT, _qtyS, _qtyW, _qtyL, _qtyM, _qtyG], "Classname", [_attachCoords, _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown];
	call gear_ui_init;
	// Count mags in player inventory and add to an array
	_mags = magazines player;
		if ("ItemTankTrap" in _mags) then {
			_qtyT = {_x == "ItemTankTrap"} count magazines player;
			_buildables set [count _buildables, _qtyT];
			_itemT = "ItemTankTrap";
		} else { _qtyT = 0; _buildables set [count _buildables, _qtyT]; };
			
		if ("ItemSandbag" in _mags) then {
			_qtyS = {_x == "ItemSandbag"} count magazines player;
			_buildables set [count _buildables, _qtyS]; 
			_itemS = "ItemSandbag";
		} else { _qtyS = 0; _buildables set [count _buildables, _qtyS]; };
		
		if ("ItemWire" in _mags) then {
			_qtyW = {_x == "ItemWire"} count magazines player;
			_buildables set [count _buildables, _qtyW]; 
			_itemW = "ItemWire";
			} else { _qtyW = 0; _buildables set [count _buildables, _qtyW]; };
			
		if ("PartWoodPile" in _mags) then {
			_qtyL = {_x == "PartWoodPile"} count magazines player;
			_buildables set [count _buildables, _qtyL]; 
			_itemL = "PartWoodPile";
		} else { _qtyL = 0; _buildables set [count _buildables, _qtyL]; };
		
		if ("PartGeneric" in _mags) then {
			_qtyM = {_x == "PartGeneric"} count magazines player;
			_buildables set [count _buildables, _qtyM]; 
			_itemM = "PartGeneric";
		} else { _qtyM = 0; _buildables set [count _buildables, _qtyM]; };
		
		if ("HandGrenade_West" in _mags) then {
			_qtyG = {_x == "HandGrenade_West"} count magazines player;
			_buildables set [count _buildables, _qtyG]; 
			_itemG = "HandGrenade_West";
		} else { _qtyG = 0; _buildables set [count _buildables, _qtyG]; };

		if ("equip_scrapelectronics" in _mags) then {
			_qtyE = {_x == "equip_scrapelectronics"} count magazines player;
			_buildables set [count _buildables, _qtyE]; 
			_itemE = "equip_scrapelectronics";
		} else { _qtyE = 0; _buildables set [count _buildables, _qtyE]; };
		
		if ("equip_crate" in _mags) then {
			_qtyCr = {_x == "equip_crate"} count magazines player;
			_buildables set [count _buildables, _qtyCr]; 
			_itemCr = "equip_crate";
		} else { _qtyCr = 0; _buildables set [count _buildables, _qtyCr]; };
		
		if ("ItemCamoNet" in _mags) then {
			_qtyC = {_x == "ItemCamoNet"} count magazines player;
			_buildables set [count _buildables, _qtyC]; 
			_itemC = "ItemCamoNet";
		} else { _qtyC = 0; _buildables set [count _buildables, _qtyC]; };
		
		if ("equip_brick" in _mags) then {
			_qtyB = {_x == "equip_brick"} count magazines player;
			_buildables set [count _buildables, _qtyB]; 
			_itemB = "equip_brick";
		} else { _qtyB = 0; _buildables set [count _buildables, _qtyB]; };
		
		if ("equip_string" in _mags) then {
			_qtySt = {_x == "equip_string"} count magazines player;
			_buildables set [count _buildables, _qtySt]; 
			_itemSt = "equip_string";
		} else { _qtySt = 0; _buildables set [count _buildables, _qtySt]; };
		
		if ("equip_duct_tape" in _mags) then {
			_qtyDT = {_x == "equip_duct_tape"} count magazines player;
			_buildables set [count _buildables, _qtyDT]; 
			_itemDt = "equip_duct_tape";
		} else { _qtyDT = 0; _buildables set [count _buildables, _qtyDT]; };
	
	/*-- Add another item for recipe here by changing _qtyI, "Item_Classname", and add recipe into build_list.sqf array!
		Dont forget to add recipe to recipelist so your players can know how to make object via recipe
	//		if ("Item_Classname" in _mags) then {
	//		_qtyI = {_x == "Item_Classname"} count magazines player;
	//		_buildables set [count _buildables, _qtyI]; 
	//		_itemG = "Item_Classname";
	//	} else { _qtyI = 0; _buildables set [count _buildables, _qtyI]; };
	*/
		
	// Check what object is returned from global array, then return classname
		for "_i" from 0 to ((count allbuildables) - 1) do
		{
			_buildable = (allbuildables select _i) select _i - _i;
			_result = [_buildables,_buildable] call BIS_fnc_areEqual;
				if (_result) then {
					_classname = (allbuildables select _i) select _i - _i + 1;
					_requirements = (allbuildables select _i) select _i - _i + 2;
					_chosenRecipe = _buildable;
				};
			_buildable = [];
		};
	// Quit here if no proper recipe is acquired else set names properly
	if (_classname == "") then {cutText ["You need the EXACT amount of whatever you are trying to build without extras.", "PLAIN DOWN"];call _funcExitScript;};
	if (_classname == "Grave") then {_text = "Booby Trap";};
	if (_classname == "Concrete_Wall_EP1") then {_text = "Gate Concrete Wall";};
	if (_classname == "Infostand_2_EP1") then {_text = "Gate Panel Keypad Access";};
	if (_classname == BBTypeOfZShield) then {_text = "Zombie Shield Generator";};
	if (_classname != "Infostand_2_EP1" && 
		_classname != "Concrete_Wall_EP1" &&  
		_classname != "Grave" &&
		_classname != BBTypeOfZShield) then {
	//_text = _classname;
	_text = getText (configFile >> "CfgVehicles" >> _classname >> "displayName");				
	};
	_buildable = [];

	//Get Requirements from build_list.sqf global array [_attachCoords, _startPos, _modDir, _toolBox, _eTool, _medWait, _longWait, _inBuilding, _roadAllowed, _inTown];
	_attachCoords 	= _requirements select 0;
	_startPos 		= _requirements select 1;
	_modDir 		= _requirements select 2;
	_toolBox 		= _requirements select 3;
	_eTool 			= _requirements select 4;
	_medWait 		= _requirements select 5;
	_longWait 		= _requirements select 6;
	_inBuilding 	= _requirements select 7;
	_roadAllowed 	= _requirements select 8;
	_inTown 		= _requirements select 9;
	_isSimulated 	= _requirements select 12;
	_isDestrutable	= _requirements select 13;
	_requireFlag 	= _requirements select 14;
	// Get _startPos for object
	_location 		= player modeltoworld _startPos;
	//Set flag radius for zombie shield generator, reduce by generator radius to avoid players building them on the edge of their flag radius
	if (BBZShieldDis == 1 && _classname == BBTypeOfZShield) then {_flagRadius = _flagRadius-BBZShieldRadius};
	//Make sure player isn't registered on more than allowed number of flags
	if (_classname == BBTypeOfFlag) then { 
		_allFlags = nearestObjects [player, [BBTypeOfFlag], 25000];
		_flagcount = 0;
		_flagMarkerArr = [];
		{
			if (typeOf(_x) == BBTypeOfFlag) then {
				_authorizedUID = _x getVariable ["AuthorizedUID", []];
				_authorizedPUID = _authorizedUID select 1;
				if ((getPlayerUid player) in _authorizedPUID && (_classname == BBTypeOfFlag)) then {
					_flagcount = _flagcount + 1;
					_flagname = format ["Flag_%1",_x];
					_flagMarker = createMarkerLocal [_flagName,position _x];       
					_flagMarker setMarkerTypeLocal "Town";
					_flagMarker setMarkerColorLocal("ColorGreen");
					_flagMarker setMarkerTextLocal format ["%1's Flag", (name player)];
					_flagMarkerArr = _flagMarkerArr + [_flagMarker];
					if (_flagcount >= BBMaxPlayerFlags) then {
						cutText [format["Your playerUID is already registered to %1 flagpoles, you can only be added on upto %1 flag poles. Check Map for temporary flag markers, 10 seconds!\nBuild canceled for %2",BBMaxPlayerFlags,_text], "PLAIN DOWN"];
						sleep 10;
						{
							deleteMarkerLocal _x
						} forEach _flagMarkerArr;
						call _funcExitScript;
					};
				};
			};
		} foreach _allFlags;
		{
			deleteMarkerLocal _x
		} forEach _flagMarkerArr;
	};
	//Special check for zombie shields
	if (_classname == BBTypeOfZShield) then {
		_allShields = nearestObjects [player, [BBTypeOfZShield], 25000];
		_shieldCount = 0;
		{
			if (typeOf(_x) == BBTypeOfZShield) then {
				_authorizedUID = _x getVariable ["AuthorizedUID", []];
				_authorizedPUID = _authorizedUID select 1;
				if ((getPlayerUID player) in _authorizedPUID && (_classname == BBTypeOfZShield)) then {
					_shieldCount = _shieldCount + 1;
					if (_shieldCount >= BBMaxZShields) then {
						cutText [format["Your playerUID is already registered to %1 zombie shield generators, you can only be added on upto %1 zombie shield generators.\nBuild canceled for %2",BBMaxZShields,_text], "PLAIN DOWN"];
						sleep 1;
						call _funcExitScript;
					};
				};
			};
		} forEach _allShields;
	};
		
	//Don't allow players to build in other's bases
	if (_classname != "Grave" && _classname != BBTypeOfFlag) then {
		_allFlags = nearestObjects [player, [BBTypeOfFlag], 25000];
		if (count _allFlags <= 0) then {
			_flagNearby = false;
			_okToBuild = false;
			if (!_okToBuild && _requireFlag && !_flagNearby) then {cutText [format["Either no flag is within %1 meters or you have not built a flag pole and claimed your land.\nBuild canceled for %2",_flagRadius, _text], "PLAIN DOWN"];call _funcExitScript;};
		};
		{
			if (typeOf(_x) == BBTypeOfFlag) then {
				_authorizedUID = _x getVariable ["AuthorizedUID", []];
				_authorizedPUID = _authorizedUID select 1;
				if ((getPlayerUid player) in _authorizedPUID && _x distance player <= _flagRadius) then {
					_flagNearby = true;
					_okToBuild = true;	
				} else { //TEST THIS
					_flagNearby = false;
					_okToBuild = false;
				};
			};
			if (_okToBuild) exitWith {};
			if (!_okToBuild && (!_requireFlag || _requireFlag) && _x distance player <= _flagRadius) then {cutText [format["Build canceled for %1\nCannot build in other player's bases, only Booby traps are allowed.",_text], "PLAIN DOWN"];call _funcExitScript;};
			if (!_okToBuild && _requireFlag && !_flagNearby) then {cutText [format["Either no flag is within %1 meters or you have not built a flag pole and claimed your land.\nBuild canceled for %2",_flagRadius, _text], "PLAIN DOWN"];call _funcExitScript;};
		} foreach _allFlags;
	};
	
	if (_toolBox) then {
		if (!_hasToolbox) then {cutText [format["You need a tool box to build %1",_text], "PLAIN DOWN"];call _funcExitScript; };
	};
	if (_eTool) then {
		if (!_hasEtool) then {cutText [format["You need an entrenching tool to build %1",_text], "PLAIN DOWN"];call _funcExitScript; };
	};
	if (!_inBuilding) then {
		if (_isOk) then {cutText [format["%1 cannot be built inside of buildings!",_text], "PLAIN DOWN"];call _funcExitScript; };
	};
	if (!_roadAllowed) then { // Do another check for object being on road
		_onRoad = isOnRoad _locationPlayer;
		if(_onRoad) then {cutText [format["You cannot build %1 on the road",_text], "PLAIN DOWN"];call _funcExitScript;};
	};
	if (!_inTown) then {
		for "_i" from 0 to ((count allbuild_notowns) - 1) do
		{
			_check_town = (allbuild_notowns select _i) select _i - _i;
			if (_town_name == _check_town) then {
				_townRange = (allbuild_notowns select _i) select _i - _i + 1;
				if (_locationPlayer distance _town_pos <= _townRange) then {
					cutText [format["You cannot build %1 within %2 meters of area %3",_text, _townRange, _town_name], "PLAIN DOWN"];call _funcExitScript;
				};
			};
		};
	};

	//Check to make sure not building flag too near another base
	_flagNearest = nearestObjects [player, [BBTypeOfFlag], (_flagRadius * 2)];
	if (_classname == BBTypeOfFlag && (count _flagNearest > 0)) then {cutText [format["Only 1 flagpole per base in a %1 meter radius! Remember, this includes the other base's build radius as well.",(_flagRadius * 2)], "PLAIN DOWN"];call _funcExitScript;};

	// Begin building process
	_buildCheck = false;
	buildReady = false;
	player allowdamage false;
	if (buildReposition) then {
	_object = createVehicle [_classname, _repoObjectPos, [], 0, "NONE"]; //Restore previous position if repositioning
	_repoObjectPos = [];
		if (_classname != "grave") then {
		_object setVariable ["characterID",dayz_characterID,true]; //Do this to prevent loot spawning during build process but not for bombs
		};
	} else {
	_object = createVehicle [_classname, _location, [], 0, "NONE"];
	_object setDir (getDir player);
		if (_classname != "grave") then {
			_object setVariable ["characterID",dayz_characterID,true]; //DO this to prevent loot spawning during build process but not for bombs
		} else {
			objectHeight=0;
			objectDistance=0;
			objectParallelDistance=0;
		};
	};
	if (_modDir > 0) then {
	_object setDir (getDir player) + _modDir;
	};
	_allowedExtendedMode = (typeOf(_object) in allExtendables);
	_allBuildables = (typeof(_object) in allbuildables_class);
	player removeAction attachGroundAction;
	player removeAction previewAction;
	player removeAction restablishAction;
	player removeAction repositionAction;
	player removeAction finishAction;
	player removeAction cancelAction;
		
    if(_allBuildables)then {
		previewAction 		= player addAction ["Preview (do this to complete)!", "dayz_code\actions\buildActions\previewBuild.sqf",_object, 6, true, true, "", ""];
        restablishAction 	= player addAction ["Restablish", "dayz_code\actions\buildActions\restablishObject.sqf",_object, 6, true, true, "", ""];
        attachGroundAction 	= player addAction ["Attach to ground", "dayz_code\actions\buildActions\attachGroundObject.sqf",_object, 6, true, true, "", ""];
    };
	if (buildReposition) then {
	rotateDir = _repoObjectDirR; //Restore previous rotation direction if repositioning
	_repoObjectDirR = 0;
	buildReposition = false;
	} else {
    rotateDir = _modDir;
	};
	player allowdamage true;
	hint "";
	//_startingPos = getPos player;  // used to restrict distance of build
	while {!buildReady} do {
	bbCDebug = missionNameSpace getVariable [format["%1",BBCustomDebug],false];
	if (bbCDebug) then {missionNameSpace setVariable [format["%1",BBCustomDebug],false]; hintSilent ""; bbCDReload = 1;};
	if (_allowedExtendedMode) then {
	//Lets make a nice hint window to tell people the controls
		hintsilent parseText format ["
		<t align='center' color='#0074E8'>Build process started</t><br/>
		<t align='center' color='#0074E8'>Move around to re-position</t><br/><br/>
		<t align='left' color='#F5CF36'>Controls</t>		<t align='right' color='#F5CF36'>NumPad</t><br/>
		<t align='left' color='#85E67E'>Rotate</t>			<t align='right' color='#E7F5E6'>7 + 9</t><br/>
		<t align='left' color='#85E67E'>Push/Pull</t>		<t align='right' color='#E7F5E6'>4 + 1</t><br/>
		<t align='left' color='#85E67E'>Left/Right</t>		<t align='right' color='#E7F5E6'>2 + 3</t><br/>
		<t align='left' color='#85E67E'>Elevate/Lower</t>	<t align='right' color='#E7F5E6'>8 + 5</t><br/>
		<t align='center' color='#F5CF36'>You can hold SHIFT for slower rotation/elevation</t><br/><br/>
		<t align='center' color='#85E67E'>Select 'Preview' when ready</t><br/>
		"];
	} else {
		if (_classname != "Grave") then {
			//Non extendables can't be elevated/lowered so we need a slightly different list
			hintsilent parseText format ["
			<t align='center' color='#0074E8'>Build process started</t><br/>
			<t align='center' color='#0074E8'>Move around to re-position</t><br/><br/>
			<t align='left' color='#F5CF36'>Controls</t>		<t align='right' color='#F5CF36'>NumPad</t><br/>
			<t align='left' color='#85E67E'>Rotate</t>			<t align='right' color='#E7F5E6'>7 + 9</t><br/>
			<t align='left' color='#85E67E'>Push/Pull</t>		<t align='right' color='#E7F5E6'>4 + 1</t><br/>
			<t align='left' color='#85E67E'>Left/Right</t>		<t align='right' color='#E7F5E6'>2 + 3</t><br/>
			<t align='center' color='#F5CF36'>You can hold SHIFT for slower rotation</t><br/><br/>
			<t align='center' color='#85E67E'>Select 'Preview' when ready</t><br/>
			"];
		} else {
			//We don't want graves to have push/pull, or left/right
			hintsilent parseText format ["
			<t align='center' color='#0074E8'>Build process started</t><br/>
			<t align='center' color='#0074E8'>Move around to re-position</t><br/>
			<t align='center' color='#0074E8'>If grave is floating, use 'Attach to Ground' option</t><br/><br/>
			<t align='left' color='#F5CF36'>Controls</t>		<t align='right' color='#F5CF36'>NumPad</t><br/>
			<t align='left' color='#85E67E'>Rotate</t>			<t align='right' color='#E7F5E6'>7 + 9</t><br/>
			<t align='center' color='#F5CF36'>You can hold SHIFT for slower rotation</t><br/><br/>
			<t align='center' color='#85E67E'>Select 'Preview' when ready</t><br/>
			"];
		};
	};	
		if(_allBuildables) then {
		//Rotations + Push Pull + Move Left or Right set to keys
			//Rotate Left
			if (DZ_BB_Rl) then {
				DZ_BB_Rl = false;
				rotateDir = rotateDir - rotateIncrement;
				if(rotateDir >= 360) then {
					rotateDir = 0;
				};
				_object setDir (getDir player) + rotateDir ;
			};
			//Rotate Right
			if (DZ_BB_Rr) then {
				DZ_BB_Rr = false;
				rotateDir = rotateDir + rotateIncrement;
				if(rotateDir >= 360) then {
					rotateDir = 0;
				};
				_object setDir (getDir player) + rotateDir ;
			};
			//Rotate Left Small
			if (DZ_BB_Rls) then {
				DZ_BB_Rls = false;
				rotateDir = rotateDir - rotateIncrementSmall;
				if(rotateDir >= 360) then {
					rotateDir = 0;
				};
				_object setDir (getDir player) + rotateDir ;
			};
			//Rotate Right Small
			if (DZ_BB_Rrs) then {
				DZ_BB_Rrs = false;
				rotateDir = rotateDir + rotateIncrementSmall;
				if(rotateDir >= 360) then {
					rotateDir = 0;
				};
				_object setDir (getDir player) + rotateDir ;
			};
			if (_classname != "Grave") then {
				//Push Away
				if (DZ_BB_A) then {
					DZ_BB_A = false;
					if(objectDistance<maxObjectDistance) then {
						objectDistance= objectDistance + 0.5;
					};
				};
				//Pull Near
				if (DZ_BB_N) then {
					DZ_BB_N = false;
					if(objectDistance>minObjectDistance) then {
						objectDistance= objectDistance - 0.3;
					};
				};
				//Move Right
				if (DZ_BB_Le) then {
					DZ_BB_Le = false;
					if(objectParallelDistance>minObjectDistance) then {
						objectParallelDistance= objectParallelDistance - 0.5;
					};
				};
				//Move Left
				if (DZ_BB_Ri) then {
					DZ_BB_Ri = false;
					if(objectParallelDistance<maxObjectDistance) then {
						objectParallelDistance= objectParallelDistance + 0.5;
					};
				};
			};
		};
		if (_allowedExtendedMode) then {
		//Additional keybinds for lifing + lowering only to be used with extended build objects
			//Elevate
			if (DZ_BB_E) then {
				DZ_BB_E = false;
				if(objectHeight<objectTopHeight) then {
					objectHeight= objectHeight + objectIncrement;
				};
			};
			//Lower
			if (DZ_BB_L) then {
				DZ_BB_L = false;
				if(objectHeight>objectLowHeight) then {
					objectHeight= objectHeight - objectIncrement;
				};
			};
			//Elevate Small
			if (DZ_BB_Es) then {
				DZ_BB_Es = false;
				if(objectHeight<objectTopHeight) then {
					objectHeight= objectHeight + objectIncrementSmall;
				};
			};
			//Lower Small
			if (DZ_BB_Ls) then {
				DZ_BB_Ls = false;
				if(objectHeight>objectLowHeight) then {
					objectHeight= objectHeight - objectIncrementSmall;
				};
			};
		};
		
		_playerCombat = player;
		_isInCombat = _playerCombat getVariable["startcombattimer",0];
		_dialog = findDisplay 106;
		//This section handles the placement where you can change position etc
			if ((speed player <= 12) && (speed player >= -9)) then {
                    _newAttachCoords = [];
                    _newAttachCoords = [(objectParallelDistance+(_attachCoords select 0)),(objectDistance + (_attachCoords select 1)),(objectHeight + (_attachCoords select 2))];
                    _object attachto [player, _newAttachCoords];
					_object setDir (getDir player) + rotateDir;	
			};
			
			//Make sure players don't move into another players base, or outside their own flag radius
			if (_classname != "Grave" && _classname != BBTypeOfFlag) then {
				_allFlags = nearestObjects [player, [BBTypeOfFlag], 25000];
				{
					if (typeOf(_x) == BBTypeOfFlag) then {
						_authorizedUID = _x getVariable ["AuthorizedUID", []];
						_authorizedPUID = _authorizedUID select 1;
						if ((getPlayerUid player) in _authorizedPUID && _x distance player <= _flagRadius && _x distance _object <= _flagRadius) then {
							_flagNearby = true;
							_okToBuild = true;
						} else {
							_flagNearby = false;
							_okToBuild = false;
						};
					};
					if (_okToBuild) exitWIth {};
					if (!_okToBuild && !_flagNearby) then {cutText [format["Build canceled for %1\nYou and the Object need to stay within %2 meters of your flag to build.",_text, _flagRadius], "PLAIN DOWN"];hint "";detach _object;deletevehicle _object;call _funcExitScript;};
				} foreach _allFlags;
			};
			//Check to make sure not building flag too near another base
			_flagNearest = nearestObjects [player, [BBTypeOfFlag], (_flagRadius * 2)];
			if (_classname == BBTypeOfFlag && (count _flagNearest > 1)) then {cutText [format["Only 1 flagpole per base in a %1 meter radius! Remember, this includes the other base's build radius as well.",(_flagRadius * 2)], "PLAIN DOWN"];hint "";detach _object;deletevehicle _object;call _funcExitScript;};
			
			// Cancel build if rules broken
			if ((!(isNull _dialog) || (speed player >= 12 || speed player <= -9) || _isInCombat > 0) && (isPlayer _playerCombat) ) then {
				detach _object;
				deletevehicle _object;
				cutText [format["Build canceled for %1. Player moving too fast, in combat, or opened gear.",_text], "PLAIN DOWN"];hint "";call _funcExitScript;
			};
		sleep 0.03;
	};
	
	//This section triggers when you select preview
	if (buildReady) then {
			_objectDir = getDir _object;
			detach _object;
			_objectPos = getPosATL _object;
			deletevehicle _object;
			_object = createVehicle [_classname, _objectPos, [], 0, "CAN_COLLIDE"];
			_object setDir _objectDir;
			if (_classname != "grave") then {
				_object setVariable ["characterID",dayz_characterID,true]; //Do this to prevent loot spawning during build process but not for bombs
			};
			buildReady=false;
			_location = _objectPos;//getposATL _object;
			_dir = _objectDir;//getDir _object;
			if (!(_allowedExtendedMode)) then {//Handle only non extendables
				_object setpos [(getposATL _object select 0),(getposATL _object select 1), if (typeOf(_object) == "Grave") then {-0.12}else{0}]; //Sets non extendables to follow land contours, tells graves to sink slightly into the ground
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
			cutText [format["AFTER RESTART: This is how the %1 object will look.\nYou can reposition the object, or complete the build.",_text], "PLAIN DOWN"];
			finishAction = player addAction ["Finish Build", "dayz_code\actions\buildActions\finishBuild.sqf", "", 6, true, true, "", ""];
			repositionAction = player addAction ["Reposition", "dayz_code\actions\buildActions\repositionObject.sqf", [_object,_objectPos,rotateDir], 6, true, true, "", ""];
			cancelAction = player addAction ["Cancel Build", "dayz_code\actions\buildActions\cancelBuild.sqf", [_object,_text], 6, true, true, "", ""];
			waitUntil {builderChooses}; //Let player decide if they want to reposition, or build as is.
				if (buildReposition || buildCancel) then {
				call _funcExitScript
				};
	} else {cutText [format["Build canceled for %1. Something went wrong!",_text], "PLAIN DOWN"];hint "";call _funcExitScript;};

	// Begin Building
	//Do quick check to see if player is not playing nice after placing object
	_locationPlayer = player modeltoworld [0,0,0];
	_onLadder 		=	(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
	_canDo 			= (!r_drag_sqf and !r_player_unconscious and !_onLadder); //USE!!
	_isWater 		= 	(surfaceIsWater _locationPlayer) or dayz_isSwimming;
	_inVehicle 		= (vehicle player != player);
	_isOk = [player,_building] call fnc_isInsideBuilding;
	if (!_inBuilding) then {
		if (_isOk) then {deletevehicle _object; cutText [format["%1 cannot be built inside of buildings!",_text], "PLAIN DOWN"];call _funcExitScript; };
	};
	// Did player walk object into restricted town?
	_closestTown = (nearestLocations [player,["NameCityCapital","NameCity","NameVillage"],25600]) select 0;
	_town_name = text _closestTown;
	_town_pos = position _closestTown;
	if (!_inTown) then {
		for "_i" from 0 to ((count allbuild_notowns) - 1) do
		{
			_check_town = (allbuild_notowns select _i) select _i - _i;
			if (_town_name == _check_town) then {
				_townRange = (allbuild_notowns select _i) select _i - _i + 1;
				if (_locationPlayer distance _town_pos <= _townRange ||  _object distance _town_pos <= _townRange) then {
					 deletevehicle _object; cutText [format["You cannot build %1 within %2 meters of area %3",_text, _townRange, _town_name], "PLAIN DOWN"];call _funcExitScript;
				};
				if (_classname == BBTypeOfFlag) then {
					if (_object distance _town_pos <= (_townRange + _flagRadius)) then {
						 deletevehicle _object; cutText [format["You cannot build %1 within %2 meters of area %3\nWhen building a %1, you must consider the %4 meter radius around the %1 conflicting with town radius of %5 meters",_text, (_townRange + _flagRadius), _town_name, _flagRadius, _townRange], "PLAIN DOWN"];call _funcExitScript;
					};
				};
			};
		};
	};

	r_interrupt = false;
	r_doLoop = true;
	_cntLoop = 0;
	//Physically begin building 
	switch (true) do
	{
		case(_longWait):
		{
			_cnt = _longWloop;
			_cnt = _cnt * 10;
			for "_i" from 0 to _longWloop do
			{
				cutText [format["Building %1.  %2 seconds left.\nMove from current position to cancel",_text,_cnt + 10], "PLAIN DOWN"];
				if (player distance _locationPlayer > 1) then {deletevehicle _object; cutText [format["Build canceled for %1, position of player moved",_text], "PLAIN DOWN"];hint "";call _funcExitScript;};
				if (!_canDo || _onLadder || _inVehicle || _isWater) then {deletevehicle _object; cutText [format["Build canceled for %1, player is unable to continue",_text], "PLAIN DOWN"];hint "";call _funcExitScript;};
				sleep 1;
				[player,"repair",0,false] call dayz_zombieSpeak;
				_id = [player,50,true,(getPosATL player)] spawn player_alertZombies;
				//DayZ interrupt feature like when canceling bandaging
				while {r_doLoop} do {
				player playActionNow "Medic"; //Moved here so the animation plays during the entire build process
					if (r_interrupt) then {
						r_doLoop = false;
					};
					if (_cntLoop >= 80) then {
						r_doLoop = false;
						_finished = true;
					};
					sleep .1;
					_cntLoop = _cntLoop + 1;
				};
				if (r_interrupt) then {
					deletevehicle _object; 
					[objNull, player, rSwitchMove,""] call RE;
					player playActionNow "stop";
					cutText [format["Build canceled for %1, position of player moved",_text], "PLAIN DOWN"];
					procBuild = false;//_playerCombat setVariable["startcombattimer", 1, true]; 
					breakOut "exit";
				};
				r_doLoop = true;
				_cntLoop = 0;
				_cnt = _cnt - 10;
			};
			sleep 1.5;
		};
		case(_medWait):
		{
			_cnt = _medWloop;
			_cnt = _cnt * 10;
			for "_i" from 0 to _medWloop do
			{
				cutText [format["Building %1.  %2 seconds left.\nMove from current position to cancel",_text,_cnt + 10], "PLAIN DOWN"];
				if (player distance _locationPlayer > 1) then {deletevehicle _object; cutText [format["Build canceled for %1, position of player moved",_text], "PLAIN DOWN"];hint "";call _funcExitScript;};
				if (!_canDo || _onLadder || _inVehicle || _isWater) then {deletevehicle _object; cutText [format["Build canceled for %1, player is unable to continue",_text], "PLAIN DOWN"];hint "";call _funcExitScript;};
				sleep 1;
				[player,"repair",0,false] call dayz_zombieSpeak;
				_id = [player,50,true,(getPosATL player)] spawn player_alertZombies;
				while {r_doLoop} do {
				player playActionNow "Medic"; //Moved here so the animation plays during the entire build process
					if (r_interrupt) then {
						r_doLoop = false;
					};
					if (_cntLoop >= 80) then {
						r_doLoop = false;
						_finished = true;
					};
					sleep .1;
					_cntLoop = _cntLoop + 1;
				};
				if (r_interrupt) then {
					deletevehicle _object; 
					[objNull, player, rSwitchMove,""] call RE;
					player playActionNow "stop";
					cutText [format["Build canceled for %1, position of player moved",_text], "PLAIN DOWN"];
					procBuild = false;//_playerCombat setVariable["startcombattimer", 1, true]; 
					breakOut "exit";
				};
				r_doLoop = true;
				_cntLoop = 0;
				_cnt = _cnt - 10;
			};
			sleep 1.5;
		};
		case(!_medWait && !_longWait):
		{
			_cnt = _smallWloop;
			_cnt = _cnt * 10;
			for "_i" from 0 to _smallWloop do
			{
				cutText [format["Building %1.  %2 seconds left.\nMove from current position to cancel",_text,_cnt + 10], "PLAIN DOWN"];
				if (player distance _locationPlayer > 1) then {deletevehicle _object; cutText [format["Build canceled for %1, position of player moved",_text], "PLAIN DOWN"];hint "";call _funcExitScript;};
				if (!_canDo || _onLadder || _inVehicle || _isWater) then {deletevehicle _object; cutText [format["Build canceled for %1, player is unable to continue",_text], "PLAIN DOWN"];hint "";call _funcExitScript;};
				sleep 1;
				[player,"repair",0,false] call dayz_zombieSpeak;
				_id = [player,50,true,(getPosATL player)] spawn player_alertZombies;
				while {r_doLoop} do {
				player playActionNow "Medic"; //Moved here so the animation plays during the entire build process
					if (r_interrupt) then {
						r_doLoop = false;
					};
					if (_cntLoop >= 80) then {
						r_doLoop = false;
						_finished = true;
					};
					sleep .1;
					_cntLoop = _cntLoop + 1;
				};
				if (r_interrupt) then {
					deletevehicle _object; 
					[objNull, player, rSwitchMove,""] call RE;
					player playActionNow "stop";
					cutText [format["Build canceled for %1, position of player moved",_text], "PLAIN DOWN"];
					procBuild = false;//_playerCombat setVariable["startcombattimer", 1, true]; 
					breakOut "exit";
				};
				r_doLoop = true;
				_cntLoop = 0;
				_cnt = _cnt - 10;
			};
			sleep 1.5;
		};
	};
	
	// Do last check to see if player attempted to remove buildables
	_mags = magazines player;
	_buildables = []; // reset original buildables
		if ("ItemTankTrap" in _mags) then {
			_qtyT = {_x == "ItemTankTrap"} count magazines player;
			_buildables set [count _buildables, _qtyT]; 
		} else { _qtyT = 0; _buildables set [count _buildables, _qtyT]; };
			
		if ("ItemSandbag" in _mags) then {
			_qtyS = {_x == "ItemSandbag"} count magazines player;
			_buildables set [count _buildables, _qtyS]; 
		} else { _qtyS = 0; _buildables set [count _buildables, _qtyS]; };
		
		if ("ItemWire" in _mags) then {
			_qtyW = {_x == "ItemWire"} count magazines player;
			_buildables set [count _buildables, _qtyW]; 
			} else { _qtyW = 0; _buildables set [count _buildables, _qtyW]; };
			
		if ("PartWoodPile" in _mags) then {
			_qtyL = {_x == "PartWoodPile"} count magazines player;
			_buildables set [count _buildables, _qtyL]; 
		} else { _qtyL = 0; _buildables set [count _buildables, _qtyL]; };
		
		if ("PartGeneric" in _mags) then {
			_qtyM = {_x == "PartGeneric"} count magazines player;
			_buildables set [count _buildables, _qtyM]; 
		} else { _qtyM = 0; _buildables set [count _buildables, _qtyM]; };
		
		if ("HandGrenade_West" in _mags) then {
			_qtyG = {_x == "HandGrenade_West"} count magazines player;
			_buildables set [count _buildables, _qtyG]; 
		} else { _qtyG = 0; _buildables set [count _buildables, _qtyG]; };

		if ("equip_scrapelectronics" in _mags) then {
			_qtyE = {_x == "equip_scrapelectronics"} count magazines player;
			_buildables set [count _buildables, _qtyE]; 
		} else { _qtyE = 0; _buildables set [count _buildables, _qtyE]; };
		
		if ("equip_crate" in _mags) then {
			_qtyCr = {_x == "equip_crate"} count magazines player;
			_buildables set [count _buildables, _qtyCr]; 
		} else { _qtyCr = 0; _buildables set [count _buildables, _qtyCr]; };
		
		if ("ItemCamoNet" in _mags) then {
			_qtyC = {_x == "ItemCamoNet"} count magazines player;
			_buildables set [count _buildables, _qtyC]; 
		} else { _qtyC = 0; _buildables set [count _buildables, _qtyC]; };

		if ("equip_brick" in _mags) then {
			_qtyB = {_x == "equip_brick"} count magazines player;
			_buildables set [count _buildables, _qtyB]; 
		} else { _qtyB = 0; _buildables set [count _buildables, _qtyB]; };
		
		if ("equip_string" in _mags) then {
			_qtySt = {_x == "equip_string"} count magazines player;
			_buildables set [count _buildables, _qtySt]; 
		} else { _qtySt = 0; _buildables set [count _buildables, _qtySt]; };
		
		if ("equip_duct_tape" in _mags) then {
			_qtyDT = {_x == "equip_duct_tape"} count magazines player;
			_buildables set [count _buildables, _qtyDT]; 
		} else { _qtyDT = 0; _buildables set [count _buildables, _qtyDT]; };
		
	// Check if it matches again
	disableUserInput true;
	cutText ["Keyboard disabled while confirm recipes\n -Anti-Dupe", "PLAIN DOWN"];
	_result = [_buildables,_chosenRecipe] call BIS_fnc_areEqual;
	if (_result) then {
	//Build final product!

		//Finish last requirement checks, _isSimulated disables objects physics if specified, _isDestructable checks if object needs to be invincible
		if (!_isSimulated) then {
			_object enablesimulation false;
		};
		if (!_isDestructable) then {
			_object addEventHandler ["HandleDamage", {false}];
		};
		

	// set the codes for gate
	//--------------------------------

		// New Method
		_uidDir = _dir;
		_uidDir = round(_uidDir);
		_uid = "";
		{
			_x = _x * 10;
			if ( _x < 0 ) then { _x = _x * -10 };
			_uid = _uid + str(round(_x));
		} forEach _location;
		_uid = _uid + str(round(_dir));

	//--------------------------------

		switch (_classname) do
		{
			case "Grave":
			{
				_object setVariable ["isBomb", 1, true];//this will be known as a bomb instead of checking with classnames in player_bomb
				cutText [format["You have constructed a %1\nIt will only set off for enemies, add friendly playerUIDs so it will not trigger for them",_text], "PLAIN DOWN"];	
			};
			case "Infostand_2_EP1":
			{
				cutText [format["You have constructed a %1\nBuild one outside as well. Look at Object to give base owners access as well!",_text,_uid], "PLAIN DOWN"];
			};
			case BBTypeOfFlag:
			{
				cutText [format["You have constructed a %1\nYou can now build within a %2 meter radius around this area, add friends playerUIDs to allow them to build too.",_text,_flagRadius], "PLAIN DOWN"];
			};
			default {
				cutText [format["You have constructed a %1",_text,_uid], "PLAIN DOWN"];
				//cutText [format[localize "str_build_01",_text], "PLAIN DOWN"];
			};
		};
		//Remove required magazines
		if (_qtyT > 0) then {
			for "_i" from 0 to _qtyT do
			{
				player removeMagazine _itemT;
			};
		};
		if (_qtyS > 0) then {
			for "_i" from 0 to _qtyS do
			{
				player removeMagazine _itemS;
			};
		};
		if (_qtyW > 0) then {
			for "_i" from 0 to _qtyW do
			{
				player removeMagazine _itemW;
			};
		};
		if (_qtyL > 0) then {
			for "_i" from 0 to _qtyL do
			{
				player removeMagazine _itemL;
			};
		};
		if (_qtyM > 0) then {
			for "_i" from 0 to _qtyM do
			{
				player removeMagazine _itemM;
			};
		};
		if (_qtyE > 0) then {
			for "_i" from 0 to _qtyE do
			{
				player removeMagazine _itemE;
			};
		};
		if (_qtyCr > 0) then {
			for "_i" from 0 to _qtyCr do
			{
				player removeMagazine _itemCR;
			};
		};
		if (_qtyC > 0) then {
			for "_i" from 0 to _qtyC do
			{
				player removeMagazine _itemC;
			};
		};
		if (_qtyB > 0) then {
			for "_i" from 0 to _qtyB do
			{
				player removeMagazine _itemB;
			};
		};
		
		if (_qtySt > 0) then {
			for "_i" from 0 to _qtySt do
			{
				player removeMagazine _itemSt;
			};
		};
		
		if (_qtyDT > 0) then {
			for "_i" from 0 to _qtyDT do
			{
				player removeMagazine _itemDt;
			};
		};
		
		//Grenade only is needed when building booby trap
		if (_qtyG > 0 && _classname == "Grave") then {
			for "_i" from 0 to _qtyG do
			{
				player removeMagazine _itemG;
			};
		};
	sleep 0.5; //Give it time to remove items
	disableUserInput false; //Allow gear access now items have been removed
	_playerUID = [];
	_playerUID set [count _playerUID, (getPlayerUID player)];
	_object setVariable ["AuthorizedUID", _playerUID , true];
	_object setVariable ["characterID",dayz_characterID,true];
	//dayzPublishObj = [dayz_characterID,_object,[_dir,_location],_classname];
	PVDZ_obj_Publish = [dayz_characterID,_object,[_dir,_location],_classname,_playerUID];
	publicVariableServer "PVDZ_obj_Publish";
		if (isServer) then {
			PVDZ_obj_Publish call server_publishObj;
		};
	} else {
	detach _object;
	deletevehicle _object; 
	cutText ["You need the EXACT amount of whatever you are trying to build without extras.", "PLAIN DOWN"];call _funcExitScript;};
	
	player allowdamage true;
	procBuild = false;//_playerCombat setVariable["startcombattimer", 1, true];

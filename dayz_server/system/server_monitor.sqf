private ["_date","_year","_month","_day","_hour","_minute","_date1","_hiveResponse","_key","_objectCount","_dir","_point","_i","_action","_dam","_selection","_wantExplosiveParts","_entity","_worldspace","_damage","_booleans","_rawData","_ObjectID","_class","_CharacterID","_inventory","_hitpoints","_fuel","_id","_objectArray","_script","_result","_outcome"];
[]execVM "\z\addons\dayz_server\system\s_fps.sqf"; //server monitor FPS (writes each ~181s diag_fps+181s diag_fpsmin*)
#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

dayz_versionNo = 		getText(configFile >> "CfgMods" >> "DayZ" >> "version");
dayz_hiveVersionNo = 	getNumber(configFile >> "CfgMods" >> "DayZ" >> "hiveVersion");

waitUntil{initialized}; //means all the functions are now defined
//####----####----####---- Base Building 1.3 Start ----####----####----####
call build_baseBuilding_arrays; // build BB 1.2 arrays
//####----####----####---- Base Building 1.3 End ----####----####----####

diag_log "HIVE: Starting";

//Set the Time
	//Send request
	_key = "CHILD:307:";
	_result = _key call server_hiveReadWrite;
	_outcome = _result select 0;
	if(_outcome == "PASS") then {
		_date = _result select 1;

		//date setup
		_year = _date select 0;
		_month = _date select 1;
		_day = _date select 2;
		_hour = _date select 3;
		_minute = _date select 4;

		//Force full moon nights
		_date1 = [2013,8,3,_hour,_minute];

		if(isDedicated) then {
			//["dayzSetDate",_date] call broadcastRpcCallAll;
			setDate _date1;
			dayzSetDate = _date1;
			dayz_storeTimeDate = _date1;
			publicVariable "dayzSetDate";
		};
		diag_log ("HIVE: Local Time set to " + str(_date1));
	};

waituntil{isNil "sm_done"}; // prevent server_monitor be called twice (bug during login of the first player)

if (isServer and isNil "sm_done") then {
	
	//Stream in objects
	/* STREAM OBJECTS */
		//Send the key
		_key = format["CHILD:302:%1:",dayZ_instance];
		_result = _key call server_hiveReadWrite;

		diag_log "HIVE: Request sent";

		//Process result
		_status = _result select 0;

		_myArray = [];
		if (_status == "ObjectStreamStart") then {
			_val = _result select 1;
			//Stream Objects
			diag_log ("HIVE: Commence Object Streaming...");
			for "_i" from 1 to _val do {
				_result = _key call server_hiveReadWrite;

				_status = _result select 0;
				_myArray set [count _myArray,_result];
				//diag_log ("HIVE: Loop ");
			};
			diag_log ("HIVE: Streamed " + str(_val) + " objects");
		};

		_countr = 0;		
		{

			//Parse Array
			_countr = _countr + 1;
			
			_action = 		_x select 0; 
			_idKey = 		_x select 1;
			_type =			if ((typeName (_x select 2)) == "STRING") then { _x select 2 };
			_ownerID = 		_x select 3;
			_worldspace = 	if ((typeName (_x select 4)) == "ARRAY") then { _x select 4 } else { [] };
			_inventory =	if ((typeName (_x select 5)) == "ARRAY") then { _x select 5 } else { [] };
			_hitPoints =	if ((typeName (_x select 6)) == "ARRAY") then { _x select 6 } else { [] };
			_fuel =			if ((typeName (_x select 7)) == "SCALAR") then { _x select 7 } else { 0 };
			_damage = 		if ((typeName (_x select 8)) == "SCALAR") then { _x select 8 } else { 0.9 };
			
			_dir = floor(random(360));
			_pos = getMarkerpos "respawn_west";	
			_wsDone = false;
			
			if (count _worldspace >= 1 && {(typeName (_worldspace select 0)) == "SCALAR"}) then { 
				_dir = _worldspace select 0;
			};
			if (count _worldspace == 2 && {(typeName (_worldspace select 1)) == "ARRAY"}) then { 
				_i = _worldspace select 1;
				if (count _i == 3 &&
					{(typeName (_i select 0)) == "SCALAR"} && 
					{(typeName (_i select 1)) == "SCALAR"} &&
					{(typeName (_i select 2)) == "SCALAR"}) then {
					_pos = _i;
					_wsDone = true;					
				};
			};
			if (!_wsDone) then {
				_pos = [getMarkerPos "center",0,30,10,0,2000,0] call BIS_fnc_findSafePos;
				if (count _pos < 3) then { _pos = [_pos select 0,_pos select 1,0]; };
				diag_log ("MOVED OBJ: " + str(_idKey) + " of class " + _type + " to pos: " + str(_pos));
			};

                if (_damage < 1) then {
                //diag_log format["OBJ: %1 - %2,%3,%4,%5,%6,%7,%8", _idKey,_type,_ownerID,_worldspace,_inventory,_hitPoints,_fuel,_damage];
           
                dayz_nonCollide = ["DomeTentStorage","TentStorage","CamoNet_DZ"];
           
                //Create it
                _object = createVehicle [_type, _pos, [], 0, if (_type in dayz_nonCollide) then {"NONE"} else {"CAN_COLLIDE"}];
                _object setVariable ["lastUpdate",time];
                // Don't set objects for deployables to ensure proper inventory updates
                if (_ownerID == "0") then {
                    _object setVariable ["ObjectID", str(_idKey), true];
                } else {
                    _object setVariable ["ObjectUID", _worldspace call dayz_objectUID2, true];
                };
                _object setVariable ["CharacterID", _ownerID, true];
				_object setdir _dir;
				_object setDamage _damage;
				
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
				_object setVariable ["AuthorizedUID", _inventory, true]; //Sets the AuthorizedUID for build objects
				_object setVariable ["ObjectUID", ((_inventory select 0) select 0), true]; //Sets Object UID using array value
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

				//Dont add inventory for traps.
				if (!(_object isKindOf "TrapItems") && !(typeOf(_object) in allbuildables_class) && !(typeOf(_object) in BBAllFlagTypes) && !(typeOf(_object) in BBAllZShieldTypes)) then {//##Base Building 1.3 correction added exception to ignore base building items since we store UIDs in Inventory
					_cargo = _inventory;
					clearWeaponCargoGlobal  _object;
					clearMagazineCargoGlobal  _object;
					clearBackpackCargoGlobal  _object;	 
					_config = ["CfgWeapons", "CfgMagazines", "CfgVehicles" ];
					{
						_magItemTypes = _x select 0;
						_magItemQtys = _x select 1;
						_i = _forEachIndex;
						{    
							if (_x == "Crossbow") then { _x = "Crossbow_DZ" }; // Convert Crossbow to Crossbow_DZ
							if (_x == "BoltSteel") then { _x = "WoodenArrow" }; // Convert BoltSteel to WoodenArrow
							// Convert to DayZ Weapons
							if (_x == "DMR") then { _x = "DMR_DZ" };
							//if (_x == "M14_EP1") then { _x = "M14_DZ" };
							if (_x == "SVD") then { _x = "SVD_DZ" }; 
							if (_x == "SVD_CAMO") then { _x = "SVD_CAMO_DZ" };
							if (isClass(configFile >> (_config select _i) >> _x) &&
								getNumber(configFile >> (_config select _i) >> _x >> "stopThis") != 1) then {
								if (_forEachIndex < count _magItemQtys) then {
									switch (_i) do {
										case 0: { _object addWeaponCargoGlobal [_x,(_magItemQtys select _forEachIndex)]; }; 
										case 1: { _object addMagazineCargoGlobal [_x,(_magItemQtys select _forEachIndex)]; }; 
										case 2: { _object addBackpackCargoGlobal [_x,(_magItemQtys select _forEachIndex)]; }; 
									};
								};
							};
						} forEach _magItemTypes;
					} forEach _cargo;
				};
				
				if (_object isKindOf "AllVehicles") then {
					{
						_selection = _x select 0;
						_dam = _x select 1;
						if (_selection in dayZ_explosiveParts and _dam > 0.8) then {_dam = 0.8};

						[_object,_selection,_dam] call fnc_veh_setFixServer;
					} forEach _hitpoints;
					_object setvelocity [0,0,1];
					_object setFuel _fuel;
					_object call fnc_veh_ResetEH;
				} else { 
					if (_type in SafeObjects) then {
						if (_object isKindOf "TentStorage" || _object isKindOf "CamoNet_DZ" || _object isKindOf "Land_A_tent") then {
							//_booleans=[];
							//_pos = [_type, _pos, _booleans] call fn_niceSpot;
							_pos set [2,0];
							_object setPosATL _pos;
							_object addMPEventHandler ["MPKilled",{_this call vehicle_handleServerKilled;}];
						};
						
						if (_object isKindOf "TrapItems") then {
							_object setVariable ["armed", _inventory select 0, false];
						};
					} else {
						_damage = 1;
						_object setDamage _damage;
						diag_log format["OBJ: %1 - %2 REMOVED", _object,_damage];
					};
					
				};
				
				//Monitor the object
				//_object enableSimulation false;
				dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_object];
			};
			sleep 0.01;
		} forEach _myArray;

	// # END OF STREAMING #

	createCenter civilian;
	if (isDedicated) then {
		endLoadingScreen;
	};

	if (isDedicated) then {
		_id = [] execFSM "\z\addons\dayz_server\system\server_cleanup.fsm";
	};

	allowConnection = true;
	
	// antiwallhack
	call compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\fa_antiwallhack.sqf";
	
	sm_done = true;
	publicVariable "sm_done";
	
	dayz_Crashspawner = [] spawn {
		// [_guaranteedLoot, _randomizedLoot, spawnOnStart, _frequency, _variance, _spawnChance, _spawnMarker, _spawnRadius, _spawnFire, _fadeFire]
		[3, 4, 3, (40 * 60), (15 * 60), 0.75, 'center', 4000, true, false] call server_spawnCrashSite;
	};
	
	//Spawn camps
	dayz_Campspawner = [] spawn {
		// quantity, marker, radius, min distance between 2 camps
		Server_InfectedCamps = [3, "center", 4500, 2000] call fn_bases;
		dayzInfectedCamps = Server_InfectedCamps;
		publicVariable "dayzInfectedCamps";
	};
	
	dayz_Plantspawner = [] spawn {
		[300] call server_plantSpawner;
	};

	//if (isDedicated) then {
	//Wild Zeds Ownership isnt working as expected yet
	//	execFSM "\z\addons\dayz_server\system\zombie_wildagent.fsm";
	//};
	
	// Trap loop
	[] spawn {
		private ["_array","_array2","_array3","_script","_armed"];
		_array = str dayz_traps;
		_array2 = str dayz_traps_active;
		_array3 = str dayz_traps_trigger;

		while { true } do {
			if ((str dayz_traps != _array) || (str dayz_traps_active != _array2) || (str dayz_traps_trigger != _array3)) then {
				_array = str dayz_traps;
				_array2 = str dayz_traps_active;
				_array3 = str dayz_traps_trigger;

				diag_log "DEBUG: traps";
				diag_log format["dayz_traps (%2) -> %1", dayz_traps, count dayz_traps];
				diag_log format["dayz_traps_active (%2) -> %1", dayz_traps_active, count dayz_traps_active];
				diag_log format["dayz_traps_trigger (%2) -> %1", dayz_traps_trigger, count dayz_traps_trigger];
				diag_log "DEBUG: end traps";
			};

			{
				if (isNull _x) then {
					dayz_traps = dayz_traps - [_x];
				};

				_script = call compile getText (configFile >> "CfgVehicles" >> typeOf _x >> "script");
				_armed = _x getVariable ["armed", false];

				if (_armed) then {
					if !(_x in dayz_traps_active) then {
						["arm", _x] call _script;
					};
				} else {
					if (_x in dayz_traps_active) then {
						["disarm", _x] call _script;
					};
				};

				//sleep 0.01;
			} forEach dayz_traps;
		};
	};
};
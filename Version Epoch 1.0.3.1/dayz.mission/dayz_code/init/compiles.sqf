
//Custom Self Actions File
	fnc_usec_selfActions 				= compile preprocessFileLineNumbers "dayz_code\compile\fn_selfActions.sqf";

//Base Building 1.3 Specific Compiles
	//player_build						= compile preprocessFileLineNumbers "dayz_code\actions\player_build.sqf";
	player_build2 						= compile preprocessFileLineNumbers "dayz_code\compile\player_build2.sqf";
	antiWall 							= compile preprocessFileLineNumbers "dayz_code\compile\antiWall.sqf";
	anti_discWall 						= compile preprocessFileLineNumbers "dayz_code\compile\anti_discWall.sqf";
	refresh_build_recipe_dialog 		= compile preprocessFileLineNumbers "buildRecipeBook\refresh_build_recipe_dialog.sqf";
	refresh_build_recipe_list_dialog 	= compile preprocessFileLineNumbers "buildRecipeBook\refresh_build_recipe_list_dialog.sqf";
	add_UIDCode  						= compile preprocessFileLineNumbers "dayz_code\external\keypad\fnc_keyPad\functions\add_UIDCode.sqf";
	remove_UIDCode  					= compile preprocessFileLineNumbers "dayz_code\external\keypad\fnc_keyPad\functions\remove_UIDCode.sqf";
//To Disable Loot and or Zombie Spawns in Base Build Objects
	//player_spawnCheck = compile preprocessFileLineNumbers "dayz_code\compile\player_spawnCheck.sqf";
	
//Keybinds
	dayz_spaceInterrupt = {
		private ["_dikCode", "_handled"];
		_dikCode = 	_this select 1;
		_handled = false;
		if (_dikCode in[0x58,0x57,0x44,0x43,0x42,0x41,0x40,0x3F,0x3E,0x3D,0x3C,0x3B,0x0B,0x0A,0x09,0x08,0x07,0x06,0x05]) then {
			_handled = true;
		};
		if (_dikCode in actionKeys "MoveForward") exitWith {r_interrupt = true};
		if (_dikCode in actionKeys "MoveLeft") exitWith {r_interrupt = true};
		if (_dikCode in actionKeys "MoveRight") exitWith {r_interrupt = true};
		if (_dikCode in actionKeys "MoveBack") exitWith {r_interrupt = true};
		//Prevent exploit of drag body
		if ((_dikCode in actionKeys "Prone") and r_drag_sqf) exitWith { force_dropBody = true; };
		if ((_dikCode in actionKeys "Crouch") and r_drag_sqf) exitWith { force_dropBody = true; };
		_shift = 	_this select 2;
		_ctrl = 	_this select 3;
		_alt =		_this select 4;
		//diag_log format["Keypress: %1", _this];
		if (_dikCode in (actionKeys "GetOver")) then {
			
			if (player isKindOf  "PZombie_VB") then {
				_handled = true;
				DZE_PZATTACK = true;
			} else {
				_nearbyObjects = nearestObjects[getPosATL player, dayz_disallowedVault, 8];
				if (count _nearbyObjects > 0) then {
					if((diag_tickTime - dayz_lastCheckBit > 4)) then {
						[objNull, player, rSwitchMove,"GetOver"] call RE;
						player playActionNow "GetOver";
						dayz_lastCheckBit = diag_tickTime;
					} else {
						_handled = true;
					};
				};
			};
		};
		//if (_dikCode == 57) then {_handled = true}; // space
		//if (_dikCode in actionKeys 'MoveForward' or _dikCode in actionKeys 'MoveBack') then {r_interrupt = true};
		if (_dikCode == 210) then {
				_nill = execvm "\z\addons\dayz_code\actions\playerstats.sqf";
		};
		if (_dikCode in actionKeys "ForceCommandingMode") then {_handled = true};
		if (_dikCode in actionKeys "PushToTalk" and (diag_tickTime - dayz_lastCheckBit > 10)) then {
			dayz_lastCheckBit = diag_tickTime;
			[player,50,true,(getPosATL player)] spawn player_alertZombies;
		};
		if (_dikCode in actionKeys "VoiceOverNet" and (diag_tickTime - dayz_lastCheckBit > 10)) then {
			dayz_lastCheckBit = diag_tickTime;
			[player,50,true,(getPosATL player)] spawn player_alertZombies;
		};
		if (_dikCode in actionKeys "PushToTalkDirect" and (diag_tickTime - dayz_lastCheckBit > 10)) then {
			dayz_lastCheckBit = diag_tickTime;
			[player,15,false,(getPosATL player)] spawn player_alertZombies;
		};
		if (_dikCode in actionKeys "Chat" and (diag_tickTime - dayz_lastCheckBit > 10)) then {
			dayz_lastCheckBit = diag_tickTime;
			[player,15,false,(getPosATL player)] spawn player_alertZombies;
		};
		if (_dikCode in actionKeys "User20" and (diag_tickTime - dayz_lastCheckBit > 5)) then {
			dayz_lastCheckBit = diag_tickTime;
			_nill = execvm "\z\addons\dayz_code\actions\playerstats.sqf";
		};
		// numpad 8 0x48 now pgup 0xC9 1
		if ((_dikCode == 0xC9 and (!_alt or !_ctrl)) or (_dikCode in actionKeys "User15")) then {
			DZE_Q = true;
		};
		// numpad 2 0x50 now pgdn 0xD1
		if ((_dikCode == 0xD1 and (!_alt or !_ctrl)) or (_dikCode in actionKeys "User16")) then {
			DZE_Z = true;
		};
		// numpad 8 0x48 now pgup 0xC9 0.1
		if ((_dikCode == 0xC9 and (_alt and !_ctrl)) or (_dikCode in actionKeys "User13")) then {
			DZE_Q_alt = true;
		};
		// numpad 2 0x50 now pgdn 0xD1
		if ((_dikCode == 0xD1 and (_alt and !_ctrl)) or (_dikCode in actionKeys "User14")) then {
			DZE_Z_alt = true;
		};
		// numpad 8 0x48 now pgup 0xC9 0.01
		if ((_dikCode == 0xC9 and (!_alt and _ctrl)) or (_dikCode in actionKeys "User7")) then {
			DZE_Q_ctrl = true;
		};
		// numpad 2 0x50 now pgdn 0xD1
		if ((_dikCode == 0xD1 and (!_alt and _ctrl)) or (_dikCode in actionKeys "User8")) then {
			DZE_Z_ctrl = true;
		};
		// numpad 4 0x4B now Q 0x10
		if (_dikCode == 0x10 or (_dikCode in actionKeys "User17")) then {
			DZE_4 = true;
		};		
		// numpad 6 0x4D now E 0x12
		if (_dikCode == 0x12 or (_dikCode in actionKeys "User18")) then {
			DZE_6 = true;
		};
		// numpad 5 0x4C now space 0x39
		if (_dikCode == 0x39 or (_dikCode in actionKeys "User19")) then {
			DZE_5 = true;
		};
		// esc
		if (_dikCode == 0x01) then {
			DZE_cancelBuilding = true;
		};
		if ((_dikCode == 0x3E or _dikCode == 0x0F or _dikCode == 0xD3) and (diag_tickTime - dayz_lastCheckBit > 10)) then {
			dayz_lastCheckBit = diag_tickTime;
			call dayz_forceSave;
		};
		/*
		if (_dikCode in actionKeys "IngamePause") then {
			_idOnPause = [] spawn dayz_onPause;
		};
		*/
	//Keybinds for Base Building
		_shiftState = _this select 2;
		//Elevate NumPad 8
		if ((_dikCode == 0x48) && !_shiftState) then {
			DZ_BB_E = true;
			_handled = true;
		};
		//Lower NumPad 5
		if ((_dikCode == 0x4C) && !_shiftState) then {
			DZ_BB_L = true;
			_handled = true;
		};
		//Elevate Small shift + NumPad 8
		if (_dikCode == 0x48) then {
			DZ_BB_Es = true;
			_handled = true;
		};
		//Lower Small shift + NumPad 5
		if (_dikCode == 0x4C) then {
			DZ_BB_Ls = true;
			_handled = true;
		};
		//Rotate Left NumPad 7
		if ((_dikCode == 0x47) && !_shiftState) then {
			DZ_BB_Rl = true;
			_handled = true;
		};
		//Rotate Right NumPad 9
		if ((_dikCode == 0x49) && !_shiftState) then {
			DZ_BB_Rr = true;
			_handled = true;
		};
		//Rotate Left Small Shift + NumPad 7
		if (_dikCode == 0x47) then {
			DZ_BB_Rls = true;
			_handled = true;
		};
		//Rotate Right Small Shift + NumPad 9
		if (_dikCode == 0x49) then {
			DZ_BB_Rrs = true;
			_handled = true;
		};
		//Push Away NumPad 4
		if (_dikCode == 0x4B) then {
			DZ_BB_A = true;
			_handled = true;
		};
		//Pull Near NumPad 1
		if (_dikCode == 0x4F) then {
			DZ_BB_N = true;
			_handled = true;
		};
		//Move Left NumPad 2
		if (_dikCode == 0x50) then {
			DZ_BB_Le = true;
			_handled = true;
		};
		//Move Right NumPad 3
		if (_dikCode == 0x51) then {
			DZ_BB_Ri = true;
			_handled = true;
		};
		_handled
	};
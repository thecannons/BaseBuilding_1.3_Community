
//Custom Self Actions File
	fnc_usec_selfActions 				= compile preprocessFileLineNumbers "dayz_code\compile\fn_selfActions.sqf";

//Base Building 1.3 Specific Compiles
	player_build 						= compile preprocessFileLineNumbers "dayz_code\actions\player_build.sqf";
	player_build2 						= compile preprocessFileLineNumbers "dayz_code\compile\player_build2.sqf";
	antiWall 							= compile preprocessFileLineNumbers "dayz_code\compile\antiWall.sqf";
	anti_discWall 						= compile preprocessFileLineNumbers "dayz_code\compile\anti_discWall.sqf";
	refresh_build_recipe_dialog 		= compile preprocessFileLineNumbers "buildRecipeBook\refresh_build_recipe_dialog.sqf";
	refresh_build_recipe_list_dialog 	= compile preprocessFileLineNumbers "buildRecipeBook\refresh_build_recipe_list_dialog.sqf";
	add_UIDCode  						= compile preprocessFileLineNumbers "dayz_code\external\keypad\fnc_keyPad\functions\add_UIDCode.sqf";
	remove_UIDCode  					= compile preprocessFileLineNumbers "dayz_code\external\keypad\fnc_keyPad\functions\remove_UIDCode.sqf";
//To Disable Loot and or Zombie Spawns in Base Build Objects
	//player_spawnCheck = compile preprocessFileLineNumbers "dayz_code\compile\player_spawnCheck.sqf";

//Testing Key Binds for Placement
	dayz_spaceInterrupt = {
		private "_handled";
		_dikCode = _this select 1;
		_shiftState = _this select 2;
		_ctrlState = _this select 3;
		_altState = _this select 4;
		_handled = false;

		// Disable ESC after death (not sure if needed but it's here to make sure)
		if (_dikCode == 0x01 && r_player_dead) then {
			_handled = true;
		};

		switch (_dikCode) do {
			case 0x02: {
				["rifle"] spawn player_switchWeapon;
				_handled = true;
			};
			case 0x03: {
				["pistol"] spawn player_switchWeapon;
				_handled = true;
			};
			case 0x04: {
				["melee"] spawn player_switchWeapon;
				_handled = true;
			};
			default {
				if (_dikCode in [0x58,0x57,0x44,0x43,0x42,0x41,0x40,0x3F,0x3E,0x3D,0x3C,0x3B,0x0B,0x0A,0x09,0x08,0x07,0x06,0x05]) then {
					_handled = true;
				};
			};
		};

		if ((_dikCode in actionKeys "Gear") and (vehicle player != player) and !_shiftState and !_ctrlState and !_altState && !dialog) then {
			createGearDialog [player, "RscDisplayGear"];
			_handled = true;
		};

		//if (_dikCode in actionKeys 'MoveForward' or _dikCode in actionKeys 'MoveBack') then {r_interrupt = true};
		//Prevent exploit of drag body
		if ((_dikCode in actionKeys "Prone") and r_drag_sqf) then { force_dropBody = true; };
		if ((_dikCode in actionKeys "Crouch") and r_drag_sqf) then { force_dropBody = true; };

		if (_dikCode in actionKeys "MoveLeft") then {r_interrupt = true};
		if (_dikCode in actionKeys "MoveRight") then {r_interrupt = true};
		if (_dikCode in actionKeys "MoveForward") then {r_interrupt = true};
		if (_dikCode in actionKeys "MoveBack") then {r_interrupt = true};
		if (_dikCode in actionKeys "ForceCommandingMode") then {_handled = true};
		if (_dikCode in actionKeys "PushToTalk" and (time - dayz_lastCheckBit > 10)) then {
			dayz_lastCheckBit = time;
			[player,15,true,(getPosATL player)] call player_alertZombies;
		};
		if (_dikCode in actionKeys "VoiceOverNet" and (time - dayz_lastCheckBit > 10)) then {
			dayz_lastCheckBit = time;
			[player,15,true,(getPosATL player)] call player_alertZombies;
		};
		if (_dikCode in actionKeys "PushToTalkDirect" and (time - dayz_lastCheckBit > 10)) then {
			dayz_lastCheckBit = time;
			[player,5,false,(getPosATL player)] call player_alertZombies;
		};
		if (_dikCode in actionKeys "Chat" and (time - dayz_lastCheckBit > 10)) then {
			dayz_lastCheckBit = time;
			[player,15,false,(getPosATL player)] call player_alertZombies;
		};
		if (_dikCode in actionKeys "User20" or _dikCode in actionKeys "NetworkStats") then {
			if (!dayz_isSwimming and !dialog) then {
				[player,4,true,(getPosATL player)] call player_alertZombies;
				createDialog "horde_journal_front_cover";
			};
			_handled = true;
		};
		if ((_dikCode in [0x3E,0x0F,0xD3]) and (time - dayz_lastCheckBit > 10)) then {
			dayz_lastCheckBit = time;
			call player_forceSave;
		};
		if (_dikCode in [0xB8,0x38,0x3E,0x2A,0x36,0x01]) then {
			_displayg = findDisplay 106;
			if (!isNull _displayg) then {
			call player_forceSave;
			} else {
				if (dialog) then {
					call player_forceSave;
				};
			};
		};
		_object = player getVariable ["constructionObject", objNull];
		if (!isNull _object and _dikCode in actionKeys "LeanLeft") then {
			_dir = getDir _object - 3;
			_object setDir _dir;
			_handled = true;
		};
		if (!isNull _object and _dikCode in actionKeys "LeanRight") then {
			_dir = getDir _object + 3;
			_object setDir _dir;
			_handled = true;
		};
	//Key Binds for Base Building
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
		//Debug Keybind
		if (_dikCode == 0x44) then {
        if (debugMonitor) then {
            debugMonitor = false;
            hintSilent "";
        } else {[] spawn fnc_debug;};
		};
		_handled
	};
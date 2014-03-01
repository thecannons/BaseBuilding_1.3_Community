//This script is used to toggle Base Building 1.3 zombie shield on/off

private ["_id","_shieldGen","_doZombieShield","_generator","_getNearestBaseFlag","_nearestFlag","_nearestGenerator","_shieldRadius","_doShield","_zombieFreaks","_zombieFreak","_count","_shieldGenStatus"];
_id = _this select 2;
_shieldGen = _this select 3 select 0;
_doZombieShield = _this select 3 select 1;
_shieldGen removeAction _id;
//_shieldGen = "CDF_WarfareBUAVterminal";
_generator = "PowerGenerator_EP1";
_getNearestBaseFlag = nearestObjects [_shieldGen, [BBTypeOfFlag], BBFlagRadius];//Find nearest flag
_nearestFlag = _getNearestBaseFlag select 0;
_nearestGenerator = nearestObjects [_nearestFlag, [_generator], BBFlagRadius]; //Make sure a generator is within the flag radius
_shieldRadius = BBZShieldRadius;

_func_bb_zombie_shield = {
//diag_log ["Stage 4 here"];
	if (_doShield) then {
		//diag_log ["Stage 5 here"];
		_shieldGen = _this select 0;
		_shieldGen setVariable ["bbZombieShield", "true", true];
		[nil,_shieldGen,rSAY,["engine_12s", _shieldRadius]] call RE;
		while {(_shieldGen getVariable ["bbZombieShield","false"]) == "true"} do {
			//diag_log ["Stage 6 here"];
			//_staticSounds = ["PMC_ElectricBlast1","PMC_ElectricBlast2"] call BIS_fnc_selectRandom;
			//[nil,_shieldGen,rSAY,[_staticSounds,_shieldRadius]] call RE;
			_zombieFreaks = (position _shieldGen) nearEntities ["zZombie_Base", _shieldRadius];
			_count = count _zombieFreaks;
			for "_i" from 0 to (_count -1) do {
				_zombieFreak = _zombieFreaks select _i;
				if (BBZShieldClean == 1) then {
					deleteVehicle _zombieFreak;
				} else {
					_zombieFreak setDamage 1;
				};
				sleep 1;
			};
		};
	} else {
		//diag_log ["Stage 5.5 here"];
		_shieldGen = _this select 0;
		_shieldGen setVariable ["bbZombieShield", "false", true];
	};
};

if (_doZombieShield) then {
	//diag_log ["Stage 1 here"];
	_shieldGenStatus = _shieldGen getVariable ["bbZombieShield", "false"];
	if (_shieldGenStatus == "false") then {
		//diag_log ["Stage 2 here"];
		if (count _getNearestBaseFlag < 1) then {
			cutText [format["You can only use this within %1 meters of a base flag!",(BBFlagRadius - 50)], "PLAIN DOWN"];
			breakout "exit";
		};
		if (count _nearestGenerator < 1) then {
			cutText [format["You need a generator within %1 meters of the flag to use this!",BBFlagRadius], "PLAIN DOWN"];
			breakout "exit";
		};
		//diag_log ["Stage 3 here"];
		_doShield = true;
		cutText ["Activating Zombie Shield", "PLAIN DOWN"];
		[_shieldGen] call _func_bb_zombie_shield;
	};
} else {
	_shieldGenStatus = _shieldGen getVariable ["bbZombieShield", "false"];
	if (_shieldGenStatus == "true") then {
		//diag_log ["Stage 1.1 here"];
		_doShield = false;
		cutText ["De-Activating Zombie Shield", "PLAIN DOWN"];
		[_shieldGen] call _func_bb_zombie_shield;
	};
};
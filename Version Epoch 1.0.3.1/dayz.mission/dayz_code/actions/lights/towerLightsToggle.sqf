private ["_id","_lever","_doTowerLights","_needGen","_getNearestBaseFlag","_nearestFlag","_nearLightTowers"];

_id = _this select 2;
_lever = _this select 3 select 0;
_doTowerLights = _this select 3 select 1;
_lever removeAction _id;

_needGen = BBTowerLightsNGen;
_genClass = "PowerGenerator_EP1";
_getNearestBaseFlag = nearestObjects [_lever, [BBTypeOfFlag], BBFlagRadius];//Find the nearest base flag.
_nearestFlag = _getNearestBaseFlag select 0; //Selects the base flag from the returned array.
_nearLightTowers = nearestObjects [_nearestFlag, ["Land_Ind_IlluminantTower"], BBFlagRadius];//Finds all towers in range of that flag.

if (_doTowerLights) then {
	{
		_x setVariable ["bbTowerLight", "true", true];
		if (_needGen) then {
			_nearGen = nearestObjects [_nearestFlag, [_genClass], BBFlagRadius];
			if ((count _nearGen) < 1) then {
				cutText ["You need to build a generator in range of the flag.","PLAIN DOWN"];
				_x setVariable ["bbTowerLight", "false", true];
			};
		};
	} forEach _nearLightTowers;
} else {
	{
		_x setVariable ["bbTowerLight", "false", true];
	} forEach _nearLightTowers;
};
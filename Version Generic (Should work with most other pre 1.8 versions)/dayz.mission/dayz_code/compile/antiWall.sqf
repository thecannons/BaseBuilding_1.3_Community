/*
Anti Wall by Daimyo
This script prevents players from exiting vehicles into a wall and glitching
through the wall in order to get into a player made base.
*/

private["_inBase","_wallRange","_wallType","_inVehicle","_walltypes","_wall","_vehPos","_nearestVeh","_nearestVehs","_isVehicle","_authorizedPUID"];
if (animationstate player == "acrgpknlmstpsnonwnondnon_amovpercmstpsnonwnondnon_getoutlow" || animationstate player == "acrgpknlmstpsnonwnondnon_amovpercmstpsraswrfldnon_getoutlow" || animationstate player == "acrgpknlmstpsnonwnondnon_amovpercmstpsraswpstdnon_getoutlow") then {
_inVehicle = (vehicle player != player);
_isVehicle = (vehicle player);
_inBase = false;
_wallRange = 10;
//_nearBool = true;
		//Check objects from global wallarray via build_list.sqf
		_flagPoles = nearestObjects [player, [BBTypeOfFlag], 300];
		if (count _flagPoles > 0) then {
			{
				_checkBase = _x getVariable ["AuthorizedUID", []];
				_authorizedPUID = _checkBase select 1; //Select the playerUIDs only from array
				if ((getPlayerUID player) in _authorizedPUID) exitWith {
					_inBase = true;
				};
			
			} foreach _flagPoles;
		};
		_walltypes = nearestObjects [player, wallarray, 30];
		if (count _walltypes > 0 && !_inBase) then {
				_wall = _walltypes select 0;//[_walltypes, player] call BIS_fnc_nearestPosition;
				if (_wall in structures) then {_wallRange = 25};
				if (player distance _wall < _wallRange) then {
						_nearestVehs = nearestObjects [player, ["LandVehicle"], 10];
						_nearestVeh = _nearestVehs select 0;//[_nearestVehs, player] call BIS_fnc_nearestPosition;

						_vehPos = getPosATL _nearestVeh;
						_vehPos set [2, 0];
						sleep .01;
						player allowdamage false;
						player setpos _vehPos;
						cutText ["Move out of the vehicle NOW to avoid death!  -Anti-Wall script", "PLAIN"];
						//player action ["eject", _isVehicle];//player moveInDriver (vehicle player);
						sleep 5;
						player allowdamage true;
						};			
		};
	};
private ["_fnc_open_door","_gateLowered","_isBuildable","_charPos","_character","_id","_pos","_z","_nearestGates","_inMotion","_lever","_text"];
_character = _this select 1;
_id = _this select 2;
_lever = _this select 3;
_isBuildable = true;
_charPos = getposATL _character;
_inMotion = _lever getVariable ["inMotion",0];
_lever removeAction _id;
_nearestGates = nearestObjects [_lever, ["Concrete_Wall_EP1"], 15];
//dayz_updateNearbyObjects = [_charPos, _isBuildable];
//publicVariableServer "dayz_updateNearbyObjects";
//	if (isServer) then {
//		dayz_updateNearbyObjects call server_updateNearbyObjects;
//	};

//[_charPos, _isBuildable] call server_updateNearbyObjects;
if (typeOf(_lever) == "Infostand_2_EP1") then {
	if (_inMotion == 0) then {

		_lever setVariable ["inMotion", 1, true];
		
		{
			//_pos = getPosATL _x; // changed from getpos
			//_z = _pos select 2;
			_gateLowered = _x getVariable ["GateLowered", false];
			//if (_z <= -2) then {
			if (_gateLowered) then {
				_text = getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
				cutText [format["Raising the %1",_text], "PLAIN DOWN"];
				//_pos set [2,0];
				//_x setPos _pos;
				_nic = [nil, _x, "per", rHideObject, false] call RE;
				[nil,_x,rSAY,["trap_bear_0",60]] call RE;
				sleep .5;
				[nil,_x,rSAY,["trap_bear_0",60]] call RE;
				_x setVariable ["GateLowered", false, true];
			} else {
				_text = getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
				cutText [format["Lowering the %1",_text], "PLAIN DOWN"];
				//_pos set [2,-6.6];
				//_x setPos _pos;
				_nic = [nil, _x, "per", rHideObject, true] call RE;
				[nil,_x,rSAY,["trap_bear_0",60]] call RE;
				_x setVariable ["GateLowered", true, true];
			};
			
			sleep 1;
			
		} foreach _nearestGates;
		_lever setVariable ["inMotion", 0, true];
	};
};

_fnc_open_door = {
	private["_timeOut","_door","_time","_cnt","_text"];
    _door = _this select 0;
    _time = _this select 1;

    _pos = getPos _door;
    _door setVariable ["inMotion", 1, true];
    _text = getText (configFile >> "CfgVehicles" >> (typeOf _door) >> "displayName");
    [nil,_door,rSAY,["trap_bear_0",60]] call RE;
     _nic = [nil, _door, "per", rHideObject, true] call RE;
    //_door hideObject true;
    //_pos set [2,-6.6];
    //_door setPos _pos;


		cutText [format["Lowering the %1, will raise after %2 seconds",_text,_time], "PLAIN DOWN"];
		sleep _time;

    cutText [format["Raising the %1",_text], "PLAIN DOWN"];
    [nil,_door,rSAY,["trap_bear_0",60]] call RE;
     _nic = [nil, _door, "per", rHideObject, false] call RE;
     //_door hideObject false; 
    //_pos set [2,0];
    //_door setPos _pos;
    _door setVariable ["inMotion", 0, true];

};
//The Fence_corrugated_plate is now its own single gate and not tied to a panel
if (typeOf(_lever) == "Fence_corrugated_plate") then 
{
[_lever, 60] spawn _fnc_open_door;
/*
		if (_inMotion == 0) then {
			_lever setVariable ["inMotion", 1, true];
			_pos = getPos _lever;
			_z = _pos select 2;
			if (_z <= -1) then {
				_text = getText (configFile >> "CfgVehicles" >> (typeOf _lever) >> "displayName");
				cutText [format["Raising the %1",_text], "PLAIN DOWN"];
				_pos set [2,0];
				_lever setPos _pos;
				[nil,_lever,rSAY,["trap_bear_0",60]] call RE;
				sleep .5;
				[nil,_lever,rSAY,["trap_bear_0",60]] call RE;
			} else {
				_text = getText (configFile >> "CfgVehicles" >> (typeOf _lever) >> "displayName");
				cutText [format["Lowering the %1",_text], "PLAIN DOWN"];
				_pos set [2,-1.4];
				_lever setPos _pos;
				[nil,_lever,rSAY,["trap_bear_0",60]] call RE;
			};
			_lever setVariable ["inMotion", 0, true];
		};
*/
};


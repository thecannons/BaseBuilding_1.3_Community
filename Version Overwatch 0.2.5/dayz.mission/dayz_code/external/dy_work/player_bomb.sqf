private["_authorizedUID","_authorizedPUID","_isBomb","_vehiclePlayer","_inVehicle","_hasBlown","_timeLeft","_bombList","_bomb","_timer","_cnt","_arrayTotal","_dir","_pos","_objectID","_objectUID","_detonate"];
/*player = _this select 0;
if (isPlayer player) then {
player = player;
};
*/
_timeLeft = 3;
_isBomb = 0;
_interval = 0.01;
if (!isPlayer player) then {_interval = 0.03;};
while {true} do {
	_inVehicle = (vehicle player != player);
	_vehiclePlayer = (vehicle player);
		_bombList = nearestObjects [player, ["Grave"],18];
	if (count _bombList > 0) then {
		{	
			if ((_x getVariable ["characterID", "0"]) != "0") then {
				_bomb = _x;
				_authorizedUID = _bomb getVariable ["AuthorizedUID", []];
				_authorizedPUID = _authorizedUID select 1;
				_isBomb = _bomb getVariable ["isBomb", 0];
				if (!procBuild && _isBomb == 1 && !((getplayerUID player) in _authorizedPUID)) then {
					_dir = direction _bomb;
					_pos = [(getposATL _bomb select 0),(getposATL _bomb select 1), (getposATL _bomb select 2) + 1.12];
					_objectID = _bomb getVariable["ObjectID","0"];
					_objectUID = _bomb getVariable["ObjectUID","0"];
					//hint format ["%1",speed _vehiclePlayer];
					if (!isNull _bomb && ((player distance _bomb < 12 && (speed player > 4 || speed player < -3)) || (_vehiclePlayer distance _bomb < 12 && (_inVehicle && speed _vehiclePlayer > 0 || _inVehicle && speed _vehiclePlayer < -0)))) then {
						//Trigger blowup sequence
						_blowUp = [_bomb, _pos, _vehiclePlayer] spawn {
							private["_bomb","_pos","_vehiclePlayer"];
							_bomb = _this select 0;
							_pos = _this select 1;
							_vehiclePlayer = _this select 2;
							_inVehicle = (vehicle player != player);
							[nil,_bomb,rSAY,["trap_bear_0",60]] call RE;
							sleep .1;
							if ((player distance _bomb < 5 && (speed player > 4 || speed player < -3)) || (_vehiclePlayer distance _bomb < 5 && (_inVehicle && speed _vehiclePlayer > 0 || _inVehicle && speed _vehiclePlayer < -0))) then {
								_detonate = "grenade" createVehicle _pos; /*createVehicle ["GrenadeHandTimedWest_DZ", _pos, [], 0, "CAN_COLLIDE"];*/
							} else {
								sleep .7;
								_detonate = "grenade" createVehicle _pos; /*createVehicle ["GrenadeHandTimedWest_DZ", _pos, [], 0, "CAN_COLLIDE"];*/
							};
						};
						sleep .8;
						PVDZ_obj_Delete = [_objectID,_objectUID];
						publicVariableServer "PVDZ_obj_Delete";
						if (isServer) then {
							PVDZ_obj_Delete call local_deleteObj;
						};
						if (!isNull _bomb) then {
							deleteVehicle _bomb;
						};
					};
				};
			};
		} forEach _bombList;
	};
	sleep _interval;
};
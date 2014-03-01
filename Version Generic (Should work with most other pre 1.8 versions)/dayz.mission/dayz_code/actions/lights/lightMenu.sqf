private ["_lever","_nearestFlags","_baseFlag","_barrels","_towers","_baseBuildAdmin","_baseBuildLAdmin","_authorizedUID","_authorizedGateCodes","_adminText"];

_lever = _this select 3;
_baseBuildAdmin = ((getPlayerUID player) in BBSuperAdminAccess);
_baseBuildLAdmin = ((getPlayerUID player) in BBLowerAdminAccess);
_authorizedUID = _lever getVariable ["AuthorizedUID", []];
_authorizedGateCodes = if (count _authorizedUID > 0) then {((getPlayerUID player) in (_authorizedUID select 1));}; 
_adminText = if (!_authorizedGateCodes && _baseBuildAdmin) then {"ADMIN:";}else{"";};//Let admins know they aren't registered
if (cursorTarget == _lever) then {
		_nearestFlags = nearestObjects [_lever, [BBTypeOfFlag], BBFlagRadius];
		_baseFlag = _nearestFlags select 0;
		_barrels = nearestObjects [_baseFlag, ["Land_Fire_Barrel"], BBFlagRadius];//Makes sure there are barrels in range of the flag
		_towers = nearestObjects [_baseFlag, ["Land_Ind_IlluminantTower"], BBFlagRadius];//Makes sure there are towers in range of the flag
	if (count _barrels > 0) then {
		if (s_player_inflameBarrels < 0) then {
			s_player_inflameBarrels = player addAction [format[("<t color=""#4FF795"">" + ("%1Barrel Lights ON") +"</t>"),_adminText], "dayz_code\actions\lights\barrelToggle.sqf", [_lever,true], 5, false, false, "", ""];
		};
		if (s_player_deflameBarrels < 0) then {
			s_player_deflameBarrels = player addAction [format[("<t color=""#4FF795"">" + ("%1Barrel Lights OFF") +"</t>"),_adminText], "dayz_code\actions\lights\barrelToggle.sqf", [_lever,false], 5, false, false, "", ""];
		};
	} else {
		if (s_player_inflameBarrels < 0) then {
			s_player_inflameBarrels = player addAction [format[("<t color=""#4FF795"">" + ("%1No Barrel Lights In Range") +"</t>"),_adminText], "", _lever, 5, false, true, "", ""];
		};
		player removeAction s_player_deflameBarrels;
		s_player_deflameBarrels = -1;
	};
	if (BBUseTowerLights == 1) then {
		if (count _towers > 0) then {
			if (s_player_towerLightsOn < 0) then {
				s_player_towerLightsOn = player addAction [format[("<t color=""#4FF795"">" + ("%1Tower Lights ON") +"</t>"),_adminText], "dayz_code\actions\lights\towerLightsToggle.sqf", [_lever,true], 5, false, false, "", ""];
			};
			if (s_player_towerLightsOff < 0) then {
				s_player_towerLightsOff = player addAction [format[("<t color=""#4FF795"">" + ("%1Tower Lights OFF") +"</t>"),_adminText], "dayz_code\actions\lights\towerLightsToggle.sqf", [_lever,false], 5, false, false, "", ""];
			};
		} else {
			if (s_player_towerLightsOn < 0) then {
				s_player_towerLightsOn = player addAction [format[("<t color=""#4FF795"">" + ("%1No Tower Lights In Range") +"</t>"),_adminText], "", _lever, 5, false, true, "", ""];
			};
			player removeAction s_player_towerLightsOff;
			s_player_towerLightsOff = -1;
		};
	};
} else {
	player removeAction s_player_inflameBarrels;
	s_player_inflameBarrels = -1;
	player removeAction s_player_deflameBarrels;
	s_player_deflameBarrels = -1;
	player removeAction s_player_towerLightsOn;
	s_player_towerLightsOn = -1;
	player removeAction s_player_towerLightsOff;
	s_player_towerLightsOff = -1;
};
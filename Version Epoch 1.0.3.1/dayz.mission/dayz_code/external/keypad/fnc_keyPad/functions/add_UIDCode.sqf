private ["_flagCount","_isOk","_allFlags","_panel","_convertInput","_authorizedUID","_authorizedOUID","_authorizedPUID","_flagUID","_flagPUID","_zShieldCount","_allZShields","_zShieldUID","_zShieldPUID"];
	_isOk = true;
	//[_panel, _convertInput] call add_UIDCode;		
	addUIDCode = false;
	sleep 0.2; //Give it time to close the last script to avoid issues with hint windows closing too fast or not displaying at all
	_panel 			= _this select 0;
	_convertInput 	= _this select 1;
	_authorizedUID = _panel getVariable ["AuthorizedUID", []];
	_authorizedOUID = _authorizedUID select 0; //Sets objectUID as first element
	_authorizedPUID = _authorizedUID select 1; //Sets playerUID as second element
	for "_i" from 0 to (count _convertInput - 1) do {_convertInput set [_i, (_convertInput select _i) + 48]};
	if ((toString _convertInput) in _authorizedPUID) then {
		CODEINPUT = [];
		bbCDebug = missionNameSpace getVariable [format["%1",BBCustomDebug],false];
		if (bbCDebug) then {missionNameSpace setVariable [format["%1",BBCustomDebug],false]; hintSilent ""; bbCDReload = 1;};
		hintsilent parseText format ["
		<t align='center' color='#FF0000'>ERROR</t><br/><br/>
		<t align='center'>Player UID %1 already has access to object</t><br/>
		<t align='center'>%2</t><br/><br/>
		<t align='left'>Object UID:</t>	<t align='right'>%3</t><br/>
		",(toString _convertInput), typeOf(_panel), str(keyCode)];
		sleep 5;
		hint "";
		if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",BBCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};
		breakout "exit";
	};
	//If object is a flag, then make sure player isn't already registered to maximum number
	if (typeOf(_panel) == BBTypeOfFlag) then {
	_flagCount = 0;
	_allFlags = nearestObjects [player, [BBTypeOfFlag], 25000];
		{
			if (typeOf(_x) == BBTypeOfFlag) then {
				_flagUID = _x getVariable ["AuthorizedUID", []];
				//_flagOUID = _flagUID select 0;
				_flagPUID = _flagUID select 1;
				if ((toString _convertInput) in _flagPUID && (typeOf(_x) == BBTypeOfFlag)) then {
					_flagCount = _flagCount + 1;
				};
			};
		} foreach _allFlags;
		if (_flagCount >= BBMaxPlayerFlags) then {
			CODEINPUT = [];
			bbCDebug = missionNameSpace getVariable [format["%1",BBCustomDebug],false];
			if (bbCDebug) then {missionNameSpace setVariable [format["%1",BBCustomDebug],false]; hintSilent ""; bbCDReload = 1;};
			hintsilent parseText format ["
			<t align='center' color='#FF0000'>ERROR</t><br/><br/>
			<t align='center'>Player UID %1 already used on %2 flags!</t><br/>
			",(toString _convertInput),BBMaxPlayerFlags];
			sleep 5;
			if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",BBCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};
			breakout "exit";
		};
	};
	//If object is a zombie shield generator, then make sure player isn't already registered to maximum number
	if (typeOf(_panel) == BBTypeOfZShield) then {
	_zShieldCount = 0;
	_allZShields = nearestObjects [player, [BBTypeOfZShield], 25000];
		{
			if (typeOf(_x) == BBTypeOfZShield) then {
				_zShieldUID = _x getVariable ["AuthorizedUID", []];
				//_zShieldOUID = _zShieldUID select 0;
				_zShieldPUID = _zShieldUID select 1;
				if ((toString _convertInput) in _zShieldPUID && (typeOf(_x) == BBTypeOfZShield)) then {
					_zShieldCount = _zShieldCount + 1;
				};
			};
		} foreach _allZShields;
		if (_zShieldCount >= BBMaxZShields) then {
			CODEINPUT = [];
			bbCDebug = missionNameSpace getVariable [format["%1",BBCustomDebug],false];
			if (bbCDebug) then {missionNameSpace setVariable [format["%1",BBCustomDebug],false]; hintSilent ""; bbCDReload = 1;};
			hintsilent parseText format ["
			<t align='center' color='#FF0000'>ERROR</t><br/><br/>
			<t align='center'>Player UID %1 already used on %2 zombie shield generators!</t><br/>
			",(toString _convertInput),BBMaxZShields];
			sleep 5;
			if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",BBCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};
			breakout "exit";
		};
	};
	_authorizedPUID set [count _authorizedPUID, (toString _convertInput)]; //Updates playerUID element with new code
	_panel setVariable ["AuthorizedUID", ([_authorizedOUID] + [_authorizedPUID]), true]; //Writes the updated arrays to the object variable
	// Update to database
	PVDZE_veh_Update = [_panel,"gear"];
	publicVariableServer "PVDZE_veh_Update";
	if (isServer) then {
		PVDZE_veh_Update call server_updateObject;
	};
	bbCDebug = missionNameSpace getVariable [format["%1",BBCustomDebug],false];
	if (bbCDebug) then {missionNameSpace setVariable [format["%1",BBCustomDebug],false]; hintSilent ""; bbCDReload = 1;};
	hintsilent parseText format ["
	<t align='center' color='#00FF3C'>SUCCESS</t><br/><br/>
	<t align='center'>Player UID %1 access granted to object</t>
	<t align='center'>%2</t><br/><br/><br/>
	<t align='left'>Object UID:</t>	<t align='right'>%3</t><br/>
	",(toString _convertInput), typeOf(_panel), str(keyCode)];
	CODEINPUT = [];
	sleep 10;
	hint "";
	if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",BBCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};
	
private ["_finalInput","_panel","_convertInput","_authorizedUID","_authorizedOUID","_authorizedPUID"];
	
	//[_panel, _convertInput, globalAuthorizedUID] call add_UIDCode;	
	removeUIDCode = false;	
	sleep 0.2; //Give it time to close the last script to avoid issues with hint windows closing too fast or not displaying at all
	_panel 			= _this select 0;
	_convertInput 	= _this select 1;
	_authorizedUID = _panel getVariable ["AuthorizedUID", []]; //Get's whole array stored for object
	_authorizedOUID = _authorizedUID select 0; //Sets objectUID as first element
	_authorizedPUID = _authorizedUID select 1; //Sets playerUID as second element
	for "_i" from 0 to (count _convertInput - 1) do {_convertInput set [_i, (_convertInput select _i) + 48]};
	if (!((toString _convertInput) in _authorizedPUID)) exitWith 
	{
		CODEINPUT = [];
		bbCDebug = missionNameSpace getVariable [format["%1",BBCustomDebug],false];
		if (bbCDebug) then {missionNameSpace setVariable [format["%1",BBCustomDebug],false]; hintSilent ""; bbCDReload = 1;};
		hintsilent parseText format ["
		<t align='center' color='#FF0000'>ERROR</t><br/><br/>
		<t align='center'>Player UID %1 not found in object</t><br/>
		<t align='center'>%2</t><br/><br/>
		<t align='left'>Object UID:</t>	<t align='right'>%3</t><br/>
		",(toString _convertInput), typeOf(_panel), str(keyCode)];
		sleep 5;
		hint "";
		if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",BBCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};
	};
	_finalInput = (toString _convertInput);
	_authorizedPUID = _authorizedPUID - [_finalInput];
	_panel setVariable ["AuthorizedUID", ([_authorizedOUID] + [_authorizedPUID]), true];
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
	<t align='center'>Player UID %1 access removed from object</t><br/>
	<t align='center'>%2</t><br/><br/>
	<t align='left'>Object UID:</t>	<t align='right'>%3</t><br/>
	",(toString _convertInput), typeOf(_panel), str(_authorizedOUID)];
	CODEINPUT = [];
	sleep 10;
	hint "";
	if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",BBCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};
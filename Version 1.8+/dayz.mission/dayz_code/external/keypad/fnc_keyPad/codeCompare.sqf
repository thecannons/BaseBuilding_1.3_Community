private ["_authorizedUID","_panel","_convertInput","_inputCode"];
_panel = accessedObject;
keyCode = _this select 0;

	// This is only if we are adding/removing playerUIDs and not entering code to operate gate
	if (addUIDCode) exitWith 
	{
		_authorizedUID = _panel getVariable ["AuthorizedUID", []];
		_inputCode = _this select 1;
		_convertInput =+ _inputCode;
		[_panel, _convertInput] spawn add_UIDCode;
		CODEINPUT = [];		
	};
	if (removeUIDCode) exitWith 
	{
		//_authorizedUID = _panel getVariable ["AuthorizedUID", []];
		_inputCode = _this select 1;
		_convertInput =+ _inputCode;
		[_panel, _convertInput] spawn remove_UIDCode;
		CODEINPUT = [];
	};
//addaction sends [target, caller, ID, (arguments)]
private ["_displayok","_lever"];
//_id = _this select 2;
//_lever removeAction _id;
_lever = objNull;
_lever = _this select 3;
accessedObject = _lever;


//_dir = direction _lever;
//_pos = getPosATL _lever;
	//_uid 	= [_dir,_pos] call dayz_leverectUID2;
_authorizedUID = _lever getVariable ["AuthorizedUID", []];
keyCode = (_authorizedUID select 0) select 0;
//keyCode = _lever getVariable ["ObjectUID","0"];
_displayok = createdialog "KeypadGate";

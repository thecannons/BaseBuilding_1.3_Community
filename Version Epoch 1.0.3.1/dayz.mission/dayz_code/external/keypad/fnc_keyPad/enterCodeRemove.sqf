/*
This script allows players to remove player UIDs from object so that 
they may no longer use the object
*/

private ["_displayok","_obj","_authorizedPUID"];
_obj = _this select 3;
accessedObject = _obj;
_authorizedUID = _obj getVariable ["AuthorizedUID", []];
//keyCode = _obj getVariable ["ObjectUID","0"];
keyCode = (_authorizedUID select 0) select 0;
_authorizedPUID = _authorizedUID select 1;
_displayok = createdialog "KeypadGate";
removeUIDCode = true;
//Show current UIDs until new UID is removed
while {removeUIDCode} do {
bbCDebug = missionNameSpace getVariable [format["%1",BBCustomDebug],false];
if (bbCDebug) then {missionNameSpace setVariable [format["%1",BBCustomDebug],false]; hintSilent ""; bbCDReload = 1;};
hintsilent parseText format ["
		<t align='center' color='#0074E8'>Current Player UID(s):</t><br/>
		<t align='center'>%1</t><br/><br/>
		<t align='center' color='#F5CF36'>Enter UID of player you would like to REMOVE access from object: %2</t><br/><br/>
		<t align='left' color='#0074E8'>Object UID:</t>	<t align='right'>%3</t><br/>
		",str(_authorizedPUID), typeOf(_obj), str(keyCode)];
if (!removeUIDCode) exitwith {
hint"";
if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",BBCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};};
};
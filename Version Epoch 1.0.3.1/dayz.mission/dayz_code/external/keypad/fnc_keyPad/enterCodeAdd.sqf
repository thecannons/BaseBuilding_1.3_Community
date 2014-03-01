/*
This script allows players to add player UIDs to the object 
so that they may use the object as well
*/

private ["_displayok","_obj","_authorizedUID","_atuhorizedOUID","_authorizedPUID"];
_obj = _this select 3;
//keyCode = _obj getVariable ["ObjectUID","0"];
// globalAuthorizedUID is the playerUID that is being checked 
_authorizedUID = _obj getVariable ["AuthorizedUID", []];
keyCode = (_authorizedUID select 0) select 0;
_authorizedPUID = _authorizedUID select 1;
accessedObject = _obj;

_displayok = createdialog "KeypadGate";
addUIDCode = true;
//Show current UIDs until new UID is added
while {addUIDCode} do {
bbCDebug = missionNameSpace getVariable [format["%1",BBCustomDebug],false];
if (bbCDebug) then {missionNameSpace setVariable [format["%1",BBCustomDebug],false]; hintSilent ""; bbCDReload = 1;};
hintsilent parseText format ["
		<t align='center' color='#0074E8'>Current Player UID(s):</t><br/>
		<t align='center'>%1</t><br/><br/>
		<t align='center' color='#F5CF36'>Enter UID of player you would like to ADD access to object: %2</t><br/><br/>
		<t align='left' color='#0074E8'>Object UID:</t>	<t align='right'>%3</t><br/>
		",str(_authorizedPUID), typeOf(_obj), str(keyCode)];
if (!addUIDCode) exitwith {
hint"";
if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",BBCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};};
};
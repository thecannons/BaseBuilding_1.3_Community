private ["_id","_lever","_doLight","_getNearestBaseFlag","_nearestFlag","_nearestBarrels"];
_id = _this select 2;
_lever = _this select 3 select 0;
_doLight = _this select 3 select 1;
_lever removeAction _id;
_getNearestBaseFlag = (nearestObjects [_lever, [BBTypeOfFlag], BBFlagRadius]);//Find the nearest base flag
_nearestFlag = _getNearestBaseFlag select 0; //Selects the base flag from the returned array
_nearestBarrels = nearestObjects [_nearestFlag, ["Land_Fire_Barrel"], BBFlagRadius];

if (_doLight) then {
{
     _x inflame true;
} foreach _nearestBarrels;
} else {
{
     _x inflame false;
} foreach _nearestBarrels;
};
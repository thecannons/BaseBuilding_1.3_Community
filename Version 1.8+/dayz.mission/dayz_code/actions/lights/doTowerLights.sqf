//Original Script created by Andrew Gregory aka axeman axeman@thefreezer.co.uk
//Edited by Rosska85 for use with DayZ Base Building 1.3
private ["_lCol","_lbrt","_lamb","_doLit","_twr","_twrPos","_rad","_oset","_nrTLs","_ang","_a","_b","_tl","_nearbyTowers","_func_bbTL"];
waitUntil {!isNull player};
//####----####----Can edit these values----####----####
_lCol = [1, 0.88, 0.73]; // Colour of lights on tower when directly looked at | RGB Value from 0 to 1.
_lbrt = 0.04;//Brightness (also visible distance) of light source.
_lamb = [1, 0.88, 0.73]; // Colour of surrounding (ambient) light | RGB Value from 0 to 1.
//####----####----End Edit Values----####----####

_func_bbTL = {
	_twr = _this select 0;
	_twrPos =  getPos _twr;
	_rad=2.65;
	_oset=14;
	_nrTLs= position _twr nearObjects ["#lightpoint",30];
	if(count _nrTLs > 3)then{
	{
		if(_doLit)then{
			_x setLightColor _lCol;
			_x setLightBrightness _lbrt;
			_x setLightAmbient _lamb;
		}else{
			deleteVehicle _x;
		};
		sleep .2;
	} forEach _nrTLs;
	} else {
		if(_doLit)then{
			for "_tls" from 1 to 4 do {
			_ang=(360 * _tls / 4)-_oset;
			_a = (_twrPos select 0)+(_rad * cos(_ang));
			_b = (_twrPos select 1)+(_rad * sin(_ang));
			_tl = "#lightpoint" createVehicle [_a,_b,(_twrPos select 2) + 26] ;
			_tl setLightColor _lCol;
			_tl setLightBrightness _lbrt;
			_tl setLightAmbient _lamb;
			_tl setDir _ang;
			_tl setVectorUp [0,0,-1];
			sleep .4;
			};
		};
	};
};
while {alive player} do {
_nearbyTowers = nearestObjects [player, ["Land_Ind_IlluminantTower"], 1200];
	{
		if ((_x getVariable ["characterID", "0"]) != "0") then { //If it has an owner
			_doLit = false;
			if ((_x getVariable ["bbTowerLight", "false"]) == "true") then { //if it is turned on
				_doLit = true;
			};
			[_x] call _func_bbTL;
		};
	} forEach _nearbyTowers;
	sleep 0.5;
};
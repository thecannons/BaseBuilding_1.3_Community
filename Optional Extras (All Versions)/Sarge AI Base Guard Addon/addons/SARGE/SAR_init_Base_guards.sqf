
//Base patrols
private["_sizeX","_sizeY","_snipers","_rifleMen","_sizeOfBase","_marker","_markername","_tMark","_someMarker","_flagPoles","_cnt","_spawnPos","_tPosX","_tPosY"];
//if (hasInterface || isServer || isDedicated) exitWith{};//Headless client maybe? 
sleep 120;
_flagPoles = nearestObjects [(getMarkerPos "center"), [BBTypeOfFlag], 25000];
diag_log "SAR_INIT_BASE_GUARDS CALLED";
diag_log format["_flagPoles: %1", str(_flagPoles)];
diag_log format["count _flagPoles: %1", (count _flagPoles)];
	{
		_sizeOfBase = nearestObjects [_x, allbuildables_class, 200];
		//Spawn guard amount based on base size
		_rifleMen = 1; //Default number of riflemen (remember, there is ALWAYS a leader too)
		_snipers = 1; //Default number of snipers
		_sizeX = 50; 
		_sizeY = 50;
		if (count _sizeOfBase >= 10) then { _rifleMen = 2; _snipers = 1; _sizeX = 75; _sizeY = 75};//Number to increase AI to if the base has 10 objects built
		if (count _sizeOfBase >= 20) then { _rifleMen = 3; _snipers = 1; _sizeX = 100; _sizeY = 100};//Number to increase AI to if the base has 20 objects built
		if (count _sizeOfBase >= 30) then { _rifleMen = 3; _snipers = 2; _sizeX = 150; _sizeY = 150};//Number to increase AI to if the base has 30 objects built
		if (count _sizeOfBase >= 100) then { _sizeX = 180; _sizeY = 180 };
		_spawnPos = (getPosATL _x);//[(getPosATL _x), 10, 50, 10, 0, 2000, 0] call BIS_fnc_findSafePos;
		_tPosX = _spawnPos select 0;
		_tPosY = _spawnPos select 1;
		
		_markername = format["FLAG_BASE_%1", _x];//Changed to _x because _cnt wasn't working, it never generated a name so they never spawned in
		_tMark = createMarker [_markername, position _x];
		_tMark setMarkerShape "ELLIPSE";
		_tMark setMarkeralpha 0;
		_tMark setMarkerType "Flag";
		_tMark setMarkerBrush "Solid";
		_tMark setMarkerSize [_sizeX, _sizeY];
		_marker = _tMark;
		
		//_behaviors = ["patrol","ambush","fortify"];
		//_behavior = _behaviors call BIS_fnc_selectRandom;
		// 1 = type of group (1 = soldiers, 2 = survivors, 3 = bandits)
		// 0 = amount of snipers in the group
		// 1 = amount of rifleman in the group
		[_x, _marker,2,_snipers,_rifleMen,"patrol", false, 5200] call SAR_AI_GUARDS;
		//[_spawnPos,2,floor(random 2),floor(random 4),"patrol",false] call SAR_AI;
		
		diag_log "SPAWNING FLAGS END!";
	} foreach _flagPoles;
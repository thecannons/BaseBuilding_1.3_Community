	//Allows player to reposition object from preview stage
	//[_object,_objectPos,rotateDir]	
	_object = _this select 3 select 0;
	_repoObjectPos = _this select 3 select 1;
	_repoObjectDirR= _this select 3 select 2;
	player removeAction repositionAction;
	player removeAction finishAction;
	player removeAction cancelAction;
	repositionAction	= -1;
	finishAction		= -1;
	cancelAction		= -1;
	builderChooses = true;
	buildReposition = true;
	sleep 0.5; //Give player_build enough time to exit before calling it again
	buildReady = false;
	procBuild = false;
	deleteVehicle _object;
	//diag_log format ["REPOSITION OBJECT _repoObjectPos is %1, _repoObjectDirR is %2",_repoObjectPos, _repoObjectDirR];
	[_repoObjectPos,_repoObjectDirR] call player_build2;
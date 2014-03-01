	//Prepares preview stage where players can confirm or reposition
	player removeAction attachGroundAction;
    player removeAction previewAction;
    player removeAction restablishAction;
	player removeAction	repositionAction;
	player removeAction finishAction;
	hint "";
	if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",BBCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};
	buildReady=true;

//####----####----####---- Base Building 1.3 Start ----####----####----####
diag_log "Started executing user settings file.";						// Log start

if (!isDedicated) then {
	_null = [] execVM "dayz_code\external\dy_work\player_bomb.sqf";		// Booby traps bomb
	_null = [] execVM "dayz_code\external\dy_work\initWall.sqf";		// Doesnt allow players to get out of vehicle through specified walls
	_null = [] execVM "dayz_code\external\dy_work\build_list.sqf";		// build_list for building array
	_null = [] execVM "dayz_code\actions\lights\doTowerLights.sqf";		// Run tower lighting script
	player setVariable ["BIS_noCoreConversations", true];
};

diag_log "Finished executing user settings file.";						// Log finish
//####----####----####---- Base Building 1.3 End ----####----####----####
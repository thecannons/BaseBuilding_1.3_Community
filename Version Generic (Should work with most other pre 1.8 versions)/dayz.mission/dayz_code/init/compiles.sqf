
//Custom Self Actions File
	fnc_usec_selfActions 				= compile preprocessFileLineNumbers "dayz_code\compile\fn_selfActions.sqf";

//Base Building 1.3 Specific Compiles
	player_build						= compile preprocessFileLineNumbers "dayz_code\actions\player_build.sqf";
	player_build2 						= compile preprocessFileLineNumbers "dayz_code\compile\player_build2.sqf";
	antiWall 							= compile preprocessFileLineNumbers "dayz_code\compile\antiWall.sqf";
	anti_discWall 						= compile preprocessFileLineNumbers "dayz_code\compile\anti_discWall.sqf";
	refresh_build_recipe_dialog 		= compile preprocessFileLineNumbers "buildRecipeBook\refresh_build_recipe_dialog.sqf";
	refresh_build_recipe_list_dialog 	= compile preprocessFileLineNumbers "buildRecipeBook\refresh_build_recipe_list_dialog.sqf";
	add_UIDCode  						= compile preprocessFileLineNumbers "dayz_code\external\keypad\fnc_keyPad\functions\add_UIDCode.sqf";
	remove_UIDCode  					= compile preprocessFileLineNumbers "dayz_code\external\keypad\fnc_keyPad\functions\remove_UIDCode.sqf";
//To Disable Loot and or Zombie Spawns in Base Build Objects
	//player_spawnCheck = compile preprocessFileLineNumbers "dayz_code\compile\player_spawnCheck.sqf";
	
//Keybinds

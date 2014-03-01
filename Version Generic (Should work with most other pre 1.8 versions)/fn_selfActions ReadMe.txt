
Find

_canDo = (!r_drag_sqf and !r_player_unconscious and !_onLadder);

AFTER that, add

//####----####----####---- Base Building 1.3 Start ----####----####----####
	_currentSkin = typeOf(player);
	_hasToolbox = "ItemToolbox" in items player;
	_baseBuildAdmin = ((getPlayerUID player) in BBSuperAdminAccess);
	_baseBuildLAdmin = ((getPlayerUID player) in BBLowerAdminAccess);
	//Get objects that can't be targetted
	_flagBasePole = nearestObject [player, BBTypeOfFlag];
		//All untargetable objects (except Base Flag), searches a 12 meter radius, you can add any new objects you put in the build list that can't be targetted
		_untargetableArray = nearestObjects [player, ["Land_CamoNetB_EAST","Land_CamoNetVar_EAST","Land_CamoNet_EAST","Land_CamoNetB_NATO","Land_CamoNetVar_NATO","Land_CamoNet_NATO","Land_Ind_IlluminantTower","Land_sara_hasic_zbroj","Land_A_Castle_Bergfrit","Land_A_Castle_Gate","Land_A_Castle_Bastion","Land_A_Castle_Wall1_20","Land_A_Castle_Wall1_20_Turn","Land_A_Castle_Wall2_30","HeliH","HeliHCivil","Land_Ind_Shed_01_main","RampConcrete","Land_Ind_Shed_01_end","Land_Ind_SawMillPen"],12];//The number at the end is the range to look for items, if you have issues with some items try increasing it by one or two at a time.
		_nearUntargetable = count _untargetableArray > 0; //Check if anything is in range
		_closestUntargetable = if (_nearUntargetable) then {_untargetableArray select 0};//Selects the closest returned item
		_nettingNames = ["Land_CamoNetB_EAST","Land_CamoNetVar_EAST","Land_CamoNet_EAST","Land_CamoNetB_NATO","Land_CamoNetVar_NATO","Land_CamoNet_NATO"]; //Used for menu options
		_castleNames = ["Land_A_Castle_Bergfrit","Land_A_Castle_Gate","Land_A_Castle_Bastion","Land_A_Castle_Wall1_20","Land_A_Castle_Wall1_20_Turn","Land_A_Castle_Wall2_30"];
		_heliPadNames = ["HeliH","HeliHCivil"];
		_roofNames = ["Land_Ind_Shed_01_main","Land_Ind_Shed_01_end","Land_Ind_SawMillPen"];
		_buildingNames = [];//Can add generic building names here
		_displayName = "Base Build Object";//Default menu option name if none of the following match
		if (typeOf(_closestUntargetable) in _nettingNames) then {_displayName = "Netting";};
		if (typeOf(_closestUntargetable) in _castleNames) then {_displayName = "Castle";};
		if (typeOf(_closestUntargetable) in _heliPadNames) then {_displayName = "HeliPad";};
		if (typeOf(_closestUntargetable) in _roofNames) then {_displayName = "Roof";};
		if (typeOf(_closestUntargetable) in _buildingNames) then {_displayName = "Building";};
		if (typeOf(_closestUntargetable) == "Land_Ind_IlluminantTower") then {_displayName = "Tower";};


	// Check mags in player inventory to show build recipe menu	
	_mags = magazines player;
	if ("ItemTankTrap" in _mags || "ItemSandbag" in _mags || "ItemWire" in _mags || "PartWoodPile" in _mags || "PartGeneric" in _mags || "equip_scrapelectronics" in _mags || "ItemCamoNet" in _mags || "equip_crate" in _mags || "equip_brick" in _mags || "equip_string" in _mags || "equip_duct_tape" in _mags) then {
		hasBuildItem = true;
	} else { hasBuildItem = false;};
	//Build Recipe Menu Action
	if((speed player <= 1) && hasBuildItem && _canDo) then {
		if (s_player_recipeMenu < 0) then {
			s_player_recipeMenu = player addaction [("<t color=""#0074E8"">" + ("Build Recipes") +"</t>"),"buildRecipeBook\build_recipe_dialog.sqf","",5,false,true,"",""];
		};
		if (s_player_buildHelp < 0) then {
			s_player_buildHelp = player addaction [("<t color=""#FF9500"">" + ("Base Building Help") +"</t>"),"dayz_code\actions\build_help.sqf","",5,false,true,"",""];
		};
		if (s_player_showFlags < 0) then {
			s_player_showFlags = player addAction [("<t color=""#FF9500"">" + ("Show My Flags") +"</t>"),"dayz_code\actions\show_flag_markers.sqf","",5,false,true,"",""];
		};
	} else {
		player removeAction s_player_buildHelp;
		s_player_buildHelp = -1;
		player removeAction s_player_recipeMenu;
		s_player_recipeMenu = -1;
		player removeAction s_player_showFlags;
		s_player_showFlags = -1;
	};
	
	//Add in custom eventhandlers or whatever on skin change
	if (_currentSkin != globalSkin) then {
		globalSkin = _currentSkin;
		player removeMPEventHandler ["MPHit", 0]; 
		player removeEventHandler ["AnimChanged", 0];
		ehWall = player addEventHandler ["AnimChanged", { player call antiWall; }];
		empHit = player addMPEventHandler ["MPHit", {_this spawn fnc_plyrHit;}];
	};

	//General Untargetable Objects
	if((isNull cursorTarget) && _canDo && !remProc && !procBuild && _nearUntargetable) then {
	_ownerUnT = _closestUntargetable getVariable ["characterID", "0"]; //Checks owner IDs of untargetable objects, simply to avoid RPT spam with map objects
	_unTauthUID = _closestUntargetable getVariable ["AuthorizedUID", []]; //Gets master AuthUID from untargetable objects
	_unTauthGateCodes = if ((_ownerUnT != "0") && (count _unTauthUID > 0)) then {((getPlayerUID player) in (_unTauthUID select 1));}; //Checks for player access to untargetable objects
	_adminText = if (!_unTauthGateCodes && _baseBuildAdmin) then {"ADMIN:";}else{"";};//Let admins know they aren't registered
		if (_unTauthGateCodes || _baseBuildAdmin) then {
			if (s_player_camoBaseOwnerAccess < 0) then {
				s_player_camoBaseOwnerAccess = player addAction [format["%2%1: Give all base owners (from flagpole) access",_displayName,_adminText], "dayz_code\external\keypad\fnc_keyPad\functions\give_gateAccess.sqf",_closestUntargetable, 1, false, true, "", ""];
			};
			if (s_player_addCamoAuth < 0) then {
				s_player_addCamoAuth = player addAction [format["%2%1: Add Player UIDs",_displayName,_adminText], "dayz_code\external\keypad\fnc_keyPad\enterCodeAdd.sqf",_closestUntargetable, 1, false, true, "", ""];
			};
			if (s_player_removeCamoAuth < 0) then {
				s_player_removeCamoAuth = player addAction [format[("<t color=""#F01313"">" + ("%2%1: Remove Player UIDs") +"</t>"),_displayName,_adminText], "dayz_code\external\keypad\fnc_keyPad\enterCodeRemove.sqf",_closestUntargetable, 1, false, true, "", ""];
			};
		};
		if (_ownerUnT != "0" && (_hasToolbox || _baseBuildAdmin || _baseBuildLAdmin)) then {
			if (s_player_deleteCamoNet < 0) then {
				s_player_deleteCamoNet = player addaction [format[("<t color=""#F01313"">" + ("Remove %1") +"</t>"),_displayName,_adminText],"dayz_code\actions\player_remove.sqf",_closestUntargetable,1,false,true,"",""];
			};
		};
	} else {
		player removeAction s_player_camoBaseOwnerAccess;
		s_player_camoBaseOwnerAccess = -1;
		player removeAction s_player_addCamoAuth;
		s_player_addCamoAuth = -1;
		player removeAction s_player_removeCamoAuth;
		s_player_removeCamoAuth = -1;
		player removeAction s_player_deleteCamoNet;
		s_player_deleteCamoNet = -1;
	};	

	// FlagPole Access (more reliable than cursortarget)
	if ((isNull cursorTarget) && _canDo && !remProc && !procBuild && (_flagBasePole distance player < 10)) then {
	_ownerFlag = _flagBasePole getVariable ["characterID", "0"]; //Checks owner IDs of flags, simply to avoid RPT spam with map objects
	_flagAuthUID = _flagBasePole getVariable ["AuthorizedUID", []]; //Gets master AuthUID from 
	_flagAuthGateCodes = if ((_ownerFlag != "0") && (count _flagAuthUID > 0)) then {((getPlayerUID player) in (_flagAuthUID select 1));}; //Checks if player has access to flag
	_adminText = if (!_flagAuthGateCodes && _baseBuildAdmin) then {"ADMIN:";}else{"";};//Let admins know they aren't registered
		if (_flagAuthGateCodes || _baseBuildAdmin) then {
			if (s_player_addFlagAuth < 0) then {
				s_player_addFlagAuth = player addAction [format["%1FlagPole: Add Player UIDs for Base Building Access",_adminText], "dayz_code\external\keypad\fnc_keyPad\enterCodeAdd.sqf", _flagBasePole, 1, false, true, "", ""];
			};
			if (s_player_removeFlagAuth < 0) then {
				s_player_removeFlagAuth = player addaction [format[("<t color=""#F01313"">" + ("%1FlagPole: Remove Player UIDs") +"</t>"),_adminText],"dayz_code\external\keypad\fnc_keyPad\enterCodeRemove.sqf", _flagBasePole, 1, false, true, "", ""];
			};
			if (s_player_removeFlag < 0) then {
				s_player_removeFlag = player addaction [format[("<t color=""#F01313"">" + ("%1Permanently Remove Flag (restrictions apply)") +"</t>"),_adminText],"dayz_code\actions\player_remove.sqf", _flagBasePole,1,false,true,"",""];
			};
			if (bbAIGuards == 1) then {
				if (s_player_guardToggle < 0) then {
					s_player_guardToggle = player addaction [format[("<t color=""#FFFFFF"">" + ("%1Toggle Guards to Kill all non-base owners (default on)") +"</t>"),_adminText],"dayz_code\actions\toggle_base_guards.sqf",_flagBasePole,1,false,true,"",""];
				};
			};
		};
	} else {
		player removeAction s_player_removeFlag;
		s_player_removeFlag = -1;
		player removeAction s_player_addFlagAuth;
		s_player_addFlagAuth = -1;
		player removeAction s_player_removeFlagAuth;
		s_player_removeFlagAuth = -1;
		player removeAction s_player_guardToggle;
		s_player_guardToggle = -1;
	};
//####----####----####---- Base Building 1.3 END ----####----####----####

Now find

	//Allow player to delete objects
	if(_isDestructable and _hasToolbox and _canDo) then {
		if (s_player_deleteBuild < 0) then {
			s_player_deleteBuild = player addAction [format[localize "str_actions_delete",_text], "\z\addons\dayz_code\actions\remove.sqf",cursorTarget, 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_deleteBuild;
		s_player_deleteBuild = -1;
	};
	
Replace that with

//####----####----####---- Base Building 1.3 Start ----####----####----####
	_lever = cursorTarget;
	_codePanels = ["Infostand_2_EP1", "Fence_corrugated_plate"];
	_baseBuildAdmin = ((getPlayerUID player) in BBSuperAdminAccess);
	_baseBuildLAdmin = ((getPlayerUID player) in BBLowerAdminAccess);
	_authorizedUID = cursorTarget getVariable ["AuthorizedUID", []];
	_authorizedGateCodes = if ((_ownerID != "0") && (count _authorizedUID > 0)) then {((getPlayerUID player) in (_authorizedUID select 1));}; //Check it's not a map object/unbuilt object to avoid RPT spam
	_adminText = if (!_authorizedGateCodes && _baseBuildAdmin) then {"ADMIN:";}else{"";};//Let admins know they aren't registered
	
	//Let players check the UID of other players when near their flags
	if (_isMan && (_flagBasePole distance player < 10)) then {
	_ownerFlag = _flagBasePole getVariable ["characterID", "0"]; //Checks owner IDs of flags, simply to avoid RPT spam with map objects
	_flagAuthUID = _flagBasePole getVariable ["AuthorizedUID", []]; //Gets master AuthUID from 
	_flagAuthGateCodes = if (_ownerFlag != "0") then {((getPlayerUID player) in (_flagAuthUID select 1));}; //Checks if player has access to flag
	_adminText = if (!_flagAuthGateCodes && _baseBuildAdmin) then {"ADMIN:";}else{"";};//Let admins know they aren't registered
		if (_flagAuthGateCodes || _baseBuildAdmin) then {
			if (s_player_getTargetUID < 0) then {
				s_player_getTargetUID = player addAction [format["%1Get UID of Targeted Player",_adminText], "dayz_code\actions\get_player_UID.sqf", cursorTarget, 4, false, true, "", ""];
			};
		};
	} else {
		player removeAction s_player_getTargetUID;
		s_player_getTargetUID = -1;
	};
	
	// Operate Gates AND Add Authorization to Gate
	if (((typeOf(cursortarget) in _codePanels) && (_authorizedGateCodes || _baseBuildAdmin) && !remProc && !procBuild) || ((typeOf(cursortarget) in allbuildables_class) && (_authorizedGateCodes || _baseBuildAdmin) && !remProc && !procBuild)) then {
		_gates = nearestObjects [_lever, ["Concrete_Wall_EP1"], 15];
		if (s_player_gateActions < 0) then {
			if (typeOf(cursortarget) == "Fence_corrugated_plate") then {
					s_player_gateActions = player addAction [format[("<t color=""#FFF700"">" + ("%1Operate Single Metal Gate") +"</t>"),_adminText], "dayz_code\external\keypad\fnc_keyPad\operate_gates.sqf", _lever, 6, true, true, "", ""];
			} else {
				if (typeOf(cursortarget) == "Infostand_2_EP1") then {
					if (count _gates > 0) then {
						s_player_gateActions = player addAction [format[("<t color=""#FFF700"">" + ("%1Operate Nearest Concrete Gates Within 15 meters") +"</t>"),_adminText], "dayz_code\external\keypad\fnc_keyPad\operate_gates.sqf", _lever, 6, true, true, "", ""];
					} else {s_player_gateActions = player addAction [format[("<t color=""#FFF700"">" + ("%1No gates around to operate") +"</t>"),_adminText], "", _lever, 6, false, true, "", ""];};
				};
			};
		};
		if (s_player_giveBaseOwnerAccess < 0) then {
			s_player_giveBaseOwnerAccess = player addAction [format["%1Give all base owners (from flagpole) access to object/gate",_adminText], "dayz_code\external\keypad\fnc_keyPad\functions\give_gateAccess.sqf", _lever, 1, false, true, "", ""];
		};
		if (s_player_addGateAuthorization < 0) then {
			s_player_addGateAuthorization = player addAction [format["%1Add Player UIDs to Grant Gate/Object Access",_adminText], "dayz_code\external\keypad\fnc_keyPad\enterCodeAdd.sqf", _lever, 1, false, true, "", ""];
		};
		if (s_player_removeGateAuthorization < 0) then {
				s_player_removeGateAuthorization = player addaction [format[("<t color=""#F01313"">" + ("%1Remove Player UIDs from Gate/Object Access") +"</t>"),_adminText],"dayz_code\external\keypad\fnc_keyPad\enterCodeRemove.sqf", _lever, 1, false, true, "", ""];
		};
	} else {
		player removeAction s_player_giveBaseOwnerAccess;
		s_player_giveBaseOwnerAccess = -1;
		player removeAction s_player_gateActions;
		s_player_gateActions = -1;
		player removeAction s_player_addGateAuthorization;
		s_player_addGateAuthorization = -1;
		player removeAction s_player_removeGateAuthorization;
		s_player_removeGateAuthorization = -1;
	};
	// Operate ROOFS
	if ((typeOf(cursortarget) in _codePanels) && (_authorizedGateCodes || _baseBuildAdmin) && !remProc && !procBuild) then {
		_gates = nearestObjects [_lever, ["Land_Ind_Shed_01_main","Land_Ind_Shed_01_end","Land_Ind_SawMillPen"], BBFlagRadius];
		if (s_player_roofToggle < 0) then {
			if (typeOf(cursortarget) == "Infostand_2_EP1") then {
				if (count _gates > 0) then {
					s_player_roofToggle = player addAction [format[("<t color=""#FFF700"">" + ("%1Operate Roof Covers") +"</t>"),_adminText], "dayz_code\external\keypad\fnc_keyPad\operate_roofs.sqf", _lever, 6, false, true, "", ""];
				} else {s_player_roofToggle = player addAction [format[("<t color=""#FFF700"">" + ("%1No roof covers around to operate") +"</t>"),_adminText], "", _lever, 6, false, true, "", ""];};
			};
		};
	} else {
		player removeAction s_player_roofToggle;
		s_player_roofToggle = -1;
	};

	// Remove Object
	if((typeOf(cursortarget) in allremovables)&& (_ownerID != "0") && (_hasToolbox || _baseBuildAdmin || _baseBuildLAdmin) && _canDo && !remProc && !procBuild && !removeObject) then {
		if (s_player_deleteBuild < 0) then {
			s_player_deleteBuild = player addAction [format[localize "str_actions_delete",_text], "dayz_code\actions\player_remove.sqf",cursorTarget, 1, false, true, "", ""];
		};
	} else {
		player removeAction s_player_deleteBuild;
		s_player_deleteBuild = -1;
	};
	// Disarm Booby Trap Action
	if((cursortarget iskindof "Grave" && cursortarget distance player < 2.5) && (_ownerID != "0") && (_hasToolbox || _baseBuildAdmin || _baseBuildLAdmin) && _canDo && !remProc && !procBuild) then {
		if (s_player_disarmBomb < 0) then {
			s_player_disarmBomb = player addaction [format[("<t color=""#F01313"">" + ("%1Disarm Bomb") +"</t>"),_adminText],"dayz_code\actions\player_disarmBomb.sqf","",1,true,true,"", ""];
		};
	} else {
		player removeAction s_player_disarmBomb;
		s_player_disarmBomb = -1;
	};
	
	//Light Menu
	if((typeOf(cursortarget) == "Infostand_2_EP1") && (_authorizedGateCodes || _baseBuildAdmin) && !remProc && !procBuild) then {
		_nearestFlags = nearestObjects [_lever, [BBTypeOfFlag], BBFlagRadius];
		_baseFlag = _nearestFlags select 0;
		_barrels = nearestObjects [_baseFlag, ["Land_Fire_Barrel"], BBFlagRadius];//Makes sure there are barrels in range of the flag
		_towers = nearestObjects [_baseFlag, ["Land_Ind_IlluminantTower"], BBFlagRadius];//Makes sure there are towers in range of the flag
		if (count _barrels > 0 || count _towers >0) then {
			if (s_player_bbLightMenu < 0) then {
				s_player_bbLightMenu = player addAction [format[("<t color=""#4FF795"">" + ("%1Light Options") +"</t>"),_adminText], "dayz_code\actions\lights\lightMenu.sqf", _lever, 5, false, false, "", ""];
			};
		} else {
			if (s_player_bbLightMenu < 0) then {
				s_player_bbLightMenu = player addAction [format[("<t color=""#4FF795"">" + ("%1No Barrel/Tower Lights in Range of Flag") +"</t>"),_adminText], "", _lever, 5, false, true, "", ""];
			};
		};
	} else {
		player removeAction s_player_bbLightMenu;
		s_player_bbLightMenu = -1;
	};

	//Zombie Shield
	if ((typeOf(cursorTarget) == BBTypeOfZShield) &&(_authorizedGateCodes || _baseBuildAdmin) && !remProc && !procBuild) then {
		if (s_player_giveBaseOwnerAccess > 0) then { //Temp fix to prevent players having more than the max allowed number of shield gens
		player removeAction s_player_giveBaseOwnerAccess;
		s_player_giveBaseOwnerAccess = -1;
		};
		if (BBEnableZShield == 1) then {
			if (s_player_bbZombieShield_on < 0) then {
				s_player_bbZombieShield_on = player addAction [format[("<t color=""#FFF700"">" + ("%1Zombie Shield On") +"</t>"),_adminText], "dayz_code\actions\shield\bbZombieShield.sqf", [_lever, true], 6, true, true, "", ""];
			};
			if (s_player_bbZombieShield_off < 0) then {
				s_player_bbZombieShield_off = player addAction [format[("<t color=""#FFF700"">" + ("%1Zombie Shield Off") +"</t>"),_adminText], "dayz_code\actions\shield\bbZombieShield.sqf", [_lever, false], 6, false, true, "", ""];
			};
		} else {
			if (s_player_bbZombieShield_on < 0) then {
				s_player_bbZombieShield_on = player addAction [format[("<t color=""#FFF700"">" + ("%1Zombie Shields are disabled on this server") +"</t>"),_adminText], "", [], 6, false, true, "", ""];
			};
			player removeAction s_player_bbZombieShield_off;
			s_player_bbZombieShield_off = -1;
		};
	} else {
		player removeAction s_player_bbZombieShield_on;
		s_player_bbZombieShield_on = -1;
		player removeAction s_player_bbZombieShield_off;
		s_player_bbZombieShield_off = -1;
	};
//####----####----####---- Base Building 1.3 End ----####----####----####

	
Then find

	{dayz_myCursorTarget removeAction _x} forEach s_player_repairActions;s_player_repairActions = [];
	dayz_myCursorTarget = objNull;
	
After that, add

//####----####----####---- Base Building 1.3 Start ----####----####----####
	player removeAction s_player_getTargetUID;
	s_player_getTargetUID = -1;
	player removeAction s_player_giveBaseOwnerAccess;
	s_player_giveBaseOwnerAccess = -1;
	player removeAction s_player_gateActions;
	s_player_gateActions = -1;
	player removeAction s_player_roofToggle;
	s_player_roofToggle = -1;
	player removeAction s_player_addGateAuthorization;
	s_player_addGateAuthorization = -1;
	player removeAction s_player_removeGateAuthorization;
	s_player_removeGateAuthorization = -1;
	player removeAction s_player_disarmBomb;
	s_player_disarmBomb = -1;
	player removeAction s_player_bbZombieShield_on;
	s_player_bbZombieShield_on = -1;
	player removeAction s_player_bbZombieShield_off;
	s_player_bbZombieShield_off = -1;
	player removeAction s_player_inflameBarrels;
	s_player_inflameBarrels = -1;
	player removeAction s_player_deflameBarrels;
	s_player_deflameBarrels = -1;
	player removeAction s_player_towerLightsOn;
	s_player_towerLightsOn = -1;
	player removeAction s_player_towerLightsOff;
	s_player_towerLightsOff = -1;
	player removeAction s_player_bbLightMenu;
	s_player_bbLightMenu = -1;
//####----####----####---- Base Building 1.3 End ----####----####----####

Save and close!
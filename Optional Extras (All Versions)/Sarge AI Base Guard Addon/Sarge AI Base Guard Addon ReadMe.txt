THIS REQUIRES SARGE AI TO ALREADY BE INSTALLED
Only tested with Sarge AI v1.5.0, no support will be given for previous versions
****STEP 1 (Copying Files)****
Copy the 'Addons' folder to the root of your mission file

****STEP 2 (Modifying missionFolder\init.sqf)****
Find

[] execVM "addons\SARGE\SAR_AI_init.sqf";

After that, add

if (BBAIGuards == 1) then {
	//Base guards
	[] execVM "addons\SARGE\SAR_init_Base_guards.sqf";
};

****STEP 3 (Modifying missionFolder\addons\SARGE\SAR_AI_init.sqf)****
**A**
Find

SAR_AI_hit                        = compile preprocessFileLineNumbers "addons\SARGE\SAR_aihit.sqf";

After that, add

SAR_AI_base_trace                 = compile preprocessFileLineNumbers "addons\SARGE\SAR_trace_base_entities.sqf";

**B**
Find

SAR_AI_VEH_FIX              = compile preprocessFileLineNumbers "addons\SARGE\SAR_vehicle_fix.sqf";

After that, add

SAR_AI_GUARDS				= compile preprocessFileLineNumbers "addons\SARGE\SAR_setup_AI_patrol_guards.sqf";

****STEP 4 (Enabling Base Guards)****
Open missionFolder\dayz_code\init\variables.sqf

Find

BBAIGuards 					= 0; //Sarge AI Base Guards/ 1 = Enabled // 0 = Disabled (Will only work if running Sarge AI)

Change it to a 1.

That's all you need to do. XD
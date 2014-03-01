private["_pos","_object","_isBuildable"];
_pos = _this select 0;
#include "\z\addons\dayz_server\compile\server_toggle_debug.hpp"

{
	[_x, "gear"] call server_updateObject;
#ifdef OBJECT_DEBUG
diag_log(format["Updating nearby object at %1",_pos]);
#endif
} forEach nearestObjects [_pos, ["Car", "Helicopter", "Motorcycle", "Ship", "TentStorage", "StashSmall", "StashMedium"], 10];

//####----####----####---- Base Building 1.3 Start ----####----####----####
if (_isBuildable) then {
	//diag_log("_isBuildable was called!");
	//diag_log("CLASSNAME ARRAY: " + str(allbuildables_class) + "";);
	//diag_log("CLASSNAME ARRAY: " + str(allbuildables_class) + "");
//{
	//[_x, "gear"] call server_updateObject;
	//diag_log("BUILDABLES: updating " + str(_x) + " object!");
	
//} forEach nearestObjects [_pos, allbuildables_class, 300];
[_object, "gear"] call server_updateObject;
_isBuildable = false;
};
//####----####----####---- Base Building 1.3 End ----####----####----####
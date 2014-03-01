private ["_item","_classname","_require","_text","_location","_sfx","_object","_string","_onLadder","_isWater","_boundingBox","_maxPoint","_actionBuild","_actionCancel"];

call gear_ui_init;

closeDialog 1;

if (r_action_count != 1) exitWith { cutText [localize "str_player_actionslimit", "PLAIN DOWN"]; };

_item = _this;
_classname = getText (configFile >> "CfgMagazines" >> _item >> "ItemActions" >> "Build" >> "create");
_require = getText (configFile >> "CfgMagazines" >> _item >> "ItemActions" >> "Build" >> "require");
_text = getText (configFile >> "CfgVehicles" >> _classname >> "displayName");
_onLadder =		(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_isWater = 		(surfaceIsWater (getPosATL player)) or dayz_isSwimming;

if (_classname == "Wire_cat1" || _classname == "Hedgehog_DZ" || _classname == "Sandbag1_DZ" || _classname == "CamoNet_DZ") exitWith {
	r_action_count = 0;
	call player_build2;
};

if(_isWater) exitWith {
	r_action_count = 0;
	cutText [localize "str_player_26", "PLAIN DOWN"];
};

if(_onLadder) exitWith {
	r_action_count = 0;
	cutText [localize "str_player_21", "PLAIN DOWN"];
};

// item is missing
if ((!(_item IN magazines player))) exitWith {
	r_action_count = 0;
	_string = switch true do {
		case (_object isKindOf "Land_A_tent"): {"str_player_31_pitch"};
		default {"str_player_31_build"};
	};
	cutText [format[(localize "str_player_31"),_text,(localize _string)] , "PLAIN DOWN"];
	diag_log(format["player_build: item:%1 require:%2  Player items:%3  magazines:%4", _item, _require, (items player), (magazines player)]);
};

// tools are missing
if ((_require != "") and {(!(_require IN items player))}) exitWith {
	r_action_count = 0;
	cutText [format[(localize "str_player_31_missingtools"),_text,_require] , "PLAIN DOWN"];
};

if (!isNull (player getVariable "constructionObject")) exitWith {
	r_action_count = 0;
	cutText [localize "str_already_building", "PLAIN DOWN"];
};

player setVariable ["constructionObject", player]; //Quick fix to stop multi build bug

player removeMagazine _item;

cutText [localize "str_player_build_rotate", "PLAIN DOWN"];

_location = getMarkerpos "respawn_west";
_object = createVehicle [_classname, _location, [], 0, "NONE"];
_boundingBox = boundingBox _object;
_maxPoint = ([[0,0], _boundingBox select 1] call BIS_fnc_distance2D) + 1;
//_object attachTo [player, [0, _maxPoint + 1, 0]];

player setVariable ["constructionObject", _object];
_object setVariable ["characterID",dayz_characterID,true];

_sfx = switch true do {
	case (_object isKindOf "Land_A_tent"): {"tentunpack"};
	default {"repair"};
};

s_player_tent_build = player addAction [localize "str_player_build_complete", "\z\addons\dayz_code\actions\object_build.sqf", [_object, _item, _classname, _text, true, 20, _sfx], 1, true, true, "", "!isNull (_target getVariable [""constructionObject"", objNull])"];
s_player_tent_cancel = player addAction [localize "str_player_build_cancel", "\z\addons\dayz_code\actions\object_build.sqf", [_object, _item, _classname, _text, false, 0, "none"], 1, true, true, "", "!isNull (_target getVariable [""constructionObject"", objNull])"];

_position = [0,0,0];
while {!isNull (player getVariable "constructionObject")} do {
	if (vehicle player != player) then {
		player action ["eject", vehicle player];
	};
	
	if (speed player > 10 or speed player <= -8) then {
		cutText [localize "str_player_build_movingfast", "PLAIN DOWN"];
		player playMove "amovpercmstpssurwnondnon";
	};
	
	if (!((count ((getPosATL player) - _position)) == 0)) then {
		_position = getPosATL player;
		_object setPosATL [(_position select 0) + _maxPoint * sin(getDir player), (_position select 1) + _maxPoint * cos(getDir player), 0.01];
	};
	
	sleep 0.01;
		
	if ((!alive player) or {((getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1)}) then {
		[[],[],[],[_object, _item, _classname, _text, false, 0, "none"]] call object_build; 
	};
};

player removeAction s_player_tent_build;
player removeAction s_player_tent_cancel;
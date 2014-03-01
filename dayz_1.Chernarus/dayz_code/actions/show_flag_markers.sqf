_allFlags = nearestObjects [player, [BBTypeOfFlag], 25000];
_flagCount = 0;
_flagMarkerArr = [];
{
	if (typeOf(_x) == BBTypeOfFlag) then {
		_authorizedUID = _x getVariable ["AuthorizedUID", []];
		_authorizedPUID = _authorizedUID select 1;
		if ((getPlayerUid player) in _authorizedPUID) then {
			_flagCount = _flagCount + 1;
			if (_flagCount >= 1) then {
				_flagname = format ["Flag_%1",_x];
				_flagMarker = createMarkerLocal [_flagName,position _x];
				_flagMarker setMarkerTypeLocal "Town";
				_flagMarker setMarkerColorLocal("ColorGreen");
				_flagMarker setMarkerTextLocal format ["%1's Flag", (name player)];
				_flagMarkerArr = _flagMarkerArr + [_flagMarker];
				if (_flagCount < BBMaxPlayerFlags) then {
				cutText ["Check your map for flag locations. These will clear after 10 seconds.", "PLAIN DOWN"];
				} else {
				cutText [format ["You are registered to the maximum number of flags (%1). Check your map for flag locations. These will clear after 10 seconds.",BBMaxPlayerFlags], "PLAIN DOWN"];
				};
			};
		};
	};
} foreach _allFlags;
if (_flagCount == 0) then {
	cutText ["You are not registered on any base flags yet", "PLAIN DOWN"];
};
sleep 10;
{
	deleteMarkerLocal _x
} forEach _flagMarkerArr;

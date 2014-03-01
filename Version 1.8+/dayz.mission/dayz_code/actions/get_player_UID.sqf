private ["_targetPlayer","_targetPlayerUID"];
_targetPlayer = _this select 3;
_targetPlayerUID = (getPlayerUID _targetPlayer);
cutText [format["Target Player UID: %1", _targetPlayerUID], "PLAIN DOWN"];
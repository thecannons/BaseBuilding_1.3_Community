_object = _this select 3 select 0;;
_text = _this select 3 select 1;
builderChooses = true;
buildCancel = true;
detach _object;
deletevehicle _object;
cutText [format ["Build canceled for %1 object",_text], "PLAIN DOWN"];
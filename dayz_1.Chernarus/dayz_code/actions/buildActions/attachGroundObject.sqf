//Sets object to ground level, only really works with extendables
private["_object"];
_object = _this select 3;
objectHeight=0;
_object setpos [(getposATL _object select 0),(getposATL _object select 1), 0];
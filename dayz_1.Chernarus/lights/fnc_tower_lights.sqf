private["_tl","_twr","_lCol","_lbrt","_lamb","_oset","_twrPos","_rad","_a","_b","_ang","_nrTLs","_doLit"];
_twr = _this select 3 select 0;
_lCol = _this select 0;
_lbrt = _this select 1;
_lamb = _this select 2;
_doLit = _this select 4 select 0;
_twrPos =  getPos _twr;
_rad=2.65;
_oset=14;
_nrTLs= position _twr nearObjects ["#lightpoint",30];
if(count _nrTLs > 3)then{
{
    if(_doLit)then{
    _x setLightColor _lCol;
    _x setLightBrightness _lbrt;
    _x setLightAmbient _lamb;
    }else{
    deleteVehicle _x;
    };
sleep .2;
}forEach _nrTLs;
}else{
    if(_doLit)then{
        for "_tls" from 1 to 4 do {
        _ang=(360 * _tls / 4)-_oset;
        _a = (_twrPos select 0)+(_rad * cos(_ang));
        _b = (_twrPos select 1)+(_rad * sin(_ang));
        _tl = "#lightpoint" createVehicle [_a,_b,(_twrPos select 2) + 26] ;
        _tl setLightColor _lCol;
        _tl setLightBrightness _lbrt;
        _tl setLightAmbient _lamb;
        _tl setDir _ang;
        _tl setVectorUp [0,0,-1];
        sleep .4;
        };
    };
};
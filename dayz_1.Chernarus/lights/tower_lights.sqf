//All rights reserved Andrew Gregory aka axeman axeman@thefreezer.co.uk
waitUntil {!isNull player};
private ["_nrTowers","_rng","_nrPl","_lCol","_lbrt","_lamb","_twrCl","_stHr","_fnHr","_ndGen","_nrGen","_rngGen","_genCls","_doLit","_gnCnt"];
//Can edit these values
_rng = 1200; //Distance from survivor to detect towers.
_lCol = [1, 0.88, 0.73]; // Colour of lights on tower when directly looked at | RGB Value from 0 to 1.
_lbrt = 0.04;//Brightness (also visible distance) of light source.
_lamb = [1, 0.88, 0.73]; // Colour of surrounding (ambient) light | RGB Value from 0 to 1.
_twrCl = "Land_Ind_IlluminantTower";
_stHr = 17;//Hour (in 24 hours) to start lighting up tower
_fnHr = 6;//Hour (in 24 hours) to stop lighting up tower
_ndGen = false;//Require a Generator ? An entity, set by _genCls, must be within a radius (in metres), set by_rngGen, for the towerlights to be lit.
_rngGen = 1800;//Generator range (Generator must be within this radius from the tower for towerlights to be lit)
_genCls = "PowerGenerator_EP1";//Class name of generator (TEsted PowerGenerator_EP1 & PowerGenerator)
//End Edit Values
fnc_axeTl = compile preprocessFileLineNumbers "lights\fnc_tower_lights.sqf";
while {alive player}
do
{
    if(daytime<_fnHr||daytime>_stHr)then{
    _nrPl = vehicle player;
    _nrTowers = nearestObjects [_nrPl, [_twrCl], _rng];
        {
		if ((_x getVariable ["characterID", "0"]) == "0") then {
        _doLit=true;
            if(_ndGen)then{
            _nrGen = (position _x) nearEntities [_genCls,_rngGen];
            _gnCnt = count _nrGen;
                if(_gnCnt < 1)then{
                _doLit=false;
                };
            };
        [_lCol,_lbrt,_lamb,[_x],[_doLit]] call fnc_axeTl;
		};
        }forEach _nrTowers;
    };
sleep .5;
};
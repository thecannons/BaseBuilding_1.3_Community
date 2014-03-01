fnc_debug = {
    debugMonitor = true;
    while {debugMonitor} do
    {
        _kills =        player getVariable["zombieKills",0];
        _killsH =        player getVariable["humanKills",0];
        _killsB =        player getVariable["banditKills",0];
        _humanity =        player getVariable["humanity",0];
        _headShots =    player getVariable["headShots",0];
        _zombies =              count entities "zZombie_Base";
        _zombiesA =    {alive _x} count entities "zZombie_Base";
        _banditCount = {(isPlayer _x) && ((_x getVariable ["humanity",0]) < 0)} count playableUnits;
        _heroCount  = {(isPlayer _x) && ((_x getVariable ["humanity",0]) >= 5000)} count playableUnits;
        _pic = (gettext (configFile >> 'CfgVehicles' >> (typeof vehicle player) >> 'picture'));
		//####----####----BB 1.3 Flag Count----####----####
		_flagCount = 0;
		_allFlags = nearestObjects [player, [BBTypeOfFlag], 25000];
		{
			if (typeOf(_x) == BBTypeOfFlag) then {
				_authorizedUID = _x getVariable ["AuthorizedUID", []];
				_authorizedPUID = _authorizedUID select 1;
				if ((getPlayerUid player) in _authorizedPUID) then {
					_flagCount = _flagCount + 1;
				};
			};
		} foreach _allFlags;
		//####----####----BB 1.3 Flag Count----####----####
		
            if (player == vehicle player) then
            {
                _pic = (gettext (configFile >> 'cfgWeapons' >> (currentWeapon player) >> 'picture'));
            }
                else
            {
                _pic = (gettext (configFile >> 'CfgVehicles' >> (typeof vehicle player) >> 'picture'));
            };
        hintSilent parseText format ["
        <t size='1'font='Bitstream'align='center' color='#EE0000' >%1</t><br/>
        <t size='1'font='Bitstream'align='left' color='#EE0000' >Blood Left:</t><t size='1' font='Bitstream'align='right' color='#EE0000' >%2</t><br/>
        <t size='1'font='Bitstream'align='left' color='#ff8810' >Humanity:</t><t size='1'font='Bitstream'align='right' color='#ff8810' >%3</t><br/>
        <t size='1'font='Bitstream'align='left' color='#EEC900' >Humans Killed:</t><t size='1'font='Bitstream'align='right' color='#EEC900' >%4</t><br/>
        <t size='1'font='Bitstream'align='left' color='#EEC900' >Bandits Killed:</t><t size='1'font='Bitstream'align='right' color='#EEC900' >%5</t><br/>
        <t size='1'font='Bitstream'align='left' color='#EEC900' >Zombies Killed:</t><t size='1'font='Bitstream'align='right' color='#EEC900' >%6</t><br/>
        <t size='1'font='Bitstream'align='left' color='#EEC900' >Head Shots:</t><t size='1'font='Bitstream'align='right' color='#EEC900' >%7</t><br/>
        <t size='1' font='Bitstream' align='left' color='#EEC900' >Zombies (Alive/Total): </t><t size='1' font='Bitstream' align='right' color='#EEC900' >%9/%8</t><br/>
        <t size='1'font='Bitstream'align='left' color='#ff8810' >Current Hero Count:</t><t size='1'font='Bitstream'align='right' color='#ff8810' >%11</t><br/>
        <t size='1'font='Bitstream'align='left' color='#ff8810' >Current Bandit Count:</t><t size='1'font='Bitstream'align='right' color='#ff8810' >%10</t><br/>
        <t size='1'font='Bitstream'align='left' color='#EEC900' >Base Flags (Owned/Max):</t><t size='1'font='Bitstream'align='right' color='#EEC900' >%13/%14</t><br/>
        <img size='3' image='%12'/><br/>
        <t size='1'font='Bitstream'align='center' color='#ff8810' >Press F10 to toggle! </t><br/>
        <t size='1'font='Bitstream'align='center' color='#ff8810' >Holo Fed Community Server </t><br/>
 
        ",dayz_playerName,r_player_blood,round _humanity,_killsH,_killsB,_kills,_headShots,count entities "zZombie_Base",{alive _x} count entities "zZombie_Base",_banditCount,_heroCount,_pic,_flagCount,BBMaxPlayerFlags];
    sleep 1;
    };
};[] spawn fnc_debug;
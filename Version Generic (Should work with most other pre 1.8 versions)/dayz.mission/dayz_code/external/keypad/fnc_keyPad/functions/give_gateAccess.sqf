private["_character","_id","_obj","_authorizedUID","_authorizedPUID","_authorizedOUID","_updatedAuthorizedUID","_allFlags","_objAuth","_objAuthWhole","_objAuth","_newAuth"];
_character = _this select 1;
_id = _this select 2;
_obj = _this select 3;
_allFlags = nearestObjects [_obj, [BBTypeOfFlag], BBFlagRadius];
		{
				_authorizedUID = _x getVariable ["AuthorizedUID", []];
				_authorizedPUID = _authorizedUID select 1;
				if (((getPlayerUid _character) in _authorizedPUID && typeOf(_x) == BBTypeOfFlag) || (((getPlayerUID player) in BBSuperAdminAccess) && typeOf(_x) == BBTypeOfFlag)) then {
					_objAuthWhole = _obj getVariable ["AuthorizedUID", []];
					_objAuthOUID = _objAuthWhole select 0;
					_objAuth = _objAuthWhole select 1;
					_newAuth = 0;
						{
							if (!(_x in _objAuth)) then {
								_objAuth set [count _objAuth, _x];
								_newAuth = _newAuth + 1;
							};
						} forEach _authorizedPUID;
					if (_newAuth > 0) then {
						_obj setVariable ["AuthorizedUID", ([_objAuthOUID] + [_objAuth]), true];
						//Send to database
						dayzUpdateVehicle = [_obj,"gear"];
						publicVariableServer "dayzUpdateVehicle";
					
						if (isServer) then {
							dayzUpdateVehicle call server_updateObject;
						};
					};
					if (_newAuth > 0) then {
						bbCDebug = missionNameSpace getVariable [format["%1",BBCustomDebug],false];
						if (bbCDebug) then {missionNameSpace setVariable [format["%1",BBCustomDebug],false]; hintSilent ""; bbCDReload = 1;};
						hintsilent parseText format ["
						<t align='center' color='#00FF3C'>SUCCESS</t><br/><br/>
						<t align='left'>You gave access to the following base owners player UIDs:</t><br/>
						<t align='left'>%1</t><br/>
						",str(_objAuth)];
						sleep 5;
						hint "";
						if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",BBCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};
					} else {
						cutText ["Everyone already has access to this object", "PLAIN DOWN"];
						sleep 5;
						if(bbCDReload == 1)then{missionNameSpace setVariable [format["%1",BBCustomDebug],true];[] spawn fnc_debug;bbCDReload=0;};
					};
				};
		} foreach _allFlags;
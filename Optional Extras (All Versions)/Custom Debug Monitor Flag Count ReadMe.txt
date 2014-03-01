THIS IS NOT A CUSTOM DEBUG MONITOR
All this will do is add a flag count for the player on your existing custom debug monitor

****STEP 1 (Locate and Open your custom debug monitor file)****
This is usually called something like custom_monitor.sqf or custom_debug.sqf

****STEP 2 (Make the additions)****
**A**
Under where the other variables are calculated, you need to add

		//####----####----BB 1.3 Flag Count----####----####
		_flagCount = 0;
		_allFlags = nearestObjects [player, [BBTypeOfFlag], 25000];
		{
			if (typeOf(_x) == BBTypeOfFlag) then {
				_authorizedUID = _x getVariable ["AuthorizedUID", []];
				_authorizedPUID = if (count _authorizedUID > 0) then {_authorizedUID select 1;};
				if ((getPlayerUid player) in _authorizedPUID) then {
					_flagCount = _flagCount + 1;
				};
			};
		} foreach _allFlags;
		//####----####----BB 1.3 Flag Count----####----####
		
**B**
Now add a line something like this in with the other lines to be displayed (you can copy paste this line and edit it as needed)

<t size='1'font='Bitstream'align='left' color='#EEC900' >Base Flags (Owned/Max):</t><t size='1'font='Bitstream'align='right' color='#EEC900' >%13/%14</t><br/>

**C**

The %13 and %14 at the end of the line are place holders, these will be replaced by variables which you need to add to the end of the list of existing variables. 
The variables will be after the closing " mark, then listed seperated by commas.
Add this to the end of the list

,_flagCount,BBMaxPlayerFlags

Now, you will need to count how many variables are in the list and change %13 and %14 to match the count.
So if on yours the new variables are third and fourth in the list, you would change them to %3 and %4.

Save and close! XD
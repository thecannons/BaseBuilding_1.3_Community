All of these edits are to be made in the dayz_mission.pbo (mission file name may vary)

****STEP 1 (Copying Files)****

First, unpack your mission file.
Now from the Base Building zip\dayz.mission\, copy over the following
buildRecipeBook 				(Folder)
dayz_code						(Folder)
build_recipe_dialog.hpp			(File)
build_recipe_dialog_list.hpp	(File)
defines.hpp						(File)

****STEP 2 (Modifying init.sqf)****
**A**
Find

progressLoadingScreen 0.1;

Directly ABOVE that, add (This placement is VERY important, if it's not in the right place you may not be able to connect to the server!)

call compile preprocessFileLineNumbers "dayz_code\init\variables.sqf";							//Initializes custom variables

**B**
Now Find

progressLoadingScreen 1.0;
	
Directly ABOVE that, add

call compile preprocessFileLineNumbers "dayz_code\init\compiles.sqf";							//Compile custom compiles
call compile preprocessFileLineNumbers "dayz_code\init\settings.sqf";							//Initialize custom clientside settings
	
Save and close

****STEP 3 (Modifying description.ext)****
**A**
At the very top of the file, add

//####----####---- Base Building Start ----####----####
#include "defines.hpp"
#include "build_recipe_dialog.hpp"
#include "build_recipe_list_dialog.hpp"
//####----####---- Base Building End ----####----####

**B**
Then, remove ALL of this

###REMOVE START###
class RscText
{
	type = 0;
	idc = -1;
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	style = 0x100; 
	font = Zeppelin32;
	SizeEx = 0.03921;
	colorText[] = {1,1,1,1};
	colorBackground[] = {0, 0, 0, 0};
	linespacing = 1;
};
class RscPicture
{
	access=0;
	type=0;
	idc=-1;
	style=48;
	colorBackground[]={0,0,0,0};
	colorText[]={1,1,1,1};
	font="TahomaB";
	sizeEx=0;
	lineSpacing=0;
	text="";
};
class RscLoadingText : RscText
{
	style = 2;
	x = 0.323532;
	y = 0.666672;
	w = 0.352944;
	h = 0.039216;
	sizeEx = 0.03921;
	colorText[] = {0.543,0.5742,0.4102,1.0};
};
class RscProgress
{
	x = 0.344;
	y = 0.619;
	w = 0.313726;
	h = 0.0261438;
	texture = "\ca\ui\data\loadscreen_progressbar_ca.paa";
	colorFrame[] = {0,0,0,0};
	colorBar[] = {1,1,1,1};
};
class RscProgressNotFreeze
{
	idc = -1;
	type = 45;
	style = 0;
	x = 0.022059;
	y = 0.911772;
	w = 0.029412;
	h = 0.039216;
	texture = "#(argb,8,8,3)color(0,0,0,0)";
};
###REMOVE END####

Save and close

****STEP 4 (Modifying fn_selfActions.sqf)****
If you do NOT already have a custom fn_selfActions.sqf, you will need to get a copy for your map/mod.
To get the file, locate your local Arma 2 install then navigate to:
@yourmodname\addons\dayz_code.pbo\compile\
Now COPY the fn_selfActions.sqf to your mission file and place it in
YourMissionFile\dayz_code\compile\
Now open the fn_selfActions ReadMe and follow the instructions there.

If you DO already have a custom fn_selfActions.sqf, refer to the fn_selfActions ReadMe for instructions.
Then open dayz_mission\dayz_code\init\compiles.sqf
Find this and delete it
//Custom Self Actions File
fnc_usec_selfActions = compile preprocessFileLineNumbers "dayz_code\compile\fn_selfActions.sqf";

****STEP 5 (Adding Keybinds)****
**A**
Firstly, you will need to locate your local Arma 2 install then navigate to:
@yourmodname\addons\dayz_code.pbo\init\compiles.sqf

In compiles.sqf, find

dayz_spaceInterrupt = {
	load of code inside
};

Select that section and COPY it

Now open yourMissionFile\dayz_code\init\compiles.sqf (We copied this over earlier)
At the bottom of the file, PASTE the dayz_spaceInterrupt code

**B**
Then, above 

		_handled
	};
	
Add

	//Keybinds for Base Building
		_shiftState = _this select 2;
		//Elevate NumPad 8
		if ((_dikCode == 0x48) && !_shiftState) then {
			DZ_BB_E = true;
			_handled = true;
		};
		//Lower NumPad 5
		if ((_dikCode == 0x4C) && !_shiftState) then {
			DZ_BB_L = true;
			_handled = true;
		};
		//Elevate Small shift + NumPad 8
		if (_dikCode == 0x48) then {
			DZ_BB_Es = true;
			_handled = true;
		};
		//Lower Small shift + NumPad 5
		if (_dikCode == 0x4C) then {
			DZ_BB_Ls = true;
			_handled = true;
		};
		//Rotate Left NumPad 7
		if ((_dikCode == 0x47) && !_shiftState) then {
			DZ_BB_Rl = true;
			_handled = true;
		};
		//Rotate Right NumPad 9
		if ((_dikCode == 0x49) && !_shiftState) then {
			DZ_BB_Rr = true;
			_handled = true;
		};
		//Rotate Left Small Shift + NumPad 7
		if (_dikCode == 0x47) then {
			DZ_BB_Rls = true;
			_handled = true;
		};
		//Rotate Right Small Shift + NumPad 9
		if (_dikCode == 0x49) then {
			DZ_BB_Rrs = true;
			_handled = true;
		};
		//Push Away NumPad 4
		if (_dikCode == 0x4B) then {
			DZ_BB_A = true;
			_handled = true;
		};
		//Pull Near NumPad 1
		if (_dikCode == 0x4F) then {
			DZ_BB_N = true;
			_handled = true;
		};
		//Move Left NumPad 2
		if (_dikCode == 0x50) then {
			DZ_BB_Le = true;
			_handled = true;
		};
		//Move Right NumPad 3
		if (_dikCode == 0x51) then {
			DZ_BB_Ri = true;
			_handled = true;
		};
		
Save and Close

****STEP 6 (player_build2.sqf)****
If you would like base building to ignore combat checks and not place players into combat when they finish building, skip this step.

If you would prefer base building to place players into combat upon completion or cancelling a build, delete player_build2.sqf and rename player_build2 - Combat System to player_build2.sqf

****Now refer to Generic DayZ_Server ReadMe.txt****
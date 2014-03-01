This will give a quick guide to disable Loot and or Zombie spawns at base building objects.

Run CUSTOM LOOT tables already? Skip to Step 3!

****Step 1 Getting player_spawnCheck.sqf****
In your dayz_code.pbo\compiles\
Copy the file 'player_spawnCheck.sqf'

Paste the file into missionFolder\dayz_code\compiles\

****Step 2 Change compiles.sqf****
Open missionFolder\dayz_code\init\compiles.sqf

Find this line

//player_spawnCheck = compile preprocessFileLineNumbers "dayz_code\compile\player_spawnCheck.sqf";

Remove the // from the front of it

****Step 3 Making your choice****
You have three options at this point,
Option 1 = Disable both Loot AND Zombie spawns at base building objects
Option 2 = Disable ONLY loot at base building objects
Option 3 = Disabled ONLY zombies at base building objects

Recommended option is 1, unless you plan to use the base building zombie shields in which case we recommend option 2.

***Option 1***
Open missionFolder\dayz_code\compiles\player_spawnCheck.sqf (location may vary if you run custom loot tables)

**A**
Find this line

if (_canSpawn) then {

Above that, add

if ((_x getVariable ["characterID", "0"]) == "0") then {

**B**
Now Find

} forEach _nearby;

Above that, add

};

Save and close.

***Option 2***
Open missionFolder\dayz_code\compiles\player_spawnCheck.sqf (location may vary if you run custom loot tables)

**A**
Find this line

if (_canSpawn) then {

After that, add

if ((_x getVariable ["characterID", "0"]) == "0") then {

**B**
Now Find

	//Zeds
		if (_dis > _spawnZedRadius) then {
		
Above that, add

};

Save and close.

***Option 3***
Open missionFolder\dayz_code\compiles\player_spawnCheck.sqf (location may vary if you run custom loot tables)

**A**
Find this line

if (_dis > _spawnZedRadius) then {

Above that, add

if ((_x getVariable ["characterID", "0"]) == "0") then {

**B**
Now Find

	};
} forEach _nearby;

Above that, add

};

Save and close.
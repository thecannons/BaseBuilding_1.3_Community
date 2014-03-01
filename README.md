## BaseBuilding-DayZ ##


Base Building DayZ Project.  This adds a building function in DayZ mod regardless of map.<br>

**I will be providing minimal support for anyone modifying the existing code.  If you have any questions, please message me on git or email me at daimyo21mods@gmail.com**

### Base Building Full Features List: ###

- Ability to build 30+ Arma 2/OA Objects in DayZ and create your ultimate base with your friends
- Buildable Recipe Menu with pictures and Information
- Gate Panels with Keypad access to open and close gates
- Buildable Booby Traps that blow up in 10 meter proximity, crawl to avoid!
- Custom disarm bomb action, with chance to fail based on not having toolbox/entrench tool
- AntiWall feature that doesnt allow players to exit out of vehicles into player made bases.
- Custom buildable removal function with chance to lose toolbox
- Detailed parameters allowing server owners to dictate where things can be built, if they are invincible, etc etc.
- Integrated into DayZ code
- Server restart compatible
- Virtually compatible with any DayZ map.
- Server side Update object feature to allow active player bases to stay updated for cleanup script.

#### Base Building - DayZ 1.3 Changelog

- Optimizations to code and functionality<br>
- Enhanced building placement mechanic<br>
- Expanded build recipe menu (and new item requirements 1.8+ ONLY)<br>
- No more entering codes, they've been replaced by a one time entry of player UIDs<br>
- No more broken removals (we now store the object UID in an array, so they can always be removed)<br>
- Booby Traps work! They will now only detonate with players who aren't marked as friendly<br>
- Base Flags, build a flag and you and your friends can build within a 200 metre radius<br>
- Shared ownership, you can share the stored flag player UIDs with any base building item you own, your friends can then use/remove that item as if it was theirs<br>
- Roofs! There is now a roof option to build, these can be toggled on/off like the gates<br>
- Lights! Place barrels around your base and toggle them on/off to light it up at night<br>
- More Lights! Thanks to a modified version of AxeMan's tower lighting script, players can build and toggle tower lighting around their base!<br>
- Optional AI Base Guards (Requires Sarge AI, only tested with v1.5.0 no support will be given for older versions)<br>
- Zombie Shield. Tired of pesky zombies spawning in your base? No problem! Build a zombie shield generator, supply it with power from a generator and activate for peace of mind, and flesh.<br>
- Customisation is key. For server admins we've made use of master variables for a lot of options to make customising BB for your server much easier and these can all be found in one file! 
<br><br>

### RECOMMENDED TO GET STARTED ###


- [Notepad++](http://notepad-plus-plus.org/download/v6.3.html)<br>
- [Notepad++ Compare Plugin](http://sourceforge.net/projects/npp-compare/)<br>
- [Arma 2 SQF Syntax Highlights for Notepad++ HIGHLY RECOMMENDED](http://forums.bistudio.com/showthread.php?91939-Notepad-SQF-syntax-highlight)<br>
### REQUIRED BEFORE INSTALLATION TUTORIAL ###

- **PBO View** (or equivalent pbo tool) --  [http://www.armaholic.com/page.php?id=1434](http://www.armaholic.com/page.php?id=1434)<br>
- **YOUR** servers **`dayz_1.YOURWORLD.pbo`** mission file<br>
- **YOUR** servers **`dayz_server.pbo`** hive server file<br>

## Installation Tutorial ##

**If you know how to unpbo and pbo your mission/server files, skip past step 6<br>**
1. Open PBO View<br>
2. Click Unpack at top (or `Ctrl + U`)<br>
3. Browse harddrive for YOUR **dayz\_1.YOURWORLD.pbo** mission file, select it and `click open`<br>
5. Do this for YOUR **dayz\_server.pbo** file too.<br>
6. Now youll have **YOUR server file** and **YOURWORLD mission file** unpbo'd<br>

##Part 1 - The Basics:
- Download the master branch from [https://github.com/Daimyo21/BaseBuilding-DayZ/archive/master.zip](https://github.com/Daimyo21/BaseBuilding-DayZ/archive/master.zip)<br>

- Extract to folder of your choice.<br>

- Inside you'll find folders for specific versions of DayZ (Only pay attention to the folder for the version you are running)<br><br>


##Part 2 - dayz\_1.world folder:

- Inside your version specific folder, follow the instructions in DayZ Mission ReadMe.txt<br>

##Part 3 - dayz\_server folder:

- Inside your version specific folder, follow the instructions in DayZ Server ReadMe.txt<br>

##Part 4 - BattlEye Filters:

- Inside your version specific folder, reference the BE Filter Changes.txt<br>

##Part 5 - SQL Update:

- NOTE: Epoch version only requires an SQL update if you are updating from Base Building 1.2!!
- Read the Database ReadMe for your database version in the database folder.<br>
- In MYSQL Workbench (or whatever you use to manage DB): <br>
- Set your default schema (the database you want to execute scripts on) <br>
- If you are updating from Base Building 1.2, then select either 'updateInstall_reality_basebuilding.sql' or 'updateInstall_hive_basebuilding.sql' and execute it<br>
- If you are doing a fresh install, select either 'newInstall_reality_basebuilding.sql' or 'newInstall_hive_basebuilding.sql' and execute it<br><br>


###Enjoy Building your new base!

##Modifying Buildable Parameters##
###build_list.sqf:

- **Found in:
"dayz\_1.world\dayz\_code\external\dy\_work\build\_list.sqf"**

This is the file used to modify parameters such as:

- Recipe requirements
- _toolBox required?
- _eTool required?
- _medWait, _longWait (how long to build, if neither, then _smallWait)
-  _inBuilding allowed?
-  _roadAllowed ?
-  _inTown ?
-  _removable (can it be removed by default removal?)
-  _isStructure (is the buildable a structure?
-  _isSimulated (does it have physics?) 
-  _isDestructable (can it be destroyed?)

Alternatively, if you modify any of these parameters, they are **ONLY client side**.  In order to make sure these parameters stay persistent on server restart, you must modify the:

>build\_baseBuilding\_arrays = { BUNCH OF CODE SIMILAR TO BUILD_LIST.sqf };

Found in the **"dayz\_server\init\server\_functions.sqf"** that we installed earlier

You can simply copy and paste the:

>_buildlist = [ ENTIRE ARRAY WITH PARAMETERS YOU CHANGED ];

from **"dayz\_1.world\dayz\_code\external\dy\_work\build\_list.sqf"**

Into the server\_functions.sqf's 
**\_buildlist = [ SERVER BUILD LIST ARRAY ];**

Detailed information can be found inside the build_list.sqf  itself on how to modify these parameter arrays!

## Other Scripts

####player_bomb.sqf 
found in **dayz\_1.world\dayz\_code\external\dy\_work\player\_bomb.sqf**

Controls functionality of player placed bombs, modify at your own risk!

####anti_discWall.sqf
Anti measure for player exploits into walls
####antiWall.sqf
When player gets out of vehicle, it teleports him into the vehicle he was getting out of to counter he/she glitching through walls.

####dialog_menus by W4rGo
I recommend not modifying this and you must have permission from [**W4rGo**](https://github.com/w4rgo) to do so.


<br><br>
##CREDITS:

- [**Simple bomb script by Igneous01**](http://forums.bistudio.com/showthread.php?123621-Simple-Bomb-defusal-with-keypad):
- [**W4rGo**](https://github.com/w4rgo) for his excellent Build Recipe Menu Dialog
- Operational Gates by Humbleuk and Killzone Kid modified <br>
- DayZ Code from “Rocket” Dean Hall and DayZ community team<br>
- Code conversion algorithm for keypanel access by Xeno<br>
- AxeMan for his original Tower Lighting script<br>
- Killzone Kid, Humbleuk and Ashfor for all their work/inspiration and any code utilized in this - release.<br>
- Ayan4m1/Bliss team Server Package and support<br>
- Entire DayZ community that help with coding and custom hooks/scripts/server support<br>

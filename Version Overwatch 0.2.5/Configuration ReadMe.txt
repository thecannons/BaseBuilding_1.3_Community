ALL SETTINGS DISCUSSED HERE ARE LOCATED IN missionFolder\dayz_code\init\variables.sqf
This file just provides a more detailed explanation of what these variables do.

****BBSuperAdminAccess****
Any playerUIDs added to this array will have full access to all Base Building items.
Admins can access any built item even if they aren't registered to use it (if they are not registered, the options will be prefixed with ADMIN:)

Admins also have the ability to add/remove player UIDs from objects they do not own so they can offer assistance to players.
Be careful with whom you give this access to as it is a very powerful function and you don't want to give it to people you don't fully trust.

****BBLowerAdminAccess****
This array contains lower level admins.
These admins will only have access to remove any base build object, but will not have access to any other options.

****BBTypeOfFlag****
Default Value: "FlagCarrierBIS_EP1"

This tells the server what flag type to use for base building.
If you change this after flags have already been built, then the existing flags will be updated at the next restart.
Available options for this variable are listed in BBAllFlagTypes.

****BBAllFlagTypes****
This is a full list of possible flags for Base Building to use. Only one may be used at a time and is set via the above variable.
If you want to add a flag which isn't already listed, then you will need to add it to this array, as well as to BBTypeOfFlag. 
You will also need to add a picture for it in missionFolder\buildRecipeBook\images\buildable\
Plus, you will need to add the new flag type to the SafeObjects array and to your Database.

****BBMaxPlayerFlags****
Default Value: 3

This variable sets how many base building flags a player can be added to.
This includes flags they build themselves, and flags their friends have added them to.

****BBFlagRadius****
Default Value: 200

This sets the radius around a flag in which players can build.
It is advisable not to set this too high because other people cannot build within this radius unless they are added to the flag.
Also, keep in mind that with a radius of 200, the next nearest flag would have to be 400 meters away.

****BBtblProb****
This sets the base chance level for losing a toolbox if player fails to remove an item they do not own.
This is increased by 40 for items which take a 'long' time to remove.
It is increased by 20 for items which take a 'medium' time to remove.

****BBlowP****
This sets the base chance level for removing an item the player does not own if it uses a 'short' removal time.

****BBmedP****
This sets the base chance level for removing an item the player does not own if it uses a 'medium' removal time.

****BBhighP****
This sets the base chance level for removing an item the player does not own if it uses a 'long' removal time.

****BBEnableZShield****
Default Value: 1

This enables or disables toggleable zombie shield generators. If disabled, players can still build the objects but they wont be able to trun them on. We added this option simply because a lot of base build buildings generate zombies, which can be a pain for players.

****BBTypeOfZShield****
Default Value: "CDF_WarfareBUAVterminal"

This is the object that will be used as a zombie shield generator. If you run a map which blocks this object, you can change it to something else. If changed, any already built items will be transformed during the next server restart.

****BBAllZShieldTypes****
This is a full list of possible zombie shield generators. Currently it only has one item, but if you change BBTypeOfZShield you will need to add the new object to this array also.
You will also need to add a picture for it in missionFolder\buildRecipeBook\images\buildable\
Plus, you will need to add the new generator type to the SafeObjects array and to your Database.

****BBMaxZShields****
Default Value: 1

This sets how many zombie shield generators a player can be associated with, whether they own it or have their UID added to the object. It's probably a good idea to keep this number rather low to stop people using them all over the map.

****BBZShieldRadius****
Default Value: 50

This sets the radius of effect an active zombie shield generator will have. You don't want to set this too high.

****BBZShieldClean****
Default Value: 0

When set to 1, this option will delete zombies within an active shield radius. If set to 0, it will simply kill the zombies but not remove their bodies. You should set this to 1 if you want to avoid zombie loot farming.

****BBZShieldDis****
Default Value: 1

When set to 1, this option limits the build radius of shield generators to (BBFlagRadius - BBZShieldRadius). So if your flag radius is 200 and your shield radius is 50, then players could only build a shield generator at a maximum distance of 150 meters from their flag. This helps to avoid people building one right on the edge of their flag radius to kill zombies out with their base.
If you reduce the flag radius or increase the shield radius, you may need to disable this option.

****BBAIGuards****
Default Value: 0

This setting enables AI base guards. (REQUIRES SARGE AI, only tested with v1.5.0, no support will be given for previous versions)
Guard numbers increase with the size of the base around the flag, minimum number of guards is 3, maximum is 6.
These numbers can be adjusted in missionFolder\Addons\SARGE\SAR_init_Base_guards.sqf

Default guard behaviour is to attack anybody in range who is not added to the flag.
Players can toggle this behaviour so the guards will only attack people who attack them, this means they could still have people visit their base for trading or what not.

Installation instructions are included in the 'Optional Extras' folder.

****BBUseTowerLights****
Default Value: 1

Thanks to AxeMan's tower lighting script, we've added the ability for players to build light towers in their base. If they also build a generator they can then toggle the tower lighting on or off. 

If you already run AxeMan's Illuminant Tower Lighting script, you will need to follow the readme in 'Optional Extras' to change it so it will ignore base build tower lights. 
If you run AxeMan's Illuminant Tower Lighting script and want the towers to just come on at night with the rest of the map towers, set this value to 0 and make no further edits.

****BBCustomDebug****
Default Value: "debugMonitor"
This is a 'special' variable.

If you run a custom debug monitor which has a toggle function, you need to replace debugMonitor with the variable used by your specific debug monitor.

To find the name of this value, open your custom debug monitor file
Now near the top there should be a line something like this

while {ImportantVariableNameHere} do

Simply copy that variable name to the BBCustomDebug

This allows Base Building to hide your custom debug monitor when it needs to display hint windows for building, adding/removing UIDs, etc. 

If you do not run a custom debug monitor, you don't need to edit this line.
If you run a custom debug monitor which does not have a toggle option, you will experience flashing hint windows when building, adding/removing UIDs, etc. 

****SafeObjects**** (1.7.7.1+ only)
This is a list of all objects the server reads as acceptable to restore on startup. If you add new items to your build list, you will also need to add them to this array otherwise the game will spawn them in destroyed after the next server restart. 
private["_separator1","_txt"];
cutText ["HOLD LEFT-CLICK ON TEXT AND DRAG UP AND DOWN, PRESS ESCAPE TO CLEAR OR CONTINUE ON BOTTOM!", "PLAIN DOWN"];
sleep 1;
"Base Building Help" hintC [
															"*Some buildables require a flagpole, build one first to design base within "+str(BBFlagRadius)+" meters",
															"*Removing a flagpole requires you to remove all buildables in the build radius",
															"*Certain buildables can be elevated and you'll get extended build options.",
															"*Some build objects will shift after you select 'Preview', this is how it will look at server restart(reposition to adjust)",
															"*Do not troll build, or build an extremely unrealistic base/trolly base.  These will be removed by admins",
															"*Info_stands give access to concrete walls within 15 meters, and all roofs, as well as lighting options around your base",
															"*'Give access to object' action gives all players tied to your FlagPole access to that object, either to remove/operate",
															"*Booby traps will only be triggered by players that are not added to the object manually or 'Give access action'",
															"*Any unrealistic building designs, (floating objects[not roofs], blatant exploited buildables) will be removed by admins"
															];
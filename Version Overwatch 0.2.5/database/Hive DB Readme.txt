
****CLEAN INSTALL****
You simply need to run the file 'newInstall_hive_basebuilding.sql' in your database.
This will add the Base Building items to your 'object_classes' table so items can be saved to the database.


****UPDATE INSTALL****
If updating from BB 1.2, you will need to run the file 'updateInstall_hive_basebuilding.sql' in your database.

If you have CHANGED any of the items in the BB 1.2 build list (added extra items), you will need to edit the file first.

In the file, you will see this line THREE times

	WHERE Classname IN ('lot','of','classnames');
	
Simply add any new classnames to all THREE of those lists (remember, the last item does not need a comma on the end). 

WARNING: If you do not do this, old build items may end up floating, and players will lose access to all existing items on the map.
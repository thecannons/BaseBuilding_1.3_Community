
****CLEAN INSTALL****
You simply need to run the file 'newInstall_reality_basebuilding.sql' in your database.
This will add the Base Building items to your 'deployable' table so items can be saved to the database.


****UPDATE INSTALL****
If updating from BB 1.2, you will need to edit the file 'updateInstall_reality_basebuilding.sql'

In the file, you will see this line THREE times

	WHERE deployable_id >= 6 and deployable_id <= 52;

Check your database 'deployable' table
Replace these numbers (in all THREE lines) with the numbers of the first and last base building 1.2 items in your deployable table.
Now run the script in your database. 

WARNING: If you do not do this, old build items may end up floating, and players will lose access to all existing items on the map.
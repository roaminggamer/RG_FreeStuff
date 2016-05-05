You have successfully generated a new project!

This project may contain a number of files and folders that are new or unfamiliar 
to you.  Let me give you a quick summary below.

Files
-----
 * build.settings   - This file is used to determine how the app builds for different 
                      devices.  It also includes plugins if requested.
 
 * config.lua       - This file is used to configure that 'design resolution', 
                      frame rate,  and a few other settings.
 
 * main.lua         - This is the entry point for all games and the first 'game' 
                      script that is loaded.

 * scripts/game.lua - If you chose to generate a sample game (Interfaces -> General Settings ->
                      Sample Game ), this file will be present.  This is the primary
                      file you should be editing when writing code to 'drop in'
                      to a framework.  

                      Don't put your game code in the composer  scene files.  
                      Instead, make a game.lua file (and supporting modules if 
                      you need them), then call the create(), destroy() functions 
                      in your game module.  This is a much cleaner and more portable
                      practice than sticking all your game code in composer scene files.

                      I will provide videos and tutorials on topic this after 
                      I finish the Mobile (Ad Monetizer).


Folders
-------
 * scripts/      - This contains game and utilities scripts.  At a minimum, you
                   will need a game.lua script/module here.             
 


Notes
-----
'EAT - Frameworks' does not generate icons or launch images.  For that, please use the 'Icon Generator' and 'Launch Image Generator' in 'EAT - Utilities'.
On a personal note,  I find having those files in the root folder to be annoying and messy, so I tend to add them last (just before publishing).


Other Content?
--------------
Depending on the selections you made in 'EAT - Frameworks', other content may have been added to this project.   
See report.txt for a full summary of the project generation.

Thanks and Happy Coding,
Ed Maurina (aka The Roaming Gamer)

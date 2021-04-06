# Liam's RPGMaker Scripts
This page contains the most up-to-date versions of all of Liam's RPGMaker scripts. Currently all of these scripts are made for RPGMaker VX Ace,
but that may change someday in the future.

## Miscellaneous Notes
The commenting in these scripts will seem excessive to anyone familiar with programming, but the reason for that is that the vast majority of people these scripts
are designed for will not be familiar with programming. These scripts are intended to be commented in a way where even someone who has no knowledge in programming
might be able to make a few tweaks to get the script to work the way they want it to. 

If you would like to talk to me for whatever reason, whether it is to commission a new script, report bugs, or learn RPGMaker scripting yourself, I have a
RPGMaker scripting focused discord server you can join with the following link:
https://discord.gg/JgaBenr

# Script List

## Gif Player
**SCRIPT INFO:**

Current Version:        1.1.2

<details>

  <summary>Changelog:</summary>
  
  v1.1 Changelog:
  * This is the first version of this script posted here

  v1.1.1 Changelog:
  * Added an "import section" to the script so other scripts can see if the script is being used

  v1.1.2 Changelog:
  * Added discord and github link
  
</details>

Description:

This script is made for showing a "gif" using show picture commands. It does not actually show a real .gif file, it just plays a bunch of static images like a gif. It will take a series of related images to play in quick succession.

**IMAGES/MEDIA:**

(None right now!)



## Radial Sound
**SCRIPT INFO:**

Current Version:        1.0.2

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here

  v1.0.1 Changelog:
  * Added an "import section" to the script so other scripts can see if the script is being used

  v1.0.2 Changelog:
  * Added discord and github link
  
</details>

Description:

This script is made for increasing and decreasing the volume of a repeated sound effect as a player gets closer or further away from the source of the volume, using the map x/y coordinates of the event and player to do so.

**IMAGES/MEDIA:**

(None right now!)



## Random Battle Messages
**SCRIPT INFO:**

Current Version:        1.0.2

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here

  v1.0.1 Changelog:
  * Added an "import section" to the script so other scripts can see if the script is being used

  v1.0.2 Changelog:
  * Added discord and github link
  
</details>

Description:

This script allows you to have a random message for when a fight begins and ends. You can make a list of messages to use for "emerging" and "victory".

**IMAGES/MEDIA:**

Here is an example of a "battle start" message.

![Random Battle Messages Screenshot 1](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/random%20battle%20messages%20example%201.png)

Here is an example of a "battle start" message after reloading the savefile.

![Random Battle Messages Screenshot 2](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/random%20battle%20messages%20example%202.png)




## Play Group Animations In Center
**SCRIPT INFO:**

Current Version:        1.0.1

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here

  v1.0.1 Changelog:
  * Added discord and github link
  
</details>

Description:

This script allows you to play animations once in the center of the screen rather that having it repeat for each target. Before this script, you could set animation's positions to "Screen" to partially solve this problem, however, even if you can't see the animation play multiple times since the animations are overlaid on top of each other, the sounds used in the animation can still be noticably heard playing over each other. This script prevents those animation sounds from playing over each other.

**IMAGES/MEDIA:**

(None right now!)



## TP Like MP and More
**SCRIPT INFO:**

Current Version:        1.0.3

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here

  v1.0.1 Changelog:
  * Fixed TP preservation at begin/end of battler only being switched around in the scripting
  * Small bugfix relating to Yanfly Battle Engine compatibility and user/target simultaneous tp gain/loss

  v1.0.2 Changelog:
  * Fixed an issue where I forgot to redefine a method that was used in a different script I made.

  v1.0.3 Changelog:
  * Added discord and github link
  
</details>

Description:

This script allows you to make TP into a system that works similarly to the MP system, and basically allows you to customize the TP system as much as you can customize the MP system. Normally, everything to do with TP assumes that max TP has a hard cap of 100. You cannot make TP skills costs over 100, you cannot make TP gain effects of flat numbers, or make TP-loss effects, and you cannot increase or decrease the set max TP. This script changes all of that. There is a large amount of settings including settings for initial TP at the start of battles, settings for TP preservation, settings for changing TP gained by damage, settings for changing how the TCR (TP Charge Rate) parameter works, and more. Additionally, a new parameter is added using notetags, TPCSTR or TP Cost Rate, which affects how much TP skills cost, similar to its MP cost rate equivalent.

**IMAGES/MEDIA:**

Here is some actors with nonstandard max TP.

![TP Like MP Screenshot 1](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/tp%20like%20mp%20nonstandard%20max%20tp.png)

Here is an image containing a skill with a nonstandard TP skill cost of 150.

![TP Like MP Screenshot 2](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/tp%20like%20mp%20nonstandard%20tp%20skill%20costs.png)

Here is the notetags added in this script to get an idea of some of the things this script allows.

![TP Like MP Screenshot 3](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/tp%20like%20mp%20notetags.png)



## MP to Guns Overhaul
**SCRIPT INFO:**

REQUIRES THE "Extra Save Data" SCRIPT!

Current Version:        1.1.4

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here

  v1.1 Changelog:
  * Changed how guns modify MP and max MP to allow for parallel normal MP and guns systems
  * It also just does the MP and max MP changes in a "better" way now

  v1.1.1 Changelog:
  * Updated the "Usage Guide" comments to cover a few more things

  v1.1.2 Changelog:
  * Fixed an issue relating to the "It also just does the MP and max MP changes in a "better" way now" from v1.1

  v1.1.3 Changelog:
  * Fixed an issue where gun misfiring was causing a crash.

  v1.1.4 Changelog:
  * Added discord and github link
  
</details>

Description:

This script turns the MP system into a guns and ammunition system. This system is meant for use with guns, but can also be used to represent ammo/aiming abilities for other kinds of weapons, like grenade launchers, bows, slingshots, etc. The MP bar represents the ammo count. "Guns" have a name, a type, ammo data, skills that are tied to them, etc. Additionally, there is one new notetagged parameter, GHIT or Gun HITchance, which determines how accurate "magical" (meaning gun-based) attacks are.

**IMAGES/MEDIA:**

Here is an image that shows how guns display their ammo count in their names.

![MP to Guns Screenshot 1](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/mp%20to%20guns%20ammo%20display.png)

Here is the actor menu after the 5/7 ammo "Dinky Pistol" gun is equipped on the top menu actor.

![MP to Guns Screenshot 2](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/mp%20to%20guns%20mp%20ammo%20bar.png)

Here is some gun skills that go with the "Dinky Pistol" gun.

![MP to Guns Screenshot 3](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/mp%20to%20guns%20gun%20skills.png)



## Top-Level Skills
**SCRIPT INFO:**

Current Version:        1.1.1

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here

  v1.0.1 Changelog:
  * Added an "import section" to the script so other scripts can see if the script is being used
  * Fixed a bug that causes the game to do a soft hang if you "cancel" a top level skill usage.

  v1.1 Changelog:
  * Fixed a lot of issues where skills with scopes other than "the user" or "one enemy" wouldn't work
  * Fixed a lot of other critical issues.

  v1.1.1 Changelog:
  * Added discord and github link
  
</details>

Description:

This script is made for allowing new skills from the skill database to be added to the 'top-level' menu in battle (the one with, 'attack', 'guard', etc.) for specific actors.

**IMAGES/MEDIA:**

Here, "Inspect" is a top-level skill added by the script.

![Top Level Skills Screenshot 1](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/top%20level%20skills%20example.png)



## Actor-Based Attack and Guard Skills
**SCRIPT INFO:**

Current Version:        1.0.1

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here

  v1.0.1 Changelog:
  * Added discord and github link
  
</details>

Description:

This script allows you to set custom attack and defend skills for different actors based on the actorIDs and skillIDs. It also allows you to set up default attack and guard skills that will be used for actors that do not have specific attack/guard skills set.

**IMAGES:**

(None right now!)



## Mystery HP
**SCRIPT INFO:**
Current Version:        1.0.1

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here

  v1.0.1 Changelog:
  * Added discord and github link
  
</details>

Description:

This script allows you to toggle making the hp bar value unknown in and out of battle with a toggleable game switch and with actor states. The MP and TP bar can also be set to be hidden along with HP.

**IMAGES/MEDIA:**

This image shows how the mystery HP can be afflicted through a state in battle. Additionally, this has the settings for hiding MP and TP bars on as well.

![Mystery HP Screenshot 1](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/top%20level%20skills%20example.png)



## Experience Rubberbanding
**SCRIPT INFO:**

REQUIRES THE "Extra Save Data" SCRIPT!

Current Version:        1.0.2

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here

  v1.0.1 Changelog:
  * Added an "import section" to the script so other scripts can see if the script is being used

  v1.0.2 Changelog:
  * Added discord and github link
  
</details>

Description:

This script applies 'rubberbanding' to experience gain. It lets you set (and may set by itself) an "xp leader" for the rubberbanding to be based off of (which will likely be a main character). XP bonuses are applied to party members who are varying amounts of levels behind the party leader, and the bonuses can be set to scale up as the amount of levels behind the leader increases.

**IMAGES/MEDIA:**

(None right now!)



## Auto and Quick Saving
**SCRIPT INFO:**

REQUIRES THE "Extra Save Data" SCRIPT!

Current Version:        1.2.2

<details>

  <summary>Changelog:</summary>
  
  v1.2 Changelog:
  * This is the first version of this script posted here

  v1.2.1 Changelog:
  * Added an "import section" to the script so other scripts can see if the script is being used

  v1.2.2 Changelog:
  * Added discord and github link
  
</details>

Description:

This script turns the first savefile in the list of savefiles in the game directory into a quicksave/autosave hybrid savefile that can only be accessed in the load menu (and not the normal save menu). Autosaves can be enabled to occur either when a specified switch is turned to true, or on map transition. Quicksaves can be enabled to occur with the press of a specified button. Additionally, the quicksave file can be quickloaded with the press of a different specified button.

**IMAGES:**

Here, the slot labeled "Quicksave Slot" is the AQS Savefile.

![Auto and Quicksaving Screenshot 1](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/aqsaves%20quicksave%20slot%20example.png)



## Max Save Increases
**SCRIPT INFO:**

Current Version:        1.2

<details>

  <summary>Changelog:</summary>
  
  v1.1 Changelog:
  * This is the first version of this script posted here

  v1.1.1 Changelog:
  * Added an "import section" to the script so other scripts can see if the script is being used

  v1.2 Changelog:
  * Removed the requirement of using the "Persistent Data" script
  * Improved the adaptability of the script (like adapting when save files are deleted from the game directory)
  * Added discord and github link
  
</details>

Description:

This script increases the amount of available save files by one whenever the last save file is saved to by the player.

**IMAGES:**

(None right now!)



## More Save Display Data (and Difficulty Display)
**SCRIPT INFO:**

REQUIRES THE "Extra Save Data" SCRIPT!

Current Version:        1.0.2

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here

  v1.0.1 Changelog:
  * Added an "import section" to the script so other scripts can see if the script is being used

  v1.0.2 Changelog:
  * Added discord and github link
  
</details>

Description:

The script provides a framework for adding more data onto savefiles. By default, the data added is game difficulty, although you can add more data by copying versions of the previous methods/variables and editing the names/values. game_party is used to store data because data stored there is stored in save data and can be accessed outside of normal gameplay (since it needs to be used on the title screen).

**This script is difficult to use without prior scripting knowledge**

**IMAGES:**

The "Easy", "Not Easy", and "H.A.R.D." below are different difficulties which display in the form of text on top of savefile windows.

![More Save Display Screenshot 1](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/more%20save%20display%20data%20difficulty%20display.png)



## Extra Save Data
**SCRIPT INFO:**

Current Version:        1.1.1

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here

  v1.1 Changelog:
  * Added an "import section" to the script so other scripts can see if the script is being used
  * Fixed some functions that didn't work properly
  * Added a new function needed in some newer scripts

  v1.1.1 Changelog:
  * Added discord and github link
  
</details>

Description:

This script allows you to save any kind of data (true/false values, numbers, etc.) to specific save files. This data is accessed using particular names attached to the pieces of data. This script generally exists for other scripts to utilize, although it can be used on its own. This is useful for scripts as an alternative to using game_variable, since the player needing to keep track of 5+ game_variables they now cannot use per script can get confusing and hard to remember.

**IMAGES/MEDIA:**

(None right now!)



## Fake Show Pictures
**SCRIPT INFO:**

Current Version:        1.0

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here
  
</details>

Description:

This script allows the equivalent of "show picture" commands to be used in more scenes than just on the game map and in battle. It also ensures that images shown using this script do not interfere with any existing visual elements on screen. This script is primarily designed to be utilized by other scripts, and does serve much of a purpose by itself.

**IMAGES/MEDIA:**

(None right now!)



## Lisa Core Movement
**SCRIPT INFO:**

Current Version:        1.1.1

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here

  v1.1 Changelog:
  * Built-in support for ropes (multiple kinds, including wall-climbing style ropes) using terrain tags. Additionally, no common events are needed
  * Followers can now use ropes
  * There is now a script call for both checking the outfit of the player, and for checking the outfit of an actor

  v1.1.1 Changelog:
  * Fixed a small mistake in how follower rope pathfinding works for "ropes" that only go horizontally
  * Added discord and github link
  
</details>

Description:

The main function of this script is that it allows you to have Lisa-style movement for the player without using any events. This script supports backwards compatibility with evented lisa movement (so long as the script is toggled off in such areas). Tiles in tilesets can be set as platforms that can be walked on or jumped to by setting terrain tags on them that are designated to mark platforms. Events can also serve as platforms by using tags in the event name. Different platform types can also be set, which have unique sounds and different damage amounts when falling from unsafe heights.

**IMAGES/MEDIA:**

Here is a link to Lisa: The Tech Demo which is made to show off what the script can do, and how to make the script do what you want. Use it as a testing ground if you want to play around with the script before using it in your own projects.

https://gamejolt.com/games/lisathetechdemo/525787

Here is a screenshot from inside the RPGMaker editor. Note the lack of movement events.

![Lisa Core Movement Screenshot 1](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/lisa%20core%20movement%20no%20movement%20events.png)

Here is a screenshot from in-game. Note the three followers in the image. Followers are now able to be used when using this script.

![Lisa Core Movement Screenshot 2](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/lisa%20core%20movement%20followers.png)



## ATS Message Options Lisa Addon
**SCRIPT INFO:**

REQUIRES THE "ATS Message Options" SCRIPT! OBTAIN AT THIS LINK: https://rmrk.net/index.php?topic=46770.0

REQUIRES THE "Extra Save Data" SCRIPT!

Current Version:        1.1.1

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here

  v1.1 Changelog:
  * Added actor-based talking sound capabilities
  * Simplified the ATS message options talk sound script calls

  v1.1.1 Changelog:
  * Added discord and github link
  
</details>

Description:

This script allows you to designate a number for ATS Message Options text box positions settings (like the n in \et[n]) to mark the text box for the show text command's position as relative to the event that contains the show text command. In other words, it serves as a "this event" marker. Additionally, it also lets you set text box positions as relative to followers, not just the player. In addition, it allows you to automatically set unique talking sounds based off of actorID for the player and any followers they have. Lastly, it simplifies the ATS message options talk sound script calls so you can call sound data by name from a list of sounds you define.

**IMAGES/MEDIA:**

Here is a link to Lisa: The Tech Demo which includes this script if you want to see it in action: https://gamejolt.com/games/lisathetechdemo/525787

Here you can see the "eventID"in \et\[999\] set to 999 to stand in as the "this event" marker.

![ATS Message Options Screenshot 1](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/ats%20message%20options%20this%20event%20example.png)

















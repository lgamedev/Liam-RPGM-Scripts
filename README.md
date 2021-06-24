# Liam's RPGMaker Scripts
This page contains the most up-to-date versions of all of Liam's RPGMaker scripts. Currently all of these scripts are made for RPGMaker VX Ace,
but that may change someday in the future.

## Miscellaneous Notes
The commenting in these scripts will seem excessive to anyone familiar with programming, but the reason for that is that the vast majority of people these scripts
are designed for will not be familiar with programming. These scripts are intended to be commented in a way where even someone who has no knowledge in programming
might be able to make a few tweaks to get the script to work the way they want it to. 

If you would like to talk to me for whatever reason, whether it is to commission a new script, report bugs, or learn RPGMaker scripting yourself, I have a
RPGMaker scripting focused discord server you can join through the following link: https://discord.gg/JgaBenr

# Script List


## Event Force Unlock
**SCRIPT INFO:**

Current Version:        1.0

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here
  
</details>

Description:

This script allows you to force events to not "lock" into place and stop animating when interacting with them. This is done using event comment notetags, and the force unlock can be done per event page, or for the entire event. Force unlocking an event allows you to ensure that continuous event animations won't be interrupted.

**IMAGES:**

(None right now!)



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

**IMAGES:**

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

**IMAGES:**

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

**IMAGES:**

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

**IMAGES:**

(None right now!)


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

**IMAGES:**

(None right now!)



## Battler Sprite Transitions
**SCRIPT INFO:**

Current Version:        1.0

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here
  
</details>

Description:

This script allows you to use 2 kinds of transitions when changing enemy battler sprite images. Notably, you can now change battler sprite images without having to use the Transformation command using script calls. The first type of transition is a fade transition where the old battler sprite image fades out and the new one fades in. The second transition is a battle animation transition where the old battler image is hidden (or not) while a specified battle animation plays and then the new battler image appears at the end of the animation. Both transitions can be used with the Transformation command and the new alternative to the Transformation command. It is also possible to use no transition.

**IMAGES:**

(None right now!)



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

**IMAGES:**

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

**IMAGES:**

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

**IMAGES:**

This image shows how the mystery HP can be afflicted through a state in battle. Additionally, this has the settings for hiding MP and TP bars on as well.

![Mystery HP Screenshot 1](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/mystery%20hp%20state%20in%20battle.png)




## State Skill Usability Refresh
**SCRIPT INFO:**
Current Version:        1.0

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here
  
</details>

Description:

This script allows you to prevent enemies/actors from using skills that they would no longer to be able to use when states are applied to them that restrict skill usability. This is done normally with the engine's base script, but this makes sure the moves are correct even in edge-case situations. Additionally, after the skill usability restricting moves are used on a battler with this script, a replacement skill for the now-unusable skill can be used.

**IMAGES:**

(None right now!)



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

**IMAGES:**

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



## Persistent Data
**SCRIPT INFO:**

Current Version:        1.2

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here

  v1.1.1 Changelog:
  * Added an "import section" to the script so other scripts can see if the script is being used

  v1.2 Changelog:
  * Now separates persistent data used by other scripts and persistent data set up by the user
  * Persistent data used by other scripts is now managed automatically
  * User-defined persistent data is now easy to set up and use
  * Added discord and github link
  
</details>

Description:

This script allows you to save any kind of data (true/false values, numbers, etc.) across all save files using a generated file stored in a directory/folder you specify. This persistent data can be retrieved and changed in map events. Persistant data is accessed by using particular names you can set. This is useful for updating title screens after certain game milestones/achievements, doing 4th wall breaking things, etc. This script may be used to other scripts or by itself.

**IMAGES:**

(None right now!)



## Lisa Core Movement
**SCRIPT INFO:**

REQUIRES THE "Extra Save Data" SCRIPT!

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

There's also some new features like:
* Having the option to use visible followers
* No longer having to press the interact key to move up or down (it is now an option)
* In-built support for eventless ropes

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



## Lisa NPC Talk Options
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

This script allows you to let the player talk to NPCs while adjacent to them, so that the player's sprite does not have to be move out of the way unless necessary. For both NPCs that can talk adjacently or not, if the player is directly on top of the NPC they are trying to talk to, then the player can be marked to either move to the left or right to get out of the way before talking to them, and then will face the NPC afterwards. Moving the player out of the way in the desired direction is condensed down to a single script call.

**IMAGES/MEDIA:**

Here is a link to Lisa: The Tech Demo which includes this script if you want to see it in action: https://gamejolt.com/games/lisathetechdemo/525787

In this event you can see that the event is set to "Same as Character" priority and has "through" on, marking them as an NPC that can be talked to adjacently. Also present is the script call playerTalkCollisionResolve(), which moves the player in the desired way (in this case, moving left and turning right) if the player is on top of their event.

![Lisa NPC Talk Options Screenshot 1](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/lisa%20npc%20talk%20options%20example.png)



## Fake Show Pictures
**SCRIPT INFO:**

Current Version:        1.0

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here
  
</details>

Description:

This script allows the equivalent of "show picture" commands to be used in more scenes than just on the game map and in battle. It also ensures that images shown using this script do not interfere with any existing visual elements on screen. This script is primarily designed to be utilized by other scripts, and does not serve much of a purpose by itself.

**IMAGES:**

(None right now!)



## Show Picture Achievements
**SCRIPT INFO:**

REQUIRES THE "Fake Show Pictures" SCRIPT!

REQUIRES THE "Persistent Data" SCRIPT!

Current Version:        1.0

<details>

  <summary>Changelog:</summary>
  
  v1.0 Changelog:
  * This is the first version of this script posted here
  
</details>

Description:

This script allows you to set up a list of achievements and an achievements screen to display all the achievements. The achievements screen's graphics, layout, and the sizes of the objects on the screen can all be modified. There are also optional achievement popups that can pop up when you earn an achievement. Unlocking an achievement is done by using script calls. Achievements are not stored per savefile, but rather in persistent data.

**This script has a default set of graphics that go with it in the "Show Picture Achievements Default Graphics" folder. Credit to "the iceman" for creating the default graphics set.**

**IMAGES:**

Here is a screenshot of the achievements screen using the default achievement graphics.

![Show Picture Achievements Screenshot 1](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/show%20picture%20achievements%20achieve%20screen.png)

Here is an example of an achievement popup using the default achievement graphics.

![Show Picture Achievements Screenshot 2](https://raw.githubusercontent.com/lgamedev/Liam-RPGM-Scripts/main/github%20readme%20graphics/show%20picture%20achievements%20achieve%20poup.png)



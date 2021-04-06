#IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-LisaCoreMove"] = true
# END OF IMPORT SECTION

# ------------------- ! REQUIRES 'EXTRA SAVE DATA' SCRIPT ! -------------------
# Script:           Lisa Core Movement
# Author:           Liam
# Version:          1.1.1
# Description:
# The main function of this script is that it allows you to have Lisa-style
# movement for the player without using any events. This script supports
# backwards compatibility with evented lisa movement (so long as the script
# is toggled off in such areas). Tiles in tilesets can be set as platforms that
# can be walked on or jumped to by setting terrain tags on them that are
# designated to mark platforms. Events can also serve as platforms by using 
# tags in the event name. Different platform types can also be set, which have
# unique sounds and different damage amounts when falling from unsafe heights.
#
# The graphics and sounds using for falling and jumping are stored as "outfits".
# The amount of tiles character can jump up, down, or to the side is also stored
# in the "outfits". Outfits for different actors can be switched during gameplay
# for the purposes of using vehicles, or for changing clothes, or for getting
# severely beaten up, and no longer being able to move around as well.
#
# One completely new feature is that pressing the Z-key/interact key is no longer
# necessary. Another new feature is that followers are
# now supported by lisa movement. Followers can now properly follow the player
# around. They don't follow the player around perfectly, like in normal
# top-down RPGMaker games, though. Lastly, falls can be made to have momentum
# when dashing (or when treating walking as dashing).
#
# Feel free to use this script however you like, commercial or not, as long
# as you credit me. Just 'Liam' is fine.
#
# This script has a tech demo that demonstrate most of its capabilities.
# If you want to download this tech demo, you can find it at:
#   https://gamejolt.com/games/lisathetechdemo/525787
#
# If you have any questions or concerns, or if you want to be notified of
# the updates for this script as they release, join my scripting-focused
# discord server at:
#   https://discord.gg/JgaBenr
#
# The most recent version of the script can always be found on github at:
#   https://github.com/lgamedev/Liam-RPGM-Scripts
#
# __Why Use This Script?__
# * It won't conflict with old maps that do not use this script's form of movement
#   so long as the script enabling toggle is set to off when the game starts.
# * A huge amount of time is saved by not needing to manually place all the
#   movement events.
# * It makes movement feel much smoother by not having to press Z key/interact key
#   when jumping.
# * Consistent falling damage is ensured for specific fall heights and
#   platform types.
# * Missed/misplaced movement events will no longer occur.
# * Allows for easily adjustable movement abilities for different versions of
#   the player (whether switching the actor in control, or having the player
#   switch clothes, or taking a severe beating, etc.)
# * Much larger maps can be made because all RPGM events cause lag, and this
#   script allows for ~80% of map events to be removed from most maps from
#   lisa-style movement done with eventing.
# * Graphics/sound data can easily be changed for all jumps/falls at once.
# * Greater immersion through having different types of platforms having
#   different fall impact sounds, and the ability to have different
#   graphics while dashing if dashing is used.
# * Followers can now be used when they couldn't be used before at all.
#
# __Usage Guide__
# To use this script, start by setting up the overall script settings in the
# Modifiable Constant section. Then, set up and then enter in terrain tag data
# with damage numbers, damage number animations, and sounds. Then set up and
# enter in data for different actor outfits with different movement abilities,
# jumping and falling graphics, and sounds. Then, set up some tiles and/or
# events with some terrain tag or terrain tag equivalents (tile terrain tags
# are done in the tilesets section of the database, and event terrain tag
# equivalents are done in event names with tags, see below for more information).
# Additionally, information on exactly what kinds of data to enter, how to set
# up the data, and what different kinds of data actually does can be found
# where the data is supposed to be entered in the Modifiable Constants section.
#
# Note 1: To use the script in backwards-compatible mode, do the following:
#   - Set the LCM_TOGGLE_INIT to false to make it so that the script starts
#     toggled off when the game starts.
#   - Set LCM_REQUIRE_Z_PRESS to true, so that there the z-press requirement
#     is consistent between evented movement and lcm movement sections.
#   - Do not use followers, or forms of movement that you did not use in
#     you evented sections. (Or figure out a justification to use them
#     in later areas where the script is turned on.)
#   - The settings LCM_JUMP_DOES_NOT_CAUSE_DIRECTION_CHANGE and
#     LCM_USE_SEPARATE_DASH_GRAPHICS should still work for evented movement,
#     so feel free to turn on those settings.
#   - Flip on the total script toggle with the call
#     "$game_map.changelcmScriptToggle(true)" when the lcm movement area is reached.
#
# Note 2: To set up a vehicle, do the following: 
#   - Set up a new "outfit" for the vehicle.
#   - Use different vehicle graphics/sounds for the vehicle.
#   - Potentially, treat walking like dashing and enable momentum for dashing
#     (this would be used for vehicles like the painful bike)
#
# Note 3: There are three ways to set up a rope.
# 1 - To set up ropes in the standard way, first set a ropes terrain tag
#     with the LCM_ROPE_TERRAIN_TAG setting and an initial ropes type
#     with the LCM_INITIAL_ACTIVE_ROPE_TYPE setting (give it a name
#     like "normal ropes" or something). In the outfit data, set up
#     ropes data (movement speed and character graphic) for the outfits
#     and each type of rope. In your tileset, set your ropes to the
#     rope terrain tag you designated. Make sure that any "rope bottom"
#     tiles are also marked with the rope terrain tag. Do not mark
#     "rope top" tiles (tiles you don't climb on that are above a platform)
#     with the ropes terrain tag. Additionally, if a character's outfit does
#     not have data for the active rope type, the character will be prevented
#     from climbing the ropes.
#
#     If you are only using one kind of rope, you can now create ropes freely
#     without the need for any eventing. If you are using multiple kinds
#     of ropes, you will need to switch the active rope type before the
#     player is able to climb properly on the given rope type with
#     the script call: $game_map.changelcmActiveRopeType("newRopeType").
#
#     Note that followers will not trigger events containing the script call,
#     so if you are using followers you will probably want to restrict
#     each map to one type of rope.
# 2 - If you want to keep the script on, but need an evented rope for
#     some reason, then check the ropes guide image and it will show you
#     how to set it up. This image is included in the files for the Tech Demo.
#     This will only work if the ropes are not using the ropes terrain tag.
# 3 - Toggle off the full script when adjacent to anywhere you could be
#     interacting with a rope, and event everything as normal. This will
#     only work if the ropes are not using the ropes terrain tag.
#
# Note 4: Here is one usable script line that doesn't really "fit" anywhere
# else: $game_player.checkIfSpecialMovementOk
# This is intended for use in common event conditional branches, and will resolve
# to "true" if the player can do a "special" movement, namely one which is bound
# to a button press. The conditions for a special movement are:
# checking when the menu is not disabled and if the player is not moving, 
# that the map interpreter is not running, and that the player is not
# not immobile due to an lcm movement. This ensures that the "special" movement
# cannot be used in the middle of a fall and the like.
#
# Note 5: When jumping/falling, the actor's "walking" animation for the
# graphic being used is now used. This means that even if you just want
# static jumping/falling frames, the "walking" frames should still be filled out
# (which is normally done for such graphics for Lisa-style games anyway).
#
# Note 6: This script will NOT work with OLD SAVES from before this script
# was put into the engine, so make sure to start a new game!
#
# Note 7: The initial settings/data will be a "basic" lisa movement setup.
#
#
# __Modifiable Constants__
module LCM
  # General Settings
  #   ---------------------------------
  # Whether or not to start with LCM movement on or off. You may want to have
  # this set to false if you want to have backwards compatibility with
  # standard evented movement at the start of your game, or if you have a
  # intro scene that needs advanced kinds of evented movement, you may also
  # want to start it as false.
  # 
  # Additionally, use "$game_map.changelcmScriptToggle(trueOrFalse)" as a map
  # event script line to flip the toggle on and off during gameplay runtime.
  # This is necessary for instancs where lcm-style movement would conflict
  # with certain events, like if falling off the map should cause a map transition
  # instead of a game over. In such a circumstance, the script should be toggled
  # off around the area that needs standard movement and standard jump/fall
  # events should be used, and toggled back on once out of the area in question.
  LCM_TOGGLE_INIT = true
  
  # Whether or not to enable particular events being able to turn off the
  # lcm movement while in the "range" of that event. This is useful
  # for things like where a fall triggers something, or needs to do something
  # particular special, like causing a map transition rather than a game over.
  # If this is not necessary, setting it to false saves processing power.
  #
  # Use "[LCMOFF] ~~~~~" in an event name (without quotes) to mark the event
  # as one where the script should be off for that event.
  LCM_CHECK_EVENT_INDIVIDUAL_OFF_TAGS = true
  
  # Whether or not to make [LCMOFF] events that cause lcm movement to turn
  # off impact only the player or not. This is mainly needed for if followers
  # are being used, and you don't want to have to event the movement for followers
  # in the movement event being used.
  LCM_APPLY_OFF_TAGS_TO_PLAYER_ONLY = true
  
  # Whether or not to enable events being able to serve as platforms. Turning
  # this off saves processing time if it's not going to be used.
  #
  # Use "$game_map.changelcmPlatformEventsToggle(trueOrFalse)" as a map
  # event script line to flip this option on and off during gameplay runtime.
  # Setting it to false saves processing power.
  #
  # Use "toggleEvPlat(true/false, eventID)" in a map event to toggle an
  # event's platform-ness. Alternatively, just do "toggleEvPlat(true/false)"
  # if the event to toggle is the event that the script line is in.
  # The line may need to be used $game_player.doPlayerFallCheck (see below)
  # depending on how it is used.
  #
  # To check if the player should fall from the evented platform due
  # to the platform toggle (this can be used for timed platforms and such), use
  # the script line "$game_player.doPlayerFallCheck".
  # Note: This may cause minor issues if followers are being used, although
  # followers are also checked by the script line.
  #
  # Use "[PLT X] ~~~~~" in an event name (without quotes, where X is the number
  # of terrain tag that the event should be considered equivalent to) to denote
  # it as a platform.
  # ALSO, the platform event tag only really works in terms of collision for 
  # single-tile events, so if you want an evented platform for a graphic that
  # spans multiple tiles, you will need to use multiple invisible tile platforms
  # along with the event that has the graphic.
  # Also, you can make "pseudo terrain tags" by using event platforms. This allows
  # you to break past the normal 0-7 terrain tags by creating data for 8+ terrain
  # tags and using them in platform events.
  # Note: When copy-pasting platform events, make sure they don't have EV###
  # in the name, where ### is a number, as this causes platform tags to be lost
  # when pasting the event
  #
  # Use "[-PLT X] ~~~~~" to mark the platform to start with it's platform
  # toggle off instead of on.
  LCM_PLATFORM_EVENTS_ENABLED = true
  
  # Whether or not to enable lcm movement for followers. Note that in order
  # to use this feature, the "Show Player Followers" checkbox in the upper-right
  # corner of the System tab of the database must be checked.
  #
  # Note 1: Followers are somewhat "messy". They do not follow the player
  # perfectly, like in top-down RPGM games.
  #
  # Note 2: The more advanced the player's movement abilities are, the less
  # followers will be able to properly keep up (but they will still rejoin the
  # player on map transitions). For example, when allowing ledge up/down jumps
  # of 2 or more for the player, or using momentum jumps, followers will likely
  # have more trouble keeping up.
  #
  # Note 3: Similarly, the more movement ability as follower has over the player,
  # the better they will be able to keep up with the player.
  #
  # Note 4: The more followers you have, the more processing has to be done
  # for each one (so, the more followers, the more lag).
  #
  # Additionally, use "$game_map.changelcmFollowerToggle(trueOrFalse)" as a map
  # event script line to flip this on and off during gameplay runtime
  LCM_FOLLOWERS_ENABLED = false
  
  # Whether or not to only damage only the player when they fall from an unsafe
  # height and take damage. This effect will only apply to lcm movements,
  # not evented movements.
  #
  # This setting being true is mainly intended for when you are using followers
  # on screen.
  LCM_DAMAGE_PLAYER_ONLY = false
  
  # When this is enabled, a gameover will be caused when followers fall off
  # a cliff (they may get separated from the player on occasion).
  # If disabled, followers will not walk off cliffs that would cause a gameover
  # (but this will cost some processing power, so it will create more lag).
  # Followers will still not actually trigger a game over if enabled, but they
  # will be stuck out of the map until the next map transition.
  LCM_FOLLOWER_GAMEOVER_ALLOWED = false
  
  # When this is enabled, followers who would normally follow behind the next
  # follower will instead try to follow the player, if the follower in front
  # of them is not as agile as the player, and cannot reach their area.
  # The downside of enabling this option is that it makes movement more
  # "messy," occasionally causing odd jumps here and there, so do not
  # enable this setting if you characters mostly have the same movement
  # abilities. Try playing for a little bit in an area with widely varying
  # terrain with this setting on and off to determine if you want this setting on.
  #
  # For example, if the player jumps up 2 tiles to a platform, and the
  # 2nd follower can't jump up 2 tile high, but 3rd follower can, then
  # turning the setting on would allow the 3rd follower and beyond to continue
  # trying to follow the player.
  LCM_FOLLOWER_POOR_AGILITY_CATCHUP = true
  
  # If set to true, then jumping up/down from/to ledges will require pressing
  # the interact input key (usually Z) like in the evented version of movement.
  LCM_REQUIRE_Z_PRESS = true
  
  # Whether or not to make "jumping" (specifically the jumping move route command)
  # change the player's direction when falling. Turning this to true will make
  # it so you can have separate left/right side falling graphics.
  # Note: Turning off the whole script will not affect this toggle;
  # this feature is backwards compatibile
  #
  # This means that when the setting is set to true, when falling off the side
  # of a ledge, the graphics for left and right are now "separated", and will
  # use the "left" and "right" graphics instead of the "down" graphic.
  LCM_JUMP_DOES_NOT_CAUSE_DIRECTION_CHANGE = true
  
  # Whether or not to set the player's (and NOT followers) walk speed
  # to their designated outfit walk speed when the player's outfit data is
  # refreshed (this happens when changing outfit, and when turning this toggle
  # to true during gameplay). If you change the player's speed during gameplay
  # at a particular moment, you should turn this toggle off for the section,
  # and on again afterwards. Otherwise, you could make a separate outfit just
  # for that occasion.
  #
  # Note 1: To force a refresh for the player (and any followers, if they exist),
  # use the script call $game_player.doFullOutfitRefresh.
  #
  # Note 2: If walk speed is set to 0 in the outfit data, then that
  # outfit will not affect the player's speed.
  #
  # Use "$game_map.changelcmUseOutfitWalkSpeedToggle(trueOrFalse)" as a map
  # event script line to flip this option on and off during gameplay runtime.
  # Note: Turning this to true will immediately do an outfit refresh for
  # the player, so you do not need to do it yourself.
  LCM_USE_OUTFIT_WALK_SPEED = true
  
  # Whether or not to disable dashing everywhere. Having dashing disabled
  # everywhere will prevent dashing at all times, regardless of
  # anything else.
  #
  # Note 1: The map-based dashing disable checkmark will still work as normal.
  #
  # Note 2: This setting is unaffected by the lcm total script toggle, so feel
  # free to set this to false so that you do not have to check the disable
  # dashing box on every new map if you do not plan on ever allowing dashing.
  #
  # Note 3: This does not affect the outfit setting treatWalkLikeDash,
  # as it's "dashing" is not actually "real dashing", but rather just decides
  # if walking can count as dashing for dash jumps and momentum jumping.
  # Map-based dash disables do not affect it either.
  #
  # Use "$game_map.changelcmGlobalDashDisableToggle(trueOrFalse)" as a map
  # event script line to flip this option on and off during gameplay runtime.
  LCM_GLOBAL_DASH_DISABLE = true
  
  # Whether or not to use separate graphics for regular dash movement
  # (not falling or jumping). Turn this off if you game does not use dashing,
  # OR if you already have a script that does this functionality, or if something
  # conflicts with this feature.
  # Note 1: This setting will apply to followers as well
  # Note 2: Turning off the whole script will not affect this toggle;
  # this feature is backwards compatibile
  # Note 3: For "outfits" that have "treat walk like dash" on, this will not
  # mean that dash graphics still get used when running around, the walking
  # graphic will still be used. (You could still make a vehicle have a "dash")
  # by keeping that outfit setting off, however)
  #
  # If enabled, the dash graphic used will be the
  # "Normal non-jump dash graphic" in the outfit data.
  #
  # Additionally, use "$game_map.changelcmSeparateDashingToggle(trueOrFalse)" as a map
  # event script line to flip this on and off during gameplay runtime.
  # Make sure to turn it off if you don't want a player to be able to
  # change their graphic when dashing at certain times.
  LCM_USE_SEPARATE_DASH_GRAPHICS = true
  
  # Whether or not to use the dash jump graphic when a fall with momentum
  # is being executed. If dashing is not being used, or if momentum jumping
  # is not being used, then this setting will not affect anything. 
  LCM_USE_DASH_JUMP_GRAPHIC_ON_MOMENTUM_FALL = true
  
  # When falling, the player will move a LCM_DASH_JUMP_ACROSS_TILES amount of
  # tiles per LCM_DASH_JUMP_TILES_DOWN tile fallen. These are used to adjust the
  # arc of a dash jump if momentum is used.
  #
  # The defaults and recommended numbers for these are 1 for both.
  LCM_DASH_JUMP_TILES_DOWN = 1
  LCM_DASH_JUMP_ACROSS_TILES = 1
  
  # The terrain tag used to mark ropes. This terrain tag should not be
  # used by ground tiles. If you don't want to use the lcm ropes system,
  # then set this number to a number you would never use like 999.
  LCM_ROPE_TERRAIN_TAG = 7
  
  # The initial active rope type. All ropes will be assumed to be the
  # active rope type for the purposes of the ropes data set in
  # the outfit data.
  #
  # Note: To change the current active rope type during run time, use
  # the script call $game_map.changelcmActiveRopeType("newRopeType")
  #
  # Note 2: If you are only using one kind of ropes, you will never
  # have to change the active rope type.
  LCM_INITIAL_ACTIVE_ROPE_TYPE = "rope"
  #   ---------------------------------
  
  
  # Terrain Tag and Platform Data
  #   ---------------------------------
  # This is the list of terrain tags to count as "Platform Tags" for tilesets
  # and platform events.
  # Terrain Tags are set in the database under the tileset section.
  # Ex.
  # LCM_PLATFORM_TAGS = [1, 2]
  LCM_PLATFORM_TAGS = [1, 2, 3]
  # 1: Dusty/dry ground, the normal ground type
  # 2: Metal
  # 3: Wood
  
  # This is the default set of data for unsafe landings (ones which cause
  # damage) when the character impacts into the ground. This is used when
  # a terrain tag is not found in the TERRAIN_TAGS_UNSAFE_LAND_SE_DATA list.
  # 
  # format:
  #   [SE name, SE volume, SE pitch]
  # Ex.
  # LCM_DEFAULT_UNSAFE_LAND_SE_DATA = ["Earth5", 70, 150]
  LCM_DEFAULT_UNSAFE_LAND_SE_DATA = ["Earth5", 70, 150]
  
  # This list is used to determine SE data for unsafe landing impacts based on
  # the terrain tag.
  #
  # format:
  #   terrainTag => [SE name, SE volume, SE pitch]
  # Ex.
  # LCM_TERRAIN_TAGS_UNSAFE_LAND_SE_DATA = {
  #   # 1: Dusty/dry ground, the normal ground type
  #   1 => ["Earth5", 70, 150],
  #   #  2: Metal
  #   2 => ["Hammer", 60, 60]
  # }
  LCM_TERRAIN_TAGS_UNSAFE_LAND_SE_DATA = {
    # 1: Dusty/dry ground, the normal ground type
    1 => ["Earth5", 70, 150],
    # 2: Metal
    2 => ["Hammer", 60, 60],
    # 3: Wood
    3 => ["Earth7", 55, 85]
  }
  
  # Stores the amount of damage to take for an unsafe fall of a given height.
  # Numbers below the max safe fall height for the terrain tag will not be used.
  # Numbers above the highest designated fall height number will default to
  # FALL_HEIGHT_MAX_DAMAGE.
  #
  # format:
  #   terrainTag => {
  #     fallHeight => damageAmount
  #   }
  # Ex.
  # LCM_UNSAFE_FALL_HEIGHT_DAMAGE = {
  #   # 1: Dusty/dry ground, the normal ground type
  #   1 => {
  #     4 => 10,
  #     5 => 50,
  #     6 => 50,
  #     7 => 100,
  #     8 => 100,
  #     9 => 200,
  #     10 => 200
  #   },
  #   # 2: Metal
  #   2 => {
  #     3 => 50,
  #     4 => 50,
  #     5 => 100,
  #     7 => 100,
  #     8 => 200
  #   }
  # }
  LCM_UNSAFE_FALL_HEIGHT_DAMAGE = {
    # 1: Dusty/dry ground, the normal ground type
    1 => {
      4 => 10,
      5 => 50,
      6 => 50,
      7 => 100,
      8 => 100,
      9 => 200,
      10 => 200
    },
    # 2: Metal
    2 => {
      3 => 50,
      4 => 50,
      5 => 100,
      7 => 100,
      8 => 200
    },
    # 3: Wood
    3 => {
      3 => 10,
      4 => 50,
      5 => 50,
      6 => 100,
      7 => 100,
      8 => 100,
      9 => 200,
      10 => 200
    }
  }
  
  # The maximum possible number of damage the player can take when falling.
  # Any fall with a fall height not specified in UNSAFE_FALL_HEIGHT_DAMAGE will
  # use this as its damage value, so lesser falls should have ALL values defined.
  LCM_FALL_HEIGHT_MAX_DAMAGE = 500
  
  # This number will be used as the max "safe" height if a valid safe height is not
  # found in MAX_SAFE_FALL_HEIGHTS for particular terrain tags.
  LCM_MAX_SAFE_FALL_HEIGHT_DEFAULT = 3
  
  # Stores the max "safe" fall heights where no damage is taken for the fall
  # for particular terrain tags.
  #
  # The max safe fall heights are the max amount of tiles the player can fall
  # without falling over and taking damage. This number is counted starting
  # from the tile under the tile the player is on.
  #
  # format:
  #   terrainTag => maxSafeFallHeight
  # Ex.
  # LCM_MAX_SAFE_FALL_HEIGHTS = {
  #   # 1: dusty/dry ground, the normal ground type 
  #   1 => 3,
  #   # 2: metal
  #   2 => 2
  # }
  LCM_MAX_SAFE_FALL_HEIGHTS = {
    # 1: dusty/dry ground, the normal ground type 
    1 => 3,
    # 2: metal
    2 => 2,
    # 3: wood
    3 => 2
  }
  
  # Stores the animation IDs for the damage amounts used for different terrain
  # types. They are split up by types so that some damage numbers may include
  # a dust cloud animation, lack a dust cloud, have a water splash instead, etc.
  #
  # The damage animation ID is the animation ID in the Animations tab of
  # the database.
  #
  # format:
  #   terrainTag => {
  #     damageAmount => damageAnimID
  #   }
  # Ex.
  # LCM_UNSAFE_FALL_HEIGHT_DAMAGE_ANIM_IDS = {
  #   # 1: dusty/dry ground, the normal ground type
  #   1 => {
  #     10 => 106,
  #     50 => 107,
  #     100 => 108,
  #     200 => 109,
  #     500 => 110
  #   },
  #   # 2: metal
  #   2 => {
  #    10 => 106,
  #    50 => 107,
  #    100 => 108,
  #    200 => 109,
  #    500 => 110
  #   }
  # }
  LCM_UNSAFE_FALL_HEIGHT_DAMAGE_ANIM_IDS = {
  # 1: dusty/dry ground, the normal ground type
    1 => {
      10 => 106,
      50 => 107,
      100 => 108,
      200 => 109,
      500 => 110
    },
  # 2: metal
    2 => {
      10 => 106,
      50 => 107,
      100 => 108,
      200 => 109,
      500 => 110
    },
  # 3: wood
    3 => {
      10 => 106,
      50 => 107,
      100 => 108,
      200 => 109,
      500 => 110
    }
  }
  #   --------------------------------- 
  
  
  # Outfit Data
  #   ---------------------------------
  # Stores the initial outfits for the player and potentially followers,
  # if followers are enabled.
  #
  # All outfits can be changed after being initialized using the
  # script call "$game_actors[actorID].changeActorlcmOutfit("outfitName")"
  # in a map event.
  # !!! IMPORTANT NOTE: the outfit change does not acatually change the
  # actor's graphic. That should be done alongside the outfit change appropriately.
  #
  # format:
  #   actorID => "outfitName"
  # Ex.
  # LCM_DEFAULT_ACTOR_OUTFIT_NAMES = {
  #   # alex
  #   1 => "alex default",
  #   # joel
  #   2 => "joel default"
  # }
  LCM_DEFAULT_ACTOR_OUTFIT_NAMES = {
    # alex
    1 => "alex default",
    # joel
    2 => "joel default"
  }
  
  # The outfit that is used to initialize characters with unrecognized
  # actor IDs.
  LCM_GENERAL_DEFAULT_OUTFIT_NAME = "alex default"
  
  # This is the main storage location for outfit-related data. It contains
  # the amount of distance that can be traveled up/down/sideways, different
  # graphics and different sounds for different outfits.
  # Note: Put 0 or "none" for things that aren't used.
  #
  # To change the "outift" used for a player or follower, do it with the
  # script call $game_actors[actorID].changeActorlcmOutfit("newOutfitName")
  # in a map event.
  #
  # Note 1: If you need to refresh the outfit data stored by the player
  # and their followers (if applicable) at an arbitrary time, use the script call
  # $game_player.doFullOutfitRefresh
  # in a map event. This is done automatically if using changeActorlcmOutfit, though.
  #
  # Note 2: To update the player (and possibly follower's) graphics (and speed,
  # if enabled) to fit their current outfit, use script call
  # $game_player.restoreOutfitGraphicAndSpeed
  # in a map event. Or
  # $game_player.restoreOutfitGraphicAndSpeed(true)
  # to also update followers.
  #
  # Note 3: To check the current outfit for a given actor, you can use
  # the script call $game_actors[actorID].getActorlcmOutfit, which will
  # return the name of the outfit as a string of text.
  # To check the player'ss current outfit, you can use the script call
  # $game_player.getPlayerlcmOutfit, which will return the name
  # of the outfit as a string of text.
  # An example of how to use these script calls would be making
  # a conditional branch with different text depending on the
  # player's current outfit. This would be done with the "script"
  # option on tab 4 of the conditional branch command's page.
  # Example: $game_player.getPlayerlcmOutfit == "alex in hat"
  #
  # Note 4: For more detailed information on what each piece of outfit data is, 
  # see the "more detailed outfit data descriptions" futher below.
  #
  # format:
  #   "outfitName" => [
  #     "normalWalkingGraphic", normalWalkingSpeed, "normalJumpingGraphic", jumpUpHeight, jumpDownHeight, jumpSEName, jumpSEVol, jumpSEPitch,
  #     "unsafeFallImpactGraphic", unsafeFallRecoverTime, "unsafeFallRecoverySEName", "unsafeFallRecoverySEVol", "unsafeFallRecoverySEPitch"
  #     "sideFallGraphic", "sideJumpGraphic", sideJumpDistance,
  #     outfitDashDisabledTrueOrFalse enableDashMomentumTrueOrFalse, treatWalkingLikeDashingTrueOrFalse, "normalDashingGraphic", dashJumpDistance,
  #     {"ropetype1DatasetName" => ["climbingGraphic", climbingSpeed], ""=>[...], ...}
  #   ]
  # Ex.
  # Note: this example is somewhat more advanced that standard lisa movement.
  # LCM_FALL_AND_JUMP_OUTFIT_DATA = {
  #   "alex default" => [
  #     # Normal jumping data: Normal non-jump/walking graphic, walking speed (1-6), Jumping graphic, Jump up height, Jump down height, Jump SE name, Jump SE volume, Jump SE pitch
  #     "$Alex in rags", 4, "$Alex in rags jumps", 2, 2, "Rustle", 70, 100,
  #     # Unsafe fall data: Fallen graphic, Max safe fall distance, Unsafe fall recovery time (in frames), Recover SE name, Recover SE volume, Recover SE pitch
  #     "$Alex in rags drop", 60, "Rustle", 70, 105,
  #     # Side falling/jumping data: Side fall graphic, Side jump graphic, Side jump distance
  #     "$Alex in rags jumps", "$Alex in rags jumps", 0,
  #     # Dash jumping data: Dashing disabled?, Enable dash momentum?, Treat walking like dashing? (for vehicles), Normal non-jump dash graphic, Side dash jump graphic, Side dash jump distance
  #     true, false, false, "$Alex in rags", "$Alex in rags jumps", 0,
  #     # Ropes data: [rope dataset name => [rope climbing graphic, climbing speed], ""=>[...], ...}
  #     {"rope" => ["$Alex in Rags climbing", 3], "vines" => ["$Alex in rags vines climbing", 3]}
  #   ],
  #   "joel default" => [
  #     # Normal jumping data: Normal non-jump/walking graphic, walking speed (1-6), Jumping graphic, Jump up height, Jump down height, Jump SE name, Jump SE volume, Jump SE pitch
  #     "$Joel Miller1", 4, "$Joel Miller5", 2, 2, "Rustle", 70, 100,
  #     # Unsafe fall data: Fallen graphic, Max safe fall distance, Unsafe fall recovery time (in frames), Recover SE name, Recover SE volume, Recover SE pitch
  #     "$Joel Miller sits", 60, "Rustle", 70, 105,
  #     # Side falling/jumping data: Side fall graphic, Side jump graphic, Side jump distance
  #     "$Joel Miller5", "$Joel Miller5", 0,
  #     # Dash jumping data: Dashing disabled?, Enable dash momentum?, Treat walking like dashing? (for vehicles), Normal non-jump dash graphic, Side dash jump graphic, Side dash jump distance
  #     true, false, false, "$Joel Miller1", "$Joel Miller5", 0,
  #     # Ropes data: [rope dataset name => [rope climbing graphic, climbing speed], ""=>[...], ...}
  #     {"rope"=> ["$Joel climbing", 3], "vines" => ["$Joel vines climbing", 3]}
  #   ]
  # }
  LCM_FALL_AND_JUMP_OUTFIT_DATA = {
    "alex default" => [
      # Normal jumping data: Normal non-jump/walking graphic, walking speed (1-6), Jumping graphic, Jump up height, Jump down height, Jump SE name, Jump SE volume, Jump SE pitch
      "$Alex in rags", 4, "$Alex in rags jumps", 2, 2, "Rustle", 70, 100,
      # Unsafe fall data: Fallen graphic, Max safe fall distance, Unsafe fall recovery time (in frames), Recover SE name, Recover SE volume, Recover SE pitch
      "$Alex in rags drop", 60, "Rustle", 70, 105,
      # Side falling/jumping data: Side fall graphic, Side jump graphic, Side jump distance
      "$Alex in rags jumps", "$Alex in rags jumps", 1,
      # Dash jumping data: Dashing disabled?, Enable dash momentum?, Treat walking like dashing? (for vehicles), Normal non-jump dash graphic, Side dash jump graphic, Side dash jump distance
      false, true, false, "$Alex in rags head down", "$Alex in rags jumps", 2,
      # Ropes data: [rope dataset name => [rope climbing graphic, climbing speed], ""=>[...], ...}
      {"rope" => ["$Alex in Rags climbing", 3], "vines" => ["$Alex in rags vines climbing", 3]}
    ],
    "joel default" => [
      # Normal jumping data: Normal non-jump/walking graphic, walking speed (1-6), Jumping graphic, Jump up height, Jump down height, Jump SE name, Jump SE volume, Jump SE pitch
      "$Joel Miller1", 4, "$Joel Miller5", 2, 2, "Rustle", 70, 100,
      # Unsafe fall data: Fallen graphic, Max safe fall distance, Unsafe fall recovery time (in frames), Recover SE name, Recover SE volume, Recover SE pitch
      "$Joel Miller sits", 60, "Rustle", 70, 105,
      # Side falling/jumping data: Side fall graphic, Side jump graphic, Side jump distance
      "$Joel Miller5", "$Joel Miller5", 1,
      # Dash jumping data: Dashing disabled?, Enable dash momentum?, Treat walking like dashing? (for vehicles), Normal non-jump dash graphic, Side dash jump graphic, Side dash jump distance
      false, true, false, "$Joel Miller1", "$Joel Miller5", 2,
      # Ropes data: [rope dataset name => [rope climbing graphic, climbing speed], ""=>[...], ...}
      {"rope"=> ["$Joel climbing", 3], "vines" => ["$Joel vines climbing", 3]}
    ]
  }
  
  # Used to override the normal unsafe fall SE that would get used based off
  # of terrain tags for a fall impact for particular outfits.
  #
  # format:
  #   "outfitName" => [SE name, SE volume, SE pitch]
  # Ex.
  # LCM_UNSAFE_FALL_IMPACT_OUTFIT_OVERRIDE_SE_DATA = {
  #   "alex vehicle 1" => ["clang", 50, 100],
  #   "alex vehicle 2" => ["clang", 70, 80]
  # }
  LCM_UNSAFE_FALL_IMPACT_OUTFIT_OVERRIDE_SE_DATA = {
    
  }
  
  # Used to override the normal damage number amount that would get used based off
  # of terrain tags for a fall impact.
  #
  # Note: The animations for the damage numbers are still based off of terrain tags.
  #
  # format:
  #   "outfitName" => {
  #     fallHeight => damageAmount
  #   }
  # Ex.
  # LCM_FALL_HEIGHT_DAMAGE_NUMBER_OUTFIT_OVERRIDE = {
  #   "alex vehicle" => {
  #     5 => 10,
  #     6 => 10,
  #     7 => 10,
  #     8 => 50,
  #     9 => 100,
  #     10 => 200
  #   }
  # }
  LCM_FALL_HEIGHT_DAMAGE_NUMBER_OUTFIT_OVERRIDE = {
    "rubio cart" => {
      7 => 10,
      8 => 50,
      9 => 100,
      10 => 200
    },
    "rubio hat cart" => {
      7 => 10,
      8 => 50,
      9 => 100,
      10 => 200
    }
  }
  
  # The max "safe" fall height where no damage is taken for the outfit overrides.
  #
  # format:
  #   "outfitName" => maxSafeFallHeight
  # Ex.
  # LCM_MAX_SAFE_FALL_HEIGHTS_OVERRIDE = {
  #   "alex vehicle" => 4
  # }
  LCM_MAX_SAFE_FALL_HEIGHTS_OVERRIDE = {
    "rubio cart" => 6,
    "rubio hat cart" => 6
  }
  
  # *** MORE DETAILED OUTFIT DATA DESCRIPTIONS ***
  # Note: These description say "player" for the sake of readability, but
  # this also applies for any followers.
  
  #   Normal Walking Graphic
  # The filename for the normal graphic to use for the player's walking animation.
  # The player graphic resets to this one after a jump/fall is complete.
  # Make sure to include the symbols at the beginning of names still if
  # the sheet has them (the same is true with all other filenames).
  
  #   Walking Speed
  # This is the numerical speed (1-6) to set for the character when 
  # they are the player (the character being controlled by the player).
  # Followers take the speed of the player, so note that if you have
  # followers, they will be set to the same speed as the player
  # when the player is faster or slower than them. Set to 0 to mark
  # that the outfit should never affect the player's walk speed.
  # Speed guide:
  #  1: 8x Slower than normal
  #  2: 4x Slower than normal
  #  3: x2 Slower than normal
  #  4: Normal speed
  #  5: x2 Faster than normal
  #  6: x4 Faster than normal
  
  #   Normal Jump Graphic
  # The filename of the graphic to use when starting a jump/fall
  # Make sure to include the symbols at the beginning of names still if
  # the sheet has them.
  
  #   Normal Jump Up/Down Height
  # How many tiles up or down the player can jump to get to other platorms.
  # In the case that there are multiple available platforms in jumping range,
  # the closest platform will be jumped to.
  
  #   Normal Jump Sound Data
  # The sound data (filename, volume, pitch) used for the sound of the jump/fall
  # itself (not impacting against the ground if damage taken).
  # It includes:
  # The filename of the sound effect to use when starting a jump/fall
  # The volume of the sound effect to use when starting a jump/fall
  # The pitch of the sound effect to use when starting a jump/fall
  
  #   Fallen Graphic
  # The filename of the graphic to use when the player impacts into the ground
  # after falling from an "unsafe" height (one which causes damage).
  
  #   Fallen Recovery Time
  # The amount of time (in frames) to wait to get up after an unsafe landing.
  # For reference, RPGMaker VXAce runs at 60 FPS.
  
  #   Fallen Recovery Sound Data
  # The sound data (filename, volume, pitch) used for the sound of getting up
  # after an unsafe fall (impacting the ground after taking damage).
  # It includes:
  # The filename of the sound effect to use when recovering from landing from an "unsafe" height
  # The volume of the sound effect to use when recovering from landing from an "unsafe" height
  # The pitch of the sound effect to use when recovering from landing from an "unsafe" height
  
  #   Side Falling Graphic
  # The filename of the graphic to use when the player is falling to the side of
  # a ledge. Note that this is also used for side falls with momentum (for dash
  # falls with momentum enabled).
  
  #   Side Jump Graphic
  # The filename of the graphic to use when the player jumps across a gap with
  # a side jump.
  
  #   Side Jump Distance
  # The size of gaps between platforms that the player can jump across.
  
  #   Disable Dashing?
  # This is a true or false value that determines whether or not the outfit
  # prevents you from dashing. This mainly intended for vehicles, but could
  # be used in other ways too.
  
  #   Use Dash Momentum?
  # This is a true or false value that determines whether or not to use momentum
  # when dashing. This may be used for vehicles where walking is treated like
  # dashing, or for actual dashing.
  # If enabled, this uses the LCM_DASH_JUMP_TILES_DOWN and
  # LCM_DASH_JUMP_ACROSS_TILES to calculate an arc for falling when a
  # ledge cannot be jumped to with a dash jump.
  
  #   Treat Walking Like Dashing?
  # This is a true or false value that determines whether or not walking should
  # be treated like dashing for the purpose of choosing the correct form of
  # side jump or potential side fall to use. This is a feature intended for
  # vehicles, so that vehicles can use momentum falling while still technically
  # "walking". Note that, when this feature is on, even if
  # LCM_USE_SEPARATE_DASH_GRAPHICS is on, it will still use the walking graphic
  # when walking around normally (not jumping/falling), as you are not
  # *actually* dashing. Treat Walking Like Dashing? is also unaffected by
  # the LCM_GLOBAL_DASH_DISABLE and map-specific dash disables, so vehicles
  # that use this form of "dashing" will work even if player dashing is
  # not used.
  
  #   Normal Dashing Graphic
  # The filename of the graphic that gets switched to after a dash jump is complete.
  # Set this to the normal walking graphic if LCM_USE_SEPARATE_DASH_GRAPHICS
  # is not being used.
  
  #   Dash Jump Graphic
  # The filename of the graphic to use when the player jumps across a gap with
  # a dash jump. This may also be used for side falls with momentum if the
  # LCM_USE_DASH_JUMP_GRAPHIC_ON_MOMENTUM_FALL is enabled.
  
  #   Dash Jump Distance
  # The size of gaps between platforms that the player can jump across when dashing.
  
  #   Rope Dataset Name
  # The name of a set of data associated with a "type" of rope. This
  # could be for a normal rope, a ladder, some vines, etc.
  # Additionally, this name will be used when rope-related script
  # calls are done in ropes common events. Note that if
  # an outfit does not have data for the associated rope, they will
  # be prevented from climbing it (if lcm rope tags are being used).
  
  #   Rope Climbing Graphic
  # The filename of the graphic to use when the player is climbing
  # on the rope.
  
  #   Rope Climbing Speed
  # This is the numerical speed (1-6) for the player when climbing
  # on the rope.
  # Speed guide:
  #  1: 8x Slower than normal
  #  2: 4x Slower than normal
  #  3: x2 Slower than normal
  #  4: Normal speed
  #  5: x2 Faster than normal
  #  6: x4 Faster than normal
  #   --------------------------------- 
  
  
  
  # BEGINNING OF SCRIPTING ====================================================
  # DO NOT MODIFY PAST THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING!
  
  # EVENT LCM MOVEMENT CURRENTLY UNSUPPORTED, DO NOT UNCOMMENT UNLESS YOU KNOW
  # WHAT YOU ARE DOING
  # Whether or not to use LCM movement for events that have the
  # [LCMove "outfitName"] event name tag. Turning this off if your game does
  # not use this saves processing time.
  #
  # Additionally, use "$game_map.changelcmEventMovementToggle(trueOrFalse)" as a map
  # event script line to flip this on and off during gameplay runtime
  #LCM_EVENT_MOVEMENT = true
  # END OF UNSUPPORTED MATERIAL
  
  # Accepted data symbol list that assigns symbols to indexes in the outfit
  # data results.
  LCM_DATA_SYMBOL_INDEX_TABLE = {
    :normalWalkingGraphic => 0,
    :normalWalkSpeed => 1,
    :normalJumpGraphic => 2,
    :normalJumpUpHeight => 3,
    :normalJumpDownHeight => 4,
    :normalJumpSEName => 5,
    :normalJumpSEVol => 6,
    :normalJumpSEPitch => 7,
    
    :unsafeFallImpactGraphic => 8,
    :unsafeFallRecoveryTime => 9,
    :unsafeFallRecoverSEName => 10,
    :unsafeFallRecoverSEVol => 11,
    :unsafeFallRecoverSEPitch => 12,
    
    :sideFallingGraphic => 13,
    :sideJumpGraphic => 14,
    :sideJumpDistance => 15,
    
    :dashingDisable => 16,
    :useDashMomentum => 17,
    :treatWalkLikeDash => 18,
    :normalDashingGraphic => 19,
    :dashJumpGraphic => 20,
    :dashJumpDistance => 21,
    
    :ropesDataList => 22
  }
  
  #--------------------------------------------------------------------------
  # * New method used to get a piece of data from the outfit dataset
  # * given the name of the outfit (datasetName) and the ID of the
  # * piece of data (dataSymbol). Serves as a lookup table.
  #--------------------------------------------------------------------------
  # Call this method in a map event with:
  # "LCM.getlcmDatasetData("outfitName", :dataSymbolName)"
  def self.getlcmDatasetData(datasetName, dataSymbol)
    # get the appropriate index for the hash data from the symbol table
    dataIndex = LCM_DATA_SYMBOL_INDEX_TABLE[dataSymbol]
    # return the appropriate piece of data
    return ((LCM_FALL_AND_JUMP_OUTFIT_DATA[datasetName])[dataIndex])
  end
  
  #--------------------------------------------------------------------------
  # * New method used to get the max safe fall distance given the active
  # * terrain tag for whatever the tile in question is, and the active
  # * outfit for the character.
  #--------------------------------------------------------------------------
  def self.getMaxSafeFallDist(activeTerrainTag, activeOutfit)
    # start with the default max safe fall height
    maxSafeFallHeightResult = LCM_MAX_SAFE_FALL_HEIGHT_DEFAULT
    
    # if there is a specified max safe height for the active terrain tag,
    # then use that instead of the default
    if (LCM_MAX_SAFE_FALL_HEIGHTS.has_key?(activeTerrainTag))
      maxSafeFallHeightResult = LCM_MAX_SAFE_FALL_HEIGHTS[activeTerrainTag]
    end
    
    # if there is an outfit override for the max safe fall damage, then use that
    # instead of anything else
    if (LCM_MAX_SAFE_FALL_HEIGHTS_OVERRIDE.has_key?(activeOutfit))
      maxSafeFallHeightResult = LCM_MAX_SAFE_FALL_HEIGHTS_OVERRIDE[activeOutfit]
    end
    
    return (maxSafeFallHeightResult) # return the max safe height
  end
  
end


class Game_CharacterBase
  # The last direction the character walked. Stored for the purpose of
  # fall-checking.
  attr_accessor :lastDirection
  
  # Whether or not a follower avoided a game over for the last move.
  # Stored so that game-over checking does not have to be done
  attr_accessor :lastMoveGameOverAvoided
  
  # The "outfit" to use storing all the lcm movement graphics, sounds, etc.
  attr_accessor :lcmMovementOutfit
  
  # Keeps track of if an outfit refresh is needed for the character.
  # should be true when initialized.
  attr_accessor :characterOutfitRefreshNeeded
  
  #--------------------------------------------------------------------------
  # * Aliased initialize() method for Game_CharacterBase used to initialize
  # * the new variables for Game_CharacterBase.
  #--------------------------------------------------------------------------
  alias before_lcm_characterbase_new_data_init initialize
  def initialize
    # call original method
    before_lcm_characterbase_new_data_init
    
    @lcmStayImmobile = false # should start being able to move normally
    @lastDirection = 2 # start with the last direction as down
    
    # if the object is a game event, then start with no outfit for now
    if (self.kind_of?(Game_Event))
      @lcmMovementOutfit = "none"
    end
    @characterOutfitRefreshNeeded = true # start by requiring an outfit refresh
    
    # start with lastMoveGameOverAvoided as false
    @lastMoveGameOverAvoided = false
  end
  
  #--------------------------------------------------------------------------
  # * New method used to change the outfit the player, follower, or event
  # * is wearing.
  #--------------------------------------------------------------------------
  # Note: this is only meant to be called from within the script, not by
  # by the script user. Use:
  # "$game_actors[actorID].changeActorlcmOutfit("newOutfitName")"
  # to change a character's outfit in an event
  def changeCharacterOutfit(newOutfitName)
    @lcmMovementOutfit = newOutfitName # set lcmMovementOutfit to the newOutfitName
    
    # refresh the outfit as well
    @characterOutfitRefreshNeeded = true
  end
  
  #--------------------------------------------------------------------------
  # * New method used to refresh the character outfit. Does nothing if
  # * a refresh is not needed, or if the character does not have a
  # * corresponding actor.
  #--------------------------------------------------------------------------
  def refreshCharacterOutfitByActor
    # only refresh the outfit if an outfit is needed
    # (a refresh is needed when running this function for the first time after
    # initialization)
    if (@characterOutfitRefreshNeeded == true)
      # for players, use the lcmGetPlayerActorID() method to then get
      # the player's current outfit.
      # for followers, use the getFollowerActorID() method instead.
      if (self.kind_of?(Game_Player))
        actorID = self.lcmGetPlayerActorID
        @lcmMovementOutfit = $game_actors[actorID].currentlcmOutfit
        
        # set the player's move speed to the one specified in the outfit
        # if the toggle to use outfit move speed is on, and the move
        # speed value is not 0
        
        # get whether or not outfit walk speed is enabled
        outfitWalkSpeedEnabled = $game_party.getExSaveData("lcmUseOutfitWalkSpeedToggle", LCM::LCM_USE_OUTFIT_WALK_SPEED)
        # if outfit walk speed is enabled, then activate change the player walk
        # speed to the outfit speed if it is not set to 0.
        if (outfitWalkSpeedEnabled)
          # get the jump up height associated with the active outfit
          outfitWalkSpeed = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkSpeed)
          if (outfitWalkSpeed != 0) # make sure the speed is not 0
            @move_speed = outfitWalkSpeed
          end
        end
        
      elsif (self.kind_of?(Game_Follower))
        actorID = self.getFollowerActorID
        
        # set outfit if follower not tied to actor (actorID -1)
        if (actorID != -1)
          @lcmMovementOutfit = $game_actors[actorID].currentlcmOutfit
        else
          # outfit is none is follower is not tied to actor
          @lcmMovementOutfit = "none"
        end
      end
      
      # an outfit refresh is no longer needed, so set the refresh flag to false
      @characterOutfitRefreshNeeded = false
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Overridden move_straight() method used to decide (and possibly execute)
  # * and lcm form of movement if the appropriate conditions are met.
  # * This method forms the "heart" of the script.
  # *
  # * Direction guide:
  # *   d:       Direction (2-down,4-left,6-right,8-up)
  # *   turn_ok: Allows change of direction on the spot
  #--------------------------------------------------------------------------
  def move_straight(d, turn_ok = true)
    return if @lcmStayImmobile
    
    # Whether or not all requirements have been met to really use the script at all
    allScriptExecutionReqsMet = true # start true, must prove false
    # Whether or not all requirements have been met to activate a ledge jump
    allLedgeJumpReqsMet = true # start true, must prove false
    
    # Whether or not the script's movement is enabled
    # Get the value stored in exSaveData. Also will initialize the value to LCM_TOGGLE_INIT
    # just in case the value was not set originally
    totalScriptToggleEnabled = $game_party.getExSaveData("lcmScriptToggle", LCM::LCM_TOGGLE_INIT)
    
    # if all other allScriptExecutionReqs have been met so far, then set
    # the value of allScriptExecutionReqsMet to the script toggle value (true or false)
    if (allScriptExecutionReqsMet == true)
      # get the value stored in exSaveData. Also will initialize the value to LCM_TOGGLE_INIT
      # just in case the value was not set originally
      allScriptExecutionReqsMet = totalScriptToggleEnabled
    end
    
    # Check if the current character is a player or follower. If they are neither,
    # then set the value of allScriptExecutionReqsMet to false (FOR NOW.....)
    if (!(self.kind_of?(Game_Player) || self.kind_of?(Game_Follower)) )
      allScriptExecutionReqsMet = false
    end
    
    # if all other allScriptExecutionReqs have been met so far, and whether the
    # current object is a game follower. If both conditions are met, then
    # allScriptExecutionReqsMet will be false if followers are not enabled (and true if enabled)
    if ((allScriptExecutionReqsMet == true) && (self.kind_of?(Game_Follower)))
      # get the value stored in exSaveData. Also will initialize the value to LCM_FOLLOWERS_ENABLED
      # just in case the value was not set originally
      allScriptExecutionReqsMet = $game_party.getExSaveData("lcmFollowerToggle", LCM::LCM_FOLLOWERS_ENABLED)
      
      # additionally, if all scriptExecutionReqs still met, then
      # allScriptExecutionReqsMet will be false if the follower object does not
      # have an actor assigned to it. (invisible, actorless follower objects follow
      # the player even if)
      if (allScriptExecutionReqsMet == true)
        allScriptExecutionReqsMet = isFollowerAssigned?
      end
    end
    
    # get whether or not follower lcm movement is enabled
    areFollowersEnabled = $game_party.getExSaveData("lcmFollowerToggle", LCM::LCM_FOLLOWERS_ENABLED)
    # get whether or not the character is a follower
    charIsFollower = self.kind_of?(Game_Follower)
    # get whether or not follower game overs are disabled
    followersGameOverDisabled = !(LCM::LCM_FOLLOWER_GAMEOVER_ALLOWED)
    # whether or not game-over checking should be done for a follower
    doFollowerGameOverChecks = ( (allScriptExecutionReqsMet == true) && (areFollowersEnabled == true) && (charIsFollower) && (followersGameOverDisabled) )
    # don't do follower game over checks if through is on
    if (self.through == true)
      doFollowerGameOverChecks = false
    end
    # whether or not game over checking was already done for the cliff and follower.
    # if the last move's direction is different to the the new direction,
    # or a gameOver was not avoided last move, then followerGameOverChecksNecessary is false
    followerGameOverChecksNecessary = ((d != @lastDirection) || (!@lastMoveGameOverAvoided))
    
    # if followerGameOverChecks not necessary and lastMoveGameOverAvoided,
    # then immediately return so the move is not gone through with
    if (!followerGameOverChecksNecessary && @lastMoveGameOverAvoided)
      # only return if through is not on for the follower
      if (self.through == false)
        return
      end
    end
    
    # if the extra game over checking is being used, do the checks here.
    if (doFollowerGameOverChecks && followerGameOverChecksNecessary)
      # see if the move would succeed based on passability first
      moveWillSucceed = passable?(@x, @y, d)
      
      # start with lcmGameOverCaused as false
      lcmGameOverCaused = false
      
      # only check it if the character movement was left (4) or right (6), and the
      # movement will succeed
      if (moveWillSucceed == true && (d == 4 || d == 6))
        # start by refreshing character outfit
        refreshCharacterOutfitByActor
        
        # do the game over checks only if the move will succeed in passability
        # followerGameOverChecks returns true if a game over would be caused,
        # otherwise, false
        lcmGameOverCaused = followerGameOverChecks(d)
        # update lastMoveGameOverAvoided
        @lastMoveGameOverAvoided = lcmGameOverCaused
        
      end
      
      # return (do not move) if the fall would cause a game over,
      # otherwise, continue as normal
      return if lcmGameOverCaused
    end
    
    # checks if the move would succeed with "normal" movement in terms of
    # tile passability
    @move_succeed = passable?(@x, @y, d)
    
    # only do any ropes passability checks for players and visible followers
    # with an outfit set up
    if (self.kind_of?(Game_Player) || (self.kind_of?(Game_Follower) && self.visible?) && self.lcmMovementOutfit != nil)
      # if the character is currently on a rope, perform checks for (potentially)
      # leaving the rope
      if (self.inRopesMode? == true)
        @move_succeed = self.checkLeavingRopesPassability(@move_succeed, d)
      # if the character is not currently on a rope, check if the character
      # is trying to climb onto a rope from above it
      else
        # only do these checks if the move initially failed and the direction
        # being moved in is down (2)
        if (@move_succeed == false && d == 2)
          # get the current active rope type stored in exSaveData
          currActiveRopeType = $game_party.getExSaveData("lcmCurrentActiveRopeType", LCM::LCM_INITIAL_ACTIVE_ROPE_TYPE)
          # if there is a valid rope to move to, then the returned value will
          # be true
          @move_succeed = self.aboveRopePassabilityOverride(currActiveRopeType)
        end
      end
      
      # only do any ropes passability checks if the move succeeded with
      # the regular passability check and debug through is not on
      if (@move_succeed == true && $game_player.debug_through? == false && self.lcmMovementOutfit != nil)
        # get the current active rope type stored in exSaveData
        currActiveRopeType = $game_party.getExSaveData("lcmCurrentActiveRopeType", LCM::LCM_INITIAL_ACTIVE_ROPE_TYPE)
        # if the ropes passability check fails, set move_succeed to false
        if (checkCharRopesTilePassability(currActiveRopeType, d) == false)
          @move_succeed = false
        end
      end
      
      # if debug through is on, just ensure the movement happens
      if ($game_player.debug_through? == true)
        @move_succeed = true
      end
    end
    
    # if the move would succeed, activate sideFallChecks if moving left/right.
    if (@move_succeed)
      # -----
      # this section is from the original method, and is what actually
      # moves the player for a successful "normal" movement.
      set_direction(d)
      @x = $game_map.round_x_with_direction(@x, d)
      @y = $game_map.round_y_with_direction(@y, d)
      @real_x = $game_map.x_with_direction(@x, reverse_dir(d))
      
      # if the character is the player then perform the ropes check
      # for updating characters to be in "ropes mode" or not with
      # whatever the current active rope type is
      if (self.kind_of?(Game_Player) && self.lcmMovementOutfit != nil)
        # get the current active rope type stored in exSaveData
        currActiveRopeType = $game_party.getExSaveData("lcmCurrentActiveRopeType", LCM::LCM_INITIAL_ACTIVE_ROPE_TYPE)
        $game_player.performPlayerRopesCheck(currActiveRopeType)
      end
      
      # get whether or not follower lcm movement is enabled for followers
      areFollowersEnabled = $game_party.getExSaveData("lcmFollowerToggle", LCM::LCM_FOLLOWERS_ENABLED)
      # if followers are enabled and the current character is a follower then
      # do the follower versions of the ropes check for updating characters
      # to be in "ropes mode" or not with whatever the current active rope type is
      if (areFollowersEnabled == true && self.kind_of?(Game_Follower))
        # get the current active rope type stored in exSaveData
        currActiveRopeType = $game_party.getExSaveData("lcmCurrentActiveRopeType", LCM::LCM_INITIAL_ACTIVE_ROPE_TYPE)
        # only do the ropes check if the follower is visible
        if (self.visible? && self.lcmMovementOutfit != nil)
          $game_player.performFollowerRopesCheck(self, currActiveRopeType)
        end
      end
      
      # actually take the step
      increase_steps
      # ------
      
      # if allScriptExecutionReqsMet so far, and CHECK_EVENT_INDIVIDUAL_OFF_TAGS
      # is enabled, then events should be checked for individual lcm script
      # off tags
      if ((allScriptExecutionReqsMet == true) && (LCM::LCM_CHECK_EVENT_INDIVIDUAL_OFF_TAGS == true))
        # only check the event if the character is either the player,
        # OR the LCM_APPLY_OFF_TAGS_TO_PLAYER_ONLY setting is off
        if ((self.kind_of?(Game_Player)) || (LCM::LCM_APPLY_OFF_TAGS_TO_PLAYER_ONLY == false))
          # use the $game_map method to check the prospective tile for
          # a lcm script disabling event. Will return true if one is
          # found, otherwise false.
          tileContainslcmOffToggleEvent = $game_map.checklcmScriptOffTag(@x, @y)
          # if the tile contains an lcmOffToggleEvent, then turn off allScriptExecutionReqsMet
          if (tileContainslcmOffToggleEvent == true)
            allScriptExecutionReqsMet = false
          end
        end
      end
      
      # if allScriptExecutionReqs met so far then check for a special
      # script disabling exception so characters do not fall off platforms
      # when going to a horizontal rope off of a platform.
      if (allScriptExecutionReqsMet == true)
        # get the current active rope type stored in exSaveData
        currActiveRopeType = $game_party.getExSaveData("lcmCurrentActiveRopeType", LCM::LCM_INITIAL_ACTIVE_ROPE_TYPE)
        
        # make sure the character has an lcm outfit set up
        if (self.lcmMovementOutfit != nil)
          # if the conditions for disabling are met, disable the script's effects
          if ($game_map.sidewaysRopeAutolcmDisable(self, currActiveRopeType))
            allScriptExecutionReqsMet = false
          end
        end
      end
      
      # if allScriptExecutionReqs met so far then check if the player is
      # currently on a rope. if they are, then disable the lcm script
      # for them so they don't jump down to platforms or anything
      # only do any ropes passability checks for players and visible followers

        
      # disables lcm movement while on ropes so that the player doesn't
      # try to jump onto a ledge while on any kind of rope
      if (allScriptExecutionReqsMet == true)
        if (self.kind_of?(Game_Player) || (self.kind_of?(Game_Follower) && self.visible?))
          # if the character is on a rope, turn allScriptExecutionReqs to false
          if (self.inRopesMode?)
            allScriptExecutionReqsMet = false
          end
        end
      end
      
      # only do the lcm things here if allScriptExecutionReqs are met
      if (allScriptExecutionReqsMet == true)
        # make sure character outfit aligns with the one in the associated
        # actor (if there is one)
        refreshCharacterOutfitByActor
        
        # Checks/actions for if "falling" should be activated when moving
        # left or right (wil activate if moved off a ledge) are done here
        if (d == 4) # left data saving
          # save data to be used when the character comes to a full stop
          # see method update_stop
          @lastDirection = d
          sideFallChecks(@lastDirection)
        elsif (d == 6) # right data saving
          # save data to be used when the character comes to a full stop
          # see method update_stop
          @lastDirection = d
          sideFallChecks(@lastDirection)
        end
        
      end
    # if the move wouldn't succeed, but the turn would, activate
    # jumpUpLedgeChecks or jumpDownLedgeChecks if moving up/down.
    elsif turn_ok
      
      set_direction(d) # update player direction
      
      if ((allScriptExecutionReqsMet == true) && (LCM::LCM_CHECK_EVENT_INDIVIDUAL_OFF_TAGS == true))
        # only check the event if the character is either the player,
        # OR the LCM_APPLY_OFF_TAGS_TO_PLAYER_ONLY setting is off
        if ((self.kind_of?(Game_Player)) || (LCM::LCM_APPLY_OFF_TAGS_TO_PLAYER_ONLY == false))
          # use the $game_map method to check the prospective tile for
          # a lcm script disabling event. Will return true if one is
          # found, otherwise false.
          tileContainslcmOffToggleEvent = $game_map.checklcmScriptOffTag(@x, @y)
          # if the tile contains an lcmOffToggleEvent, then turn off allScriptExecutionReqsMet
          if (tileContainslcmOffToggleEvent == true)
            allScriptExecutionReqsMet = false
          end
        end
      end
      
      # disables lcm movement while on ropes so that the player doesn't
      # try to jump onto a ledge while on any kind of rope
      if (allScriptExecutionReqsMet == true)
        if (self.kind_of?(Game_Player) || (self.kind_of?(Game_Follower) && self.visible?))
          # if the character is on a rope, turn allScriptExecutionReqs to false
          if (self.inRopesMode?)
            allScriptExecutionReqsMet = false
          end
        end
      end
      
      # only do the lcm things here if allScriptExecutionReqs are met
      if (allScriptExecutionReqsMet == true)
        # make sure character outfit aligns with the one in the associated
        # actor (if there is one)
        refreshCharacterOutfitByActor
        
        # if all other ledgeJumpReqs have been met so far, and the CharacterBase
        # object is the player, then do further checks
        if ((allLedgeJumpReqsMet == true) && (self.kind_of?(Game_Player)))
          # if the LCM_REQUIRE_Z_PRESS setting is on/true, then check
          # if the interact key is pressed. Set the allLedgeJumpReqsMet 
          # true/false value to the same as whether or not the interact key pressed
          if (LCM::LCM_REQUIRE_Z_PRESS)
            allLedgeJumpReqsMet = Input.trigger?(:C) # :C is the input for "Interact"
          end
        end
              
        # Checks/actions for if trying to go upwards/downwards to a platform are
        # done here
        # first, check that all requirements to ledge jump were met
        if (allLedgeJumpReqsMet == true)
          if (d == 8) # up checks/actions
            jumpUpLedgeChecks
          elsif (d == 2) # down checks/actions
            jumpDownLedgeChecks
          end
        end
        
        # get whether or not follower lcm movement is enabled
        areFollowersEnabled = $game_party.getExSaveData("lcmFollowerToggle", LCM::LCM_FOLLOWERS_ENABLED)
        # if character is the player, and lcm followers are enabled, then
        # activate all follower's chase_preceding_character() method
        # by invoking the move() method for them
        if (self.kind_of?(Game_Player) && (areFollowersEnabled == true))
          self.lcmGetPlayerFollowers.move
        end
      
      end
      
      # unchanged old method line, checks for event touch triggers
      check_event_trigger_touch_front
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to allow the player to jump up to a platform in
  # * their (up) jumping range, past impassible tiles. Activates jumpUpLedge()
  # * if a viable platform is found, otherwise does nothing.
  #--------------------------------------------------------------------------
  def jumpUpLedgeChecks
    # get direction (it will always be 8, as 8 is the "up" direction)
    d = 8
    
    origX = $game_map.round_x_with_direction(@x, d) # store original x
    # store original y, +1 to account for the position of the event being
    # ontop of potential ledges to jump on
    origY = $game_map.round_y_with_direction((@y + 1), d)
    
    tileNum = 0 # number of tiles searched
    platformFound = false # whether or not a platform has been found
    activeTerrainTag = 0 # 0 as default, decides what animations/sounds to use when hit ground
    # the x position should just stay the same as the original
    xPos = origX
    # y val to check first should be the origY
    yPos = origY
    # get the jump up height associated with the active outfit
    jumpUpHeight = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpUpHeight)
    # get whether or not platform events are enabled from exSaveData
    platformEventsEnabled = $game_party.getExSaveData("lcmPlatformEventsToggle", LCM::LCM_PLATFORM_EVENTS_ENABLED)
    # if trying to go upwards, check all tiles in the jump range until
    # a platform-tagged tile is found
    while ((tileNum < jumpUpHeight) && !platformFound)
      terrainTag = $game_map.terrainTagPlatformCheck(xPos, yPos) # get map tile terrain tag
      eventTerrainTag = -1 # set eventTerrainTag to -1 by default unless platform events have been enabled
      if (platformEventsEnabled == true)
        eventTerrainTag = $game_map.getEventPlatTerrainTagEquiv(xPos, yPos) # get event terrain tag equivalent
      end
      # if the list of platform terrain tags includes the terrain tag
      # currently being checked, if it does, mark the platform as found
      if (LCM::LCM_PLATFORM_TAGS.include?(terrainTag))
        platformFound = true
        activeTerrainTag = terrainTag
      # get the equivalent terrain tag for any event designated as a platform
      # with the [PLT #] notetag in its name. Will be -1 if no "platform"
      # events were found at the location.
      # if the equivalent terrain tag is not equal to -1, then
      elsif (eventTerrainTag != -1)
        platformFound = true
        # also set the activeTerrainTag to the event version, it takes priority
        # for deciding what sounds/animations to use
        activeTerrainTag = eventTerrainTag
      end
      
      # if the platform is not found, increment tile position upwards
      if (!platformFound)
        # increment the tile number by one
        tileNum += 1
        # decrease yPos by 1 to go up 1 in the tile search
        yPos -= 1
      end
    end
    
    # if an acceptable platform was found, jump up to the platform
    if (platformFound)
      # get the final destination y value
      destY = yPos - 1
      
      # calculate the difference between current and final y positions
      yDiff = (destY - origY).abs
      
      jumpUpLedge(yDiff) # go through with the actual jump
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create and run the move routes so a character can jump
  # * up to a platform. Requires the y difference between the character and
  # * the platform being jumped to.
  #--------------------------------------------------------------------------
  def jumpUpLedge(yDiff)
    # create new move route and set move route settings
    upLedgeMoveRoute = RPG::MoveRoute.new
    upLedgeMoveRoute.repeat = false
    upLedgeMoveRoute.skippable = false
    upLedgeMoveRoute.wait = true
    
    # create script movement command (will be used with different data repeatedly)
    # NOTE: the entries are executed in reverse order (to how it would normally
    # be set up in an event) due to how insertion works!!!
    movement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    movement.code = 0
    movement.parameters = []
    upLedgeMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to jump
    movement.code = 14 # 14 is for the "Jump" command
    # jump up to the negative y difference (y vals decrease going upward)
    movement.parameters = [0, -yDiff]
    # add the jump movement command to the move route
    upLedgeMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to turn on the character stepping animation
    movement.code = 33
    # add the walking animation enabling command
    upLedgeMoveRoute.list.insert(0, movement.clone)
    
    # get active outfit's graphic for ledge jumping
    ledgeJumpGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpGraphic)
    # create script movement command to change player graphic to the jumping graphic
    movement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the set jump graphic at position 0
    movement.parameters = [ledgeJumpGraphic, 0]
    # add the change graphic movement command
    upLedgeMoveRoute.list.insert(0, movement.clone)
    
    # get the active outfit's standard jump SE data
    jumpSEName = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEName)
    jumpSEVolume = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEVol)
    jumpSEPitch = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEPitch)
    # create script movement command to play the jump sound
    movement.code = 44 # 44 is for the "Play SE" command
    # set up the sound with filename, speed, pitch
    movement.parameters = [RPG::SE.new(jumpSEName, jumpSEVolume, jumpSEPitch)]
    # add the play SE movement command to the move route
    # (.clone makes it so that a copy of the original movement object's data)
    upLedgeMoveRoute.list.insert(0, movement.clone)
    
    # create new move route to execute AFTER the other one (it is set to
    # wait for completion to change the graphic back to normal) and set up the settings
    resetMoveRoute = RPG::MoveRoute.new
    resetMoveRoute.repeat = false
    resetMoveRoute.skippable = false
    resetMoveRoute.wait = false
    
    # create move command for the resetMoveRoute
    resetMovement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    resetMovement.code = 0
    resetMovement.parameters = []
    resetMoveRoute.list.insert(0, resetMovement.clone)
    
    # gets the appropriate walking/dashing graphic depending on if the player
    # is dashing or not
    correctWalkingOrDashingGraphic = "none" # start with "none" as the value
    if (dash?)
      # get whether or not separate dashing is enabled
      dashingEnabled = $game_party.getExSaveData("lcmSeparateDashingToggle", LCM::LCM_USE_SEPARATE_DASH_GRAPHICS)
      
      # if dashing is enabled, use the dashing graphic, otherwise, just use the normal one
      if (dashingEnabled)
        # get the active outfit's dashing graphic
        correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalDashingGraphic)
      else
        # get the active outfit's walking graphic
        correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
      end
      
    else
      # get the active outfit's walking graphic
      correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
    end
    # create script movement command to change player graphic back to the normal one
    resetMovement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the normal graphic at position 0
    resetMovement.parameters = [correctWalkingOrDashingGraphic, 0]
    # add the change graphic movement command
    resetMoveRoute.list.insert(0, resetMovement.clone)
    
    # create script movement command to turn off the character stepping animation
    resetMovement.code = 34
    # add the walking animation disabling command 
    resetMoveRoute.list.insert(0, resetMovement.clone)
    
    # run the move routes consecutively
    setuplcmCustomConsecutiveMoveRoutes(upLedgeMoveRoute, resetMoveRoute)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to allow the player to jump down to a platform in
  # * their (down) jumping range, past impassible tiles. Activates jumpDownLedge()
  # * if a viable platform is found, otherwise does nothing.
  #--------------------------------------------------------------------------
  def jumpDownLedgeChecks
    # get direction (it will always be 2, as 2 is the "down" direction)
    d = 2
    
    origX = $game_map.round_x_with_direction(@x, d) # store original x
    # store original y, +2 to account for the position of the event being
    # ontop of the ledge you are currently on, meaning the first available
    # ledge to jump on is two below the event (y increases going downwards)
    origY = $game_map.round_y_with_direction((@y + 1), d)
    
    tileNum = 0 # number of tiles searched
    platformFound = false # whether or not a platform has been found
    activeTerrainTag = 0 # 0 as default, decides what animations/sounds to use when hit ground
    # the x position should just stay the same as the original
    xPos = origX
    # y val to check first should be the origY
    yPos = origY
    # get the jump up height associated with the active outfit
    jumpDownHeight = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpDownHeight)
    # get whehter or not platform events are enabled from exSaveData
    platformEventsEnabled = $game_party.getExSaveData("lcmPlatformEventsToggle", LCM::LCM_PLATFORM_EVENTS_ENABLED)
    # if trying to go upwards, check all tiles in the jump range until
    # a platform-tagged tile is found
    while ((tileNum < jumpDownHeight) && !platformFound)
      terrainTag = $game_map.terrainTagPlatformCheck(xPos, yPos) # get map tile terrain tag
      eventTerrainTag = -1 # set eventTerrainTag to -1 by default unless platform events have been enabled
      if (platformEventsEnabled == true)
        eventTerrainTag = $game_map.getEventPlatTerrainTagEquiv(xPos, yPos) # get event terrain tag equivalent
      end
      # if the list of platform terrain tags includes the terrain tag
      # currently being checked, if it does, mark the platform as found
      if (LCM::LCM_PLATFORM_TAGS.include?(terrainTag))
        platformFound = true
        activeTerrainTag = terrainTag
      # get the equivalent terrain tag for any event designated as a platform
      # with the [PLT #] notetag in its name. Will be -1 if no "platform"
      # events were found at the location.
      # if the equivalent terrain tag is not equal to -1, then
      elsif (eventTerrainTag != -1)
        platformFound = true
        # also set the activeTerrainTag to the event version, it takes priority
        # for deciding what sounds/animations to use
        activeTerrainTag = eventTerrainTag
      end
      
      # if the platform is not found, increment tile position upwards
      if (!platformFound)
        # increment the tile number by one
        tileNum += 1
        # increase yPos by 1 to go down 1 in the tile search
        yPos += 1
      end
    end
    
    # if an acceptable platform was found, jump down to the platform
    if (platformFound)
      # get the final destination y value
      destY = yPos + 1
      
      # calculate the difference between current and final y positions
      yDiff = (destY - origY).abs
      
      jumpDownLedge(yDiff) # go through with the actual jump
    end
  end

  #--------------------------------------------------------------------------
  # * New method used to create and run the move routes so a character can jump
  # * down to a platform. Requires the y difference between the character and
  # * the platform being jumped to.
  # *
  # * Also, isSideFall is an optional parameter, that when set to true, will make
  # * the falling graphic be the sideFall graphic instead of the ledge jump graphic,
  # * since sideFalls that do not cause damage can share this method.
  #--------------------------------------------------------------------------
  def jumpDownLedge(yDiff, isSideFall = false)    
    # create new move route and set move route settings
    downLedgeMoveRoute = RPG::MoveRoute.new
    downLedgeMoveRoute.repeat = false
    downLedgeMoveRoute.skippable = false
    downLedgeMoveRoute.wait = true
    
    # create script movement command (will be used with different data repeatedly)
    # NOTE: the entries are executed in reverse order (to how it would normally
    # be set up in an event) due to how insertion works!!!
    movement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    movement.code = 0
    movement.parameters = []
    downLedgeMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to jump
    movement.code = 14 # 14 is for the "Jump" command
    # jump down to the y difference (y vals increase going downward)
    movement.parameters = [0, yDiff]
    # add the jump movement command to the move route
    downLedgeMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to turn on the character stepping animation
    movement.code = 33
    # add the walking animation enabling command
    downLedgeMoveRoute.list.insert(0, movement.clone)
    
    # get active outfit's graphic for ledge jumping
    ledgeJumpGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpGraphic)
    # if it's actually a sideFall using the method, then use side fall graphic
    if (isSideFall == true)
      ledgeJumpGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :sideFallingGraphic)
    end
    # create script movement command to change player graphic to the jumping graphic
    movement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the set jump graphic at position 0
    movement.parameters = [ledgeJumpGraphic, 0]
    # add the change graphic movement command
    downLedgeMoveRoute.list.insert(0, movement.clone)
    
    # get the active outfit's standard jump SE data
    jumpSEName = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEName)
    jumpSEVolume = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEVol)
    jumpSEPitch = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEPitch)
    # create script movement command to play the jump sound
    movement.code = 44 # 44 is for the "Play SE" command
    # set up the sound with filename, speed, pitch
    movement.parameters = [RPG::SE.new(jumpSEName, jumpSEVolume, jumpSEPitch)]
    # add the play SE movement command to the move route
    # (.clone makes it so that a copy of the original movement object's data)
    downLedgeMoveRoute.list.insert(0, movement.clone)
    
    # create new move route to execute AFTER the other one (it is set to
    # wait for completion to change the graphic back to normal) and set up the settings
    resetMoveRoute = RPG::MoveRoute.new
    resetMoveRoute.repeat = false
    resetMoveRoute.skippable = false
    resetMoveRoute.wait = false
    
    # create move command for the resetMoveRoute
    resetMovement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    resetMovement.code = 0
    resetMovement.parameters = []
    resetMoveRoute.list.insert(0, resetMovement.clone)
    
    # gets the appropriate walking/dashing graphic depending on if the player
    # is dashing or not
    correctWalkingOrDashingGraphic = "none" # start with "none" as the value
    if (dash?)
      # get whether or not separate dashing is enabled
      dashingEnabled = $game_party.getExSaveData("lcmSeparateDashingToggle", LCM::LCM_USE_SEPARATE_DASH_GRAPHICS)
      
      # if dashing is enabled, use the dashing graphic, otherwise, just use the normal one
      if (dashingEnabled)
        # get the active outfit's dashing graphic
        correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalDashingGraphic)
      else
        # get the active outfit's walking graphic
        correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
      end
      
    else
      # get the active outfit's walking graphic
      correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
    end
    # create script movement command to change player graphic back to the normal one
    resetMovement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the normal graphic at position 0
    resetMovement.parameters = [correctWalkingOrDashingGraphic, 0]
    # add the change graphic movement command
    resetMoveRoute.list.insert(0, resetMovement.clone)
    
    # create script movement command to turn off the character stepping animation
    resetMovement.code = 34
    # add the walking animation disabling command 
    resetMoveRoute.list.insert(0, resetMovement.clone)
    
    # run the move routes consecutively
    setuplcmCustomConsecutiveMoveRoutes(downLedgeMoveRoute, resetMoveRoute)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if a character has walked of the edge of
  # * a platform, and then if they did, either doing a side jump or dash jump
  # * if enabled or possible, or otherwise activating a fall. If the player
  # * is still over a platform, it will do nothing and return early.
  # *
  # * Also, forcedCheck is a parameter used by the method doPlayerFallCheck()
  # * activated by script call "$game_player.doPlayerFallCheck", which
  # * forces fall checking to occur even if it wouldn't normally.
  #--------------------------------------------------------------------------
  def sideFallChecks(direction, forcedCheck = false)
    # note: direction will either be 4 for left, or 6 for right
    
    origX = $game_map.round_x_with_direction(@x, direction) # store original x
    # store original y
    origY = $game_map.round_y_with_direction(@y, direction)
    
    # get whether or not platform events are enabled from exSaveData
    platformEventsEnabled = $game_party.getExSaveData("lcmPlatformEventsToggle", LCM::LCM_PLATFORM_EVENTS_ENABLED)
    
    # get the last tile's x value (orig X + 1 if went left (4), orig X - 1 if
    # went right (6))
    lastTileX = (direction == 4)? (origX + 2) : (origX - 2)
    # get the terrain tag of the last tile the player was on
    # (origY + 1 to check the tile BELOW the player's feet)
    lastTerrainTag = $game_map.terrainTagPlatformCheck(lastTileX, (origY + 1))
    lastEventTerrainTag = -1 # set lastEventTerrainTag to -1 by default unless platform events have been enabled
    if (platformEventsEnabled == true)
      # get the event terrain tag of the last tile the player was on
      # -1 if the last tile did not have a "platform" event
      lastEventTerrainTag = $game_map.getEventPlatTerrainTagEquiv(lastTileX, (origY + 1))
    end
    # if the tile below the player's feet and in the opposite direction
    # to the way they just moved is not a platform, then don't bother
    # checking anything else, just return early
    if ( (!(LCM::LCM_PLATFORM_TAGS.include?(lastTerrainTag))) && (lastEventTerrainTag == -1) && (!forcedCheck) )
      return
    end
    
    # if there is a platform under the player's feet, then return early
    
    # currentTile's X is origX + 1 if moving left, origX - 1 if moving right
    currentTileX = (direction == 4)? (origX + 1) : (origX - 1)
    # get the terrain tag of the current tile the player is on (after moving)
    # (origY + 1 to check the tile BELOW the player's feet)
    currentTerrainTag = $game_map.terrainTagPlatformCheck(currentTileX, (origY + 1))
    currentEventTerrainTag = -1 # set currentEventTerrainTag to -1 by default unless platform events have been enabled
    if (platformEventsEnabled == true)
      # get the event terrain tag of the current tile the player is on
      # -1 if the tile does not have a "platform" event
      currentEventTerrainTag = $game_map.getEventPlatTerrainTagEquiv(currentTileX, (origY + 1))
    end
    # if there is a platform tile OR a platform event below the player's feet,
    # return immediately
    if ( (LCM::LCM_PLATFORM_TAGS.include?(currentTerrainTag)) || (currentEventTerrainTag != -1) )
      return
    end
    
    # get the active outfit's side jump enable status (if side jump distance >0, then it is enabled)
    sideJumpEnabled = (LCM.getlcmDatasetData(@lcmMovementOutfit, :sideJumpDistance) > 0)
    # get the active outfit's dash enable status (if dash jump distance >0, then it is enabled)
    dashJumpEnabled = (LCM.getlcmDatasetData(@lcmMovementOutfit, :dashJumpDistance) > 0)
    
    # if any side jumps are enabled and it was not a forcedCheck, do side jump checks.
    if ( (!forcedCheck) && ((sideJumpEnabled == true) || (dashJumpEnabled == true)) )
      # sideJumpChecks runs the sideJump if the checks are met, and returns
      # 'true' if some form of sideJump was run.
      sideJumpWasRun = sideJumpChecks(direction)
      
      # if a sideJumpWasRun, then return immediately (since any falls have already
      # been done)
      if (sideJumpWasRun)
        return
      end
    end
    
    # if the previous two checks ("last tile was platform?" and "current tile is not platform?")
    # were met, and no side jump was run, then the player should fall down
    
    # check all tiles going downwards from the player until a platform is found,
    # OR the spot three tiles under the map is reached (when the player is sure
    # to be off the map screen)
    offMapEndPos = $game_map.height + 3 # three tiles below the map border, where player will not be seen
    tileNum = 0 # number of tiles searched
    platformFound = false # whether or not a platform has been found
    activeTerrainTag = 0 # 0 as default, decides what animations/sounds to use when hit ground
    # the x position be the new currentTileX
    xPos = currentTileX
    # y val to check first should be the origY + 1 to start at the tile below
    # the player's feet
    yPos = origY + 1
    while ((yPos < offMapEndPos) && !platformFound)
      terrainTag = $game_map.terrainTagPlatformCheck(xPos, yPos) # get map tile terrain tag
      eventTerrainTag = -1 # set eventTerrainTag to -1 by default unless platform events have been enabled
      if (platformEventsEnabled == true)
        eventTerrainTag = $game_map.getEventPlatTerrainTagEquiv(xPos, yPos) # get event terrain tag equivalent
      end
      # if the list of platform terrain tags includes the terrain tag
      # currently being checked, if it does, mark the platform as found
      if (LCM::LCM_PLATFORM_TAGS.include?(terrainTag))
        platformFound = true
        activeTerrainTag = terrainTag
      # get the equivalent terrain tag for any event designated as a platform
      # with the [PLT #] notetag in its name. Will be -1 if no "platform"
      # events were found at the location.
      # if the equivalent terrain tag is not equal to -1, then
      elsif (eventTerrainTag != -1)
        platformFound = true
        # also set the activeTerrainTag to the event version, it takes priority
        # for deciding what sounds/animations to use
        activeTerrainTag = eventTerrainTag
      end
      
      # if the platform is not found, increment tile position upwards
      if (!platformFound)
        # increment the tile number by one
        tileNum += 1
        # increase yPos by 1 to go down 1 in the tile search
        yPos += 1
      end
    end
    
    destY = yPos - 1 # get the final destination y value
    
    # calculate the total fall height (tile amount between the tile
    # the player "event" is on (not the one below their feet) and the platform they
    # are landing on, or at least the location they are falling to)
    fallHeight = (destY - origY).abs
    
    # store whether or not the mapEnd was reached (it was if no platform was found)
    mapEndReached = !platformFound
    
    # just in case something was messed up, only execute sideFall if
    # the fallHeight is above 0
    if (fallHeight > 0)
      # call sideFall with the fallHeight, and use whether or not a
      # platform was found to tell if the end of the map was reached
      sideFall(fallHeight, mapEndReached, activeTerrainTag)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to decide what type decide which type of side fall should
  # * be used, and activates the side fall.
  # *
  # * Side fall type guide:
  # *   Regular: Falling down w/o taking damage and not falling over at the end of
  # *   the fall. Occurs when falling from a "safe" height
  # *   Big: Falling down at the end of the fall and taking damage. Occurs when
  # *   falling from an "unsafe" height.
  # *   Game Over: Falling off the map, and triggering a game over. Occurs when
  # *   the mapEndReached flag is true.
  #--------------------------------------------------------------------------
  def sideFall(fallHeight, mapEndReached, activeTerrainTag)
    # first, determine which sideFall to use, either

    
    # get the max safe fall distance associated with the active outfit and terrain tag
    maxSafeFallDist = LCM.getMaxSafeFallDist(activeTerrainTag, @lcmMovementOutfit)
    
    # if the map end was reached, just call the Game Over fall
    if (mapEndReached == true)
      sideFallGameOver(fallHeight)
    # if the fall was from a "safe" height, then call the Regular fall
    elsif (fallHeight <= maxSafeFallDist)
      sideFallReg(fallHeight)
    elsif (fallHeight > maxSafeFallDist)
      sideFallBig(fallHeight, activeTerrainTag)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to call the jumpDownLedge() method with the isSideFall
  # * optional parameter set to true. The method does the same thing as this
  # * one would need to do (set up a move route for moving downwards), but
  # * will just use a different graphic while falling.
  #--------------------------------------------------------------------------
  def sideFallReg(yDiff)
    # move route for a non-damaging or game-over-causing fall is identical
    # to a ledge down jump, so just use that method
    #
    # Additionally, since jumpDownLedge is being used for a side fall,
    # mark it as a sidefall using the second optional parameter
    # isSideFall, that way, the proper sideFall graphic is used.
    jumpDownLedge(yDiff, true)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create and run the move route for falling from
  # * an unsafe distance down to a platform, and then impacting into the
  # * ground and recovering from that impact.
  #--------------------------------------------------------------------------
  def sideFallBig(yDiff, activeTerrainTag)    
    # calculate/store the amount of damage to take, and the animation
    # ID tied to the amount of damage to take
    damageTaken = 0 # start with damageTaken at 0
    damageAnimID = 0 # start with damageAnimationID at 0
    # get the fall height damage num and animation num hashes by terrain tag
    terrainFallHeightDamageHash = LCM::LCM_UNSAFE_FALL_HEIGHT_DAMAGE[activeTerrainTag]
    terrainFallHeightAnimHash = LCM::LCM_UNSAFE_FALL_HEIGHT_DAMAGE_ANIM_IDS[activeTerrainTag]
    # if there is a specified damage for the amount of tiles fallen, use
    # that number, otherwise, use the FALL_HEIGHT_MAX_DAMAGE info
    if (terrainFallHeightDamageHash.has_key?(yDiff))
      damageTaken = terrainFallHeightDamageHash[yDiff]
      damageAnimID = terrainFallHeightAnimHash[damageTaken]
    else
      damageTaken = LCM::LCM_FALL_HEIGHT_MAX_DAMAGE
      damageAnimID = terrainFallHeightAnimHash[damageTaken]
    end
    
    # if there is an outfit override for the damage taken from falls, use that instead
    if (LCM::LCM_FALL_HEIGHT_DAMAGE_NUMBER_OUTFIT_OVERRIDE.has_key?(@lcmMovementOutfit))
      # get the fall height damage num hash by the outfit
      outfitFallHeightDamageHash = LCM::LCM_FALL_HEIGHT_DAMAGE_NUMBER_OUTFIT_OVERRIDE[@lcmMovementOutfit]
      
      # if there is a specified damage for the amount of tiles fallen for the
      # outfit, use that number, otherwise, use the FALL_HEIGHT_MAX_DAMAGE info
      if (outfitFallHeightDamageHash.has_key?(yDiff))
        damageTaken = outfitFallHeightDamageHash[yDiff]
        damageAnimID = terrainFallHeightAnimHash[damageTaken]
      else
        damageTaken = LCM::LCM_FALL_HEIGHT_MAX_DAMAGE
        damageAnimID = terrainFallHeightAnimHash[damageTaken]
      end
    end
    
    # the hpChange is damageTaken * -1
    hpChange = damageTaken * -1
    
    # create new move route and set move route settings
    regularFallMoveRoute = RPG::MoveRoute.new
    regularFallMoveRoute.repeat = false
    regularFallMoveRoute.skippable = false
    regularFallMoveRoute.wait = true
    
    # create script movement command (will be used with different data repeatedly)
    # NOTE: the entries are executed in reverse order (to how it would normally
    # be set up in an event) due to how insertion works!!!
    movement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    movement.code = 0
    movement.parameters = []
    regularFallMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to jump
    movement.code = 14 # 14 is for the "Jump" command
    # jump down to the y difference (y vals increase going downward)
    movement.parameters = [0, yDiff]
    # add the jump movement command to the move route
    regularFallMoveRoute.list.insert(0, movement.clone)

    # create script movement command to turn on the character stepping animation
    movement.code = 33
    # add the walking animation enabling command
    regularFallMoveRoute.list.insert(0, movement.clone)
    
    # get the active outfit's side falling graphic
    sideFallingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :sideFallingGraphic)
    # create script movement command to change player graphic to the jumping graphic
    movement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the set jump graphic at position 0
    movement.parameters = [sideFallingGraphic, 0]
    # add the change graphic movement command
    regularFallMoveRoute.list.insert(0, movement.clone)
    
    # get the active outfit's standard jump SE data
    jumpSEName = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEName)
    jumpSEVolume = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEVol)
    jumpSEPitch = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEPitch)
    # create script movement command to play the jump sound
    movement.code = 44 # 44 is for the "Play SE" command
    # set up the sound with filename, speed, pitch
    movement.parameters = [RPG::SE.new(jumpSEName, jumpSEVolume, jumpSEPitch)]
    # add the play SE movement command to the move route
    # (.clone makes it so that a copy of the original movement object's data)
    regularFallMoveRoute.list.insert(0, movement.clone)
    
    # create new move route to execute AFTER the other one (it is set to
    # wait for completion to change the graphic back to normal) and set up the settings
    fallenMoveRoute = RPG::MoveRoute.new
    fallenMoveRoute.repeat = false
    fallenMoveRoute.skippable = false
    fallenMoveRoute.wait = false
    
    # if the character is a follower, set the fallen move route to wait
    # so they don't move while fallen
    if (self.kind_of?(Game_Follower))
      fallenMoveRoute.wait = true
    end
    
    # create move command for the resetMoveRoute
    fallenMovement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    fallenMovement.code = 0
    fallenMovement.parameters = []
    fallenMoveRoute.list.insert(0, fallenMovement.clone)
    
    # gets the appropriate walking/dashing graphic depending on if the player
    # is dashing or not
    correctWalkingOrDashingGraphic = "none" # start with "none" as the value
    if (dash?)
      # get whether or not separate dashing is enabled
      dashingEnabled = $game_party.getExSaveData("lcmSeparateDashingToggle", LCM::LCM_USE_SEPARATE_DASH_GRAPHICS)
      
      # if dashing is enabled, use the dashing graphic, otherwise, just use the normal one
      if (dashingEnabled)
        # get the active outfit's dashing graphic
        correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalDashingGraphic)
      else
        # get the active outfit's walking graphic
        correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
      end
      
    else
      # get the active outfit's walking graphic
      correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
    end
    # create script movement command to change player graphic back to the normal one
    fallenMovement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the normal graphic at position 0
    fallenMovement.parameters = [correctWalkingOrDashingGraphic, 0]
    # add the change graphic movement command
    fallenMoveRoute.list.insert(0, fallenMovement.clone)
    
    # get the active outfit's fall recovery SE data
    recoverySEName = LCM.getlcmDatasetData(@lcmMovementOutfit, :unsafeFallRecoverSEName)
    recoverySEVolume = LCM.getlcmDatasetData(@lcmMovementOutfit, :unsafeFallRecoverSEVol)
    recoverySEPitch = LCM.getlcmDatasetData(@lcmMovementOutfit, :unsafeFallRecoverSEPitch)
    # create script movement command to play the fallen recovery sound
    fallenMovement.code = 44 # 44 is for the "Play SE" command
    # set up the sound with filename, speed, pitch
    fallenMovement.parameters = [RPG::SE.new(recoverySEName, recoverySEVolume, recoverySEPitch)]
    # add the play SE movement command to the move route
    fallenMoveRoute.list.insert(0, fallenMovement.clone)
    
    # get the active outfit's fall recovery time
    recoveryTime = LCM.getlcmDatasetData(@lcmMovementOutfit, :unsafeFallRecoveryTime)
    # create script movement command to wait 60 frames
    fallenMovement.code = 15 # 15 is for the "Wait" command
    fallenMovement.parameters = [recoveryTime]
    # add the wait movement command
    fallenMoveRoute.list.insert(0, fallenMovement.clone)
    
    # Do damage to the party ONLY IF THE CHARACTER IS THE PLAYER!!!
    # followers, other events, etc. will not trigger a party change hp
    if (self.kind_of?(Game_Player))
      # create script movement command to execute script to emulate the effect
      # of changing party HP through an event
      fallenMovement.code = 45 # 45 is for the "Script" command
      
      # set up the lines to execute
      changeHPScriptLinesToExec = "" # placeholder to replace
      # if only the player should be damaged, then just do that,
      # otherwise, damage the entire party.
      #
      # notes:
      # - the true in change_hp() is to enable death for the actor hp changing
      # - damageTaken.to_s is the damageTaken var added into the string script to be evaluated
      if (LCM::LCM_DAMAGE_PLAYER_ONLY == true)
        # damage just the player
        changeHPScriptLinesToExec = ("
          actor = $game_actors[$game_player.lcmGetPlayerActorID]
          if !actor.dead?
            actor.change_hp(" + hpChange.to_s + ", true)
            actor.perform_collapse_effect if actor.dead?
            SceneManager.goto(Scene_Gameover) if $game_party.all_dead?
          end"
        )
      else
        # damage the whole party
        changeHPScriptLinesToExec = (
          "$game_party.members.each { |actor|
            next if actor.dead?
            actor.change_hp(" + hpChange.to_s + ", true)
            actor.perform_collapse_effect if actor.dead?
            SceneManager.goto(Scene_Gameover) if $game_party.all_dead?
          }")
      end
      fallenMovement.parameters = [changeHPScriptLinesToExec]
      # add the Script movement command to the move route
      fallenMoveRoute.list.insert(0, fallenMovement.clone)
    end
    
    # get the active outfit's fallen graphic
    fallImpactGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :unsafeFallImpactGraphic)
    # create script movement command to change player graphic back to the fallen over version
    fallenMovement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the fallen graphic at position 0
    fallenMovement.parameters = [fallImpactGraphic, 0]
    # add the change graphic movement command
    fallenMoveRoute.list.insert(0, fallenMovement.clone)
    
    # Do not do damage number animations for followers (FOR NOW....)
    if (!self.kind_of?(Game_Follower))
      # create script movement command to execute script to emulate the effect
      # of showing an animation through an event
      fallenMovement.code = 45 # 45 is for the "Script" command
      # set up the line to execute
      # note: all you need to do to play an animation in a move route is
      # just setting animation_id = animNumber apparently
      animationScriptLineToExec = ("self.animation_id = " + damageAnimID.to_s)
      fallenMovement.parameters = [animationScriptLineToExec]
      # add the Script movement command to the move route
      fallenMoveRoute.list.insert(0, fallenMovement.clone)
    end
    
    # create script movement command to turn off the character stepping animation
    fallenMovement.code = 34
    # add the walking animation disabling command
    fallenMoveRoute.list.insert(0, fallenMovement.clone)
    
    # try to get SE data based off of terrain tag. if it fails, use the default
    fallImpactSEName = "none" # init to placeholder vals
    if(LCM::LCM_TERRAIN_TAGS_UNSAFE_LAND_SE_DATA.has_key?(activeTerrainTag))
      fallImpactSEDataArray = LCM::LCM_TERRAIN_TAGS_UNSAFE_LAND_SE_DATA[activeTerrainTag] # get the array of SE data
    else
      fallImpactSEDataArray = LCM:: LCM_DEFAULT_UNSAFE_LAND_SE_DATA # get the array of SE data
    end
    # if there is an outfit override for the sound for fall impact, use that instead
    if (LCM::LCM_UNSAFE_FALL_IMPACT_OUTFIT_OVERRIDE_SE_DATA.has_key?(@lcmMovementOutfit))
      fallImpactSEDataArray = LCM::LCM_UNSAFE_FALL_IMPACT_OUTFIT_OVERRIDE_SE_DATA[@lcmMovementOutfit]
    end
    # use the correct SE data array to get the final SE data values
    fallImpactSEName = fallImpactSEDataArray[0]
    fallImpactSEVol = fallImpactSEDataArray[1]
    fallImpactSEPitch = fallImpactSEDataArray[2]
    
    # create script movement command to play the fallen sound
    fallenMovement.code = 44 # 44 is for the "Play SE" command
    # set up the sound with filename, speed, pitch
    fallenMovement.parameters = [RPG::SE.new(fallImpactSEName, fallImpactSEVol, fallImpactSEPitch)]
    # add the play SE movement command to the move route
    fallenMoveRoute.list.insert(0, fallenMovement.clone)
    
    # run the move routes consecutively
    setuplcmCustomConsecutiveMoveRoutes(regularFallMoveRoute, fallenMoveRoute)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create and run the move route for falling down past
  # * the border of the map, causing a game over.
  #--------------------------------------------------------------------------
  def sideFallGameOver(yDiff)
    # create new move route and set move route settings
    normalFallMoveRoute = RPG::MoveRoute.new
    normalFallMoveRoute.repeat = false
    normalFallMoveRoute.skippable = false
    normalFallMoveRoute.wait = true
    
    # create script movement command (will be used with different data repeatedly)
    # NOTE: the entries are executed in reverse order (to how it would normally
    # be set up in an event) due to how insertion works!!!
    movement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    movement.code = 0
    movement.parameters = []
    normalFallMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to jump
    movement.code = 14 # 14 is for the "Jump" command
    # jump down to the y difference (y vals increase going downward)
    movement.parameters = [0, yDiff]
    # add the jump movement command to the move route
    normalFallMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to turn on the character stepping animation
    movement.code = 33
    # add the walking animation enabling command 
    normalFallMoveRoute.list.insert(0, movement.clone)
    
    # get the active outfit's side falling graphic
    sideFallingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :sideFallingGraphic)
    # create script movement command to change player graphic to the jumping graphic
    movement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the set jump graphic at position 0
    movement.parameters = [sideFallingGraphic, 0]
    # add the change graphic movement command
    normalFallMoveRoute.list.insert(0, movement.clone)
    
    # get the active outfit's standard jump SE data
    jumpSEName = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEName)
    jumpSEVolume = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEVol)
    jumpSEPitch = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEPitch)
    # create script movement command to play the jump sound
    movement.code = 44 # 44 is for the "Play SE" command
    # set up the sound with filename, speed, pitch
    movement.parameters = [RPG::SE.new(jumpSEName, jumpSEVolume, jumpSEPitch)]
    # add the play SE movement command to the move route
    # (.clone makes it so that a copy of the original movement object's data)
    normalFallMoveRoute.list.insert(0, movement.clone)
    
    # create new move route to execute AFTER the other one (it is set to
    # wait for completion to change the graphic back to normal) and set up the settings
    gameOverFallMoveRoute = RPG::MoveRoute.new
    gameOverFallMoveRoute.repeat = false
    gameOverFallMoveRoute.skippable = false
    gameOverFallMoveRoute.wait = false
    
    # create move command for the resetMoveRoute
    gameOverMovement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    gameOverMovement.code = 0
    gameOverMovement.parameters = []
    gameOverFallMoveRoute.list.insert(0, gameOverMovement.clone)
    
    # only do a game over if the character is the player
    if (self.kind_of?(Game_Player))
      # create script movement command to execute script to emulate the effect
      # of doing a game over through an event
      gameOverMovement.code = 45 # 45 is for the "Script" command
      # set up the line to execute
      gameOverScriptLineToExec = "SceneManager.goto(Scene_Gameover)"
      gameOverMovement.parameters = [gameOverScriptLineToExec]
      # add the Script movement command to the move route
      gameOverFallMoveRoute.list.insert(0, gameOverMovement.clone)
    end
    
    # create script movement command to turn off the character stepping animation
    gameOverMovement.code = 34
    # add the walking animation disabling command 
    gameOverFallMoveRoute.list.insert(0, gameOverMovement.clone)
    
    # run the move route
    setuplcmCustomConsecutiveMoveRoutes(normalFallMoveRoute, gameOverFallMoveRoute)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to decide what kind of side jump (regular or dash) to
  # * execute, if there is a platform within side jump or dash jump range, and
  # * execute one of them if needed. Also handles side falls with momentum.
  # * If any of the methods are executed, true is returned. Otherwise,
  # * false is returned.
  #--------------------------------------------------------------------------
  def sideJumpChecks(direction)
    sideJumpRan = false # stores whether or not a sideJump was run. Starts false and must be proven true
    
    # get the active outfit's dash enable status (if dash jump distance >0, then it is enabled)
    dashJumpEnabled = (LCM.getlcmDatasetData(@lcmMovementOutfit, :dashJumpDistance) > 0)
    # get the active outfit's side jump enable status (if side jump distance >0, then it is enabled)
    sideJumpEnabled = (LCM.getlcmDatasetData(@lcmMovementOutfit, :sideJumpDistance) > 0)
    # get whether or not to treat normal walking as dashing (intended for vehicles)
    treatWalkingAsDash = LCM.getlcmDatasetData(@lcmMovementOutfit, :treatWalkLikeDash)
    # get whether or not to have dash jumps use momemtum or not
    dashJumpUseMomentum = LCM.getlcmDatasetData(@lcmMovementOutfit, :useDashMomentum)
    
    # do dash jump checks if walking is treated as dashing OR
    # the character is a Follower OR is dashing, AND dashing is enabled for the character,
    # then do the dash checks
    if ( (treatWalkingAsDash || self.kind_of?(Game_Follower) || dash?) && (dashJumpEnabled == true) )      
      # calculate the dashJump distance, with 'true' marking it a dash jump
      #
      # note: returns -1 if no jumpable platform found
      finalDashJumpDistanceCalculation = sideJumpDistanceCalc(direction, true)
      
      # if the there was a dashJumpDistance above 0, do a
      # sideJump in dash mode, otherwise, begin a dashJumpFall
      if (finalDashJumpDistanceCalculation > 0)
        sideJumpRan = true # set sideJumpRan to true
        # whether or not to run the dashJump, starts true, will only be set to false
        # if the character is a follower and a dash jump was not needed for them
        runDashJump = true
        
        # if the character is a follower, do some extra checks for if dashing 
        # is needed
        if (self.kind_of?(Game_Follower))
          # get regular side fall distance from outfit data
          regSideFallDistance = LCM.getlcmDatasetData(@lcmMovementOutfit, :sideJumpDistance)
          # checks if a dash jump is necessary for the follower
          dashJumpNeededForFollower = (finalDashJumpDistanceCalculation > regSideFallDistance)
          runDashJump = dashJumpNeededForFollower
        end
        
        # if a dash jump should be run, run that, otherwise, run a regular side jump
        # (reg side jump will only run here if it's a follower which doesn't
        # need to dash)
        if (runDashJump)
          # if the character is the player, flip on the dashJumpNoSlowdown flag
          if (self.kind_of?(Game_Player))
            self.dashJumpNoSlowdown = true
          end
          # the true is to mark the sideJump as a dash jump
          sideJump(direction, finalDashJumpDistanceCalculation, true)
        else
          # if the character is the player, flip on the dashJumpNoSlowdown flag
          if (self.kind_of?(Game_Player))
            self.dashJumpNoSlowdown = true
          end
          # the false is to mark the sideJump as a regular side jump
          sideJump(direction, finalDashJumpDistanceCalculation, false)
        end
      # if falling, only do momentum fall checks for non-Followers
      elsif (!self.kind_of?(Game_Follower))
        # call the dashJumpFall method if momentum for dash jumps is
        # enabled (otherwise, the standard falling method will do, and
        # sideJumpRan will not be flipped to true, do nothing).
        if (dashJumpUseMomentum == true)
          # set sideJumpRan to true (it is a fall, but normal fall should not be executed)
          sideJumpRan = true
          # if the character is the player, flip on the dashJumpNoSlowdown flag
          if (self.kind_of?(Game_Player))
            self.dashJumpNoSlowdown = true
          end
          # call the falling method for dash jumps using momentum
          dashJumpFall(direction, finalDashJumpDistanceCalculation)
        end
      end
    
    # do side jump checks if side jumps enabled and the character is a player object
    # Also, this won't be run if the player was dashing
    elsif (sideJumpEnabled == true)
      # calculate the sideJump distance, with 'false' marking it not a dash jump
      finalSideJumpDistanceCalculation = sideJumpDistanceCalc(direction, false)
      
      # if the there was a sideJumpDistance above 0, do a
      # sideJump, otherwise, do nothing (normal falling should be done, so
      # sideJumpRan stays false)
      if (finalSideJumpDistanceCalculation > 0)
        sideJumpRan = true # set sideJumpRan to true
        
        # call sideFall with the finalSideJumpDistanceCalculation
        #
        # the false is to mark the sideJump as not a dash jump
        sideJump(direction, finalSideJumpDistanceCalculation, false)
      end
    end
    
    return (sideJumpRan) # return whether or not some for of jump was ran
  end
  
  #--------------------------------------------------------------------------
  # * New method used to decide the amount of horizontal distance to jump
  # * to complete a side or dash jump. Returns the calculated value, or
  # * -1 if no platform in jumping range was found.
  #--------------------------------------------------------------------------
  def sideJumpDistanceCalc(direction, isDashJump)
    # note: direction will either be 4 for left, or 6 for right
    
    origX = $game_map.round_x_with_direction(@x, direction) # store original x
    # store original y
    origY = $game_map.round_y_with_direction(@y, direction)
    # currentTile's X is origX + 1 if moving left, origX - 1 if moving right
    # (x increases going right)
    currentTileX = (direction == 4)? (origX + 1) : (origX - 1)
    
    # check all tiles going left or right from the player until a platform is found,
    # OR the spot three tiles under the map is reached (when the player is sure
    # to be off the map screen)
    tileNum = 0 # number of tiles searched
    platformFound = false # whether or not a platform has been found
    activeTerrainTag = 0 # 0 as default, decides what animations/sounds to use when hit ground
    # the x position be the new currentTileX
    xPos = currentTileX
    # y val to check first should be the origY + 1 to start at the tile below
    # the player's feet
    yPos = origY + 1
    
    # get whether or not platform events are enabled from exSaveData
    platformEventsEnabled = $game_party.getExSaveData("lcmPlatformEventsToggle", LCM::LCM_PLATFORM_EVENTS_ENABLED)
    
    # get the active outfit's dash jump distance
    dashJumpDistance = LCM.getlcmDatasetData(@lcmMovementOutfit, :dashJumpDistance)
    # get the active outfit's side jump distance
    sideJumpDistance = LCM.getlcmDatasetData(@lcmMovementOutfit, :sideJumpDistance)
    
    # sideJump max distance is dashJumpDistance + 1 if dashing, or
    # sideJumpDistance + 1 if not dashing
    sideJumpMaxDist = (isDashJump == true)? (dashJumpDistance + 1) : (sideJumpDistance + 1)
    while ((tileNum < sideJumpMaxDist) && !platformFound)
      terrainTag = $game_map.terrainTagPlatformCheck(xPos, yPos) # get map tile terrain tag
      eventTerrainTag = -1 # set eventTerrainTag to -1 by default unless platform events have been enabled
      if (platformEventsEnabled == true)
        eventTerrainTag = $game_map.getEventPlatTerrainTagEquiv(xPos, yPos) # get event terrain tag equivalent
      end
      # if the list of platform terrain tags includes the terrain tag
      # currently being checked, if it does, mark the platform as found
      if (LCM::LCM_PLATFORM_TAGS.include?(terrainTag))
        platformFound = true
        activeTerrainTag = terrainTag
      # get the equivalent terrain tag for any event designated as a platform
      # with the [PLT #] notetag in its name. Will be -1 if no "platform"
      # events were found at the location.
      # if the equivalent terrain tag is not equal to -1, then
      elsif (eventTerrainTag != -1)
        platformFound = true
        # also set the activeTerrainTag to the event version, it takes priority
        # for deciding what sounds/animations to use
        activeTerrainTag = eventTerrainTag
      end
    
      # if the platform is not found, increment tile position upwards
      if (!platformFound)
        # increment the tile number by one
        tileNum += 1
        # add -1 to xPos if moving left [4-left] or +1 if moving right
        # (x increases going right)
        xPos = (direction == 4)? (xPos - 1) : (xPos + 1)
      end
    end
    
    destX = (direction == 4)? (xPos - 1) : (xPos + 1) # get the final destination x value
    
    # calculate the total side jump distance (tile amount between the two
    # platforms the player is jumping between)
    sideJumpDist = (destX - origX).abs
    
    # if no platform was found, then set sideJumpDist to -1 so a jump is not done
    if (!platformFound)
      sideJumpDist = -1
    end
    
    return (sideJumpDist) # return the distance to jump (-1 if no valid platform found)
  end
  
  #--------------------------------------------------------------------------
  # * New method used create and execute the move route for a side jump or a
  # * dashJump onto another ledge, depending on the isDashJump parameter.
  # * The difference between the two in this method is that a dash jump will
  # * use different graphics.
  #--------------------------------------------------------------------------
  def sideJump(direction, xDiff, isDashJump)
    # how far to jump accounting for direction
    # [4-left, 6-right]
    # If going left, use -xDiff, otherwise, just use xDiff
    finalXValChange = (direction == 4)? (-xDiff) : (xDiff)
    
    # create new move route and set move route settings
    sideJumpMoveRoute = RPG::MoveRoute.new
    sideJumpMoveRoute.repeat = false
    sideJumpMoveRoute.skippable = false
    sideJumpMoveRoute.wait = true
    
    # create script movement command (will be used with different data repeatedly)
    # NOTE: the entries are executed in reverse order (to how it would normally
    # be set up in an event) due to how insertion works!!!
    movement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    movement.code = 0
    movement.parameters = []
    sideJumpMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to jump
    movement.code = 14 # 14 is for the "Jump" command
    # jump the correct xValChange amount (- is left, positive is right)
    movement.parameters = [finalXValChange, 0]
    # add the jump movement command to the move route
    sideJumpMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to turn on the character stepping animation
    movement.code = 33
    # add the walking animation enabling command 
    sideJumpMoveRoute.list.insert(0, movement.clone)
    
    # gets the appropriate side jump graphic depending on if side jumping or dash jumping
    correctSideJumpGraphic = "none" # start with "none" as the value
    if (isDashJump == true || $game_player.playerDashGraphicInUse)
      # get the active outfit's dash jumping graphic
      correctSideJumpGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :dashJumpGraphic)
    else
      # get the active outfit's side jumping graphic
      correctSideJumpGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :sideJumpGraphic)
    end
    # create script movement command to change player graphic to the jumping graphic
    movement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the set jump graphic at position 0
    movement.parameters = [correctSideJumpGraphic, 0]
    # add the change graphic movement command
    sideJumpMoveRoute.list.insert(0, movement.clone)
    
    # get the active outfit's standard jump SE data
    jumpSEName = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEName)
    jumpSEVolume = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEVol)
    jumpSEPitch = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEPitch)
    # create script movement command to play the jump sound
    movement.code = 44 # 44 is for the "Play SE" command
    # set up the sound with filename, speed, pitch
    movement.parameters = [RPG::SE.new(jumpSEName, jumpSEVolume, jumpSEPitch)]
    # add the play SE movement command to the move route
    # (.clone makes it so that a copy of the original movement object's data)
    sideJumpMoveRoute.list.insert(0, movement.clone)
    
    # create new move route to execute AFTER the other one (it is set to
    # wait for completion to change the graphic back to normal) and set up the settings
    resetMoveRoute = RPG::MoveRoute.new
    resetMoveRoute.repeat = false
    resetMoveRoute.skippable = false
    resetMoveRoute.wait = false
    
    # create move command for the resetMoveRoute
    resetMovement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    resetMovement.code = 0
    resetMovement.parameters = []
    resetMoveRoute.list.insert(0, resetMovement.clone)
    
    # get whether or not to treat normal walking as dashing (intended for vehicles)
    treatWalkingAsDash = LCM.getlcmDatasetData(@lcmMovementOutfit, :treatWalkLikeDash)
    # gets the appropriate walking/dashing graphic depending on if side jumping or dash jumping
    correctWalkingOrDashingGraphic = "none" # start with "none" as the value
    if ((isDashJump == true && !treatWalkingAsDash) || dash?)
      # get whether or not separate dashing is enabled
      dashingEnabled = $game_party.getExSaveData("lcmSeparateDashingToggle", LCM::LCM_USE_SEPARATE_DASH_GRAPHICS)
      
      # if dashing is enabled, use the dashing graphic, otherwise, just use the normal one
      if (dashingEnabled)
        # get the active outfit's dashing graphic
        correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalDashingGraphic)
      else
        # get the active outfit's walking graphic
        correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
      end
      
    else
      # get the active outfit's walking graphic
      correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
    end
    # create script movement command to change player graphic back to the normal one
    resetMovement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the normal graphic at position 0
    resetMovement.parameters = [correctWalkingOrDashingGraphic, 0]
    # add the change graphic movement command
    resetMoveRoute.list.insert(0, resetMovement.clone)
    
    # create script movement command to turn off the character stepping animation
    resetMovement.code = 34
    # add the walking animation disabling command 
    resetMoveRoute.list.insert(0, resetMovement.clone)
    
    # run the move routes consecutively
    setuplcmCustomConsecutiveMoveRoutes(sideJumpMoveRoute, resetMoveRoute)
  end
  
  # decides which dashJumpFall to use and calculates the numbers for it
  # note, this is only used for dash jump falls with momentum, dash jumps
  # without momentum are counted as regular side falls
  
  #--------------------------------------------------------------------------
  # * New method used to decide which variation of a dash jump fall to use.
  # * This method specifically handles such falls with momentum (otherwise,
  # * the normal side falls are used).
  # *
  # * Dash fall type guide:
  # *   Regular: Falling down w/o taking damage and not falling over at the end of
  # *   the fall. Occurs when falling from a "safe" height
  # *   Big: Falling down at the end of the fall and taking damage. Occurs when
  # *   falling from an "unsafe" height.
  # *   Game Over: Falling off the map, and triggering a game over. Occurs when
  # *   the mapEndReached flag is true.
  #--------------------------------------------------------------------------
  def dashJumpFall(direction, currXUnderCharacter)
    # note: direction will either be 4 for left, or 6 for right
    
    origX = $game_map.round_x_with_direction(@x, direction) # store original x
    # store original y
    origY = $game_map.round_y_with_direction(@y, direction)
    # currentTile's X is origX + 1 if moving left, origX - 1 if moving right
    # (x increases going right)
    currentTileX = (direction == 4)? (origX + 1) : (origX - 1)
    
    # check all tiles going left or right from the player until a platform is found,
    # OR the spot three tiles under the map is reached (when the player is sure
    # to be off the map screen)
    offMapEndPos = $game_map.height + 3 # three tiles below the map border, where player will not be seen
    tileNum = 0 # number of tiles searched
    platformFound = false # whether or not a platform has been found
    activeTerrainTag = 0 # 0 as default, decides what animations/sounds to use when hit ground
    # the x position be the new currentTileX
    xPos = currentTileX
    # y val to check first should be the origY + 1 to start at the tile below
    # the player's feet
    yPos = origY + 1
    # get whether or not platform events are enabled from exSaveData
    platformEventsEnabled = $game_party.getExSaveData("lcmPlatformEventsToggle", LCM::LCM_PLATFORM_EVENTS_ENABLED)
    # keeps track of how much to add to LCM_DASH_JUMP_TILES_DOWN. This number is
    # increase to this number each time a new across value is triggered. This
    # makes sure that you cannot jump ridiculous differences
    lcmDashJumpTilesDownAdditions = 0
    # check the tiles arcing downward until a platform to land on is found,
    # or until the end of the map position is reached
    while ((yPos < offMapEndPos) && (!platformFound))
      terrainTag = $game_map.terrainTagPlatformCheck(xPos, yPos) # get map tile terrain tag
      eventTerrainTag = -1 # set eventTerrainTag to -1 by default unless platform events have been enabled
      if (platformEventsEnabled == true)
        eventTerrainTag = $game_map.getEventPlatTerrainTagEquiv(xPos, yPos) # get event terrain tag equivalent
      end
      # if the list of platform terrain tags includes the terrain tag
      # currently being checked, if it does, mark the platform as found
      if (LCM::LCM_PLATFORM_TAGS.include?(terrainTag))
        platformFound = true
        activeTerrainTag = terrainTag
      # get the equivalent terrain tag for any event designated as a platform
      # with the [PLT #] notetag in its name. Will be -1 if no "platform"
      # events were found at the location.
      # if the equivalent terrain tag is not equal to -1, then
      elsif (eventTerrainTag != -1)
        platformFound = true
        # also set the activeTerrainTag to the event version, it takes priority
        # for deciding what sounds/animations to use
        activeTerrainTag = eventTerrainTag
      end
      
      # if the platform is not found, increment tile position upwards
      if (!platformFound)
        # increment the tile number by one
        tileNum += 1
        # if tileNum has gone up by a LCM_DASH_JUMP_TILES_DOWN amount,
        # then increase/decrease xPos by LCM_DASH_JUMP_ACROSS_TILES
        if ((tileNum % (LCM::LCM_DASH_JUMP_TILES_DOWN + lcmDashJumpTilesDownAdditions)) == 0)
          jumpAcrossTiles = LCM::LCM_DASH_JUMP_ACROSS_TILES
          lcmDashJumpTilesDownAdditions += tileNum # increment dashJumpTilesDownAdditions by one
          # add -jumpAcrossTiles to xPos if moving left [4-left] or +jumpAcrossTiles
          # if moving right (x increases going right)
          xPos = (direction == 4)? (xPos - jumpAcrossTiles) : (xPos + jumpAcrossTiles)
        end
        yPos += 1 # always increase yPos by 1 (y vals increase going down)
        
      end
    end
    
    destX = (direction == 4)? (xPos - 1) : (xPos + 1) # get the final destination x value
    
    destY = yPos - 1 # get the final destination y value
    
    # calculate the total fall height (tile amount between the tile
    # the player "event" is on (not the one below their feet) and the platform they
    # are landing on, or at least the location they are falling to)
    fallHeight = (destY - origY).abs
    
    # calculate the total side fall forward distance
    fallForwardDist = (destX - origX).abs
    
    # store whether or not the mapEnd was reached (it was if no platform was found)
    mapEndReached = !platformFound
    
    # get the max safe fall distance associated with the active outfit and terrain tag
    maxSafeFallDist = LCM.getMaxSafeFallDist(activeTerrainTag, @lcmMovementOutfit)
    
    # determine which side fall with momentum to use and execute it
    
    # if the map end was reached, just call the Game Over fall
    if (mapEndReached == true)
      sideFallMomGameOver(direction, fallForwardDist, fallHeight)
    # if the fall was from a "safe" height, then call the Regular fall
    elsif (fallHeight <= maxSafeFallDist)
      sideFallMomReg(direction, fallForwardDist, fallHeight)
    # for unsafe falls, call the Big fall
    elsif (fallHeight > maxSafeFallDist)
      sideFallMomBig(direction, fallForwardDist, fallHeight, activeTerrainTag)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create and execute the move route for side falls
  # * with momentum from a safe height, where no damage is taken.
  #--------------------------------------------------------------------------
  def sideFallMomReg(direction, xDiff, yDiff)    
    # how far to jump accounting for direction
    # [4-left, 6-right]
    # If going left, use -xDiff, otherwise, just use xDiff
    finalXValChange = (direction == 4)? (-xDiff) : (xDiff)
    
    # create new move route and set move route settings
    sideFallMomMoveRoute = RPG::MoveRoute.new
    sideFallMomMoveRoute.repeat = false
    sideFallMomMoveRoute.skippable = false
    sideFallMomMoveRoute.wait = true
    
    # create script movement command (will be used with different data repeatedly)
    # NOTE: the entries are executed in reverse order (to how it would normally
    # be set up in an event) due to how insertion works!!!
    movement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    movement.code = 0
    movement.parameters = []
    sideFallMomMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to jump
    movement.code = 14 # 14 is for the "Jump" command
    # jump down to the y difference (y vals increase going downward)
    movement.parameters = [finalXValChange, yDiff]
    # add the jump movement command to the move route
    sideFallMomMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to turn on the character stepping animation
    movement.code = 33
    # add the walking animation enabling command
    sideFallMomMoveRoute.list.insert(0, movement.clone)
    
    sideFallingGraphic = "" # set placeholder empty graphic filename
    # if the dash jump graphic should be used for momentum falls,
    # then use the dash jump graphic. Otherwise, use the standard
    # side fall graphic
    if (LCM::LCM_USE_DASH_JUMP_GRAPHIC_ON_MOMENTUM_FALL == false)
      # get the active outfit's standard side falling graphic
      sideFallingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :sideFallingGraphic)
    else
      # set the sideFallingGraphic to be the dash jumping graphic
      sideFallingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :dashJumpGraphic)
    end
    # create script movement command to change player graphic to the jumping graphic
    movement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the set jump graphic at position 0
    movement.parameters = [sideFallingGraphic, 0]
    # add the change graphic movement command
    sideFallMomMoveRoute.list.insert(0, movement.clone)
    
    # get the active outfit's standard jump SE data
    jumpSEName = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEName)
    jumpSEVolume = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEVol)
    jumpSEPitch = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEPitch)
    # create script movement command to play the jump sound
    movement.code = 44 # 44 is for the "Play SE" command
    # set up the sound with filename, speed, pitch
    movement.parameters = [RPG::SE.new(jumpSEName, jumpSEVolume, jumpSEPitch)]
    # add the play SE movement command to the move route
    # (.clone makes it so that a copy of the original movement object's data)
    sideFallMomMoveRoute.list.insert(0, movement.clone)
    
    # create new move route to execute AFTER the other one (it is set to
    # wait for completion to change the graphic back to normal) and set up the settings
    resetMoveRoute = RPG::MoveRoute.new
    resetMoveRoute.repeat = false
    resetMoveRoute.skippable = false
    resetMoveRoute.wait = false
    
    # create move command for the resetMoveRoute
    resetMovement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    resetMovement.code = 0
    resetMovement.parameters = []
    resetMoveRoute.list.insert(0, resetMovement.clone)
    
    
    # get whether or not to treat normal walking as dashing (intended for vehicles)
    treatWalkingAsDash = LCM.getlcmDatasetData(@lcmMovementOutfit, :treatWalkLikeDash)
    # gets the appropriate walking/dashing graphic depending on if side jumping or dash jumping
    correctWalkingOrDashingGraphic = "none" # start with "none" as the value
    if ( (!treatWalkingAsDash) || (dash?))
      # get whether or not separate dashing is enabled
      dashingEnabled = $game_party.getExSaveData("lcmSeparateDashingToggle", LCM::LCM_USE_SEPARATE_DASH_GRAPHICS)
      
      # if dashing is enabled, use the dashing graphic, otherwise, just use the normal one
      if (dashingEnabled)
        # get the active outfit's dashing graphic
        correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalDashingGraphic)
      else
        # get the active outfit's walking graphic
        correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
      end
      
    else
      # get the active outfit's walking graphic
      correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
    end
    # create script movement command to change player graphic back to the normal one
    resetMovement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the normal graphic at position 0
    resetMovement.parameters = [correctWalkingOrDashingGraphic, 0]
    # add the change graphic movement command
    resetMoveRoute.list.insert(0, resetMovement.clone)
    
    # create script movement command to turn off the character stepping animation
    resetMovement.code = 34
    # add the walking animation disabling command 
    resetMoveRoute.list.insert(0, resetMovement.clone)
    
    # run the move routes consecutively
    setuplcmCustomConsecutiveMoveRoutes(sideFallMomMoveRoute, resetMoveRoute)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create and run the move route for falling with momentum
  # * from an unsafe distance down to a platform, and then impacting into the
  # * ground and recovering from that impact.
  #--------------------------------------------------------------------------
  def sideFallMomBig(direction, xDiff, yDiff, activeTerrainTag)
    # how far to jump accounting for direction
    # [4-left, 6-right]
    # If going left, use -xDiff, otherwise, just use xDiff
    finalXValChange = (direction == 4)? (-xDiff) : (xDiff)
    
    # calculate/store the amount of damage to take, and the animation
    # get the fall height damage num and animation num hashes by terrain tag
    terrainFallHeightDamageHash = LCM::LCM_UNSAFE_FALL_HEIGHT_DAMAGE[activeTerrainTag]
    terrainFallHeightAnimHash = LCM::LCM_UNSAFE_FALL_HEIGHT_DAMAGE_ANIM_IDS[activeTerrainTag]
    # if there is a specified damage for the amount of tiles fallen, use
    # that number, otherwise, use the FALL_HEIGHT_MAX_DAMAGE info
    if (terrainFallHeightDamageHash.has_key?(yDiff))
      damageTaken = terrainFallHeightDamageHash[yDiff]
      damageAnimID = terrainFallHeightAnimHash[damageTaken]
    else
      damageTaken = LCM::LCM_FALL_HEIGHT_MAX_DAMAGE
      damageAnimID = terrainFallHeightAnimHash[damageTaken]
    end
    
    # if there is an outfit override for the damage taken from falls, use that instead
    if (LCM::LCM_FALL_HEIGHT_DAMAGE_NUMBER_OUTFIT_OVERRIDE.has_key?(@lcmMovementOutfit))
      # get the fall height damage num hash by the outfit
      outfitFallHeightDamageHash = LCM::LCM_FALL_HEIGHT_DAMAGE_NUMBER_OUTFIT_OVERRIDE[@lcmMovementOutfit]
      
      # if there is a specified damage for the amount of tiles fallen for the
      # outfit, use that number, otherwise, use the FALL_HEIGHT_MAX_DAMAGE info
      if (outfitFallHeightDamageHash.has_key?(yDiff))
        damageTaken = outfitFallHeightDamageHash[yDiff]
        damageAnimID = terrainFallHeightAnimHash[damageTaken]
      else
        damageTaken = LCM::LCM_FALL_HEIGHT_MAX_DAMAGE
        damageAnimID = terrainFallHeightAnimHash[damageTaken]
      end
    end
    
    # the hpChange is damageTaken * -1
    hpChange = damageTaken * -1
    
    # create new move route and set move route settings
    sideFallMomBigMoveRoute = RPG::MoveRoute.new
    sideFallMomBigMoveRoute.repeat = false
    sideFallMomBigMoveRoute.skippable = false
    sideFallMomBigMoveRoute.wait = true
    
    # create script movement command (will be used with different data repeatedly)
    # NOTE: the entries are executed in reverse order (to how it would normally
    # be set up in an event) due to how insertion works!!!
    movement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    movement.code = 0
    movement.parameters = []
    sideFallMomBigMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to jump
    movement.code = 14 # 14 is for the "Jump" command
    # jump down to the y difference (y vals increase going downward)
    movement.parameters = [finalXValChange, yDiff]
    # add the jump movement command to the move route
    sideFallMomBigMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to turn on the character stepping animation
    movement.code = 33
    # add the walking animation enabling command 
    sideFallMomBigMoveRoute.list.insert(0, movement.clone)
    
    sideFallingGraphic = "" # set placeholder empty graphic filename
    # if the dash jump graphic should be used for momentum falls,
    # then use the dash jump graphic. Otherwise, use the standard
    # side fall graphic
    if (LCM::LCM_USE_DASH_JUMP_GRAPHIC_ON_MOMENTUM_FALL == false)
      # get the active outfit's standard side falling graphic
      sideFallingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :sideFallingGraphic)
    else
      # set the sideFallingGraphic to be the dash jumping graphic
      sideFallingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :dashJumpGraphic)
    end
    # create script movement command to change player graphic to the jumping graphic
    movement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the set jump graphic at position 0
    movement.parameters = [sideFallingGraphic, 0]
    # add the change graphic movement command
    sideFallMomBigMoveRoute.list.insert(0, movement.clone)
    
    # get the active outfit's standard jump SE data
    jumpSEName = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEName)
    jumpSEVolume = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEVol)
    jumpSEPitch = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEPitch)
    # create script movement command to play the jump sound
    movement.code = 44 # 44 is for the "Play SE" command
    # set up the sound with filename, speed, pitch
    movement.parameters = [RPG::SE.new(jumpSEName, jumpSEVolume, jumpSEPitch)]
    # add the play SE movement command to the move route
    # (.clone makes it so that a copy of the original movement object's data)
    sideFallMomBigMoveRoute.list.insert(0, movement.clone)
    
    # create new move route to execute AFTER the other one (it is set to
    # wait for completion to change the graphic back to normal) and set up the settings
    fallenMoveRoute = RPG::MoveRoute.new
    fallenMoveRoute.repeat = false
    fallenMoveRoute.skippable = false
    fallenMoveRoute.wait = false
    
    # if the character is a follower, set the fallen move route to wait
    # so they don't move while fallen
    if (self.kind_of?(Game_Follower))
      fallenMoveRoute.wait = true
    end
    
    # create move command for the resetMoveRoute
    fallenMovement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    fallenMovement.code = 0
    fallenMovement.parameters = []
    fallenMoveRoute.list.insert(0, fallenMovement.clone)
    
    treatWalkingAsDash = LCM.getlcmDatasetData(@lcmMovementOutfit, :treatWalkLikeDash)
    # gets the appropriate walking/dashing graphic depending on if side jumping or dash jumping
    correctWalkingOrDashingGraphic = "none" # start with "none" as the value
    if ( (!treatWalkingAsDash) || (dash?))
      # get whether or not separate dashing is enabled
      dashingEnabled = $game_party.getExSaveData("lcmSeparateDashingToggle", LCM::LCM_USE_SEPARATE_DASH_GRAPHICS)
      
      # if dashing is enabled, use the dashing graphic, otherwise, just use the normal one
      if (dashingEnabled)
        # get the active outfit's dashing graphic
        correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalDashingGraphic)
      else
        # get the active outfit's walking graphic
        correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
      end
      
    else
      # get the active outfit's walking graphic
      correctWalkingOrDashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
    end
    # create script movement command to change player graphic back to the normal one
    fallenMovement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the normal graphic at position 0
    fallenMovement.parameters = [correctWalkingOrDashingGraphic, 0]
    # add the change graphic movement command
    fallenMoveRoute.list.insert(0, fallenMovement.clone)
    
    # get the active outfit's fall recovery SE data
    recoverySEName = LCM.getlcmDatasetData(@lcmMovementOutfit, :unsafeFallRecoverSEName)
    recoverySEVolume = LCM.getlcmDatasetData(@lcmMovementOutfit, :unsafeFallRecoverSEVol)
    recoverySEPitch = LCM.getlcmDatasetData(@lcmMovementOutfit, :unsafeFallRecoverSEPitch)
    # create script movement command to play the fallen recovery sound
    fallenMovement.code = 44 # 44 is for the "Play SE" command
    # set up the sound with filename, speed, pitch
    fallenMovement.parameters = [RPG::SE.new(recoverySEName, recoverySEVolume, recoverySEPitch)]
    # add the play SE movement command to the move route
    fallenMoveRoute.list.insert(0, fallenMovement.clone)
    
    # get the active outfit's fall recovery time
    recoveryTime = LCM.getlcmDatasetData(@lcmMovementOutfit, :unsafeFallRecoveryTime)
    # create script movement command to wait 60 frames
    fallenMovement.code = 15 # 15 is for the "Wait" command
    fallenMovement.parameters = [recoveryTime]
    # add the wait movement command
    fallenMoveRoute.list.insert(0, fallenMovement.clone)
    
    # Do damage to the party ONLY IF THE CHARACTER IS THE PLAYER!!!
    # followers, other events, etc. will not trigger a party change hp
    if (self.kind_of?(Game_Player))
      # create script movement command to execute script to emulate the effect
      # of changing party HP through an event
      fallenMovement.code = 45 # 45 is for the "Script" command
      # set up the lines to execute
      changeHPScriptLinesToExec = "" # placeholder to replace
      # if only the player should be damaged, then just do that,
      # otherwise, damage the entire party.
      #
      # notes:
      # - the true in change_hp() is to enable death for the actor hp changing
      # - damageTaken.to_s is the damageTaken var added into the string script to be evaluated
      if (LCM::LCM_DAMAGE_PLAYER_ONLY == true)
        # damage just the player
        changeHPScriptLinesToExec = ("
          actor = $game_actors[$game_player.lcmGetPlayerActorID]
          if !actor.dead?
            actor.change_hp(" + hpChange.to_s + ", true)
            actor.perform_collapse_effect if actor.dead?
            SceneManager.goto(Scene_Gameover) if $game_party.all_dead?
          end"
        )
      else
        # damage the whole party
        changeHPScriptLinesToExec = (
          "$game_party.members.each { |actor|
            next if actor.dead?
            actor.change_hp(" + hpChange.to_s + ", true)
            actor.perform_collapse_effect if actor.dead?
            SceneManager.goto(Scene_Gameover) if $game_party.all_dead?
          }")
      end
      fallenMovement.parameters = [changeHPScriptLinesToExec]
      # add the Script movement command to the move route
      fallenMoveRoute.list.insert(0, fallenMovement.clone)
    end
    
    # get the active outfit's fallen graphic
    fallImpactGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :unsafeFallImpactGraphic)
    # create script movement command to change player graphic back to the fallen over version
    fallenMovement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the fallen graphic at position 0
    fallenMovement.parameters = [fallImpactGraphic, 0]
    # add the change graphic movement command
    fallenMoveRoute.list.insert(0, fallenMovement.clone)
    
    # Do not do damage number animations for followers (FOR NOW....)
    if (!self.kind_of?(Game_Follower))
      # create script movement command to execute script to emulate the effect
      # of showing an animation through an event
      fallenMovement.code = 45 # 45 is for the "Script" command
      # set up the line to execute
      # note: all you need to do to play an animation in a move route is
      # just setting animation_id = animNumber apparently
      animationScriptLineToExec = ("self.animation_id = " + damageAnimID.to_s)
      fallenMovement.parameters = [animationScriptLineToExec]
      # add the Script movement command to the move route
      fallenMoveRoute.list.insert(0, fallenMovement.clone)
    end
    
    # create script movement command to turn off the character stepping animation
    fallenMovement.code = 34
    # add the walking animation disabling command 
    fallenMoveRoute.list.insert(0, fallenMovement.clone)
    
    # try to get SE data based off of terrain tag. if it fails, use the default
    fallImpactSEName = "none" # init to placeholder vals
    if(LCM::LCM_TERRAIN_TAGS_UNSAFE_LAND_SE_DATA.has_key?(activeTerrainTag))
      fallImpactSEDataArray = LCM::LCM_TERRAIN_TAGS_UNSAFE_LAND_SE_DATA[activeTerrainTag] # get the array of SE data
    else
      fallImpactSEDataArray = LCM:: LCM_DEFAULT_UNSAFE_LAND_SE_DATA # get the array of SE data
    end
    # if there is an outfit override for the sound for fall impact, use that instead
    if (LCM::LCM_UNSAFE_FALL_IMPACT_OUTFIT_OVERRIDE_SE_DATA.has_key?(@lcmMovementOutfit))
      fallImpactSEDataArray = LCM::LCM_UNSAFE_FALL_IMPACT_OUTFIT_OVERRIDE_SE_DATA[@lcmMovementOutfit]
    end
  
    # use the correct SE data array to get the final SE data values
    fallImpactSEName = fallImpactSEDataArray[0]
    fallImpactSEVol = fallImpactSEDataArray[1]
    fallImpactSEPitch = fallImpactSEDataArray[2]
    
    # create script movement command to play the fallen sound
    fallenMovement.code = 44 # 44 is for the "Play SE" command
    # set up the sound with filename, speed, pitch
    fallenMovement.parameters = [RPG::SE.new(fallImpactSEName, fallImpactSEVol, fallImpactSEPitch)]
    # add the play SE movement command to the move route
    fallenMoveRoute.list.insert(0, fallenMovement.clone)
    
    # run the move routes consecutively
    setuplcmCustomConsecutiveMoveRoutes(sideFallMomBigMoveRoute, fallenMoveRoute)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create and run the move route for falling with momentum
  # * down past the border of the map, causing a game over.
  #--------------------------------------------------------------------------
  def sideFallMomGameOver(direction, xDiff, yDiff)
    # how far to jump accounting for direction
    # [4-left, 6-right]
    # If going left, use -xDiff, otherwise, just use xDiff
    finalXValChange = (direction == 4)? (-xDiff) : (xDiff)
    
    # create new move route and set move route settings
    normalSideFallMomMoveRoute = RPG::MoveRoute.new
    normalSideFallMomMoveRoute.repeat = false
    normalSideFallMomMoveRoute.skippable = false
    normalSideFallMomMoveRoute.wait = true
    
    # create script movement command (will be used with different data repeatedly)
    # NOTE: the entries are executed in reverse order (to how it would normally
    # be set up in an event) due to how insertion works!!!
    movement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    movement.code = 0
    movement.parameters = []
    normalSideFallMomMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to jump
    movement.code = 14 # 14 is for the "Jump" command
    # jump down to the y difference (y vals increase going downward)
    movement.parameters = [finalXValChange, yDiff]
    # add the jump movement command to the move route
    normalSideFallMomMoveRoute.list.insert(0, movement.clone)
    
    # create script movement command to turn on the character stepping animation
    movement.code = 33
    # add the walking animation enabling command 
    normalSideFallMomMoveRoute.list.insert(0, movement.clone)
    
    sideFallingGraphic = "" # set placeholder empty graphic filename
    # if the dash jump graphic should be used for momentum falls,
    # then use the dash jump graphic. Otherwise, use the standard
    # side fall graphic
    if (LCM::LCM_USE_DASH_JUMP_GRAPHIC_ON_MOMENTUM_FALL == false)
      # get the active outfit's standard side falling graphic
      sideFallingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :sideFallingGraphic)
    else
      # set the sideFallingGraphic to be the dash jumping graphic
      sideFallingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :dashJumpGraphic)
    end
    # create script movement command to change player graphic to the jumping graphic
    movement.code = 41 # 41 is for the "Change Actor Graphic" command
    # change player graphic to the set jump graphic at position 0
    movement.parameters = [sideFallingGraphic, 0]
    # add the change graphic movement command
    normalSideFallMomMoveRoute.list.insert(0, movement.clone)
    
    # get the active outfit's standard jump SE data
    jumpSEName = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEName)
    jumpSEVolume = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEVol)
    jumpSEPitch = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpSEPitch)
    # create script movement command to play the jump sound
    movement.code = 44 # 44 is for the "Play SE" command
    # set up the sound with filename, speed, pitch
    movement.parameters = [RPG::SE.new(jumpSEName, jumpSEVolume, jumpSEPitch)]
    # add the play SE movement command to the move route
    # (.clone makes it so that a copy of the original movement object's data)
    normalSideFallMomMoveRoute.list.insert(0, movement.clone)
    
    # create new move route to execute AFTER the other one (it is set to
    # wait for completion to change the graphic back to normal) and set up the settings
    gameOverFallMoveRoute = RPG::MoveRoute.new
    gameOverFallMoveRoute.repeat = false
    gameOverFallMoveRoute.skippable = false
    gameOverFallMoveRoute.wait = false
    
    # create move command for the resetMoveRoute
    gameOverMovement = RPG::MoveCommand.new
    
    # route end movement command (code 0)
    gameOverMovement.code = 0
    gameOverMovement.parameters = []
    gameOverFallMoveRoute.list.insert(0, gameOverMovement.clone)
    
    # only do a game over if the character is the player
    if (self.kind_of?(Game_Player))
      # create script movement command to execute script to emulate the effect
      # of doing a game over through an event
      gameOverMovement.code = 45 # 45 is for the "Script" command
      # set up the line to execute
      gameOverScriptLineToExec = "SceneManager.goto(Scene_Gameover)"
      gameOverMovement.parameters = [gameOverScriptLineToExec]
      # add the Script movement command to the move route
      gameOverFallMoveRoute.list.insert(0, gameOverMovement.clone)
    end
    
    # create script movement command to turn off the character stepping animation
    gameOverMovement.code = 34
    # add the walking animation disabling command 
    gameOverFallMoveRoute.list.insert(0, gameOverMovement.clone)
    
    # run the move route
    setuplcmCustomConsecutiveMoveRoutes(normalSideFallMomMoveRoute, gameOverFallMoveRoute)
  end
  
  # Variable used to store a fiber for move routes that are forced here,
  # so that move routes can wait for the previous one to execute without
  # using a Game_Interpreter object
  attr_accessor :lcmCustomConsecutiveMoveRoutesFiber
  
  # Variable to store the moveRouteList
  attr_accessor :lcmCustomConsecutiveMoveRoutesList
  
  # Variable to store moveRouteIndex
  attr_accessor :lcmCustomConsecutiveMoveRoutesIndex
  
  # Variable to make sure characters stay still while the lcm move route(s)
  # are executing
  attr_accessor :lcmStayImmobile
  
  #--------------------------------------------------------------------------
  # * Aliased update() method for Game_CharacterBase used to continue the
  # * Fiber on frame updated for custom consecutive move routes if there are
  # * move routes that still need to be executed.
  #--------------------------------------------------------------------------
  alias after_lcm_custom_fiber_update update
  def update
    # if the fiber exists, check if it is alive, and if it is,
    # resume the fiber
    @lcmCustomConsecutiveMoveRoutesFiber.resume if @lcmCustomConsecutiveMoveRoutesFiber
    
    # call original method
    after_lcm_custom_fiber_update
  end
  
  #--------------------------------------------------------------------------
  # * New method used to set up a list of move routes to execute consecutively
  # * using a Fiber. Creates a new Fiber to store and run later.
  #--------------------------------------------------------------------------
  def setuplcmCustomConsecutiveMoveRoutes(*moveRouteList)
    # if lcmCustomConsecutiveMoveRoutesList is nil, then fill in the list
    if (@lcmCustomConsecutiveMoveRoutesList == nil)
      # set up empty array
      @lcmCustomConsecutiveMoveRoutesList = []
      
      # put each move route in the parameter list into lcmCustomConsecutiveMoveRoutesList
      moveRouteList.each do |moveRoute|
        # push in moveRoute
        @lcmCustomConsecutiveMoveRoutesList.push(moveRoute)
      end
    end
    
    # create and run the moveRoutes fiber as long as there are move routes to run
    @lcmCustomConsecutiveMoveRoutesFiber = Fiber.new { runlcmCustomConsecutiveMoveRoutes } if @lcmCustomConsecutiveMoveRoutesList
  end
  
  #--------------------------------------------------------------------------
  # * New method used to execute move routes consecutively using a Fiber
  # * so that the move routes will actually wait for completion (normally,
  # * such waiting is done through a Game_Interpreter object, but I cannot
  # * find a way to access one in a usable way).
  #--------------------------------------------------------------------------
  def runlcmCustomConsecutiveMoveRoutes
    # do not let any non-moverout moves occur while this method runs
    @lcmStayImmobile = true
    
    @lcmCustomConsecutiveMoveRoutesIndex = 0
    
    # go through the move routes, and do all of them in order
    while @lcmCustomConsecutiveMoveRoutesList[@lcmCustomConsecutiveMoveRoutesIndex] do
      # get current move route
      currMoveRoute = @lcmCustomConsecutiveMoveRoutesList[@lcmCustomConsecutiveMoveRoutesIndex]
      $game_map.refresh if $game_map.need_refresh # refresh map if needed
      # force the new move route
      self.force_move_route(currMoveRoute)
      Fiber.yield while self.move_route_forcing if currMoveRoute.wait
      
      @lcmCustomConsecutiveMoveRoutesIndex += 1
    end
    Fiber.yield
    
    # clear out lcmCustomConsecutiveMoveRoutesFiber and the list when done
    @lcmCustomConsecutiveMoveRoutesFiber = nil
    @lcmCustomConsecutiveMoveRoutesList = nil
    
    # allow normal movement again
    @lcmStayImmobile = false
    
    # get whether or not separate dashing is enabled
    dashingEnabled = $game_party.getExSaveData("lcmSeparateDashingToggle", LCM::LCM_USE_SEPARATE_DASH_GRAPHICS)
    # if dashing is enabled, then activate the dash refresh flag for
    # player and follower objects
    if (dashingEnabled)
      if (self.kind_of?(Game_Player) || self.kind_of?(Game_Follower))
        self.activateDashRefresh
      end
    end
    
  end
  
end # end of Game_CharacterBase


class Game_Character < Game_CharacterBase  
  #--------------------------------------------------------------------------
  # * Overridden jump method used to make it so that when doing sidefall
  # * "jumps" (as in the jump method's usage to drop down), the graphic
  # * does not change to looking downwards, instead, right/left difference is kept.
  #--------------------------------------------------------------------------
  def jump(x_plus, y_plus)
    # if the setting to turn off jump direction changing is set to false,
    # still do the direction change
    if (LCM::LCM_JUMP_DOES_NOT_CAUSE_DIRECTION_CHANGE == false)
      if x_plus.abs > y_plus.abs
        set_direction(x_plus < 0 ? 4 : 6) if x_plus != 0
      else
        set_direction(y_plus < 0 ? 8 : 2) if y_plus != 0
      end
    end
    
    # standard method lines
    @x += x_plus
    @y += y_plus
    distance = Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
    @jump_peak = 10 + distance - @move_speed
    @jump_count = @jump_peak * 2
    @stop_count = 0
    straighten
  end
end


class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Aliased movable?() method for Game_Player used to prevent movement
  # * if an lcm movement is in the process of executing.
  #--------------------------------------------------------------------------
  alias after_lcm_movability_checks movable?
  def movable?
    return false if @lcmStayImmobile
    
    # call original method
    after_lcm_movability_checks
  end
  
  #--------------------------------------------------------------------------
  # * Aliased movable?() method for Game_Player used to prevent movement
  # * if an lcm movement is in the process of executing.
  #--------------------------------------------------------------------------
  def checkIfSpecialMovementOk
    # return false if a normal move would not be able to be executed
    return false if !movable?
    
    # return false if the menu is disabled (this for in case the
    # game uses an item-based outfit setup, as ropes and lcm movement
    # disable the menu in that case)
    return false if $game_system.menu_disabled
    
    # return false if currently on a rope
    return false if (@characterUsingRopes == true)
    
    # return true if the previous checks were all met
    return true
  end
  
  #--------------------------------------------------------------------------
  # * New method made for use in events to force fall checking for the
  # * player, and their followers if followers are being used.
  # * Call with "$game_player.doPlayerFallCheck"
  #--------------------------------------------------------------------------
  def doPlayerFallCheck    
    # call sideFallChecks with the player's last direction, and mark it as "forced",
    # so the "last platform" check is skipped (the one that checks if last tile
    # walked on was a platform or not)
    $game_player.sideFallChecks($game_player.lastDirection, true)
    
    # get whether or not follower lcm movement is enabled for followers
    areFollowersEnabled = $game_party.getExSaveData("lcmFollowerToggle", LCM::LCM_FOLLOWERS_ENABLED)
    if (areFollowersEnabled == true)
      # iterate through the list of followers, and do sideFallChecks for all
      # of them if they are "visible"
      $game_player.followers.each do |follower|
        # if the follower is "visible" (is assigned to an actor and visibly present),
        # then do sideFallChecks for them
        if (follower.visible?)
          follower.sideFallChecks(follower.lastDirection, true)
        end
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method made to mark the player's outfit and any of their followers
  # * (if enabled) as needing an outfit refresh.
  #--------------------------------------------------------------------------
  def doFullOutfitRefresh
    # set the outfit for the player as needing a refresh
    @characterOutfitRefreshNeeded = true
    
    # set the outfit for the player's followers as needing a refresh
    # get whether or not follower lcm movement is enabled for followers
    areFollowersEnabled = $game_party.getExSaveData("lcmFollowerToggle", LCM::LCM_FOLLOWERS_ENABLED)
    # if followers are enabled, then set that an outfit refresh is needed
    # for all followers
    if (areFollowersEnabled == true)
      # mark all followers as needing an outfit refresh
      $game_player.followers.each do |follower|
        # if the follower is "visible" (is assigned to an actor and visibly
        # present), then mark them as needing an outfit refresh and refresh the outfit
        if (follower.visible?)
          follower.characterOutfitRefreshNeeded = true
        end
      end
    end
  end
    
  #--------------------------------------------------------------------------
  # * New method to directly restore the outfit graphic and outfit speed
  # * (if enabled), and potentially, their followers graphics if the optional
  # * parameter is used.
  #--------------------------------------------------------------------------
  def restoreOutfitGraphicAndSpeed(includeFollowers = false)
    # make sure character outfit for the player aligns with the one in the
    # associated actor (if there is one)
    refreshCharacterOutfitByActor
    
    # note: followers take the player's speed, so it just needs to be
    # set for the player
    
    # get whether or not outfit walk speed is enabled for the player
    outfitWalkSpeedEnabled = $game_party.getExSaveData("lcmUseOutfitWalkSpeedToggle", LCM::LCM_USE_OUTFIT_WALK_SPEED)
    # if outfit walk speed is enabled, then activate change the player walk
    # speed to the outfit speed if it is not set to 0.
    if (outfitWalkSpeedEnabled)
      # get the jump up height associated with the active outfit
      outfitWalkSpeed = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkSpeed)
      if (outfitWalkSpeed != 0) # make sure the speed is not 0
        @move_speed = outfitWalkSpeed
      end
    end
    
    # set the actor's graphic to their walking or dashing graphic, depending.
    
    # get the walking graphic and update the flags appropriately
    walkingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
    # get the character's dashing graphic
    dashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalDashingGraphic)
    # get whether or not separate dashing is enabled
    dashingEnabled = $game_party.getExSaveData("lcmSeparateDashingToggle", LCM::LCM_USE_SEPARATE_DASH_GRAPHICS)
    # only do the new dash check if LCM_USE_SEPARATE_DASH_GRAPHICS is enabled
    if (dashingEnabled == true && dash?)
      # set the dashing graphic
      set_graphic(dashingGraphic, 0)
    else
      # set the walking graphic
      set_graphic(walkingGraphic, 0)
    end
    
    # set the outfit for the player's followers as needing a refresh
    # get whether or not follower lcm movement is enabled for followers
    areFollowersEnabled = $game_party.getExSaveData("lcmFollowerToggle", LCM::LCM_FOLLOWERS_ENABLED)
    # if followers are enabled, then set that an outfit refresh is needed
    # for all followers
    if (areFollowersEnabled == true && includeFollowers == true)
      # update graphic for all visible followers
      $game_player.followers.each do |follower|
        # if the follower is "visible" (is assigned to an actor and visibly
        # present), then refresh their outfit if needed, and set their graphic
        if (follower.visible?)
          follower.refreshCharacterOutfitByActor # refresh follower outfit if needed
          
          # get the walking graphic and update the flags appropriately
          followerWalkingGraphic = LCM.getlcmDatasetData(follower.lcmMovementOutfit, :normalWalkingGraphic)
          # get the character's dashing graphic
          dashingGraphic = LCM.getlcmDatasetData(follower.lcmMovementOutfit, :normalDashingGraphic)
          # only do the new dash check if LCM_USE_SEPARATE_DASH_GRAPHICS is enabled
          if (dashingEnabled == true && dash?)
            # set the dashing graphic
            follower.set_graphic(dashingGraphic, 0)
          else
            # set the walking graphic
            follower.set_graphic(walkingGraphic, 0)
          end
          
        end
      end
      
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method to return the actor ID of the actor associated with
  # * the Player object.
  #--------------------------------------------------------------------------
  def lcmGetPlayerActorID
    # note: 'actor' here is a method that returns the Game_Actor object associated
    # with the player object using the line below:
    # $game_party.battle_members[0]
    #
    # return the actor's id
    return(actor.id)
  end
  
  #--------------------------------------------------------------------------
  # * New method to return the player's followers. This is needed to access
  # * the "followers" variable from outside the Game_Player class, since
  # * "followers" is a reader variable.
  #--------------------------------------------------------------------------
  def lcmGetPlayerFollowers
    return @followers
  end
  
  #--------------------------------------------------------------------------
  # * New method to change the player's active outfit to the new outfit.
  # * Mean for use in other parts of the script (not external events) with call
  # * "$game_player.changeCharacterOutfit("newOutfitName")"
  #--------------------------------------------------------------------------
  def changeCharacterOutfit(newOutfitName)
    @lcmMovementOutfit = newOutfitName # set lcmMovementOutfit to the newOutfitName
    
    # refresh the outfit as well
    @characterOutfitRefreshNeeded = true
  end
  
  #--------------------------------------------------------------------------
  # * Aliased perform_transfer method for the Game_Player class used to
  # * reset the follower game over checking if followers are enabled as
  # * well as follower game over checking.
  #--------------------------------------------------------------------------
  alias after_lcm_follower_game_over_check_reset perform_transfer
  def perform_transfer
    # if the transfer is successful, and followers are enabled as well
    # as follower game over checking, then clear follower game over flags
    if (transfer?)
      # get whether or not follower lcm movement is enabled
      areFollowersEnabled = $game_party.getExSaveData("lcmFollowerToggle", LCM::LCM_FOLLOWERS_ENABLED)
      # get whether or not follower game overs are disabled
      followersGameOverDisabled = !(LCM::LCM_FOLLOWER_GAMEOVER_ALLOWED)
      
      # follower enable/game over enable check here
      if ((areFollowersEnabled == true) && (followersGameOverDisabled == true))
        # reset the lastMoveGameOverAvoided flag for all followers to false
        $game_player.followers.each do |follower|
          follower.lastMoveGameOverAvoided = false
        end
      end
    end
    
    # call original method (actually do the transfer)
    after_lcm_follower_game_over_check_reset
  end
  
end


class Game_Follower < Game_Character
  #--------------------------------------------------------------------------
  # * Overridden update() for the Game_Follower class used keep through
  # * off for followers, unles the player has through on, or if the
  # * debug through is on. Overridden instead of aliased because
  # * the superclass update() method in characterBase has explicit return
  # * statements in it (and if aliased before, the through change would be
  # * overwritten).
  #--------------------------------------------------------------------------
  def update
    @move_speed     = $game_player.real_move_speed
    @transparent    = $game_player.transparent
    @walk_anime     = $game_player.walk_anime
    @step_anime     = $game_player.step_anime
    @direction_fix  = $game_player.direction_fix
    @opacity        = $game_player.opacity
    @blend_type     = $game_player.blend_type
    if ($game_player.through || $game_player.debug_through? || !visible?)
      @through = true
    else
      @through = false
    end
    super
  end
  
  #--------------------------------------------------------------------------
  # * Overridden chase_preceding_character() method used to prevent
  # * followers from moving diagonally, and to have rudimentary pathfinding
  # * when lcm movement is on (meaning when through is off).
  #--------------------------------------------------------------------------
  def chase_preceding_character
    # if through is on, use the original version of the method
    if (@through == true)
      # original method here (nothing modified)
      unless (moving?)
        sx = distance_x_from(@preceding_character.x)
        sy = distance_y_from(@preceding_character.y)
        if sx != 0 && sy != 0
          move_diagonal(sx > 0 ? 4 : 6, sy > 0 ? 8 : 2)
        elsif sx != 0
          move_straight(sx > 0 ? 4 : 6)
        elsif sy != 0
          move_straight(sy > 0 ? 8 : 2)
        end
      end
    
    # if the follower is currently climbing a rope,
    # then try to move vertically towards the preceding character
    # if there is no horizontal passage,
    # or horizontally towards the preceding character if there is no
    # horizontal passage.
    # otherwise, do the normal revised pathfinding
    elsif (inRopesMode? == true)
      # use the special rope version of follower pathfinding that
      # tries to help ensure that followers don't get stuck on them
      ropeFollowerPathfinding
      
    # new version of the method here, forces moving straight movement
    # and has some better pathfinding for 2d platforming
    else
      # do the revised follower pathfinding
      revisedFollowerPathfinding
    end # end of the different follower movement versions
    
  end
    
  #--------------------------------------------------------------------------
  # * New method used to make a follower use a revised form of pathfinding,
  #--------------------------------------------------------------------------
  def revisedFollowerPathfinding
    # don't try to move again if executing an lcm movement, or already moving
    unless (@lcmStayImmobile || moving?)
      # if the follower poor agility catchup is on, see if the followers
      # have fallen too far behind the player, and should try to follow the
      # player instead of the next follower for a little while.
      if (LCM::LCM_FOLLOWER_POOR_AGILITY_CATCHUP == true)
        # check if x distance (absolute value, don't consider direction) from
        # the player is greater than the follower's member index to see
        # if the x distance is too great
        xPlayerReqs = (distance_x_from($game_player.x)).abs() > @member_index
        # check if the y distance from the player (absolute) from the
        # player is greater than 1 to see if y distance is too great.
        yPlayerReqs = distance_y_from($game_player.y).abs() >= 1
        # if the X or Y reqs are met, then set sx and sy to be in relation
        # to the player (follow the player), otherwise, set them in
        # relation to the next follower (the normal way).
        if (xPlayerReqs || yPlayerReqs)
          sx = distance_x_from($game_player.x)
          sy = distance_y_from($game_player.y)
        else
          sx = distance_x_from(@preceding_character.x)
          sy = distance_y_from(@preceding_character.y)
        end
      
      else
        # standard version of choosing sx and sy
        sx = distance_x_from(@preceding_character.x)
        sy = distance_y_from(@preceding_character.y)
      end
      
      if (sx != 0 && sy != 0)
        # sx and sy take direction into account (left is -, right is +),
        # so take the absoulute value to get the true distance
        absoluteXDistance = sx.abs()
        absoluteYDistance = sy.abs()
      
        # if the y distance is greater than or equal to the x distance,
        # then give the y movement priority, otherwise, the x movement
        if (absoluteYDistance >= absoluteXDistance)
          canYMovementBeMade = false # start the movement is not being possible
          
          # get whether the follower would move up or down if it did a y movement
          prospectiveDirection = (sy > 0 ? 8 : 2)
          
          # make sure character outfit aligns with the one in the associated
          # actor (if there is one)
          refreshCharacterOutfitByActor
          
          # direction 8 is up, so check the above tiles
          # followerUp/DownLedgeCheck returns true/false depending on if
          # a platform was found in jumping range.
          if (prospectiveDirection == 8)
            canYMovementBeMade = followerUpLedgeCheck
          # direction 2 is down, so check the below tiles
          elsif (prospectiveDirection == 2)
            canYMovementBeMade = followerDownLedgeCheck
          end
          
          # if a y-axis movement can be made do that, otherwise,
          # do an x-axis movement instead, since that can almost always be done.
          if (canYMovementBeMade == true)
            move_straight(sy > 0 ? 8 : 2)
          else
            move_straight(sx > 0 ? 4 : 6)
          end
          
        else
          move_straight(sx > 0 ? 4 : 6)
        end
      elsif sx != 0
        move_straight(sx > 0 ? 4 : 6)
      elsif sy != 0
        move_straight(sy > 0 ? 8 : 2)
      end
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * New method used to make a follower use a special ropeclimbing form
  # * of pathfinding. This is made so that followers don't get stuck
  # * on ropes as they tend to do using the normal pathfinding.
  #--------------------------------------------------------------------------
  def ropeFollowerPathfinding
    # don't try to move again if executing an lcm movement, or already moving
    unless (@lcmStayImmobile || moving?)
      
      intendedDirection = 1
      
      currentX = self.x
      currentY = self.y
      
      # (up and down are directions 2 and 8)
      tileVerticallyPassable = ($game_map.passable?(currentX, currentY, 2) || $game_map.passable?(currentX, currentY, 8))
      tileHorizontallyPassable = ($game_map.passable?(currentX, currentY, 4) || $game_map.passable?(currentX, currentY, 6))
      
      # if the tile is only vertically passable, then move up/down
      # towards the y-row the player is at (unless on same one, then
      # just don't move)
      if (tileVerticallyPassable && !tileHorizontallyPassable)
        # use the player x and y values when choosing sx and sy
        sy = distance_y_from($game_player.y)
      
        # only do anything if sy isn't 0
        if (sy != 0)
          # get whether the follower would move up or down if it did a y movement
          prospectiveDirection = (sy > 0 ? 8 : 2)
          
          # move towards the prospective direction
          move_straight(prospectiveDirection)
        end
      
      
      # if the tile is only horizontally passable, then move left/right
      # towards the x-column the player is at (unless on same one, then
      # just don't move)
      elsif (!tileVerticallyPassable && tileHorizontallyPassable)
        # use the player x values when choosing sx
        sx = distance_x_from($game_player.x)
      
        # only do anything if sx isn't 0
        if (sx != 0)
          # get whether the follower would move left or right if it did a x movement
          prospectiveDirection = (sx > 0 ? 4 : 6)
          
          # move towards the prospective direction
          move_straight(prospectiveDirection)
        end
      
      # if the tile has some other combination of passability, then
      # use the normal "revised" pathfinding
      else
        # do the normal pathfinding
        revisedFollowerPathfinding
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if an actor is "assigned" to a follower. This
  # * is needed because "empty" and invisible follower objects follower the
  # * player, even if the party is empty.
  #--------------------------------------------------------------------------
  def isFollowerAssigned?
    # note: "actor" here is a method that gets the associated actor to the follower,
    # it is not a variable
    #
    # if the associated actor to the follower object exists, return true, otherwise,
    # return false.
    if (actor)
      return true
    else
      return false
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method to change the follower's outfit for use in other parts of
  # * the script (but not external events) with call
  # * "(followerObject).changeCharacterOutfit("newOutfitName")"
  #--------------------------------------------------------------------------
  def changeCharacterOutfit(newOutfitName)
    @lcmMovementOutfit = newOutfitName # set lcmMovementOutfit to the newOutfitName
    
    # refresh the outfit as well
    @characterOutfitRefreshNeeded = true
  end
  
  #--------------------------------------------------------------------------
  # * New method to return the actor ID of the actor associated with
  # * the Player object. Returns -1 if there is no associated actor.
  #--------------------------------------------------------------------------
  def getFollowerActorID
    # note: 'actor' here is a method that returns the Game_Actor object associated
    # with the follower object using the line below:
    # $game_party.battle_members[@member_index]
    
    # if there is no associated actor, return -1
    if(actor == nil)
      return (-1)
    end
    
    # otherwise, return the associated actor's ID.
    return(actor.id)
  end
  
  #--------------------------------------------------------------------------
  # * Aliased dash?() method for the Game_Follower class used to mark followers
  # * as "dashing" if the player is dashing.
  #--------------------------------------------------------------------------
  alias after_lcm_follower_dash_checks dash?
  def dash?
    # get whether or not separate dashing is enabled
    dashingEnabled = $game_party.getExSaveData("lcmSeparateDashingToggle", LCM::LCM_USE_SEPARATE_DASH_GRAPHICS)
    # only do the new dash check if LCM_USE_SEPARATE_DASH_GRAPHICS is enabled
    if (dashingEnabled == true)
      # return true if the player is currently dashing
      return true if $game_player.dash?
    end
    
    # call original method
    after_lcm_follower_dash_checks
  end
  
  #--------------------------------------------------------------------------
  # * Aliased real_move_speed() for the Game_Follower class used to make sure
  # * followers do not have their move speed increased by dashing. Their move
  # * speed is already set to the player's dashing move speed whhen the player
  # * is dashing, so if further increased in this method, it would be inaccurate.
  #--------------------------------------------------------------------------
  alias after_lcm_follower_dash_move_speed_checks real_move_speed
  def real_move_speed
    # get whether or not separate dashing is enabled
    dashingEnabled = $game_party.getExSaveData("lcmSeparateDashingToggle", LCM::LCM_USE_SEPARATE_DASH_GRAPHICS)
    # only do the new dash check if LCM_USE_SEPARATE_DASH_GRAPHICS is enabled
    if (dashingEnabled == true)
      return @move_speed # explicit return the normal move_speed
    else
      # only line of original method -> @move_speed + (dash? ? 1 : 0)
      # call original method
      after_lcm_follower_dash_move_speed_checks
    end
  end
  
end


class Game_Event < Game_Character
  # Variable that stores whether or not the event should be counted as a platform
  # true if it is a platform, otherwise, false
  # Starts as true if there is a platform tag.
  # Used with the event nametag -> [PLT #] to start an event platform with the
  # toggle starting on, or [-PLT #] to start with the platform toggle off.
  attr_accessor :platformToggle
  
  # Variable that stores what terrain tag should be used for the event if it
  # does end up counted as a platform. It gets this from the number in the
  # platform nametag of an event name -> [PLT #] or [-PLT #]
  attr_accessor :terrainTagEquiv
  
  # Variable that stores if the event should temporarily turn off the
  # lcm movement while characters are in the tile containing the event.
  # Used with the event nametag -> [LCMOFF]
  attr_accessor :lcmOffEvent
  
  #--------------------------------------------------------------------------
  # * Aliased initialize() method for the Game_Event class used to set the
  # * equivalent terrain tag and initial platformToggle,. For the platform toggle,
  # * it may retrieve the the information from exSaveData using the key associated
  # * to the event. If there is no associated stored data in exSaveData, and
  # * the initial platform toggle is true, then this is saved into exSaveData.
  # * The potential initial platform toggle and terrain tag equivalent are
  # * taken from the event nametag [PLT #] or [-PLT #], where the # is the
  # * terrain tag equivalent number, and PLT marks starting with the toggle on;
  # * -PLT starting with the toggle off.
  # * Also intializes if the event should temporarily disable the lcm script
  # * while on its tile.
  #--------------------------------------------------------------------------
  alias before_lcm_event_init initialize
  def initialize(map_id, event)
    # call original method
    before_lcm_event_init(map_id, event)
    
    # start with the platform toggle not set yet
    platToggleIsSet = false
    
    # get the event's exSaveData key
    exSaveDataKey = ("mapID- " + @map_id.to_s + " eventID- " + @id.to_s)
    
    # if the exSaveData has the event's key, then use the stored value
    if ($game_party.doesExSaveDataExist?(exSaveDataKey))
      # set the platformToggle appropriately
      @platformToggle = $game_party.getExSaveDataNoInit(exSaveDataKey)
      platToggleIsSet = true
    end
    
    # get the correct terrain tag val, and possibly create the platformToggle
    # exSaveData for the first time
    if (LCM::LCM_PLATFORM_EVENTS_ENABLED == true)
      eventName = @event.name # get the event's name
      
      # use regex to check if eventName contains a platform tag -> [PLT terrainTagNum]
      # if it exists, save the value into @terrainTagEquiv, otherwise, set
      # @terrainTagEquiv to -1
      if (eventName =~ /\[PLT (.*)\]/i)
        # gets the value from notetag ($1 is global var used for regex),
        # and ensures it is integer
        @terrainTagEquiv = $1.to_i
        # if the platform toggle was not set by exSaveData previously, start
        # with platformToggle as true, and create a new entry in exSaveData
        # and set it to true
        if (!platToggleIsSet)
          # the event should be considered a platform, so start with it toggled on
          @platformToggle = true
          $game_party.setExSaveData(exSaveDataKey, true) # update / set the value in exSaveData
        end
      # regex checking for if the event toggle is supposed to start off instead
      # of on.
      elsif (eventName =~ /\[-PLT (.*)\]/i)
        # gets the value from notetag ($1 is global var used for regex),
        # and ensures it is integer
        @terrainTagEquiv = $1.to_i
        # if the platform toggle was not set by exSaveData previously, start
        # with platformToggle as true, and create a new entry in exSaveData
        # and set it to true
        if (!platToggleIsSet)
          # the event should not be considered a platform until enabled, start
          # with it toggled off
          @platformToggle = false
          $game_party.setExSaveData(exSaveDataKey, false) # update / set the value in exSaveData
        end
      # handling for if platform events enabled, but it is not a platform event
      else
        # use -1 as the default for no platform equivalent
        @terrainTagEquiv = -1
        # the event is not a platform, so have it toggled off
        @platformToggle = false
      end
    # handling for if platform events not enabled
    else
        # use -1 as the default for no platform equivalent
        @terrainTagEquiv = -1
        # the event is not a platform, so have it toggled off
        @platformToggle = false
    end
    
    # use regex to check if eventName contains a script off tag -> [LCMOFF]
    # if it exists, set lcmOffEvent to true
    if (eventName =~ /\[LCMOFF\]/i)
      @lcmOffEvent = true
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * New method return the event's name in the stored RPG::Event object.
  # * Necessary becuase the @event variable is a reader type variable.
  #--------------------------------------------------------------------------
  def lcmGetEventName
    return (@event.name) # return the name of stored RPG::Event
  end
  
  #--------------------------------------------------------------------------
  # * Aliased update_stop() method for Game_Event used to not update the event's
  # * movement if it is the middle of an lcm movement.
  #--------------------------------------------------------------------------
  def update_stop
    super
    update_self_movement unless (@move_route_forcing || @lcmStayImmobile)
  end
  
  #--------------------------------------------------------------------------
  # * New method for use in events to change the toggle value of a platform
  # * event in move routes. Default eventID is the event ID for the event
  # * This script is called in unless otherwise specified.
  #--------------------------------------------------------------------------
  def toggleEvPlat(trueOrFalse, eventID = self.id)
    # get the event's exSaveData key
    exSaveDataKey = ("mapID- " + @map_id.to_s + " eventID- " + @id.to_s)
    
    @platformToggle = trueOrFalse
    $game_party.setExSaveData(exSaveDataKey, trueOrFalse) # update / set the value in exSaveData
  end
  
  #--------------------------------------------------------------------------
  # * New method to use in events to change the outfit for an event with lcm movemen.
  # * Default eventID is the event ID for the event this script line is called
  # * in unless otherwise specified.
  #--------------------------------------------------------------------------
  def changeCharacterOutfit(newOutfitName, eventID = self.id)
    eventToChangeOutfit = $game_map.events[eventID]
    eventToChangeOutfit.lcmMovementOutfit = newOutfitName # set lcmMovementOutfit to the newOutfitName
  
    # refresh the outfit as well
    @characterOutfitRefreshNeeded = true
  end
  
end


class Scene_Map < Scene_Base  
  #--------------------------------------------------------------------------
  # * Aliased update_call_menu() method used to prevent opening the menu
  # * while the player is doing an lcm movement of some kind.
  #--------------------------------------------------------------------------
  alias after_lcm_menu_checks_attempt_menu_call update_call_menu
  def update_call_menu
    # if the player is doing an lcm movement, then do not let the menu be called
    if ($game_player.lcmStayImmobile)
      @menu_calling = false
      return
    end
    
    # call original method
    after_lcm_menu_checks_attempt_menu_call
  end
end


class Game_Map
  #--------------------------------------------------------------------------
  # * Aliased initialize() method for the class Game_Map used to initialize
  # * the values for various script toggles.
  # * 
  # * Variable guide:
  # *   lcmScriptToggle: The toggle that toggles the whole script (almost all of it, anyway)
  # *   lcmFollowerToggle: The toggle for followers being enabled or not
  # *   lcmEventMovementToggle: The toggle that would be used for events
  # *   moving in lcm format, but is currently unused
  # *   lcmPlatformEventsToggle: The toggle for events being able to work as platforms
  # *   lcmSeparateDashingToggle: The toggle for dashing getting separate graphics to walking when not jumping/falling
  #--------------------------------------------------------------------------
  alias before_lcm_new_map_init initialize
  def initialize
    # call original method
    before_lcm_new_map_init
    
    # initialize lcmScriptToggle to the value in LCM_TOGGLE_INIT if it has not
    # been set yet.
    if (!$game_party.doesExSaveDataExist?("lcmScriptToggle"))
      $game_party.setExSaveData("lcmScriptToggle", LCM::LCM_TOGGLE_INIT)
    end
    
    # initialize lcmFollowerToggle to the value in LCM_FOLLOWERS_ENABLED
    if (!$game_party.doesExSaveDataExist?("lcmFollowerToggle"))
      $game_party.setExSaveData("lcmFollowerToggle", LCM::LCM_FOLLOWERS_ENABLED)
    end
    
    # initialize lcmEventMovementToggle to the value in LCM_PLAYER_OR_FOLLOWER_EVENT_LCM_MOVEMENT
    #
    # !! Currently unused !!
    #if (!$game_party.doesExSaveDataExist?("lcmEventMovementToggle"))
      #$game_party.setExSaveData("lcmEventMovementToggle", LCM::LCM_PLAYER_OR_FOLLOWER_EVENT_LCM_MOVEMENT)
    #end
    
    # initialize lcmPlatformEventsToggle to the value in LCM_PLATFORM_EVENTS_ENABLED if it has not
    # been set yet.
    if (!$game_party.doesExSaveDataExist?("lcmPlatformEventsToggle"))
      $game_party.setExSaveData("lcmPlatformEventsToggle", LCM::LCM_PLATFORM_EVENTS_ENABLED)
    end
    
    # initialize lcmGlobalDashDisable to the value in LCM_GLOBAL_DASH_DISABLE
    if (!$game_party.doesExSaveDataExist?("lcmGlobalDashDisableToggle"))
      $game_party.setExSaveData("lcmGlobalDashDisableToggle", LCM::LCM_GLOBAL_DASH_DISABLE)
    end
    
    # initialize lcmSeparateDashingToggle to the value in LCM_USE_SEPARATE_DASH_GRAPHICS
    if (!$game_party.doesExSaveDataExist?("lcmSeparateDashingToggle"))
      $game_party.setExSaveData("lcmSeparateDashingToggle", LCM::LCM_USE_SEPARATE_DASH_GRAPHICS)
    end
    
    # initialize lcmUseOutfitWalkSpeed to the value in LCM_USE_OUTFIT_WALK_SPEED
    if (!$game_party.doesExSaveDataExist?("lcmUseOutfitWalkSpeedToggle"))
      $game_party.setExSaveData("lcmUseOutfitWalkSpeedToggle", LCM::LCM_USE_OUTFIT_WALK_SPEED)
    end
    
    # initialize lcmCurrentActiveRopeType to the value in LCM_USE_OUTFIT_WALK_SPEED
    if (!$game_party.doesExSaveDataExist?("lcmCurrentActiveRopeType"))
      $game_party.setExSaveData("lcmCurrentActiveRopeType", LCM::LCM_INITIAL_ACTIVE_ROPE_TYPE)
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Wrapper method to clean up the script call to change the total lcm script toggle
  # * Call this in map events with "$game_map.changelcmScriptToggle(trueOrFalse)"
  #--------------------------------------------------------------------------
  def changelcmScriptToggle(trueOrFalse)
    $game_party.setExSaveData("lcmScriptToggle", trueOrFalse)
    
    # if toggling it on after it has been off, do an outfit refresh
    # for the party
    if (trueOrFalse == true)
      $game_player.doFullOutfitRefresh
    end
  end
  
  #--------------------------------------------------------------------------
  # * Wrapper method to clean up the script call to change the follower toggle
  # * Call this in map events with "$game_map.changelcmFollowerToggle(trueOrFalse)"
  #--------------------------------------------------------------------------
  def changelcmFollowerToggle(trueOrFalse)
    $game_party.setExSaveData("lcmFollowerToggle", trueOrFalse)
  end
  
  #--------------------------------------------------------------------------
  # * Wrapper method to clean up the script call to change the event lcm movement toggle
  # * Call this in map events with "$game_map.changelcmEventMovementToggle(trueOrFalse)"
  #--------------------------------------------------------------------------
  # !!! Currently unused !!!
  #def changelcmEventMovementToggle(trueOrFalse)
    #$game_party.setExSaveData("lcmEventMovementToggle", trueOrFalse)
  #end
  
  #--------------------------------------------------------------------------
  # * Wrapper method to clean up the script call to change the platform events toggle
  # * Call this in map events with "$game_map.changelcmPlatformEventsToggle(trueOrFalse)"
  #--------------------------------------------------------------------------
  def changelcmPlatformEventsToggle(trueOrFalse)
    $game_party.setExSaveData("lcmPlatformEventsToggle", trueOrFalse)
  end
  
  #--------------------------------------------------------------------------
  # * Wrapper method to clean up the script call to change the global dash disable toggle
  # * Call this in map events with "$game_map.changelcmGlobalDashDisableToggle(trueOrFalse)"
  #--------------------------------------------------------------------------
  def changelcmGlobalDashDisableToggle(trueOrFalse)
    $game_party.setExSaveData("lcmGlobalDashDisableToggle", trueOrFalse)
  end
  
  #--------------------------------------------------------------------------
  # * Wrapper method to clean up the script call to change the global dash disable toggle
  # * Call this in map events with "$game_map.changelcmActiveRopeType("newRopeType")"
  #--------------------------------------------------------------------------
  def changelcmActiveRopeType(newRopeType)
    $game_party.setExSaveData("lcmCurrentActiveRopeType", newRopeType)
  end
  
  
  #--------------------------------------------------------------------------
  # * New method to clean up the script call to change the separate dashing graphic toggle.
  # * Also resets associated flags and set the actor graphics to the normal walking graphic.
  # * Call this in map events with "$game_map.changelcmSeparateDashingToggle(trueOrFalse)"
  #--------------------------------------------------------------------------
  def changelcmSeparateDashingToggle(trueOrFalse)
    # the dashing graphic/flags need to be updated to off if the toggle is being set to false
    
    if (trueOrFalse == false)
      # make sure player character outfit aligns with the one in the associated
      # actor (if there is one)
      $game_player.refreshCharacterOutfitByActor
      
      playerWalkingGraphic = LCM.getlcmDatasetData($game_player.lcmMovementOutfit, :normalWalkingGraphic)
      # if setting the toggle to false clear the flags for the player
      # and their followers.
      $game_player.changeToDashGraphic = false
      $game_player.playerDashGraphicInUse = false
      # set player's graphic to the normal walking graphic
      $game_player.set_graphic(playerWalkingGraphic, 0)
      
      # if followers are enabled, do the updates for the followers
      
      # get whether or not follower lcm movement is enabled for followers
      areFollowersEnabled = $game_party.getExSaveData("lcmFollowerToggle", LCM::LCM_FOLLOWERS_ENABLED)
      if (areFollowersEnabled == true)
        # iterate through the list of followers and update the separate dash data,
        # and change their graphic if they are "visible"
        $game_player.followers.each do |follower|
          follower.changeToDashGraphic = false
          follower.playerDashGraphicInUse = false
          if (follower.visible?)
            # make sure follower outfit aligns with the one in the associated
            # actor (if there is one)
            follower.refreshCharacterOutfitByActor
            
            followerWalkingGraphic = LCM.getlcmDatasetData(follower.lcmMovementOutfit, :normalWalkingGraphic)
            follower.set_graphic(followerWalkingGraphic, 0)
          end
        end
      end
      
    end
    
    # now set the exSaveData value
    $game_party.setExSaveData("lcmSeparateDashingToggle", trueOrFalse)
  end
  
  #--------------------------------------------------------------------------
  # * Wrapper method to clean up the script call to change the use outfit walk
  # * speed toggle.
  # * Call this in map events with "$game_map.changelcmUseOutfitWalkSpeedToggle(trueOrFalse)"
  #--------------------------------------------------------------------------
  def changelcmUseOutfitWalkSpeedToggle(trueOrFalse)
    $game_party.setExSaveData("lcmUseOutfitWalkSpeedToggle", trueOrFalse)
    
    # also refresh outfit for the player to reflect the new walk speed and/or
    # frequency speed if the toggle was turned on
    if (trueOrFalse == true)
      # turn the outfit refresh flag to true
      $game_player.characterOutfitRefreshNeeded = true
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * New method to check if there is any event at a given set of coordinates
  # * that should be considered a "platform". Returns -1 if no platform is
  # * found, and otherwise, returns the "terrain tag" that the event platform
  # * should be considered as for the purposes of choosing sounds,
  # * animations, etc.
  # *
  # * To access this method, use the script call "$game_map.getEventPlatTerrainTagEquiv(x, y)" 
  #--------------------------------------------------------------------------
  def getEventPlatTerrainTagEquiv(x, y)
    eventsAtLoc = events_xy(x, y) # get array of events at the location
    
    # check if any event has a platform event
    platEventFound = false # start false, must prove true
    # the terrain tag equivalent for the platform. starts at -1 to represent
    # no platform event being found. used to decide what sounds/animation
    # to use when falling on the event
    terrainTagEquivResult = -1
    eventsAtLoc.each do |locEvent|
      # get relevant event data
      eventPlatformToggle = locEvent.platformToggle # platform toggle status
      eventTerrainTagEquiv = locEvent.terrainTagEquiv # terrain tag equivalent
      
      # if the platform toggle is on, and there is a eventTerrainTag
      # equivalent (not -1), then set the result to the eventTerrainTag equivalent
      if ((eventPlatformToggle == true) && (eventTerrainTagEquiv != -1))
        terrainTagEquivResult = eventTerrainTagEquiv
        # can return the result terrainTagEquivResult early because only
        # one is used anyway
        return (terrainTagEquivResult)
      else
        terrainTagEquivResult = -1
      end
    end
    
    # return the result terrainTagEquiv
    return (terrainTagEquivResult)
    
  end
  
  #--------------------------------------------------------------------------
  # * New method to check if there is any event at a given set of coordinates
  # * that should turn off lcm movement while in "range" of that event.
  # * Returns true if any such event is found, otherwise, false.
  # *
  # * To access this method, use the script call "$game_map.checklcmScriptOffTag(x, y)" 
  #--------------------------------------------------------------------------
  def checklcmScriptOffTag(x, y)
    eventsAtLoc = events_xy(x, y) # get array of events at the location
    
    # check if any event should turn off lcm movement
    lcmOffEventFound = false # start false, must prove true
    eventsAtLoc.each do |locEvent|
      # if no event has been found yet, check the current event
      if (!lcmOffEventFound)
        # get relevant event data
        eventlcmOffToggle = locEvent.lcmOffEvent # event lcm movement off toggle setting
        
        # the the event has the offToggle on, set lcmOffEventFound to true
        if (eventlcmOffToggle == true)
          lcmOffEventFound = true
        end
      end
      
    end
    
    # return whether or not an lcmOff event was found
    return (lcmOffEventFound)
  end
  
  #--------------------------------------------------------------------------
  # * New method that is basically a copy of terrain_tag() but this one
  # * goes through all terrain tags to check if any are platform tags,
  # * and if one is, returns that instead of the first tag it finds.
  #--------------------------------------------------------------------------
  def terrainTagPlatformCheck(x, y)
    # return 0 if the coordinates are not valid
    return 0 unless valid?(x, y)
    
    # the first platform tag that is found (unless none are found)
    firstTagFound = 0
    
    # go through the layered tiles and return the first platform tag found
    layered_tiles(x, y).each do |tile_id|
      tag = tileset.flags[tile_id] >> 12
      # if the tag is not equal to 0 and the firstTag has not been found yet,
      # then update firstTagFound to the new tag value.
      # This will mean that if no platform terrain tags are ever found, the
      # first non-platform terraiin tag will be returned
      if (tag != 0 && firstTagFound == 0)
        firstTagFound = tag
      end
     
      # if the tag being checked is a platform tag, immediately return it,
      # otherwise keep looping
      if (LCM::LCM_PLATFORM_TAGS.include?(tag))
        return tag
      end
    end
    
    # return whatever the first non-platform tag found was (or 0 if none found)
    return firstTagFound
  end
  
  #--------------------------------------------------------------------------
  # * New method to check if a tile has any rope terrain tags in its
  # * layered tiles. If it does, returns true, otherwise, false.
  #--------------------------------------------------------------------------
  def ropesTerrainTagCheck(x, y)
    # return 0 if the coordinates are not valid
    return 0 unless valid?(x, y)
    
    # go through the layered tiles and return true if a rope terrain tag found
    layered_tiles(x, y).each do |tile_id|
      tag = tileset.flags[tile_id] >> 12
      # if the tag is the ropes terrain tag, return true
      if (tag == LCM::LCM_ROPE_TERRAIN_TAG)
        return true
      end
      
    end
    
    # If no rope terrain tag was found, false is returned
    return false
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if a tile should have the lcm script if
  # * it a horizontal-based ropes tile (so that going to a horizontal rope
  # * type from a ledge won't cause a fall).
  #--------------------------------------------------------------------------
  def sidewaysRopeAutolcmDisable(character, ropeType)
    # get tile x and y
    tileX = character.x
    tileY = character.y
    # get character direction
    charDirection = character.direction
    
    # check if a ropes terrain tag is found at the tile the character is on
    ropesTerrainTagFound = $game_map.ropesTerrainTagCheck(tileX, tileY)
    # check if the character's direction is left or right (4 or 6)
    charDirectionHoriz = (charDirection == 4 || charDirection == 6)
    # check if the tile has passability for the direction
    directionPassSuccess = passable?(tileX, tileY, charDirection)
    
    # check if the character can climb the given rope
    characterCanClimbRope = character.checkCharRopesAbility(ropeType)
    
    # starts false, gets marked true if:
    # the direction of the character is left or right
    # and the tile being traveled to is a rope
    # and the tile being traveled to has the appropriate passability
    # and the character can actually climb the rope in question
    activateAutolcmDisable = false
    if (ropesTerrainTagFound == true && charDirectionHoriz == true &&  directionPassSuccess == true && characterCanClimbRope == true)
      # all conditions met, so set activateAutolcmDisable to true
      activateAutolcmDisable = true
    end
    
    # return activateAutolcmDisable implicitly
    activateAutolcmDisable
  end
  
end


class Game_Interpreter
  #--------------------------------------------------------------------------
  # * New method to change the toggle value of a platform event.
  # * Meant for use with script call "toggleEvPlat(trueOrFalse)" in a map event
  # * to change the toggle of the event the call is placed in, or
  # * with call "toggleEvPlat(trueOrFalse, eventID)" to change the toggle
  # * of the event of a different event than the on in which the call is placed.
  #--------------------------------------------------------------------------
  def toggleEvPlat(trueOrFalse, eventID = @event_id)
    # set the event's platformToggle to the specified value
    #
    # note: @event_id is a parameter for Game_Interpreter
    $game_map.events[eventID].toggleEvPlat(trueOrFalse)
  end
  
  #--------------------------------------------------------------------------
  # * New method to change the outfit for an for an event with lcm movement.
  # * Meant for use with script call "changeCharacterOutfit("newOutfitName")"
  # * in a map event to change the toggle of the event the call is placed in,
  # * or with call "changeCharacterOutfit("newOutfitName", eventID)" to change
  # * the toggle of the event of a different event than the on in which the
  # * call is placed.
  #--------------------------------------------------------------------------
  def changeCharacterOutfit(newOutfitName, eventID = @event_id)
    eventToChangeOutfit = $game_map.events[eventID]
    eventToChangeOutfit.lcmMovementOutfit = newOutfitName # set lcmMovementOutfit to the newOutfitName
  
    # refresh the outfit as well
    @characterOutfitRefreshNeeded = true
  end
  
end


class Game_Actor < Game_Battler
  # Variable that stores the lcmOutfit associated with an actor.
  # Note: Variables in Game_Actor are stored into save data, so the outfit
  # does not need to be stored into exSaveData.
  attr_accessor :currentlcmOutfit
  
  #--------------------------------------------------------------------------
  # * Aliased initialize() method for Game_Actor used to initialize
  # * the currentlcmOutfit variable.
  #--------------------------------------------------------------------------
  alias before_lcm_actor_new_data_init initialize
  def initialize(actor_id)
    # call original method
    before_lcm_actor_new_data_init(actor_id)
    
    # start by setting trying to set the outfit to the default outfit associated
    # with the actor ID.
    @currentlcmOutfit = LCM::LCM_DEFAULT_ACTOR_OUTFIT_NAMES[actor_id]
    # if the current outfit doesn't exist because the follower object does
    # not yet have an associated actor, then set the currentlcmOutfit to
    # default for actors with unspecified outfits
    if (@currentlcmOutfit == nil)
      @currentlcmOutfit = LCM::LCM_GENERAL_DEFAULT_OUTFIT_NAME 
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to change the outfit for the associated player or
  # * follower object for the actor, and also stores the new outfit in
  # * the player data.
  # * Use "$game_actors[actorID].changeActorlcmOutfit("newOutfitName")" as
  # * a script line in a map event to call this method.
  #--------------------------------------------------------------------------
  def changeActorlcmOutfit(newOutfitName)
    actorID = @actor_id # get the actor ID for the current actor
    gamePlayerActorID = $game_player.lcmGetPlayerActorID # get the actor ID for the player
    # get whether or not follower lcm movement is enabled for followers
    areFollowersEnabled = $game_party.getExSaveData("lcmFollowerToggle", LCM::LCM_FOLLOWERS_ENABLED)
    
    # the actor's actorID matches of to the player's, then change the player's
    # outfit
    if (actorID == gamePlayerActorID)
      $game_player.changeCharacterOutfit(newOutfitName)
    # if followers are enabled, check if the actor's actorID matches any of the followers.
    # If it does match any of the followers, change the outfit for that follower
    elsif (areFollowersEnabled == true)
      # iterate through the list of followers, check for matching IDs, and if
      # any match, change their outfit
      $game_player.followers.each do |follower|
        followerID = follower.getFollowerActorID
        # if the IDs match, change the follower's outfit to the new one
        if (actorID == followerID)
          follower.changeCharacterOutfit(newOutfitName)
        end
      end
    end
    
    # change actor-stored outfit name
    @currentlcmOutfit = newOutfitName
    
  end
  
  #--------------------------------------------------------------------------
  # * New method used to serve as a script call to get an actor's current
  # * outfit name for conditional branches.
  # * Call with "$game_player.getPlayerlcmOutfit"
  #--------------------------------------------------------------------------
  def getActorlcmOutfit
    # implicit return of the currentlcmOutfit variable
    @currentlcmOutfit
  end
  
end


class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Aliased command_formation() method used to mark the player and
  # * their follower's (if enabled) outfits as needing a refresh.
  #--------------------------------------------------------------------------
  alias after_lcm_formation_outfit_refresh command_formation
  def command_formation
    # mark outfits as needing refresh for the player (and followers to, if
    # they are enabled)
    $game_player.doFullOutfitRefresh
    
    # call the original method
    after_lcm_formation_outfit_refresh
  end
end


# This Game_CharacterBase segment stores new methods related to different
# kinds of follower checks.
# It is kept separate from the rest just so to prevent confusion, as the
# contained methods are mostly copies of check methods elsewhere but with
# slight modifications.
class Game_CharacterBase
  #--------------------------------------------------------------------------
  # * New method used to check if a follower as a platform in the jumping
  # * range above them, which is used in basic pathfinding. Returns
  # * true if a platform can be reached, otherwise, false.
  #--------------------------------------------------------------------------
  def followerUpLedgeCheck
    d = 8 # direction to check is 8, 8=up
    
    origX = $game_map.round_x_with_direction(@x, d) # store original x
    # store original y, +1 to account for the position of the event being
    # ontop of potential ledges to jump on
    origY = $game_map.round_y_with_direction((@y + 1), d)
    
    tileNum = 0 # number of tiles searched
    platformFound = false # whether or not a platform has been found
    activeTerrainTag = 0 # 0 as default, decides what animations/sounds to use when hit ground
    # the x position should just stay the same as the original
    xPos = origX
    # y val to check first should be the origY
    yPos = origY
    # get the jump up height associated with the active outfit
    jumpUpHeight = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpUpHeight)
    # get whether or not platform events are enabled from exSaveData
    platformEventsEnabled = $game_party.getExSaveData("lcmPlatformEventsToggle", LCM::LCM_PLATFORM_EVENTS_ENABLED)
    # if trying to go upwards, check all tiles in the jump range until
    # a platform-tagged tile is found
    while ((tileNum < jumpUpHeight) && !platformFound)
      terrainTag = $game_map.terrainTagPlatformCheck(xPos, yPos) # get map tile terrain tag
      eventTerrainTag = -1 # set eventTerrainTag to -1 by default unless platform events have been enabled
      if (platformEventsEnabled == true)
        eventTerrainTag = $game_map.getEventPlatTerrainTagEquiv(xPos, yPos) # get event terrain tag equivalent
      end
      # if the list of platform terrain tags includes the terrain tag
      # currently being checked, if it does, mark the platform as found
      if (LCM::LCM_PLATFORM_TAGS.include?(terrainTag))
        platformFound = true
        activeTerrainTag = terrainTag
      # get the equivalent terrain tag for any event designated as a platform
      # with the [PLT #] notetag in its name. Will be -1 if no "platform"
      # events were found at the location.
      # if the equivalent terrain tag is not equal to -1, then
      elsif (eventTerrainTag != -1)
        platformFound = true
        # also set the activeTerrainTag to the event version, it takes priority
        # for deciding what sounds/animations to use
        activeTerrainTag = eventTerrainTag
      end
      
      # if the platform is not found, increment tile position upwards
      if (!platformFound)
        # increment the tile number by one
        tileNum += 1
        # decrease yPos by 1 to go up 1 in the tile search
        yPos -= 1
      end
    end
    
    # return if a platform was found or not
    return platformFound
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if a follower as a platform in the jumping
  # * range below them, which is used in basic pathfinding. Returns
  # * true if a platform can be reached, otherwise, false.
  #--------------------------------------------------------------------------
  def followerDownLedgeCheck
    d = 2 # direction to check is 2, 2=down
    
    origX = $game_map.round_x_with_direction(@x, d) # store original x
    # store original y, +2 to account for the position of the event being
    # ontop of the ledge you are currently on, meaning the first available
    # ledge to jump on is two below the event (y increases going downwards)
    origY = $game_map.round_y_with_direction((@y + 1), d)
    
    tileNum = 0 # number of tiles searched
    platformFound = false # whether or not a platform has been found
    activeTerrainTag = 0 # 0 as default, decides what animations/sounds to use when hit ground
    # the x position should just stay the same as the original
    xPos = origX
    # y val to check first should be the origY
    yPos = origY
    # get the jump up height associated with the active outfit
    jumpDownHeight = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalJumpDownHeight)
    # get whehter or not platform events are enabled from exSaveData
    platformEventsEnabled = $game_party.getExSaveData("lcmPlatformEventsToggle", LCM::LCM_PLATFORM_EVENTS_ENABLED)
    # if trying to go upwards, check all tiles in the jump range until
    # a platform-tagged tile is found
    while ((tileNum < jumpDownHeight) && !platformFound)
      terrainTag = $game_map.terrainTagPlatformCheck(xPos, yPos) # get map tile terrain tag
      eventTerrainTag = -1 # set eventTerrainTag to -1 by default unless platform events have been enabled
      if (platformEventsEnabled == true)
        eventTerrainTag = $game_map.getEventPlatTerrainTagEquiv(xPos, yPos) # get event terrain tag equivalent
      end
      # if the list of platform terrain tags includes the terrain tag
      # currently being checked, if it does, mark the platform as found
      if (LCM::LCM_PLATFORM_TAGS.include?(terrainTag))
        platformFound = true
        activeTerrainTag = terrainTag
      # get the equivalent terrain tag for any event designated as a platform
      # with the [PLT #] notetag in its name. Will be -1 if no "platform"
      # events were found at the location.
      # if the equivalent terrain tag is not equal to -1, then
      elsif (eventTerrainTag != -1)
        platformFound = true
        # also set the activeTerrainTag to the event version, it takes priority
        # for deciding what sounds/animations to use
        activeTerrainTag = eventTerrainTag
      end
      
      # if the platform is not found, increment tile position upwards
      if (!platformFound)
        # increment the tile number by one
        tileNum += 1
        # increase yPos by 1 to go down 1 in the tile search
        yPos += 1
      end
    end
    
    # return if a platform was found or not
    return platformFound
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if a follower would fall off the map if they
  # * made a move in the direction they are trying to move.
  # * Returns true if a game over would occur, otherwise, false.
  #--------------------------------------------------------------------------
  def followerGameOverChecks(direction)
    # note: direction will either be 4 for left, or 6 for right
    
    origX = @x #$game_map.round_x_with_direction(@x, direction) # store original x
    # store original y
    origY = $game_map.round_y_with_direction(@y, direction)
    
    # get the active outfit's dash enable status (if dash jump distance >0, then it is enabled)
    dashJumpEnabled = (LCM.getlcmDatasetData(@lcmMovementOutfit, :dashJumpDistance) > 0)
    # get the active outfit's side jump enable status (if side jump distance >0, then it is enabled)
    sideJumpEnabled = (LCM.getlcmDatasetData(@lcmMovementOutfit, :sideJumpDistance) > 0)
    
    # get whether or not platform events are enabled from exSaveData
    platformEventsEnabled = $game_party.getExSaveData("lcmPlatformEventsToggle", LCM::LCM_PLATFORM_EVENTS_ENABLED)
    
    # where you would go upon moving
    prospectiveX = (direction == 4)? (origX - 1) : (origX + 1)
    # get the terrain tag of the last tile the player was on
    # (origY + 1 to check the tile BELOW the player's feet)
    newTerrainTag = $game_map.terrainTagPlatformCheck(prospectiveX, (origY + 1))
    newEventTerrainTag = -1 # set lastEventTerrainTag to -1 by default unless platform events have been enabled
    if (platformEventsEnabled == true)
      # get the event terrain tag of the last tile the player was on
      # -1 if the last tile did not have a "platform" event
      newEventTerrainTag = $game_map.getEventPlatTerrainTagEquiv(prospectiveX, (origY + 1))
    end
    
    # return false early if the place that would be moved to is a platform
    if ( (LCM::LCM_PLATFORM_TAGS.include?(newTerrainTag)) || (LCM::LCM_PLATFORM_TAGS.include?(newEventTerrainTag)) )
      return false
    end
    
    # currentTile's X is origX + 1 if moving left, origX - 1 if moving right
    currentTileX = (direction == 4)? (origX + 2) : (origX - 2)
        
    # if any side jumps are enabled and it was not a forcedCheck, do side jump checks.
    if ((sideJumpEnabled == true) || (dashJumpEnabled == true))
      # sideJumpChecks runs the sideJump if the checks are met, and returns
      # 'true' if some form of sideJump was run.
      sideJumpWouldRun = followerSideJumpChecks(direction)
      
      # if a sideJumpWasRun, then return immediately (since any falls have already
      # been done)
      if (sideJumpWouldRun)
        return false
      end
    end
    
    # if the previous two checks ("last tile was platform?" and "current tile is not platform?")
    # were met, and no side jump was run, then the player should fall down
    
    # check all tiles going downwards from the player until a platform is found,
    # OR the spot three tiles under the map is reached (when the player is sure
    # to be off the map screen)
    offMapEndPos = $game_map.height + 3 # three tiles below the map border, where player will not be seen
    tileNum = 0 # number of tiles searched
    platformFound = false # whether or not a platform has been found
    activeTerrainTag = 0 # 0 as default, decides what animations/sounds to use when hit ground
    # the x position be the new currentTileX
    xPos = prospectiveX
    # y val to check first should be the origY + 1 to start at the tile below
    # the player's feet
    yPos = origY + 1
    while ((yPos < offMapEndPos) && !platformFound)
      terrainTag = $game_map.terrainTagPlatformCheck(xPos, yPos) # get map tile terrain tag
      eventTerrainTag = -1 # set eventTerrainTag to -1 by default unless platform events have been enabled
      if (platformEventsEnabled == true)
        eventTerrainTag = $game_map.getEventPlatTerrainTagEquiv(xPos, yPos) # get event terrain tag equivalent
      end
      # if the list of platform terrain tags includes the terrain tag
      # currently being checked, if it does, mark the platform as found
      if (LCM::LCM_PLATFORM_TAGS.include?(terrainTag))
        platformFound = true
        activeTerrainTag = terrainTag
      # get the equivalent terrain tag for any event designated as a platform
      # with the [PLT #] notetag in its name. Will be -1 if no "platform"
      # events were found at the location.
      # if the equivalent terrain tag is not equal to -1, then
      elsif (eventTerrainTag != -1)
        platformFound = true
        # also set the activeTerrainTag to the event version, it takes priority
        # for deciding what sounds/animations to use
        activeTerrainTag = eventTerrainTag
      end
      
      # if the platform is not found, increment tile position upwards
      if (!platformFound)
        # increment the tile number by one
        tileNum += 1
        # increase yPos by 1 to go down 1 in the tile search
        yPos += 1
      end
    end
    
    destY = yPos - 1 # get the final destination y value
    
    # calculate the total fall height (tile amount between the tile
    # the player "event" is on (not the one below their feet) and the platform they
    # are landing on, or at least the location they are falling to)
    fallHeight = (destY - origY).abs
    
    # store whether or not the mapEnd was reached (it was if no platform was found)
    mapEndReached = !platformFound
    
    # if mapEndReached, return true because the fall would result in a game over,
    # otherwise, return false
    # (momentum falls aren't counted...)
    if (mapEndReached == true)
      return true
    else
      return false
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if a follower would be able to perform a
  # * regular side jump or a dash jump instead of falling off the map.
  # * Returns true if a possible side or dash jump is found, otherwise
  # * returns false.
  #--------------------------------------------------------------------------
  def followerSideJumpChecks(direction)
    # note: direction will either be 4 for left, or 6 for right
    
    origX = $game_map.round_x_with_direction(@x, direction) # store original x
    origY = $game_map.round_y_with_direction(@y, direction) # store original y
    
    # origX diff. bc @x not updated (character did not move)
    origX = (direction == 4)? (origX - 1) : (origX + 1)
    
    # currentTile's X is origX + 1 if moving left, origX - 1 if moving right
    # (x increases going right)
    currentTileX = (direction == 4)? (origX + 1) : (origX - 1)
    
    # check all tiles going left or right from the player until a platform is found,
    # OR the spot three tiles under the map is reached (when the player is sure
    # to be off the map screen)
    tileNum = 0 # number of tiles searched
    platformFound = false # whether or not a platform has been found
    activeTerrainTag = 0 # 0 as default, decides what animations/sounds to use when hit ground
    # the x position be the new currentTileX
    xPos = currentTileX
    # y val to check first should be the origY + 1 to start at the tile below
    # the player's feet
    yPos = origY + 1
    
    # get whether or not platform events are enabled from exSaveData
    platformEventsEnabled = $game_party.getExSaveData("lcmPlatformEventsToggle", LCM::LCM_PLATFORM_EVENTS_ENABLED)
    
    # get the active outfit's dash jump distance
    dashJumpDistance = LCM.getlcmDatasetData(@lcmMovementOutfit, :dashJumpDistance)
    # get the active outfit's side jump distance
    sideJumpDistance = LCM.getlcmDatasetData(@lcmMovementOutfit, :sideJumpDistance)
    
    # use dash jump as max if available (dist>0), otherwise reg sideJump
    sideJumpMaxDist = (dashJumpDistance > 0)? (dashJumpDistance + 1) : (sideJumpDistance + 1)
    while ((tileNum < sideJumpMaxDist) && !platformFound)
      terrainTag = $game_map.terrainTagPlatformCheck(xPos, yPos) # get map tile terrain tag
      eventTerrainTag = -1 # set eventTerrainTag to -1 by default unless platform events have been enabled
      if (platformEventsEnabled == true)
        eventTerrainTag = $game_map.getEventPlatTerrainTagEquiv(xPos, yPos) # get event terrain tag equivalent
      end
      # if the list of platform terrain tags includes the terrain tag
      # currently being checked, if it does, mark the platform as found
      if (LCM::LCM_PLATFORM_TAGS.include?(terrainTag))
        # return true because sideJump would run
        return true
      # get the equivalent terrain tag for any event designated as a platform
      # with the [PLT #] notetag in its name. Will be -1 if no "platform"
      # events were found at the location.
      # if the equivalent terrain tag is not equal to -1, then
      elsif (eventTerrainTag != -1)
        # return true immediately because sideJump would run
        return true
      end
    
      # if the platform is not found, increment tile position left/right
      if (!platformFound)
        # increment the tile number by one
        tileNum += 1
        # add -1 to xPos if moving left [4-left] or +1 if moving right
        # (x increases going right)
        xPos = (direction == 4)? (xPos - 1) : (xPos + 1)
      end
    end
    
    # return false if no side jumpable platform found
    return false
  end
  
end


# This Game_CharacterBase segment stores new methods related to dashing
# It is stored separately to prevent confusion and keep everything self-contained.
class Game_Character < Game_CharacterBase
  # Variable used as a flag to decide when to change graphics from
  # walking to dashing, or dashing to walking, etc.
  attr_accessor :changeToDashGraphic
  
  # Variable used to store whether or not the dash graphic is (or should be)
  # in use for the palyer.
  attr_accessor :playerDashGraphicInUse
  
  # Variable used to check if a character is currently being considered
  # as using a rope (in "ropes mode").
  attr_accessor :characterUsingRopes
  
  #--------------------------------------------------------------------------
  # * Aliased init_public_members method used to initialize the new
  # * characterUsingRopes boolean variable
  #--------------------------------------------------------------------------
  alias before_init_rope_var init_public_members
  def init_public_members
    before_init_rope_var # Call original method
    @characterUsingRopes = false # start with the character as not using ropes
  end

  #--------------------------------------------------------------------------
  # * Aliased update_animation() method for the Game_Character class used to
  # * change a character's graphic to their walking or dashing graphic as needed.
  #--------------------------------------------------------------------------
	alias before_lcm_dash_change_graphic_checks update_animation
	def update_animation
    # get whether or not separate graphic dashing is enabled
    dashingEnabled = $game_party.getExSaveData("lcmSeparateDashingToggle", LCM::LCM_USE_SEPARATE_DASH_GRAPHICS)
    # if dashing is enabled, advance further into the graphic checks
    if (dashingEnabled == true)
      # if the character is not an event, advance further into the graphic checks
      if (!self.kind_of?(Game_Event))
        
        specialDashChecksPassed = true # start with the flag as true, prove false
        if (specialDashChecksPassed == true)
          # the first requirement to advance is that no lcm movement can be occurring
          specialDashChecksPassed = !@lcmStayImmobile
        end
        # do not change graphics if currently on a rope
        if (specialDashChecksPassed == true)
          specialDashChecksPassed = !@characterUsingRopes
        end
        # for followers to be checked, followers must be enabled, and the
        # specific follower must be visible.
        if ((specialDashChecksPassed == true) && (self.kind_of?(Game_Follower)))
          # get whether or not follower lcm movement is enabled for followers
          areFollowersEnabled = $game_party.getExSaveData("lcmFollowerToggle", LCM::LCM_FOLLOWERS_ENABLED)
          specialDashChecksPassed = (areFollowersEnabled && self.visible?)
        end
        
        # if the preliminary checks were met to consider changing the graphics,
        # then 
        if (specialDashChecksPassed == true)
          # initialize changeToDashGraphic to true and playerDashGraphicInUse to false
          # and lcmDashRefreshNeeded if needed
          @changeToDashGraphic = true if (@changeToDashGraphic == nil)
          @playerDashGraphicInUse = false if (@playerDashGraphicInUse == nil)
          @lcmDashRefreshNeeded = false if (@lcmDashRefreshNeeded == nil)
          
          # to be considered as dashing, either the player must be actively
          # dashing and moving, or the character must be a follower and the
          # dash graphic should be in use
          dashReqs = true
          if (dashReqs == true)
            dashReqs = (dash? && $game_player.moving?) || (self.kind_of?(Game_Follower) && ($game_player.playerDashGraphicInUse == true))
          end
          
          # if dash requirements are met, potentially change the character
          # graphic to the dash graphic
          if (dashReqs == true)
            # if the dash graphic needs to be changed to, do it
            if (@changeToDashGraphic == true)
              # make sure character outfit aligns with the one in the associated
              # actor (if there is one)
              refreshCharacterOutfitByActor
              
              # get the character's dashing graphic
              dashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalDashingGraphic)
              
              # set the dashing graphic and update the flags appropriately
              set_graphic(dashingGraphic, 0)
              @changeToDashGraphic = false
              if (self.kind_of?(Game_Player))
                @playerDashGraphicInUse = true
              end
            # if a dash refresh is needed the the character outfit is not the
            # dashing outfit, then set the graphic to the dash graphic
            elsif (@lcmDashRefreshNeeded == true)
              # get the character's dashing graphic
              dashingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalDashingGraphic)
              # if the character's graphic filename is not dashing, set it to dashing
              if (@character_name != dashingGraphic)
                # set the dashing graphic and update the flags appropriately
                set_graphic(dashingGraphic, 0)
                @changeToDashGraphic = false
                if (self.kind_of?(Game_Player))
                  @playerDashGraphicInUse = true
                end
                @lcmDashRefreshNeeded = false
              end
            end
              
          # if dash requirements are not meant, and the changeToDashGraphic
          # is false, then potentially update the character's graphic to
          # the walking graphic
          elsif (@changeToDashGraphic == false)
            changeWalkGraphicChecks = true
            if (changeWalkGraphicChecks == true && (self.kind_of?(Game_Follower)))
              changeWalkGraphicChecks = !$game_player.playerDashGraphicInUse
            end
            
            if (changeWalkGraphicChecks == true)
              # make sure character outfit aligns with the one in the associated
              # actor (if there is one)
              refreshCharacterOutfitByActor
              
              # get the walking graphic and update the flags appropriately
              walkingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
              # set the walking graphic and update the flags appropriately
              set_graphic(walkingGraphic, 0)
              @changeToDashGraphic = true
              if (self.kind_of?(Game_Player))
                @playerDashGraphicInUse = false
              end
            end
          # if a dash refresh is needed the the character outfit is not the
          # walking outfit, then set the graphic to the walking graphic
          elsif (@lcmDashRefreshNeeded == true && @move_route_forcing == false && @lcmMovementOutfit != nil && @lcmMovementOutfit != "none")
            # get the walking graphic and update the flags appropriately
            walkingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
            # if the character's graphic filename is not dashing, set it to dashing
            if (@character_name != walkingGraphic)
              # set the walking graphic and update the flags appropriately
              set_graphic(walkingGraphic, 0)
              @changeToDashGraphic = true
              if (self.kind_of?(Game_Player))
                @playerDashGraphicInUse = false
              end
            end
            @lcmDashRefreshNeeded = false
            
          end# end of walking/dashing checks

        end # end of the requirements for trying to change the graphic at all
        
      end
    end # end of all dashing graphic checks/changes
		
		# call original method
		before_lcm_dash_change_graphic_checks
	end
  
  #--------------------------------------------------------------------------
  # * New method used to activate a dash refresh for use in methods outside
  # * the Game_Character class.
  #--------------------------------------------------------------------------
  def activateDashRefresh
    @lcmDashRefreshNeeded = true # update the flag to true
  end
  
  #--------------------------------------------------------------------------
  # * New method check if the character is in "ropes mode" (currently climbing
  # * some form of rope).
  #--------------------------------------------------------------------------
  def inRopesMode?
    # return the characterUsingRopes var implicitly
    @characterUsingRopes
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update the player's
  # * graphic and walkspeed. If the player is in ropes mode, it
  # * changes their graphic and movement speed to the appropriate ropes
  # * graphic according to the rope type and outfit. If they are not in ropes
  # * mode, then it changes their graphic and movement speed to their normal
  # * walking graphic and normal speed.
  #--------------------------------------------------------------------------
  def performPlayerRopesUpdate(ropeType)
    # Note:
    # Index zero of a rope's data is the graphic, and index 1 is the
    # movement speed
    
    # if char in ropes mode, change the char to ropes graphic/speed,
    # otherwise, change the char to normal graphic/speed
    if (inRopesMode?)
      # disable menu access
      $game_system.menu_disabled = true
      # disable dashing
      $game_map.changelcmGlobalDashDisableToggle(true)
      
      # get the current outfit's ropes data (all types)
      charRopeData = LCM.getlcmDatasetData(@lcmMovementOutfit, :ropesDataList)
      # get the data for the current type of rope
      currentRopeData = charRopeData[ropeType]
      # get the climbing graphic for the rope type
      ropeClimbingGraphic = currentRopeData[0]
      # get the movement speed for the rope type
      ropeMoveSpeed = currentRopeData[1]
      
      # If the character is facing up (direction 2) or down (dir 8) 
      # then perform the graphic and speed change instantly
      # Otherwise, use a move route force instead so the character finishes
      # moving to the next tile before the changes occur
      if (@direction == 2 || @direction == 8)
        # update the character's current graphic to the ropes one
        # (0 in position 0 in the spritesheet)
        set_graphic(ropeClimbingGraphic, 0)
        # update the character's current movement speed to the ropes one
        @move_speed = ropeMoveSpeed
      else
        # create new move route to execute AFTER the other one (it is set to
        # wait for completion to change the graphic back to normal) and set up the settings
        ropeMoveRoute = RPG::MoveRoute.new
        ropeMoveRoute.repeat = false
        ropeMoveRoute.skippable = false
        ropeMoveRoute.wait = false
        
        # create move command for the resetMoveRoute
        ropeMovement = RPG::MoveCommand.new
        
        # route end movement command (code 0)
        ropeMovement.code = 0
        ropeMovement.parameters = []
        ropeMoveRoute.list.insert(0, ropeMovement.clone)
        
        # create script movement command to change player speed back to the normal one
        ropeMovement.code = 29 # 29 is for the "Change Speed" command
        # change spped back to normal
        ropeMovement.parameters = [ropeMoveSpeed]
        # add the change speed movement command
        ropeMoveRoute.list.insert(0, ropeMovement.clone)
        
        # create script movement command to change player graphic back to the normal one
        ropeMovement.code = 41 # 41 is for the "Change Graphic" command
        # change player graphic to the normal graphic at position 0
        ropeMovement.parameters = [ropeClimbingGraphic, 0]
        # add the change graphic movement command
        ropeMoveRoute.list.insert(0, ropeMovement.clone)
        
        # force the move route
        force_move_route(ropeMoveRoute)
      end
      
    else
      # get the current outfit's normal walking graphic
      normalWalkingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
      # get the current outfit's normal movement speed
      normalMoveSpeed = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkSpeed)
      
      # If the character is facing left (direction 4) or right (dir 6) 
      # then perform the graphic and speed change instantly
      # Otherwise, use a move route force instead so the character finishes
      # moving to the next tile before the changes occur
      if (@direction == 4 || @direction == 6)
        # update the character's current graphic to the normal walking one
        # (0 in position 0 in the spritesheet)
        set_graphic(normalWalkingGraphic, 0)
        # update the character's current movement speed to the normal outfit speed
        @move_speed = normalMoveSpeed
      else
        
        # create new move route to execute AFTER the other one (it is set to
        # wait for completion to change the graphic back to normal) and set up the settings
        resetMoveRoute = RPG::MoveRoute.new
        resetMoveRoute.repeat = false
        resetMoveRoute.skippable = false
        resetMoveRoute.wait = false
        
        # create move command for the resetMoveRoute
        resetMovement = RPG::MoveCommand.new
        
        # route end movement command (code 0)
        resetMovement.code = 0
        resetMovement.parameters = []
        resetMoveRoute.list.insert(0, resetMovement.clone)
        
        # create script movement command to change player speed back to the normal one
        resetMovement.code = 29 # 29 is for the "Change Speed" command
        # change spped back to normal
        resetMovement.parameters = [normalMoveSpeed]
        # add the change speed movement command
        resetMoveRoute.list.insert(0, resetMovement.clone)
        
        # create script movement command to change player graphic back to the normal one
        resetMovement.code = 41 # 41 is for the "Change Graphic" command
        # change player graphic to the normal graphic at position 0
        resetMovement.parameters = [normalWalkingGraphic, 0]
        # add the change graphic movement command
        resetMoveRoute.list.insert(0, resetMovement.clone)
        
        # force the move route
        force_move_route(resetMoveRoute)
      end
      
      # enable menu access
      $game_system.menu_disabled = false
      # re-enable dashing if the global dash disable toggle isn't set to off
      # by default
      if (LCM::LCM_GLOBAL_DASH_DISABLE == false)
        $game_map.changelcmGlobalDashDisableToggle(false)
      end
      
    end  
      
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update a follower's
  # * graphic and walkspeed. If the follower is in ropes mode, it
  # * changes their graphic and movement speed to the appropriate ropes
  # * graphic according to the rope type and outfit. If they are not in ropes
  # * mode, then it changes their graphic and movement speed to their normal
  # * walking graphic and normal speed. Note that with the follower version
  # * of the rope updates, graphic/speed changes are all instant because
  # * otherwise followers tend to sometimes not change their graphic
  # * when entering or exiting a rope.
  #--------------------------------------------------------------------------
  def performFollowerRopesUpdate(ropeType)
    # Note:
    # Index zero of a rope's data is the graphic, and index 1 is the
    # movement speed
    
    # if char in ropes mode, change the char to ropes graphic/speed,
    # otherwise, change the char to normal graphic/speed
    if (inRopesMode?)
      # get the current outfit's ropes data (all types)
      charRopeData = LCM.getlcmDatasetData(@lcmMovementOutfit, :ropesDataList)
      # get the data for the current type of rope
      currentRopeData = charRopeData[ropeType]
      # get the climbing graphic for the rope type
      ropeClimbingGraphic = currentRopeData[0]
      # get the movement speed for the rope type
      ropeMoveSpeed = currentRopeData[1]
      
      # update the character's current graphic to the ropes one
      # (0 in position 0 in the spritesheet)
      set_graphic(ropeClimbingGraphic, 0)
      # update the character's current movement speed to the ropes one
      @move_speed = ropeMoveSpeed
      
    else
      # get the current outfit's normal walking graphic
      normalWalkingGraphic = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkingGraphic)
      # get the current outfit's normal movement speed
      normalMoveSpeed = LCM.getlcmDatasetData(@lcmMovementOutfit, :normalWalkSpeed)
      
      # update the character's current graphic to the normal walking one
      # (0 in position 0 in the spritesheet)
      set_graphic(normalWalkingGraphic, 0)
      # update the character's current movement speed to the normal outfit speed
      @move_speed = normalMoveSpeed
    end  
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if a character is able to clinb on a given
  # * type of rope or not. Returns true if they can, otherwise false.
  #--------------------------------------------------------------------------
  def checkCharRopesAbility(ropeType)
    # get the current outfit's ropes data (all types)
    charRopeData = LCM.getlcmDatasetData(@lcmMovementOutfit, :ropesDataList)
    
    # returns true if the given ropeType is present the the rope data list,
    # otherwise false
    return (charRopeData.has_key?(ropeType))
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if a character can pass through a given rope
  # * tile. They should be able to walk horizontally through them, but
  # * not climb up vertically in any way. Returns true if the character
  # * can move through the tile, otherwise false.
  #--------------------------------------------------------------------------
  def checkCharRopesTilePassability(ropeType, currDirection)
    # start with the pass check boolean var as true, must prove false
    canCharPassTile = true
    # get the x and y values of the new tile
    newX = $game_map.round_x_with_direction(self.x, currDirection)
    newY = $game_map.round_y_with_direction(self.y, currDirection)
    # check if the tile in question is a ropes tile
    ropesTerrainTagFound = $game_map.ropesTerrainTagCheck(newX, newY)
    
    # if the tile is not a ropes tile, do nothing,
    # otherwise, do further checks
    if (ropesTerrainTagFound == true)
      # if the character is not able to climb the type of rope
      # and the character is moving vertically (up or down, direction 2 or 8),
      # canCharPassTile will be set to false. Otherwise, it will remain true.
      if (checkCharRopesAbility(ropeType) == false && (currDirection == 2 || currDirection == 8))
        canCharPassTile = false
      end
    end
    
    # return the value of canCharPassTile implicitly
    canCharPassTile
  end
  
  #--------------------------------------------------------------------------
  # * New method used to determine if the initial result of passability should
  # * be changed because the character is attempting to leave a rope. Depending
  # * on the situation that could flip a tile from impassible to passible, or
  # * flip a tile from passible to impassible. Returns the correct passibility
  # * when all checks are done.
  #--------------------------------------------------------------------------
  def checkLeavingRopesPassability(initialPassability, newDirection)
    # get the x and y values of the tile the character is on before moving
    oldX = self.x
    oldY = self.y
    
    # get the x and y values of the tile the character is moving to
    newX = $game_map.round_x_with_direction(self.x, newDirection)
    newY = $game_map.round_y_with_direction(self.y, newDirection)
    
    # set the finalPassibility to the initial passability to start with
    finalPassability = initialPassability
    
    # check if the tile being moved to is not a rope, otherwise,
    # immediately return the original passability
    ropesTerrainTagFound = $game_map.ropesTerrainTagCheck(newX, newY)
    if (ropesTerrainTagFound == true)
      return finalPassability
    end
        
    # if the direction is up (8), force passabiility if the tile before
    # moving is a platform tile since you should be able to climb ontop of it
    if (newDirection == 8)
      # try to get the platform terrain tag of the tile the character
      # is on before movement
      terrainTag = $game_map.terrainTagPlatformCheck(oldX, oldY)
      # if the list of platform terrain tags includes the terrain tag
      # of the below tile, mark it as a platform
      currentTileIsPlatform = LCM::LCM_PLATFORM_TAGS.include?(terrainTag)
      
      # if the tile is a paltform, then change final passability to true
      if (currentTileIsPlatform)
        finalPassability = true
      end
      
    end
    
    # if the direction is left or right (4, 6), force impassibility if
    # there is not a platform under the new tile (if there was a ropes terrain
    # terrain tag on the new tile the function would have already returned earlier)
    if (newDirection == 4 || newDirection == 6)
      # get the y value for the tile under the new tile
      underNewTileY = newY + 1
      # try to get the platform terrain tag of the tile under the tile
      # the character is moving to
      terrainTag = $game_map.terrainTagPlatformCheck(newX, underNewTileY)
      # if the list of platform terrain tags includes the terrain tag
      # of the below tile, mark it as a platform
      newTileHasPlatformUnderIt = LCM::LCM_PLATFORM_TAGS.include?(terrainTag)
      
      # if the new tile does not have a platform under it, do not allow
      # moving to the tile
      if (!newTileHasPlatformUnderIt)
        finalPassability = false
      end
    end
    
    # return the finalPassibility implicitly
    finalPassability
  end
  
  #--------------------------------------------------------------------------
  # * New method used to determine if a tile being moved to should be forcefully
  # * marked as passable because it is a top rope tile. This method
  # * will only run when the character was not already climbing a rope,
  # * did not have passability before, and when they are moving downwards. 
  # * Returns true if the passability should be overriden, otherwise false.
  #--------------------------------------------------------------------------
  def aboveRopePassabilityOverride(ropeType)
    # get the x and y values of the new tile
    newX = self.x
    newY = self.y + 1 # +1 because going down a tile
    
    # check if the new tile has a rope on it
    ropesTerrainTagFound = $game_map.ropesTerrainTagCheck(newX, newY)
    # implicitly return true if the tile had a rope, otherwise, false
    ropesTerrainTagFound
  end
  
end


class Game_Player < Game_Character
  # Variable to keep track of when the player is actively dashing,
  # to return true for dash?() to make sure the dash speed isn't lost for
  # the forced move route.
  attr_accessor :dashJumpNoSlowdown
  
  # Variable to keep track of the current active rope type (the rope
  # that all ropes will be counted as)
  attr_accessor :currActiveRopeType
  
  #--------------------------------------------------------------------------
  # * Overridden dash?() method for the Game_Player class used to provide
  # * support for disabling dashes both globally and outfit-based, and is also
  # * used to prevent an issue where a slowdown occurs before a dash jump,
  # * since dashing gets disabled while the movement right before
  # * an lcm-type movement finishes.
  #--------------------------------------------------------------------------
  def dash?
    # The slowdown before dash jump issue is fixed by only counting the
    # move_route_forcing condition if the "real_x" position of the player has
    # caught up to the "x" position that the player is moving to. This exception
    # to the @move_route_forcing condition is only allowed when the
    # dashJumpNoSlowdown flag is on. I sincerely hope this doesn't cause
    # any issue in situations I'm not thinking of.
    
    # initialize the dashJumpSlowdown flag to false if it has not been yet
    @dashJumpNoSlowdown = false if (@dashJumpNoSlowdown == nil)
    # turns off the dashJumpNoSlowdown flag when real_x catches up to x
    if (@dashJumpNoSlowdown == true)
      @dashJumpNoSlowdown = false if (@real_x == @x)
    end
    
    # get whether or not dashes are disabled globally from exSaveData
    globalDashDisable = $game_party.getExSaveData("lcmGlobalDashDisableToggle", LCM::LCM_GLOBAL_DASH_DISABLE)
    # return false if the global dash disable toggle is on
    return false if globalDashDisable
    
    # return false if the outfit dash disable is on (and there is a valid outfit)
    if (@lcmMovementOutfit != nil)
      if (@lcmMovementOutfit != "none")
        # get whether or not dashes are disabled by the current outfit
        outfitDashDisable = LCM.getlcmDatasetData(@lcmMovementOutfit, :dashingDisable)
        return false if outfitDashDisable
      end
    end
    
    # line from original method v
    # return false if @move_route_forcing
    # new line: v
    return false if (@move_route_forcing && ((@dashJumpNoSlowdown) ? @real_x == @x : true))
    # the rest of the lines are from the original method
    return false if $game_map.disable_dash?
    return false if vehicle
    return Input.press?(:A)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to serve as a script call to get the player's current
  # * outfit name for conditional branches.
  # * Call with "$game_player.getPlayerlcmOutfit"
  #--------------------------------------------------------------------------
  def getPlayerlcmOutfit
    # implicit return of the currentlcmOutfit variable for whatever the current
    # player's actor is
    actor.currentlcmOutfit
  end
  
  #--------------------------------------------------------------------------
  # * New method that checks the player to see if they are on a rope.
  # * If they are on a rope, it updates the players's current graphic and
  # * speed to the appropriate values for the given rope type.
  #--------------------------------------------------------------------------
  def performPlayerRopesCheck(ropeName)    
    # get character x val
    charX = self.x
    # get character y val
    charY = self.y
    # get y val of the tile below the one the player is on before movement
    # (will be inacurrate if not going horizontally, but that doesn't matter here)
    yOfBelowTile = charY + 1
    
    # try to get the platform terrain tag of the tile below the player (after
    # the movement) if one exists
    terrainTag = $game_map.terrainTagPlatformCheck(charX, yOfBelowTile)
    # if the list of platform terrain tags includes the terrain tag
    # of the below tile, mark it as a platform
    belowTileIsPlatform = LCM::LCM_PLATFORM_TAGS.include?(terrainTag)
    
    # check player's current tile (tile after movement) for the ropes terrain tag
    ropesTerrainTagFound = $game_map.ropesTerrainTagCheck(charX, charY)
    
    # don't do ropes checks (meaning grabbing onto the rope) if not moving
    # horizontally, not already in ropes mode, the player is moving on a rope tile,
    # and the player is moving to a tile where there is a platform tile beneath the player's tile
    doNotDoRopesChecksSpecial = ((self.direction == 4 || self.direction == 6) && !self.inRopesMode? && ropesTerrainTagFound && belowTileIsPlatform == true)
    
    # Player Checks/Actions
    # Possibilities:
    # On rope tile & in "ropes mode"         -> Do nothing
    # On rope tile & not in "ropes mode"     -> Enter ropes mode, do ropes changes
    # Not on rope tile & in "ropes mode"     -> Exit ropes mode, reverse ropes changes
    # Not on rope tile & not in "ropes mode" -> Do nothing
    
    # if the special scenario for not doing ropes checks is not ocurring,
    # then do the rest of the ropes checks normally, otherwise, do nothing
    if (!doNotDoRopesChecksSpecial)
      # only do anything if the given rope type is climable by the player
      if (checkCharRopesAbility(ropeName) == true)
        # do different actions depending on whether the player is on a rope
        # tile or not.
        if (ropesTerrainTagFound == true)
          # the player is on a ropes tile, so only do updates if the
          # player is not in "ropes mode"
          if (!self.inRopesMode?)
            $game_player.characterUsingRopes = true # mark the player as in ropes mode
            # update player graphic/speed to the rope's versions
            performPlayerRopesUpdate(ropeName)
          end
        else
          # the player is not on a ropes tile, so only do updates if the
          # player is in "ropes mode"
          if (self.inRopesMode?)
            $game_player.characterUsingRopes = false # mark the player as not in ropes mode
            # update player graphic/speed back to default
            performPlayerRopesUpdate(ropeName)
          end
        end
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method that checks a particular follower to see if they are on a rope.
  # * If they are on a rope, it updates the followers's current graphic and
  # * speed to the appropriate values for the given rope type.
  #--------------------------------------------------------------------------
  def performFollowerRopesCheck(follower, ropeName)
    # get character x val
    charX = follower.x
    # get character y val
    charY = follower.y
    # get y val of the tile below the one the follower is on before movement
    # (will be inacurrate if not going horizontally, but that doesn't matter here)
    yOfBelowTile = charY + 1
    
    # try to get the platform terrain tag of the tile below the follower (after
    # the movement) if one exists
    terrainTag = $game_map.terrainTagPlatformCheck(charX, yOfBelowTile)
    # if the list of platform terrain tags includes the terrain tag
    # of the below tile, mark it as a platform
    belowTileIsPlatform = LCM::LCM_PLATFORM_TAGS.include?(terrainTag)
    
    # check follower's current tile (tile after movement) for the ropes terrain tag
    ropesTerrainTagFound = $game_map.ropesTerrainTagCheck(charX, charY)
    
    # don't do ropes checks (meaning grabbing onto the rope) if not moving
    # horizontally, not already in ropes mode, the follower is moving on a rope tile,
    # and the player is moving to a tile where there is a platform tile beneath the follower's tile
    doNotDoRopesChecksSpecial = ((follower.direction == 4 || follower.direction == 6) && !follower.inRopesMode? && ropesTerrainTagFound && belowTileIsPlatform == true)
    
    # Follower Checks/Actions
    # Possibilities:
    # On rope tile & in "ropes mode"         -> Do nothing
    # On rope tile & not in "ropes mode"     -> Enter ropes mode, do ropes changes
    # Not on rope tile & in "ropes mode"     -> Exit ropes mode, reverse ropes changes
    # Not on rope tile & not in "ropes mode" -> Do nothing
    
    # if the special scenario for not doing ropes checks is not ocurring,
    # then do the rest of the ropes checks normally, otherwise, do nothing
    if (!doNotDoRopesChecksSpecial)
      # only do anything if the given rope type is climable by the player
      if (follower.checkCharRopesAbility(ropeName) == true)
        # check follower's current tile for the ropes terrain tag
        ropesTerrainTagFound = $game_map.ropesTerrainTagCheck(follower.x, follower.y)
        # do different actions depending on whether the follower is on a rope
        # tile or not.
        if (ropesTerrainTagFound == true)
          # the player is on a ropes tile, so only do updates if the
          # player is not in "ropes mode"
          if (!follower.inRopesMode?)
            follower.characterUsingRopes = true # mark the player as in ropes mode
            # update char graphic/speed to the rope's versions
            follower.performFollowerRopesUpdate(ropeName)
          end
        else
          # the player is not on a ropes tile, so only do updates if the
          # player is in "ropes mode"
          if (follower.inRopesMode?)
            follower.characterUsingRopes = false # mark the player as not in ropes mode
            # update char graphic/speed back to default
            follower.performFollowerRopesUpdate(ropeName)
          end
        end
      end
    end
  end

end


# COMPATIBILITY METHODS BEYOND THIS POINT ----------------------------------------
# If the yanfly party system is in use, alias call_party_menu to
# cause a full party refresh.
if ($imported["YEA-PartySystem"] == true)
  class Game_Interpreter
    #--------------------------------------------------------------------------
    # * Aliased call_party_menu() method used to mark the player and
    # * their follower's (if enabled) outfits as needing a refresh.
    #--------------------------------------------------------------------------
    alias after_lcm_yanfly_party_menu_outfit_refresh call_party_menu
    def call_party_menu
      # mark outfits as needing refresh for the player (and followers to, if
      # they are enabled)
      $game_player.doFullOutfitRefresh
      
      # call original method
      after_lcm_yanfly_party_menu_outfit_refresh
    end
  end
end

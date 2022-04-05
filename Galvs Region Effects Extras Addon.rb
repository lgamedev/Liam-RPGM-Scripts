# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-GalvRegEffectsExtrasAddon"] = true
# END OF IMPORT SECTION

# ----------------- ! REQUIRES 'GALV'S REGION EFFECTS' SCRIPT! -----------------
# ----------------- ! REQUIRES 'EXTRA SAVE DATA' SCRIPT      ! -----------------
# Script:           Galv's Region Effects Extras Addon
# Author:           Liam (Original script by Galv)
# Version:          1.0
# Description:
# This addon allows you to create extra region effect sets that you can
# change between during gameplay runtime with a script call as well as additional
# extra features for these extra region effect sets like extra customization
# of the pitch/volume variance for sound effects. The region effect set from
# the original script is the default region effect set that is used and can
# still be accessed. When this default set is active it has the special
# behaviour of basically turning the extra features of this script addon "off"
# for that set (namely pitch/volume variance). This means that you should
# not use the original script's region effect set if you always want
# to have the additonal features of this addon active. Some maps can have
# special region effect sets that are used when the player transfers into
# the map, and when the player is no longer in a special region
# effect set map the active region effect will change back to the last
# non-special-map one. Lastly, random region effects can be used which
# will pull a random effect from a specified list of effects. 
#
# Feel free to use this script however you like, commercial or not, as long
# as you credit me. Just 'Liam' is fine. Note that this addon still requires
# the Galv's Region Effects script, so the license it uses will still
# apply to your game as well.
#
# If you have any questions or concerns, or if you want to be notified of
# the updates for this script as they release, join my scripting-focused
# discord server at:
#   https://discord.gg/JgaBenr
#
# The most recent version of the script can always be found on github at:
#   https://github.com/lgamedev/Liam-RPGM-Scripts
#
# __Usage Guide__
# If you don't already have it, you will need the Galv's Region Effects script from:
# https://galvs-scripts.com/galvs-region-effects/
# You will also need the "Extra Save Data" script.
# That script is also by Liam, find it through the earlier github link.
#
# To use this script addon, place it somewhere below the original Galv's
# Region Effects script. Then, fill out the script settings in the
# Modifiable Constants section as desired.
#
# Important Note 1: Make sure this is BELOW the Galv's Region Effects script!!!!
# Otherwise, the script will NOT FUNCTION!
#
# Important Note 2: You can still use the region effect set from the original
# Galv's Region Effects script. This is done by setting the active
# region effect set to "orig script default". The starting active region effect
# set will also be "orig script default" until changed. HOWEVER, using the original
# region effect set will also render the extra effects/features of the
# script null, namely the extra volume/pitch variance controls and the
# random region effects. You could view using the "orig script default" region
# effect set as turning this script addon "off". Do not use that
# set if you always want the additional features of this addon to be on.
#
# Other Notes (These are a modified version of the original script's header
# comments placed here for the user's convenience. You do not have to do this
# again if this is already done):
# OTHER INSTRUCTIONS:
#  - Make sure to create/have a map with the same ID as the SPAWN_MAP_ID from
#    the original script's settings. This map will be the map used to copy
#    events from to use as region effects when region effects use events.
#  - Change REGION_EFFECT_SWITCH from the original script's settings to a switch
#    you are not otherwise using in your game.
#  - Turn the switch specified by REGION_EFFECT_SWITCH on to disable
#    region effects.
#
#    Script Calls:
# There are two new script calls you can use as script line in events:
#
#   changeActiveRegionEffectSet("New Region Effect Set Name", changeStoredRegionSet = true)
# This script call changes the active region effect set to the one
# whose name you specify. This will take effect immediately as soon
# as the script call is ran.
# Note: If you set the active region effect set
# to "orig script default", the region effect set from the original Galv's
# Region effects script will be used. The starting active (and stored) region
# effect set will also be "orig script default" until changed. HOWEVER, using the
# original region effect set will also render the extra effects/features of
# the script null, namely the extra volume/pitch variance controls and the
# random region effects. You could view using the "orig script default" region
# effect set as turning this script addon "off".
#
# There is an optional parameter for this script call, changeStoredRegionSet.
# This parameter determines if the stored "default" active region set which is
# temporarily overridden by map-specific region sets when present will also
# be set to the current map region set. If true, it changes the stored
# region effect set, and if false, it doesn't. It defaults to true if not used.
# You can call this method like:
#   changeActiveRegionEffectSet("New Region Effect Set Name", true)
#   changeActiveRegionEffectSet("New Region Effect Set Name", false)
#   or just
#   changeActiveRegionEffectSet("New Region Effect Set Name")
# The 1st and 3rd calls are functionally equivalent.
#
# Normally, you would want to change the stored region set, so you can ignore
# the optional parameter most of the time and use the 3rd version of the call.
# The main sort of situation where you would want to not change the stored
# region effect set would be if you had a map-specific region effect set which
# changed to something else while on the map (like a new puddle appearing so
# a specific region effect has its sound effect changed), but the region effect
# set should not become the new "default" region effect set since the effect
# set still basically specific to the map.
# You would basically never use the optional parameter on a map
# that isn't a special region effect set map.
# 
# -----
# 
#   setActiveRegionEffectSetToCurrentMapSet(changeStoredRegionSet = false)
# This script call changes the active region effect set to the map-specific
# one designated for the current map. If there is no designated
# region effect set for the current map, this script call will do nothing.
#
# There is an optional parameter for this script call, changeStoredRegionSet.
# This parameter determines if the stored "default" active region set which is
# temporarily overridden by map-specific region sets when present will also
# be set to the current map region set. If true, it changes the stored
# region effect set, and if false, it doesn't. It defaults to false if not used.
# You can call this method like:
#   setActiveRegionEffectSetToCurrentMapSet(true)
#   setActiveRegionEffectSetToCurrentMapSet(false)
#   or just
#   setActiveRegionEffectSetToCurrentMapSet
# The 2nd and 3rd calls are functionally equivalent.
#
#
# __Modifiable Constants__
module Region_Effects
  # The minimum volume that variance can cause volume to reach. If the theoretical
  # final volume ends up lower than this number, then it will be brought
  # up to this number.
  #
  # Note 1: If a custom volume range causes the volume to go below this number
  # or if the volume was put under this number to begin with, then the min
  # variance volume will not increase it. It will be assumed that the
  # extra-quiet volume was intended.
  #
  # Note 2: There's not really such a thing as "negative volume", so 0
  # is a hard limit regardless of this setting.
  MIN_VARIANCE_VOLUME = 0
  
  # The maximum volume that variance can cause volume to reach. If the theoretical
  # final volume ends up higher than this number, then it will be brought
  # down to this number.
  #
  # Note 1: If a custom volume range causes the volume to go above this number
  # or if the volume was put above this number to begin with, then the max
  # variance volume will not decrease it. It will be assumed that the
  # extra-loud volume was intended.
  #
  # Note 2: Unlike what the original script says, you can actually
  # have volume go over 100, but you probably don't want to take it much
  # above 200 as it will start getting really loud.
  MAX_VARIANCE_VOLUME = 200
  
  # The default volume variance to use for sound effects. This variance
  # is the maximum number which the sounds that get played can differ
  # from the sound's originally-designated volume in the sound data.
  # If set to 0, all volumes for sound effects will be the same unless
  # a custom volume range is designated.
  #
  # The original default volume range the original script uses is 10
  # with normalization on.
  DEFAULT_VOLUME_VARIANCE = 10
  
  # Whether or not to "normalize" the volume variance (makes it more likely to
  # trend towards 0 in whatever the difference from the original volume number is).
  #
  # This will take effect for default and custom volume variances.
  NORMALIZE_VOLUME_VARIANCE = true
  
  # Whether or not to allow volume to go to 0 when variance affects
  # sound effect volume. If this setting is set to false, post-variance
  # volumes of 0 will instead be bumped up to 1.
  #
  # This setting will take effect for default and custom volume variances,
  # but if the volume is set to 0 (not in a custom range) it will not
  # bump the volume up to 1.
  ALLOW_ZERO_VOLUME_BY_VARIANCE = false
  
  # The minimum pitch that variance can cause pitch to reach. If the theoretical
  # final pitch ends up lower than this number, then it will be brought
  # up to this number.
  #
  # Note 1: If a custom pitch range causes the volume to go below this number
  # or if the pitch was put under this number to begin with, then the min
  # variance volume will not increase it. It will be assumed that the
  # extra-low pitch was intended.
  #
  # Note 2: Unlike what the original script says, you can have
  # have pitch be under 50, but you probably don't want to take it much
  # lower than 10. There's not really such a thing as a pitch less than 1, so 1
  # is a hard limit regardless of this setting.
  MIN_VARIANCE_PITCH = 10
  
  # The maximum pitch that variance can cause pitch to reach. If the theoretical
  # final pitch ends up higher than this number, then it will be brought
  # down to this number.
  #
  # Note 1: If a custom pitch range causes the pitch to go above this number
  # or if the pitch was put above this number to begin with, then the max
  # variance pitch will not decrease it. It will be assumed that the
  # extra-high volume was intended.
  #
  # Note 2: Unlike what the original script says, you can actually
  # have pitch go over 150, but you probably don't want to take it much
  # above 200 as it starts getting very shrill.
  MAX_VARIANCE_PITCH = 200
  
  # The default pitch variance to use for sound effects. This variance
  # is the maximum number which the sounds that get played can differ
  # from the sound's originally-designated pitch in the sound data.
  # If set to 0, all pitches of sound effects will be the same unless
  # a custom pitch range is designated.
  #
  # The original default pitch range the original script uses is 40
  # with normalization on.
  DEFAULT_PITCH_VARIANCE = 40
  
  # Whether or not to "normalize" the pitch variance (makes it more likely to
  # trend towards 0 in whatever the difference from the original pitch number is).
  #
  # This will take effect for default and custom pitch variances.
  NORMALIZE_PITCH_VARIANCE = true
  
  # A list of region effect set names pointing to the corresponding
  # region effect lists. These are used in the script call
  # to change the active region effect set and in the special map region
  # effect set list. You can add as many of your own region effect
  # sets as you want by following the format, but each region effect
  # set will be limited in number by the amount of regions (there are 64
  # regions counting region 0, the "no region" region).
  #
  # Additionally the "pitch" and "volume" parameters can now be a user-defined
  # range as well as just a number SPECIFICALLY FOR THESE ADDITIONAL
  # REGION SETS (it will not work for the original script's set).
  # These ranges will be used to generate a custom variances.
  # These are set up like: lowerBoundNum..upperBoundNum
  # Example: 50..75
  #
  # You can also get a random effect from a set of effect in
  # RANDOM_EFFECT_SETS. To do this, preface what would otherwise be your
  # sound name with "randeffect-"
  # and then follow it with the random sound set name to use.
  # Example: "randeffect-Random Effect Set 1 Name"
  # If using a random effect, the rest of the data in EXTRA_REGION_EFFECT_SETS
  # (other than the name) will be ignored and a random effect will be chosen
  # out of the specified list in RANDOM_EFFECT_SETS to use as the actual effect.
  # DO NOT PUT A SPACE BETWEEN THE DASH AND THE RANDOM SOUND SET NAME!
  # The random effect set name should begin directly adjacent to the dash.
  #
  # Note: DO NOT USE THE NAME "orig script default" FOR ANY REGION
  # EFFECT SET NAMES HERE, IT IS RESERVED FOR THE REGION EFFECT
  # SET FROM THE ORIGINAL SCRIPT! See the notes about "orig script default"
  # region effect set for the "changeActiveRegionEffectSet()" script
  # call for more information about the effects of using
  # the "orig script default" set.
  #
  # format: "Region Effect Set Name" => {
  #           regionNum => [SEE EFFECT DATA BELOW]
  #         }
  # effect data:
  # ["soundName", volOrVolRange, pitchOrPitchRange, eventID, commonEventID]
  #
  #  regionNum          -  The region ID the effect will activate on.
  #  soundName          -  The name of the SE file. "" for no sound.
  #  volOrVolRange      -  The volume of the SE (greater than 0) or volume range.
  #  pitchOrPitchRange  -  The pitch of the SE (greater than 1) or pitch range.
  #  eventID            -  Event ID called from the spawn map. 0 for none.
  #  commonEventID      -  Common event ID to call. 0 for no common event.
  EXTRA_REGION_EFFECT_SETS = {
    "Test Map 1 Set" => {
      # a random effect from "Random Effect Set 1" (other data in line below ignored)
      1 => ["randeffect-Random Effect Set 1", 0, 0, 0, 0],
      2 => ["Bow2", 5..100, 40..200, 0, 0],        # Loose sand
      3 => ["Ice4", 10, 135, 0, 0]        # Snow
    },
    "Test Map 2 Set" => {
      1 => ["Earth4", 10, 140, 0, 0],     # Stone
      2 => ["Water1", 5, 140, 0, 0],      # Water
      3 => ["Fire1", 10, 70, 0, 0]        # Lava
    },
    "Region Set 3 Name" => {
      
    }
  }
  
  # A list of random effect set names pointing to the corresponding
  # random region effect lists. A random effect is drawn from the
  # specified list when designated in a region effect set in
  # EXTRA_REGION_EFFECT_SETS where the "soundName" is set up like
  # "randeffect-Random Effect Set Name". Every effect in the random
  # effect lists has an equal chance of being used. You can add
  # as many random effect sets random effect possibilities in the
  # random effect sets as you want as long as you follow the format.
  #
  # You can change the active region effect set with the script call
  #   changeActiveRegionEffectSet("New Region Effect Set Name")
  #
  # format: "Random Region Effect Set Name" => [
  #           [SEE EFFECT DATA BELOW],
  #           [SEE EFFECT DATA BELOW],
  #           [SEE EFFECT DATA BELOW],
  #           [...]
  #         ]
  # effect data:
  # ["soundName", volOrVolRange, pitchOrPitchRange, eventID, commonEventID]
  #
  #  regionNum          -  The region ID the effect will activate on.
  #  soundName          -  The name of the SE file. "" for no sound.
  #  volOrVolRange      -  The volume of the SE (greater than 0) or volume range.
  #  pitchOrPitchRange  -  The pitch of the SE (greater than 1) or pitch range.
  #  eventID            -  Event ID called from the spawn map. 0 for none.
  #  commonEventID      -  Common event ID to call. 0 for no common event.
  RANDOM_EFFECT_SETS = {
    "Random Effect Set 1" => [
      ["Cow", 15, 140, 0, 0],            # Cow
      ["Blow7", 60, 150, 0, 0],          # Wood surface
      ["Water1", 60, 110, 0, 0]          # Shallow Water
    ],
    "Random Effect Set 2" => [
      ["", 0, 0, 0, 0],                  # Nothing
      ["Blow7", 60, 150, 0, 0],          # Wood surface
      ["Water1", 60, 110, 0, 0]          # Shallow Water
    ],
    "Random Effect Set 3" => [
      ["", 0, 0, 0, 0],                  # Nothing
    ]
  }
  
  # A list of specific mapIDs pointing to region effect set names
  # where the active region effect set will be set to
  # the corresponding special region set when transferring into
  # one of these special maps. You can add as many region sets
  # for specific maps as you want as long as you follow the format.
  # It is fine to repeat the same region set name for multiple
  # different maps.
  #
  # Upon transferring out of one of these maps, the active region effect set
  # will change to the last non-special-map region effect set (if the
  # new map doesn't also have a specifc region effect set designated for it).
  #
  # Note: You can use "orig script default" here as a region effect set name
  # to use the region effect set from the original script as the region
  # effect set. See the notes about "orig script default" region effect set for the
  # "changeActiveRegionEffectSet()" script call for more information about
  # the effects of using the "orig script default" set.
  #
  # format: mapID => "Region Set Name"
  REGION_SETS_FOR_SPECIFIC_MAPS = {
    # the below lines are just used as examples, change the values as needed
    9994 => "Test Map 1 Set",
    9996 => "Test Map 1 Set",
    9999 => "Region Set 2 Name",
    9998 => "orig script default",
    9997 => "Region Set 3 Name"
  }
  
  # This setting determines whether or not the stored/"default" region effect
  # set will be restored as the active region effect set when leaving a map
  # that has a specially-designated region effect set in
  # REGION_SETS_FOR_SPECIFIC_MAPS, even if the special map region effect set
  # was not actually being used when the player transferred out of the map.
  # That may be the case if you change the active region effect set to something
  # else on a map with a special map set.
  #
  # If it was too difficult to understand what that mean, just leave this
  # setting as true and it will probably be fine for you.
  RESTORE_STORED_REGION_SET_ON_MAP_EXIT_EVEN_IF_MAP_SET_NOT_IN_USE = true
  
  # __END OF MODIFIABLE CONSTANTS__
  
  
  
  # BEGINNING OF SCRIPTING ====================================================
  
  #--------------------------------------------------------------------------
  # * New helper method used to get the region effect set data using
  # * the region effect set name. Will get the region effect set from
  # * the original Galv's Region Effects script if the region effect
  # * set name is specifically "orig script default".
  # * Returns the appropriate region effect set data.
  #--------------------------------------------------------------------------
  def self.get_region_set(regionSetName)
    regionEffectSet = (regionSetName.downcase != "orig script default") ? EXTRA_REGION_EFFECT_SETS[regionSetName] : EFFECT
    return (regionEffectSet)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to handle the swap of the current active region set
  # * to a map-specific one. It first checks if the swap is needed based
  # * off whether the old and new mapIDs had a map-specific region effect
  # * set active.
  # * Then, it will adjust the active and stored region effect sets as needed.
  #--------------------------------------------------------------------------
  def self.special_map_region_set_handling(newMapID, oldMapID)
    # start with placeholder value for whether to cound the old map
    # as a special region effect set as false
    countOldMapAsSpecialRegionSetMap = false
    # When checking if the old map is a special region effect set map,
    # either verify whether the special map effect set was actually
    # in use as the active map region effect set depending on the
    # RESTORE_STORED_REGION_SET_ON_MAP_EXIT_EVEN_IF_MAP_SET_NOT_IN_USE
    # setting
    #
    # if true, don't check the actual active region effect set,
    # if false, do check the actual active region effect set
    if (Region_Effects::RESTORE_STORED_REGION_SET_ON_MAP_EXIT_EVEN_IF_MAP_SET_NOT_IN_USE == true)
      # to determine if the old map should be counted as a special region
      # set map, just check if there was a special region effect set
      # designated for the old map
      countOldMapAsSpecialRegionSetMap = Region_Effects::REGION_SETS_FOR_SPECIFIC_MAPS.has_key?(oldMapID)
    else
      # to determine if the old map should be counted as a special region
      # set map, find out if the old map's special region set is in use (if there is one)
      countOldMapAsSpecialRegionSetMap = $game_map.specifiedMapSpecialRegionEffectSetInUse(oldMapID)
    end
    
    # find if the new map id of the map the player is being
    # transferred to is a map with a special region effects list
    newMapIsSpecialRegionSetMap = Region_Effects::REGION_SETS_FOR_SPECIFIC_MAPS.has_key?(newMapID)
      
    # if the old map had a map-specific region effect set and the new
    # map does not have a special region effect set, then restore whatever the
    # stored region effect set is to the active region effect set.
    if (countOldMapAsSpecialRegionSetMap && !newMapIsSpecialRegionSetMap)
      # set active region set to the stored region set
      storedRegionSetName = $game_party.getExSaveData("storedGREERegionSetName", "orig script default")
      $game_party.setExSaveData("activeGREERegionSetName", storedRegionSetName)
      
    # if the new map has a map-specific region effect set, then
    # change the active region effect set to the map-specific one.
    #
    # additionally, if the old map did NOT have a special map region effect set,
    # then store the current active region set which will be replaced.
    elsif (newMapIsSpecialRegionSetMap)
      # get old active region set name
      oldActiveRegionSetName = $game_party.getExSaveData("activeGREERegionSetName", "orig script default")
      
      # set new active region set name according to the new mapID
      $game_party.setExSaveData("activeGREERegionSetName", Region_Effects::REGION_SETS_FOR_SPECIFIC_MAPS[newMapID])
      
      # if the old map did NOT have a special map region set in use, then
      # store the current active region set name that was just replaced
      if (!countOldMapAsSpecialRegionSetMap)
        $game_party.setExSaveData("storedGREERegionSetName", oldActiveRegionSetName)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * New helper method used to get a random number between a positive and
  # * and negative version of the given number.
  # * Returns the result.
  #--------------------------------------------------------------------------
  def self.get_rand_btwn_pos_and_neg(positiveNum)
    # randomize what would be the negative portions as just
    # a greater positive number, then the number is subtracted at the
    # the end to get the appropriate number in the range of
    # the negative and positive versions of the number
    #
    # 1 added since rand(n) returns numbers 0 to n-1
    result = rand(positiveNum + positiveNum + 1) - positiveNum
    return (result)
  end
  
end


module DataManager
  class << self
    # sets up the alias for play_battle_start
    alias gree_before_new_game_map_region_setup setup_new_game
  end
  
  #--------------------------------------------------------------------------
  # * Aliased setup_new_game() method used to setup a special map-specific
  # * region effect set if the first map the player spawns in on when
  # * a new game is started has a map-specific region effect set.
  #--------------------------------------------------------------------------
  def self.setup_new_game
    # setup player on the map
    gree_before_new_game_map_region_setup
    
    # just use -1 as oldMapID since it won't have any region set
    # designated for it
    oldMapID = -1
    newMapID = $game_map.map_id
    
    # set the appropriate map region sound if applicable
    Region_Effects.special_map_region_set_handling(newMapID, oldMapID)
  end
end


class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Aliased galv_region_check() method used to run the special
  # * galv_region_check_gree_alt_method() instead of the original
  # * galv_region_check() if a non-default region effect set is being used
  # * (the default being the one from the original Galv's Region Effects script).
  # *
  # * Note: The way this works means that the new script settings like
  # * enhanced pitch/volume variance controls WILL NOT WORK if your
  # * current active region set is the one from the original script.
  # * This means that you should avoid using the original script's
  # * region effect set if you do not want to have the original script
  # * work as "normal".
  #--------------------------------------------------------------------------
  alias gree_galv_region_check_orig galv_region_check
  def galv_region_check
    # get currently active region effect set
    currActiveRegionEffectSetName = $game_party.getExSaveData("activeGREERegionSetName", "orig script default")
    # do the original galv_region_check() method or the
    # galv_region_check_gree_alt_method() depending on whether the
    # original region effect set is being used or not (use original if orig script default)
    if (currActiveRegionEffectSetName.downcase == "orig script default")
      # call original method if using default effect set
      gree_galv_region_check_orig
    else
      # otherwise call alternative method that can get the new extra regions effect sets
      galv_region_check_gree_alt_method(currActiveRegionEffectSetName)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method which replaces the function of the galv_region_check() method
  # * from the original Galv's Region Effects script.
  # * Like the old version of the method, it does the region effect set
  # * sound-playing and event-running, but with some changes/additions.
  # * There is much more control in the script settings as to how
  # * the variance in pitch and volume is done. There is also support
  # * for doing a random effect from a list of possible effects.
  #--------------------------------------------------------------------------
  def galv_region_check_gree_alt_method(currActiveRegionEffectSetName)
    # below line is from the original method in galv's script, not
    # completely sure why it's here but I'm leaving it for now
    return if Input.trigger?(:C)
    
    # get region id of player
    r_id = $game_map.region_id($game_player.x, $game_player.y)
    
    # get active region effect list
    activeRegionEffectSet = Region_Effects.get_region_set(currActiveRegionEffectSetName)
	
    # return if no active region effect set
    return if (activeRegionEffectSet.nil?)
    # return if no designated sound for region in region effect set
    return if (activeRegionEffectSet[r_id].nil?)
    
    # get effectData
    effectData = activeRegionEffectSet[r_id]
    # get effectSoundName
    effectSoundName = activeRegionEffectSet[r_id][0]
    
    # change the effect data to a random effect data from the specified
    # random effect list if the effect should actually be a random effect
    randEffectRegex = /randeffect-(.*)/i
    if (effectSoundName =~ randEffectRegex)
      # save the random effect set name
      randomEffectSetName = $1
      
      # potential future addition to the script if requested: allow you to
      # apply weights to the random choosing of effects in random effect lists
      
      # immediately return if the specified random effect list does not exist
      return if (!Region_Effects::RANDOM_EFFECT_SETS.has_key?(randomEffectSetName))
      # immediately return if the specified random effect list is empty
      return if (Region_Effects::RANDOM_EFFECT_SETS[randomEffectSetName].empty?)
      
      # get a random effect from the specified random effect list as
      # the new effectData
      effectData = Region_Effects::RANDOM_EFFECT_SETS[randomEffectSetName].sample
      
      # get the new, proper, effectSoundName from the new effectData
      effectSoundName = effectData[0]
    end
    
    # get original volume placeholder (0)
    # origVolume will eventually be the volume that is modified
    # according to the volume variance
    origVolume = 0
    
    # GET/CALCULATE VOLUME VARIANCE AND NUM TO CHANGE BY
    # start with default volume variance number
    volVarianceNum = Region_Effects::DEFAULT_VOLUME_VARIANCE
    # get origVolume depending on if the volume is a number or a range,
    # if it is a range, also get the appropriate custom volVarianceNum.
    if (effectData[1].is_a?(Numeric))
      # make sure the origVolume number is an integer
      origVolume = effectData[1].to_i
    elsif (effectData[1].is_a?(Range))
      minVolRangeNum = effectData[1].begin.to_i
      maxVolRangeNum = effectData[1].end.to_i
      
      # get the origVolume as the middle of the min and max volume range numbers
      origVolume = minVolRangeNum + ((maxVolRangeNum - minVolRangeNum) / 2).to_i
      
      # volVarianceNum will be the difference between the maxVolRangeNum
      # and the origVolume
      volVarianceNum = maxVolRangeNum - origVolume
    end
    
    # get final volume change using randomization depending of if
    # volume variance is normalized or not.
    volumeChangeNum = 0 # placeholder value
    if (Region_Effects::NORMALIZE_VOLUME_VARIANCE)
      volumeChangeNum = rand(volVarianceNum + 1) - rand(volVarianceNum + 1)
    else
      # get random number btwn -volVarianceNum and +volVarianceNum
      volumeChangeNum = Region_Effects.get_rand_btwn_pos_and_neg(volVarianceNum)
    end
    
    
    # get original pitch placeholder (0)
    # origPitch will eventually be the pitch that is modified
    # according to the pitch variance
    origPitch = 0
    
    # GET/CALCULATE PITCH VARIANCE AND NUM TO CHANGE BY
    # start with default pitch variance number
    pitchVarianceNum = Region_Effects::DEFAULT_PITCH_VARIANCE
    # get origPitch depending on if the volume is a number or a range,
    # if it is a range, also get the appropriate custom pitchVarianceNum.
    if (effectData[2].is_a?(Numeric))
      # make sure the origPitch number is an integer
      origPitch = effectData[2].to_i
    elsif (effectData[2].is_a?(Range))
      minPitchRangeNum = effectData[2].begin.to_i
      maxPitchRangeNum = effectData[2].end.to_i
      
      # get the origPitch as the middle of the min and max pitch range numbers
      origPitch = minPitchRangeNum + ((maxPitchRangeNum - minPitchRangeNum) / 2).to_i
      
      # pitchVarianceNum will be the difference between the maxPitchRangeNum
      # and the origPitch
      pitchVarianceNum = maxPitchRangeNum - origPitch
    end
    
    # get final pitch change using randomization depending on if
    # pitch variance is normalized or not.
    pitchChangeNum = 0 # placeholder value
    if (Region_Effects::NORMALIZE_PITCH_VARIANCE)
      pitchChangeNum = rand(pitchVarianceNum + 1) - rand(pitchVarianceNum + 1)
    else
      # get random number btwn -pitchVarianceNum and +pitchVarianceNum
      pitchChangeNum = Region_Effects.get_rand_btwn_pos_and_neg(pitchVarianceNum)
    end
    
    
    # get the modifiedVolume, the original volume modified by the variance
    modifiedVolume = origVolume + volumeChangeNum
    # if the effect did not have a custom volume variance range
    # and the original volume was greater than the MIN_VARIANCE_VOLUME,
    # then increase the modifiedVolume up to MIN_VARIANCE_VOLUME if it is
    # lower than it
    if (!effectData[1].is_a?(Range) && (origVolume > Region_Effects::MIN_VARIANCE_VOLUME))
      modifiedVolume = [modifiedVolume, Region_Effects::MIN_VARIANCE_VOLUME].max
    end
    # if the effect did not have a custom volume variance range
    # and the original volume was less than than the MAX_VARIANCE_VOLUME,
    # then decrease the modifiedVolume down to MAX_VARIANCE_VOLUME if it is
    # higher than it
    if (!effectData[1].is_a?(Range) && (origVolume < Region_Effects::MAX_VARIANCE_VOLUME))
      modifiedVolume = [modifiedVolume, Region_Effects::MAX_VARIANCE_VOLUME].min
    end
    # ensure finalVolume is above the hard minimum bound of 0
    finalVolume = [modifiedVolume, 0].max
    # set finalVolume to 1 if the ALLOW_ZERO_VOLUME_BY_VARIANCE setting is false,
    # the current finalVolume is 0 (or less),
    # and the originalVolume was greater than 0
    if ((Region_Effects::ALLOW_ZERO_VOLUME_BY_VARIANCE == false) && (finalVolume <= 0) && (origVolume > 0))
      finalVolume = 1
    end
    
    
    # get the modifiedPitch, the original pitch modified by the variance
    modifiedPitch = origPitch + pitchChangeNum
    # if the effect did not have a custom pitch variance range
    # and the original pitch was greater than the MIN_VARIANCE_PITCH,
    # then increase the modifiedPitch up to MIN_VARIANCE_PITCH if it is
    # lower than it
    if (!effectData[2].is_a?(Range) && (origPitch > Region_Effects::MIN_VARIANCE_PITCH))
      modifiedPitch = [modifiedPitch, Region_Effects::MIN_VARIANCE_PITCH].max
    end
    # if the effect did not have a custom pitch variance range
    # and the original pitch was less than than the MAX_VARIANCE_PITCH,
    # then decrease the modifiedPitch down to MAX_VARIANCE_PITCH if it is
    # higher than it
    if (!effectData[2].is_a?(Range) && (origPitch < Region_Effects::MAX_VARIANCE_PITCH))
      modifiedPitch = [modifiedPitch, Region_Effects::MAX_VARIANCE_PITCH].min
    end
    # ensure finalPitch is above the hard minimum bound of 1
    finalPitch = [modifiedPitch, 1].max
    
    # get event to run (if there is one) and common event to run (if there is one)
    eve = activeRegionEffectSet[r_id][3]
    com_eve = activeRegionEffectSet[r_id][4]

    # Play the sound using the final calculated volume and pitch
    RPG::SE.new(effectSoundName, finalVolume, finalPitch).play
    
    # if there is an event to run, run it
    if (eve > 0)
      $game_map.region_event($game_player.x, $game_player.y, eve, Region_Effects::SPAWN_MAP_ID)
    end
    # if there is a common event to run, run it
    $game_temp.reserve_common_event(com_eve) unless (com_eve == nil)
  end
  
  #--------------------------------------------------------------------------
  # * Aliased perform_transfer() method used to swap the current active
  # * region set to a map-specific one right before the transfer is
  # * executed. Checks for if the swap is needed is done
  # * in the called method special_map_region_set_handling().
  #--------------------------------------------------------------------------
  alias gree_after_region_effect_set_updates perform_transfer
  def perform_transfer
    if (transfer?)
      # get new and old mapIDs
      newMapID = @new_map_id
      oldMapID = $game_map.map_id
      
      # Perform the checks/actions for setting up map-specific
      # region effect set
      Region_Effects.special_map_region_set_handling(newMapID, oldMapID)
      
      # Call original method (actually do the transfer)
      gree_after_region_effect_set_updates
    end
  end
  
end


class Game_Interpreter
  #--------------------------------------------------------------------------
  # * New method used to change the current active region set. It will set both
  # * the active region set and the stored region effect set (the "default" 
  # * region effect set that is temporarily overridden by map-specific
  # * region effect sets).
  # * If changeStoredRegionSet is true, the "default" region effect set
  # * which is temporarily overridden by map-specific effect sets will
  # * be changed along with the active region effect set.
  # * If changeStoredRegionSet is not present/false, only the active
  # * region effect set will be changed and not the stored one.
  # *
  # * Note: does not do nothing if an invalid newRegionEffectSetName is given
  # * because it will be confusing for users if they change the
  # * region effect set and it just silently doesn't change.
  #--------------------------------------------------------------------------
  def changeActiveRegionEffectSet(newRegionEffectSetName, changeStoredRegionSet = true)
    # set new active region set name according to the new region effect set name
    $game_party.setExSaveData("activeGREERegionSetName", newRegionEffectSetName)
    
    # if the stored region set is to be changed, then do so.
    if (changeStoredRegionSet)
      # set stored region set name to the same as the active one that was changed
      $game_party.setExSaveData("storedGREERegionSetName", newRegionEffectSetName)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to set the currently active region effect set to the
  # * specific one designated for the current map.
  # * If there is not a specially-designated region effect for the current map,
  # * then it does nothing.
  # * It has an optional parameter, changeStoredRegionSet. If not used, it
  # * defaults to false. If changeStoredRegionSet is true, the "default"
  # * region effect set which is temporarily overridden by map-specific
  # * effect sets will be changed along with the active region effect set.
  # * If changeStoredRegionSet is not present/false, only the active
  # * region effect set will be changed and not the stored one.
  #--------------------------------------------------------------------------
  def setActiveRegionEffectSetToCurrentMapSet(changeStoredRegionSet = false)
    if (!$game_map.map_id.nil?)
      # save current mapID
      currMapID = $game_map.map_id
      
      # check if the map id of the map the player is on
      # is a map with a special region effects list
      mapIsSpecialRegionSetMap = Region_Effects::REGION_SETS_FOR_SPECIFIC_MAPS.has_key?(currMapID)
      
      # if there is a designated region effects list, set it to the active
      # region effect list, otherwise, do nothing
      if (mapIsSpecialRegionSetMap)
        # get the name of the new region effect set to use
        newRegionEffectSetName = Region_Effects::REGION_SETS_FOR_SPECIFIC_MAPS[currMapID]
        
        # set new active region set name according to the new region effect set name
        $game_party.setExSaveData("activeGREERegionSetName", newRegionEffectSetName)
        
        # if the stored region set is to be changed, then do so
        if (changeStoredRegionSet)
          # set stored region set name according to the new region effect set name
          $game_party.setExSaveData("activeGREERegionSetName", newRegionEffectSetName)
        end
      end
    end
  end
end


class Game_Map
  #--------------------------------------------------------------------------
  # * New method used to check if the current map's special region effect set
  # * is in active use.
  # * Returns false if the special region effect set is not in use, or if
  # * the map does not have a special region effect set.
  #--------------------------------------------------------------------------
  def currMapSpecialRegionEffectSetInUse
    # if on a valid map, then check the region effect set
    if (map_id > 0)
      # find out if the current map has a special region set
      # if it does, check if it is in use
      currMapHasSpecialRegionSet = Region_Effects::REGION_SETS_FOR_SPECIFIC_MAPS.has_key?(map_id)
      
      # if the current map has a special region set, check if the
      # active region set matches it
      if (currMapHasSpecialRegionSet)
        # get active region set name
        activeRegionSetName = $game_party.getExSaveData("activeGREERegionSetName", "orig script default")
        
        # return whther the active region set is the current map's special region set or not
        return (Region_Effects::REGION_SETS_FOR_SPECIFIC_MAPS[map_id] == activeRegionSetName)
      end
    end
    
    # return false if all checks were not done
    return false
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if the a specified map's special region effect set
  # * is in active use.
  # * Returns false if the special region effect set is not in use, or if
  # * the map does not have a special region effect set.
  #--------------------------------------------------------------------------
  def specifiedMapSpecialRegionEffectSetInUse(mapID)
    # if a valid map, then check the region effect set
    if (mapID > 0)
      # find out if the specified map has a special region set
      # if it does, check if it is in use
      mapHasSpecialRegionSet = Region_Effects::REGION_SETS_FOR_SPECIFIC_MAPS.has_key?(mapID)
      
      # if the map has a special region set, check if the active
      # region set matches it
      if (mapHasSpecialRegionSet)
        # get active region set name
        activeRegionSetName = $game_party.getExSaveData("activeGREERegionSetName", "orig script default")
        
        # return whther the active region set is the map's special region set or not
        return (Region_Effects::REGION_SETS_FOR_SPECIFIC_MAPS[mapID] == activeRegionSetName)
      end
    end
    
    # return false if all checks were not done
    return false
  end
  
end

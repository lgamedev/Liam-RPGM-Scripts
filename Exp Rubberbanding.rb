# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-ExperienceRubberbanding"] = true
# END OF IMPORT SECTION

# ------------------- ! REQUIRES 'EXTRA SAVE DATA' SCRIPT ! -------------------
# Script:           Experience Rubberbanding
# Author:           Liam
# Version:          1.0.2
# Description:
# This script applies 'rubberbanding' to experience gain. It lets
# you set (and may set by itself) an "xp leader" for the rubberbanding to be
# based off of (which will likely be a main character). XP bonuses are applied
# to party members who are varying amounts of levels behind the party leader,
# and the bonuses can scale up as the amount of levels behind the leader increases.
# Requires the experience rubberbanding script.
#
# Note: This script does not applying negative rubberbanding if an actor
# is above the ACTOR_XP_LEADER.
#
# Feel free to use this script however you like, commercial or not, as long
# as you credit me. Just 'Liam' is fine.
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
# To use this script, set the ACTOR_XP_LEADER id (the actor to base the
# rubberbanding on, most likely the main character for your game). Next,
# decide whether you want the actor xp leader to be able to change when an
# actor levels up (if the actor has a higher level than the current xp leader).
# Then, set the ranges and corresponding bonuses for the number of levels
# that the actor is behind the xp leader in XP_RB_RANGES and XP_RB_BONUSES.
# Make sure the corresponding ranges and bonuses are in the same place
# on both lists.
# 
# Note 1: This script changes how the "change xp" command works in map events as
# well, so be mindful of that.
#
# Note 2: If you add a very high-level party member to your party at some point,
# MAKE SURE TO TURN OFF ACTOR_XP_LEAD_CHANGE_ON_LEVEL BEFORE THEY ARE ADDED!
# Otherwise, the high-level party member will soon become the ACTOR_XP_LEADER,
# and ruin the balancing of your game.
#
#   Example:
# ACTOR_XP_LEADER = 1
# ACTOR_XP_LEAD_CHANGE_ON_LEVEL = true
# XP_RB_RANGES = [
#   1..3, 4..8, 9..13, 14..99
# ]
# XP_RB_BONUSES = [
#   120,  150,  200,   300
# ]
#
# Using the above lists/settings will result in the following results:
# The actor w/ ID will be counted as the "XP LEADER" to start with.
# Then, upon level up:
# if an actor is behind by 1-3 levels, they will get a 120% xp bonus
# if an actor is behind by 4-8 levels, they will get a 120% xp bonus
# if an actor is behind by 9-13 levels, they will get a 120% xp bonus
# if an actor is behind by 14+ levels, they will get a 300% xp bonus
# and if an actor becomes a higher level then the xp leader upon level up,
# the ACTOR_XP_LEADER will change becayse ACTOR_XP_LEAD_CHANGE_ON_LEVEL is true.
#
#
# __Modifiable Constants__
module XPRB
  # The actor id of party memeber who should be the highest level or
  # used to base the rubber banding on
  # (because they are the party leader or whatever).
  # To change this value during gameplay, use the following script an a map event
  #   $game_party.setExSaveData("ACTOR_XP_LEADER", 1)
  # (use whichever actorID number you want in the place of the '1')
  ACTOR_XP_LEADER = 1
  
  # Allow the actor xp leader to change when an actor levels up if the actor
  # leveling up is a higher level then the current xp leader.
  # To turn this off/on during gameplay, use the following script an a map event
  #   $game_party.setExSaveData("ACTOR_XP_LEAD_CHANGE_ON_LEVEL", true)
  # (or use false, depending on what you want to set the value to)
  ACTOR_XP_LEAD_CHANGE_ON_LEVEL = true
  
  # What the ranges (for the # of levels a given actor is behind the XP_LEADER)
  # are. Ranges should be at the same place in this list as their corresponding
  # bonus xp.
  # NOTE: The ranges should go up to 99 in some capacity
  # (example: one range could be 14..99 to represent 14+ levels behind), since
  # no partymember will ever be 99 levels behind due to the level cap.
  XP_RB_RANGES = [
    1..3, 4..8, 9..13, 14..99
  ]
  
  # What bonuses to add for each range. Add numbers as percentages
  # (example, for 120% bonus xp for a character, put 120 in the array).
  # Put the numbers in the order corresponding with the order of the XP_RB_RANGES.
  XP_RB_BONUSES = [
    120,  150,  200,   300
  ]
  
  # __END OF MODIFIABLE CONSTANTS__
end



# BEGINNING OF SCRIPTING ====================================================
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Change Experience
  #     show : Level up display flag
  #--------------------------------------------------------------------------
  alias original_change_xp_method change_exp
  def change_exp(exp, show)
    # get the xp leader's actor ID
    xpLeaderID = $game_party.getExSaveData("ACTOR_XP_LEADER", XPRB::ACTOR_XP_LEADER)
    
    # get the party xp leader's amount of levels
    xpLeaderLevels = $game_actors[xpLeaderID].level
    
    # modify the exp gained with rubberbanding if the exp gained is positive
    if (exp >= 0)
      # get the amount of levels behind the party xp leader
      levelsBehind = xpLeaderLevels - @level
      
      # iterate through the list of ranges modify the exp gained according
      # to which range levelsBehind falls into
      XPRB::XP_RB_RANGES.each_with_index do |range, index|
        # if the number of levels behind falls into current range in the list,
        # apply the rubber banding percentage to the 
        # check if the range includes levelsBehind using the case equality operator
        if (range === levelsBehind)
          bonusPercentage = XPRB::XP_RB_BONUSES[index] / 100
          # modify the exp value with the bonus rubber banding percentage
          # (and make sure the number is an integer)
          exp = (exp * bonusPercentage).to_i
        end
      end
    end
    
    # call the original method (finalizes the exp change and applies level ups/downs)
    original_change_xp_method(exp, show)
    
    # check if the the xp leader changing setting is on, and send the
    # XPRB::ACTOR_XP_LEAD_CHANGE_ON_LEVEL value to initialize the data if it has not been yet
    xpLeadChange = $game_party.getExSaveData("ACTOR_XP_LEAD_CHANGE_ON_LEVEL", XPRB::ACTOR_XP_LEAD_CHANGE_ON_LEVEL)
    
    # change XP leader to the current actor if the current actors level
    # is beyond the XP leader's and xpLeadChange
    if ((@level > xpLeaderLevels) && xpLeadChange)
      # set the actor xp leader to the current actor
      $game_party.setExSaveData("ACTOR_XP_LEADER", @actor_id)
    end
  end
  
end
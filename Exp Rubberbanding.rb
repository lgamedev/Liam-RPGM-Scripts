# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-ExperienceRubberbanding"] = true
# END OF IMPORT SECTION

# ------------------- ! REQUIRES 'EXTRA SAVE DATA' SCRIPT ! -------------------
# Script:           Experience Rubberbanding
# Author:           Liam
# Version:          1.1
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
# on both lists. Set other settings as you think makes sense. Use the
# provided script calls in "script" event commands to change the settings
# during gameplay.
# 
# Note: If you add a very high-level party member to your party temporarily
# at some point, MAKE SURE TO TURN OFF ACTOR_XP_LEAD_CHANGE_ON_LEVEL BEFORE
# THEY ARE ADDED! Otherwise, the high-level party member may become the
# ACTOR_XP_LEADER and ruin the balancing of your game.
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
# The actor w/ ID 1 will be counted as the "XP LEADER" to start with.
# Then, upon level up:
# if an actor is behind by 1-3 levels, they will get a 120% xp bonus
# if an actor is behind by 4-8 levels, they will get a 120% xp bonus
# if an actor is behind by 9-13 levels, they will get a 200% xp bonus
# if an actor is behind by 14+ levels, they will get a 300% xp bonus
# and if an actor becomes a higher level then the xp leader upon level up,
# the ACTOR_XP_LEADER will change becayse ACTOR_XP_LEAD_CHANGE_ON_LEVEL is true.
#
#
# __Modifiable Constants__
module XPRB
  # This setting should be set to the actor id of party member who will be
  # used to base the rubberbanding off of as a guide. Usually, this would
  # be set to the main character since they would normally be the highest
  # level and always in the party, but it does not have to be.
  #
  # Change the setting during gameplay with the script call:
  #   set_new_actor_xp_leader(actorID)
  # (use the xp leader's actor number where it says actorID)
  ACTOR_XP_LEADER = 1
  
  # This setting allows the actor xp leader to change when an actor levels up
  # if the actor leveling up is a higher level then the current xp leader when
  # set to true.
  #
  # Change the setting during gameplay with script calls:
  #   toggle_actor_xp_lead_change_on_level(true)
  #   toggle_actor_xp_lead_change_on_level(false)
  ACTOR_XP_LEAD_CHANGE_ON_LEVEL = false
  
  # This setting determines whether or not xp rubberbanding affects
  # xp gained from the "change EXP" event command. If set to true
  # it does, otherwise, it does not.
  #
  # Change the setting during gameplay with script calls:
  #   toggle_change_xp_event_command_xp_rubberbanding(true)
  #   toggle_change_xp_event_command_xp_rubberbanding(false)
  CHANGE_XP_EVCOM_AFFECTED_BY_RUBBERBANDING = true
  
  # This setting determines whether or not
  # "reserve"/"non-active"/"non-battle members" have their xp gain affected
  # by rubberbanding or not. If set to true, they do, otherwise, they do not.
  #
  # Change the setting during gameplay with script calls:
  #   toggle_reserve_party_members_xp_rubberbanding(true)
  #   toggle_reserve_party_members_xp_rubberbanding(false)
  RUBBERBAND_RESERVE_PARTY_MEMBERS = false
  
  # What the ranges (for the number of levels a given actor is behind the
  # XP_LEADER) are which will give certain bonuses to xp. Ranges should be at
  # the same place in this list as their corresponding bonus xp. You can
  # set as many ranges as you want as long as they don't overlap and they
  # follow the setting format (and they have bonus percentages set for them).
  #
  # Note: The ranges should go up to the level cap (so 99 would be good enough
  # in moset cases)
  # (example: one range could be 14..99 to represent 14+ levels behind), since
  # no partymember will ever be 99 levels behind due to the level cap.
  #
  # format:
  # [
  # lvlsbehindrange1min..lvlsbehindrange1max, lbr2min..lbr2max, lbr3min..lbr3max, .....
  # ]
  XP_RB_RANGES = [
    1..3, 4..8, 9..13, 14..99
  ]
  
  # What bonuses to add for each range. Add numbers as percentages
  # (example, for 120% bonus xp for a character, put 120 in the array).
  # Put the numbers in the order corresponding with the order of the XP_RB_RANGES.
  # You can set as many bonus percentages as you want (as long as they have
  # corresponding xp rubberbanding ranges).
  #
  # format:
  # [
  # xprubberbandbonuspercent1, xprbbonus%2, xprbbonus%3, .....
  # ]
  XP_RB_BONUSES = [
    120,  150,  200,   300
  ]
  
  # __END OF MODIFIABLE CONSTANTS__
end



# BEGINNING OF SCRIPTING ====================================================
class Game_Actor < Game_Battler
  
  #--------------------------------------------------------------------------
  # * New method used to determine whether or not the actor should currently
  # * have exp rubberbanding applied or not. An actor should have exp
  # * rubberbanding if:
  # *    - the amount of xp to be gained originally is positive
  # *    - the actor is not leveling up (and gaining the xp) through
  # *      a "Change Level" event command
  # *    - the actor is either not gaining xp through a "change EXP"
  # *      event command, OR, the script setting allows xp rubberbanding
  # *      in that scenario
  # *    - the actor is either not reserve party member, OR, the script
  # *      allows xp rubberbanding in that scenario
  # *
  # * Returns true if all conditions are met, otherwise false.
  #--------------------------------------------------------------------------
  def actor_should_exp_rubberband?(origXPGain)
    # immediately return false if xp gain is zero or negative
    return false if (origXPGain <= 0)
    
    # immediately return false if actor level is being directly changed
    # through the "change level" event command
    return false if (@xprb_actor_level_changing == true)
    
    # immediately return false if directly changing xp through a
    # "Change EXP" event command AND AT THE SAME TIME xp rubberbanding is not to
    # be done in that scenario according to the
    # CHANGE_XP_EVCOM_AFFECTED_BY_RUBBERBANDING script setting
    xpDirectChangeRubberbanding = $game_party.getExSaveData("xprb_CHANGE_XP_EVCOM_AFFECTED_BY_RUBBERBANDING", XPRB::CHANGE_XP_EVCOM_AFFECTED_BY_RUBBERBANDING)
    return false if ((@xprb_actor_xp_event_command_direct_changing == true) && (xpDirectChangeRubberbanding == false))
    
    # immediately return false if the actor is a reserve partymember
    # AND AT THE SAME TIME xp rubberbanding is not to be done for them
    # according to the RUBBERBAND_RESERVE_PARTY_MEMBERS script setting
    xpRubberbandForReserves = $game_party.getExSaveData("xprb_RUBBERBAND_RESERVE_PARTY_MEMBERS", XPRB::RUBBERBAND_RESERVE_PARTY_MEMBERS)
    return false if (!self.battle_member? && (xpRubberbandForReserves == false))
    
    # return true if all checks were passed
    return true
  end
  
  #--------------------------------------------------------------------------
  # * New method used to get the rubberbanded experience value according to
  # * the appropriate rubberbanding bonus value. Will return the original
  # * xp amount to gain if no particular rubberband bonus value should be used.
  # *
  # * Returns the appropriate rubberbanded amount of xp to gain.
  #--------------------------------------------------------------------------
  def get_rubberbanded_exp_val(origXPGain)    
    # get the xp leader's actor ID
    xpLeaderID = $game_party.getExSaveData("xprb_ACTOR_XP_LEADER", XPRB::ACTOR_XP_LEADER)
    
    # get the xp leader's actorID and then levels using the actorID
    xpLeaderID = $game_party.getExSaveData("xprb_ACTOR_XP_LEADER", XPRB::ACTOR_XP_LEADER)
    xpLeaderLevels = $game_actors[xpLeaderID].level
    
    # get the amount of levels behind the party xp leader
    levelsBehind = xpLeaderLevels - @level
    
    # iterate through the list of ranges modify the exp gained according
    # to which range levelsBehind falls into
    XPRB::XP_RB_RANGES.each_with_index do |range, index|
      # if the number of levels behind falls into current range in the list,
      # apply the rubber banding percentage to the amount of xp gained
      
      # checks if the range includes levelsBehind using the case equality operator
      if (range === levelsBehind)
        # get bonus percentage for the range in the script settings
        bonusPercentage = XPRB::XP_RB_BONUSES[index] / 100.0
        # modify the exp gain with the bonus rubber banding percentage
        # (and make sure the number is an integer)
        newXPGain = (origXPGain* bonusPercentage).to_i
        
        # return the modified xp gain number
        return (newXPGain)
      end
    end
      
    # if no rubberbanding bonus percent was able to be found,
    # just return the original xp gain amount
    return (origXPGain)
  end
  
  #--------------------------------------------------------------------------
  # * Aliased change_exp() method for Sprite_Battler used to
  # * increase actor exp gain based on the actor's difference in level
  # * to the current actor exp leader.
  # *
  # * Note: the parameter "show" is a true/false value indicating whether
  # * a message indicating level ups will appear or not.
  #--------------------------------------------------------------------------
  alias xprb_original_change_xp_method change_exp
  def change_exp(exp, show)
    # start with the final xp val to change to as the original
    # value to change to (changed later by exp rubberbanding if applicable
    newXPValToChangeTo = exp
    
    # get the actor's original amount of xp
    origXPVal = @exp[@class_id]
    
    # get the original amount the xp gained (may be negative; is the number
    # before being affected by xp rubberbanding)
    origXPGain = exp - origXPVal
    
    # if the actor should have exp rubberbanding bonuses applied (if they
    # exist), then get the appropriate newXPGain
    if (actor_should_exp_rubberband?(origXPGain))
      # get new rubberbanded change in xp value from method that calculates it
      newXPGain = get_rubberbanded_exp_val(origXPGain)
      
      # change the newXPValToChangeTo based on the updated xp gain value
      newXPValToChangeTo = origXPVal + newXPGain
    end
    
    # call the original method (finalizes the exp change and applies level ups/downs)
    xprb_original_change_xp_method(newXPValToChangeTo, show)
    
    # check if the the xp leader changing setting is on, and send the
    # XPRB::ACTOR_XP_LEAD_CHANGE_ON_LEVEL value to initialize the data if it has not been yet
    xpLeadChange = $game_party.getExSaveData("xprb_ACTOR_XP_LEAD_CHANGE_ON_LEVEL", XPRB::ACTOR_XP_LEAD_CHANGE_ON_LEVEL)
    
    # get the xp leader's actorID and then levels using the actorID
    xpLeaderID = $game_party.getExSaveData("xprb_ACTOR_XP_LEADER", XPRB::ACTOR_XP_LEADER)
    xpLeaderLevels = $game_actors[xpLeaderID].level
    
    # change xp leader to the current actor if the current actor's level
    # is beyond the xp leader's level and the xpLeadChange setting is on
    if ((@level > xpLeaderLevels) && xpLeadChange)
      # set the actor xp leader to the current actor
      $game_party.setExSaveData("xprb_ACTOR_XP_LEADER", @actor_id)
    end
    
    # mark that no longer changing actor level or using the event command
    # for directly changing actor xp (set both to false)
    @xprb_actor_level_changing = false
    @xprb_actor_xp_event_command_direct_changing = false
  end
  
  # New variable used to track if the actor's exp is changing through the
  # "change level" event command (if it is, the the exp gained will not be
  # modified by exp rubberbanding)
  attr_accessor :xprb_actor_level_changing
  
  # New variable used to track if the actor's exp is being directly changed
  # through the "change EXP" event command (if it is, the the exp gained may
  # or may not be modified by exp rubberbanding depending on the
  # CHANGE_XP_EVCOM_AFFECTED_BY_RUBBERBANDING script setting)
  attr_accessor :xprb_actor_xp_event_command_direct_changing
  
  #--------------------------------------------------------------------------
  # * Aliased setup() for Game_Actor used to set the initial value of
  # * expr_actor_level_changing and expr_actor_xp_event_command_direct_changing
  # * to false.
  #--------------------------------------------------------------------------
  alias xprb_before_actor_level_changing_flag_set setup
  def setup(actor_id)
    # Call original method
    xprb_before_actor_level_changing_flag_set(actor_id)
    
    # set intial value of expr_actor_level_changing
    # and expr_actor_xp_event_command_direct_changing to false
    @xprb_actor_level_changing = false
    @xprb_actor_xp_event_command_direct_changing = false
  end
  
  #--------------------------------------------------------------------------
  # * Aliased change_level() used to mark that the actor's level is
  # * being directly changed using a variable. When the variable
  # * is true (level is directly changed), the exp gained will not be modified
  # * by exp rubberbanding. The flag will later be set to false where the
  # * xp change is actually done.
  # *
  # * Note: the parameter "show" is a true/false value indicating whether
  # * a message indicating level ups will appear or not.
  #--------------------------------------------------------------------------
  alias xprb_after_actor_level_changing_flag_set change_level
  def change_level(level, show)
    # mark that now changing actor level
    @xprb_actor_level_changing = true
    
    # only lines of original method below:
    #level = [[level, max_level].min, 1].max
    #change_exp(exp_for_level(level), show)
    
    # Call original method
    xprb_after_actor_level_changing_flag_set(level, show)
  end
  
end


class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Aliased command_315() in Game_Interpreter used to mark that the actor's
  # * exp value is being directly modified via a "change EXP" event command.
  # * When the variable is true (exp is directly changed), the exp gained may
  # * or may not be modified depending on the
  # * CHANGE_XP_EVCOM_AFFECTED_BY_RUBBERBANDING script setting. The flag will
  # * later be set to false where the xp change is actually done.
  #--------------------------------------------------------------------------
  alias xprb_after_actor_direct_xp_changing_flag_set command_315
  def command_315   
    # set the expr_actor_xp_event_command_direct_changing flag to true
    # for all actors having their xp directly changed through the event command
    iterate_actor_var(@params[0], @params[1]) do |actor|
      actor.xprb_actor_xp_event_command_direct_changing = true
    end
    
    # Call original method
    xprb_after_actor_direct_xp_changing_flag_set
  end
  
  #--------------------------------------------------------------------------
  # * New wrapper method that is the equivalent of the script call which
  # * changes the actor xp leader to a newly-specified one using actorID:
  # *   $game_party.setExSaveData("xprb_ACTOR_XP_LEADER", newActorXPLeaderID)
  # * It simplifies the script call to:
  # *   set_new_actor_xp_leader(newActorXPLeaderActorID)
  #--------------------------------------------------------------------------
  def set_new_actor_xp_leader(newActorXPLeaderActorID)
    $game_party.setExSaveData("xprb_ACTOR_XP_LEADER", newActorXPLeaderActorID)
  end
  
  #--------------------------------------------------------------------------
  # * New wrapper method that is the equivalent of the script call which
  # * changes the actor xp lead change on level script setting:
  # *   $game_party.setExSaveData("xprb_ACTOR_XP_LEAD_CHANGE_ON_LEVEL", trueOrFalse)
  # * It simplifies the script call to:
  # *   toggle_actor_xp_lead_change_on_level(trueOrFalse)
  #--------------------------------------------------------------------------
  def toggle_actor_xp_lead_change_on_level(trueOrFalse)
    $game_party.setExSaveData("xprb_ACTOR_XP_LEAD_CHANGE_ON_LEVEL", trueOrFalse)
  end
  
  #--------------------------------------------------------------------------
  # * New wrapper method that is the equivalent of the script call which
  # * changes script setting determining if the "change EXP" event command
  # * is affected by xp rubberbanding or not:
  # *   $game_party.setExSaveData("xprb_CHANGE_XP_EVCOM_AFFECTED_BY_RUBBERBANDING", trueOrFalse)
  # * It simplifies the script call to:
  # *   toggle_change_xp_event_command_xp_rubberbanding(trueOrFalse)
  #--------------------------------------------------------------------------
  def toggle_change_xp_event_command_xp_rubberbanding(trueOrFalse)
    $game_party.setExSaveData("xprb_CHANGE_XP_EVCOM_AFFECTED_BY_RUBBERBANDING", trueOrFalse)
  end
  
  #--------------------------------------------------------------------------
  # * New wrapper method that is the equivalent of the script call which
  # * changes script setting determining if the "change EXP" event command
  # * is affected by xp rubberbanding or not:
  # *   $game_party.setExSaveData("xprb_RUBBERBAND_RESERVE_PARTY_MEMBERS", trueOrFalse)
  # * It simplifies the script call to:
  # *   toggle_reserve_party_members_xp_rubberbanding(trueOrFalse)
  #--------------------------------------------------------------------------
  def toggle_reserve_party_members_xp_rubberbanding(trueOrFalse)
    $game_party.setExSaveData("xprb_RUBBERBAND_RESERVE_PARTY_MEMBERS", trueOrFalse)
  end
  
end


# COMPATIBILITY METHODS FOR YANFLY'S "Victory Aftermath" SCRIPT BELOW:
if ($imported["YEA-VictoryAftermath"])
  class Window_VictoryEXP_Back < Window_Selectable
    #--------------------------------------------------------------------------
    # * Aliased actor_exp_gain() in Window_VictoryEXP_Back from Yanfly's
    # * "Victory Aftermath" script used to apply the exp rubberbanding bonus
    # * to the final experience amount gained that will be displayed
    # * in the victory aftermath xp window.
    #--------------------------------------------------------------------------
    alias xprb_before_exp_rubberband_bonus_applied actor_exp_gain
    def actor_exp_gain(actor)
      # only lines of original method below:
      #n = @exp_total * actor.final_exp_rate
      #return n.to_i
      
      # Call original method and store the returned exp gain amount
      origXPGain = xprb_before_exp_rubberband_bonus_applied(actor)
      
      # start with finalXPGain as origXPGain
      finalXPGain = origXPGain
      
      # if the actor should have exp rubberbanding bonuses applied,
      # then get the appropriate newXPValChange
      if (actor.actor_should_exp_rubberband?(origXPGain))
        # get new rubberbanded change in xp value from method that calculates it
        newXPValChange = actor.get_rubberbanded_exp_val(origXPGain)
        
        # change finalXPGain to newXPValChange
        finalXPGain = newXPValChange
      end
      
      # return the final updated xp gain amount
      return (finalXPGain)
    end
  end
end

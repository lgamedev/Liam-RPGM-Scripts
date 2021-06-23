# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-StateSkillUsabilityRefresh"] = true
# END OF IMPORT SECTION

# ------------------- ! REQUIRES 'EXTRA SAVE DATA' SCRIPT ! -------------------
# Script:           State Skill Usability Refresh
# Author:           Liam
# Version:          1.0
# Description:
# This script allows you to prevent enemies/actors from using skills
# that they would no longer to be able to use when states are applied
# to them that restrict skill usability. This is done normally with
# the engine's base script, but this makes sure the moves are correct
# even in edge-case situations. The difference is, after the skill usability
# restricting moves are used on a battler with this script, a replacement
# skill for the now-unusable skill can be used. The restricting states
# either restrict a particular skill or a skill type. When these
# skill usability restricting states are applied (and sometimes removed),
# it may result in a "skill usability refresh" (depending on script settings
# and notetagging). These refreshes make it so that if an enemy/actor is found
# to be trying to use a skill which they no longer would be able to use if
# the turn was still in the action selection phase, then they will either do
# no action at all, or they will select a new action. Particular replacement
# actions can be set for actors, while enemies just pick a new action
# from whatever their updated action list is. Skill usability refreshes
# can be forced for any skill using the skill usability refresh notetag, and
# to get states to refresh on removal the notetag mut be used.
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
# To use this script, first, place it in your script list. After that,
# set up the script settings however you want. Use the provided notetags
# as needed.
#
# Notetags:
# Put these in the "Note" section of database pages for states to use them.
#
# <DO USABILITY REFRESH>
#
# This notetag will cause a skill to do a skill usability refresh after it is
# applied when the DO_SKILL_USABILITY_REFRESH_FOR_ALL_STATES setting is off.
# This notetag is the only way to do skill usability refreshes if the
# DO_SKILL_USABILITY_REFRESH_FOR_ALL_STATES setting is off.
# Notetagged usability refreshes will also cause states to do usability
# refreshes on state removal too, which may be useful in certain situations.
# 
#
# <NO USABILITY REFRESH>
#
# This notetag will prevent a skill usability refresh from being done
# even if the DO_SKILL_USABILITY_REFRESH_FOR_ALL_STATES setting is on.
#
#
# __Modifiable Constants__
module SURFS
  # This setting determines if skill usability refreshes/checks (that cause
  # battlers to be unable to use skills that they were going to use) should
  # happen for all skills that affer skill usability. If set to true, the
  # 'NO USABILITY REFRESH' notetag can be used to exclude specific skills
  # from the skill usability refresh, and if set to false, the
  # 'DO USABILITY REFRESH' notetag must be used to make skill usage restricting
  # states do a skill usability refresh when they are applied.
  #
  # using notetags on specific skills will bypass this setting
  DO_SKILL_USABILITY_REFRESH_FOR_ALL_STATES = true
  
  # This setting determines whether or not to affect actors when doing a
  # skill usability check after a skill usage restricting state is applied to them.
  ACTOR_SKILL_USABILITY_REFRESH_ON = true
  
  # This setting determines whether or not to affect enemies when doing a
  # skill usability check after a skill usage restricting state is applied to them.
  ENEMY_SKILL_USABILITY_REFRESH_ON = true
  
  # This setting determines what skill an actor should use as a replacement skill
  # when they are no longer able to use the skill they were going to use after
  # a skill usage restricting state is applied to them.
  #
  # It is probably best to set these skills to a basic attack or guard skill
  # of some kind.
  #
  # format:
  #   actorID => skillID
  # Ex.
  # ACTOR_REPLACEMENT_SKILLS = {
  #   1 => 13,
  #   3 => 2
  # }
  # The above setting would result in the actor with actorID 1 using the
  # skill number 13 as their replacement skill for skills they can no longer
  # use due to a new state, and the actor with actorID 3 using the skill
  # number 2 as their replacement skill.
  ACTOR_REPLACEMENT_SKILLS = {
    1 => 2,
    2 => 1
  }
  
  # This setting determines what replacement skill to use as the default
  # replacement skill if a replacement skill is not specified for a given actor.
  #
  # It is probably best to set this skill to a basic attack or guard skill
  # of some kind.
  ACTOR_DEFAULT_REPLACEMENT_SKILL = 1
  
  # This setting controls whether actors do or do not pick a new skill
  # after their old one is invalidated by getting a skill use restricting state.
  #
  # If this setting is set to "new", the actor will pick the skill given by
  # ACTOR_REPLACEMENT_SKILLS if there is a skill designated for the actor's
  # actorID, otherwise, it will use the ACTOR_DEFAULT_REPLACEMENT_SKILL.
  # If this setting is set to "none", the actor will be left with not taking
  # an action that turn and replacement skills are not used.
  #
  # Options: "new", "none"
  ACTOR_USABILITY_REPLACEMENT_MODE = "new"
  
  # This setting controls whether enemies do or do not pick a new skill
  # after their old one is invalidated by getting a skill use restricting state.
  #
  # If this setting is set to "new", the enemy will pick a new valid skill from
  # their new list of available skills.
  # If this setting is set to "none", the enemy will be left with not taking
  # an action that turn.
  #
  # Options: "new", "none"
  ENEMY_USABILITY_REPLACEMENT_MODE = "new"
  
  # __END OF MODIFIABLE CONSTANTS__
end



# BEGINNING OF SCRIPTING ====================================================
class RPG::State
  #--------------------------------------------------------------------------
  # * New method used to read in a do 'do skill usability notetag',
  # * which if present, means the state should cause a skill usability refresh.
  #--------------------------------------------------------------------------
  def doSkillUsabilityRefresh
    # check if doSkillUsabilityRefresh has been checked yet, if not, get it
    if @doSkillUsabilityRefresh.nil?
      # checks for DO USABILITY REFRESH notetag being present
      if (@note =~ /<DO USABILITY REFRESH>/i)
        # the state is marked for a usability refresh if the DO USABILITY REFRESH
        # notetag is present
        @doSkillUsabilityRefresh = true
      else
        # false returned as default val if no notetag present
        @doSkillUsabilityRefresh = false
      end
    end
    # doSkillUsabilityRefresh implicit return
    @doSkillUsabilityRefresh
  end
  
  #--------------------------------------------------------------------------
  # * New method used to read in a 'no skill usability' notetag,
  # * which if present, means the state should prevent any skill usability refresh.
  #--------------------------------------------------------------------------
  def noSkillUsabilityRefresh
    # check if noSkillUsabilityRefresh has been checked yet, if not, get it
    if @noSkillUsabilityRefresh.nil?
      # checks for NO USABILITY REFRESH notetag being present
      if (@note =~ /<NO USABILITY REFRESH>/i)
        # the state is marked for a usability refresh if the NO USABILITY REFRESH
        # notetag is present
        @noSkillUsabilityRefresh = true
      else
        # false returned as default val if no notetag present
        @noSkillUsabilityRefresh = false
      end
    end
    # noSkillUsabilityRefresh implicit return
    @noSkillUsabilityRefresh
  end
  
  #--------------------------------------------------------------------------
  # * New method used to determine if the state affects skill usability
  # * (meaning it has the features of sealing a skill type or particular skill(s))
  #--------------------------------------------------------------------------
  def impactsSkillUsability?
    # return true if the state feature list includes feature 42 or 44
    # 42 -> seal skill type
    # 44 -> seal skill
    return (@features.any? {|feature| (feature.code == 42 || feature.code == 44)})
  end
  
end


class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Aliased add_new_state() for Game_Battler used to prevent actor and/or
  # * enemy battlers from using a skill chosen before a skill-restricting
  # * state is inflicted on the battler by triggering a skill usability refresh
  # * after the state is added.
  #--------------------------------------------------------------------------
  alias surfs_between_state_add_refresh_checks_and_changes add_new_state
  def add_new_state(state_id)
    # just immediately make battler die if the state inflicts death
    die if state_id == death_state_id
    
    stateData = $data_states[state_id] # get state data
    
    # start new flag for triggering a state skill usability refresh as false
    doStateSkillUsabilityRefresh = false
    
    # check if the state impacts skill usability
    stateImpactsSkillUsability = stateData.impactsSkillUsability?
    
    # check if skill usability refresh exclusion notetag found
    skillUseRefreshExcludeNotetagFound = stateData.noSkillUsabilityRefresh
    
    # check if skill usability refresh notetag found
    skillUseRefreshNotetagFound = stateData.doSkillUsabilityRefresh
    
    # check if skill usability refresh should occur for all skill usability
    # impacting states if the state does impact skill usability, and if it
    # should mark that a refresh should happen
    if (stateImpactsSkillUsability == true)
      doStateSkillUsabilityRefresh = SURFS::DO_SKILL_USABILITY_REFRESH_FOR_ALL_STATES
    end
    
    # if the state should specially do a refresh,
    # mark that a refresh should happen
    if (skillUseRefreshNotetagFound == true)
      doStateSkillUsabilityRefresh = true
    end
    
    # if the battle is an actor, do not do the skill usability refresh
    # if it is not enabled for actors
    if (self.kind_of?(Game_Actor))
      if (SURFS::ACTOR_SKILL_USABILITY_REFRESH_ON == false)
        doStateSkillUsabilityRefresh = false
      end
    end
    
    # if the battle is an enemy, do not do the skill usability refresh
    # if it is not enabled for actors
    if (self.kind_of?(Game_Enemy))
      if (SURFS::ENEMY_SKILL_USABILITY_REFRESH_ON == false)
        doStateSkillUsabilityRefresh = false
      end
    end
    
    # if the state should be specially excluded from doing a refresh,
    # mark that a refresh should not happen
    if (skillUseRefreshExcludeNotetagFound == true)
      doStateSkillUsabilityRefresh = false
    end
    
    # Call original method (add the state)
    surfs_between_state_add_refresh_checks_and_changes(state_id)
    
    if (doStateSkillUsabilityRefresh == true)
      # trigger state skill usability refresh
      stateSkillUsabilityRefresh
    end
  end
  
  #--------------------------------------------------------------------------
  # * Erase States
  #--------------------------------------------------------------------------
  alias surfs_between_state_remove_refresh_checks_and_changes erase_state
  def erase_state(state_id)
    stateData = $data_states[state_id] # get state data
    
    # start new flag for triggering a state skill usability refresh as false
    doStateSkillUsabilityRefresh = false
    
    # check if skill usability refresh notetag found
    skillUseRefreshNotetagFound = stateData.doSkillUsabilityRefresh
    
    # if the state should specially do a refresh,
    # mark that a refresh should happen
    if (skillUseRefreshNotetagFound == true)
      doStateSkillUsabilityRefresh = true
    end
    
    # Call original method (remove the state)
    surfs_between_state_remove_refresh_checks_and_changes(state_id)
    
    if (doStateSkillUsabilityRefresh == true)
      # trigger state skill usability refresh
      stateSkillUsabilityRefresh
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to do skill usability refresh for battlers. Depending
  # * on the skill replacement settings, either the battler will be left
  # * with no action, or the battler will forcefully select a new action.
  #--------------------------------------------------------------------------
  def stateSkillUsabilityRefresh
    # first, check if the action(s) taken before is now impossible
    isOldActionImpossible = @actions.any? {|action| usable?(action.item) == false}
    
    if ((isOldActionImpossible == false) && self.kind_of?(Game_Enemy))
      # get any action list of RPG::ENEMY::ACTION objects from enemy
      enemyPossibleActionList = enemy.actions.select {|a| action_valid?(a)}
      # enemyPossibleActionSkillIDs starts as empty array
      enemyPossibleActionSkillIDs = []
      # get array of skillIDs from enemyPossibleActionList
      enemyPossibleActionList.each do |action|
        # add action skillID into the skillID list for possible actions
        enemyPossibleActionSkillIDs.push(action.skill_id)
      end
      
      # check if any action is invalid
      @actions.each do |action|
        # don't do anything if the action is not a skill
        if (action.item.is_a?(RPG::Skill))
          # get action skillID
          actionSkillID = action.item.id
          
          # if old action still possible, mark it as impossible if the action's
          # skillID is not in the enemyPossibleActionSkillIDs list
          if ((isOldActionImpossible == false) && (enemyPossibleActionSkillIDs.include?(actionSkillID) == false))
            isOldActionImpossible = true
          end
        end
      end
    end
    
    # do not do anything else unless the old action is no longer possible
    if (isOldActionImpossible == true)
      if (self.kind_of?(Game_Actor))
        # decide what to do for enemy skill usability refresh based on
        # the replacement mode
        if (SURFS::ACTOR_USABILITY_REPLACEMENT_MODE.downcase == "none")
          # just clear the actor's actions
          clear_actions
        elsif (SURFS::ACTOR_USABILITY_REPLACEMENT_MODE.downcase == "new")
          # start by clearing any of the actor's current actions
          clear_actions
          
          # start with the new skillID of the skill to use as the default
          # replacement skill
          newSkillID = SURFS::ACTOR_DEFAULT_REPLACEMENT_SKILL
          
          # get the actor's id
          actorID = self.id
          
          # if there is a specific replacement skill set for the actor
          # based on the actorID, then set the newSkillID to the
          # specific new skillID.
          if (SURFS::ACTOR_REPLACEMENT_SKILLS.has_key?(actorID))
            newSkillID = SURFS::ACTOR_REPLACEMENT_SKILLS[actorID]
          end
          
          # get new empty actions list based on amount of action times
          @actions = Array.new(make_action_times) { Game_Action.new(self) }
          
          # fully set up the new skill as the actor's action
          # (it will automatically test to make sure the new skill
          # is possible in evauluate())
          @actions.each do |action|
            action.set_skill(newSkillID).evaluate
          end
        end
      
      elsif (self.kind_of?(Game_Enemy))
        # decide what to do for enemy skill usability refresh based on
        # the replacement mode
        if (SURFS::ENEMY_USABILITY_REPLACEMENT_MODE.downcase == "none")
          # just clear the enemy's actions
          clear_actions
        elsif (SURFS::ENEMY_USABILITY_REPLACEMENT_MODE.downcase == "new")
          # select a new action from the enemy's available actions
          make_actions
        end
      end
      
    end
    
  end
  
end

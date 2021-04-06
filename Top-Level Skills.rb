# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-TopLevelSkills"] = true
# END OF IMPORT SECTION

# Script:           Top-Level Skills
# Author:           Liam
# Version:          1.1.1
# Description:
# This script is made for allowing new skills from the skill database 
# to be added to the 'top-level' menu (aka the menu command list)
# in battle. For clarification, this is the menu that normalls has skills like:
# 'attack', 'guard', etc.
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
# Use this script by adding actor IDs, skill menu names, and skill IDs
# to the lists below. Each skill added should have its attributes
# (actor ID, skill name, skill ID) in the same place in each of the three lists.
#  
# Note 1: New skills will be placed in the menu after the 'attack' and 'skill'
# menu options in the order that you enter them into the lists.
#
# Note 2: These skills should not consume MP or TP. The normal skill menu
# is properly built to handle those skills.
#
#   Example:
# NEW_SKILL_ACTORS =     [2,         1,                2                       ]
# NEW_SKILL_NAMES  =     ["test1",   "example1",       "test2"                 ]
# NEW_SKILL_IDS    =     [57,        15,               60                      ]
#
# Using the above lists will result in the following topskill menus:
# Actor w/ ID 1 topskill menu-
# attack
# skill
# example1 (will use skill w/ ID 15 in database)
# guard
# item
#
# Actor w/ ID 2 topskill menu-
# attack
# skill
# test1 (will use skill w/ ID 57 in database)
# test2 (will use skill w/ ID 60 in database)
# guard
# item
#
#
# __Modifiable Constants__
module TLSKILLS
  # Modify these lists to add your new topskills. Make sure the positions
  # in the lists correspond.
  
  # list of actor IDs for the new skills
  NEW_SKILL_ACTORS =     [2]
  # list of names shown in the menu for the new skills
  NEW_SKILL_NAMES  =     ["Inspect"]
  # list of skill IDs for the new skills
  NEW_SKILL_IDS    =     [57]
  
  # __END OF MODIFIABLE CONSTANTS__
end



# BEGINNING OF SCRIPTING ====================================================
class Game_Action
  #--------------------------------------------------------------------------
  # * New method used to set the skill up in Game_Action using a
  # * skillID parameter.
  #--------------------------------------------------------------------------
  def set_new_skill(skillID)
    set_skill(skillID)
    # returns itself
    self
  end
	
end


class Window_Selectable < Window_Base
  #--------------------------------------------------------------------------
  # * Overriden call_handler() method, overriden to add the new skills into
  # * the handler list. symbol parameter stores 
  #--------------------------------------------------------------------------
  def call_handler(symbol)
    # save the passed symbol method as a string to check if it is "newCommand"
    symbolString = symbol.to_s
    
    # placeholder value for the firstGenericIndex, the index of the command
    # menu where generic skills start
    firstGenericIndex = 0
    # if the passed method is for newCommand, use the handler call with
    # the parameter to pass in the index for the 3 module lists
    if (symbolString == "newCommand")
      # if the selection options are part of a window command list, then
      # find the first generic skill index
      if (self.kind_of?(Window_Command))
        # need to find the index of the first generic skill in the command list
        firstGenericIndexFound = false # once found, flag flips to true
        # go through the list until the first generic skill is found, then
        # save that index.
        @list.each_with_index do |listEntry, index|
          # if the symbol of the command list entry matches the one selected,
          # and the first generic index is already found, then mark the
          # current index as the first generic index.
          if (!firstGenericIndexFound && listEntry[:symbol] == symbol)
            firstGenericIndexFound = true
            firstGenericIndex = index
          end
        end
      end
      
      # selection in UI menu cursor index minus the first generic index
      # note: remember, indexes are lists starting at 0
      actorNewSkillIndex = @index - firstGenericIndex
      finalSkillIndex = 0 # 0 is a placeholder value
      # whether or not the final index in the 3 module lists is found
      finalIndexFound = false
      
      # get current actor from the global variable in the make_command_list function
      currActor = $currBattleActorID
      # index starts at -1 because for the index to start at 0, 1 
      # skill for the current actor must be found
      currActorSkillIndex = -1
      # iterate throught the actor ID list and search for the
      # correct index in the 3 modules
      TLSKILLS::NEW_SKILL_ACTORS.each_with_index do |actorID, index|
        # if a skill in the actor IDs list is found then increase the index
        # for all new skills the actor has
        if (actorID == currActor)
          currActorSkillIndex += 1
        end
        # if the final index in the 3 modules lists not yet found,
        # and the current actorSkillIndex matches the desired index
        # based off the the cursor index, then mark the index as found
        # and use the current 'index' value in the actor IDs list
        # as the final index to use
        if ((!finalIndexFound)&& (currActorSkillIndex == actorNewSkillIndex))
          finalSkillIndex = index
          finalIndexFound = true
        end
      end
      # get the skillID for the generic skill to be used that will get
      # used as a parameter for the command_newCommand(skillID) method
      skillIDtoUse = TLSKILLS::NEW_SKILL_IDS[finalSkillIndex]
      # handler call using the finalSkillIndex as a parameter for the
      # command_newCommand(skillID) method
      @handler[symbol].call(skillIDtoUse) if handle?(symbol)
      
    else
      # normal/old handler call
      # note: the 'if handle?' checks if the symbol is in the handler list
      @handler[symbol].call if handle?(symbol)
    end
  end
  
end


class Window_Command < Window_Selectable  
  #--------------------------------------------------------------------------
  # * New method, similar to add_command() method used to add skillID
  # * into the @list hash. skillID is not currently used, but it provides options
  # * for future functionality,
  #--------------------------------------------------------------------------
  def add_command_new(skillID, name, symbol, enabled = true, ext = nil)
    @list.push({:skillID=>skillID, :name=>name, :symbol=>symbol, :enabled=>enabled, :ext=>ext})
  end
end


class Window_ActorCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Overriden make_command_list() used to add the new skill commands
  # * into the actor's topskill menu window in between the skill command(s)
  # * and the guard command.
  #--------------------------------------------------------------------------
  def make_command_list
    return unless @actor
    # GLOBAL VARIABLE for accessing actor id in the Window_Selectable class
    # not ideal to use global variable for this, but not sure of a better way
    $currBattleActorID = BattleManager.actor.id
    add_attack_command
    add_skill_commands
    
    # iterate through the new skill IDs list, and add the new skills
    # to whichever actor is active
    TLSKILLS::NEW_SKILL_IDS.each_with_index do |element, index|
      # check if current actor matches the skill being looked at in the
      # 3 modules
      if BattleManager.actor.id == TLSKILLS::NEW_SKILL_ACTORS[index]
        # the third parameter is the usability of the skill, which is just assumed true here
        # may change that in the future
        add_command_new(index, TLSKILLS::NEW_SKILL_NAMES[index], :newCommand, true)
      end
    end
    
    add_guard_command
    add_item_command
  end
  
  #--------------------------------------------------------------------------
  # * New method, similar to other ones that get a skillId for a specific
  # * skill, but is more generic, using an index parameter. Not currently
  # * used.
  #--------------------------------------------------------------------------
  def command_skill_id(index)
    @list[index][:skillID]
  end
  
end


class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Overridden create_actor_command_window() method used to add the
  # * generic command_newCommand handler to the hash of handlers.
  #--------------------------------------------------------------------------
  def create_actor_command_window
    @actor_command_window = Window_ActorCommand.new
    @actor_command_window.viewport = @info_viewport
    @actor_command_window.set_handler(:attack, method(:command_attack))
    @actor_command_window.set_handler(:skill,  method(:command_skill))

    # add generic window handler for all new commands
    # (window handler stores a hash w/ :newCommand symbol as the key for
    # the command_newCommand() method)
    @actor_command_window.set_handler(:newCommand, method(:command_newCommand))
	
    @actor_command_window.set_handler(:guard,  method(:command_guard))
    @actor_command_window.set_handler(:item,   method(:command_item))
    @actor_command_window.set_handler(:cancel, method(:prior_command))
    @actor_command_window.x = Graphics.width
  end
  
  #--------------------------------------------------------------------------
  # * New method, used for generically getting the skill information from
  # * the database by using the passed skillID parameter.
  # * Similar to other methods in Scene_Battle specific to certain skills.
  #--------------------------------------------------------------------------
  def command_newCommand(skillID)
    # get the current skill's data
    currSkill = $data_skills[skillID] # $data_skills[BattleManager.actor.attack_skill_id]
    # if the yanfly battle engine is imported then do an extra line
    # so the engine processes the skill correctly
    if ($imported["YEA-BattleEngine"])
      $game_temp.battle_aid = $data_skills[skillID]
    end
    
    # Set the potential skill according to the skillID
    BattleManager.actor.input.set_new_skill(skillID)
    # If the current skill needs an enemy/ally selection, immediately
    # finalize the command.
    # If the current skill is for enemies, go to enemy selection.
    # Otherwise, go to actor selection.
    if (!currSkill.need_selection?)
      next_command
    elsif (currSkill.for_opponent?)
      select_enemy_selection
    else
      select_actor_selection
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased on_enemy_cancel() method used to handle canceling out of
  # * generic command skill enemy targeting.
  #--------------------------------------------------------------------------
  alias tls_before_new_generic_enemy_cancel_handling on_enemy_cancel
  def on_enemy_cancel
    tls_before_new_generic_enemy_cancel_handling # call original method
    
    # if the current command is a new generic command, go back to the
    # actor command window
    if (@actor_command_window.current_symbol == :newCommand)
      @actor_command_window.activate
    end
  end

  #--------------------------------------------------------------------------
  # * Aliased on_actor_cancel() method used to handle canceling out of
  # * generic command skill actor targeting.
  #--------------------------------------------------------------------------
  alias tls_before_new_generic_actor_cancel_handling on_actor_cancel
  def on_actor_cancel
    tls_before_new_generic_actor_cancel_handling # call original method
    
    # if the current command is a new generic command, go back to the
    # actor command window
    if (@actor_command_window.current_symbol == :newCommand)
      @actor_command_window.activate
      
      # if the yanfly battle engine is imported then do two extra line
      # so the battle UI is navigated correctly
      if ($imported["YEA-BattleEngine"])
        @status_window.refresh
        @status_window.show
      end
    end
  end
  
end
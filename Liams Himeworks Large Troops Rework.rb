# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-HimeLargeTroopsRework"] = true
# END OF IMPORT SECTION

# ------------------- ! REQUIRES 'EXTRA SAVE DATA' SCRIPT ! -------------------
# Script:           Liam's Himeworks Large Troops Rework
# Original Author:  Himeworks
# Rework Author:    Liam
# Version:          1.0
# Description:
# This script rewrite of Himeworks' Large Troops script changes the handling
# of troop event pages for troops which extend a parent/host troop.
# This rewrite fixes some existing issues with the original script such as
# failing to account for particular event commands and the troop event page
# conditionals. It does this by ensuring the correct enemy troop members are
# dealt with in extended troop event pages. This script rewrite also makes script
# calls in extended troop events sourced from other scripts work correctly.
#
# Feel free to use this script however you like, commercial or not, as long
# as you credit me. Just 'Liam' is fine. Note that this script rework is still
# built off of the original Himeworks Large Troops scripts, so the license
# it uses will still apply to your game as well.
# You can see Himework's license here: https://himeworks.com/terms-of-use/
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
# To use this script, place it somewhere in your scripts list, ideally somewhere
# lower on the list rather than higher. Make sure you have the Extra Save Data
# script also by Liam from the Github link above if you do not have it already.
# Then, set up the single script setting added in the rework,
# INIT_EXTENDED_TROOP_HANDLING_METHOD, which is explained by comments next
# to that setting.
#
# Important Note 1: Make sure you have removed the original Himework's Large
# Troops script! This is a script REPLACEMENT and NOT an add-on!
# Otherwise, the script will NOT FUNCTION!
#
# Important Note 2: The information on the usage of the original script is
# preserved further down below in script below the rework-based information
# and settings.
#
# __Modifiable Constants__
module HLTR
  # This setting determines what the event commands in extended troop events
  # "consider" the troop members list to be when they execute. Event pages
  # from the host/parent troop will be unaffected by this setting and work
  # as normal (meaning you can still access extended troop members from
  # host/parent troop event pages).
  #
  # There are two methods of determining what extended troop event pages
  # recognize as the enemy troop member list:
  # Method 1 -
  #   Have the extended troop event page treat the members list it recognizes as
  #   the whole of the "host/parent troop" BUT with the order of the enemies
  #   swapped so that the enemies from the extended troop that is running will
  #   come first. The rest of the troops will be in their standard order after
  #   them. The benefit of this method is that if you have an event command that
  #   is meant to affect ALL enemies in an extended troop page, it will indeed
  #   affect ALL enemies in the troop, rather than just the ones in the
  #   extended troop.
  #
  # Method 2 -
  #  Have the extended troop event page treat the troop it recognizes as
  #  JUST the extended troop. This means that if an extended troop event
  #  page has an event command that is meant to affect ALL enemies, it will
  #  ONLY affect all of the extended troop enemies and not the rest of the
  #  troop members. You may want to use this method if this method makes
  #  more sense to you, or you may want to use it temporarily to make an
  #  "all enemies" attack affect just the extended troop.
  #
  # The value of this setting must be either 1 or 2. Those numbers
  # correspond to method 1 and 2.
  #
  # You can change the value of this setting during gameplay runtime
  # using the script call:
  #   set_hltr_extended_troop_handling(newHandlingVal)
  # where newHandlingVal is either 1 or 2
  # Example:
  #   set_hltr_extended_troop_handling(1)
  INIT_EXTENDED_TROOP_HANDLING_METHOD = 1
  
  # __END OF MODIFIABLE CONSTANTS__
end
  
  
  
#===============================================================================
# __ORIGINAL DESCRIPTION (Edited slightly for accuracy to the rework)__
# Title: Large Troops
# Author: Hime
# Editor: Liam
# Date: Mar 9, 2013
# Source: 
#
#--------------------------------------------------------------------------------
# ** Change log
# Mar 9, 2013
#   - Initial release
#--------------------------------------------------------------------------------   
# ** Himework's Original Terms of Use (These still apply)
# * Free to use in non-commercial projects
# * Contact me for commercial use (NOTE: Himeworks has since updated this
# * policy as per their website, and no longer requires contact for commercial
# * use, although they would still appreciate it)
# * No real support. The script is provided as-is
# * Will do bug fixes, but no compatibility patches
# * Features may be requested but no guarantees, especially if it is non-trivial
# * Credits to Hime Works in your project
# * Preserve this header
# * MOST RECENT FULL LICENSE TEXT HERE: https://himeworks.com/terms-of-use/
#--------------------------------------------------------------------------------
# ** Description
# 
# This script combines multiple troops into a single troop.
# You will still set them up as separate troops, but at run-time they will
# be merged together.
# 
# All events will be merged and updated as required.
# 
#--------------------------------------------------------------------------------
# ** Usage (Edited for clarity with the rework)
# 
# Create a comment on the first page of the troop events with the following text:
# 
#   <parent troop: x>
#   
# Where x is the ID of the troop that the notetagged troop should extend.
# The troop with ID x will become the host/parent troop, and the notetagged
# troop will be the extended troop.
# All of the enemies and event pages will be merged.
# 
# You can set up the troop events as you normally do without having to worry
# about indexing. The only thing you need to worry about is where to place
# the sprites.
#
# One host/parent troop can be extended with multiple other troops.
# 
#===============================================================================



# The line below marks the start of the unedited original script
# created by Himeworks. It is preserved here unchanged.
# Further below is a line marking the end of the original script by Himeworks.
# BEGINNING OF ORIGINAL SCRIPTING STARTS HERE ==================================

$imported = {} if $imported.nil?
$imported["TH_LargeTroops"] = true
#===============================================================================
# ** Configuration
#===============================================================================
module TH
  module Large_Troops
    
    Regex = /<parent troop: (\d+)/i
  end
end


#===============================================================================
# ** Rest of Script
#===============================================================================
module RPG
  class Troop
    #---------------------------------------------------------------------------
    # New. Merges the other troop with this troop
    #---------------------------------------------------------------------------
    def add_extended_troop(troop)
      add_extended_pages(troop)
      @members.concat(troop.members)
    end
    
    #---------------------------------------------------------------------------
    # New. Merge other troop's pages with this troop
    #---------------------------------------------------------------------------
    def add_extended_pages(troop)
      new_pages = setup_extended_pages(troop.pages)
      @pages.concat(new_pages)
    end
    
    #---------------------------------------------------------------------------
    # New. Update all indices in enemy-related commands to point to the correct 
    # member when they are added to the troop
    #---------------------------------------------------------------------------
    def setup_extended_pages(pages)
      # MAJOR SCRIPT REWORK EDIT BELOW:
      # Enemy troop member offsets no longer used since the troop members
      # are being rearranged as necessary instead of modifying the individual
      # enemy members being dealt with in individual commands.
      #
      # For this reason, the original contents of this function are removed
      # and instead the original set of event pages are returned.
      
      return pages
    end
  end
  
end


module DataManager
  class << self
    alias :th_large_troops_load_database :load_database
  end
  
  def self.load_database
    th_large_troops_load_database
    load_large_troops
  end
  
  #-----------------------------------------------------------------------------
  # New. Setup all extended troops
  #-----------------------------------------------------------------------------
  def self.load_large_troops
    $data_troops.each {|troop|
      next unless troop
      troop.pages[0].list.each {|cmd|
        if cmd.code == 108 && cmd.parameters[0] =~ TH::Large_Troops::Regex
          $data_troops[$1.to_i].add_extended_troop(troop)
        end
      }
    }
  end
  
end



# END OF ORIGINAL SCRIPTING ====================================================

# Beyond this line is the new scripting for the rework by Liam.
# BEGINNING OF REWORK SCRIPTING ================================================

# EVERYTHING BELOW THIS POINT IS NEWLY-EDITED STUFF DONE FOR THE REWORK!
class Game_Troop < Game_Unit
  # New variable used to temporarily mark when an extended troop event page
  # condition is being checked, and if one is being checked, exactly what
  # the source extended troopID is.
  #
  # Will be set to -1 as a placeholder value when there is no current source
  # extended troop for a troop event page condition being checked.
  attr_accessor :hltr_currently_checking_external_ev_page_cond_src_troop_id
  
  #--------------------------------------------------------------------------
  # * Aliased initialize() method for the Game_Troop class used to mark
  # * that a troop event page condition from an extended troop event
  # * is not currently being checked when the troop is initialized.
  #--------------------------------------------------------------------------
  alias hltr_before_troop_cond_checker_init initialize
  def initialize
    # Call original method
    hltr_before_troop_cond_checker_init
    
    # mark that a troop event page condition from an external event page
    # is currently not being checked by setting the external source troop id
    # to -1 as a placeholder value
    @hltr_currently_checking_external_ev_page_cond_src_troop_id = -1
  end
  
  #--------------------------------------------------------------------------
  # * Aliased setup() method for the Game_Troop class used to mark
  # * the enemies from extended troops as coming from particular extended
  # * troops using the source troopIDs.
  #--------------------------------------------------------------------------
  alias hltr_before_game_enemy_ext_troop_marking setup
  def setup(troop_id)
    # Call original method
    hltr_before_game_enemy_ext_troop_marking(troop_id)
    
    # start the index for @enemies at 0
    enemyIndex = 0
    troop.members.each do |member|
      # skip if not valid enemy
      next unless $data_enemies[member.enemy_id]
      
      # if the troop member was originally from an extended troop (-1 means
      # not from extended troop),
      # mark what troop that is on the associated enemy
      if (member.hltr_mem_extended_troop_src_id != -1)
        @enemies[enemyIndex].hltr_enemy_src_extended_troop_id = member.hltr_mem_extended_troop_src_id
      end
      
      # increment enemyIndex (will be skipped if the troop memeber wasn't added)
      enemyIndex += 1
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * New helper method for Game_Troop class used to get the full troop member
  # * list including the host/main troops enemies, plus the extended troop's
  # * enemies. In this enemy list, the extended troop being dealt with in
  # * particular (the parameter) will be placed at the beginning of the list
  # * for the purpose of troop events which target specific enemy indexes.
  # * Returns an array of enemies.
  #--------------------------------------------------------------------------
  def hltr_get_full_extended_troop_member_list(extSrcTroopID)
    # start by getting the troop members from the specified extended
    # source troop and all of the other members separately.
    troopMembersExcludingExtTroop = []
    extendedTroopMembers = []
    @enemies.each do |enemy|
      # if the enemy is not from the specified extended source troop,
      # then add it to the troopMembersExcludingExtTroop array
      #
      # otherwise, add it to the extendedTroopMembers array
      if (enemy.hltr_enemy_src_extended_troop_id != extSrcTroopID)
        troopMembersExcludingExtTroop.push(enemy)
      else
        extendedTroopMembers.push(enemy)
      end
    end
    
    # implicitly return the new troop list with the specific extended
    # source troop members first
    troopMembersWithExtendedTroopFirst = extendedTroopMembers.concat(troopMembersExcludingExtTroop)
  end
  
  #--------------------------------------------------------------------------
  # * New helper method for Game_Troop class used to get ony a particular
  # * extended troop's list of enemies.
  # * Returns an array of enemies.
  #--------------------------------------------------------------------------
  def hltr_get_only_extended_troop_member_list(extSrcTroopID)
    extendedTroopMembers = []
    @enemies.each do |enemy|
      # if the enemy is from the specified extended source troop,
      # add it to the extendedTroopMembers array
      if (enemy.hltr_enemy_src_extended_troop_id == extSrcTroopID)
        extendedTroopMembers.push(enemy)
      end
    end
    
    # implicitly return the new troop list with only the extended troop members
    extendedTroopMembers
  end
  
  #--------------------------------------------------------------------------
  # * Aliased members() function in Game_Troop used to change the list of
  # * members that is returned to properly account for extended troop
  # * event pages that were added to the parent/host troop.
  # *
  # * NOTE: I am well aware that using `caller` like this is extremely
  # * hacky and NOT AT ALL "good" programming design, but the original
  # * script was unable to account for a lot of things (like any missed
  # * event commands did not have member offsets, as well as any script calls
  # * added to Game_Interpreter by other scripts). This is a very hacky,
  # * imperfect solution that could be avoided by rewriting a ton of code,
  # * but that could cause many script incompatibilities with other scripts,
  # * so I decided to write it like this, as painful as it is.
  #--------------------------------------------------------------------------
  alias hltr_orig_getting_enemies_line members
  def members
    # only line of original method (@enemies implicit return) -> @enemies
    # Call original method, store them as the original enemies of the troop
    # which will be returned implicitly like normal if no special
    # members list switching actions take place
    hltr_orig_enemies = hltr_orig_getting_enemies_line
    
    # start with finalEnemyMemberList as being the original enemies
    finalEnemyMemberList = hltr_orig_enemies
    
    # check if the troop event page that is running is from
    # an extended troop originally, if it is, then do checking
    # for if the method that ran came from the Game Interpreter
    # then switch around the member lists
    if (@interpreter.hltr_is_curr_ev_com_from_extended_troop == true)
      # regex to seperate the method name from the set of method info
      # the caller() method returns
      callerMethodRegex = /:in `(.*)'/
    
      # get the method name of the method that called this method (the members() method)
      # AND the method name of the method that called the method that called this method
      firstCallerMethodInfo = caller[0]
      secondCallerMethodInfo = caller[1]
      firstCallerMethodName = "" # start with placeholder val
      secondCallerMethodName = "" # start with placeholder val
      if (firstCallerMethodInfo =~ callerMethodRegex)
        # get first caller method name from regex var
        firstCallerMethodName = $1
      end
      if (secondCallerMethodInfo =~ callerMethodRegex)
        # get second caller method name from regex var
        secondCallerMethodName = $1
      end
      
      # check if the first and second caller methods are both from the
      # game interpreter, if they are, the first caller method is ALMOST certainly
      # from Game_Interpreter and not another class with a shared method name
      firstAndSecondCallersFromGameInterp = false # start with placeholder val of false
      # check if first and second caller method are present in the game interpreter
      if (Game_Interpreter.method_defined?(firstCallerMethodName) && Game_Interpreter.method_defined?(secondCallerMethodName))
        firstAndSecondCallersFromGameInterp = true
      end
      
      # check if calling method is a method from Game_Interpreter,
      # if it is, then switch the member list to start with
      # the proper extended troops being first
      if (firstAndSecondCallersFromGameInterp == true)
        # get the troopID of the external troop being dealt with
        # from the stored value in the game interpreter
        extSrcTroopID = @interpreter.hltr_get_curr_ev_com_ext_troop_id_val
        
        # get the proper extended troop member list depending on whether
        # the original troop members should be included after the extended
        # troop member list or not in the final enemy member list that is returned
        # according to the current extended troop handling method setting
        extTroopMemHandlingMethod = $game_party.getExSaveData("hltrExtendedTroopHandling", HLTR::INIT_EXTENDED_TROOP_HANDLING_METHOD)
        case extTroopMemHandlingMethod
          # if handling method of 1, include the original troop members
          when 1
            finalEnemyMemberList = hltr_get_full_extended_troop_member_list(extSrcTroopID)
          # if handling method of 2, just have the extended troop members
          when 2
            finalEnemyMemberList = hltr_get_only_extended_troop_member_list(extSrcTroopID)
          # get full extended troop list if invalid number
          else
            finalEnemyMemberList = hltr_get_full_extended_troop_member_list(extSrcTroopID)
        end

      end
      
    end
    
    # check if currently checking a troop event page conditions from
    # an external source, if this is the case, do further checks to see
    # if the conditional check method was the caller of this method (members())
    #
    # -1 is the placeholder value for "not currently checking external troop
    # event page condition", so if the value is not -1, then the checks
    # should continue
    if (@hltr_currently_checking_external_ev_page_cond_src_troop_id != -1)
      # regex to seperate the method name from the set of method info
      # the caller() method returns
      callerMethodRegex = /:in `(.*)'/
      
      # get the method name of the method that called this method (the members() method)
      firstCallerMethodInfo = caller[0]
      firstCallerMethodName = "" # start with placeholder val
      if (firstCallerMethodInfo =~ callerMethodRegex)
        # get first caller method name from regex var
        firstCallerMethodName = $1
      end
      
      # if the method is the conditions_met?() method, then switch the
      # member lists to start with the proper extended troops being first
      if (firstCallerMethodName == "conditions_met?")
        # get the troopID of the external troop being dealt with
        # from the stored value
        extSrcTroopID = @hltr_currently_checking_external_ev_page_cond_src_troop_id
        
        # get the proper extended troop member list depending on whether
        # the original troop members should be included after the extended
        # troop member list or not in the final enemy member list that is returned
        # according to the current extended troop handling method setting
        extTroopMemHandlingMethod = $game_party.getExSaveData("hltrExtendedTroopHandling", HLTR::INIT_EXTENDED_TROOP_HANDLING_METHOD)
        case extTroopMemHandlingMethod
          # if handling method of 1, include the original troop members
          when 1
            finalEnemyMemberList = hltr_get_full_extended_troop_member_list(extSrcTroopID)
          # if handling method of 2, just have the extended troop members
          when 2
            finalEnemyMemberList = hltr_get_only_extended_troop_member_list(extSrcTroopID)
          # get full extended troop list if invalid number
          else
            finalEnemyMemberList = hltr_get_full_extended_troop_member_list(extSrcTroopID)
        end

      end
    end
    
    # return finalEnemyMemberList implicitly
    finalEnemyMemberList
  end
  
  #--------------------------------------------------------------------------
  # * Aliased conditions_met?() for the Game_Troop class used to temporarily
  # * mark when an extended troop event page condition is being checked,
  # * and if one is being checked, exactly what the source extended troopID is.
  # * Returns the the number of the extended troop event source of the
  # * condition being checked if there is one, otherwise returns -1 as
  # * a placeholder value if there is not one.
  #--------------------------------------------------------------------------
  alias hltr_orig_conds_met_checking conditions_met?
  def conditions_met?(page)
    # set the condition external troop event page source id to the
    # appropraite one from the given page
    @hltr_currently_checking_external_ev_page_cond_src_troop_id = page.hltr_pg_extended_troop_src_id
    
    # Call original method and store the value
    origCondResult = hltr_orig_conds_met_checking(page)
    
    # mark that no longer checking an external condition by returning
    # hltr_currently_checking_external_ev_page_cond_src_troop_id
    # to the placeholder value of -1
    @hltr_currently_checking_external_ev_page_cond_src_troop_id = -1
    
    # return the original result unchanged
    return (origCondResult)
  end
  
end


class Game_Interpreter
  #--------------------------------------------------------------------------
  # * New helper method used to determine if the game interpreter is running
  # * a command which is originally from an extended troop. Returns the
  # * true or false.
  #--------------------------------------------------------------------------
  def hltr_is_curr_ev_com_from_extended_troop
    # immediately return false if interpreter not running
    return false if (!running?)
    # immediately return false if list not setup
    return false if (@list.nil?)
    # immediately return false if event data does not exist
    return false if (@list[@index].nil?)
    
    # -1 is default "external troop id" for the troop event command
    # if it is NOT from an external troop
    #
    # so, it IS from an external troop if the value of hltr_ev_com_from_ext_troop_id
    # is not 1
    return (@list[@index].hltr_ev_com_from_ext_troop_id != -1)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to return the troopID of the extended troop the event
  # * command that is running was originally sourced from.
  # *
  # * NOTE: This method will crash if it has not been ensured that the
  # * interpreter is actually running, so
  # * hltr_is_curr_ev_com_from_extended_troop() should be checked (and true)
  # * before this method is ran.
  #--------------------------------------------------------------------------
  def hltr_get_curr_ev_com_ext_troop_id_val
    return(@list[@index].hltr_ev_com_from_ext_troop_id)
  end
  
end


class RPG::Troop
  # New variable hash which stores troop member lists for troops which were
  # used to extend the current (host) troop.
  attr_accessor :hltr_extended_troop_member_lists
  
  #---------------------------------------------------------------------------
  # * Aliased initialize() for the RPG::Troop class used to setup the hash
  # * storing extended troop member lists as an empty hash.
  #---------------------------------------------------------------------------
  alias hltr_before_ext_troop_member_lists_init initialize
  def initialize
    # Call original method
    hltr_before_ext_troop_member_lists_init
    
    # set up extended troop member lists hash as empty hash
    @hltr_extended_troop_member_lists = {}
  end
  
  #---------------------------------------------------------------------------
  # * Aliased add_extended_troop() for the RPG::Troop class used to
  # * save an given extended troop member list in the main/host troop
  # * data object.
  #---------------------------------------------------------------------------
  alias hltr_before_ext_troop_members_save add_extended_troop
  def add_extended_troop(troop)    
    # save original length of troop members list
    troopMembersOrigLength = @members.length
    
    # only lines of original method below:
    #add_extended_pages(troop)
    #@members.concat(troop.members)
    
    # Call original method
    hltr_before_ext_troop_members_save(troop)
    
    # start member index as original length before new troop members added
    troopMemberIndex = troopMembersOrigLength
    # while troop member index is less than the new troop member array length,
    # mark the troop member as coming from the given extended source troopID
    while (troopMemberIndex < @members.length)
      # set page's hltr_mem_extended_troop_src_id to the given source troopID
      @members[troopMemberIndex].hltr_mem_extended_troop_src_id = troop.id
      
      # increment troopMemberIndex
      troopMemberIndex += 1
    end
    
    # initialize hltr_extended_troop_member_lists hash in case it's nil
    if (@hltr_extended_troop_member_lists.nil?)
      @hltr_extended_troop_member_lists = {}
    end
    
    # save the extended troop using the extended troopID as the key,
    # and the member list as the value
    @hltr_extended_troop_member_lists[troop.id] = troop.members
  end
  
  #---------------------------------------------------------------------------
  # * Aliased add_extended_pages() for the RPG::Troop class used to
  # * save additional information related to the source extended troopID
  # * for each extended troop event page.
  #---------------------------------------------------------------------------
  alias hltr_before_ev_page_ext_troop_src_id_save add_extended_pages
  def add_extended_pages(troop)
    
    # save original length of pages
    pagesOrigLength = @pages.length
    
    # only lines of original method below
    #new_pages = setup_extended_pages(troop.pages)
    #@pages.concat(new_pages)
    
    # Call original method
    hltr_before_ev_page_ext_troop_src_id_save(troop)
    
    # start page index as original length before new pages added
    pageIndex = pagesOrigLength
    # while page index is less than the new page length,
    # mark the pages as coming from the given extended source troopID
    while (pageIndex < @pages.length)
      # set page's hltr_pg_extended_troop_src_id to the given source troopID
      @pages[pageIndex].hltr_pg_extended_troop_src_id = troop.id
      
      # also mark each eventCommand in the event page list as from an
      # extended troop
      @pages[pageIndex].list.each do |eventCommand|
        eventCommand.hltr_ev_com_from_ext_troop_id = troop.id
      end
      
      # increment pageIndex
      pageIndex += 1
    end
    
  end
  
end


class RPG::Troop::Page
  # New variable which stores the troopID of the extended troop that the
  # troop event page object data object originally came from.
  #
  # Will be set to -1 as a placeholder value if the page is not from
  # an extended troop.
  attr_accessor :hltr_pg_extended_troop_src_id
  
  #---------------------------------------------------------------------------
  # * Aliased initialize() for the RPG::Troop::Page class used to initialize
  # * the variable storing the extended troop event page source troopID
  # * for the troop event page to -1 as a placeholder value for the page not
  # * being from an extended troop. Will be updated to the proper extended
  # * troopID later if appropriate.
  #---------------------------------------------------------------------------
  alias hltr_before_ext_troop_flag_init initialize
  def initialize
    # Call original method
    hltr_before_ext_troop_flag_init
    
    # initialize the extended troop source troopID for the troop event page as
    # -1 as a value marking that it is not from an extended troop,
    # other methods may change the value later
    @hltr_pg_extended_troop_src_id = -1
  end
end


class RPG::EventCommand
  # New variable which stores the troopID of the extended troop that the
  # event command data object originally came from.
  #
  # Will be set to -1 as a placeholder value if the event command is not from
  # an extended troop.
  attr_accessor :hltr_ev_com_from_ext_troop_id
  
  #---------------------------------------------------------------------------
  # * Aliased initialize() for the RPG::EventCommand class used to initialize
  # * the variable storing the extended troop event page source troopID
  # * for the event command to -1 as a placeholder value for the event command not
  # * being from an extended troop. Will be updated to the proper extended
  # * troopID later if appropriate.
  #---------------------------------------------------------------------------
  alias hltr_before_ev_com_ext_troop_flag_init initialize
  def initialize(code = 0, indent = 0, parameters = [])
    # Call original method
    hltr_before_ev_com_ext_troop_flag_init(code, indent, parameters)
    
    # initialize the extended troop source troopID for the event command as
    # -1 as a value marking that it is not from an extended troop,
    # other methods may change the value later
    @hltr_ev_com_from_ext_troop_id = -1
  end
end


class RPG::Troop::Member
  # New variable which stores the troopID of the extended troop that the
  # troop member data object originally came from.
  #
  # Will be set to -1 as a placeholder value if the troop member is not from
  # an extended troop.
  attr_accessor :hltr_mem_extended_troop_src_id
  
  #---------------------------------------------------------------------------
  # * Aliased initialize() for the RPG::Troop::Member class used to initialize
  # * the variable storing the extended troop event page source troopID
  # * for the troop member data object to -1 as a placeholder value for the
  # * troop member data object not being from an extended troop. Will be updated
  # * to the proper extended troopID later if appropriate.
  #---------------------------------------------------------------------------
  alias hltr_after_orig_troop_mem_data_init initialize
  def initialize
    # Call original method
    hltr_after_orig_troop_mem_data_init
    
    # initialize the extended troop source troopID for the troop member as
    # -1 as a value marking that it is not from an extended troop,
    # other methods may change the value later
    @hltr_mem_extended_troop_src_id = -1
  end
end


class Game_Enemy < Game_Battler
  # New variable which stores the troopID of the extended troop that the
  # enemy originally came from.
  #
  # Will be set to -1 as a placeholder value if the enemy is not from
  # an extended troop.
  attr_accessor :hltr_enemy_src_extended_troop_id
  
  #--------------------------------------------------------------------------
  # * Aliased initialize() for Game_Enemy used to initialize the value that
  # * tracks the extended troop the Enemy came from. -1 is the initial value
  # * which is used as a placeholder to denote that the Enemey is NOT from
  # * an extended troop.
  #--------------------------------------------------------------------------
  
  #---------------------------------------------------------------------------
  # * Aliased initialize() for the Game_Enemy class used to initialize
  # * the variable which tracks the source extended troop troopID of the extended
  # * troop the enemy originally came from. It initializes the value to -1 as
  # * a placeholder value marking that the enemy is not from an extended troop.
  # * The variable's value will be be updated to the proper extended troopID
  # * later if appropriate.
  #---------------------------------------------------------------------------
  alias hltr_before_ext_src_troop_init initialize
  def initialize(index, enemy_id)
    # Call original method
    hltr_before_ext_src_troop_init(index, enemy_id)
    
    # start with hltr_enemy_src_extended_troop as -1 to mark that
    # the enemy is not from any extended troop
    @hltr_enemy_src_extended_troop_id = -1
  end
end


class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Wrapper method used to change how extended troop event pages are handled
  # * with a simple script call
  # * 
  # * Methods
  # * 1 - Treat the extended troop as the FULL troop but put the special
  # * extended troop members first.
  # * 2 - Treat the extended troop as JUST the special extended troop members.
  #--------------------------------------------------------------------------
  def set_hltr_extended_troop_handling(newHandlingVal)
    $game_party.setExSaveData("hltrExtendedTroopHandling", newHandlingVal)
  end
end

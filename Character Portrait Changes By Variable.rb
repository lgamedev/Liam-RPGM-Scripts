# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-CharPortraitsChangeByVar"] = true
# END OF IMPORT SECTION

# Script:           Character Portrait Changes By Variable
# Author:           Liam
# Version:          1.0
# Description:
# This script allows you to set up special "base" character portraits for text
# message windows which can change to other portraits according to the value
# of game variables paired with the base portraits. Optionally, the in-game
# menu portraits can change alongside the text message portraits. This allows
# you to do different outfits for a character, or possibly other things like
# the current emotional state of the character. The alternate portraits for
# the "base" portraits are determined using "text markers" in the alternate
# portrait filenames which are added to the end of the "base" portrait
# filenames. The "text markers" contain the text unique to each alternate
# portrait filename which differentiates it from the "base" character
# portrait filename.
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
# To use this script, start by placing it in your scripts list. After that,
# set up the script settings as you want them. Set up your "base" portraits
# and the alternate versions of the "base" portraits which have filenames
# that are the "base" portrait filename plus a text marker. Then, change the
# value of the game variables which determine which alternate portraits
# are used using Control Variable event commands.
#
#
# __Modifiable Constants__
module CPCBV
  # This setting determines whether you want the changes to "base"
  # character portrait to apply wherever the "base" portraits for specific
  # actors are used (like the menu), rather than only in text message windows.
  USE_CHARACTER_PORTRAIT_CHANGES_FOR_ALL_ACTOR_FACES = true
  
  # The PORTRAIT_TEXT_MARKER_START and PORTRAIT_TEXT_MARKER_END together
  # with the text marker name identifier which gets placed in between
  # them make up portrait "text markers". These text markers get placed
  # at the end of "base" portrait filenames to mark them as various
  # alternate versions of the "base" portrait.
  # PORTRAIT_TEXT_MARKER_START sets the what goes at start of all text markers.
  # PORTRAIT_TEXT_MARKER_END sets the what goes at start of all text markers.
  # It is optional, and can can be left as "" if you do not want to use it.
  #
  # Marked portrait filename example:
  #   marker start:                  "_["
  #   marker end:                    "]"
  #   base or "unmarked" filename:   "john"
  #   text marker alt portrait text: "top hat"
  #   filename:                      "Marylin_[top hat]"
  PORTRAIT_TEXT_MARKER_START = "_"
  PORTRAIT_TEXT_MARKER_END = ""
  
  # This setting determines what game variables and their variable values
  # correspond to certain portrait text marker name identifiers for
  # chosen "base" portraits. When naming the alternate versions
  # of "base" portraits, the filenames should be the "base" portrait
  # filname, immediately followed by the text marker for the portrait.
  # If the current value of the associated variable for a portrait
  # does not have a portrait text marker associated with it, the "base"
  # portrait will be used rather than any of the alternates.
  #
  # Format:
  #   ACTOR_CHARACTER_PORTRAIT_TEXT_MARKER_VARIABLE_VALUES = {
  #     "basePortraitFilename1" => {
  #       -1 => altPortraitSelectionVariableNum,
  #       1 => "textMarkerName1",
  #       2 => "textMarkerName2",
  #       3 => "textMarkerName3",
  #       ...
  #     },
  #    
  #     "basePortraitFilename2" => {
  #       -1 => altPortraitSelectionVariableNum,
  #       1 => "textMarkerName1",
  #       2 => "textMarkerName2",
  #       3 => "textMarkerName3",
  #       ...
  #     },
  #     
  #     ...
  #   }
  #
  # Example:
  #   ACTOR_CHARACTER_PORTRAIT_TEXT_MARKER_VARIABLE_VALUES = {
  #     "Marilyn" => {
  #       -1 => 15,
  #       1 => "neutral",
  #       2 => "happy",
  #       3 => "angry"
  #     },
  #    
  #     "john" => {
  #       -1 => 16,
  #       1 => "no hat",
  #       2 => "top hat",
  #       3 => "bowler hat",
  #       4 => "cool hat"
  #     }
  #   }
  #
  # Example Valid Alternate Portrait Filenames For Above Example:
  # (Using "_[" as PORTRAIT_TEXT_MARKER_START and "]" as PORTRAIT_TEXT_MARKER_END)
  #   "Marilyn_[angry]"
  # The above alternate portrait filename will be used when the "Marilyn" base
  # portrait is used, and game variable 15 is set to 3.
  #   "john_[no hat]"
  # The above alternate portrait filename will be used when the "john" base
  # portrait is used, and game variable 16 is set to 1.
  #
  # Note 1: You can use the same text marker name identifier for
  # any number of different "base" portraits, but you cannot
  # use the same text marker name identifier more than once for 1
  # individual "base" portrait.
  #
  # Note 2: If the portrait text marker variable is set to a number which
  # has no value in the portrait's text markers list, then the base portrait
  # filename will be used.
  #
  # Note 3: The value of -1 in the portrait text marker lists MUST be the
  # number of the game variable whose value should be checked to determine
  # the proper portrait text marker.
  #
  # Note 4: Optionally, 0 can be used as one of the portrait text marker
  # variable values. If 0 is used, it means that when the portrait text marker
  # variable is not set yet (or is manually set to 0), then that 0
  # portrait text marker will be used.
  #
  # Note 5: the variable values do not have to be in direct sequential order
  # (1, 2, 3, 4, 5, ....). You can skip around in what variable
  # numbers you use to match with the text markers should you wish it.
  #
  # Note 6: There should NOT be a comma after the closing bracket holding the
  # data for 1 individual actor if it is the final actor in the list. Similarly,
  # there should NOT be a comma after the final variable value to portrait text
  # marker pair in an actor's list.
  #
  # Note 7: If you need to have special notetags in filenames due to
  # other scripts (like animated portrait scripts), and those notetags need
  # to be different between the "base" portrait and alternates, then you should:
  #   1 - Ensure that your text markers will not conflict with the filename
  #       notetags. Change PORTRAIT_TEXT_MARKER_START and PORTRAIT_TEXT_MARKER_END
  #       if needed.
  #   2 - Refrain from actually displaying the base portraits. Add a new
  #       text markers for the 0 values of the variables and use those
  #       portrait variations as replacements for your "base" portraits.
  #   3 - Place the filename notetags that need to be unique for each
  #       portrait variation inside of your portrait text marker name identifiers.
  #       Depending on how the other scripts have their filename notetagging
  #       setup, it may (but has a chance to not) work.
  #   
  PORTRAIT_TEXT_MARKER_VARIABLE_VALUES = {
    "Marylin" => {
      -1 => 35,
      1 => "Pink",
      2 => "Punk",
      3 => "Secret"
    },
    
    "john" => {
      -1 => 36,
      1 => "no hat",
      2 => "top hat",
      3 => "bowler hat"
    }
    
  }
  
  # __END OF MODIFIABLE CONSTANTS__
  
  
  
# BEGINNING OF SCRIPTING ====================================================

  #--------------------------------------------------------------------------
  # * New helper method used to check if a given portrait name is valid for
  # * text marker name changes (meaning that the portrait is in the
  # * PORTRAIT_TEXT_MARKER_VARIABLE_VALUES list and has a variable
  # * assigned to it.
  #--------------------------------------------------------------------------
  def self.portrait_name_valid_for_text_marker_name_changes(portrait_name)
    # if portrait text marker variable values list does not contain the current
    # portrait name, then return that portrait name is invalid for changes immediately 
    if (!PORTRAIT_TEXT_MARKER_VARIABLE_VALUES.has_key?(portrait_name))
      return (false)
    else
      # if the original portrait name is in the portrait text marker variable
      # values list, but the text marker game variable was not designated
      # (the hash does not have a -1 value), then return that portrait name
      # is invalid for changes immediately
      if (!PORTRAIT_TEXT_MARKER_VARIABLE_VALUES[portrait_name].has_key?(-1))
        return (false)
      end
    end
    
    # return true (portrait name valid for changes) if no validity checks failed
    return (true)
  end
  
  #--------------------------------------------------------------------------
  # * New method which takes in a portrait name, and if the portrait
  # * is a "base" portrait with a valid alternate portrait that should
  # * be used according to the script settings and associated game variable,
  # * then the new alternate portrait name will be returned.
  # * If there is no alternate portrait name that should be used,
  # * the original portrait name is returned.
  #--------------------------------------------------------------------------
  def self.change_portrait_name_by_variable(orig_portrait_name)
    # return original portrait name immediately if current portrait name
    # is not valid for text marker name changes
    # (either portrait name not present in portrait text marker list,
    # or missing variable designation)
    if (!portrait_name_valid_for_text_marker_name_changes(orig_portrait_name))
      return (orig_portrait_name)
    end
    
    # get list of portrait text markers for the current portrait
    portraitTextMarkerList = PORTRAIT_TEXT_MARKER_VARIABLE_VALUES[orig_portrait_name]
    
    # get value of game variable which determines the portrait text marker
    # (hash key -1 will always be that game variable)
    portraitTextMarkerVarValue = $game_variables[portraitTextMarkerList[-1]]
    
    # return original portrait name immediately if portrait text marker
    # variable values list for the current portrait name does not contain
    # the current value of the variable
    if (!portraitTextMarkerList.has_key?(portraitTextMarkerVarValue))
      return (orig_portrait_name)
    end
    
    # get portrait marker inner text (goes in-between start and end)
    portraitTextMarkerInnerText = portraitTextMarkerList[portraitTextMarkerVarValue]
    # get original portrait name with full portrait text marker applied
    # as the final modified portrait name including the text marker
    return (orig_portrait_name + PORTRAIT_TEXT_MARKER_START + portraitTextMarkerInnerText + PORTRAIT_TEXT_MARKER_END)
  end
  
end


class Game_Actor < Game_Battler
  # New instance variable boolean flag to mark if a variable-changed portrait
  # name is currently being used for the actor
  attr_reader :cpcbv_using_changed_portrait_name
  # New instance variable string to save a variable-changed portrait name
  # if one is currently being used for the actor
  attr_reader :cpcbv_changed_portrait_name_string
  
  #--------------------------------------------------------------------------
  # * Aliased init_graphics() method of Game_Actor class used to initialize
  # * the new @cpcbv_using_changed_portrait_name flag and
  # * @cpcbv_changed_portrait_name string to false and nil respectively.
  #--------------------------------------------------------------------------
  alias cpcbv_before_face_name_portrait_change_by_var init_graphics
  def init_graphics
    # Call original method
    cpcbv_before_face_name_portrait_change_by_var
    
    # initialize @cpcbv_using_changed_portrait_name flag to false
    # (will be changed to true when face_name method used if needed)
    @cpcbv_using_changed_portrait_name = false
    # initialize @cpcbv_changed_portrait_name_string flag to false
    # (will be changed to appropriate string when face_name method used if needed)
    @cpcbv_changed_portrait_name_string = nil
  end
  
  #--------------------------------------------------------------------------
  # * Aliased (hidden) getter face_name() method for the @face_name reader
  # * instance variable in the Game_Actor class used to return a modified
  # * portrait name rather than the true portrait name. This is done
  # * according to the values of specific variables tied to specific "base"
  # * portrait names.
  #--------------------------------------------------------------------------
  alias cpcbv_after_face_name_portrait_change_by_var face_name
  def face_name
    # if character portrait changes are enabled for all actor faces,
    # then do checks on whether or not a modified character portrait
    # needs to be returned according to the matching portrait name change variable
    # (if such a variable exists, if it does not, the portrait name is unchanged)
    if (CPCBV::USE_CHARACTER_PORTRAIT_CHANGES_FOR_ALL_ACTOR_FACES == true)
      # start by storing orig face_name in variable
      orig_face_name = @face_name
      
      # get a new face name as needed according to portrait variable value
      # (will be same as original if said variable does not exist)
      new_face_name = CPCBV.change_portrait_name_by_variable(orig_face_name)
      
      # if @face_name changed, then mark that a changed portrait name is
      # being used with flag @cpcbv_using_changed_portrait_name
      # AND
      # set the value of @cpcbv_changed_portrait_name_string to be the new face name
      #
      # if @face_name did not change, then mark that a changed portrait
      # name is NOT being used and set @cpcbv_changed_portrait_name_string to nil
      if (new_face_name != orig_face_name)
        @cpcbv_using_changed_portrait_name = true
        @cpcbv_changed_portrait_name_string = new_face_name
      else
        @cpcbv_using_changed_portrait_name = false
        @cpcbv_changed_portrait_name_string = nil
      end
      
      # if using changed portrait name, explicitly return the changed portrait
      # name string immediately
      if (@cpcbv_using_changed_portrait_name == true)
        return (@cpcbv_changed_portrait_name_string)
      end
      
    end
    
    # Call original method (which just returns @face_name implicitly)
    cpcbv_after_face_name_portrait_change_by_var
  end
end


class Game_Message
  #--------------------------------------------------------------------------
  # * Aliased (hidden) getter face_name() method for the @face_name reader
  # * instance variable in the Game_Message class used set the @face_name
  # * variable to an alternate version of the "base" portrait name. This is done
  # * according to the values of specific variables tied to specific "base"
  # * portrait names.
  #--------------------------------------------------------------------------
  alias cpcbv_after_face_name_portrait_change_by_var_message_ver face_name
  def face_name
    # set @face_name to a new modified face name as needed according to
    # portrait variable value (will be same as original if said variable
    # does not exist)
    @face_name = CPCBV.change_portrait_name_by_variable(@face_name)
    
    # Call original method (which just returns @face_name implicitly)
    cpcbv_after_face_name_portrait_change_by_var_message_ver
  end
end

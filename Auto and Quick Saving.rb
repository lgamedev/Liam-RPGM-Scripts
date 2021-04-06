# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-AutoQuickSaving"] = true
# END OF IMPORT SECTION

# ------------------- ! REQUIRES 'EXTRA SAVE DATA' SCRIPT ! -------------------
# Script:           Auto/Quick Saving
# Author:           Liam
# Version:          1.2.2
# Description:
# This script turns the first savefile in the list of savefiles in the game
# directory into a quicksave/autosave hybrid savefile that can only be accessed
# in the load menu (and not the normal save menu). Autosaves can be
# enabled to occur either when a specified switch is turned to true, or
# on map transition. Quicksaves can be enabled to occur with the press of
# a specified button. Additionally, the quicksave file can be quickloaded
# with the press of a different specified button.
# Requires the extra save data script.
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
# The savefile can be autosaved to by enabling AQS_MAP_AUTOSAVE, which
# causes an autosave to the aqsavefile (autoquicksavesavefile) slot upon the
# player going through a map transition, or by enabling AQS_SWITCH_AUTOSAVE,
# which causes an autosave to the aqsavefile when a specified switch is turned to
# true (the switch is turned false after the save). Additionally, quicksaving
# with the press of a specified key can be enabled with AQS_KEY_QUICKSAVE.
#
# Note 1: Autosaving only activates when the player has control (aka, whenever
# you can bring your menu up, the autosave can fire), this means that if the
# autosave switch is turned on, the autosave may not trigger depending on the
# kind of map event the switch turns on in.
#
# Note 2: Autosaves on map transition may cause bugs if an room has
# an autorun event (or it may not, it needs testing). Consider temporarily turning
# off map transition autosaves in specific sections if there are problems and you still
# want to use the map transition autosaves.
#
# Note 3: Quicksaves/loads also only activate when the player has control, and out
# of battle. If the player is in battle, nothing happens when the quicksave
# button is pressed. If the player is on the map but does not have control,
# the system's buzzer sound will play and the save/load will not occur. If the player
# is on the map and has control, the save/load wil be successful and play the save sound
#
# Note 4: If you want to enable/disable the autosave/quicksave methods during
# gameplay, use a script line in a map event like the following:
#   $game_party.setExSaveData("AQS_KEY_QUICKSAVE", true)
# (for more info, see the comments paired with the modifiable constants below)
#
#
# __Modifiable Constants__
module AQSAVES
  # The display name for the auto/quick save slot
  AQSAVE_NAME = "Quicksave Slot"
  # The maximum number of saves you want not counting the autosave slot
  # (put in 0 to only have the autosave slot, if that's what you want,
  # NOT SURE THAT THAT WORKS QUITE W/O FURTHER SUPPORT THOUGH)
  MAX_NUM_SAVES = 20
  # Set to 'true' to get an autosave to trigger after map transitions
  # To turn this off/on during gameplay, use the following script in a map event
  #   $game_party.setExSaveData("AQS_MAP_AUTOSAVE", true)
  # (or use false, depending on what you want to set the value to)
  AQS_MAP_AUTOSAVE = false
  # Whether or not to activate an autosave when a certain variable is flipped
  # to true.
  # This setting doesn't really need to be able to change during gamepaly
  # Note: May break if there are autorun events in the map that is transitioned
  # to. If this is the casem turn off the setting during gameplay briefly
  # and then turn it back on.
  AQS_SWITCH_AUTOSAVE = true
  # The number/ID of the game switch you want to use to activate the autosave
  # if switch autosave is enabled (AQS_SWITCH_AUTOSAVE).
  # Set the switch to "true" in an event to trigger the save. The switch's
  # value will be set back to false after the save is done.
  AQS_SWITCH_AUTOSAVE_ID = 399
  # Set to 'true' to get a quicksave to trigger on pressing the related key
  # To turn this off/on during gameplay, use the following script an a map event
  #   $game_party.setExSaveData("AQS_KEY_QUICKSAVE", true)
  # (or use false, depending on what you want to set the value to)
  AQS_KEY_QUICKSAVE = true
  # If you do not have a full keyboard availability script, the available options
  # are -> :F5, :F6, :F7, and :F8
  AQS_S_KEY_USED = :F6
  # Set to 'true' to get a quickload to trigger on pressing the related key
  # To turn this off/on during gameplay, use the following script an a map event
  #   $game_party.setExSaveData("AQS_KEY_QUICKLOAD", true)
  # (or use false, depending on what you want to set the value to)
  AQS_KEY_QUICKLOAD = true
  # If you do not have a full keyboard availability script, the available options
  # are -> :F5, :F6, :F7, and :F8
  AQS_L_KEY_USED = :F7
  
  # __END OF MODIFIABLE CONSTANTS__
end


  

# BEGINNING OF SCRIPTING ====================================================
module DataManager
  #--------------------------------------------------------------------------
  # * Overriden savefile_max() function, used to account for the AQSAVES max
  # * number of saves.
  #--------------------------------------------------------------------------
  def self.savefile_max
    # +1 to account for the AQsavefile
    return (AQSAVES::MAX_NUM_SAVES + 1)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to save the game to the aqs savefile (which is always
  # * the savefile at the zero index)
  #--------------------------------------------------------------------------
  def self.aqs_save
      # The AQsavefile is always the first file, and the save_game function
      # automatically adds +1 to the passed number when deciding the
      # filename, so pass in 0.
      DataManager.save_game(0)
    end

end

class Window_SaveFile < Window_Base
  #--------------------------------------------------------------------------
  # * Overriden refresh() method used to add the AQsavefile to the beginning
  # * of the save list, and update file name display index appropriately
  # * depending on if the aqsavefile is visible or not (visible if loading)
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(normal_color)
    # the first file is the AQsavefile if loading, so if conditions met, 
    # change the display name of the file
    if (SceneManager.scene_is?(Scene_Load))
      if (@file_index == 0)
        name = AQSAVES::AQSAVE_NAME
      else
        # no +1 to account for the AQsavefile in the display name
        name = Vocab::File + " #{@file_index}"
      end
    else
      # +1 to account for both indexing at 0 AND the unsavable autosave slot
      name = Vocab::File + " #{@file_index + 1}"
    end
    draw_text(4, 0, 200, line_height, name)
    @name_width = text_size(name).width
    draw_party_characters(152, 58)
    draw_playtime(0, contents.height - line_height, contents.width - 4, 2)
  end
  
  # -------------------------------------------------------------------------
  # * Overriden draw_party_characters(), used to get the correct save data if loading
  # * (must now account for the aqs file)
  #--------------------------------------------------------------------------
  def draw_party_characters(x, y)
	# this var represent the index of the file to load in the actual save file data
	load_save_index = @file_index
	# add +1 to the loaded data to account for the fact that the AQsavefile if not in
	# the loading menu
	if (!(SceneManager.scene_is?(Scene_Load)))
		load_save_index = load_save_index + 1
	end
	header = DataManager.load_header(load_save_index)
    return unless header
    header[:characters].each_with_index do |data, i|
      draw_character(data[0], data[1], x + i * 48, y)
    end
  end
  
  # -------------------------------------------------------------------------
  # * Overriden draw_playtime(), used to get the correct save data if loading
  # * (must now account for the aqs file)
  #--------------------------------------------------------------------------
  def draw_playtime(x, y, width, align)
	# this var represent the index of the file to load in the actual save file data
	load_save_index = @file_index
	# add +1 to the loaded data to account for the fact that the AQsavefile if not in
	# the loading menu
	if (!(SceneManager.scene_is?(Scene_Load)))
		load_save_index = load_save_index + 1
	end
	header = DataManager.load_header(load_save_index)
    return unless header
    draw_text(x, y, width, line_height, header[:playtime_s], 2)
  end
  
end


class Scene_File < Scene_MenuBase
  attr_accessor :lastSaveIndex # last index used for the savefiles
  
  #--------------------------------------------------------------------------
  # * Overriden create_savefile_windows(), used to lower the max save count if not loading
  # * (lowered bc aqsavefile not present)
  #--------------------------------------------------------------------------
  def create_savefile_windows
    # local variable to keep track of max saves
    max_saves = item_max
    @savefile_windows = Array.new(max_saves) do |i|
      Window_SaveFile.new(savefile_height, i)
    end
    # save last index used for the savefiles
    @lastSaveIndex = max_saves - 1;
    @savefile_windows.each {|window| window.viewport = @savefile_viewport }
  end
  
  #--------------------------------------------------------------------------
  # * Overriden item_max(), used to lower the max save count if not loading
  # * (lowered bc aqsavefile not present)
  #--------------------------------------------------------------------------
  def item_max
  	# note: max_saves is a new local variable
    max_saves = DataManager.savefile_max
    # if not loading files, do not add the extra file for the AQsavefile,
    # so subtract 1 from the max
    if (!(SceneManager.scene_is?(Scene_Load)))
      max_saves -= 1
    end
    return max_saves
  end

  #--------------------------------------------------------------------------
  # * Overriden init_selection(), used to lower the selection index if
  # * saving (lowered bc aqsavefile not present)
  #--------------------------------------------------------------------------
  def init_selection
    @index = first_savefile_index
    # if saving, the initial selection should be 1 less because the
    # aqsavefile is absent (as long as the index isn't 0)
    # (this prevents a bug where the aqs savefile can be saved to
    # in a new game when there are zero savefiles, even though the aqs
    # savefile is not on screen)
    if (SceneManager.scene_is?(Scene_Save))
      if (@index != 0)
        @index -= 1
      end
    end
    @savefile_windows[@index].selected = true
    self.top_index = @index - visible_max / 2
    ensure_cursor_visible
  end
  
end

class Scene_Save < Scene_File
  #--------------------------------------------------------------------------
  # * Overriden on_savefile_ok(), used to add 1 to the save index when saving
  # * the game (bc the index must be increased by 1)
  #--------------------------------------------------------------------------
  def on_savefile_ok
    super
	# +1 to account for changed index bc the AQsavefile is present when loading
    if DataManager.save_game(@index + 1)
      on_save_success
    else
      Sound.play_buzzer
    end
  end
end


class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Aliased command201() (which is the transfer player command in map events),
  # * used to add an autosave on map transitions
  #--------------------------------------------------------------------------
  alias before_new_transfer_actions command_201
  def command_201
    before_new_transfer_actions
    
    # check if the the map autosave setting is on, and send the
    # AQS_MAP_AUTOSAVE value to initialize the data if it has not been yet
    mapAutosave = $game_party.getExSaveData("AQS_MAP_AUTOSAVE", AQSAVES::AQS_MAP_AUTOSAVE)
    
    # make sure that map transition fully completed by checking if the
    # current scene is the map scene. If it is and map autosaves are set
    # to trigger, then activate the autosave.
    if ((SceneManager.scene_is?(Scene_Map)) && (mapAutosave))
      DataManager.aqs_save
    end
  end
end


class Game_Map
  #--------------------------------------------------------------------------
  # * Aliased update_events() method to check if the quicksave key is activated
  # * during in event, in which case, the save will not activate and the
  # * buzzer sound will play.
  #--------------------------------------------------------------------------
  alias before_check_event update_events
  def update_events
    # call the original method, do all the standard event updating actions
    before_check_event
    
    # check if the the key quicksave setting is on, and send the
    # AQS_KEY_QUICKSAVE value to initialize the data if it has not been yet
    keyQuicksave = $game_party.getExSaveData("AQS_KEY_QUICKSAVE", AQSAVES::AQS_KEY_QUICKSAVE)
    # check if the the key quickload setting is on, and send the
    # AQS_KEY_QUICKLAOD value to initialize the data if it has not been yet
    keyQuickload = $game_party.getExSaveData("AQS_KEY_QUICKLOAD", AQSAVES::AQS_KEY_QUICKLOAD)
    
    # check if the AQS key-based quicksave/load could theoretically activate
    # and if the game interpreter is currently running (no saving/loading at
    # those points)
    if (((keyQuicksave == true) || (keyQuickload == true)) && ($game_map.interpreter.running?))
      # if the AQS quicksave/load key is used (and an event is currently active)
      # play the buzzer (plays when normal save/load would fail in the menu)
      if ((Input.trigger?(AQSAVES::AQS_S_KEY_USED)) || (Input.trigger?(AQSAVES::AQS_L_KEY_USED)))
        Sound.play_buzzer
      end
    end
  end
end


class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # * Aliased update_scene() method to check for either the autosave game switch
  # * being true, or the quicksave key being activated, and activating the
  # * the AQS save if either are true (if their associated settings are true)
  #--------------------------------------------------------------------------
  alias before_pseudo_event_actions update_scene
  def update_scene
    before_pseudo_event_actions
    # check for aqs save conditions unless the scene is changing
    aqs_save_checks unless scene_changing?
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if the autosave game switch is true or if the AQS
  # * quicksave key is pressed, and if the setting are enabled, activate the
  # * autosave/quicksave.
  #--------------------------------------------------------------------------
  def aqs_save_checks
    # check if the AQS switch-based autosave can activate
    if (AQSAVES::AQS_SWITCH_AUTOSAVE)
      # if the AQS game switch is true, trigger the aqs save
      if ($game_switches[AQSAVES::AQS_SWITCH_AUTOSAVE_ID] == true)
        DataManager.aqs_save
        # turn the switch back off after the save is complete
        $game_switches[AQSAVES::AQS_SWITCH_AUTOSAVE_ID] = false
      end
    end
    
    # check if the the key quicksave setting is on, and send the
    # AQS_KEY_QUICKSAVE value to initialize the data if it has not been yet
    keyQuicksave = $game_party.getExSaveData("AQS_KEY_QUICKSAVE", AQSAVES::AQS_KEY_QUICKSAVE)
    # check if the the key quickload setting is on, and send the
    # AQS_KEY_QUICKLOAD value to initialize the data if it has not been yet
    keyQuickload = $game_party.getExSaveData("AQS_KEY_QUICKLOAD", AQSAVES::AQS_KEY_QUICKLOAD)
    
    # check if the AQS key-based quicksave/load can activate
    if ((keyQuicksave == true) || (keyQuickload == true))
      # if the AQS quicksave key is used, trigger the aqs save
      if (Input.trigger?(AQSAVES::AQS_S_KEY_USED))
        DataManager.aqs_save
        # play the save sound
        Sound.play_save
      # if the AQS quickload key is used, trigger the aqs load
      elsif (Input.trigger?(AQSAVES::AQS_L_KEY_USED))
        # Try to load the game the the AQS index (which is always 0)
        # load_game() returns true (and loads the game) if the game is loadable
        # (which means the save file exists), otherwise, returns false
        # If succesful, perform the standard load actions, otherwise, play the
        # designated buzzer noise.
        if (DataManager.load_game(0))
          # below is the normal game load actions
          Sound.play_load
          fadeout_all
          $game_system.on_after_load
          SceneManager.goto(Scene_Map)
        else
          Sound.play_buzzer
        end
      end
    end
  end
  
end
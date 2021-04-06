# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-MoreSaveDisplay"] = true
# END OF IMPORT SECTION

# Script:           More Save Display Data (& Difficulty Display)
# Author:           Liam
# Version:          1.0.2
# Description:
# The script provides a framework for adding more data onto savefiles.
# By default, the data added is game difficulty, although you can add more
# data by copying versions of the previous methods/variables and editing the
# names/values. game_party is used to store data because data stored there
# is stored in save data and can be accessed outside of normal gameplay
# (since it needs to be used on the title screen).
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
# To add additional pieces of data to display on your save files, you will need
# to add new versions of the code lines and methods for each new piece of
# data wherever there a section contained by
#    # NEW ___ |START(S)| HERE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#        code/method definitions
#    # NEW ___ |END(S)| HERE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Each one of these sections has a rough guide on what to add for a new piece of
# data. You can use the "difficulty" related methods as a guide, or if you know
# who 'Liam' is and how to contact him, you could ask him for help if you
# need assistance.
# 
# Alternatively, if you just want a method to draw difficulty, change the
# difficulty drawing/saving scripts to your needs.
# Use $game_party.set_difficulty(number) as a single-line script in a map event
# to change the difficulty.
#
# In general, use $game_party.set_dataName(value) in a map event to change the
# data in general.
#
#
# No editable constants for this script. Methods/Variables
# must be made manually.



# BEGINNING OF SCRIPTING ====================================================
module DataManager
  #--------------------------------------------------------------------------
  # * Overridden self.make_save_header used to add the new set of headers
  # * to the hash of headers. Returns the header list.
  #--------------------------------------------------------------------------
  def self.make_save_header
    # header is a hash that stores display-related data, grabbing it
    # from $game_system or $game_party
    header = {}
    header[:characters] = $game_party.characters_for_savefile
    header[:playtime_s] = $game_system.playtime_s
    
    # NEW HEADERS |START| HERE! >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    # put a new
    #    header[:dataNameheader] = $game_system.dataName
    # for a new piece of data.
    header[:difficultyheader] = $game_system.difficulty
    
    
    # NEW HEADERS |END| HERE! <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    # return the header list
    header
  end
  
end


class Game_System
  
  # NEW HEADER TEXT METHODS |START| HERE! >>>>>>>>>>>>>>>>>>>>>>>>>>>>
  # put a new
  #    def dataName
  #       dataValue = $game_party.dataName
  #       
  #       #conditionals based on value here#     (like the case structure)
  #          sprintf("My Return Text")
  #          .
  #          .
  #          .
  #    end
  # for a new piece of data. The text returned will be attached to the header
  # associated with the piece of data.
  
  #--------------------------------------------------------------------------
  # * New method used to return the appropriate string (of text) depending
  # * on the current value of the data stored in game_party.
  #--------------------------------------------------------------------------
  def difficulty
    # get the difficulty number stored in $game_party
    difficultyNum = $game_party.difficulty
    
    # case statement, choose appropriate text for each difficulty
    # (1 is Easy, 2 is Not Easy, 3 is H.A.R.D.)
    case difficultyNum
    when 0
      sprintf("ERROR, DIFF UNINITIALIZED")
    when 1
      sprintf("Easy")
    when 2
      sprintf("Not Easy")
    when 3
      sprintf("H.A.R.D.")
    else
      sprintf("ERROR, DIFF INVALID")
    end
    # returns whatever sring was created w/ sprintf("Display Text") was made automatically
    # (ruby will automatically return the last line executed)
  end
  
  
  # NEW HEADER TEXT METHODS |END| HERE! <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  
end


class Game_Party < Game_Unit
  
  # NEW PARTY-SAVED DATA |STARTS| HERE! >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  # Put a new
  #    attr_reader :dataName
  # for a new piece of data. This will store the data and attach it to the savefile.
  attr_reader   :difficulty
  
  
  # NEW PARTY-SAVED DATA |ENDS| HERE! <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  
  #--------------------------------------------------------------------------
  # * Aliased initialize for Game_Party Object Initialization used to
  # * initialize the new pieces of data stored in Game_Party.
  #--------------------------------------------------------------------------
  alias before_new_party_data_processing initialize
  def initialize
    before_new_party_data_processing
    
    # NEW PARTY-SAVED DATA INITIALIZATIONS |START| HERE >>>>>>>>>>>>>
    # Put a new
    #   @dataName = initialValue
    # for a new piece of data. The initial value is the value the data will
    # have before you update it for the first time.
    # for @difficulty = 2, 2 represents a specific difficulty ("Not Easy")
    @difficulty = 2 # 2 is the default difficulty, "Not Easy"
    
    
    # NEW PARTY-SAVED DATA INITIALIZATIONS |END| HERE <<<<<<<<<<<<<<<
    
  end
  
  # NEW DATA SETTING METHODS |START| HERE! >>>>>>>>>>>>>>>>>>>>>>>>>>
  # Put a new
  #   def set_dataName(newValue)
  #      @dataName = newValue      
  #
  #      mySwitchAndVarChanges
  #      .
  #      .
  #      .
  #   end
  # for a new piece of data. Switch and Variable changes, or anything else
  # that needs updated with your changed piece of data is up to you.
  # Use set_difficulty() as a reference.
  
  #--------------------------------------------------------------------------
  # * New method used to set the difficulty in Game_Party and update the game
  # * switches and variables related to difficulty at the same time.
  #--------------------------------------------------------------------------
  def set_difficulty(newVal)
    # set the difficulty value for 
    @difficulty = newVal
    
    # the ID numbers of the difficulty-related switches/variables
    # (change if needed)
    easyModeSwitchNum = 275
    difficultyVarNum = 65
    hardModeSwitchNum = 350
    
    # set the game variable storing game difficulty
    $game_variables[difficultyVarNum] = newVal
    
    # case statement, set appropriate switches for the difficulties depending on
    # the new difficulty
    # (1 is Easy, 2 is Not Easy, 3 is H.A.R.D.)
    case newVal
    when 0
      # do nothing, value may be unitialized somehow
    when 1
      # changing vals for easy mode
      $game_switches[easyModeSwitchNum] = true
      $game_switches[hardModeSwitchNum] = false
    when 2
      # changing vals for normal mode
      $game_switches[easyModeSwitchNum] = false
      $game_switches[hardModeSwitchNum] = false
    when 3
      # changing vals for hard mode
      $game_switches[easyModeSwitchNum] = false
      $game_switches[hardModeSwitchNum] = true
    else
      # do nothing, difficulty number invalid somehow
    end
    
  end
  
  # NEW DATA SETTING METHODS |END| HERE! <<<<<<<<<<<<<<<<<<<<<<<<<<<<
  
end


class Window_SaveFile < Window_Base
  #--------------------------------------------------------------------------
  # * Overriden refresh() method used to add the new draw_dataName calls to
  # * for the save file windows. Also supports adding the AQsavefile to the beginning
  # * of the save list (if AQSAVES script present), and update file name
  # * display index appropriately depending on if the aqsavefile is
  # * visible or not (visible if loading). 
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    change_color(normal_color)
    
    # check if AQSAVES (auto/quicksaving script) present
    aqSavesPresent = $imported["Liam-AutoQuickSaving"]
    # only do AQSAVE related things if AQSAVES present
    if (aqSavesPresent)
      if (SceneManager.scene_is?(Scene_Load))
        # if it is the first savefile, use the aqsave name
        if (@file_index == 0)
          name = AQSAVES::AQSAVE_NAME
        # AQSAVES load not aqsavefile display
        else
          # no +1 to account for the AQsavefile in the display name
          name = Vocab::File + " #{@file_index}"
        end
      # AQSAVES non-load display
      else
        # +1 to account for both indexing at 0 AND the unsavable autosave slot
        name = Vocab::File + " #{@file_index + 1}"
      end
    # AQSAVES not present, use normal display
    else 
      # normal save file name printing
      name = Vocab::File + " #{@file_index}"
    end
    
    draw_text(4, 0, 200, line_height, name)
    @name_width = text_size(name).width
    draw_party_characters(152, 58)
    draw_playtime(0, contents.height - line_height, contents.width - 4, 2)
    
    # NEW draw_name CALLS |START| HERE! >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    # Put a new
    #   draw_dataName(xValue, yValue, widthAllotted, alignment)
    # for a new piece of data. The x and y values are relative to the
    # individual save file window. (x, y) pair (0, 0) is in the top left corner
    # of any given save file window, and the x and y numbers increase as
    # they move toward the lower right corner (probably, I just messed around with
    # the values until it looked good, really). The width is the amount of
    # space to allow the text to fit into. As for alignment,
    # alignment value 0 is left-alignment, 1 is centered, and 2 is right-aligned.
    draw_difficulty(0, contents.height - line_height * 2, contents.width, 2)
    
    
    # NEW draw_name CALLS |END| HERE! <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
  end
  
  # NEW draw_name METHOD DEFINITIONS |START| HERE! >>>>>>>>>>>>>>>>>>
  # Put a new
  #   def draw_dataName(x, y, width, align)
  #       save_index = aqsavesIndexModifier(@file_index)
  #       header = DataManager.load_header(save_index)
  #       return unless header
  #
  #       #conditionals based on value here#         (like the case structure)
  #          .
  #          .
  #          draw_text(x, y, width, line_height, "My Text To Draw", align)
  #       .
  #       .
  #       .
  #   end
  # for a new piece of data. Modify the conditional and draw text section
  # to do whatever you want with scripting, whether it is actually displaying
  # pictures instead (look up scripting calls for rpgmaker vx ace for this),
  # or making the text or color change, etc.
    
  # -------------------------------------------------------------------------
  # * New method used to draw the difficulty text onto the save file menu.
  # * Also colors the text appropriately.
  #--------------------------------------------------------------------------
  def draw_difficulty(x, y, width, align)
    # get the index of the savefile, modified w/ aqsaves if necessary
    # (just returns the value of @file_index if AQS script not present)
    save_index = aqsavesIndexModifier(@file_index)
    # load the header set for the savefile
    header = DataManager.load_header(save_index)
    return unless header
    
    # case statement, choose appropriate text/color for each difficulty
    # depending on the header
    # (1 is Easy, 2 is Not Easy, 3 is H.A.R.D.)
    case header[:difficultyheader]
    when "ERROR, DIFF UNINITIALIZED"
      # handling for if the difficulty somehow wasn't initialized properly
      draw_text(x, y, width, line_height, "ERROR, DIFF UNINITIALIZED", align)
    when "Easy"
      # change the text color to a dark blue
      change_color(text_color(9))
      draw_text(x, y, width, line_height, "Easy", align)
    when "Not Easy"
      # change the text color to a dark green
      change_color(text_color(11))
      draw_text(x, y, width, line_height, "Not Easy", align)
    when "H.A.R.D."
      # change the text color to red
      change_color(text_color(18))
      draw_text(x, y, width, line_height, "H.A.R.D.", align)
    else
      # print that difficulty invalid if string not found
      draw_text(x, y, width, line_height, "ERROR, DIFF INVALID", align)
    end
    
    # note: line_height will be recognized even though it is not visibly declared
  end
  
  
  # NEW draw_name METHOD DEFINITIONS |END| HERE! <<<<<<<<<<<<<<<<<<<<
  
  # -------------------------------------------------------------------------
  # * New method used to modify a save index for AQSAVE script compatibility.
  # * If AQSAVES is not present, it simply returns the index.
  #--------------------------------------------------------------------------
  def aqsavesIndexModifier(index)
    # check if AQSAVES (auto/quicksaving script) present
    aqSavesPresent = $imported["Liam-AutoQuickSaving"]
    # only do anything if AQSAVES present
    if (aqSavesPresent)
      # add +1 to the loaded data to account for the fact that the AQsavefile if not in
      # the loading menu (if in the loading menu)
      if (!(SceneManager.scene_is?(Scene_Load)))
        index += 1
      end
    end
    
    return index
  end
    
end

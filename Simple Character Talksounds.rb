# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-SimpleCharacterTalksounds"] = true
# END OF IMPORT SECTION

# Script:           Simple Character Talksounds
# Author:           Liam
# Version:          1.0
# Description:
# This script allows you to easily create character talksounds and play them
# when text message windows display their text. Talksound data is set up
# in the script settings, and the active talksound is controlled using
# a designated game variable. There is optional pitch randomisation to
# vary individual talksound noises. There is also a setting to change how
# closely together individual talksounds noises are played can be set.
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
# set up the script settings as you want them. Then, change the value
# of your designated talksound variable in Control Variable event commands before
# text window event commands to use your desired talksounds for the
# text windows.
#
#
# __Modifiable Constants__
module SCT
  # This setting determines the number of the game variable whose value be
  # used to determine the current talksound.
  #
  # Note: When the value of this variable is 0, no talksound will be used.
  CURRENT_TALKSOUND_USED_VARIBABLE_NUM = 5
  
  # This setting determines the volume for talksounds that is used
  # when no custom volume is specified.
  DEFAULT_VOLUME = 80
  
  # This setting determines the pitch for talksounds that is used
  # when no custom pitch is specified.
  DEFAULT_PITCH = 100
  
  # These two settings determine how far a given talksound pitch can be
  # randomized from the original pitch value each time a talksound plays.
  # The start and end make up a range of percentages which the original
  # talksound pitches can be modified by.
  #
  # Example:
  #   With a PITCH_RANDOMIZATION_RANGE_START of 70 and a
  #   PITCH_RANDOMIZATION_RANGE_END of 120, an original talksound pitch will
  #   be multiplied by a random percentage in between 70% and 120%.
  #   So for an original talksound pitch of 80, any individual
  #   talking sound will have a pitch between 56 and 96.
  #   For an original talksound pitch of 100, any individual talking sound
  #   will have a pitch between 70 and 120.
  #
  # Note: Set both the start and end of the range to 100 to not sue
  # pitch randomization.
  PITCH_RANDOMIZATION_RANGE_START = 70
  PITCH_RANDOMIZATION_RANGE_END = 120
  
  # This setting determines the amount of characters that must be displayed
  # on screen as the text is drawn it takes to play a new individual
  # talksound. With a lower number, individual talksounds will play
  # closer together. With a higher number, individual talksounds will
  # play further apart.
  SOUND_PLAYING_INTERVAL = 3
  
  # This setting determines the number of a game variable whose value can
  # override the SOUND_PLAYING_INTERVAL. If value of the variable
  # is above 0, the value will be used as the SOUND_PLAYING_INTERVAL
  # rather than the default one. See the comments for the SOUND_PLAYING_INTERVAL
  # for more information about what the SOUND_PLAYING_INTERVAL does.
  #
  # Note: Set this setting to -1 to not use any game variable for this setting.
  SOUND_PLAYING_INTERVAL_VARIABLE = -1
  
  # This list of pieces of data holds the sound names and custom volume/pitch
  # data. The number before each piece of sound data determines
  # what value of the game variable whose number is determined by the
  # CURRENT_TALKSOUND_USED_VARIBABLE_NUM is needed to play each talksound.
  # that talksound. You can add as many new data entries to this list
  # as you like by copy-pasting new sound data entries below the old ones
  # and changing the values.
  #
  # Format:
  #   {
  #     talksoundVariableValue => [sound data],
  #     talksoundVariableValue => [sound data],
  #     talksoundVariableValue => [sound data],
  #     ...
  #   }
  # 
  # Example:
  #   3 => ["ding", 80, 100]
  #   Using the above example in the sound data list would result in the
  #   sound with the name "ding" being used with a volume of 80 and a
  #   pitch of 100 when the game variable whose number is
  #   CURRENT_TALKSOUND_USED_VARIBABLE_NUM is set to 3.
  #
  # Sound Data Format Options:
  #   ["soundname"]
  #   Uses default volume/pitch from the settings further above.
  #   ["soundname", soundVol]
  #   Uses custom sound volume, and default pitch from the setting further above.
  #   ["soundname", soundVol, soundPitch] 
  #   Uses custom sound volume and pitch.
  #
  # Note 1: The numbers in the list do not need to be sequential (1, 2, 3...),
  # you can use whatever numbers you like except for 0, which should not be
  # used as it means that no talksound should be used.
  #
  # Note 2: After each piece of sound data except for the very last entry
  # in the list, there should be a comma.
  SOUND_DATA = {
    1 => ["marylin"],
    2 => ["john", 45, 30],
    3 => ["boing"],
    4 => ["pinnacle"],
    5 => ["eww", 80],
    6 => ["Adle"],
    7 => ["barbeque"]
  }
  
  # __END OF MODIFIABLE CONSTANTS__
end



# BEGINNING OF SCRIPTING ====================================================
module Sound
  #--------------------------------------------------------------------------
  # * New method play an individual character talksound sound effect.
  # * This method is activated every SOUND_PLAYING_INTERVAL amount of
  # * characters in a text message window. Individual character talksound
  # * sound effects have varying pitches depending on pitch randomization
  # * settings.
  #--------------------------------------------------------------------------
  def self.sct_play_text_se
    # get number of sound to play from the game variable
    soundToPlayNum = $game_variables[SCT::CURRENT_TALKSOUND_USED_VARIBABLE_NUM]
    
    # only do anything else if there is associated sound data for the value of the variable
    if (SCT::SOUND_DATA.has_key?(soundToPlayNum) == true)
    
      # get actor talksound sound effect data
      talksoundSEData = SCT::SOUND_DATA[soundToPlayNum]
      seFilename = talksoundSEData[0]
      seVol = (talksoundSEData[1].nil?) ? SCT::DEFAULT_VOLUME : talksoundSEData[1]
      sePitch = (talksoundSEData[2].nil?) ? SCT::DEFAULT_PITCH : talksoundSEData[2]
      
      # get range of variance between start and end pitch randomization numbers
      pitchVarianceRange = SCT::PITCH_RANDOMIZATION_RANGE_END - SCT::PITCH_RANDOMIZATION_RANGE_START
      # if the variance range is greater than 0, then modify the pitch
      # according to the variance range
      if (pitchVarianceRange > 0)
        # get modifier to multiply the pitch with
        pitchModifier = (rand(pitchVarianceRange + 1) + SCT::PITCH_RANDOMIZATION_RANGE_START).to_f / 100.0
        
        # get new sePitch using the pitch modifier
        sePitch = (sePitch * pitchModifier).to_i
      end
      
      # play character talksound sound effect
      RPG::SE.new(seFilename, seVol, sePitch).play
    end
  end
end


class Window_Message < Window_Base
  #--------------------------------------------------------------------------
  # * Aliased initialize() method in Window_Message class used to
  # * initialize the @character_talksound_count variable to 0.
  #--------------------------------------------------------------------------
  alias sct_after_character_count_init initialize
  def initialize
    # Call original method
    sct_after_character_count_init
    
    # start with character talksound count at 0
    @character_talksound_count = 0
  end
  
  #--------------------------------------------------------------------------
  # * Aliased process_normal_character() method in Window_Message class used to
  # * play individual character talk sounds according to the
  # * @character_talksound_count value and SOUND_PLAYING_INTERVAL setting.
  # * Increments @character_talksound_count by 1 every character.
  #--------------------------------------------------------------------------
  alias sct_after_process_normal_character process_normal_character
  def process_normal_character(c, pos)
    # Call original method
    sct_after_process_normal_character(c, pos)
    
    # get talksound character interval based off of script settings, start with
    # SOUND_PLAYING_INTERVAL as the default
    talksoundCharacterInterval = SCT::SOUND_PLAYING_INTERVAL
    # check if sound playing interval variable exists (the number of the game
    # variable to use is above 0)
    if (SCT::SOUND_PLAYING_INTERVAL_VARIABLE > 0)
      # if the value of the SOUND_PLAYING_INTERVAL_VARIABLE is above 0
      # then use it as the talksound character interval rather than
      # the SOUND_PLAYING_INTERVAL value.
      if ($game_variables[SCT::SOUND_PLAYING_INTERVAL_VARIABLE] > 0)
        talksoundCharacterInterval = $game_variables[SCT::SOUND_PLAYING_INTERVAL_VARIABLE]
      end
    end
    
    # play sound if the character interval passed and not show lines in fast mode
    Sound.sct_play_text_se if ((@character_talksound_count % talksoundCharacterInterval == 0) && !@line_show_fast)
    # add 1 to talksound count
    @character_talksound_count += 1
  end
  
  #--------------------------------------------------------------------------
  # * Aliased process_new_page() method in Window_Message class used to reset
  # * @character_talksound_count to 0 since a new batch of text is starting.
  #--------------------------------------------------------------------------
  alias sct_after_process_new_page process_new_page
  def process_new_page(text, pos)
    # Call original method
    sct_after_process_new_page(text, pos)
    
    # reset character talksound count to 0
    @character_talksound_count = 0
  end
end

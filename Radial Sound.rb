# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-RadialSound"] = true
# END OF IMPORT SECTION

# Script:           Radial Sound
# Author:           Liam
# Version:          1.0.1
# Description:
# This script is made for increasing and decreasing the
# volume of a repeated sound effect as a player gets closer or further
# away from the source of the volume, using the map x/y coordinates of
# the event and player to do so.
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
# Use this script by placing a script call in a map event to one of the three versions of the
# method below. Script calls should be given their own map event on
# 'parallel process' without anything else being in the event
#
#   Calling:
# radial_sound(srcX, srcY, filename, initVolume, soundPitch, soundDropoffModifier, waitTime)
# Use the above call for sounds from a specific pixel point
#
# radial_sound_event(filename, initVolume, soundPitch, soundDropoffModifier, waitTime)
# Use the above call for sounds from the location of the event which contains the script call
#
# radial_sound_event_name(eventName, filename, initVolume, soundPitch, soundDropoffModifier, waitTime)
# Use the above call for sounds from the location of the event with the eventName you specify
#
#   Parameters:
# srcX is the x value (in screen pixels) of where the sound is being emitted from
# srcY is the y value (in screen pixels) of where the sound is being emitted from
# filename is the filename for the sound effect Ex. 'MySoundFile' (no file extension needed)
# (note: will only recognize audio in the Sound Effect folder)
# initVolume should be the maximum volume you want a sound to reach
# soundPitch is the pitch of the sound, use as normal
# soundDropoffModifier is how fast sound decreases as distance increases. Use it like a percentage.
# (note: sDM can be made negative or above 100 for extra effect, though)
# waitTime is the amount of time (in !!--milliseconds--!!) that should pass before replaying the sound
# (this will usually be the length of the sound clip or close to it)
#
# Note: if you use the radial_sound_event version of the command, the srcX and srcY of the command will
# be set to update to the location of the event. Make sure to use this for moving events.
#
#   Examples:
# FULL EXAMPLE COMMAND 1: radial_sound(128, 384, 'mySoundFile', 80, 90, 100, 80)
# results in radial sound coming from screen coordinates (128, 384), using
# sound file 'mySoundFile' with max volume 80 and pitch 90,
# sDM of 100 (volume drops to 0 after ~5 tiles away), and a interval time of 80 milliseconds
#
# FULL EXAMPLE COMMAND 2: radial_sound_event('mySoundFile', 80, 90, 100, 80)
# results in the same thing as the previous command, but it uses the coordinates
# of whatever event the script command is placed in, rather than srcX and srcY
#
# FULL EXAMPLE COMMAND 3: radial_sound_event_name('My Event', 'mySoundFile', 80, 90, 100, 80)
# results in the same thing as the previous command, but it uses the coordinates
# of whatever event has the eventName you give it, in this case, it is 'My Event'
#
#
# __Modifiable Constants__
module RSOUND
  # helps determine the minimum amount of volume lessening as a result of
  # distance increasing. Feel free to change it, but only if all of your
  # sounds are getting quiet too fast, or too slowly consistently.
  # Additionally, I recommend keeping it in the range 0.1 < x <= 1
  # lower = slower sound dropoff | higher = faster sound dropoff
  SOUND_DROPOFF_BASE_VALUE = 0.25
  
  # __END OF MODIFIABLE CONSTANTS__
end



# BEGINNING OF SCRIPTING ====================================================
class Game_Interpreter

  #--------------------------------------------------------------------------
  # * Radial sound increasing/decreasing in volume depending on sound source x/y coordinates
  #--------------------------------------------------------------------------
	def radial_sound(srcX, srcY, filename, initVolume, soundPitch, soundDropoffModifier, waitTime)
    # get player x/y coords
    playerX = $game_player.x * 32 # times 32 to account for tile vs map position
    playerY = $game_player.y * 32
    # calculate distance (uses distance formula)
    distance = Math.sqrt((playerX - srcX)*(playerX - srcX) + (playerY - srcY)*(playerY-srcY))
    # calculate appropriate currVolume using distance, sDM, and the sDBV
    # the 0.5 is just to blanket lower the volume lessening, feel free to edit as needed
    currVolume = initVolume - (0.5 * distance * (((soundDropoffModifier / 100)) + RSOUND::SOUND_DROPOFF_BASE_VALUE))
    currVolume = currVolume.round()
    
    # debug statement for checking currVolume
    # $game_variables[100] = currVolume
    
    # play the sound if the currVolume is above 0
    if (currVolume > 0)
      RPG::SE.new(filename, currVolume, soundPitch).play
    end
    
    # wait the specified amount of time before repeating
    wait(waitTime)
    
  end
  
  
  #--------------------------------------------------------------------------
  # * Radial sound increasing/decreasing in volume depending on sound source x/y coordinates from event,
  # * and the event used is the one that contains the script call line
  #--------------------------------------------------------------------------
  def radial_sound_event(filename, initVolume, soundPitch, soundDropoffModifier, waitTime)
    playerX = $game_player.x * 32 # times 32 to account for tile vs map position
    playerY = $game_player.y * 32
    srcX = $game_map.events[@event_id].x * 32
    srcY = $game_map.events[@event_id].y * 32
    distance = Math.sqrt((playerX - srcX)*(playerX - srcX) + (playerY - srcY)*(playerY-srcY))
    currVolume = initVolume - (0.5 * distance * (((soundDropoffModifier / 100)) + RSOUND::SOUND_DROPOFF_BASE_VALUE))
    currVolume = currVolume.round()
    
    # debug statement for checking currVolume
    # $game_variables[100] = currVolume
    
    if (currVolume > 0)
      RPG::SE.new(filename, currVolume, soundPitch).play
    end
    
    wait(waitTime)
    
  end
  
  #--------------------------------------------------------------------------
  # * Radial sound increasing/decreasing in volume depending on sound source x/y coordinates from event,
  # * and the event used is the one that is given in eventName
  #--------------------------------------------------------------------------
  def radial_sound_event_name(eventName, filename, initVolume, soundPitch, soundDropoffModifier, waitTime)
    playerX = $game_player.x * 32
    playerY = $game_player.y * 32
    # get event id using the passed eventName
    eventID = $game_map.getMapIDFromEvent(eventName)
    srcX = $game_map.events[eventID].x * 32
    srcY = $game_map.events[eventID].y * 32
    distance = Math.sqrt((playerX - srcX)*(playerX - srcX) + (playerY - srcY)*(playerY-srcY))
    currVolume = initVolume - (0.5 * distance * (((soundDropoffModifier / 100)) + RSOUND::SOUND_DROPOFF_BASE_VALUE))
    currVolume = currVolume.round()
    
    # debug statement for checking currVolume
    # $game_variables[100] = currVolume
    
    if (currVolume > 0)
      RPG::SE.new(filename, currVolume, soundPitch).play
    end
    
    wait(waitTime)
    
  end
  
end


class Game_Map
  # array storing the event names in mapID order as a hash,
  # with names being the keys, and mapID being the values
  attr_reader :event_names
  
  #--------------------------------------------------------------------------
  # * Aliased helper method that uses alias to add name-id matchup hash
  # * into the setup_events method in class Game_Map
  #--------------------------------------------------------------------------
  alias before_indexing_event_names setup_events
  def setup_events
    before_indexing_event_names
    @event_names = Hash.new
    
    # iterate through all events, adding eventNames as keys, and the indexes as values
    for i in @map.events.keys
      currName = @map.events[i].name # get name of event at current index (in array of all events in map)
      event_names[currName] = i # use current event name as key, index as value
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Helper method used in the radial_sound_event using the eventName parameter,
  # * gets the mapID of an event from its event name using the preloaded
  # * event_names array
  #--------------------------------------------------------------------------
  def getMapIDFromEvent(eventName)
    return @event_names[eventName]
  end
  
end
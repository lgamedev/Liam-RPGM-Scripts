# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-ExSaveData"] = true
# END OF IMPORT SECTION

# Script:           Extra Save Data
# Author:           Liam
# Version:          1.1.1
# Description:
# This script allows you to save any kind of data (true/false values, numbers,
# etc.) to specific save files. This data is accessed using particular
# names attached to the pieces of data. This script generally exists for
# other scripts to utilize, although it can be used on its own.
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
# Note: This script uses Game_Party to store the data because the variables
# in it are stored associated to a given savefile.
#
# __Usage Guide__
# If you are only using the script because it is required by other scripts,
# simply having this script in the scripting section is all you need to do.
#
# If you want to do something new with this script, see below:
# This script is used by getting and setting values attached to data names.
# Use the Calling and Parameter information below to see how to use
# the script. The calls can be used in another script, or by themselves
# as a script line in a map event.
#
#   Calling:
# $game_party.getExSaveDataNoInit(dataName)
# Use the above call to get the value associated with the given dataName.
# USE THIS METHOD ONLY IF YOU ARE 100% SURE THAT THE HASH AND PIECE OF DATA
# IN THE HASH ALREADY EXISTS!
# (This means that the getExSaveData() with the initValue parameter or
# the setExSaveData() commands must be guranteed to have be used at
# least once before the getExSaveDataNoInit(dataName) call)
# (If you don't know what this means, you shouldn't use this version of the method)
#
# $game_party.getExSaveData(dataName, initValue)
# Use the above call to get the value associated with the given dataName.
# Additionally, the this method will initialize the new piece of data
# with the value given by initValue if the data was not present previously.
#
# $game_party.setExSaveData(dataName, newValue)
# Use the above call to set the value associated with the given dataName
# to the newValue.
# Additionally, the this method will initialize the new piece of data
# with the value given by newValue if the data was not present previously.
#
#   Parameters:
# dataName is the name attached to a given piece of data in quotes.
# initValue is a value to set the stored data value to if it has not been set before.
# newValue is the value to change a stored data value to (if not yet set, it will set it to this.)
#
#   Examples:
# $game_variables[100] = $game_party.getExSaveData("ACTOR_XP_LEADER", 1)
#
# The above script line will get the value associated with the ACTOR_XP_LEADER
# name and store it into the 100th game variable. Additionally, if
# the ACTOR_XP_LEADER value was not set previously, it will create space
# for the ACTOR_XP_LEADER data and set the associated value to 1.
#
# $game_party.setExSaveData("ACTOR_XP_LEADER", 1)
#
# The above script line will set the value associated with the ACTOR_XP_LEADER
# to 1. Additionally, if the ACTOR_XP_LEADER value was not set previously,
# it will create space for the ACTOR_XP_LEADER data and set the associated
# value to 1.
#
#
# No editable constants for this script.



# BEGINNING OF SCRIPTING ====================================================
class Game_Party < Game_Unit
  # stores the hash of the new key/value pairs that make up the new data pieces
  attr_reader   :exSaveData
  
  #--------------------------------------------------------------------------
  # * New method used to return the extra save data associated with the
  # * dataName in the hash. USE THIS METHOD ONLY IF YOU ARE 100%
  # * SURE THAT THE HASH AND PIECE OF DATA IN THE HASH ALREADY EXISTS!
  # * (This means that the getData() with the initValue parameter or
  # * the setExSaveData() commands must have guranteed to be used at
  # * least once before the getExSaveData(dataName) call)
  #--------------------------------------------------------------------------
  def getExSaveDataNoInit(dataName)
    initExSaveDataHash               # initalize the hash if it doesn't exist yet
    
    # return the value in the key-value
    return @exSaveData[dataName]
  end
  
  #--------------------------------------------------------------------------
  # * Overloaded getExSaveData() method used to initialize the exSaveData hash
  # * and/or key-value pair if either or both of them do not exist. initValue
  # * is used to initialize the value of the new key-value pair if it does
  # * not exist yet (otherwise, initValue is not used). Returns the extra
  # * save data given the dataName in the hash.
  #--------------------------------------------------------------------------
  def getExSaveData(dataName, initValue)
    initExSaveDataHash               # initalize the hash if it doesn't exist yet
    initNewKey(dataName, initValue)  # initialize the key-value pair if it doesn't exist yet
    
    # return the value in the key-value pair
    return @exSaveData[dataName]
  end
  
  #--------------------------------------------------------------------------
  # * New method used to set the extra save data associated with the
  # * dataName in the hash. It wil initialize the exSaveData hash
  # * and/or key-value pair if either or both of them do not exist. newValue
  # * is used to initialize the value of the new key-value pair.
  #--------------------------------------------------------------------------
  def setExSaveData(dataName, newValue)
    initExSaveDataHash               # initialize the hash if it doesn't exist yet
    initNewKey(dataName, newValue)   # initialize the key-value pair if it doesn't exist yet
    
    # temp hash to store the new key/val pair
    newDataTempHash = {dataName => newValue}
    # complete the merge to overwrite exSaveData k/v pair w/ new k/v pair
    @exSaveData.update(newDataTempHash)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to initialize the exSaveData hash if it does not
  # * exist yet.
  #--------------------------------------------------------------------------
  def initExSaveDataHash
    # if the exSaveData hash is not created, set exSaveData as an empty hash
    if (@exSaveData == nil)
      @exSaveData = Hash.new
    end
  end
  
  #--------------------------------------------------------------------------
  # * New helper method used to initialize the a new key-value pair if there is no
  # * key in the hash for dataName.
  #--------------------------------------------------------------------------
  def initNewKey(dataName, initValue)
    # check if the key currently exists, if it doesn't, add it to the key list
    if (!(@exSaveData.has_key?(dataName)))
      @exSaveData[dataName] = initValue
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to return if a piece of data currently exists
  # * (this is used for determining if a set of calculations needs to be
  # * done to create the data value or not)
  #--------------------------------------------------------------------------
  def doesExSaveDataExist?(dataName)
    initExSaveDataHash               # initalize the hash if it doesn't exist yet
    return (@exSaveData.has_key?(dataName))
  end

end
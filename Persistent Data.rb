# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-PersistentData"] = true
# END OF IMPORT SECTION

# Script:           Persistent Data
# Author:           Liam
# Version:          1.2
# Description:
# This script allows you to save any kind of data (true/false values, numbers,
# lists, etc.) across all save files using a generated file stored in a
# directory/folder you specify. This script may be utilized by other
# scripts, and script data has it's own text file. Persistent data
# is accessed using particular data names that you can set, and the
# data can be accessed inside of map events with script calls.
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
# Set the name of the directory/folder to store the persistent data text files
# in by changing the value of PDATA_DIRECTORY. Set the names of the two persistent
# data files (one for your use, and one for other script's use) by changing
# the value of PDATA_FILENAME and PDATA_OTHER_SCRIPTS_FILENAME. Tf you only
# have this script so it can be utilized by other scripts, then you are done.
#
# If you want to set up and use your own persistent data, first, set
# that data up with PDATA_STORED_DATA. Then, to retrieve that data in
# an event, use one of the script calls in the script call list further
# below. Use these script calls with the "Script..." option of page 3 of the
# Event Commands window when editing an event.
#
# Note: To fully reset all persistent data, just delete the persistent
# data files and they'll be remade with their initial default values.
#
#   Calling:
# DataManager.setPersistentDataEv(dataName, newDataVal)
# Use the above script call in a map event to set the persistent data piece
# with the name dataName to have the new data value of newDataVal
#
# DataManager.getPersistentDataEv(dataName)
# Use the above script call in a map event to get the persistent data piece
# with the name dataName. This will return whatever the actual value attached
# to the data is, and not just a string of text.
#
# setGameVariableP(gameVariableNumber, dataName)
# Use the above script call to copy the number or string of text from the value attached to the
# persistentDataName you enter into the game variable of the number you enter.
# If you put text into a variable, do not do math with it, or it will cause a crash.
#
# setGameSwitchP(gameSwitchNumber, dataName)
# Use the above script call to copy the true/false value from the value attached to the
# persistentDataName you enter into the game switch of the number you enter.
# Associated data value must be 'true' or 'false' (no actual quotes).
#
# setPVariable(gameVariableNumber, dataName)
# Use the above script call to copy the value from the game variable of the number
# you enter into the persistent data piece w/ the persistentDataName you enter.
#
# setPSwitch(gameSwitchNumber, dataName)
# Use the above script call to copy the true/false value from the game switch of the number
# you enter into the persistent data piece w/ the persistentDataName you enter.
#
#   Parameters:
# dataname is the name of the piece of data you are trying to get or change.
#
# gameVariableNumber/gameSwitchNumber is the number of the variable/switch whose
# value will be modified or used. You can find this value in the
# 'Control Switches/Control Variables' box in an event.
# persistentDataName is the name for the piece of data you want the value of. It is
# the name that you set in PDATA_STORED_DATA_LOCATIONS and PDATA_TEXT.
#
#   Examples:
# Example data used is below v
# PDATA_STORED_DATA = {
#   # test value
#   "myText" => "hello",
#   "mySecondData" => true,
#   "testValue3" => {"testKey1" => [1, 2, 3], "testKey2" => [4, 5, 6]},
#   "testValue4" => "AAAAAAAAAAAAAAAAAAAAAAAA",
#   "testValue5" => false
# }
#
# setGameVariableP(100, myText)
# setGameSwitchP(50, mySecondData)
#
# Using the above script calls in a map event will result in the text 'hello'
# being saved to the 100th game variable (which can then be used in dialogue, etc.),
# and the value 'true' (or ON), being set for the 50th game switch.
#
# setPVariable(100, myText)
# setPSwitch(50, mySecondData)
#
# Using the above script calls in a map event will result in the persistent data
# associated with the 'myText' name being updated to the value in the
# 100th game variable, and the persistent data associated with the 'mySecondData'
# name being updated to the true/false value in the 50th game switch.
#
#
# __Modifiable Constants__
module PDATA
  # The name of the folder that the persistent data text files will be
  # placed into in the game directory.
  #
  # Note: If you change this name after the folder and files are already
  # set up, the data will be reset since new persistent data text files 
  # will be made and used under the new directory name.
  PDATA_DIRECTORY = "persistentData"
  
  # The filename of the file to store "normal" persistent data in.
  #
  # Note 1: Requires a file extension at the end!
  #
  # Note 2: Use .txt as your file extensions for easy manual editing
  # (but players may try to edit it), or create you own extension
  # (just make sure it is not an existing one) and I think it should still work.
  #
  # Note 3: Your file data will be reset if you change this filename after
  # the old file has already been set up.
  PDATA_FILENAME = "pVarData.txt"
  
  # The filename of the file to store "other scripts" persistent data in.
  # This persistent data comes from other scripts that use this script.
  # Most of the time, you should never need to look at or edit this file
  # since its data will be handled automatically by the other scripts.
  #
  # Note 1: Requires a file extension at the end!
  #
  # Note 1: Use .txt as your file extensions for easy manual editing
  # (but players may try to edit it), or create you own extension
  # (just make sure it is not an existing one) and I think it should still work.
  #
  # Note 3: Your file data will be reset if you change this filename after
  # the old file has already been set up.
  PDATA_OTHER_SCRIPTS_FILENAME = "pVarDataOtherScripts.txt"
  
  # A list of the data names and their associated inital values that will be
  # put into the "normal" persistent data file. These initial values may
  # be numbers, strings of text, true/false values, or even lists of values.
  #
  # Note: If you add or remove dataName and value pairs to this list, 
  # the normal persistent data file will be automatically updated to include
  # the new entry. However, changing the value of one of the items
  # on this list will not change the value stored in persistent data
  # if that value is already set. If you want to edit the value
  # currently stored in persistent data, you can use the
  # script call DataManager.setPersistentDataEv or just edit the text
  # file manually.
  #
  # format:
  #   dataName => dataValue
  # Ex.
  # PDATA_STORED_DATA = {
  #   "testValue1" => 1,
  #   "testValue2" => ["apples", "oranges", "bananas"],
  #   "testValue3" => {"testKey1" => [1, 2, 3], "testKey2" => [4, 5, 6]},
  #   "testValue4" => "grapefruit",
  #   "testValue5" => false
  # }
  PDATA_STORED_DATA = {
  }
  
  # __END OF MODIFIABLE CONSTANTS__
  
  

# BEGINNING OF SCRIPTING ====================================================
  # Hash with the filepaths to use when accessing persistent data
  # depending on the filename
  PDATA_FILEPATH = {PDATA_FILENAME => (PDATA_DIRECTORY + "/" + PDATA_FILENAME),
                    PDATA_OTHER_SCRIPTS_FILENAME => (PDATA_DIRECTORY + "/" + PDATA_OTHER_SCRIPTS_FILENAME)}
  
  # stores which files pair up with which accessor variables in
  # the DataManager module
  PDATA_FILE_TO_ACCESSOR_VAR = {PDATA_FILENAME => "persistentData", PDATA_OTHER_SCRIPTS_FILENAME => "otherScriptsPersistentData"}
end


module DataManager
  # Stores all persistent data, including the "normal" persistent data
  # and the script persistent data
  @allPersistentData = {}
  
  # Stores hash with script data that should be saved into persistent data.
  # Keys are pieces of data, and the values are the initial value for the
  # data (not used if already saved)
  @scriptPersistentDataToSetup = {}
  
  #--------------------------------------------------------------------------
  # * New method that just returns allPersistentData implicitly.
  #--------------------------------------------------------------------------
  def self.allPersistentData
    @allPersistentData
  end
  
  #--------------------------------------------------------------------------
  # * New method that just returns scriptPersistentDataToSetup implicitly.
  #--------------------------------------------------------------------------
  def self.scriptPersistentDataToSetup
    @scriptPersistentDataToSetup
  end
  
  #--------------------------------------------------------------------------
  # * New method that prepares the hash of persistent data from other
  # * scripts.
  #--------------------------------------------------------------------------
  def self.prepareScriptPersistentData
    # if scriptPersistentDataToSetup is not nil clear the hash
    if (@scriptPersistentDataToSetup != nil)
      @scriptPersistentDataToSetup.clear
    end
    
    
    # different data pieces from other scripts will be initialized
    # here through aliasing this method in those other scripts
  end
  
  #--------------------------------------------------------------------------
  # * New method that loads a file of persistent data into the persistentData
  # * accessor as a hash w/ line number as the keys.
  #--------------------------------------------------------------------------
  def self.loadPersistentData(pDataFilename)
    # Set the allPersistentData hash to have two hashes in it, one
    # for "normal" persistent data, and one for "other script" persistent data
    if (@allPersistentData.nil?)
      @allPersistentData = {"persistentData" => {}, "otherScriptsPersistentData" => {}}
    elsif (@allPersistentData.empty?)
      @allPersistentData["persistentData"] = {}
      @allPersistentData["otherScriptsPersistentData"] = {}
    else
      @allPersistentData.clear
      @allPersistentData = {"persistentData" => {}, "otherScriptsPersistentData" => {}}
    end
    
    # Get which type of persistent data is needed based off of the filename
    persistentDataType = PDATA::PDATA_FILE_TO_ACCESSOR_VAR[pDataFilename]
    
    # if the hash in question does not exist, create it, otherwise clear the hash
    if (!@allPersistentData.has_key?(persistentDataType))
      @allPersistentData[persistentDataType] = Hash.new
    else
      @allPersistentData[persistentDataType].clear
    end
    
    # get the current persistent data hash being dealt with
    currPDataHash = @allPersistentData[persistentDataType]
    
    # open file w/ pdata filepath in (r)ead mode
    file = File.open(PDATA::PDATA_FILEPATH[pDataFilename], "r")
    # go through file line by line, storing data
    file.each do |line|
      # get the string portion before the '='
      lineKeyString = line.partition('=').first
      # get the string portion after the '='
      lineValString = line.partition('=').last
      # evaluate the string segment after the '=' as Ruby code and use as the value
      currPDataHash[lineKeyString] = eval(lineValString)
    end
    
    # close the file
    file.close
  end
  
  #--------------------------------------------------------------------------
  # * New method that gets pre-loaded persistent data using the name of
  # * the data as the parameter. Returns the data value.
  # *
  # * pDataType should either be "persistentData" or "otherScriptsPersistentData"
  #--------------------------------------------------------------------------
  def self.getPersistentData(pDataType, dataName)
    currPDataHash = @allPersistentData[pDataType]
    dataValue = currPDataHash[dataName]
    return dataValue
  end
  
  #--------------------------------------------------------------------------
  # * New method that is basically copy of getPersistentData() used
  # * to simplify the script call to one parameter for ease of use.
  # * Returns the data value, whatever it may be.
  # * Call with: DataManager.getPersistentDataEv(dataName)
  #--------------------------------------------------------------------------
  def self.getPersistentDataEv(dataName)
    # current data type is "normal" persistent data
    pDataType = "persistentData"
    currPDataHash = @allPersistentData[pDataType]
    dataValue = currPDataHash[dataName]
    return dataValue
  end
  
  #--------------------------------------------------------------------------
  # * New method that sets both the pre-loaded persistent data in persistentData
  # * and the data in the persistent data text file using the name associated
  # * with the data and the value of the data as a string.
  #--------------------------------------------------------------------------
  def self.setPersistentData(pDataType, dataName, newDataVal)
    currPDataHash = @allPersistentData[pDataType] # get hash being dealt with
    # initialize the persistent data filename being dealt with as an empty string
    pDataFilename = ""
    # get the actual persistent data filename using the pDataType
    if (pDataType == "persistentData")
      # dealing with normal persistent data, so use the normal filename
      pDataFilename = PDATA::PDATA_FILENAME
    elsif (pDataType == "otherScriptsPersistentData")
      # dealing with script persistent data, so use the script filename
      pDataFilename = PDATA::PDATA_OTHER_SCRIPTS_FILENAME
    end
    
    # SET UP DATA IN THE TEMPORARY HASH AND UPDATE
    # Use a temporary hash to store the new key-value pair
    newDataTempHash = {dataName => newDataVal}
    # update the current persistent data hash to overwrite 
    # the old key-value pair w/ the new key-value pair
    currPDataHash.update(newDataTempHash)
    
    # GET ALL LINES IN THE CURRENT PERSISTENT DATA TEXT FILE
    # where to store the file contents w/ the edited line
    fileLines = ""
    # targetLineName is the dataName of the piece of data to modify
    targetLineName = dataName
    # open file w/ pdata filepath in (r)ead mode
    readFile = File.open(PDATA::PDATA_FILEPATH[pDataFilename], "r")
    # go through file line by line, storing data
    readFile.each_line do |line|
      # get the line's dataName the string portion before the '='
      lineDataname = line.partition('=').first
      
      # if the line's dataName matches the name of the piece of data
      # being changed, then modify the line to contain the new value
      if (lineDataname == targetLineName)
        # add back '=' symbol
        lineDataname = lineDataname + '='
        # get the new data value as a string
        newDataValString = newDataVal.to_s
        # if the new data value was originally a string, add extra quotes
        if (newDataVal.is_a?(String))
          # add an extra set of quotes around the value since
          # it should have quotes inside of the persistent data file
          newDataValString = "\"" + newDataValString + "\""
        end
        # add newDataString after the '=' symbol
        modifiedLine = lineDataname + newDataValString
        # add the modified line to the fileLines string
        fileLines = fileLines + modifiedLine + "\n"
      else
        fileLines = fileLines + line # put in line without modification
      end
    end
    # stop reading file
    readFile.close
    
    # remove the end \n character from the fileLines string if there is one
    fileLines = fileLines.strip

    # SET DATA IN THE FILE
    # open file w/ pdata filepath in (w)rite mode
    File.open(PDATA::PDATA_FILEPATH[pDataFilename], "w") {|file| file.write(fileLines)}
    # the above line closes the file automatically
  end
  
  #--------------------------------------------------------------------------
  # * New method that is basically a copy of setPersistentData() use for
  # * simplifying the script call down to two parameters when using
  # * script calls in map events.
  # * Call with: DataManager.setPersistentDataEv(dataName, newDataVal)
  #--------------------------------------------------------------------------
  def self.setPersistentDataEv(dataName, newDataVal)
    # currPDataHash, pDataType, and pDataFilename is for normal persistent data
    pDataType = "persistentData"
    currPDataHash = @allPersistentData[pDataType]
    pDataFilename = PDATA::PDATA_FILENAME
    
    # SET UP DATA IN THE TEMPORARY HASH AND UPDATE
    # Use a temporary hash to store the new key-value pair
    newDataTempHash = {dataName => newDataVal}
    # update the current persistent data hash to overwrite 
    # the old key-value pair w/ the new key-value pair
    currPDataHash.update(newDataTempHash)
    
    # GET ALL LINES IN THE CURRENT PERSISTENT DATA TEXT FILE
    # where to store the file contents w/ the edited line
    fileLines = ""
    # targetLineName is the dataName of the piece of data to modify
    targetLineName = dataName
    # open file w/ pdata filepath in (r)ead mode
    readFile = File.open(PDATA::PDATA_FILEPATH[pDataFilename], "r")
    # go through file line by line, storing data
    readFile.each_line do |line|
      # get the line's dataName the string portion before the '='
      lineDataname = line.partition('=').first
      
      # if the line's dataName matches the name of the piece of data
      # being changed, then modify the line to contain the new value
      if (lineDataname == targetLineName)
        # add back '=' symbol
        lineDataname = lineDataname + '='
        # get the new data value as a string
        newDataValString = newDataVal.to_s
        # if the new data value was originally a string, add extra quotes
        if (newDataVal.is_a?(String))
          # add an extra set of quotes around the value since
          # it should have quotes inside of the persistent data file
          newDataValString = "\"" + newDataValString + "\""
        end
        # add newDataString after the '=' symbol
        modifiedLine = lineDataname + newDataValString
        # add the modified line to the fileLines string
        fileLines = fileLines + modifiedLine + "\n"
      else
        fileLines = fileLines + line # put in line without modification
      end
    end
    # stop reading file
    readFile.close
    
    # remove the end \n character from the fileLines string if there is one
    fileLines = fileLines.strip

    # SET DATA IN THE FILE
    # open file w/ pdata filepath in (w)rite mode
    # and write in the new file contents
    File.open(PDATA::PDATA_FILEPATH[pDataFilename], "w") {|file| file.write(fileLines)}
    # the above line closes the file automatically
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create a persistent data file and the directory
  # * the file is placed into if the file/directory are not found.
  # * Does nothing if the file already exists.
  #--------------------------------------------------------------------------
  def self.createPersistentFile(pDataFilename)
    # create new directory and file if file cannot be found, otherwise, do nothing
    if (!(File.exist?(PDATA::PDATA_FILEPATH[pDataFilename])))
      # get directory name
      directory_name = PDATA::PDATA_DIRECTORY
      # make new directory w/ directory name title unless it already exists
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      
      # start the current data hash as nil
      currPDatahash = nil
      # deteremine the hash to use to setup the the text for the file depending
      # on whether the file being set up is the normal or script persistent data
      if (pDataFilename == PDATA::PDATA_FILENAME)
        # for the "normal" persistent data, the current data hash is PDATA_STORED_DATA
        currPDataHash = PDATA::PDATA_STORED_DATA
      elsif (pDataFilename == PDATA::PDATA_OTHER_SCRIPTS_FILENAME)
        # for the script persistent data, the current data hash is scriptPersistentDataToSetup
        currPDataHash = @scriptPersistentDataToSetup
      end
      # initialize fileContentsArray as an empty array
      fileContentsArray = []
      # get the current text to setup by iterating over the current data hash
      currPDataHash.each do |key, value|
        currKey = key # get current key
        # get the value that goes with the key as a string
        currValue = value.to_s
        # if the original was originally a string, add extra quotes
        if (value.is_a?(String))
          # add an extra set of quotes around the value since
          # it should have quotes inside of the persistent data file
          currValue = "\"" + currValue + "\""
        end
        # the current text line will be key=value where value is in string form
        currTextLine = key + "=" + currValue
        # add the current text line to the end of the file contents array
        fileContentsArray.push(currTextLine)
      end
      
      # \n represents a newline (like pressing enter on your keyboard)
      newlineChar = "\n"
      # the final index of the file contents array is its length-1
      finalIndex = fileContentsArray.length - 1
      # start the actual file contents as an empty string
      fileContents = ""

      # file contents should be each line stored in the array
      # with a newline in between each array entry
      # (except for at the last index; the end of the file)
      fileContentsArray.each_with_index do |line, i|
        # add the array entry into the file contents
        fileContents = fileContents + line
        # add newline char as long as the index is not the last index
        if (i != finalIndex)
          fileContents = fileContents + newlineChar
        end
      end
      
      # open file w/ pdata filepath in (w)rite mode
      # and write in the file contents
      File.open(PDATA::PDATA_FILEPATH[pDataFilename], "w") {|file| file.write(fileContents)}
      # the above line closes the file automatically
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update the persistent data file if the associated
  # * initial value storing hashes have had keys added or removed to
  # * them (aka the key/dataName cannot be found in the persistent data file
  # * in question).
  # * Does not trigger an update if no new keys are found.
  #--------------------------------------------------------------------------
  def self.updatePersistentFile(pDataFilename)
    # boolean to check if the file needs to be updated to add key-value pairs,
    # starts false
    fileNeedsAddUpdate = false
    # boolean to check if the file needs to be updated to remove key-value pairs,
    # starts false
    fileNeedSubUpdate = false
    
    # get which type of persistent data is needed based off of the filename
    persistentDataType = PDATA::PDATA_FILE_TO_ACCESSOR_VAR[pDataFilename]
    # get the current persistent data hash being dealt with
    #
    # in this case, the current hash being dealt with is the hash
    # with the initial values
    currPDataHash = nil # start with currPDataHash as nil
    # get the actual persistent data filename using the pDataType
    if (persistentDataType == "persistentData")
      # dealing with normal persistent data, so use the "normal" initial values hash
      currPDataHash = PDATA::PDATA_STORED_DATA
    elsif (persistentDataType == "otherScriptsPersistentData")
      # dealing with script persistent data, so use the "other scripts" initial values hash
      currPDataHash = @scriptPersistentDataToSetup
    end
    
    # get all the keys in the hash being dealt with as an array
    currHashKeys = currPDataHash.keys
    # will store the keys in persistent data that are not in the initial hash data
    hashKeysToRemove = []
    
    # open the file in (r)ead mode for checking it against the associate hash data
    checkFile = File.open(PDATA::PDATA_FILEPATH[pDataFilename], "r")
    # go through file line by line, checking if there is a difference (not counting value)
    checkFile.each_line do |line|
      # get current line
      currLine = line
      # get the string portion before the '=' to get the key for the line
      lineKeyString = line.partition('=').first
      # if the lineKeyString is not found as a key in the initial data hash,
      # then mark is subtraction update as needed and add the key
      # to the list of hashKeysToRemove
      if (!currPDataHash.has_key?(lineKeyString))
        fileNeedSubUpdate = true
        hashKeysToRemove.push(lineKeyString) # add to the list
      end
      # delete the key from the associated hash's key list
      currHashKeys.delete(lineKeyString)
    end
    # stop reading file
    checkFile.close
    
    # initialize the current keys to add as nil
    keysToAdd = nil
    # if the current hash keys list is not empty, then the file
    # needs an addition update
    if (!currHashKeys.empty?)
      fileNeedsAddUpdate = true
      # set the keysToAdd as the remaining currHashKeys
      keysToAdd = currHashKeys
    end

    # if file needs an addition update, then do it, otherwise, do nothing
    if (fileNeedsAddUpdate == true)
      # initialize the new file string as an empty string
      newFileString = ""
      # get the current file contents as one string
      oldFile = File.open(PDATA::PDATA_FILEPATH[pDataFilename], "r")
      # set the new file's string to the old file's contents
      newFileString = oldFile.read
      newLineChar = "\n" # get the newline character
      newFileString += newLineChar# add a newLineChar at the end
      oldFile.close # close the old file
      
      # get the final index of the keysToAdd array
      finalIndex = keysToAdd.length - 1
      # add the new key-value pairs to the old text file's string
      keysToAdd.each_with_index do |key, index|
        # get the value that goes with the key as a string
        valueToAdd = currPDataHash[key].to_s
        # if the current value was originally a string, add extra quotes
        if (currPDataHash[key].is_a?(String))
          # add an extra set of quotes around the value since
          # it should have quotes inside of the persistent data file
          valueToAdd = "\"" + valueToAdd + "\""
        end
        
        # get the new line to add to the new file's string
        newLineToAdd = key + "=" + valueToAdd
        # add newline char as long as the index is not the last index
        if (index != finalIndex)
          newLineToAdd += newLineChar
        end
        # add the new line to the newFileString
        newFileString += newLineToAdd
      end
      
      # open file w/ pdata filepath in (w)rite mode
      # and write in the new file contents
      File.open(PDATA::PDATA_FILEPATH[pDataFilename], "w") {|file| file.write(newFileString)}
      # the above line closes the file automatically
    end
    
    # if the file needs a subtraction update, then do it, otherwise, do nothing
    if (fileNeedSubUpdate == true)
      # delete the keys
      deletePersistentData(currPDataHash, persistentDataType, hashKeysToRemove)
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * New method that used to delete a piece of data from persistent
  # * data and temporary storage. Used in the update function when
  # * a piece of data has been removed from the associated initial data hash.
  #--------------------------------------------------------------------------
  def self.deletePersistentData(initialDataHash, pDataType, keysToDelete)
    currPDataHash = @allPersistentData[pDataType] # get temp-storage hash being dealt with
    # initialize the persistent data filename being dealt with as an empty string
    pDataFilename = ""
    # get the actual persistent data filename using the pDataType
    if (pDataType == "persistentData")
      # dealing with normal persistent data, so use the normal filename
      pDataFilename = PDATA::PDATA_FILENAME
    elsif (pDataType == "otherScriptsPersistentData")
      # dealing with script persistent data, so use the script filename
      pDataFilename = PDATA::PDATA_OTHER_SCRIPTS_FILENAME
    end
    
    # DELETE DATA FROM THE TEMPORARY-STORAGE HASH
    # Iterate over the list to keysToDelete and delete each key from
    # the temporary storage hash
    keysToDelete.each do |key|
      currPDataHash.delete(key)
    end
    
    # GET ALL LINES IN THE CURRENT PERSISTENT DATA TEXT FILE WITHOUT
    # THE LINES TO DELETE
    # where to store the file contents w/ the edited line
    fileLines = ""
    # open file w/ pdata filepath in (r)ead mode
    readFile = File.open(PDATA::PDATA_FILEPATH[pDataFilename], "r")
    # go through file line by line, storing data
    readFile.each_line do |line|
      # get the line's dataName the string portion before the '='
      lineDataname = line.partition('=').first
      
      # if the line's dataName matches one of of the key's to delete,
      # then do not add the line to the fileLines string
      addLineToFileLines = !(keysToDelete.include?(lineDataname))
      
      # for keys to keep, add them to the fileLines string
      if (addLineToFileLines == true)
        fileLines = fileLines + line # add the line
      end
    end
    # stop reading file
    readFile.close
    
    # remove the end \n character from the fileLines string if there is one
    fileLines = fileLines.strip

    # SET DATA IN THE FILE
    # open file w/ pdata filepath in (w)rite mode
    File.open(PDATA::PDATA_FILEPATH[pDataFilename], "w") {|file| file.write(fileLines)}
    # the above line closes the file automatically
  end
  
  # aliases the init() method from the DataManager module to initialize/update/etc
  # persistent data when the game data is first loaded
  class << self
    alias beforePersistentDataInit init
  end
  
  #--------------------------------------------------------------------------
  # * Aliased init() method in the DataManager module used to
  # * initialize/update/etc persistent data when the game is loaded.
  #--------------------------------------------------------------------------
  def self.init
    # Call original method
    beforePersistentDataInit
    
    # Set the allPersistentData hash to have two hashes in it, one
    # for "normal" persistent data, and one for "other script" persistent data
    if (@allPersistentData.nil?)
      @allPersistentData = {"persistentData" => {}, "otherScriptsPersistentData" => {}}
    elsif (@allPersistentData.empty?)
      @allPersistentData["persistentData"] = {}
      @allPersistentData["otherScriptsPersistentData"] = {}
    else
      @allPersistentData.clear
      @allPersistentData = {"persistentData" => {}, "otherScriptsPersistentData" => {}}
    end
    # Set the scriptPersistentDataToSetup hash to an empty hash if it does not exist
    if (@scriptPersistentDataToSetup.nil?)
      @scriptPersistentDataToSetup = {}
    else
      @scriptPersistentDataToSetup.clear
      @scriptPersistentDataToSetup = {}
    end
    
    # Prepare any script persistent data if in case it is needed for setup
    prepareScriptPersistentData
    
    # create new folder/file for normal persistent data if it does not exist
    createPersistentFile(PDATA::PDATA_FILENAME)
    # create new file for script persistent data if it does not exist
    createPersistentFile(PDATA::PDATA_OTHER_SCRIPTS_FILENAME)
    
    # update file for the normal persistent data file if new keys (dataNames)
    # have been added
    updatePersistentFile(PDATA::PDATA_FILENAME)
    # update file for the other scripts persistent data file if
    # new keys (dataNames) have been added
    updatePersistentFile(PDATA::PDATA_OTHER_SCRIPTS_FILENAME)
    
    # load persistent data from the norm persistend datafile
    # into temporary storage
    loadPersistentData(PDATA::PDATA_FILENAME)
    # load persistent data from the other scripts persistent data file
    # into temporary storage
    loadPersistentData(PDATA::PDATA_OTHER_SCRIPTS_FILENAME)
  end
  
end


class Game_Interpreter
  #--------------------------------------------------------------------------
  # * New method used to set a game variable (in the normal game database)
  # * to be the value associated with the specified persistent data name.
  # * Value associated w/ the the persistent data name MUST BE A NUMBER OR
  # * A SET OF TEXT.
  #--------------------------------------------------------------------------
	def setGameVariableP(gameVariableNumber, persistentDataName)
    $game_variables[gameVariableNumber] = getPersistentDataEv(persistentDataName)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to set a game switch (in the normal game database)
  # * to be the value associated with the specified persistent data name.
  # * Value associated w/ the the persistent data name MUST BE 'true' OR 'false'.
  #--------------------------------------------------------------------------
  def setGameSwitchP(gameSwitchNumber, persistentDataName)
    $game_switches[gameSwitchNumber] = getPersistentDataEv(persistentDataName)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to set a persistent data piece (temporary hash and in the file)
  # * to be the value in a game variable
  #--------------------------------------------------------------------------
  def setPVariable(gameVariableNumber, persistentDataName)
    # set persistent data takes data as a string, so first convert the variable
    # value to a string
    stringData = $game_variables[gameVariableNumber].to_s
    # send the data to the DataManager setPersistentData method
    DataManager.setPersistentDataEv(persistentDataName, stringData)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to set a persistent data piece (temporary hash and in the file)
  # * to be the value in a game switch
  #--------------------------------------------------------------------------
  def setPSwitch(gameSwitchNumber, persistentDataName)
    # set persistent data takes data as a string, so first convert the variable
    # value to a string
    stringData = $game_switches[gameSwitchNumber].to_s
    # send the data to the DataManager setPersistentData method
    DataManager.setPersistentDataEv(persistentDataName, stringData)
  end
  
end
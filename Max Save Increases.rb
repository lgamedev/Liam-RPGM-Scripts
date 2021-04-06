# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-MaxSaveIncreases"] = true
# END OF IMPORT SECTION

# Script:           Max Save Increases
# Author:           Liam
# Version:          1.2
# Description:
# This script increases the amount of available save files by one whenever
# the last available save file is saved to by the player. If savefiles are
# added or deleted in or out of game, the script should adapt to the correct
# maximum number of available savefiles.
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
# Modify the initial max number of saves to whatever number you want.
# The script should work fine from there.
#
#
# __Modifiable Constants__
module MSAVESINC
  # The maximum number of saves you want initially.
  # Not used if using the AQS auto/quick saving script.
  INIT_MAX_NUM_SAVES = 20
  
  # __END OF MODIFIABLE CONSTANTS__
end



# BEGINNING OF SCRIPTING ====================================================
module DataManager
  # New class variable to store the num of savefiles to add past the
  # normal max count. Starts nil (so the initial value can be properly
  # figured out if it hasn't been set for the first time after game launch).
  @@saveAdditions = nil
  
  #--------------------------------------------------------------------------
  # * New method to return the value of saveAdditions.
  #--------------------------------------------------------------------------
  def self.saveAdditions
    @@saveAdditions # returns the value implicitly
  end
  
  #--------------------------------------------------------------------------
  # * Overriden self.savefile_max() used to add additional savefiles to
  # * the savefile max count based on the persistent data storage. Returns
  # * the proper max num of saves to show on save-related screens.
  #--------------------------------------------------------------------------
  def self.savefile_max
    # initialize needMaxSavefileCheck to false, must prove true
    needMaxSavefileCheck = false
    
    # if saveAdditions does not exist then set it to 0
    # and then mark needMaxSavefileCheck to true since the
    # highest-numbered savefile needs to be found in the game directory
    # so saveAdditions can be updated accordingly
    if (@@saveAdditions.nil?)
      @@saveAdditions = 0
      needMaxSavefileCheck = true
    end
    
    # initialize currMaxSavefiles to 0
    currMaxSavefiles = 0
    # get the current max number of save files that should be added according
    # to the current value of saveAdditions
    aqSavesPresent = $imported["Liam-AutoQuickSaving"]
    # use AQSAVES max save num if script present,
    # otherwise use MSAVEINC max save num
    if (aqSavesPresent)
      # +1 to account for the AQsavefile, and add new save additions
      currMaxSavefiles = AQSAVES::MAX_NUM_SAVES + 1 + @@saveAdditions
    else
      # add new save additions
      currMaxSavefiles = MSAVESINC::INIT_MAX_NUM_SAVES + @@saveAdditions
    end
    
    # if the max savefile needs to be found, then find it and
    # update saveAdditions accordingly.
    #
    # this check should only have to be done the first time a save-related
    # screen is opened after launching the gameA
    if (needMaxSavefileCheck == true)
      # get all the savefiles in the directory
      allDirectorySavefileNames = Dir.glob("Save*.rvdata2")
      # only do the rest of the max savefile checks if there is
      # any save data in the game directory
      if (!allDirectorySavefileNames.empty?)
        # get the final savefile name (from the last index)
        finalSavefileName = allDirectorySavefileNames[(allDirectorySavefileNames.length - 1)]
        
        # get the finalSavefileName without the file extension
        finalSavefileName = finalSavefileName.partition(".rvdata2").first
        # use regex to get the number of the savefile
        # (replace all characters except the digits 0-9 with an empty string)
        # (also convert it to an integer)
        finalSavefileNum = (finalSavefileName.gsub(/[^0-9]/, "")).to_i
        
        # if the final savefile number is greater than the
        # current maximum number of savefiles that there should be
        # according to saveAdditions, then add the fileSavefileNum
        # minus the current number of maxSavefiles to saveAdditions
        # plus an extra 1 to add the new savefile
        if (finalSavefileNum > currMaxSavefiles)
          @@saveAdditions += ((finalSavefileNum - currMaxSavefiles) + 1)
        end
        
        # recalculate the current max savefile number
        if (aqSavesPresent)
          # +1 to account for the AQsavefile, and add new save additions
          currMaxSavefiles = AQSAVES::MAX_NUM_SAVES + 1 + @@saveAdditions
        else
          # add new save additions
          currMaxSavefiles = MSAVESINC::INIT_MAX_NUM_SAVES + @@saveAdditions
        end
      end
    end
    
    # get what should be the current max savefile number so that it can be
    # checked for accuracy (-1 since the savefile max includes the newest
    # empty slot)
    currMaxSavefile = (currMaxSavefiles - 1)
    # initialize the currMaxSavefileFilename to an empty string
    currMaxSavefileFilename = ""
    # get the current last save file that should exist
    # note: 0 is added before single digit numbers
    if (currMaxSavefile < 10)
      currMaxSavefileFilename = "Save" + "0" + currMaxSavefile.to_s + ".rvdata2"
    else
      currMaxSavefileFilename = "Save" + currMaxSavefile.to_s + ".rvdata2"
    end
    
    # if saveAdditions is greater than 0, and what should be the
    # final savefile does not exist, than decrement saveAdditions and
    # try to find a matching savefile until saveAdditions reaches 0,
    # or the matching savefile is found
    #
    # Note: this makes it so the game doesn't crash when savefiles
    # are deleted during gameplay and updates to the proper count instead
    if (@@saveAdditions > 0)
      # checks if there is a matching file in the game directory
      if (Dir.glob(currMaxSavefileFilename).empty?)
        # start with a matching savefile as not found
        matchingSavefileFound = false
        
        # start the current savefile being checked as currMaxSavefile
        currSavefileChecked = currMaxSavefile
        # loop and decrement saveAdditions until it reaches 0 or
        # a matching savefile is found
        while (@@saveAdditions > 0 && matchingSavefileFound == false)
          currSavefileNameToCheck = "" # initialize as empty string
          if (currSavefileChecked < 10)
            currSavefileNameToCheck = "Save" + "0" + currSavefileChecked.to_s + ".rvdata2"
          else
            currSavefileNameToCheck = "Save" + currSavefileChecked.to_s + ".rvdata2"
          end
          
          # if the current savefile is found in the game directory,
          # then mark the matching savefile as found,
          # otherwise decrement currSavefileChecked and saveAdditions
          if (!Dir.glob(currMaxSavefileFilename).empty?)
            matchingSavefileFound = true
          else
            currSavefileChecked -= 1# decrement current savefile checked
            @@saveAdditions -= 1 # decrement saveAdditions
          end
        end
      end
    end
    
    # if the last save file exists, then add one to saveAdditions
    if (last_save_file_exists?)
      @@saveAdditions += 1
    end
    
    # check if the AQS auto/quicksave script is used
    aqSavesPresent = $imported["Liam-AutoQuickSaving"]
    # initialize final max saves result to 0
    finalMaxSavesResult = 0
    # use AQSAVES max save num in present, otherwise use MSAVEINC max save num
    if (aqSavesPresent)
      # +1 to account for the AQsavefile, and add new save additions
      finalMaxSavesResult = AQSAVES::MAX_NUM_SAVES + 1 + @@saveAdditions
    else
      # add new save additions
      finalMaxSavesResult = MSAVESINC::INIT_MAX_NUM_SAVES + @@saveAdditions
    end
    
    # return the finalMaxSavesResult
    return finalMaxSavesResult
  end
  
  #--------------------------------------------------------------------------
  # * New method used to determine if the last savefile out of the currently
  # * existing list of savefiles in the game directory is used.
  #--------------------------------------------------------------------------
  def self.last_save_file_exists?
    # if saveAdditions does not exist, set it to 0
    if (@@saveAdditions.nil?)
      @@saveAdditions = 0
    end
    
    # initialize maxSaves to 0
    maxSaves = 0
    # check if the AQS auto/quicksave script is used
    aqSavesPresent = $imported["Liam-AutoQuickSaving"]
    if (aqSavesPresent)
      # get current max save number w/ +1 to account for the AQsavefile
      maxSaves = (AQSAVES::MAX_NUM_SAVES + 1 + @@saveAdditions)
    else
      # get current max save number
      maxSaves = (MSAVESINC::INIT_MAX_NUM_SAVES + @@saveAdditions)
    end
    
    # the last save number is the maxSaves number
    lastSaveNum = maxSaves
    lastSavefileTxt = "" # initialize lastSavefileTxt to empty string
    # if the last savefile number is a one digit number, add 0 before it
    if (lastSaveNum < 10)
      lastSavefileTxt = "Save" + "0" + lastSaveNum.to_s + ".rvdata2"
    else
      lastSavefileTxt = "Save" + lastSaveNum.to_s + ".rvdata2"
    end
    # check if there is a file matching the lastSavefileTxt in the game directory
    # and return the result implicitly
    !Dir.glob(lastSavefileTxt).empty?
  end

end
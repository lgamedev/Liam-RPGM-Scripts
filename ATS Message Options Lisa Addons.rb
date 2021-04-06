#IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-ATSMessageOptionsAddon"] = true
# END OF IMPORT SECTION

# ------------------- ! REQUIRES 'ATS MESSAGE OPTIONS' SCRIPT ! -------------------
# ------------------- ! REQUIRES 'EXTRA SAVE DATA' SCRIPT     ! -------------------
# Script:           ATS Message Options Lisa Addon
# Author:           Liam
# Version:          1.1.1
# Description:
# This script allows you to designate a number for ATS Message Options
# text box positions setting (like the n in \et[n]) to mark the text box
# for the show text command's position as relative to the event that
# contains the show text command. In other words, it serves as a
# "this event" marker. It also lets you set text box positions
# relative to followers, not just the player. See the FOLLOWER_ACTOR_ID_START_AT
# setting in the Modifiable Constants section for more information.
# In addition, it allows you to automatically set unique talking sounds
# based off of actorID for the player and even their followers if
# they have them. Lastly, it simplifies the other ATS message options
# talking sound script calls so that you can call sound data by name
# from a list of sounds you define.
#
# Feel free to use this script however you like, commercial or not, as long
# as you credit me. Just 'Liam' is fine. Note that, this still requires
# the ATS message options script, so that license it uses will still
# apply to your game as well.
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
# If you don't already have it, you will need the ATS message options script from:
# https://rmrk.net/index.php?topic=46770.0
# You will also need the "Extra Save Data" script.
#
# To use this script, just fill in the settings in the Modifiable Constants
# section. Make sure to read the comments for each setting, as some of the
# settings are somewhat complex.
#
# Important Note: Make sure this is BELOW the ATS Message Options script!!!!
# Otherwise, the script will NOT FUNCTION!
#
#    Script Calls:
# setNewTalkSoundData("talkSoundName")
# Sets the default talk sound to be used for message boxes. This is not just
# for the event's message boxes, but all message boxes.
# Note: It is not used by actors who are talking if actorID based talksounds
# are enabled though.
#
# setNextTalkSoundData("talkSoundName")
# Sets the talk sound for the next dialogue box, overriding the default sound.
# Note: It is also not used by actors who are talking if actorID based talksounds
# are enabled though.
#
# restoreOrigTalkSoundData
# Restores the normal default talk sound in the ATS message options script.
# That default talk sound can be found under the label :letter_se in that script.
#
# $game_player.changeActorTalksoundToggle(trueOrFalse)
# Changes the toggle for whether or not the actorID based talksounds
# will be used when actors talk. You may want to turn it off temporarily
# if an actor should have a different talksound at a specific moment
# for some reason.
#
#
# __Modifiable Constants__
module ATSLADD
  # What number to use in the text box positions setting (like the n in \et[n])
  # to mark it as designating the message box position to be in relation to
  # the event running the show text command.
  #
  # This number should be beyond any resonable number that could normally
  # be an event.
  THIS_EVENT_NUMBER = 999
  
  
  # Use the addition result of (this number + followerActorID) in the text box
  # positions setting (like the n in \et[n]) to mark it as designating the
  # message box position to be placed in relation to a follower with the
  # corresponding actor ID that was added, (if such a follower exists).
  # If the follower can not be found, it will play the message as if there
  # was no designated character. You should be checking if you have a character
  # in your party before displaying the text, that is unchanged.
  #
  # Note: this means that FOLLOWER_ACTOR_ID_START_AT itself is not a valid number,
  # as it would correspond to actor ID 0, which does not exist.
  #
  # It's best to have this at a very round number, like 1000.
  FOLLOWER_ACTOR_ID_START_AT = 1000
  
  # When this setting is "true" actorID based talk sounds will be used,
  # otherwise, whatever the default talksound at the time is will be used
  # when an actor is speaking.
  #
  # Additionally, use "$game_player.changeActorTalksoundToggle(trueOrFalse)" as a
  # map event script line to flip this on and off during gameplay runtime.
  ACTOR_TALK_SOUNDS_ENABLED = true
  
  # This list is used to determine the talksound for actors (including followers)
  # using the actor's actorID. If an actor does not have a sound designated for
  # their actorID, they will use whatever is the default sound at the time.
  #
  # format:
  #   actorID => [SE name, SE volume, SE pitch]
  # Ex.
  # ACTOR_ID_TALK_SOUNDS = {
  #   1 => ["Hammer", 30, 60],
  #   12 => ["Bottle", 90, 100]
  # }
  ACTOR_ID_TALK_SOUNDS = {
  }
  
  # This list stores any other talk sound data tied to a name. These names
  # are used in script calls which set what talk sound data to use. See
  # the script call list for more information.
  #
  # format:
  #   soundDataName => [SE name, SE volume, SE pitch]
  # Ex.
  # OTHER_TALK_SOUNDS = {
  #   "aggressive npc" => ["Blow5", 60, 60],
  #   "strange npc" => ["confuse", 80, 125],
  #   "specific individual" => ["Hit", 60, 100]
  # }
  OTHER_TALK_SOUNDS = {
    "aggressive npc" => ["Blow5", 60, 60],
    "strange npc" => ["confuse", 80, 125],
    "specific individual" => ["Hit", 60, 100]
  }
  
  # __END OF MODIFIABLE CONSTANTS__
end



# BEGINNING OF SCRIPTING ====================================================
class Game_Message
  # Variable that saves the event ID for the event where a
  # message is being executed/shown.
  attr_accessor :eventWhereMessageExecuted
  
  # The last set of talksound data that was used to letter sounds.
  # Used to reset to the appropriate sound after an actor sound is used.
  #attr_accessor :previousTalkSound
  
  #--------------------------------------------------------------------------
  # * Aliased all_text() method used to overwrite the changes from the
  # * aliased all_text() method from ATS Message Options. One line is
  # * modified to use the new atsmo_get_character_game_message() rather
  # * than looking for a directly corresponding game event with the ID,
  # * so that "this event" and follower designations can be used for
  # * ATS messages.
  #--------------------------------------------------------------------------
  alias original_not_atsladd_all_text all_text
  def all_text(*args, &block)
    # get text block before modification
    origResult = @texts.inject("") {|r, text| r += text + "\n" }
    
    # Call original method.
    # This should just be base engine all_text method, or at least be before
    # the original aliased all_text() from ATS Message Options
    result = original_not_atsladd_all_text(*args, &block)
    
    # set result to origResult
    result = origResult
    
    # start of aliased all_text in ATS Message Options --------------
    # Look for the Name Box Code
    if result[/\\NB([LRTB]*)\{(.+?)\}/im]
      atsmo_setup_name_window($2, $1) 
      result.gsub!(/\\NB([LRTB]*)\{(.+?)\}/im, "")
    end
    if result[/([\\\/])FIT/i]
      @fit_window_to_message = $1 == "\\" 
      result.gsub!(/[\\\/]FIT/i, "")
    end
    if result[/\\E([LRTB]?)\[(\d+)\]/i]
      @show_on_character_pos = $1.downcase.to_sym if !$1.empty?
      @show_on_character_id = $2.to_i
      # Don't show on character if the event referenced is nil
      # original line -> @show_on_character_id = -1 if show_on_character_id > 0 && !$game_map.events[show_on_character_id]
      
      # only modified line of method below
      # check if show_on_character_id > 0 and if any valid character retrieved
      @show_on_character_id = -1 if show_on_character_id > 0 && !atsmo_get_character_game_message(show_on_character_id)
      
      result.gsub!(/\\E[LRTB]?\[\d+\]/i, "")
    end
    # return the result implicitly
    result
    # end of aliased all_text in ATS Message Options ---------------------
  end
  
  #--------------------------------------------------------------------------
  # * New method that serves as an exact copy of ATS Message Options'
  # * atsmo_get_character(), but that is accessible in Game_Message.
  # * Also includes the new changes for getting characters from
  # * "this event" and follower designations for showing text.
  #--------------------------------------------------------------------------
  def atsmo_get_character_game_message(id)
    # new stuff ------------------------------------------
    # if the id is the number marked as denoting "This Event" for the
    # piece of text to show, then get the event where the message was
    # executed. If the event is found (not nil), then return the
    # event associated with the "this event" id as the character.
    if (id == ATSLADD::THIS_EVENT_NUMBER)
      # get the eventID where the message is being shown
      messageEventID = $game_message.eventWhereMessageExecuted
      
      # return associated event if the id not nil, and greater than 0
      if (messageEventID != nil)
        if (messageEventID > 0)
          # return "this event" as the character
          return ($game_map.events[messageEventID])
        end
      end
    # if the id is greater than 0, and greater than the follower
    # actor id to start at, then check all followers to find the follower
    # with the matching associated actor ID. If a matching follower is
    # found, return it as the character.
    elsif (id > 0 && (id > ATSLADD::FOLLOWER_ACTOR_ID_START_AT))
      # get the actorID to match up the follower IDs to
      actorID = (id - ATSLADD::FOLLOWER_ACTOR_ID_START_AT)
      
      # check for followers if the actorID > 0
      if (actorID > 0)
        # iterate through the list of followers, check for matching IDs, and if
        # any match, return it as the character
        $game_player.followers.each do |follower|
          followerID = follower.atsladd_GetFollowerActorID
          # if the IDs match return the follower as the character
          if (actorID == followerID)
            return (follower)
          end
        end
      end
      
    end
    # --------------------------------------------------
    
    # old stuff ------------------------------------------
    # implicit return of game_player if id still 0, otherwise a map
    # event will be returned with the id
    id == 0 ? $game_player : $game_map.events[id]
    # --------------------------------------------------
  end
  
end


class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Aliased command_101(), or Show Text method used to save the event ID
  # * of the event that is causing the text to be shown. This is used for
  # * ATS Messages with the "This Event" number used.
  #--------------------------------------------------------------------------
  alias after_atsladd_event_id_storage command_101
  def command_101
    # If the event ID is not nil, and it is greater than 0, then store it
    # as the event where the 
    if (@event_id != nil)
      if (@event_id > 0)
        $game_message.eventWhereMessageExecuted = @event_id
      end
    end
    
    # call original method
    after_atsladd_event_id_storage
  end
  
  # basically a wrapper method for ats_all when dealing with talk sound data
  def setNewTalkSoundData(talkSoundName)
    # call ats_all with the given sound data
    ats_all(:letter_se, ATSLADD::OTHER_TALK_SOUNDS[talkSoundName])
  end
  
  # basically a wrapper method for ats_next when dealing with talk sound data
  def setNextTalkSoundData(talkSoundName)
    ats_next(:letter_se, ATSLADD::OTHER_TALK_SOUNDS[talkSoundName])
  end
  
  # calls ats_all with the default sound data provided by user in the
  # ATS message options script
  def restoreOrigTalkSoundData
    # call ats_all with the default sound data in the ATS message options script
    ats_all(:letter_se, Game_ATS::CONFIG[:ats_message_options][:letter_se])
  end
end


class Window_Message < Window_Base  
  #--------------------------------------------------------------------------
  # * Aliased atsmo_get_character() method from ATS Message Options used to
  # * get the "this event" character for dialogue to be placed in reference
  # * to a character. Also used to get followers from their actor ID to use
  # * as the character.
  #--------------------------------------------------------------------------
  alias after_atsladd_id_checks atsmo_get_character
  def atsmo_get_character(id)
  # get whether or not actor talk sounds are enabled from exSaveData
    actorTalkSoundsEnabled = $game_party.getExSaveData("atsladdTalksoundToggle", ATSLADD::ACTOR_TALK_SOUNDS_ENABLED)
    
    # if the id is 0, the player is being dealt with, so
    # get the player's actorID to potentially change the talksound
    # if actor talk sounds are enabled
    if (id == 0 && actorTalkSoundsEnabled == true)
      playerActorID = $game_player.atsladd_getPlayerActorID
      # if ACTOR_ID_TALK_SOUNDS has a sound designated for the
      # given actorID, then set the talk sound to that sound,
      # otherwise, leave the sound unchanged
      if (ATSLADD::ACTOR_ID_TALK_SOUNDS.has_key?(playerActorID))        
        # change out the letter sound effect data for the message
        $game_message.letter_se = ATSLADD::ACTOR_ID_TALK_SOUNDS[playerActorID]
      end
    end
    
    # if the id is the number marked as denoting "This Event" for the
    # piece of text to show, then get the event where the message was
    # executed. If the event is found (not nil), then return the
    # event associated with the "this event" id as the character.
    if (id == ATSLADD::THIS_EVENT_NUMBER)
      # get the eventID where the message is being shown
      messageEventID = $game_message.eventWhereMessageExecuted
      
      # return associated event if the id not nil, and greater than 0
      if (messageEventID != nil)
        if (messageEventID > 0)
          # return "this event" as the character
          return ($game_map.events[messageEventID])
        end
      end
    # if the id is greater than 0, and greater than the follower
    # actor id to start at, then check all followers to find the follower
    # with the matching associated actor ID. If a matching follower is
    # found, return it as the character.
    elsif (id > 0 && (id > ATSLADD::FOLLOWER_ACTOR_ID_START_AT))
      # get the actorID to match up the follower IDs to
      actorID = (id - ATSLADD::FOLLOWER_ACTOR_ID_START_AT)
      
      # check for followers if the actorID > 0
      if (actorID > 0)
        # iterate through the list of followers, check for matching IDs, and if
        # any match, return it as the character
        $game_player.followers.each do |follower|
          followerID = follower.atsladd_GetFollowerActorID
          # if the IDs match return the follower as the character
          if (actorID == followerID)
            # because the actor was valid, potentially change to the appropriate
            # talk sound based on the actorID if actor talksounds
            # are in use
            if (actorTalkSoundsEnabled == true)
              # if ACTOR_ID_TALK_SOUNDS has a sound designated for the
              # given actorID, then set the talk sound to that sound,
              # otherwise, leave the sound unchanged
              if (ATSLADD::ACTOR_ID_TALK_SOUNDS.has_key?(actorID))
                # change out the letter sound effect data for the message
                $game_message.letter_se = ATSLADD::ACTOR_ID_TALK_SOUNDS[actorID]
              end
            end
            
            # return the follower object explicitly so the original method does not run
            return (follower)
          end
        end
      end
      
    end
    
    # only line of original method -> id == 0 ? $game_player : $game_map.events[id]
    # call original method
    after_atsladd_id_checks(id)
  end
end


class Game_Follower < Game_Character
  #--------------------------------------------------------------------------
  # * New method to return the actor ID of the actor associated with
  # * the Player object. Returns -1 if there is no associated actor.
  #--------------------------------------------------------------------------
  def atsladd_GetFollowerActorID
    # note: 'actor' here is a method that returns the Game_Actor object associated
    # with the follower object using the line below:
    # $game_party.battle_members[@member_index]
    
    # if there is no associated actor, return -1
    if(actor == nil)
      return (-1)
    end
    
    # otherwise, return the associated actor's ID.
    return(actor.id)
  end
end


class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * New method to return the actor ID of the actor associated with
  # * the Player object.
  #--------------------------------------------------------------------------
  def atsladd_getPlayerActorID
    # note: 'actor' here is a method that returns the Game_Actor object associated
    # with the player object using the line below:
    # $game_party.battle_members[0]
    #
    # return the actor's id
    return(actor.id)
  end
  
  #--------------------------------------------------------------------------
  # * Wrapper method to clean up the script call to change the actor talksound toggle
  # * Call this in map events with "$game_player.changeActorTalksoundToggle(trueOrFalse)"
  #--------------------------------------------------------------------------
  def changeActorTalksoundToggle(trueOrFalse)
    $game_party.setExSaveData("atsladdTalksoundToggle", trueOrFalse)
  end
  
end
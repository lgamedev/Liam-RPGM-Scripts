# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-EventForceUnlock"] = true
# END OF IMPORT SECTION

# Script:           Event Force Unlock
# Author:           Liam
# Version:          1.0
# Description:
# This script allows you to force events to not "lock" into place and stop
# animating when interacting with them. This is done using event comment
# notetags, and the force unlock can be done per event page, or for the
# entire event. Force unlocking an event allows you to ensure that continuous
# event animations won't be interrupted.
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
# To use this script, just place it in your script list. After that,
# place the EVFORCEUNLOCK and EVFORCEPAGEUNLOCK notetags as needed
# in event comments.
#
# Notetags:
# Put these notetags in an event "Comment" command. The comment button is the
# bottom command of the "Flow Control" section on page 1 of the event command
# window that pops up when creating a new event command.
#
# <EVFORCEUNLOCK>
#
# This notetag will force an entire event to stay unlocked. This notetag
# MUST be placed on the first event page.
#
# <EVFORCEPAGEUNLOCK>
#
# This notetag will force an event page to make the event stay unlocked
# while that event page runs. These notetags can be placed on multiple
# event pages.
#
#
# No editable constants for this script.



# BEGINNING OF SCRIPTING ====================================================
class Game_Event < Game_Character
  # New variable to mark the event as permenantly being in the event
  # force unlock state
  attr_reader :doPermEvForceUnlock
  
  # New variable to store the indexes of the event pages where event force unlock
  # should be active
  attr_reader :doPageEvForceUnlockPages
  
  # New variable to mark the event as being in the event force unlock state
  # for the currently active event page
  attr_reader :doPageEvForceUnlock
  
  alias after_evforce_check initialize
  def initialize(map_id, event)    
    # start doPageEvForceUnlockPages as an empty array
    # array elements will be page indexes to do event force unlock on while the
    # page is active
    @doPageEvForceUnlockPages = []
    
    # initialize the flag to use event force unlock as false
    forcePermEvUnlock = false
    
    # check the event pages for the evforce notetags
    event.pages.each_with_index do |page, index|
      page.list.each do |command|
        # flag finding a force unlock page notetag was found for the page, starts false
        forcePageUnlockFound = false
        
        # if the event command code is 108 or 408 (both numbers
        # are for event comments), then check the comment for
        # the EVFORCEUNLOCK notetag.
        if ([108, 408].include?(command.code))
          
          # check the command's comment text
          command.parameters.each do |text|
            # if it's the first event page, then check for the EVFORCEUNLOCK notetag
            if (index == 0)
              # if the forceEvUnlock flag is still false, do the checking actions
              if (forcePermEvUnlock == false)
                # check if the EVFORCEUNLOCK notetag is present
                # and set the value to true if it is, otherwise false
                forcePermEvUnlock = evforceunlock_doForceUnlock(text)
              end
            end
            
            # check for the EVFORCEPAGEUNLOCK notetag if one was not already found
            # for the page
            if (forcePageUnlockFound == false)
              # if the EVFORCEPAGEUNLOCK notetag found, then mark the notetag
              # as found for the page and save the page index into
              # the doPageEvForceUnlockPages array
              if (evforceunlock_doForceUnlockPage(text) == true)
                forcePageUnlockFound = true # flip force unlock page found flag
                @doPageEvForceUnlockPages.push(index) # save page index
              end
            end
            
          end
        end
      end      
    end
    
    # set the value of doPermEvForceUnlock to the value of the flag forcePermEvUnlock
    @doPermEvForceUnlock = forcePermEvUnlock
    
    # set the value of doPageEvForceUnlock to false since no event pages
    # have officially started yet
    @doPageEvForceUnlock = false
    
    # Call original method
    after_evforce_check(map_id, event)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to read in the force unlock notetag from event comments.
  # * format: <EVFORCEUNLOCK>
  #--------------------------------------------------------------------------
  def evforceunlock_doForceUnlock(note)
    # check if evforceunlock_doForceUnlock has been checked yet, if not, get it
    if (@evforceunlock_doForceUnlock.nil?)
      # checks for EVFORCEUNLOCK notetag
      if (note =~ /<EVFORCEUNLOCK>/i)
        # set evforceunlock_doForceUnlock to true
        @evforceunlock_doForceUnlock = true
      else
        # false explicit return as default val if no notetag present
        return (false)
      end
    end
    
    # evforceunlock_doForceUnlock implicit return
    @evforceunlock_doForceUnlock
  end
  
  #--------------------------------------------------------------------------
  # * New method used to read in the page force unlock notetag from event comments.
  # * format: <EVFORCEPAGEUNLOCK>
  #--------------------------------------------------------------------------
  def evforceunlock_doForceUnlockPage(note)
    # checks for EVFORCEPAGEUNLOCK notetag, if found, returns true, else, false
    if (note =~ /<EVFORCEPAGEUNLOCK>/i)
      return (true)
    else
      # false explicit return as default val if no notetag present
      return (false)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased lock() method used to prevent locking when the permanent
  # * event force unlock is on, or if the page force unlock is on.
  #--------------------------------------------------------------------------
  alias after_evforce_event_unlock_check lock
  def lock
    # if @doPermEvForceUnlock or @doPageEvForceUnlock is set to true, then do
    # not allow the event to lock, otherwise, do the locking checks as normal
    if (@doPermEvForceUnlock == false && @doPageEvForceUnlock == false)
      # Call original method
      after_evforce_event_unlock_check
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased start() for Game_Event used to update the boolean variable for
  # * marking that the current page should have event force unlock on or
  # * off before the event starts running.
  #--------------------------------------------------------------------------
  alias after_evforce_page_force_unlock_check start
  def start
    # if the event page is empty, return
    return if empty?    
    
    # get index of current page in the page array
    pageIndex = @event.pages.index(@page)
    
    # if the pageIndex for the new page is in the array of
    # event page indexes to activate event force unlocking, then
    # flip doPageEvForceUnlock to true, otherwise, make sure it is false
    if (@doPageEvForceUnlockPages.include?(pageIndex))
      @doPageEvForceUnlock = true
    else
      @doPageEvForceUnlock = false
    end
    
    # Call original method
    after_evforce_page_force_unlock_check
  end
  
end

#IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-NPCTalkOptions"] = true
# END OF IMPORT SECTION

# Script:           Lisa NPC Talk Options
# Author:           Liam
# Version:          1.0.1
# Description:
# This script allows you to let the player talk to NPCs while adjacent to them,
# so that the player's sprite does not have to be move out of the way unless
# necessary. For both NPCs that can talk adjacently or not, if the player is
# directly on top of the NPC they are trying to talk to, then the player can
# be marked to either move to the left or right to get out of the way before
# talking to them, and then will face the NPC afterwards. Moving the player out
# of the way in the desired direction is condensed down to a single script call.
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
# To use this script and have adjacent-talking NPCs, set up NPC talking events
# that have the priority "same as characters" and have the "through" property.
# For any NPC, you can use the script calls as described in the Calling
# subsection further below to simplify the move routes for moving the player
# out of the way when they are directly on top of an NPC event.
#
# Important Note 1: Either "playerTalkCollisionResolve" or "adjNPCCheckIfPlayerYEquiv"
# MUST be called at the beginning of each event page for NPC talking/interaction.
# See the adjNPCCheckIfPlayerYEquiv information in the Calling subsection for
# more information.
#
# Important Note 2: If you happen to have any events that are both
# same as characters priority AND have through on,
# then those events will now be triggered if their trigger is met and the
# player is on top of that event. This would only matter if you wanted that
# event to only be able to be triggered while adjacent to the event, and not
# in it, which I would imagine would be very rare for events with through on.
#
#    Calling:
# playerTalkCollisionResolve("leftOrRight")
# Use the above call in a map event script call to designate the player to move
# left or right out of the way on an NPC if talking from the NPC from
# their event position.
# playerTalkCollisionResolve("leftOrRight", tilesAway)
# Use the above call in a map event script call to also designate the
# number of tiles to move away from the NPC event before turning towards them.
#
# adjNPCCheckIfPlayerYEquiv
# Checks if the player y-level and NPC event y-level are equivalent (meaning
# the player and NPC event are on the same horizontal line). Makes
# the event stop executing if their y-levels are not equivalent. This is used
# to ensure that players will not talk to NPCs from above or below them.
# This method is also present in playerTalkCollisionResolve, so if that
# method was called earlier in the event, this method does not need to be called.
# Directly call this method at the beginning of an event if
# the player should be moved (if needed) after some other things on the event
# page execute. This ensures that those "some other things"
# aren't executed if the y-levels are not equal.
#
#   Parameters:
# "leftOrRight" may be:
# "none"  - if none, it just checks to make sure the player isn't above or
#           below the NPC (left and right do this too).
# "left"  - if left, move the player left, then turn right if the player
#           is on the same space as the NPC event.
# "right" - if right, move the player right, then turn left if the player
#           is on the same space as the NPC event.
# The optional paramater tilesAway should be the number of tiles to move
# away from the NPC event (whether left or right). Defaults to 1 if
# none specified.
#
#
# No editable constants for this script.



# BEGINNING OF SCRIPTING ====================================================
class Game_CharacterBase
  #--------------------------------------------------------------------------
  # * New method used to return the true/false value of @through for the event.
  # * It is necessary to access the value of @through outside of the class.
  #--------------------------------------------------------------------------
  def adjNPCEventIsThrough?
    return @through
  end
end

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Aliased check_event_trigger_here() method used to check for same as
  # * character events only if they have "through" on.
  # *
  # * Note: This method normally checks for events with non-same-as-characters
  # * priority.
  #--------------------------------------------------------------------------
  alias before_check_player_loc_same_as_event_trigger check_event_trigger_here
  def check_event_trigger_here(triggers)
    # only line of original method -> start_map_event(@x, @y, triggers, false)
    # (checks for non same-as-character priority events at the player's position)
    # call original method
    before_check_player_loc_same_as_event_trigger(triggers)
    
    # call a similar method to start_map_event() that starts map events that
    # are at the player's location, and have same-as-characters priority and
    # through on.
    startSameThroughMapEvent(@x, @y, triggers)
  end
  
  #--------------------------------------------------------------------------
  # * New method that is very similar to start_map_event() that starts map
  # * events that are at the player's location, and have same-as-characters
  # * priority and through on.
  #--------------------------------------------------------------------------
  def startSameThroughMapEvent(x, y, triggers)
    # return if the interpreter is already running
    return if $game_map.interpreter.running?
    
    # for each event at the x,y position, check if the event trigger conditions
    # are met, if the event is same as characters (normal) priority, and if the
    # event is "through". If all conditions are met, start the event, otherwise
    # do nothing for the event.
    $game_map.events_xy(x, y).each do |event|
      if (event.trigger_in?(triggers) && event.normal_priority? == true && event.adjNPCEventIsThrough?)
        event.start # start the event
      end
    end
  end
  
end


class Game_Interpreter
  #--------------------------------------------------------------------------
  # * New method used to verify if the player and the event being executed
  # * are in the same y-level. Immediately exits event processing if they are not.
  # * Returns true if the y-levels are equivalent, otherwise, false
  # * Call this in a map event with script call
  # * "adjNPCCheckIfPlayerYEquiv"
  # * Note 1: You should call this event at the start of an event page if
  # * collision resolving should be done after some other things on the event
  # * page. Using this method ensures that the player is on the same y-level as
  # * the NPC they are going to talk to, so that those "some other things"
  # * aren't executed if the y-levels are not equal.
  # * Note 2: This script call should be at the very beginning of event
  # * pages it is used on.
  #--------------------------------------------------------------------------
  def adjNPCCheckIfPlayerYEquiv
    # if the player' y and event's y are not equal, exit the event and return,
    # since the player shouldn't be able to talk to NPCs from above them
    if ($game_player.y != $game_map.events[@event_id].y)
      command_115 # exit event processing command
      return false # return false, 
    else
      return true
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if verify if the player and the event being executed
  # * are in the same y-level. Immediately exits event processing if they are not.
  # * Then, if the player and the NPC event are on the same position, it moves
  # * the player left or right to move away from their event location before
  # * talking to the NPC.
  # * Call this in a map event with script call
  # * "playerTalkCollisionResolve(leftOrRight)"
  # * Note: This script call should be at the very beginning of all event
  # * pages with NPC talking.
  # *
  # * leftOrRight may be:
  # * "none"  - if none, just check to make sure the player isn't above or
  # *           below the NPC (left and right do this too).
  # * "left"  - if left, move the player left, then turn right if the player
  # *           is on the same space as the NPC event.
  # * "right" - if right, move the player right, then turn left if the player
  # *           is on the same space as the NPC event.
  # *
  # * There is also an optional parameter tilesAway, with a default of 1, which
  # * can be used to set a custom amount of distance (in tiles) to walk away
  # * before turning to the NPC to talk to.
  #--------------------------------------------------------------------------
  def playerTalkCollisionResolve(leftOrRight, tilesAway = 1)
    # if the player' y and event's y are not equal, return.
    # The player shouldn't be able to talk to NPCs from above/below them
    if (!adjNPCCheckIfPlayerYEquiv)
      return
    end
    
    # return from this method unless the player's x and event's x are equal,
    # because then the player does not need to get out of their way
    return unless ($game_player.x == $game_map.events[@event_id].x)
    
    # get the left or right parameter in lowercase
    leftOrRightLower = leftOrRight.downcase
    
    # if the player being on top of the NPC should be resolved by moving left,
    # then move the player left, and then turn right.
    if (leftOrRightLower == "left")
      # create new move route and set move route settings
      leftMoveRoute = RPG::MoveRoute.new
      leftMoveRoute.repeat = false
      leftMoveRoute.skippable = false
      leftMoveRoute.wait = true
      
      # create script movement command (will be used with different data repeatedly)
      # NOTE: the entries are executed in reverse order (to how it would normally
      # be set up in an event) due to how insertion works!!!
      movement = RPG::MoveCommand.new
      
      # route end movement command (code 0)
      movement.code = 0
      movement.parameters = []
      leftMoveRoute.list.insert(0, movement.clone)
      
      # create script movement command to turn right
      movement.code = 18
      # add the turn right command
      leftMoveRoute.list.insert(0, movement.clone)
      
      movesAdded = 0 # start the amount of moves added at 0
      # add a move left command for each tile away to move
      while (movesAdded < tilesAway)
        # create script movement command to move left
        movement.code = 2
        # add the move left command
        leftMoveRoute.list.insert(0, movement.clone)
        # increment movesAdded by 1
        movesAdded += 1
      end
      
      # set the player's move route as the leftMoveRoute and execute it
      adjNPCsetPlayerMoveRoute(leftMoveRoute)
    
    # if the player being on top of the NPC should be resolved by moving right,
    # then move the player right, and then turn left.
    elsif (leftOrRightLower == "right")
      # set up and execute player move route to move right, and turn left
      
      # create new move route and set move route settings
      rightMoveRoute = RPG::MoveRoute.new
      rightMoveRoute.repeat = false
      rightMoveRoute.skippable = false
      rightMoveRoute.wait = true
      
      # create script movement command (will be used with different data repeatedly)
      # NOTE: the entries are executed in reverse order (to how it would normally
      # be set up in an event) due to how insertion works!!!
      movement = RPG::MoveCommand.new
      
      # route end movement command (code 0)
      movement.code = 0
      movement.parameters = []
      rightMoveRoute.list.insert(0, movement.clone)
      
      # create script movement command to turn left
      movement.code = 17
      # add the turn left command
      rightMoveRoute.list.insert(0, movement.clone)
      
      movesAdded = 0 # start the amount of moves added at 0
      # add a move left command for each tile away to move
      while (movesAdded < tilesAway)
        # create script movement command to move right
        movement.code = 3
        # add the move right command
        rightMoveRoute.list.insert(0, movement.clone)
        # increment movesAdded by 1
        movesAdded += 1
      end
      
      # set the player's move route as the leftMoveRoute and execute it
      adjNPCsetPlayerMoveRoute(rightMoveRoute)
      
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method that is very similar to command_205(), or set move route,
  # * used to set a move route for the player
  #--------------------------------------------------------------------------
  def adjNPCsetPlayerMoveRoute(moveRoute)
    $game_map.refresh if $game_map.need_refresh # refresh map data if needed
    # get the player (-1) as the character
    character = get_character(-1)
    # if the player object exists, force the move route, and pause execution
    # for the event until the move route is done executing if the
    # move route is set to wait
    if (character)
      character.force_move_route(moveRoute)
      Fiber.yield while character.move_route_forcing if moveRoute.wait
    end
  end
  
end
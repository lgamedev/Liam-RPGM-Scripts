# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-PGAIC"] = true
# END OF IMPORT SECTION

# Script:           Play Group Animations In Center
# Author:           Liam
# Version:          1.0.1
# Description:
# This script allows you to play animations once in the center of the
# screen rather that having it repeat for each target. Before this
# script, you could set animation's position to "Screen" to partially
# solve this problem, however, even if you can't see the animation play multiple
# times since the animations are overlaid on top of each other, the sounds
# used in the animation can still be noticably heard playing over each other.
# This script prevents animation sounds from playing over each other.
#
# This script pairs well with the Yanfly Battle Engine's <one animation>
# notetag, which will activate all the animations at once rather than
# consecutively.
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
# To use this script, apply the <animcenteronly> notetag to a skill (or item)
# where you want the animation to only play once in the center of the screen
# and not have the associated sound play on top of itself.
#
# Note: The way this script is implemented, animations played in
# center cannot cause modifications to the target
# (like causing them to flash a color). They can still do screen effects
# just fine however.
#
#
# No editable constants for this script.



# BEGINNING OF SCRIPTING ====================================================
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Show Animation (Section from the base script)
  #     targets      : Target array
  #     animation_id : Animation ID (-1:  Same as normal attack)
  # *
  # * Aliased show_animation() method used to check if the skill/item
  # * has the <animcenteronly> notetag, and if it does, then it calls a function
  # * to play the designated animation once in the center of the screen and not
  # * on all targets.
  #--------------------------------------------------------------------------
  alias after_pgaic_center_targets_changes show_animation
  def show_animation(targets, animation_id)
    # get current item/skill used by the actor (a baseItem object, thus skill= "item")
    currItem = @subject.current_action.item
    
    # crate a new targets array
    newTargets = Array.new
    
    # if the current "item" has the <animcenteronly> notetag, change the
    # targets list for the animation to just the first enemy
    if (pgaic_SkillOrItemAnimcenterNotetagFound(currItem) == true)
      
      # crate new targets list only containing the first
      newTargets.push($game_troop.alive_members[0])
      
      # if the new targets list is not nil, then throw on a flag
      # to use the enemy as a "fake enemy" in the center
      if (!newTargets[0].nil?)
        $game_troop.alive_members[0].fakeEnemyInCenter = true
      end
    else
      # fill the newTargets list with the data from the old targets list
      targets.each do |target|
        newTargets.push(target)
      end
    end
    
    # call original method with the (potentially) revised targets list
    after_pgaic_center_targets_changes(newTargets, animation_id)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if there is a <animcenteronly>
  # * notetag associated with a skill or item.
  # * Returns true if the notetag is found, otherwise, false.
  #--------------------------------------------------------------------------
  def pgaic_SkillOrItemAnimcenterNotetagFound(skillOrItem)
    # general flag for if the animcenteronly is found starts false
    animcenteronlyNotetagFound = false
    
    # check if the passed parameter is a skill or item, and get the
    # if the notetag is present
    if (skillOrItem.is_a?(RPG::Skill))
      skillUsed = skillOrItem # the skillOrItem is a skill
      skillID = skillUsed.id # get skillID
      skillData = $data_skills[skillID] # get skill data
      # set the general flag to the result of the notetag check
      animcenteronlyNotetagFound = skillData.pgaic_pgaicNotetagPresent?
    end
    if (skillOrItem.is_a?(RPG::Item))
      itemUsed = skillOrItem # the skillOrItem is an item
      itemID = itemUsed.id # get itemID
      itemData = $data_items[itemID] # get item data
      # set the general flag to the result of the notetag check
      animcenteronlyNotetagFound = itemData.pgaic_pgaicNotetagPresent?
    end
    
    # return the result through the general pgaic flag
    return animcenteronlyNotetagFound
  end
end


class Game_Enemy < Game_Battler
  # Variable flag that, when true, marks that an enemy is temporarily designated
  # as a "fake enemy" in the center of the screen.
  attr_accessor :fakeEnemyInCenter
  
  #--------------------------------------------------------------------------
  # * Aliased initialize() method in Game_Enemy used to add a initialize
  # * a variable flag that lets an enemy temporarily be designated
  # * as a fake enemy in the center of the screen.
  #--------------------------------------------------------------------------
  alias pgaic_before_new_feic_init initialize
  def initialize(index, enemy_id)
    pgaic_before_new_feic_init(index, enemy_id) # call original method
    # initialize the new variable fakeEnemyInCenter to false
    @fakeEnemyInCenter = false
  end
end


class Sprite_Base < Sprite
  #--------------------------------------------------------------------------
  # * Aliased set_animation_origin() method used to forcefully change the
  # * animation origin to be in the center of the screen if the Sprite object in
  # * question is a Sprite_Battler object and the attached Game_Battler
  # * object has the "fake enemy" in center of screen tag on.
  #--------------------------------------------------------------------------
  alias pgaic_after_anim_origin_position_change set_animation_origin
  def set_animation_origin
    # save the original animation position in case it is changed
    origPosition = @animation.position
    # boolean flag to check if a fake battler was found
    fakeBattlerInCenterFound = false
    
    # if the Sprite object is a Sprite_Battler object, check if there is
    # an enemy in the first position of the troop
    if (self.kind_of?(Sprite_Battler))
      # if the first member of the troop exists as well has the current sprite's
      # battler, then check if the battler objects refer to the same battler
      if ((!$game_troop.alive_members[0].nil?) && (!self.battler.nil?))
        # if the battler objects refer to the same battler, then
        # check if the battler is a fake battler
        if ($game_troop.alive_members[0] == self.battler)
          # if the battler is a "fake enemy" in the center of the screen,
          # then change the animation position to 3 (which corresponds
          # to an animation set in the center of the screen)
          if ($game_troop.alive_members[0].fakeEnemyInCenter == true)
            # mark that a fake battler was found
            fakeBattlerInCenterFound = true
            @animation.position = 3 # set the position to center (3)
          end
        end
      end
    end
    
    pgaic_after_anim_origin_position_change # Call original method
    
    # if a fake enemy battler was used in the animation, then turn off
    # the flag making it fake and set the animation's position to whatever
    # it originally was
    if (fakeBattlerInCenterFound == true)
      $game_troop.alive_members[0].fakeEnemyInCenter = false
      # set the animation's position back to whatever it originally was
      @animation.position = origPosition
    end
  end
end


class RPG::BaseItem
  #--------------------------------------------------------------------------
  # * New method used to read if there is a animcenteronly notetag.
  # * format: <animcenteronly>
  # * Checks to see if there is a animcenteronly notetag, indicating that
  # * an animation that would normally play on multiple targets should only
  # * play once in the center of the screen. If the notetag is found, the
  # * function returns true. If no GHIT notetag is found, returns false.
  #--------------------------------------------------------------------------
  def pgaic_pgaicNotetagPresent?
    # check if the notetag has been checked yet, if not, do so
    if @pgaicNotetagFound.nil?
      # checks for animcenteronly notetag
      # set the notetag flag to true if found, otherwise false
      if (@note =~ /<animcenteronly>/i)
        @pgaicNotetagFound = true
      else
        # false returned as default val if no notetag present
        @pgaicNotetagFound = false
      end
    end
    # pgaicNotetagFound implicit return
    @pgaicNotetagFound
  end
end
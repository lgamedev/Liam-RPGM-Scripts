# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-BattlerSpriteTransitions"] = true
# END OF IMPORT SECTION

# ------------------- ! REQUIRES 'EXTRA SAVE DATA' SCRIPT ! -------------------
# Script:           Battler Sprite Transitions
# Author:           Liam
# Version:          1.0
# Description:
# This script allows you to use 2 kinds of transitions when changing enemy
# battler sprite images. Notably, you can now change battler sprite images
# without having to use the Transformation command using script calls.
# The first type of transition is a fade transition where the old battler
# sprite image fades out and the new one fades in. The second transition is
# a battle animation transition where the old battler image is hidden (or not)
# while a specified battle animation plays and then the new battler image
# appears at the end of the animation. Both transitions can be used
# with the Transformation command and the new alternative to the Transformation
# command. It is also possible to use no transition.
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
# use the provided script calls as needed.
#
#   Calling:
# Note: Doing animations without hiding the battler is probably what
# most will want to use, unless their battlers can be properly replicated
# by the dimensions available in animation frames along with zooming in frames.
#
# enemy_sprite_change(enemyPosition, newSpriteFilename, newHue-optional)
# enemy_sprite_change_fade(enemyPosition, newSpriteFilename, newHue-optional)
# enemy_sprite_change_animation(enemyPosition, newSpriteFilename, transitionAnimationID, newHue-optional)
# enemy_sprite_change_animation_no_hide(enemyPosition, newSpriteFilename, transitionAnimationID, newHue-optional)
#
# The above script calls change an enemy's battler sprite to a new specified
# image. This can be done with a fade transition (second script call) where
# the old sprite image fades out and the new one fades in. It can also be
# done with a transition where the battler sprite is made transparent, a
# specified battle animation plays, and the new sprite image appears when the
# animation is finished (third script call). The fourth script call allows you
# to not hide the old battler sprite while the battle animation plays.
# Alternatively, no transition can be used and image can just immediately flip
# to the new battler image (first script call). Optionally, a hue parameter
# can be used to specify a new hue for the battler.
#
# transform_with_fade(enemyPosition, newEnemyID)
# transform_with_anim(enemyPosition, newEnemyID, transitionAnimationID)
# transform_with_anim_no_hide(enemyPosition, newEnemyID, transitionAnimationID)
#
# The above script calls allows the new battler sprite transitions
# to be used when using the transform command on an enemy. The fade
# and battle animation transitions can both be used.
#
# Note: There are other script calls for modifying the values
# of script settings during gameplay runtime. Please refer to
# the comments of those settings to see those script calls.
#
#   Parameters:
# enemyPosition is the position number of the enemy you want to change the
#   battler sprite of in the troop (1-8 by default).
# newSpriteFilename is the filename (in quotes) of the battler's new
#   sprite graphic. If this filename is set to the special exception
#   name of "current_battler_name_here", then the current battler
#   sprite graphic will not be changed.
# transitionAnimationID is the number of the battle animation in
#   the animations section of the database that will be used as the
#   the battler sprite transition animation.
# newHue is an optional parameter (you do not have to put a value for this
#   parameter) to change the hue of the battler's sprite graphic and is
#   a number that can range from 0 to 255.
# newEnemyID is the number of the enemy in the enemies section of the database
#   that the battler will transform into
#
#   Examples:
# Note: Not every single one of the script calls from the Calling
# section is listed here, but these examples should show you everything
# you need to know to use all of the script calls.
# PICTURES PRESENT IN THE GAME DATABASE: CoolBattler1.png
#
# enemy_sprite_change_fade(2, "CoolBattler1")
# The above script line changes the enemy in position 2 of the troop to
# have their new battler graphic be CoolBattler1.png after a fade transition.
#
# enemy_sprite_change(2, "current_battler_name_here", 200)
# The above script line changes the enemy in position 2 of the troop to
# have their hueshift value change to 200, while their battler sprite graphic
# remains unaffected.
#
# enemy_sprite_change_animaton_no_hide(2, "CoolBattler1", 18)
# The above script line changes the enemy in position 2 of the troop to
# display battle animation 18 on top of the old battler sprite and
# changes the battler image to the new CoolBattler1.png image after the
# animation is done displaying.
#
# transform_with_fade(2, 23)
# The above script line changes the enemy in position 2 of the troop to
# change to the enemy with the enemyID of 23, and it does a fade transition
# when changing the new battler sprite image.
#
# transform_with_anim(2, 23, 18)
# The above script line changes the enemy in position 2 of the troop to
# change to the enemy with the enemyID of 23, and it does a battle animation
# transition using battle animation 18 during which the battler is hidden
# when changing to the new battler sprite image.
#
#
# __Modifiable Constants__
module BST
  # The length (in frames) of the amount of time a battler sprite should take to
  # fade out while undergoing a battler sprite change fade transition.
  # To change this value during gameplay, use the following script call:
  #   set_battler_sprite_fadeout_timing(newFadeoutTiming)
  FADE_OUT_LENGTH = 60
  
  # The length (in frames) of the amount of time a battler sprite should take to
  # stay faded out while undergoing a battler sprite change fade transition.
  # To change this value during gameplay, use the following script call:
  #   set_battler_sprite_fadewait_timing(newFadewaitTiming)
  FADE_WAIT_LENGTH = 120
  
  # The length (in frames) of the amount of time a battler sprite should take to
  # fade in while undergoing a battler sprite change fade transition.
  # To change this value during gameplay, use the following script call:
  #   set_battler_sprite_fadein_timing(newFadeinTiming)
  FADE_IN_LENGTH = 60
  
  # To set all fade times (out/wait/in) at once, use the script call:
  #   set_battler_sprite_all_fade_timing(newFadeoutTiming, newFadewaitTiming, newFadeinTiming)
  
  # To restore all fade times to the original values, use the script call:
  #   restore_default_battler_sprite_fade_timings
  
  # The data for the sound effect to play when an enemy does a fadeout during
  # battler sprite transition.
  # 
  # Note: Leave the name as just empty quotes ("") if you don't want any sound
  # when a battler sprite does a fadeout during transition.
  # 
  # format:
  #   ["SE name", SE volume, SE pitch]
  # Ex.
  #   FADE_OUT_SE = ["ding", 80, 100]
  #
  # To change the setting during gameplay, use the following script call:
  #   set_battler_sprite_fadeout_se(newFadeoutSEFilename, newFadeoutSEVol, newFadeoutSEPitch)
  FADE_OUT_SE = ["", 80, 100]
  
  # The data for the sound effect to play when an enemy has just finished
  # fading out during a battler sprite fade transition.
  # 
  # Note: Leave the name as just empty quotes ("") if you don't want any sound
  # when a battler sprite finishes fading out during transition.
  # 
  # format:
  #   ["SE name", SE volume, SE pitch]
  # Ex.
  #   FADE_WAIT_SE = ["ding", 80, 100]
  #
  # To change the setting during gameplay, use the following script call:
  #   set_battler_sprite_fadewait_se(newFadewaitSEFilename, newFadewaitSEVol, newFadewaitSEPitch)
  FADE_WAIT_SE = ["", 80, 100]
  
  # The data for the sound effect to play when an enemy does a fadein during
  # battler sprite transition.
  # 
  # Note: Leave the name as just empty quotes ("") if you don't want any sound
  # when a battler sprite does a fadein during transition.
  # 
  # format:
  #   ["SE name", SE volume, SE pitch]
  # Ex.
  #   FADE_IN_SE = ["ding", 80, 100]
  #
  # To change the setting during gameplay, use the following script call:
  #   set_battler_sprite_all_fade_se(newFadeoutSEData, newFadewaitSEData, newFadeinSEData)
  FADE_IN_SE = ["", 80, 100]
  
  # To set all fade sound effects (out/wait/in) at once, use the script call:
  #   set_battler_sprite_all_fade_se(newFadeoutSEData, newFadewaitSEData, newFadeinSEData)
  # where newFadeoutSEData is -> ["fadeoutSE name", fadeoutSE volume, fadeoutSE pitch]
  # and newFadewaitSEData is  -> ["fadewaitSE name", fadewaitSE volume, fadewaitSE pitch]
  # and newFadeinSEData is    -> ["fadeinSE name", fadeinSE volume, fadeinSE pitch]
  
  # To restore all fade sound effects to the original values, use the script call:
  #   restore_default_battler_sprite_fade_timings
  
  # This setting, when set to true, makes all transformations use
  # fade battler sprite transitions.
  FADE_FOR_ALL_TRANSFORM = false
  
  # __END OF MODIFIABLE CONSTANTS__
end



# BEGINNING OF SCRIPTING ====================================================
class Sprite_Battler < Sprite_Base
  # New variable used to track when the fadeout battler sprite transition
  # effect is active
  attr_accessor :doBattleTranFadeOut
  # New variable used to track when the fadewait battler sprite transition
  # effect is active
  attr_accessor :doBattleTranFadeWait
  # New variable used to track when the fadein battler sprite transition
  # effect is active
  attr_accessor :doBattleTranFadeIn
  
  # New variable used to track when the fadeout battler sprite transition
  # battle animation has started and is still running
  attr_accessor :battlerSpriteTransitionAnimationStarted
  # New variable used as a flag to mark that the battler should not be hidden
  # during the battler sprite transition battle animation
  attr_accessor :battlerSpriteTransitionAnimationNoHideBattler
  
  #--------------------------------------------------------------------------
  # * Aliased initialize() method for Sprite_Battler used to
  # * set up initial values for the battle animation and fade battler
  # * sprite transitions.
  #--------------------------------------------------------------------------
  alias before_bst_new_var_init initialize
  def initialize(viewport, battler = nil)
    # Call original method
    before_bst_new_var_init(viewport, battler)
    
    @doBattleTranFadeOut = false
    @doBattleTranFadeWait = false
    @doBattleTranFadeIn = false
    
    @battlerSpriteTransitionAnimationStarted = false
    @battlerSpriteTransitionAnimationNoHideBattler = false
  end
  
  #--------------------------------------------------------------------------
  # * Aliased setup_new_animation() method for Sprite_Battler used to
  # * set up proper variable values for the battler sprite transition
  # * animation if one is set to begin.
  #--------------------------------------------------------------------------
  alias bst_after_new_trans_anim_prepare setup_new_animation
  def setup_new_animation
    # only do special battler sprite transition animation setup if
    # the battler is set to use one
    if (@battler.doBattleAnimTransForNextBattleSpriteChange == true)
      # set the battle sprite transition animation no hide flag as neeeded
      @battlerSpriteTransitionAnimationNoHideBattler = @battler.doBattleAnimTransNoHideForNextBattleSpriteChange
      # set the enemy's actual animation_id to the battlerSpriteTransitionAnimID
      @battler.animation_id = @battler.doBattleAnimTransNewAnimID
      
      # flip the enemy's doBattleAnimTransForNextBattleSpriteChange back to false
      # since the animation has now started
      @battler.doBattleAnimTransForNextBattleSpriteChange = false
      # set the enemy's doBattleAnimTransNewAnimID back to 0 since it is in use
      @battler.doBattleAnimTransNewAnimID = 0
      # set the enemy's doBattleAnimTransNewAnimID back to false also
      @battler.doBattleAnimTransNoHideForNextBattleSpriteChange = false
      
      # mark that a transition animation is in progress
      @battlerSpriteTransitionAnimationStarted = true
    end
    
    # Call original method (setup the new animation)
    bst_after_new_trans_anim_prepare
  end
  
  #--------------------------------------------------------------------------
  # * Aliased update_bitmap() method for Sprite_Battler used to only
  # * update the battler sprite's bitmap when the timing is appropriate
  # * based on the state of any battle sprite transitions (fade transition
  # * and battle animation transition).
  #--------------------------------------------------------------------------
  alias bst_sprite_bitmap_change_orig_method update_bitmap
  def update_bitmap
    # get the new bitmap
    bstNewBitmap = Cache.battler(@battler.battler_name, @battler.battler_hue)
    # if the current bitmap is different to the new bitmap, check if a fade
    # transition should be done
    if (bitmap != bstNewBitmap)
      # only do further checks if the battler is still alive and visible
      if (@battler.alive? && @battler_visible)
        # if a fade is supposed to be done for the batter, then do it
        if (@battler.doFadeForNextBattleSpriteChange == true)
          puts("BATTLER TRANSITION FADEOUT STARTED!!!!")
          @doBattleTranFadeOut = true # mark that fade out should be done
          
          # get fade out sound effect data
          fadeoutSEData = $game_party.getExSaveData("battlerSpriteFadeoutSE", BST::FADE_OUT_SE)
          seFilename = fadeoutSEData[0]
          seVol = fadeoutSEData[1]
          sePitch = fadeoutSEData[2]
          # play fade out sound effect
          RPG::SE.new(seFilename, seVol, sePitch).play
          
          # start fade out
          start_battle_sprite_transition_fade_effect(:battletranfadeout)
        end
        
        # regardless of whether the fadeout actually activated or not, mark
        # the battler has having done the fade since it was attempted
        @battler.doFadeForNextBattleSpriteChange = false
      end
      
      # standard battler sprite transition checks to see if the battler sprite
      # can change while the battle animation transition runs
      battlerSpriteTransitionChecks = (!@battler.doBattleAnimTransForNextBattleSpriteChange || (@battlerSpriteTransitionAnimationStarted == true && self.opacity = 0))
      # also don't change battler sprite until the animation is over if
      # the battler is not supposed to be hidden
      battlerSpriteTransitionChecks = battlerSpriteTransitionChecks && (@battlerSpriteTransitionAnimationNoHideBattler == false)
      
      # Call original method (actually sets up the new bitmap) if
      # the fadeOut isn't active and a battle sprite transition animation
      # isn't being prepared
      if ((@doBattleTranFadeOut == false || !@battler.alive?) && (battlerSpriteTransitionChecks == true))
        bst_sprite_bitmap_change_orig_method
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased init_visibility() method for Sprite_Battler used to ensure
  # * that visibility is not disturbed while any fade transitions are
  # * being done.
  #--------------------------------------------------------------------------
  alias bst_init_visibility_orig_method init_visibility
  def init_visibility
    # Call original method if not doing any fade transitions
    if (@doBattleTranFadeOut == false && @doBattleTranFadeWait == false && @doBattleTranFadeIn == false)
      bst_init_visibility_orig_method
    end
    
    # if doing fadeWait then make sure opacity is 0
    if (@doBattleTranFadeWait == true)
      self.opacity = 0
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to start the new fade battle sprite transition effects.
  # * A near-copy of the start_effect() method that is used to only
  # * do the revert_to_normal() method in specific circumstances.
  #--------------------------------------------------------------------------
  def start_battle_sprite_transition_fade_effect(effect_type)
    # set effect type to the newly-specified effect type
    @effect_type = effect_type
    
    # set effect duration according to current fade effect
    case @effect_type
    when :battletranfadeout
      # get proper fade out length from extra save data
      fadeoutTime = $game_party.getExSaveData("battlerSpriteFadeoutTime", BST::FADE_OUT_LENGTH)
      
      @effect_duration = fadeoutTime
    when :battletranfadewait
      # get proper fade wait length from extra save data
      fadewaitTime = $game_party.getExSaveData("battlerSpriteFadewaitTime", BST::FADE_WAIT_LENGTH)
      
      @effect_duration = fadewaitTime
    when :battletranfadein
      # get proper fade in length from extra save data
      fadeinTime = $game_party.getExSaveData("battlerSpriteFadeinTime", BST::FADE_IN_LENGTH)
      
      @effect_duration = fadeinTime
    end
    
    # if not doing the fade wait or fade in, then revert to normal sprite variable values
    if (@effect_type != :battletranfadewait && @effect_type != :battletranfadein)
      revert_to_normal
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased update_effect() used to update the fade effects for the battle
  # * sprite fade transition based on which fade effect is active.
  #--------------------------------------------------------------------------
  alias bst_after_sprite_fade_transition_checks update_effect
  def update_effect
    # boolean flags for if the fadewait or fadein effects need to be run
    runFadeWait = false
    runFadeIn = false
    # save original @effect_duration
    origEffectDuration = @effect_duration
    
    # update the new battler sprite fade effects if effect duration minus 1
    # is above zero
    # (minus 1 because normally effect duration is subtracted in the original
    # method and cannot be done here)
    if (@effect_duration > 0)
      @effect_duration -= 1 # decrement effect_duration by 1
      
      # use different update method depending on fade effect
      case @effect_type
      when :battletranfadeout
        puts("doing fadeout update, effect_duration IS NOW " + @effect_duration.to_s)
        update_fade_out_battle_sprite_transition
      # (no update needed for :battletranfadewait)
      when :battletranfadein
        update_fade_in_battle_sprite_transition
      end
      
      if (@effect_type == :battletranfadewait)
        puts("battletranfadewait @effect_duration issssssssss-> " + @effect_duration.to_s)
      end
      
      # FADE CHANGE CHECKS
      # only do any fade change checks if one of the doFade vars is true
      # and the effect duration is 0
      if (@effect_duration == 0 && (@doBattleTranFadeOut == true || @doBattleTranFadeWait == true || @doBattleTranFadeIn == true))
        # modify the doFades depending on effect type
        case @effect_type
        when :battletranfadeout
          puts("BATTLER TRANSITION FADEWAIT STARTED!!!!")
          runFadeWait = true # mark that fadeWait should run
          
          # fadeOut now false, fadeWait now true
          @doBattleTranFadeOut = false
          @doBattleTranFadeWait = true
          
          # get fade wait sound effect data
          fadewaitSEData = $game_party.getExSaveData("battlerSpriteFadewaitSE", BST::FADE_WAIT_SE)
          seFilename = fadewaitSEData[0]
          seVol = fadewaitSEData[1]
          sePitch = fadewaitSEData[2]
          # play fade wait sound effect
          RPG::SE.new(seFilename, seVol, sePitch).play
          
        when :battletranfadewait
          puts("BATTLER TRANSITION FADEIN STARTED!!!!")
          runFadeIn = true # mark that fadein should run
          # fadeOut now false, fadeWait now true
          @doBattleTranFadeWait = false
          @doBattleTranFadeIn = true
          
          # get fade in sound effect data
          fadeinSEData = $game_party.getExSaveData("battlerSpriteFadeinSE", BST::FADE_IN_SE)
          seFilename = fadeinSEData[0]
          seVol = fadeinSEData[1]
          sePitch = fadeinSEData[2]
          # play fade in sound effect
          RPG::SE.new(seFilename, seVol, sePitch).play
          
        when :battletranfadein
          puts("BATTLER TRANSITION FADEIN ENDED!!!!")
          # fadeIn now false
          @doBattleTranFadeIn = false
        end
      end
      
      # reset effect type to nil if effect duration is zero
      @effect_type = nil if (@effect_duration == 0)
    end
    
    # reset effect duration to the original value since the original method will run
    @effect_duration = origEffectDuration
    
    # Call original method
    bst_after_sprite_fade_transition_checks
    
    # run fadeWait or fadeIn if needed
    if (runFadeWait == true)
      # start fade wait
      start_battle_sprite_transition_fade_effect(:battletranfadewait)
    elsif (runFadeIn == true)
      # start fade in
      start_battle_sprite_transition_fade_effect(:battletranfadein)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update the fadeout effect for the battle sprite
  # * fade transition.
  #--------------------------------------------------------------------------
  def update_fade_out_battle_sprite_transition
    # get proper fade out length from extra save data
    fadeoutTime = $game_party.getExSaveData("battlerSpriteFadeoutTime", BST::FADE_OUT_LENGTH)
      
    # fadeTimeRatio = (1 / fadeoutTime)
    # get the amount to fade per one frame -> (maxOpacity * (fadeTimeRatio))
    amountToFade = 255.0 * (1.0 / fadeoutTime)
    
    # set new opacity
    self.opacity = 255 - ((fadeoutTime - @effect_duration) * amountToFade).to_i
  end 
  
  #--------------------------------------------------------------------------
  # * New method used to update the fadein effect for the battle sprite
  # * fade transition.
  #--------------------------------------------------------------------------
  def update_fade_in_battle_sprite_transition
    # get proper fade in length from extra save data
    fadeinTime = $game_party.getExSaveData("battlerSpriteFadeinTime", BST::FADE_IN_LENGTH)
    
    # fadeTimeRatio = (1 / fadeinTime)
    # get the amount to fade per one frame-> (maxOpacity * (fadeTimeRatio))
    amountToFade = 255.0 * (1.0 / fadeinTime)
    
    # set new opacity
    self.opacity = ((fadeinTime - @effect_duration) * amountToFade).to_i
  end
  
end


class Sprite_Base < Sprite
  #--------------------------------------------------------------------------
  # * Aliased start_animation() used to update battler sprite opacity when the
  # * battler sprite transition animation has been started.
  #--------------------------------------------------------------------------
  alias bst_after_anim_setup start_animation
  def start_animation(animation, mirror = false)
    # Call original method (start the animation)
    bst_after_anim_setup(animation, mirror)
    
    # only do animation transition action if a battler sprite and a
    # transition animation is being run and the battler should be hidden
    if (self.kind_of?(Sprite_Battler))
      if (self.battlerSpriteTransitionAnimationStarted == true && self.battlerSpriteTransitionAnimationNoHideBattler == false)
        # set sprite opacity to 0
        self.opacity = 0
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased end_animation() used to update battler sprite opacity when the
  # * battler sprite transition animation has been ended and reset battle
  # * animation transition variables.
  #--------------------------------------------------------------------------
  alias bst_before_anim_end end_animation
  def end_animation
    # only do animation transition actions if a battler sprite and a
    # transition animation is being set up
    if (self.kind_of?(Sprite_Battler))
      if (self.battlerSpriteTransitionAnimationStarted == true)
        # mark that a transition animation is no longer in progress
        self.battlerSpriteTransitionAnimationStarted = false
        
        # reset sprite opacity back to max if battler was not hidden
        if (self.battlerSpriteTransitionAnimationNoHideBattler == false)
          # set sprite opacity to 255 (max opacity)
          self.opacity = 255
        end
        
        # reset the transition animation no hide flag back to false if needed
        self.battlerSpriteTransitionAnimationNoHideBattler = false
      end
    end
    
    # Call original method (end the animation)
    bst_before_anim_end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased animation_set_sprite() used to not take battler sprite opacity
  # * into account if doing a battler sprite transition with animation.
  #--------------------------------------------------------------------------
  alias bst_before_anim_set_sprite_transition_opacity animation_set_sprites
  def animation_set_sprites(frame)
    # Call original method
    bst_before_anim_set_sprite_transition_opacity(frame)
    
    # get cell data
    cell_data = frame.cell_data
    
    # set each animation sprite opacity without taking battler sprite
    # opacity into account
    @ani_sprites.each_with_index do |sprite, i|
      # skip certain sprites if not valid
      next unless sprite
      pattern = cell_data[i, 0]
      if !pattern || pattern < 0
        sprite.visible = false
        next
      end
      
      # update opacity without using battler sprite opacity
      sprite.opacity = cell_data[i, 6]
    end
  end
  
end


class Game_Battler < Game_BattlerBase
  # New variable used to store whether or not a fade transition should be
  # used when the battler next does a sprite change
  attr_accessor :doFadeForNextBattleSpriteChange
  
  # New variable used to store whether or not a battle animation transition
  # should be used when the battler next does a sprite change
  attr_accessor :doBattleAnimTransForNextBattleSpriteChange
  # New variable used to store whether or not the next battle animation transition
  # should not hide the battler while the battle sprite transition is executed
  attr_accessor :doBattleAnimTransNoHideForNextBattleSpriteChange
  # New variable used to store the battle animation ID of the battle animation
  # to use for the next battle animation transition
  attr_accessor :doBattleAnimTransNewAnimID
  
  #--------------------------------------------------------------------------
  # * Aliased initialize() method for Game_Battler used to set up initial values
  # * for all of the new variables.
  #--------------------------------------------------------------------------
  alias bst_after_new_fade_var_init initialize
  def initialize
    # start with doFadeForNextBattleSpriteChange false
    @doFadeForNextBattleSpriteChange = false
    # start with doBattleAnimTransForNextBattleSpriteChange false
    @doBattleAnimTransForNextBattleSpriteChange = false
    # start with doBattleAnimTransNoHideForNextBattleSpriteChange false
    @doBattleAnimTransNoHideForNextBattleSpriteChange = false
    # start with doBattleAnimTransNewAnimID as 0
    @doBattleAnimTransNewAnimID = 0
    
    # Call original method
    bst_after_new_fade_var_init
  end
  
  #--------------------------------------------------------------------------
  # * New method used to change an enemy's battler sprite graphic to a
  # * a new specified filename.
  #--------------------------------------------------------------------------
  def bst_update_battler_sprite_filename(newSpriteFilename, newHue=2000)
    # if battler name is not "current_battler_name_here", then change the battler's
    # sprite filename
    if (newSpriteFilename != "current_battler_name_here")
      @battler_name = newSpriteFilename
    end
    
    # if a proper hue value is set, change battler hue to the new one
    if (newHue != 2000 && newHue <= 255  && newHue >= 0)
      @battler_hue = newHue
    end
  end
end


class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # * Aliased transform() used to set up fades for all transformations if
  # * fades are enabled for all enemy transformations.
  #--------------------------------------------------------------------------
  alias bst_after_transform_fade_set transform
  def transform(enemy_id)
    puts("@doFadeForNextBattleSpriteChange currently active????????????? " + @doFadeForNextBattleSpriteChange.to_s)
    
    # if fade is always set to occur for battle transformations,
    # then set fade to occur on battler sprite change
    if (BST::FADE_FOR_ALL_TRANSFORM == true)
      @doFadeForNextBattleSpriteChange = true
    end
    
    # Call original method
    bst_after_transform_fade_set(enemy_id)
  end
end


class Game_Interpreter
  #--------------------------------------------------------------------------
  # * New method used as a script call to change an enemy's battler sprite
  # * graphic to a newly specified filename. Accepts a new hue as an optional
  # * parameter.
  # * Call with: enemy_sprite_change(enemyPosition, newSpriteFilename, newHue-optional)
  #--------------------------------------------------------------------------
  def enemy_sprite_change(enemyPos, newSpriteFilename, newHue=2000)
    puts("enemy_sprite_change() is running!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    # get enemy (-1 to account for indexing at 0)
    enemy = $game_troop.members[enemyPos - 1]
    
    # ony do any changes if there is an enemy
    if (enemy)
      # set up the enemy with the new battler sprite graphic
      enemy.bst_update_battler_sprite_filename(newSpriteFilename, newHue)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to change an enemy's battler sprite
  # * graphic to a newly specified filename with a fadeout of the old battler
  # * sprite and a fadein of the new one. Accepts a new hue as an optional
  # * parameter.
  # * Call with: enemy_sprite_change_fade(enemyPosition, newSpriteFilename, newHue-optional)
  #--------------------------------------------------------------------------
  def enemy_sprite_change_fade(enemyPos, newSpriteFilename, newHue=2000)
    # get enemy (-1 to account for indexing at 0)
    enemy = $game_troop.members[enemyPos - 1]
    
    # ony do any changes if there is an enemy
    if (enemy)
      # set fade up
      enemy.doFadeForNextBattleSpriteChange = true
      
      # set up the enemy with the new battler sprite graphic
      enemy.bst_update_battler_sprite_filename(newSpriteFilename, newHue)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to change an enemy's battler sprite
  # * graphic to a newly specified filename. Does an animation while hiding
  # * the battler's graphic before displaying the new battler graphic.
  # * Accepts a new hue as an optional parameter.
  # * Call with: enemy_sprite_change_animation(enemyPosition, newSpriteFilename, transitionAnimationID, newHue-optional)
  #--------------------------------------------------------------------------
  def enemy_sprite_change_animation(enemyPos, newSpriteFilename, transAnimID, newHue=2000)
    # get enemy (-1 to account for indexing at 0)
    enemy = $game_troop.members[enemyPos - 1]
    
    # ony do any changes if there is an enemy
    if (enemy)
      # set battler transition up
      enemy.doBattleAnimTransForNextBattleSpriteChange = true
      # set up the enemy with the new battle sprite transition animation ID
      enemy.doBattleAnimTransNewAnimID = transAnimID
      
      # set up the enemy with the new battler sprite graphic
      enemy.bst_update_battler_sprite_filename(newSpriteFilename, newHue)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to change an enemy's battler sprite
  # * graphic to a newly specified filename. Does an animation and displays
  # * the new battler graphic at the end. Accepts a new hue as an optional parameter.
  # * Call with: enemy_sprite_change_animation_no_hide(enemyPosition, newSpriteFilename, transitionAnimationID, newHue-optional)
  #--------------------------------------------------------------------------
  def enemy_sprite_change_animation_no_hide(enemyPos, newSpriteFilename, transAnimID, newHue=2000)
    # get enemy (-1 to account for indexing at 0)
    enemy = $game_troop.members[enemyPos - 1]
    
    # only do any changes if there is an enemy
    if (enemy)
      # set battler transition animation up
      enemy.doBattleAnimTransForNextBattleSpriteChange = true
      # set battler transition animation no hide flag up
      enemy.doBattleAnimTransNoHideForNextBattleSpriteChange = true
      # set up the enemy with the new battler sprite transition animation ID
      enemy.doBattleAnimTransNewAnimID = transAnimID
      
      # set up the enemy with the new battler sprite graphic
      enemy.bst_update_battler_sprite_filename(newSpriteFilename, newHue)
    end
  end

  #--------------------------------------------------------------------------
  # * New method used as a script call to do the enemy transformation command
  # * but with a fadeout of the old battler sprite and a fadein of the new one.
  # * Call with: transform_with_fade(enemyPosition, newEnemyID)
  #--------------------------------------------------------------------------
  def transform_with_fade(enemyPos, newEnemyID)
    # get enemy (-1 to account for indexing at 0)
    enemy = $game_troop.members[enemyPos - 1]
    
    # ony do any changes if there is an enemy
    if (enemy)
      # set battler sprite transition fade up
      enemy.doFadeForNextBattleSpriteChange = true
      
      # transform the enemy using the new enemyID
      enemy.transform(newEnemyID)
      
      # reset enemy names
      $game_troop.make_unique_names
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to do the enemy transformation command
  # * but with a battle animation used as a transition animation.
  # * Call with: transform_with_anim(enemyPosition, newEnemyID, transitionAnimationID)
  #--------------------------------------------------------------------------
  def transform_with_anim(enemyPos, newEnemyID, transAnimID)
    # get enemy (-1 to account for indexing at 0)
    enemy = $game_troop.members[enemyPos - 1]
    
    # ony do any changes if there is an enemy
    if (enemy)
      # set battler transition animation up
      enemy.doBattleAnimTransForNextBattleSpriteChange = true
      # set up the enemy with the new battler sprite transition animation ID
      enemy.doBattleAnimTransNewAnimID = transAnimID
      
      # transform the enemy using the new enemyID
      enemy.transform(newEnemyID)
      
      # reset enemy names
      $game_troop.make_unique_names
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to do the enemy transformation command
  # * but with a battle animation used as a transition animation. This version
  # * does not hide the battler's sprite during the time the battle animation plays.
  # * Call with: transform_with_anim_no_hide(enemyPosition, newEnemyID, transitionAnimationID)
  #--------------------------------------------------------------------------
  def transform_with_anim_no_hide(enemyPos, newEnemyID, transAnimID)
    # get enemy (-1 to account for indexing at 0)
    enemy = $game_troop.members[enemyPos - 1]
    
    # ony do any changes if there is an enemy
    if (enemy)
      # set battler transition animation up
      enemy.doBattleAnimTransForNextBattleSpriteChange = true
      # set battler transition animation no hide flag up
      enemy.doBattleAnimTransNoHideForNextBattleSpriteChange = true
      # set up the enemy with the new battler sprite transition animation ID
      enemy.doBattleAnimTransNewAnimID = transAnimID
      
      # transform the enemy using the new enemyID
      enemy.transform(newEnemyID)
      
      # reset enemy names
      $game_troop.make_unique_names
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to set a new amount of time (in frames)
  # * that fadeouts should take for battler sprite transition fadeouts.
  # * Call with: set_battler_sprite_fadeout_timing(newFadeoutTiming)
  #--------------------------------------------------------------------------
  def set_battler_sprite_fadeout_timing(newFadeoutTiming)
    # save the new fadeout time into extra save data
    fadeoutTime = $game_party.setExSaveData("battlerSpriteFadeoutTime", newFadeoutTiming)
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to set a new amount of time (in frames)
  # * that fadewaits should take for battler sprite transition fades.
  # * Call with: set_battler_sprite_fadewait_timing(newFadewaitTiming)
  #--------------------------------------------------------------------------
  def set_battler_sprite_fadewait_timing(newFadewaitTiming)
    # save the new fadewait time into extra save data
    fadewaitTime = $game_party.getExSaveData("battlerSpriteFadewaitTime", newFadewaitTiming)
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to set a new amount of time (in frames)
  # * that fadeins should take for battler sprite transition fadeins.
  # * Call with: set_battler_sprite_fadein_timing(newFadeinTiming)
  #--------------------------------------------------------------------------
  def set_battler_sprite_fadein_timing(newFadeinTiming)
    # save the new fadein time into extra save data
    fadeinTime = $game_party.getExSaveData("battlerSpriteFadeinTime", newFadeinTiming)
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to set a new amount of time (in frames)
  # * that fadeouts/fadewaits/fadeins should take for battler sprite transition
  # * fadeouts/fadewaits/fadeins all at once.
  # * Call with: set_battler_sprite_all_fade_timing(newFadeoutTiming, newFadewaitTiming, newFadeinTiming)
  #--------------------------------------------------------------------------
  def set_battler_sprite_all_fade_timing(newFadeoutTiming, newFadewaitTiming, newFadeinTiming)
    # save the new fadeout time into extra save data
    fadeoutTime = $game_party.setExSaveData("battlerSpriteFadeoutTime", newFadeoutTiming)
    # save the new fadewait time into extra save data
    fadewaitTime = $game_party.getExSaveData("battlerSpriteFadewaitTime", newFadewaitTiming)
    # save the new fadein time into extra save data
    fadeinTime = $game_party.getExSaveData("battlerSpriteFadeinTime", newFadeinTiming)
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to restore the default amount of
  # * time (in frames) that fadeouts/fadewaits/fadeins should take for battler
  # * sprite transitions.
  # * Call with: restore_default_battler_sprite_fade_timings
  #--------------------------------------------------------------------------
  def restore_default_battler_sprite_fade_timings
    # restore the default fadeout time extra save data
    $game_party.setExSaveData("battlerSpriteFadeoutTime", BST::FADE_OUT_LENGTH)
    # restore the default fadewait time in extra save data
    $game_party.setExSaveData("battlerSpriteFadewaitTime", BST::FADE_WAIT_LENGTH)
    # restore the default fadein time in extra save data
    $game_party.setExSaveData("battlerSpriteFadeinTime", BST::FADE_IN_LENGTH)
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to set new data to use for the
  # * battler sprite transition fadeout sound effect.
  # * Call with: set_battler_sprite_fadeout_se(newFadeoutSEFilename, newFadeoutSEVol, newFadeoutSEPitch)
  #--------------------------------------------------------------------------
  def set_battler_sprite_fadeout_se(newFadeoutSEFilename, newFadeoutSEVol, newFadeoutSEPitch)
    # get new fadeout se data array
    newFadeoutSEData = [newFadeoutSEFilename, newFadeoutSEVol, newFadeoutSEPitch]
    
    # save the new fadeout se data array into extra save data
    $game_party.setExSaveData("battlerSpriteFadeoutSE", newFadeoutSEData)
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to set new data to use for the
  # * battler sprite transition fadewait sound effect.
  # * Call with: set_battler_sprite_fadewait_se(newFadewaitSEFilename, newFadewaitSEVol, newFadewaitSEPitch)
  #--------------------------------------------------------------------------
  def set_battler_sprite_fadewait_se(newFadewaitSEFilename, newFadewaitSEVol, newFadewaitSEPitch)
    # get new fadewait se data array
    newFadewaitSEData = [newFadewaitSEFilename, newFadewaitSEVol, newFadewaitSEPitch]
    
    # save the new fadewait se data array into extra save data
    $game_party.setExSaveData("battlerSpriteFadewaitSE", newFadewaitSEData)
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to set new data to use for the
  # * battler sprite transition fadein sound effect.
  # * Call with: set_battler_sprite_fadein_se(newFadeinSEFilename, newFadeinSEVol, newFadeinSEPitch)
  #--------------------------------------------------------------------------
  def set_battler_sprite_fadein_se(newFadeinSEFilename, newFadeinSEVol, newFadeinSEPitch)
    # get new fadein se data array
    newFadeinSEData = [newFadeinSEFilename, newFadeinSEVol, newFadeinSEPitch]
    
    # save the new fadein se data array into extra save data
    $game_party.setExSaveData("battlerSpriteFadeinSE", newFadeinSEData)
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to set new sound effect data to use
  # * for a battler sprite transition fadeouts/fadewaits/fadeins sound effects
  # * all at once.
  # * Call with: set_battler_sprite_all_fade_se(newFadeoutSEData, newFadewaitSEData, newFadeinSEData)
  #--------------------------------------------------------------------------
  def set_battler_sprite_all_fade_se(newFadeoutSEData, newFadewaitSEData, newFadeinSEData)
    # save the new fadeout se data array into extra save data
    $game_party.setExSaveData("battlerSpriteFadeoutSE", newFadeoutSEData)
    # save the new fadewait se data array into extra save data
    $game_party.setExSaveData("battlerSpriteFadewaitSE", newFadewaitSEData)
    # save the new fadein se data array into extra save data
    $game_party.setExSaveData("battlerSpriteFadeinSE", newFadeinSEData)
  end
  
  #--------------------------------------------------------------------------
  # * New method used as a script call to restore the default sound effects
  # * that fadeouts/fadewaits/fadeins trigger during battler sprite transitions.
  # * Call with: restore_default_battler_sprite_fade_sounds
  #--------------------------------------------------------------------------
  def restore_default_battler_sprite_fade_sounds
    # restore the default fadeout sound data in extra save data
    $game_party.setExSaveData("battlerSpriteFadeoutSE", BST::FADE_OUT_SE)
    # restore the default fadeout sound data in extra save data
    $game_party.setExSaveData("battlerSpriteFadewaitSE", BST::FADE_WAIT_SE)
    # restore the default fadein sound data in extra save data
    $game_party.setExSaveData("battlerSpriteFadeinSE", BST::FADE_IN_SE)
  end
  
end

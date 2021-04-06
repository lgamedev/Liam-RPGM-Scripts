# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-MysteryHP"] = true
# END OF IMPORT SECTION

# Script:           Mystery HP state/setting
# Author:           Liam
# Version:          1.0.1
# Description:
# This script allows you to toggle making the hp bar value unkown in and out of
# battle with a game switch and with actor states. Additionally, you
# can restrict the toggled hiding hp bar values to only affect certain party
# members (however, when actors have mystery HP states, they will always have
# a mystery HP bar, unless in battle and MYSTERY_HP_IN_BATTLE is set to false).
# The MP and TP bar can also be set to be hidden along with HP.
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
# Note 1: It is highly recommended to put this script as far at the end of the
# script list as possible for compatibility reasons. It should be past any script
# that modifies things/methods that show the HP/MP/TP bars (Except the one in Note 2)
# Examples - Yanfly's Menu Engine, Yanfly's Battle Engine
#
# Note 2: if using Liam's TP like MP script, put this script before TP like MP
# (it inserts the TP bar at the end of the existing stuff before it)
#
# Note 3: The mystery HP bar is a fully filled HP bar set to custom colors,
# and the HP bar text displays "???" instead of the HP and Max HP text.
#
# __Usage Guide__
# To use this script, complete all the settings in the modifiable constants
# section. After that, use the mystery hp switch to enable the mystery
# hp toggle, and use notetags on states to make actors with those states
# have a mystery hp bar.
#
# Note: The mystery hp toggle that affects all actors always starts as false/off
# until toggled by turning the MYSTERY_HP_SWITCH_ENABLE game switch to true/on
# in a game event.
#
# Notetag:
# <MYSTHP>
#
# Put this notetag in the "Notes" section on the database page for states
# to make a state into one that causes the mystery hp bar to display for
# actors with that state.
#
#
# __Modifiable Constants__
module MYSTHP    
    # Whether or not to have MP included as well included in the MYSTHP state/effect
    MYSTERY_HP_INCLUDE_MP = false
    
    # Whether or not to have TP included as well included in the MYSTHP state/effect
    # Note: This may have some compatibility issues with other scripts that
    # modify TP. Additionally, this script does not currently support
    # hiding TP when drawn in the menus
    MYSTERY_HP_INCLUDE_TP = false
    
    # Whether or not to have mystery hp affect actors when in-battle or not
    MYSTERY_HP_IN_BATTLE = true
    
    # Note 1: The various HP/MP/TP bars are actually a gradient
    # of 2 colors, with the first being the color on the left side of the
    # gradient, and the second the one on the right. To have a solidly
    # colored bar, just set the two RGB colors to be the same color that you
    # want.
    #
    # Note 2: Uses RGB colors, black by default (red, green, and blue all at 0)
    # For people unfamiliar with RGB, the three numbers specify what amounts
    # of Red, Green and Blue (in that order) go into the final color. Each color
    # maxes out at 255. With all colors at 255, it will create white.
    #
    # The 1st color to use for the HP bar when in mystery mode (left side of gradient)
    MYSTERY_HP_COLOR_1 = (Color.new(0, 0, 0))
    # The 2nd color to use for the HP bar when in mystery mode (right side of gradient)
    MYSTERY_HP_COLOR_2 = (Color.new(0, 0, 0))
    
    # The number of a game switch to use to enable the global mystery hp toggle
    # with. If the game switch set to true, the global mystery hp toggle is on,
    # otherwise, it is off.
    MYSTERY_HP_SWITCH_ENABLE = 351
    
    # 2 settings:
    #   "Global"
    #   All actors will be affected by the mysteryHP when turned on.
    #   "Include Specific Actors"
    #   Only the actors from the actorIDs in the list will be affected by
    #   the mystery hp toggle (they will still be affected by mystery hp states)
    #
    # The setting for how the global mysteryHP toggle affects the actors
    MYSTERY_HP_TOGGLE_VER = "Global"
    # list of actors to be affected by the mysteryHP toggle if it is set to
    # "Include Specific Actors" (all other actors will not be affected)
    MYSTERY_HP_INCLUDED_ACTORS = []
    
    # __END OF MODIFIABLE CONSTANTS__
end



# BEGINNING OF SCRIPTING ====================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # * New method used to check the actor-specific parts of the mysteryHP checks.
  # * Checks if the actor has a state that causes mysteryHP or if the
  # * actor should have mysteryHP due to global mysteryHP settings.
  #--------------------------------------------------------------------------
  def actorMysteryHPEnabled?(actor)
    # first, check if the actor has the mysteryHP state, because that
    # will always result in the actor having mysteryHP no matter what
    
    # go through the list of the battler's states check if any state
    # has a <MYSTHP> notetag. If one does, return true.
    (actor.states).each do |state|
      stateID = state.id # get state id
      stateData = $data_states[stateID] # get state data
      # true if <MYSTHP> notetag found in state, else false
      stateMystHPActive = stateData.mysteryHPState
      if (stateMystHPActive)
        return true
      end
    end
    
    # check if global mysteryHP toggle is on
    globalMysteryHPOn = $game_switches[MYSTHP::MYSTERY_HP_SWITCH_ENABLE]
    
    # get the MYSTERY_HP_TOGGLE_VER setting as all lower case letters
    globalMysteryToggleSetting = MYSTHP::MYSTERY_HP_TOGGLE_VER.downcase
    # case statement, choose appropriate true/false value to return based
    # on actor and settings
    case globalMysteryToggleSetting
    when "global"
      # if the global mysteryHP toggle is on, return true because all
      # actors should be affected
      if (globalMysteryHPOn)
        return true
      end
    when "include specific actors"
      # if the global mysteryHP toggle is on, check if the actor's actorID
      # is in the MYSTERY_HP_INCLUDED_ACTORS list, if the actor is, return true
      if (globalMysteryHPOn)
        if (MYSTHP::MYSTERY_HP_INCLUDED_ACTORS.include?(actor.id))
          return true
        end
      end
    end
    
    # returns false if no reason to have the actor
    return false
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if all mysteryHP checks are met for a given actor.
  # * Returns true if all of them are, otherwise return false.
  #--------------------------------------------------------------------------
  def allMysteryHPChecksMet?(actor)
    # checks if mysteryHP is enabled for the actor
    mysteryHPEnabledForActor = actorMysteryHPEnabled?(actor)
    
    # start by assuming battle checks passed, must prove wrong
    mysteryHPBattleChecksMet = true
    # checks if in battle, if in battle, checks if mysteryHP enabled for battle
    if ($game_party.in_battle)
      # if mysteryHP not enabled for battle, fail the mysteryHPBattleChecks
      if (!MYSTHP::MYSTERY_HP_IN_BATTLE)
        mysteryHPBattleChecksMet = false
      end
    end
    
    # if mystery hp enabled for actor, and all mysteryHP battle checks are met,
    # call original method and return
    return (mysteryHPEnabledForActor && mysteryHPBattleChecksMet)
  end
  
  #--------------------------------------------------------------------------
  # * Aliased draw_actor_simple_status() used to call original method
  # * unless the mystery HP status is enabled for the actor.
  # * Calls a (near) copyversion of the draw_actor_hp method instead of
  # * the original one for compatibility reasons.
  # *
  # * Note: This method is aliased, but may still caus compatibility issues
  # * because it cannot always call the original method. See the top of
  # * this script for more information.
  #--------------------------------------------------------------------------
  alias not_mysthp_draw_actor_simple_status draw_actor_simple_status
  def draw_actor_simple_status(actor, x, y)
    # if not all of the mysteryHPChecks are met, call the original method,
    # otherwise, do compatibility checks/methods
    if (allMysteryHPChecksMet?(actor))
      # if the yanfly menu engine is imported, use the draw_actor_simple_status()
      # compatibility method and return, otherwise, use the standard method
      if ($imported["YEA-AceMenuEngine"])
        # call yanfly menu engine draw_actor_simple_status() compatibility method
        mysthp_draw_actor_simple_status_yanfly_menu_engine_compatibility(actor, x, y)
        return
      else
        # call the standard draw_actor_simple_status() mysteryHP version and return
        draw_actor_simple_status_mysteryhp(actor, x, y)
        return
      end
    end
    
    # call original method (draw name, level, hp (not mystery), mp, etc.)
    not_mysthp_draw_actor_simple_status(actor, x, y)

  end
  
  #--------------------------------------------------------------------------
  # * New method that is a near-copy of the base script draw_actor_simple_status()
  # * method, but calls the draw_actor_mystery_hp() method instead of the normal
  # * draw_actor_hp().
  #--------------------------------------------------------------------------
  def draw_actor_simple_status_mysteryhp(actor, x, y)
    # Same as in base script draw_actor_simple_status() -------------
    draw_actor_name(actor, x, y)
    draw_actor_level(actor, x, y + line_height * 1)
    draw_actor_icons(actor, x, y + line_height * 2)
    draw_actor_class(actor, x + 120, y)
    # end of draw_actor_simple_status() stuff -----------------------
    
    # same params as draw_actor_hp, but calls mysteryHP copy draw_actor_hp() method
    draw_actor_mystery_hp(actor, x + 120, y + line_height * 1)
    
    # if mysteryHP includes MP, then use same params as draw_actor_mp,
    # but calls the copy mysteryHP draw_actor_mp() method
    if (MYSTHP::MYSTERY_HP_INCLUDE_MP)
      draw_actor_mystery_mp(actor, x + 120, y + line_height * 2)
    else
      draw_actor_mp(actor, x + 120, y + line_height * 2)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used for Yanfly battle engine compatibility, mostly copies
  # * their overriden draw_actor_simple_status() method with some changes to
  # * use mysteryHP.
  #--------------------------------------------------------------------------
  def mysthp_draw_actor_simple_status_yanfly_menu_engine_compatibility(actor, dx, dy)
    # note: everything here is mostly untouched from the original yanfly menu engine
    # script except the commented areas w/ mystery HP/MP methods
    dy -= line_height / 2
    draw_actor_name(actor, dx, dy)
    draw_actor_level(actor, dx, dy + line_height * 1)
    draw_actor_icons(actor, dx, dy + line_height * 2)
    dw = contents.width - dx - 124
    draw_actor_class(actor, dx + 120, dy, dw)
    # use draw_actor_mystery_hp instead of the normal draw_actor_hp
    draw_actor_mystery_hp(actor, dx + 120, dy + line_height * 1, dw)
    if YEA::MENU::DRAW_TP_GAUGE && actor.draw_tp? && (!actor.draw_mp? || !YEA::MENU::DRAW_MP_GAUGE)
      draw_actor_tp(actor, dx + 120, dy + line_height * 2, dw)
    elsif YEA::MENU::DRAW_TP_GAUGE && YEA::MENU::DRAW_MP_GAUGE && actor.draw_tp? && actor.draw_mp?
      if $imported["YEA-BattleEngine"]
        draw_actor_tp(actor, dx + 120, dy + line_height * 2, dw/2 - 1)
        # if mysteryHP includes MP, then use same params as draw_actor_mp,
        # but calls the copy mysteryHP draw_actor_mp() method
        if (MYSTHP::MYSTERY_HP_INCLUDE_MP)
          draw_actor_mystery_mp(actor, dx + 120 + dw/2, dy + (line_height * 2), dw/2 + 1)
        else
          draw_actor_mp(actor, dx + 120 + dw/2, dy + (line_height * 2), dw/2 + 1)
        end
      else
        # if mysteryHP includes MP, then use same params as draw_actor_mp,
        # but calls the copy mysteryHP draw_actor_mp() method
        if (MYSTHP::MYSTERY_HP_INCLUDE_MP)
          draw_actor_mystery_mp(actor, dx + 120, dy + line_height * 2, dw/2 - 1)
        else
          draw_actor_mp(actor, dx + 120, dy + line_height * 2, dw/2 - 1)
        end
        draw_actor_tp(actor, dx + 120 + dw/2, dy + line_height * 2, dw/2 + 1)
      end
    elsif YEA::MENU::DRAW_MP_GAUGE && actor.draw_mp?
      # if mysteryHP includes MP, then use same params as draw_actor_mp,
      # but calls the copy mysteryHP draw_actor_mp() method
      if (MYSTHP::MYSTERY_HP_INCLUDE_MP)
        draw_actor_mystery_mp(actor, dx + 120, dy + line_height * 2, dw)
      else
        draw_actor_mp(actor, dx + 120, dy + line_height * 2, dw)
      end
    end
    return unless $imported["YEA-JPManager"]
    draw_actor_jp(actor, dx + 120, dy, dw)
  end
  
  #--------------------------------------------------------------------------
  # * New method that is mostly a copy of draw_actor_hp() except for the lines
  # * at the top used to draw the actor hp bar but as a mysteryHP version.
  #--------------------------------------------------------------------------
  def draw_actor_mystery_hp(actor, x, y, width = 124)
    # get mysteryHP bar colors
    mystHPGaugeColor1 = MYSTHP::MYSTERY_HP_COLOR_1
    mystHPGaugeColor2 = MYSTHP::MYSTERY_HP_COLOR_2
    # gauges are filled with a rate of 1.0, so use that
    mystHPGaugeAmnt = 1.0
    # what to replace the HP numbers with (MHP and HP)
    # feel free to change this
    mystHPNumReplace = "???"
    
    # rest is basicaly draw_actor_hp() but using the data above
    draw_gauge(x, y, width, mystHPGaugeAmnt, mystHPGaugeColor1, mystHPGaugeColor2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::hp_a)
    draw_current_and_max_values(x, y, width, (mystHPNumReplace + " "), mystHPNumReplace,
      hp_color(actor), normal_color)
    end
    
  #--------------------------------------------------------------------------
  # * New method that is mostly a copy of draw_actor_mp() except for the lines
  # * at the top used to draw the actor mp bar but as a mystery version.
  #--------------------------------------------------------------------------
  def draw_actor_mystery_mp(actor, x, y, width = 124)
    # get mystery bar colors
    mystMPGaugeColor1 = MYSTHP::MYSTERY_HP_COLOR_1
    mystMPGaugeColor2 = MYSTHP::MYSTERY_HP_COLOR_2
    # gauges are filled with a rate of 1.0, so use that
    mystMPGaugeAmnt = 1.0
    # what to replace the MP numbers with (MMP and MP)
    # feel free to change this
    mystMPNumReplace = "???"
    
    draw_gauge(x, y, width, mystMPGaugeAmnt, mystMPGaugeColor1, mystMPGaugeColor2)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::mp_a)
    draw_current_and_max_values(x, y, width, (mystMPNumReplace + " "), mystMPNumReplace,
      mp_color(actor), normal_color)
  end
  
  #--------------------------------------------------------------------------
  # * Aliased draw_actor_tp() method used to draw a mystery TP bar just in
  # * case it is called in a non-battle context in some scripts. May support
  # * future compatibility options if requested.
  #--------------------------------------------------------------------------
  alias not_mysthp_draw_actor_tp draw_actor_tp
  def draw_actor_tp(actor, x, y, width = 124)
    # if all mysteryHP checks for actor and the INCLUDE_TP setting is on,
    # use the mystery TP bar lines, otherwise, call the original method
    if (allMysteryHPChecksMet?(actor) && MYSTHP::MYSTERY_HP_INCLUDE_TP)
      # get mystery bar colors
      mystTPGaugeColor1 = MYSTHP::MYSTERY_HP_COLOR_1
      mystTPGaugeColor2 = MYSTHP::MYSTERY_HP_COLOR_2
      # gauges are filled with a rate of 1.0, so use that
      mystTPGaugeAmnt = 1.0
      # what to replace the TP number with
      # feel free to change this
      mystTPNumReplace = "???"
      
      draw_gauge(x, y, width, mystTPGaugeAmnt, mystTPGaugeColor1, mystTPGaugeColor2)
      change_color(system_color)
      draw_text(x, y, 30, line_height, Vocab::tp_a)
      change_color(tp_color(actor))
      draw_text(x + width - 42, y, 42, line_height, mystTPNumReplace, 2)
    else
      # call the original method (do normal TP bar drawing)
      not_mysthp_draw_actor_tp(actor, x, y, width)
    end
  end
  
end


class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Aliased overriden draw_actor_hp() method in subclass for the purposes of
  # * compatibility with battle engine scripts. Currently only supports Yanfly
  # * Battle Engine compatibility. Contact me and make a request for others.
  #--------------------------------------------------------------------------
  alias not_mysthp_draw_actor_hp_battle draw_actor_hp
  def draw_actor_hp(actor, x, y, width = 124)
    # if not all of the mysteryHPChecks are met, call the original method
    # (whatever it may resolve to), otherwise, do compatibility checks/methods
    if (allMysteryHPChecksMet?(actor))
      # if using Yanfly battle engine, use the compatibility method
      if ($imported["YEA-BattleEngine"])
        draw_actor_mysthp_yanfly_battle_engine_compatibility(actor, x, y, width)
      # if no compatibility scripts used, call the default method
      else
        # call the original method, whatever it may resolve to
        not_mysthp_draw_actor_hp_battle(actor, x, y, width)
      end
    else
      # call the original method, whatever it may resolve to
      not_mysthp_draw_actor_hp_battle(actor, x, y, width)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased overriden draw_actor_mp() method in subclass for the purposes of
  # * compatibility with battle engine scripts. Currently only supports Yanfly
  # * Battle Engine compatibility. Contact me and make a request for others.
  #--------------------------------------------------------------------------
  alias not_mysthp_draw_actor_mp_battle draw_actor_mp
  def draw_actor_mp(actor, x, y, width = 124)
    # if not all of the mysteryHPChecks are met or the INCLUDE_MP setting is off,
    # call the original method (whatever it may resolve to), otherwise,
    # do compatibility checks/methods
    if (allMysteryHPChecksMet?(actor) && MYSTHP::MYSTERY_HP_INCLUDE_MP)
      # if using Yanfly battle engine, use the compatibility method
      if ($imported["YEA-BattleEngine"])
        draw_actor_mystmp_yanfly_battle_engine_compatibility(actor, x, y, width)
      # if no compatibility scripts used, call the default method
      else
        # call the original method, whatever it may resolve to
        not_mysthp_draw_actor_mp_battle(actor, x, y, width)
      end
    else
      # call the original method, whatever it may resolve to
      not_mysthp_draw_actor_mp_battle(actor, x, y, width)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased overriden draw_actor_tp() method in subclass for the purposes of
  # * compatibility with battle engine scripts. Currently only supports Yanfly
  # * Battle Engine compatibility. Contact me and make a request for others.
  #--------------------------------------------------------------------------
  alias not_mysthp_draw_actor_tp_battle draw_actor_tp
  def draw_actor_tp(actor, x, y, width = 124)
    # if not all of the mysteryHPChecks are met or the INCLUDE_TP setting is off,
    # call the original method (whatever it may resolve to), otherwise,
    # do compatibility checks/methods
    if (allMysteryHPChecksMet?(actor) && MYSTHP::MYSTERY_HP_INCLUDE_TP)
      # if using Yanfly battle engine, use the compatibility method
      if ($imported["YEA-BattleEngine"])
        draw_actor_mysttp_yanfly_battle_engine_compatibility(actor, x, y, width)
      # if no compatibility scripts used, call the default method
      else
        # call the original method, whatever it may resolve to
        not_mysthp_draw_actor_tp_battle(actor, x, y, width)
      end
    else
      # call the original method, whatever it may resolve to
      not_mysthp_draw_actor_tp_battle(actor, x, y, width)
    end
  end
    
  #--------------------------------------------------------------------------
  # * New method used to draw the actor's HP bar as a mysteryHP bar when
  # * using the Yanfly battle engine script that is mostly a copy of
  # * Yanfly's battle draw_actor_hp() method except for the stuff at the top.
  #--------------------------------------------------------------------------
  def draw_actor_mysthp_yanfly_battle_engine_compatibility(actor, dx, dy, width=124)
    # Same as in draw_actor_mystery_hp() -----------------------------
    # get mysteryHP bar colors
    mystHPGaugeColor1 = MYSTHP::MYSTERY_HP_COLOR_1
    mystHPGaugeColor2 = MYSTHP::MYSTERY_HP_COLOR_2
    # gauges are filled with a rate of 1.0, so use that
    mystHPGaugeAmnt = 1.0
    # what to replace the HP numbers with (MHP and HP)
    # feel free to change this
    mystHPNumReplace = "???"
    # end of draw_actor_mystery_hp stuff() ---------------------------
    
    # rest is same as in yanfly's battler draw_actor_hp except for using
    # the data in the above section
    draw_gauge(dx, dy, width, mystHPGaugeAmnt, mystHPGaugeColor1, mystHPGaugeColor2)
    change_color(system_color)
    cy = (Font.default_size - contents.font.size) / 2 + 1
    draw_text(dx+2, dy+cy, 30, line_height, Vocab::hp_a)
    draw_current_and_max_values(dx, dy+cy, width, mystHPNumReplace, mystHPNumReplace,
      hp_color(actor), normal_color)
    end
    
  #--------------------------------------------------------------------------
  # * New method used to draw the actor's MP bar as a mysteryHP bar when
  # * using the Yanfly battle engine script that is mostly a copy of
  # * Yanfly's battle draw_actor_mp() method except for the stuff at the top.
  #--------------------------------------------------------------------------
  def draw_actor_mystmp_yanfly_battle_engine_compatibility(actor, dx, dy, width = 124)
    # Same as in draw_actor_mystery_mp() -----------------------------
    # get mystery bar colors
    mystMPGaugeColor1 = MYSTHP::MYSTERY_HP_COLOR_1
    mystMPGaugeColor2 = MYSTHP::MYSTERY_HP_COLOR_2
    # gauges are filled with a rate of 1.0, so use that
    mystMPGaugeAmnt = 1.0
    # what to replace the MP numbers with (MMP and MP)
    # feel free to change this
    mystMPNumReplace = "???"
    # end of draw_actor_mystery_mp stuff() ----------------------------
    
    # rest is same as in yanfly's battler draw_actor_mp except for using
    # the data in the above section
    draw_gauge(dx, dy, width, mystMPGaugeAmnt, mystMPGaugeColor1,  mystMPGaugeColor2)
    change_color(system_color)
    cy = (Font.default_size - contents.font.size) / 2 + 1
    draw_text(dx+2, dy+cy, 30, line_height, Vocab::mp_a)
    draw_current_and_max_values(dx, dy+cy, width, mystMPNumReplace, mystMPNumReplace,
      mp_color(actor), normal_color)
    end
    
  #--------------------------------------------------------------------------
  # * New method used to draw the actor's MP bar as a mysteryHP bar when
  # * using the Yanfly battle engine script that is mostly a copy of
  # * Yanfly's battle draw_actor_mp() method except for the stuff at the top.
  #--------------------------------------------------------------------------
  def draw_actor_mysttp_yanfly_battle_engine_compatibility(actor, dx, dy, width = 124)
    # Same as in earlier aliased draw_actor_tp() -----------------------
    # get mystery bar colors
    mystTPGaugeColor1 = MYSTHP::MYSTERY_HP_COLOR_1
    mystTPGaugeColor2 = MYSTHP::MYSTERY_HP_COLOR_2
    # gauges are filled with a rate of 1.0, so use that
    mystTPGaugeAmnt = 1.0
    # what to replace the TP number(s) with
    # feel free to change this
    mystTPNumReplace = "???"
    # end of earlier aliased draw_actor_tp stuff() ---------------------
    
    # rest is same as in yanfly's battler draw_actor_tp except for using
    # the data in the above section      
    draw_gauge(dx, dy, width, mystTPGaugeAmnt, mystTPGaugeColor1, mystTPGaugeColor2)
    change_color(system_color)
    cy = (Font.default_size - contents.font.size) / 2 + 1
    draw_text(dx+2, dy+cy, 30, line_height, Vocab::tp_a)
    change_color(tp_color(actor))
    draw_text(dx + width - 42, dy+cy, 42, line_height, mystTPNumReplace, 2)
  end
    
 end
 
 class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Alised hp_color() method used to make sure the the text color used is
  # * always the default color if in mystery mode.
  #--------------------------------------------------------------------------
  alias after_mysthp_hp_color_check hp_color
  def hp_color(actor)
    # if in mystery HP bar mode for the actor, then immediately return
    # the normal text color
    if (allMysteryHPChecksMet?(actor))
      return normal_color
    end
    
    # call original method (choose text colors based on fullness of HP bar)
    after_mysthp_hp_color_check(actor)
  end
  #--------------------------------------------------------------------------
  # * Alised mp_color() method used to make sure the the text color used is
  # * always the default color if in mystery mode.
  #--------------------------------------------------------------------------
  alias after_mysthp_mp_color_check mp_color
  def mp_color(actor)
    # if in mystery HP bar mode for the actor, and the INCLUDE_MP setting is
    # on, then immediately return the normal text color
    if (allMysteryHPChecksMet?(actor) && MYSTHP::MYSTERY_HP_INCLUDE_MP)
      return normal_color
    end
    
    # call original method (choose text colors based on fullness of MP bar)
    after_mysthp_mp_color_check(actor)
  end
  
  #--------------------------------------------------------------------------
  # * Alised tp_color() method used to make sure the the text color used is
  # * always the default color if in mystery mode.
  #--------------------------------------------------------------------------
  alias after_mysthp_tp_color_check tp_color
  def tp_color(actor)
    # if in mystery HP bar mode for the actor, and the INCLUDE_TP setting is
    # on, then immediately return the normal text color
    if (allMysteryHPChecksMet?(actor) && MYSTHP::MYSTERY_HP_INCLUDE_TP)
      return normal_color
    end
    
    # call original method (has just a normal color by default anyway)
    after_mysthp_tp_color_check(actor)
  end
  
end


class Window_Status < Window_Selectable
  #--------------------------------------------------------------------------
  # * Aliased draw_basic_info() method used to display mysteryHP bar (and 
  # * possible MP bar) instead of the standard one(s) if mysteryHP is active
  # * for the actor.
  #--------------------------------------------------------------------------
  alias not_mysthp_draw_basic_info draw_basic_info
  def draw_basic_info(x, y)
    # if all mysteryHPChecks are met for the actor, draw mysteryHP bar and
    # possible mysteryMP bar
    if (allMysteryHPChecksMet?(@actor))
      draw_actor_level(@actor, x, y + line_height * 0) # from original method
      draw_actor_icons(@actor, x, y + line_height * 1) # from original method
      draw_actor_mystery_hp(@actor, x, y + line_height * 2) # draw mystery HP bar
      # draw mystery mp bar if INCLUDE_MP setting is on, otherwise, draw the
      # normal mp bar
      if (MYSTHP::MYSTERY_HP_INCLUDE_MP)
        draw_actor_mystery_mp(@actor, x, y + line_height * 3) 
      else
        draw_actor_mp(@actor, x, y + line_height * 3)
      end
    else
      # call original method (draw normal level, icons, hp, mp)
      not_mysthp_draw_basic_info(x, y)
    end
  end
end


class RPG::State
  #--------------------------------------------------------------------------
  # * New method used to read in a notetag, which if present, means the state
  # * should cause mysteryHP to trigger for actors who get it.
  #--------------------------------------------------------------------------
  def mysteryHPState
    # check if mysteryHPState has been checked yet, if not, get it
    if @mysteryHPState.nil?
      # checks for MYSTHP notetag being present
      if (@note =~ /<(.*)MYSTHP(.*)>/i)
        # the state activates mysteryHP if the MYSTHP notetag is present
        @mysteryHPState = true
      else
        # false returned as default val if no notetag present
        @mysteryHPState = false
      end
    end
    # mysteryHPState implicit return
    @mysteryHPState
  end
end

class String
  #--------------------------------------------------------------------------
  # * New method to ensure compatibility with Yanfly Battle Engine.
  # * The Yanfly Engine uses a method .group on Numbers to convert numbers
  # * to strings, but this causes an issue for strings like "???" 
  # * because .group is not defined for strings, so this method defines it.
  # * Returns itself (a string).
  #--------------------------------------------------------------------------
  if $imported["YEA-BattleEngine"]
  def group; return self; end
  end
end
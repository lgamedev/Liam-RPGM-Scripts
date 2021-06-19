# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-TPLikeMP"] = true
# END OF IMPORT SECTION

# Script:           TP like MP (& extra TP settings)
# Author:           Liam
# Version:          1.1.4
# Description:
# This script allows you to make TP into a system that works similarly to
# the MP system. Normally, everything to do with TP assumes that max TP has
# a hard cap of 100. You cannot make TP skills costs over 100, you cannot
# make TP gain effects of flat numbers, or make TP-loss effects, and you
# cannot increase or decrease the set max TP. This script changes all of that.
# There is a large amount of settings including settings for initial TP
# at the start of battles, settings for TP preservation, settings for
# changing TP gained by damage, settings for changing how the TCR (TP Charge Rate)
# parameter works, and more. Additionally, a new parameter is added using
# notetags, TPCSTR or TP Cost Rate, which affects how much TP skills cost,
# similar to its MP cost rate equivalent. You can also set up damage
# formulas for TP (Damage, Recovery, Draining), just like HP and MP by
# using damage formula notetags.
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
# Note: If you are also using the mysteryHP script, make sure this script
# is placed after that one. It should also probably be placed somewhat lower
# down on the script list for compatibility reasons
#
# __Usage Guide__
# ! Necessary Database action ! (manually do this if to see the TP bar in battle):
# check "Display TP in Battle" in the upper right corner of the "System"
# tab in the RPGM database. Technically, this isn't necessary if you force
# the TP bars to display, but it might mess with other scripts so you should
# check it just to be safe.
#
# To use this script, modify all of the settings in the Modifiable Constants
# section so that the TP system does what you want, and use the notetags
# that come with this script however you wish.
#
# Note 1: If you want TP to function AS CLOSE TO MP AS POSSIBLE, do the following:
#   - Check the "Display TP in Battle" checkbox in the Database system tab
#   - Set TPLMP_DISPLAY_TP_IN_MENU to true
#   - Set ALWAYS_PRESERVE_TP to true
#   - Set USE_INIT_TP to "None"
#   - Set USE_MAX_TP to "Actor Formula"
#   - Set ACTOR_CUSTOM_MAX_TP_FORMULAS to have a list of actor IDs tied to
#   corresponding formulas in quotes that use the actor's level to calculate
#   an appropriate max TP value.
#   - Set TP_DAMAGE_GAIN_SETTING to "Multiplier"
#   - Set TP_DAMAGE_MULTIPLIER to 0
# Remaining difference: No "TP-type" attack type (like the Physical and Magic attack types)
#
# Note 2: If you want to change tp bar colors/tp skill cost colors, those colors are
# set in Window_Base starting on line 169 with the line
#   def tp_gauge_color1;   text_color(18);  end;
# To change the colors of things, just change the number in text_color()
# To see what each number corresponds to, look up "RPGMaker Text Colors"
# for more information.
# Here is a link helpful picture guide (credit to rpgmakercentral forum member DJBunz):
# https://www.rpgmakercentral.com/uploads/monthly_05_2012/post-10339-0-42132900-1337550530.png
#
# Note 3: For information on how to use the settings, look at the text above
# each setting.
#
#   Calling:
# There is four new script calls you can use in events:
#
# tplmp_change_actor_tp(tpChange, actorID1, actorID2, actorID3, ...)
# This method changes the TP by the tpChange amount (positive or negative number)
# for the actors whose actorIDs are listed.
#
# tplmp_change_party_tp(tpChange)
# This method changes the pary's TP by the tpChange amount
# (positive or negative number) for the active party members.
#
# tplmp_set_actor_tp(newTP, actorID1, actorID2, actorID3, ...)
# This method sets the TP of the actors whose actorIDs are listed to the newTP number.
#
# tplmp_set_party_tp(newTP)
# This method sets the party's TP to the newTP amount.
#
#   Parameters:
# tpChange is what to change an actor's TP value by (it is added to the existing
# TP count for the actor(s)). It should be a number (positive or negative).
#
# newTP is what to set an actor's tp to. It should be a positive number.
#
# actorIDn where n is a number is an actor's ID, and there can be as many
# of them in the comma-separated list as is necessary. This means you can
# can call like:
# tplmp_change_actor_tp(15, 1, 3, 10),
# or just tplmp_change_actor_tp(15, 1)
#
#   Examples:
# tplmp_change_actor_tp(15, 1, 3, 10)
# The above script line will increase the TP of the actors with
# actorIDs 1, 3, and 10.
#
# tplmp_change_party_tp(-15)
# The above script line will decrease the TP of the actors in the party by 15.
#
# tplmp_set_actor_tp(20, 1, 3, 10)
# The above script line will set the TP of the actors with
# actorIDs 1, 3, and 10 to 20.
#
# tplmp_set_party_tp(20)
# The above script line will set the TP of the actors in the party to 20.
#
#   Notetags:
# The following is a guide for the available notetags added in this script.
# Place these in the appropriate "Notes" section of pages in the database.
# 
# Note: Notetags for skills/items will be treated like the "Effects" section
# tp changes, for tp damage formulas, see the Damage Formula Notetags section
# further down this script.
#
# There is a lot of notetags, so here is a quick reference guide before going
# into more detail on each one:
#   VALUES:                NOTETAG FORMATS:     DATABASE PAGES:
#   Max TP Change %      - <MAXTP% num>       | Class, Weapon, Armor, State, Enemy
#   Max TP Change        - <MAXTP num>        | Class, Weapon, Armor, State, Enemy
#   TP Cost Rate         - <TPCSTR num>       | Actor, Class, Weapon, Armor, State, Enemy
#   Extra TP cost        - <EXTPCOST num>     | Skill
#   User TP Change %     - <U-TPCHANGE% num>  | Skill, Item
#   User TP Change Num   - <U-TPCHANGE num>   | Skill, Item
#   Target TP Change %   - <T-TPCHANGE% num>  | Skill, Item
#   Target TP Change Num - <T-TPCHANGE num>   | Skill, Item
#
# Further notetag details start here.
#
# <MAXTP% num>
# <MAXTP num>
#
# The above notetags can be used on the following database pages:
# Class, Weapon, Armor, State, Enemy
#
# The MAXTP% notetag is used to increase or decrease an actor or enemy's
# max TP by a percentage. MAXTP% value starts at 0 without any notetags.
# <MAXTP% 50> will add 50 to that default value of 0. <MAXTP% -75> will remove
# 75 from the MAXTP% value. At a MAXTP% value of -100%, max TP will be zeroed out
# (the MAXTP% value is prevented from dropping below -100%). At a MAXTP%
# value of -50%, the base max TP is halved. At a MAXTP% value of 50%, the base
# max TP is increased 50%. At a maxTP% value of 200%, the max TP is doubled (and
# so on from there). All MAXTP% notetag percentages will be added together
# before performing the multiplication calculation.
#
# The MAXTP notetag is used to increase or decrease an actor or enemy's
# max TP by a flat number. This number is added to the total max TP value
# AFTER the MAXTP% is added. (So if you would want a piece of gear to completely
# remove max TP, then use <MAXTP% -999> and <MAXTP -9999> to be sure it is removed).
#
# <TPCSTR num>
#
# The above notetags can be used on the following database pages:
# Actor, Class, Weapon, Armor, State, Enemy
#
# The TPCSTR (or TP CoSTRate) notetag is used to increase or decrease the TP
# cost rate for an actor or enemy. TPCSTR value starts at 100. Higher TPCSTR
# values result in TP skill costs increasing, and lower TPCSTR values result
# in TP skill costs decreasing. At a TPCSTR value of 0, all TP skill costs
# will be zeroed out (the TPCSTR value is preventing from dropping below 0).
# TPCSTR number values can be positive or negative.
#
# <EXTPCOST num>
# 
# The above notetag can be used on the following database page:
# Skill
#
# The EXTPCOST notetag is used to set nonstandard TP costs for skills that
# require TP to use (normally, the database limits you to 100). You do not need
# to set the normal database TP cost if you use an EXTPCOST notetag, but if you
# do use both, the numbers will be added together. Additionally, the cost
# should be a positive number (user the U-TPCHANGE notetags for TP gain to the
# user for items/skills).
#
# <U-TPCHANGE% num>
# <U-TPCHANGE num>
#
# The above notetags can be used on the following database pages:
# Skill, Item
#
# The U-TPCHANGE% notetag is used to give the !--user--! a percentage of max TP
# amount of TP. The fact that it is specifically the user means that if an item
# or skill with this notetag is used in the menu out of battle, the user will be
# whoever is the actor set to be the partymember who uses items in the menu.
# The U-TPCHANGE% value will be multiplied with max TP to get the amount to add
# to the total skill/item user TP gain.
#
# The U-TPCHANGE notetag is used to give the user a flat number amount of TP.
#
# Both notetags can be, but should probably not, be negative (if you want a negative
# TP gain, you should probably be using a larger TP cost, possibly with an EXTPCOST).
# Additionally, U-TPCHANGE values are counted as a "side-effect" or skills/items,
# the same as the "TP Gain" in the Invocation section for item/skill database pages.
# Being a "side-effect" means that Items/Skills will not be able to be used if
# U-TPCHANGE is the only thing tied to the item/skill. If you want something
# that affects the TP of the user, you should use the "The User" attack scope
# for the item/skill and use the Gain TP% base engine effect, or use
# the T-TPCHANGE notetags.
#
# <T-TPCHANGE% num>
# <T-TPCHANGE num>
#
# The above notetags can be used on the following database pages:
# Skill, Item
#
# The T-TPCHANGE% notetag is used to add/remove a percentage of max TP from
# the target(s). The T-TPCHANGE% value will be multiplied with max TP to get
# the amount to add/remove to the total skill/item user TP change.
#
# The T-TPCHANGE notetag is used to make the target(s) gain/lose a flat number of TP.
#
# Both notetags, for the purposes of being able to use items, count the same
# as the Gain TP % effect in the standard database. This means that items
# with T-TPCHANGE notetags will be able to be used unless the total calculated
# T-TPCHANGE value (percent and flat number together) is positive and the actor
# is already at max TP.
#
#   Damage Formula Notetags:
# The following is a guide for the available damage formula notetags added
# in this script.
# Place these in the "Formula" section of skills/item pages in the database
# to transform the formula into a TP-based formula. It does not matter
# which kind of formula the drop-down menu is set to (as long as it isn't
# "none", since that will prevent you from enterng a formula).
#
# Example: <TPDAM> 3 + a.mat
# The above example would set up a TP damaging attack with a value
# of 3 plus the user's magic attack parameter. The formula is the structured
# the same as usual other than the TPDAM notetag in front of it.
# 
# <TPDAM>
#
# The TPDAM notetag is used to turn a damage formula into a TP-damage
# damage formula.
#
# <TPREC>
#
# The TPREC notetag is used to turn a damage formula into a TP-recovery
# damage formula.
#
# <TPDRAIN>
#
# The TPDRAIN notetag is used to turn a damage formula into a TP-draining
# damage formula.
#
#
# __Modifiable Constants__
module TPLMP
  # General Settings
  #   ---------------------------------
  # When true, makes it so the tp bar displays in the menu (not just in battle)
  TPLMP_DISPLAY_TP_IN_MENU = true
  
  # Decides if the TP bar should be forced to display in the menu and in
  # battle for actors regardless of anything else (other than if max TP is 0).
  TPLMP_FORCE_TP_BAR_DISPLAY = true
  
  # List any actors who should always have their TP bars displayed here.
  # (TP bars will still not display if max TP is 0).
  # This should be a comma-separated list.
  # Ex.
  # TPLMP_FORCE_TP_BAR_DISPLAY_ACTORS = [
  #   3, 4, 5
  # ]
  # The above version of the setting will force TP bars to display for actors
  # with the actorIDs 3, 4, and 5.
  TPLMP_FORCE_TP_BAR_DISPLAY_ACTORS = [
    
  ]
  
  # List any actors who should never have their TP bars displayed here.
  # This will override the TPLMP_FORCE_TP_BAR_DISPLAY setting for actors
  # that are put in this list.
  # This should be a comma-separated list.
  # Ex.
  # TPLMP_FORCE_TP_BAR_NEVER_DISPLAY_ACTORS = [
  #   3, 4, 5
  # ]
  # The above version of the setting will force TP bars to never display for actors
  # with the actorIDs 3, 4, and 5.
  TPLMP_FORCE_TP_BAR_NEVER_DISPLAY_ACTORS = [
    
  ]
  
  # When true, makes it so you can always preserve tp between fights,
  # tp will not be reset at the beginning or end of fights
  # (Note: this makes it so INIT_TP is not used)
  ALWAYS_PRESERVE_TP = false
  
  # Decides if tp should only be preserved at the start or end of battle.
  # Set ALWAYS_PRESERVE_TP to false if you want only one of these, or that
  # setting will override this one.
  #   "None" will do no special actions.
  #   "Begin" will make it so TP is not set to the initial TP value at the
  #   beginning of battles (unless the actor's TP lower than initial TP value)
  #   "End" will make it so TP is not cleared at the end of battles
  #   (but it will be set to the initial TP value if that number is higher then
  #   the actor's tp value)
  PRESERVE_TP_ONLY = "Begin"
  #   ---------------------------------
  
  
  # Max TP Settings
  #   ---------------------------------
  # Upper ceiling for max TP, max TP can go no higher than this number.
  MAX_TP_CEILING = 999
  
  # List any actors who should never be able to use TP here (Their max TP
  # will always be set to 0 at all times.)
  # This should be a comma-separated list.
  # Ex.
  # TP_DISABLED_ACTORS = [
  #   3, 4, 5
  # ]
  # The above version of the setting will disable TP for actors with the
  # actorIDs 3, 4, and 5.
  TP_DISABLED_ACTORS = [
    
  ]
  
  # Decides how you want to set the max tp for actors
  #   "None" to use the default value (100)
  #   "Number" to use MAX_TP_NUMBER
  #   "Formula" to use MAX_TP_FORMULA
  #   "Actor Number" to set different numbers for different actors, and 
  #   MAX_TP_NUMBER as the default
  #   "Actor Formula" to set different formulas for different actors, and
  #   MAX_TP_FORMULA as the default
  USE_MAX_TP = "Actor Number"
  # The standard maximum TP number.
  # NOTE: This number is used for maximum enemy TP no matter what setting
  # you use. To increase/decrease the number for specific enemies,
  # use the MAXTP notetags (and use negative or positive values).
  MAX_TP_NUMBER = 100
  
  # Sets a custom max TP ruby formula to evaluate. Use a formula with
  # the actor level in it to increase max TP upon level up.
  # 
  # Possible useful elements to use in initial TP calculation formulas:
  #   #  self.agi
  #   Actor agility
  #   #  self.luk
  #   Actor luck
  #   #  getBattlerLevel
  #   Actor level
  #
  # Custom formulas require quotes around them.
  # Ex.
  # "(5 * getBattlerLevel) + 5"
  # The above formula sets base max TP to be 5 times the actor's level + 5
  MAX_TP_FORMULA = "(5 * getBattlerLevel) + 5"
  
  # Sets custom max tp numbers for specific actors. MAX_TP_NUMBER is used
  # as the default number if there is no number set for an actor.
  #
  # format:
  #   actorID => maxTPNum
  # Ex.
  # ACTOR_CUSTOM_MAX_TP_NUMBERS = {
  #   1 => 400, 3 => 120
  # }
  # The above version of the setting will make the base TP for the actor
  # with the actorID of 1 400, and the base TP for the actor with the actorID
  # of 3, 120.
  ACTOR_CUSTOM_MAX_TP_NUMBERS = {
    # formatted example to base things off of below
    #1 => 400, 3 => 120
    3 => 20,
    4 => 200
  }
  
  # Sets custom ruby formulas to evaluate for specific actors. MAX_TO_FORMULA
  # is used as the default formula if there is no formula set for an actor.
  #
  # For possible useful elements, see the ones for MAX_TP_FORMULA
  #
  # format:
  #   actorID => "formula"
  # Ex.
  # ACTOR_CUSTOM_MAX_TP_FORMULAS = {
  #   1 => "(5 * getBattlerLevel) + 5", 3 => "(10 * getBattlerLevel) + 5"
  # }
  # The above setting would result in the actor with actorID 1 in having
  # a max TP growth rate based on level that is half as much as the actor
  # with actorID 3.
  ACTOR_CUSTOM_MAX_TP_FORMULAS = {
    # formatted example to base things off of below
    #1 => "(5 * getBattlerLevel) + 5", 3 => "(10 * getBattlerLevel) + 5"
  }
  #   ---------------------------------
  
  
  # Battle Initial TP Settings
  #   ---------------------------------
  # Decides what form of initializing tp at the start of battle you want for actors.
  #   "None" to have it not change the existing TP, (You can use this if ALWAYS_PRESERVE_TP is on)
  #   "Number" to use INIT_TP_NUMBER
  #   "Max" to use the actor's max tp
  #   "Formula" to use INIT_TP_FORMULA
  USE_INIT_TP = "Number"
  # Initialize tp at start of battles to this number if enabled.
  INIT_TP_NUMBER = 10
  # Initialize tp at start of battle to a ruby formula (in quotes).
  # Note: the default formula used here is the base script's standard formula
  # used to initialize tp, which is a random percentage (decimal number btwn
  # 0 and 1), and multiplied by 25 (resulting in range of 0-25, avg = 12).
  # This looks like -> "rand * 25"
  #
  # Possible useful elements to use in initial TP calculation formulas:
  #   #  rand
  #   Gets random decimal number btwn 0 and 1, use like a percentage
  #   #  rand(put a number here)
  #   Gets a random number between 0 and (1 - the number you put in there)
  #   #  rand(num1..num2)
  #   Gets a random number between num1 and num2 (inclusive range)
  #   #  self.max_tp
  #   Actor max TP
  #   #  self.agi
  #   Actor agility
  #   #  self.luk
  #   Actor luck
  #   #  getBattlerLevel
  #   Actor level
  #
  # Note: if the result ends up being negative or over the tp maximum,
  # it will bring it up to 0 or down to the tp maximum and make the result
  # an integer (num w/o decimals)
  #
  # Custom formulas require quotes around them.
  # Ex.
  # "(((rand(-25..25) + 50) / 100.0) * max_tp).to_i"
  # The above formula would start off actors/enemies with between 25% and 75%
  # of their max TP.
  # IMPORTANT NOTE: Using 100.0 in percentage division is necessary so that
  # the code interpreter uses decimals in the percentage result.
  INIT_TP_FORMUlA = "rand * 25"
  
  # Decides what form of initializing tp at the start of battle you want
  #   "None" to have it not change the existing TP, (You can use this if ALWAYS_PRESERVE_TP is on)
  #   "Number" to use ENEMY_INIT_TP_NUMBER
  #   "Max" to use the enemy's max tp
  #   "Formula" to use ENEMY_INIT_TP_FORMULA
  USE_ENEMY_INIT_TP = "Max"
  # Initialize enemy TP at start of battles to this number if enabled.
  ENEMY_INIT_TP_NUMBER = 10
  # Initialize enemy TP at start of battle to a ruby formula (in quotes).
  #
  # Custom formulas require quotes around them.
  # Ex.
  # "(((rand(-25..25) + 50) / 100.0) * max_tp).to_i"
  # The above formula would start off actors/enemies with between 25% and 75%
  # of their max TP.
  # IMPORTANT NOTE: Using 100.0 in percentage division is necessary so that
  # the code interpreter uses decimals in the percentage result.
  ENEMY_INIT_TP_FORMUlA = "rand * 75"
  #   ---------------------------------
  
  
  # Damage TP Gain Settings
  #   ---------------------------------
  # A constant number to add to the total damage tp gain whenever taking damage
  # (added to custom formula too if not set to zero)
  TP_DAMAGE_FLAT_GAIN = 0
  
  # If this setting is enabled/true, it will use the percentage in
  # TP_GUARDING_BONUS_PERCENT and multiply it with the tp gained through
  # whatever formula for tp gain through damage is used
  TP_GUARDING_BONUS_USED = false
  
  # This setting is the percent bonus TP to add to TP gained through damage when
  # guarding (not including the flat gain) if the TP_GUARDING_BONUS_USED setting
  # is set to true.
  # Ex. 40  ->  40% bonus TP gained
  TP_GUARDING_BONUS_PERCENT = 140
  
  # Note 1: damage_rate is the decimal percent of hp damage taken by an actor
  # (Example: .325 is 32.5% of health lost)
  #
  # Note 2: tcr is tp charge rate (this is an effect that can be can be set
  # normally as an sp-parameter)
  #
  # Decides how you want to set the max tp for actors
  #   "None" to use the default formula (50 * damage_rate * tcr)
  #   "Multiplier" to use TP_DAMAGE_MULTIPLIER (this number replaces 50 in the default formula)
  #   "Formula" to use TP_DAMAGE_CUSTOM_FORMULA
  TP_DAMAGE_GAIN_SETTING = "Multiplier"
  
  # Number to multiply with damage_rate and the tcr. Replaces 50 from the default formula.
  # Ex. 50
  # This is the number used in the base script. A battler losing 10%
  # of their health would get 5 TP, losing 50% health would get 25 TP, etc.
  # Set to 0 to gain no TP from damage.
  TP_DAMAGE_MULTIPLIER = 65
  
  # Possible useful elements to use in initial TP calculation formulas:
  #   # damage_rate
  #   What decimal percentage btwn 0 and 1 of the actor's hp was taken
  #   #  rand
  #   Gets random decimal number btwn 0 and 1, use like a percentage
  #   #  rand(put a number here)
  #   Gets a random number between 0 and (1 - the number you put in there)
  #   #  self.max_tp
  #   Actor max TP
  #   #  tp_rate
  #   Gets decimal percentage btwn 0 and 1 for (actor's current TP / actor's max TP)
  #   #  self.def
  #   Actor defence
  #   #  tcr
  #   Actor TP charge rate (special parameter, normally mutiplied against all
  #   normal sources of TP gain.)
  #
  # Custom formulas require quotes around them.
  # Ex.
  # "50 * damage_rate * tcr"
  # The above formula is the one used in the base script. It multiplies the
  # damage_rate (percentage of battler's hp taken) by 50, and then the result
  # of that times the TP charge rate. This means a battler losing 10%
  # of their health would get 5 TP, losing 50% health would get 25 TP, etc.
  TP_DAMAGE_CUSTOM_FORMULA = "50 * damage_rate * tcr"
  #   ---------------------------------
  
  
  # TP Charge Rate Settings
  #   ---------------------------------
  # Note: Just in case you are not aware, TP charge rate, or TCR,
  # is a setting in the default game engine as a special parameter
  # that affects how fast TP is gained.
  
  # If this setting is enabled/true, it will make TCR cause TP losses
  # to be diminished when TCR is higher then normal, and increase TP losses
  # when TCR is lower than normal. If it is disabled/false, only
  # tp gain will be affected by TCR.
  # If enabled, if TCR was 50% rather than the standard 100%, then
  # a TP loss of 30 would be doubled to 60. If TCR was 150%, then a TP loss of
  # 30 would be 1/3 less, or 20. If TCR was 200%, then a TP loss of 30
  # would be halved, or 15.
  TP_CHARGE_RATE_CHANGES_TP_LOSS = false
  
  # If this setting is enabled/true, it will make TCR affect the
  # tp gain effect for skills/items in the database.
  # Notetagged target TP gain/loss is also affected by this.
  TP_CHARGE_RATE_FOR_EFFECT_TARGET_TP_CHANGE = true
  
  # Normally, TCR affects the user tp gain in the "invocation" section
  # of skills/items in the database. Setting this to false will make
  # it not affect this.
  # Notetagged user TP gain/loss is also affected by this.
  TP_CHARGE_RATE_FOR_INVOCATION_USER_TP_CHANGE = true
  #   ---------------------------------
  
  # __END OF MODIFIABLE CONSTANTS__
  
  
  
  # BEGINNING OF SCRIPTING ====================================================
  
  # These numbers deal with data values in the RPG::UsableItem::Damage class.
  # They are used to create the TP damage formulas.
  # !!! DO NOT MODIFY THESE !!! unless there is a reason like compatibility
  # issues and you know what you're doing.
  
  # Number for the "TP damage" damage type
  TP_DAMAGE_TYPE_NUM = 21
  # Number for the "TP recovery" damage type
  TP_RECOVER_TYPE_NUM = 22
  # Number for the "TP drain" damage type
  TP_DRAIN_TYPE_NUM = 23
end


class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Aliased tp= assignment operator to ensure that tp val stays as an integer
  #--------------------------------------------------------------------------
  alias before_tplmp_ensure_int tp=
  def tp=(tp)
    # ensure the tp parameter is an integer (there's no reason the tp
    # should ever be set to a value with a decimal in it)
    tpParam = tp.to_i
    
    # only line of original method -> @tp = [[tp, max_tp].min, 0].max
    # call original method, but with the parameter as an integer
    before_tplmp_ensure_int(tpParam)
    
    # ensures that tp is btwn 0 and max tp value
    refresh
  end
  
  #--------------------------------------------------------------------------
  # * Aliased max_tp() used to account for custom max tp values (not just having
  # * it be 100 and nothing else). There are different ways of obtaining
  # * the max tp values depending on the max tp setting.
  #--------------------------------------------------------------------------
  # aliased max tp to allow custom max tp values
  alias after_tplmp_calc_max_tp max_tp
  def max_tp
    # check if the list of TP-disabled actors is empty. If it isn't,
    # check the list to see if the current battler is a TP-disabled actor
    if (TPLMP::TP_DISABLED_ACTORS != nil)
      if (self.kind_of?(Game_Actor))
        actorID = self.id
        # if the actor is TP-disabled, return 0 for the max TP
        if (TPLMP::TP_DISABLED_ACTORS.include?(actorID))
          return 0
        end
      end
    end
    
    # start the end result max tp at -1 (just to reveal if there is an error)
    resultMaxTP = -1
    
    # get the USE_MAX_TP setting as all lower case letters
    maxTPSetting = TPLMP::USE_MAX_TP.downcase
    # case statement, choose appropriate tp for each max TP setting
    case maxTPSetting
    when "none"
      # use the default max TP, 100
      resultMaxTP = 100
    when "number"
      # set max tp to MAX_TP_NUMBER
      resultMaxTP = TPLMP::MAX_TP_NUMBER
    when "formula"
      # set max tp to evaluated ruby formula from MAX_TP_FORMULA
      resultMaxTP = (eval(TPLMP::MAX_TP_FORMULA)).to_i
    when "actor number"
     # make 100% sure the object is an actor
      if (self.kind_of?(Game_Actor))
        actorID = self.id
        # check if the ACTOR_CUSTOM_MAX_TP hash has the battler's
        # actorID in it, then use the custom number for that actor,
        # otherwise, use the default number MAX_TP_NUMBER
        if (TPLMP::ACTOR_CUSTOM_MAX_TP_NUMBERS.has_key?(actorID))
          resultMaxTP = TPLMP::ACTOR_CUSTOM_MAX_TP_NUMBERS[actorID]
        else
          resultMaxTP = TPLMP::MAX_TP_NUMBER
        end
      else
        # if enemies use TP, just use the MAX_TP_NUMBER
        resultMaxTP = TPLMP::MAX_TP_NUMBER
      end
    when "actor formula"
      # make 100% sure the object is an actor
      if (self.kind_of?(Game_Actor))
        actorID = self.id
        # check if the ACTOR_CUSTOM_MAX_TP_FORMULAS hash has the battler's
        # actorID in it, then use the custom formula for that actor,
        # otherwise, use the default number MAX_TP_FORMULA
        if (TPLMP::ACTOR_CUSTOM_MAX_TP_FORMULAS.has_key?(actorID))
          resultMaxTP = (eval(TPLMP::ACTOR_CUSTOM_MAX_TP_FORMULAS[actorID])).to_i
        else
          resultMaxTP = (eval(TPLMP::MAX_TP_FORMULA)).to_i
        end
      else
        # if enemies do use TP, just use the MAX_TP_NUMBER
        resultMaxTP = TPLMP::MAX_TP_NUMBER
      end
    end
    
    # get the extra notetagged max TP values
    extraMaxTP = calculateTotalMaxTPChange(resultMaxTP)
    resultMaxTP += extraMaxTP
    
    # if result TP above max TP ceiling, set max tp to the tp ceiling
    if (resultMaxTP > TPLMP::MAX_TP_CEILING)
      resultMaxTP = TPLMP::MAX_TP_CEILING
    end
    
    # if the result max TP is below zero, set the max tp to zero
    if (resultMaxTP < 0)
      resultMaxTP = 0
    end
    
    # return the final result for max TP
    return resultMaxTP
    
    # only line of original method -> return 100
    # call original method (it just returns 100)
    # (this shouldn't be reached...)
    after_tplmp_calc_max_tp
  end
  
  #--------------------------------------------------------------------------
  # * New method used to calculate the total amount of notetagged 
  # * extra max TP to add to the standard max TP.
  # * Returns the calculated value.
  #--------------------------------------------------------------------------
  def calculateTotalMaxTPChange(standardMaxTP)
    # get the percentage of max TP to change target TP by
    maxTPChangePercent = calcBattlerMAXTPPercent
    # multiply the max TP percentage against standard max TP and store the value
    maxTPChangePercentNum = ((maxTPChangePercent / 100.0) * standardMaxTP).to_i
    
    # get the flat number to change max TP by
    maxTPChangeNum = calcBattlerMAXTPPNum
    
    # get the final result, the calculated max TP percent number + the flat max TP number
    finalMaxTPChange = maxTPChangePercentNum + maxTPChangeNum
    
    # return the final amount to change max TP by
    return finalMaxTPChange
  end
  
  #--------------------------------------------------------------------------
  # * Aliased tp_rate() method used to pretty much just return my version
  # * of the tp_rate calculation (the original just returns 100 instead of
  # * the max_tp value)
  #--------------------------------------------------------------------------
  # aliased to pretty much just return my version, used for calculations
  # and for drawing tp bars correctly on menus
  alias before_tplmp_new_tp_rate tp_rate
  def tp_rate
    # only line of original method -> @tp.to_f / 100
    # call original method, get original tp_rate
    origTPRate = before_tplmp_new_tp_rate
    
    # but always return the new form of calculating the tp rate,
    # where result is 0 if max_tp not greater than 0, and is otherwise
    # the tp / max_tp
    return max_tp > 0 ? (@tp.to_f / max_tp) : 0
  end
  
  #--------------------------------------------------------------------------
  # * Aliased recover_all() method used so that actors start with max tp if
  # * tp is always preserved.
  #--------------------------------------------------------------------------
  alias before_tplmp_recoverall_tp recover_all
  def recover_all
    # Note: recover_all is used when actors are initialized
    
    # call original method, clear all states and recover all hp and mp
    before_tplmp_recoverall_tp
    
    # if tp is always preserved, set the starting tp to the max_tp
    if (TPLMP::ALWAYS_PRESERVE_TP)
      @tp = max_tp
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased skill_tp_cost() method used to allow for use of notetagged custom
  # * tp skill costs (engine database doesn't let you set them over 100....)
  # * as well to use a a new "parameter" TCSR which can lower/increase
  # * TP skill costs, just like the base engine special parameter MCR, which
  # * can increase/lower MP skill costs.
  #--------------------------------------------------------------------------
  alias tplmp_skill_orig_tp_cost skill_tp_cost
  def skill_tp_cost(skill)    
    # get the extra TP cost from the EXTPCOST notetag for the skill given.
    # (returns -1 if no notetag found)
    extraTPCost = $data_skills[skill.id].tplmp_getExTPCost
    # set extraTPCost to 0 if it equals -1
    if (extraTPCost == -1)
      extraTPCost = 0
    end
    
    # only line of original method  (implicitly returns this)-> skill.tp_cost
    # call original method and store the result in origTPCost
    origTPCost = tplmp_skill_orig_tp_cost(skill)
    
    # get final TP cost, which is the original cost from the database with the
    # new notetagged EXTPCOST added
    finalTPCost = origTPCost + extraTPCost
    
    # get the tp CostMultiplier for the battler
    tpCostMultiplier = calcBattlerTPCostRate
    
    # multiply the finalTPCost with the (tpCostMultiplier / 100.0)
    # because maxTPMultiplier is a percentage
    finalTPCost = (((tpCostMultiplier / 100.0) * finalTPCost).to_i)
    
    # implicitly return the final TP cost
    finalTPCost
  end
  
  #--------------------------------------------------------------------------
  # * Aliased refresh() method for Game_BattlerBase used to ensure that tp
  # * (like hp and mp) is within the acceptable range (0 and the tp maximum).
  #--------------------------------------------------------------------------
  alias before_tplmp_tp_refresh refresh
  def refresh
    # call original method (make sure hp/mp in bounds, correct states applied, etc.)
    before_tplmp_tp_refresh
    
    # ensure tp is between 0 and the max_tp
    @tp = [[@tp, max_tp].min, 0].max
  end
  
end


class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * New helper method used to check if a battler is an actor
  # * (if the battler is not, it is an enemy). Returns true/false
  # * depending on if the battler is an actor or not.
  #--------------------------------------------------------------------------
  def tplmp_battlerIsActor?
    # return true if instance of Game_Actor, else false
    return self.kind_of?(Game_Actor)
  end
  
  #--------------------------------------------------------------------------
  # * Aliased on_battle_start() method used to always preserve TP
  # * if the ALWAYS_PRESERVE_TP setting is on. Aliased and not overriden
  # * for compatibility purposes.
  #--------------------------------------------------------------------------
  alias tplmp_always_preserve_tp_orig_start on_battle_start
  def on_battle_start
    # get original tp before the original method can change it
    origTP = self.tp
    
    # only line of original method -> init_tp unless preserve_tp?
    tplmp_always_preserve_tp_orig_start # call original method
    
    # if ALWAYS_PRESERVE_TP is on, set the battler TP the original TP value
    if (TPLMP::ALWAYS_PRESERVE_TP)
      self.tp = origTP
    end
    
    # if preserving TP only at the end of battles,
    # set TP to init_tp if init_tp is the higher number, otherwise keep original tp
    if (!TPLMP::ALWAYS_PRESERVE_TP && (TPLMP::PRESERVE_TP_ONLY.downcase == "begin"))
      # get initialTP
      initialTP = init_tp
      # set TP to either the original TP or init_tp, whichever is higher
      self.tp = (initialTP > origTP) ? initialTP : origTP
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased on_battle_end() method used to always preserve TP
  # * if the ALWAYS_PRESERVE_TP setting is on. Aliased and not overriden
  # * for compatibility purposes.
  #--------------------------------------------------------------------------
  alias tplmp_always_preserve_tp_orig_end on_battle_end
  def on_battle_end
    # get original tp before the original method can change it
    origTP = self.tp
    
    # call original method (removes battle stats, buffs, etc.)
    tplmp_always_preserve_tp_orig_end
    
    # if ALWAYS_PRESERVE_TP is on, set the battler TP the original TP value
    if (TPLMP::ALWAYS_PRESERVE_TP)
      self.tp = origTP
    end
    
    # if preserving TP only at the end of battles,
    # set TP to init_tp if init_tp is the higher number, otherwise keep original tp
    if (!TPLMP::ALWAYS_PRESERVE_TP && (TPLMP::PRESERVE_TP_ONLY.downcase == "end"))
      # get initialTP
      initialTP = init_tp
      # set TP to either the original TP or init_tp, whichever is higher
      self.tp = (initialTP > origTP) ? initialTP : origTP
    end
    
    # if preserving TP only for the beginning of battle, set the actor's tp to
    # the initial TP
    if (!TPLMP::ALWAYS_PRESERVE_TP && (TPLMP::PRESERVE_TP_ONLY.downcase == "begin"))
      self.tp = init_tp
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased init_tp() method used to always decide what to initialize TP
  # * to for battlers depending on what the settings are.
  # * Aliased and not overriden for compatibility purposes.
  #--------------------------------------------------------------------------
  alias tplmp_init_tp_orig init_tp
  def init_tp
    # get original tp before the original method can change it
    origTP = self.tp
    
    # only line of original method -> self.tp = rand * 25
    # (the original line takes a random percentage (decimal num btwn
    # 0 and 1), and multiplies it by 25, resulting in range of 0-25)
    tplmp_init_tp_orig # call orginal method
    
    # use different initial tp depending the battler is a Game_Enemy object or not
    if (self.kind_of?(Game_Enemy))
      # get the USE_INIT_TP setting as all lower case letters
      enemyInitTPSetting = TPLMP::USE_ENEMY_INIT_TP.downcase
      # case statement, choose appropriate tp for each initial TP setting
      case enemyInitTPSetting
      when "none"
        # set initial TP to the original TP
        self.tp = origTP
      when "number"
        # set initial TP to a specific defined number
        self.tp = TPLMP::ENEMY_INIT_TP_NUMBER
      when "max"
        # set initial TP to the max amount of TP
        self.tp = self.max_tp
      when "formula"
        # set tp to the evaluated ruby code formula with result as integer
        self.tp = (eval(TPLMP::ENEMY_INIT_TP_FORMULA)).to_i
      end
    else
      # get the USE_INIT_TP setting as all lower case letters
      initTPSetting = TPLMP::USE_INIT_TP.downcase
      # case statement, choose appropriate tp for each initial TP setting
      case initTPSetting
      when "none"
        # set initial TP to the original TP
        self.tp = origTP
      when "number"
        # set initial TP to a specific defined number
        self.tp = TPLMP::INIT_TP_NUMBER
      when "max"
        # set initial TP to the max amount of TP
        self.tp = self.max_tp
      when "formula"
        # set tp to the evaluated ruby code formula with result as integer
        self.tp = (eval(TPLMP::INIT_TP_FORMULA)).to_i
      end
    end

  end
  
  #--------------------------------------------------------------------------
  # * Aliased item_test() method used to allow usage of items/skill with
  # * tp damage/recovery/draining damage formulas, and usage of tp gain effect
  # * items using the new notetags outside of battle.
  #--------------------------------------------------------------------------
  alias after_tplmp_notetag_tp_changes item_test
  def item_test(user, item)
    # if item exists, set it up properly
    if (item)
      # update the item's damage formula type
      item.damage.tplmp_update_damage_formula_type
    end
    
    # do initial check just to make sure the target isn't dead
    return false if item.for_dead_friend? != dead?
    
    # get current max tp
    currMaxTP = max_tp
    
    # return true if item is primarily a tp recovery item and the target
    # is not at max tp.
    return true if item.damage.recover? && item.damage.to_tp? && tp < currMaxTP
    # return false if item a tp recovery item and target at max tp
    return false if item.damage.recover? && item.damage.to_tp? && tp == currMaxTP
    # return false if item a tp recovery item and target's max tp is 0
    return false if item.damage.recover? && item.damage.to_tp? && currMaxTP == 0
    
    # get the total itemTPChange (from notetags)
    itemTPChange = calculateTotalTargetTPChange(item)
    
    # return true if the itemTPChange is positive and tp < maxTP
    return true if (itemTPChange > 0) && (tp < max_tp)
    
    # Call original method
    after_tplmp_notetag_tp_changes(user, item)
  end
  
  
  #--------------------------------------------------------------------------
  # * Aliased item_apply() method used to correctly gain TP amounts included
  # * both notetagged gain and base engine effect gain. Also ensures that
  # * tp effects/attacks actually go through.
  #--------------------------------------------------------------------------
  alias after_tplmp_item_apply_changes_done item_apply
  def item_apply(user, item)
    # yanfly battle engine compatibility flag, start if off with a 'false' value
    $tplmp_doNotDoPopupsYet = false
    
    # START OF TP TARGET GAIN/LOSS EFFECT HERE --------------
    
    # whether or not the tp gain database effect is found.
    # starts false, must be proven true
    gainTPEffectFound = false
    # the item effect id relating to tp gain for the item
    effectIndexes = [] # start as empty list (TECHNICALLY there gain be multiple gain tp effects)
    # store the original gain_tp effect value here, becuase the value
    # needs to be reset to normal later
    effectOrigValues = [] # start as empty list
    
    # go through the list of effects, and try to find the TP_GAIN effect
    item.effects.each_with_index do |effect, i|
      # if the GAIN_TP effect is found, then the base engine tp gain% database
      # effect is being used.
      if (effect.code == EFFECT_GAIN_TP)
        effectIndexes.push(i) # store the effect index
        effectOrigValues.push(effect.value1) # store the effect value
        gainTPEffectFound = true # set gainTPEffectFound to true
        
        # get the correct base engine tp gain amount
        correctedBaseEngineTPGain = (((effect.value1 / 100.0) * max_tp).to_i)
        # set the effect value to equal the corrected tp gain amount
        effect.value1 = correctedBaseEngineTPGain
      end
    end
    
    notetagTPEffectAdded = false
    # get the notetagged value to change the target's tp by
    # (includes both the calculated % and flat number notetags)
    notetagTPEffectChange = calculateTotalTargetTPChange(item)
    # if the added TP from the notetags is not 0, then an extra effect will
    # temporarily be added to the item list (and will be deleted after processing
    # is complete)
    if (notetagTPEffectChange != 0)
      notetagTPEffectAdded = true # a notetag TP effect is being added, so set to true
      notetagTPEffectIndex = item.effects.length # set the notetag tp effect index to the effect list size
      # add an extra effect with the appropriate values to the item's effect list
      # (will be deleted after processing is complete)
      # Effect initialization parameters (code, data_id, value1, value2)
      item.effects.push(RPG::UsableItem::Effect.new(EFFECT_GAIN_TP, 0, notetagTPEffectChange, 0))
    end
    
    # END OF TP TARGET GAIN/LOSS EFFECT HERE --------------

    # START OF TP USER GAIN/LOSS HERE --------------
    
    origItemTP_gainVal = item.tp_gain # store the original item.tp_gain value
    # get the notetagged value to change the user's tp by
    # (includes both the calculated % and flat number notetags)
    notetagTPUserChange = calculateTotalUserTPChange(item)
    # update the item's tp_gain value by adding the notetagged user TP change
    item.tp_gain += notetagTPUserChange
    
    # END OF TP USER GAIN/LOSS HERE --------------
    
    # call original method (does normal item effect processing)
    after_tplmp_item_apply_changes_done(user, item)
    
    # START OF SKILL/ITEM DATA RESET HERE --------------
    
    # note: changes to the item effects/tp_gain are permanent, so in order
    # for future uses not to start with incorrect data, the data
    # must be reset, and is done in this section.
    
    # if there was one or more base engine tp_gain effects, set them back to normal
    if (gainTPEffectFound == true)
      effectIndexes.each_with_index do |effectIndex, i|
        # set the item effect value to its original value
        item.effects[effectIndex].value1 = effectOrigValues[i]
      end
    end
    
    # if a notetagged tp effect was added, delete it here
    if (notetagTPEffectAdded == true)
      # delete the tp gain effect used for the notetags
      item.effects.delete(item.effects[notetagTPEffectIndex])
    end
    
    # set the item tp_gain back to what it originally was
    item.tp_gain = origItemTP_gainVal
    
    # END OF SKILL/ITEM DATA RESET HERE --------------
    
    # set the no popups flag back to normal, yanfly popups can now fire as normal again
    $tplmp_doNotDoPopupsYet = false
  end
  
  #--------------------------------------------------------------------------
  # * New method used to add up the TP from a target tp percentage gain notetags
  # # and TP from flat number target tp gain.
  #--------------------------------------------------------------------------
  def calculateTotalTargetTPChange(skillOrItem)
    # get the percentage of max TP to change target TP by
    targetTPChangePercent = calcSkillItemTargetTPChangePercent(skillOrItem)
    # multiply the TP percentage against max TP and store the value
    targetTPChangePercentNum = ((targetTPChangePercent / 100.0) * max_tp).to_i
    
    # get the flat number to change target TP by
    targetTPChangeNum = calcSkillItemTargetTPChangeNum(skillOrItem)
    
    # get the final result, the calculated TP percent number + the flat TP number
    finalTargetTPChange = targetTPChangePercentNum + targetTPChangeNum
    
    # return the final amount to change the target TP by
    return finalTargetTPChange
  end
  
  #--------------------------------------------------------------------------
  # * New method used to add up the TP from a user tp percentage gain notetags
  # * and TP from flat number user tp gain.
  #--------------------------------------------------------------------------
  def calculateTotalUserTPChange(skillOrItem)
    # get the percentage of max TP to change user TP by
    userTPChangePercent = calcSkillItemUserTPChangePercent(skillOrItem)
    # multiply the TP percentage against max TP and store the value
    userTPChangePercentNum = ((userTPChangePercent / 100.0) * max_tp).to_i
    
    # get the flat number to change user TP by
    userTPChangeNum = calcSkillItemUserTPChangeNum(skillOrItem)
    
    # get the final result, the calculated TP percent number + the flat TP number
    finalUserTPChange = userTPChangePercentNum + userTPChangeNum
    
    # return the final amount to change the user TP by
    return finalUserTPChange
  end
  
  #--------------------------------------------------------------------------
  # * Aliased item_effect_test() method used to return false if already
  # * at maximum TP for an item that gains TP through the "effects" section
  # * of the database.
  #--------------------------------------------------------------------------
  alias after_tplmp_item_effect_test_checks_done item_effect_test
  def item_effect_test(user, item, effect)
    case effect.code
    # this technically says EFFECT_GAIN_TP, but this manages TP loss too
    when EFFECT_GAIN_TP
      # return true that gain tp effect can be used if TP is less than
      # max TP or if the effect value is negative.
      return (@tp < max_tp || effect.value1 < 0)
    end
    
    # call original method (if gaining HP, MP, gaining/losing states, etc.)
    after_tplmp_item_effect_test_checks_done(user, item, effect)
  end
  
  #--------------------------------------------------------------------------
  # * Aliased item_effect_gain_tp() method used for allowing certain
  # * tcr (tp charge rate) options. Aliased and not overridden for
  # * compatibility purposes.
  #--------------------------------------------------------------------------
  alias tplmp_item_effect_gain_tp_orig_method item_effect_gain_tp
  def item_effect_gain_tp(user, item, effect)
    # yanfly battle engibe compatibility flag, set to true so tp damage/gain
    # popups do not incorrectly fire
    $tplmp_doNotDoPopupsYet = true
    
    origTP = self.tp # store the tp value before original method is run
    # store the tp damage value before original method is run
    origTPDam = @result.tp_damage
    effectValue = effect.value1.to_i # get the effect value
    origResultSuccess = @result.success # get the original success value
    
    # call original method (for compatibility purposes, sets tp, tp_damage,
    # and result success values to new values)
    tplmp_item_effect_gain_tp_orig_method(user, item, effect)
    
    # note 1: (tcr does not affect the tp gain effect by default)
    # note 2: tp_damage may be positive or negative at this point
    
    # first, check if the setting to make TCR affect effect target tp change
    # is on, if it is, do further processing, otherwise, do nothing
    # (the standard method does not use TCR already, so just leave
    # everything as is)
    if (TPLMP::TP_CHARGE_RATE_FOR_EFFECT_TARGET_TP_CHANGE == true)
      # if special processing is needed to include TCR, then first reset
      # the data modified by the original method
      self.tp = origTP
      @result.success = origResultSuccess
      @result.tp_damage = origTPDam
      
      # check if the effectValue is positive or negative, and do different
      # processing depending on the result
      if (effectValue < 0)
        # if the setting for TCR affecting tp loss is on, use TCR when
        # calculating the proper tp_damage, otherwise do not use TCR
        if (TPLMP::TP_CHARGE_RATE_CHANGES_TP_LOSS)
          # get the inverse effect value for tcr since dealing with tp loss
          modifiedEffectValue = (effectValue * (1.0 / tcr)).to_i
          # do changes from the original method with the modifed effect value
          @result.tp_damage -= modifiedEffectValue
          @result.success = true if modifiedEffectValue != 0
          self.tp += modifiedEffectValue
        else
          # do changes from the original method with the modifed effect value
          @result.tp_damage -= effectValue
          @result.success = true if effectValue != 0
          self.tp += effectValue
        end
      elsif (effectValue > 0)
        # use tcr to modify the effect value
        modifiedEffectValue = (effectValue * tcr).to_i
        # do changes from the original method with the modifed effect value
        @result.tp_damage -= modifiedEffectValue
        @result.success = true if modifiedEffectValue != 0
        self.tp += modifiedEffectValue
      end
    end
    
    # if the yanfly battle engine is imported and the do not do popups flag
    # is on, then do the yanfly battle engine make_damage_popups() here
    if ($imported["YEA-BattleEngine"] && $tplmp_doNotDoPopupsYet)
      # set the doNotDoPopups value back to false
      $tplmp_doNotDoPopupsYet = false
      make_damage_popups(user)
      # set back to true (until item_apply is done executing)
      $tplmp_doNotDoPopupsYet = true
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased item_user_effect() method used for allowing certain tcr
  # * (tp charge rate) settings and ensuring tcr affects negative tp_gain
  # * properly. Aliased and not overridden for compatibility purposes.
  #--------------------------------------------------------------------------
  alias tplmp_item_user_effect_orig_method item_user_effect
  def item_user_effect(user, item)
    # yanfly battle engine compatibility flag, set to true so tp damage/gain
    # popups do not incorrectly fire
    $tplmp_doNotDoPopupsYet = true
    
    origTP = user.tp # store the tp value before original method is run
    
    # only line of original method -> user.tp += item.tp_gain * user.tcr
    # call original method (sets user TP to standard value)
    tplmp_item_user_effect_orig_method(user, item)
    
    # set TP to its original value
    user.tp = origTP
    
    # get user item TP change
    itemUserTPChange = item.tp_gain
    
    # first, check if the setting to make TCR affect user tp change
    # is on, if it is, do further processing using TCR, otherwise,
    # immediately modify user.tp by the itemUserTPChange
    if (TPLMP::TP_CHARGE_RATE_FOR_INVOCATION_USER_TP_CHANGE == true)      
      # check if the itemUserTPChange is positive or negative, and do different
      # processing depending on the result
      if (itemUserTPChange < 0)
        # if the setting for TCR affecting tp loss is on, use TCR when
        # calculating the proper itemUserTPChange, otherwise do not use TCR
        if (TPLMP::TP_CHARGE_RATE_CHANGES_TP_LOSS)
          # get the inverse effect value for tcr since dealing with tp loss
          modifiedItemUserTPChange = (itemUserTPChange * (1.0 / tcr)).to_i
          user.tp += modifiedItemUserTPChange
        end
      elsif (itemUserTPChange > 0)
        # if the itemUserTPChange is positive and tcr is being used, just
        # use the original method's equivalent
        user.tp += (itemUserTPChange * user.tcr).to_i
      end
    else      
      # add the itemUserTPChange directly to user.tp immediately, no extra
      # processing is needed
      user.tp += itemUserTPChange
    end
    
    # if the yanfly battle engine is imported and the do not do popups flag
    # is on, then do the yanfly battle engine restore_damage() here
    if ($imported["YEA-BattleEngine"] && $tplmp_doNotDoPopupsYet)
      # set the doNotDoPopups value back to false
      $tplmp_doNotDoPopupsYet = false
      @result.restore_damage
      # set back to true (until item_apply is done executing)
      $tplmp_doNotDoPopupsYet = true
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased charge_tp_by_damage() used to change the tp appropriately
  # * according to the user set rate. Aliased just in case other methods
  # * try to change charge_tp_by_damage().
  #--------------------------------------------------------------------------
  alias tplmp_charge_tp_by_damage_orig_method charge_tp_by_damage
  def charge_tp_by_damage(damage_rate)
    # note: the damage_rate parameter is the percentage of max hp the actor lost
    
    # get original tp value
    origTP = self.tp
    
    # only line of original method -> self.tp += 50 * damage_rate * tcr
    # call original method and store the result
    tplmp_charge_tp_by_damage_orig_method(damage_rate)
    origResult = self.tp
    
    # set tp back to original tp
    self.tp = origTP
    
    # get the USE_MAX_TP setting as all lower case letters
    damageTPGainSetting = TPLMP::TP_DAMAGE_GAIN_SETTING.downcase
    # case statement, choose appropriate tp for each max TP setting
    case damageTPGainSetting
    when "none"
      # set TP to the result of the original method
      self.tp = origResult
    when "multiplier"
      # add multiplierNumber * damage_rate * tcr
      self.tp += TPLMP::TP_DAMAGE_MULTIPLIER * damage_rate * tcr
    when "formula"
      # set max TP to evaluated ruby formula from MAX_TP_FORMULA
      self.tp += (eval(TPLMP::TP_DAMAGE_CUSTOM_FORMULA)).to_i
    end
    
    # calculate the bonus tp to add if the guarding tp bonus is enabled
    # and the actor is guarding
    if (TPLMP::TP_GUARDING_BONUS_USED == true && guard?)
      # get the difference btwn the new TP and the old TP
      # (not including the flat gain)
      tpDifference = self.tp - origTP
      
      # get the bonus TP (guarding bonus / 100 because it represents a percentage)
      bonusTP = (((TPLMP::TP_GUARDING_BONUS_PERCENT / 100.0) * tpDifference).to_i)
      # add the bonus TP to the actor's TP
      self.tp += bonusTP
    end
    
    # add TP flat value to the TP count
    self.tp += TPLMP::TP_DAMAGE_FLAT_GAIN
  end
  
  #--------------------------------------------------------------------------
  # * Aliased execute_damage() used to perform target tp damage loss and user
  # * tp drain damage gain.
  #--------------------------------------------------------------------------
  alias tplmp_after_tp_drain_execute execute_damage
  def execute_damage(user)
    # temporarily save tp damage amount (circumvents yanfly variable resets)
    tpDamageAmount = @result.tp_damage
    # temporarily save tp drain amount (circumvents yanfly variable resets)
    tpDrainAmount = @result.tplmp_tp_drain
    
    # Call original method
    tplmp_after_tp_drain_execute(user)
    
    # perform target tp damage losing (or gaining if set to recovery) tp change
    self.tp -= tpDamageAmount
    
    # perform user tp drain tp gain change
    user.tp += tpDrainAmount
  end
  
  #--------------------------------------------------------------------------
  # * Aliased regenerate_tp() method used to properly change tp according
  # * to the actual max_tp.
  #--------------------------------------------------------------------------
  alias tplmp_regenerate_tp_orig_method regenerate_tp
  def regenerate_tp
    # get original tp value
    origTP = self.tp
    
    # only line of original method -> self.tp += 100 * trg
    # call original method
    tplmp_regenerate_tp_orig_method
    
    # set tp value to the orginal value
    self.tp = origTP
    # set the tp value to properly regenerate using max_tp
    self.tp += (max_tp * trg).to_i
  end
  
  #--------------------------------------------------------------------------
  # * New method used to calculate the MAXTP value. Returns the sum of all
  # * the battler's MAXTP notetag values from the following database pages:
  # * Class, Weapons, Armor, States
  #--------------------------------------------------------------------------
  def calcBattlerMAXTPPNum
    # get the user (which is just self)
    user = self
    
    # general note: ternary operators are used to change MAXTP values
    # to be 0 or a specified default value when MAXTP notetags are not present
    # (tplmp_maxTPChangeVal return val of -1 indicated no MAXTP notetag found)
    
    # Start all MAXTP sections as 0
    classMAXTPN = 0
    weaponMAXTPN = 0
    armorMAXTPN = 0
    stateMAXTPN = 0
    
    enemyMAXTPN = 0
    
    # if the battler is an actor, check the notetags (enemies don't need to use max TP notetags)
    if (user.kind_of?(Game_Actor))
      actorClassID = user.class_id # get actor's classID
      classData = $data_classes[actorClassID] # get actor's class data
      classMAXTPNTagVal = classData.tplmp_maxTPNumChangeVal # get actor's class MAXTP tag val (-1 -> no tag)
      # get actor's class MAXTP
      classMAXTPN = (classMAXTPNTagVal != -1) ? classMAXTPNTagVal : 0
      
      actorWeapons = user.weapons # get list of battler's weapons
      # add up all the MAXTP scores in the actor's weapons list
      actorWeapons.each do |weapon|
        weaponID = weapon.id # get weaponID
        weaponData = $data_weapons[weaponID] # get weapon data
        weaponMAXTPNTagVal = weaponData.tplmp_maxTPNumChangeVal # get weapon MAXTP tag val (-1 -> no tag)
        # add weapon MAXTP to total weapon MAXTP
        weaponMAXTPN += (weaponMAXTPNTagVal != -1) ? weaponMAXTPNTagVal : 0
      end
      
      actorArmors = user.armors # get list of battler's armors
      # add up all the MAXTP scores in the actor's armor list
      actorArmors.each do |armor|
        armorID = armor.id # get armorID
        armorData = $data_armors[armorID] # get armor data
        armorMAXTPNTagVal = armorData.tplmp_maxTPNumChangeVal # get armor MAXTP tag val (-1 -> no tag)
        # add weapon MAXTP% to total weapon MAXTP
        armorMAXTPN += (armorMAXTPNTagVal != -1) ? armorMAXTPNTagVal : 0
      end
    end
    
    # go through the list of the battler's states and add MAXTP scores
    (user.states).each do |state|
      stateID = state.id # get state id
      stateData = $data_states[stateID] # get state data
      stateMAXTPNTagVal = stateData.tplmp_maxTPNumChangeVal # get state MAXTP tag val (-1 -> no tag)
      # add state MAXTP% to total state MAXTP
      stateMAXTPN += (stateMAXTPNTagVal != -1) ? stateMAXTPNTagVal : 0
    end
    
    # for enemy battlers (battler not actor), check notetags for enemy
    if (!user.tplmp_battlerIsActor?)
      enemyID = user.enemy_id # get enemyID
      enemyData = $data_enemies[enemyID] # get enemy data
      enemyMAXTPNTagVal = enemyData.tplmp_maxTPNumChangeVal # get enemy MAXTP tag val (-1 -> no tag)
      # get enemy MAXTP
      enemyMAXTP = (enemyMAXTPNTagVal != -1) ? enemyMAXTPNTagVal : 0
    end
    
    # Get the amount to change the battler's tp bar
    # May end up as a positive or a negative number
    maxTPChange = classMAXTPN + weaponMAXTPN + armorMAXTPN + stateMAXTPN + enemyMAXTPN
    
    # return result maxTPChange
    return maxTPChange
  end
  
  #--------------------------------------------------------------------------
  # * New method used to calculate the MAXTP% value. Returns the sum of all
  # * the battler's MAXTP% notetag values from the following database pages:
  # * Class, Weapons, Armor, States
  #--------------------------------------------------------------------------
  def calcBattlerMAXTPPercent
    # get the user (which is just self)
    user = self
    
    # general note: ternary operators are used to change MAXTP% values
    # to be 0 or a specified default value when MAXTP% notetags are not present
    # (tplmp_maxTPChangeVal return val of -1 indicated no MAXTP% notetag found)
    
    # Start all MAXTP% sections as 0
    classMAXTPP = 0
    weaponMAXTPP = 0
    armorMAXTPP = 0
    stateMAXTPP = 0
    
    enemyMAXTPP = 0
    
    # if the battler is an actor, check the notetags (enemies don't need to use max TP notetags)
    if (user.kind_of?(Game_Actor))
      actorClassID = user.class_id # get actor's classID
      classData = $data_classes[actorClassID] # get actor's class data
      classMAXTPPTagVal = classData.tplmp_maxTPPercentChangeVal # get actor's class MAXTP% tag val (-1 -> no tag)
      # get actor's class MAXTP%
      classMAXTPP = (classMAXTPPTagVal != -1) ? classMAXTPPTagVal : 0
      
      actorWeapons = user.weapons # get list of battler's weapons
      # add up all the MAXTP% scores in the actor's weapons list
      actorWeapons.each do |weapon|
        weaponID = weapon.id # get weaponID
        weaponData = $data_weapons[weaponID] # get weapon data
        weaponMAXTPPTagVal = weaponData.tplmp_maxTPPercentChangeVal # get weapon MAXTP% tag val (-1 -> no tag)
        # add weapon MAXTP% to total weapon MAXTP%
        weaponMAXTPP += (weaponMAXTPPTagVal != -1) ? weaponMAXTPPTagVal : 0
      end
      
      actorArmors = user.armors # get list of battler's armors
      # add up all the MAXTP% scores in the actor's armor list
      actorArmors.each do |armor|
        armorID = armor.id # get armorID
        armorData = $data_armors[armorID] # get armor data
        armorMAXTPPTagVal = armorData.tplmp_maxTPPercentChangeVal # get armor MAXTP% tag val (-1 -> no tag)
        # add weapon MAXTP% to total weapon MAXTP%
        armorMAXTPP += (armorMAXTPPTagVal != -1) ? armorMAXTPPTagVal : 0
      end
    end
    
    # go through the list of the battler's states and add MAXTP% scores
    (user.states).each do |state|
      stateID = state.id # get state id
      stateData = $data_states[stateID] # get state data
      stateMAXTPPTagVal = stateData.tplmp_maxTPPercentChangeVal # get state MAXTP% tag val (-1 -> no tag)
      # add state MAXTP% to total state MAXTP%
      stateMAXTPP += (stateMAXTPPTagVal != -1) ? stateMAXTPPTagVal : 0
    end
    
    # for enemy battlers (battler not actor), check notetags for enemy
    if (!user.tplmp_battlerIsActor?)
      enemyID = user.enemy_id # get enemyID
      enemyData = $data_enemies[enemyID] # get enemy data
      enemyMAXTPPTagVal = enemyData.tplmp_maxTPPercentChangeVal # get enemy MAXTP% tag val (-1 -> no tag)
      # get enemy MAXTP%
      enemyMAXTPP = (enemyMAXTPPTagVal != -1) ? enemyMAXTPPTagVal : 0
    end
    
    # Get the % amount to change the battler's maxTPMultiplier by
    # May end up as a positive or a negative number
    maxTPPChangePercent = classMAXTPP + weaponMAXTPP + armorMAXTPP + stateMAXTPP + enemyMAXTPP
    
    
    # if maxTPPChangePercent is less than -100%, set it to 100%
    # (at maxTPPChangePercent of -100%, max tp is already 0)
    if (maxTPPChangePercent < -100)
      maxTPPChangePercent = -100
    end
    
    # return result maxTPPChangePercent
    return maxTPPChangePercent
  end
  
  #--------------------------------------------------------------------------
  # * New method used to calculate the TPCSTR value. Returns the sum of all
  # * the battler's TPCSTR notetag values from the following database pages:
  # * Class, Weapons, Armor, States
  #--------------------------------------------------------------------------
  def calcBattlerTPCostRate
    # get the user (which is just self)
    user = self
    
    # general note: ternary operators are used to change TPCSTR values
    # to be 0 when TPCSTR notetags are not present
    # (tplmp_TPCostRate return val of -1 indicated no TPCSTR notetag found)
    
    # Start all TPCSTR sections as 0
    totalActorTPCSTR = 0
    enemyTPCSTR = 0
    stateTPCSTR = 0
    
    # if the battler is an actor, check the actor/class/weapon/armor notetags
    if (user.kind_of?(Game_Actor))
      actorID = user.id
      actorData = $data_actors[actorID] # get actor data
      actorTPCSTRTagVal = actorData.tplmp_TPCostRate # get actor TPCSTR tag val (-1 -> no tag)
      # get actor TPCSTR
      actorTPCSTR = (actorTPCSTRTagVal != -1) ? actorTPCSTRTagVal : 0
      
      actorClassID = user.class_id # get actor's classID
      classData = $data_classes[actorClassID] # get actor's class data
      classTPCSTRTagVal = classData.tplmp_TPCostRate # get actor's class TPCSTR tag val (-1 -> no tag)
      # get actor's class TPCSTR
      classTPCSTR = (classTPCSTRTagVal != -1) ? classTPCSTRTagVal : 0
      
      weaponTPCSTR = 0 # start weapon TPCSTR at 0
      actorWeapons = user.weapons # get list of battler's weapons
      # add up all the TPCSTR scores in the actor's weapons list
      actorWeapons.each do |weapon|
        weaponID = weapon.id # get weaponID
        weaponData = $data_weapons[weaponID] # get weapon data
        weaponTPCSTRTagVal = weaponData.tplmp_TPCostRate # get weapon TPCSTR tag val (-1 -> no tag)
        # add weapon TPCSTR to total weapon TPCSTR
        weaponTPCSTR += (weaponTPCSTRTagVal != -1) ? weaponTPCSTRTagVal : 0
      end
      
      armorTPCSTR = 0 # start armor TPCSTR at 0
      actorArmors = user.armors # get list of battler's armors
      # add up all the TPCSTR scores in the actor's armor list
      actorArmors.each do |armor|
        armorID = armor.id # get armorID
        armorData = $data_armors[armorID] # get armor data
        armorTPCSTRTagVal = armorData.tplmp_TPCostRate # get armor TPCSTR tag val (-1 -> no tag)
        # add weapon TPCSTR to total weapon TPCSTR
        armorTPCSTR += (armorTPCSTRTagVal != -1) ? armorTPCSTRTagVal : 0
      end
      
      # get total actor TPCSTR
      totalActorTPCSTR = actorTPCSTR + classTPCSTR + weaponTPCSTR + armorTPCSTR
    end
    
    # for enemy battlers (battler not actor), check notetags for enemy
    if (!user.tplmp_battlerIsActor?)
      enemyID = user.enemy_id # get enemyID
      enemyData = $data_enemies[enemyID] # get enemy data
      enemyTPCSTRTagVal = enemyData.tplmp_TPCostRate # get enemy TPCSTR tag val (-1 -> no tag)
      # get enemy TPCSTR
      enemyTPCSTR = (enemyTPCSTRTagVal != -1) ? enemyTPCSTRTagVal : 0
    end
    
    # go through the list of the battler's states and add MAXTP% scores
    (user.states).each do |state|
      stateID = state.id # get state id
      stateData = $data_states[stateID] # get state data
      stateTPCSTRTagVal = stateData.tplmp_TPCostRate # get state TPCSTR tag val (-1 -> no tag)
      # add state TPCSTR to total state TPCSTR
      stateTPCSTR += (stateTPCSTRTagVal != -1) ? stateTPCSTRTagVal : 0
    end
    
    # Get the % amount to change the actor's tpCostRateMultiplier by
    # May end up as a positive or a negative number
    tpCostRateChange = totalActorTPCSTR + enemyTPCSTR + stateTPCSTR
    
    # calculate tpcstr multiplier (+100 because 100 * tpCostRate is the default TP cost rate)
    tpCostRateMultiplier = 100 + tpCostRateChange
    
    
    # if tpCostRateMultiplier is negative, set the tpCostRateMultiplier to 0
    # (at tpCostRateMultiplier of 0, all skills are already free)
    if (tpCostRateMultiplier < 0)
      tpCostRateMultiplier = 0
    end
    
    # return result tpCostRateMultiplier
    return tpCostRateMultiplier
  end
  
  #--------------------------------------------------------------------------
  # * New method used to calculate the percentage to change the item/skill's
  # * target TP by. Checks skill notetags if the parameter is a skill, and
  # * checks item notetags if the parameter is an item.
  #--------------------------------------------------------------------------
  def calcSkillItemTargetTPChangePercent(skillOrItem)
    # general note: ternary operators are used to change TTPCHANGE% values
    # to be 0 when TTPCHANGE% notetags are not present
    # (tplmp_getTargetPercentTPChange return val of -1 indicated no TTPCHANGE% notetag found)
    
    # Start all TTPCHANGE% sections as 0
    skillTTPCHANGEP = 0
    itemTTPCHANGEP = 0
    
    # check if the passed parameter is a skill or item, and get the
    # corresponding notetag value
    if (skillOrItem.is_a?(RPG::Skill))
      skillUsed = skillOrItem # the skillOrItem is a skill
      skillID = skillUsed.id # get skillID
      skillData = $data_skills[skillID] # get skill data
      # get skill TTPCHANGE% tag val (-1 -> no tag)
      skillTTPCHANGEPTagVal = skillData.tplmp_getTargetPercentTPChange
      # get skill TTPCHANGE%
      skillTTPCHANGEP = (skillTTPCHANGEPTagVal != -1) ? skillTTPCHANGEPTagVal : 0
    end
    
    if (skillOrItem.is_a?(RPG::Item))
      itemUsed = skillOrItem # the skillOrItem is an item
      itemID = itemUsed.id # get itemID
      itemData = $data_items[itemID] # get item data
      # get item TTPCHANGE% tag val (-1 -> no tag)
      itemTTPCHANGEPTagVal = itemData.tplmp_getTargetPercentTPChange
      # get item TTPCHANGE%
      itemTTPCHANGEP = (itemTTPCHANGEPTagVal != -1) ? itemTTPCHANGEPTagVal : 0
    end
    
    # Get the % of the target's max tp to change their tp by
    targetTPChangePercent = skillTTPCHANGEP + itemTTPCHANGEP
    
    # return result targetTPChangePercent
    return targetTPChangePercent
  end
  
  #--------------------------------------------------------------------------
  # * New method used to calculate the flat number to change the item/skill's
  # * target TP by. Checks skill notetags if the parameter is a skill, and
  # * checks item notetags if the parameter is an item.
  #--------------------------------------------------------------------------
  def calcSkillItemTargetTPChangeNum(skillOrItem)
    # general note: ternary operators are used to change TTPCHANGE values
    # to be 0 when TTPCHANGE notetags are not present
    # (tplmp_getTargetNumTPChange return val of -1 indicated no TTPCHANGE notetag found)
    
    # Start all TTPCHANGE sections as 0
    skillTTPCHANGEN = 0
    itemTTPCHANGEN = 0
    
    # check if the passed parameter is a skill or item, and get the
    # corresponding notetag value
    if (skillOrItem.is_a?(RPG::Skill))
      skillUsed = skillOrItem # the skillOrItem is a skill
      skillID = skillUsed.id # get skillID
      skillData = $data_skills[skillID] # get skill data
      # get skill TTPCHANGE tag val (-1 -> no tag)
      skillTTPCHANGENTagVal = skillData.tplmp_getTargetNumTPChange
      # get skill TTPCHANGE
      skillTTPCHANGEN = (skillTTPCHANGENTagVal != -1) ? skillTTPCHANGENTagVal : 0
    end
    
    if (skillOrItem.is_a?(RPG::Item))
      itemUsed = skillOrItem # the skillOrItem is an item
      itemID = itemUsed.id # get itemID
      itemData = $data_items[itemID] # get item data
      # get item TTPCHANGE tag val (-1 -> no tag)
      itemTTPCHANGENTagVal = itemData.tplmp_getTargetNumTPChange
      # get item TTPCHANGE
      itemTTPCHANGEN = (itemTTPCHANGENTagVal != -1) ? itemTTPCHANGENTagVal : 0
    end
    
    # Get the number to change the target's tp by
    targetTPChangeNumber = skillTTPCHANGEN + itemTTPCHANGEN
    
    # return result targetTPChangeNumber
    return targetTPChangeNumber
  end
  
  #--------------------------------------------------------------------------
  # * New method used to calculate the percentage to change the item/skill's
  # * user TP by. Checks skill notetags if the parameter is a skill, and
  # * checks item notetags if the parameter is an item.
  #--------------------------------------------------------------------------
  def calcSkillItemUserTPChangePercent(skillOrItem)
    # general note: ternary operators are used to change UTPCHANGE% values
    # to be 0 when UTPCHANGE% notetags are not present
    # (tplmp_getUserPercentTPChange return val of -1 indicated no UTPCHANGE% notetag found)
    
    # Start all UTPCHANGE% sections as 0
    skillUTPCHANGEP = 0
    itemUTPCHANGEP = 0
    
    # check if the passed parameter is a skill or item, and get the
    # corresponding notetag value
    if (skillOrItem.is_a?(RPG::Skill))
      skillUsed = skillOrItem # the skillOrItem is a skill
      skillID = skillUsed.id # get skillID
      skillData = $data_skills[skillID] # get skill data
      # get skill UTPCHANGE% tag val (-1 -> no tag)
      skillUTPCHANGEPTagVal = skillData.tplmp_getUserPercentTPChange
      # get skill UTPCHANGE%
      skillUTPCHANGEP = (skillUTPCHANGEPTagVal != -1) ? skillUTPCHANGEPTagVal : 0
    end
    
    if (skillOrItem.is_a?(RPG::Item))
      itemUsed = skillOrItem # the skillOrItem is an item
      itemID = itemUsed.id # get itemID
      itemData = $data_items[itemID] # get item data
      # get item UTPCHANGE% tag val (-1 -> no tag)
      itemUTPCHANGEPTagVal = itemData.tplmp_getUserPercentTPChange
      # get item UTPCHANGE%
      itemUTPCHANGEP = (itemUTPCHANGEPTagVal != -1) ? itemUTPCHANGEPTagVal : 0
    end
    
    # Get the % of the user's max tp to change their tp by
    userTPChangePercent = skillUTPCHANGEP + itemUTPCHANGEP
    
    # return result userTPChangePercent
    return userTPChangePercent
  end
  
  #--------------------------------------------------------------------------
  # * New method used to calculate the flat number to change the item/skill's
  # * user TP by. Checks skill notetags if the parameter is a skill, and
  # * checks item notetags if the parameter is an item.
  #--------------------------------------------------------------------------
  def calcSkillItemUserTPChangeNum(skillOrItem)
    # general note: ternary operators are used to change UTPCHANGE values
    # to be 0 when UTPCHANGE notetags are not present
    # (tplmp_getUserNumTPChange return val of -1 indicated no UTPCHANGE notetag found)
    
    # Start all UTPCHANGE sections as 0
    skillUTPCHANGEN = 0
    itemUTPCHANGEN = 0
    
    # check if the passed parameter is a skill or item, and get the
    # corresponding notetag value
    if (skillOrItem.is_a?(RPG::Skill))
      skillUsed = skillOrItem # the skillOrItem is a skill
      skillID = skillUsed.id # get skillID
      skillData = $data_skills[skillID] # get skill data
      # get skill UTPCHANGE tag val (-1 -> no tag)
      skillUTPCHANGENTagVal = skillData.tplmp_getUserNumTPChange
      # get skill UTPCHANGE
      skillUTPCHANGEN = (skillUTPCHANGENTagVal != -1) ? skillUTPCHANGENTagVal : 0
    end
    
    if (skillOrItem.is_a?(RPG::Item))
      itemUsed = skillOrItem # the skillOrItem is an item
      itemID = itemUsed.id # get itemID
      itemData = $data_items[itemID] # get item data
      # get item UTPCHANGE tag val (-1 -> no tag)
      itemUTPCHANGENTagVal = itemData.tplmp_getUserNumTPChange
      # get item UTPCHANGE
      itemUTPCHANGEN = (itemUTPCHANGENTagVal != -1) ? itemUTPCHANGENTagVal : 0
    end
    
    # Get the number to change the user's tp by
    userTPChangeNumber = skillUTPCHANGEN + itemUTPCHANGEN
    
    # return result targetTPChangeNumber
    return userTPChangeNumber
  end
  
  #--------------------------------------------------------------------------
  # * New helper method used to get the level of a Battler if they are an actor.
  # * Returns the level if actor, else, returns 0.
  #--------------------------------------------------------------------------
  def getBattlerLevel
    # return battler level if battler is an actor
    if (self.kind_of?(Game_Actor))
      return self.level
    end
    # otherwise, return 0 (enemy tp just set to 100 if a formula would
    # normally be used)
    return 0
  end
  
end


class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Aliased draw_actor_simple_status() to draw the tp bar in the menu
  # * if the TPLMP_DISPLAY_TP_IN_MENU setting is on.
  #--------------------------------------------------------------------------
  alias before_tplmp_draw_simple_status draw_actor_simple_status
  def draw_actor_simple_status(actor, x, y)    
    # call original method (display name, level, hp, mp, etc.)
    before_tplmp_draw_simple_status(actor, x, y)
    
    # if drawing TP bar in menu is on, AND max TP is greater than 0,
    # draw the TP bar
    #
    # feel free to tweak the lineHeightMultiplier to get it to display
    # exactly where you want it
    lineHeightMultiplier = 3
    # tpBarWidth 124 by default
    tpBarWidth = 124
    
    # lineHeightMultiplier of 2.5 looks more appropriate for the Yanfly menu engine
    if ($imported["YEA-AceMenuEngine"])
      lineHeightMultiplier = 2.5
      tpBarWidth = contents.width - x - 124
    end
    
    # check if the window is a window where the TP bar doesn't display well 
    windowTPCaution = (self.kind_of?(Window_SkillStatus))
    # if the window is not one of the bad TP display windows, or the
    # yanfly menu engine is being used, the TP bar can display
    tpBarCanDisplay = (!windowTPCaution || $imported["YEA-AceMenuEngine"])
    
    # if the DISPLAY_TP_IN_MENU setting is on and max TP is above zero, and
    # the scene is not the actors stats screen (TP bar doesn't really fit there),
    # then the tp bar can be displayed as part of draw_actor_simple_status
    if (tpBarCanDisplay && TPLMP::TPLMP_DISPLAY_TP_IN_MENU && !actor.force_disable_draw_tp? && (actor.max_tp > 0))
      draw_actor_tp(actor, x + 120, y + (line_height * lineHeightMultiplier).to_i, tpBarWidth)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Overriden draw_actor_tp() method used to draw tp so that it displays
  # * a number out of the maximum tp (X / X) instead of just the singular tp
  # * that it shows normally.
  # * Note: it hurts not to a put a return statement in here instead of
  # * repeating a bunch of code, but it makes it more compatible with
  # * possible draw_actor_tp aliases.
  #--------------------------------------------------------------------------
  def draw_actor_tp(actor, x, y, width = 124)
    # if the Liam's mysteryHP script is imported, and the mystery TP setting is
    # on from that script, then the tp bar drawn will be of the mysteryHP kind.
    # Otherwise, standard TP drawing is done
    if ($imported["Liam-MysteryHP"])      
      # if all mysteryHP checks for actor and the INCLUDE_TP setting is on,
      # use the mystery TP bar lines, otherwise, use the original method's lines
      if (allMysteryHPChecksMet?(actor) && MYSTHP::MYSTERY_HP_INCLUDE_TP)
        # get mystery bar colors
        mystTPGaugeColor1Compat = MYSTHP::MYSTERY_HP_COLOR_1
        mystTPGaugeColor2Compat = MYSTHP::MYSTERY_HP_COLOR_2
        # gauges are filled with a rate of 1.0, so use that
        mystTPGaugeAmntCompat = 1.0
        # what to replace the TP number with
        # feel free to change this
        mystTPNumReplaceCompat = "???"
        
        # draw the tp gauge (the bar)
        draw_gauge(x, y, width, mystTPGaugeAmntCompat, mystTPGaugeColor1Compat, mystTPGaugeColor2Compat)
        # change text color to standard system color
        change_color(system_color)
        # draw the text for the TP vocab as set in the database
        draw_text(x, y, 30, line_height, Vocab::tp_a)
        draw_current_and_max_values(x, y, width, (mystTPNumReplaceCompat + " "), mystTPNumReplaceCompat,
          tp_color(actor), normal_color)
      else
        # normal method lines here
        # draw the tp gauge (the bar)
        draw_gauge(x, y, width, actor.tp_rate, tp_gauge_color1, tp_gauge_color2)
        # change text color to standard system color
        change_color(system_color)
        # draw the text for the TP vocab as set in the database
        draw_text(x, y, 30, line_height, Vocab::tp_a)
        draw_current_and_max_values(x, y, width, actor.tp, actor.max_tp,
          tp_color(actor), normal_color)
      end
    else
      # normal method lines here
      # draw the tp gauge (the bar)
      draw_gauge(x, y, width, actor.tp_rate, tp_gauge_color1, tp_gauge_color2)
      # change text color to standard system color
      change_color(system_color)
      # draw the text for the TP vocab as set in the database
      draw_text(x, y, 30, line_height, Vocab::tp_a)
      draw_current_and_max_values(x, y, width, actor.tp, actor.max_tp,
        tp_color(actor), normal_color)
    end
  end
  
end


class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * New method used to check if the tp bar should be forced to display
  # * for the actor according to the script's settings.
  #--------------------------------------------------------------------------
  def force_draw_tp?
    # return false if the tp bar is forcefully disabled
    return false if (force_disable_draw_tp?)
    
    # return false if max_tp is 0
    return false if (max_tp == 0)
    
    # return true if the tp bars are always forced to display
    return true if (TPLMP::TPLMP_FORCE_TP_BAR_DISPLAY)
    
    # return true if the bar is forced to display for the specific actor
    return true if (TPLMP::TPLMP_FORCE_TP_BAR_DISPLAY_ACTORS.include?(self.id))
    
    # return false if no criteria for forcing tp bar drawing were met
    return false
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if the tp bar should be forced to not display
  # * for the actor according to the script's settings.
  #--------------------------------------------------------------------------
  def force_disable_draw_tp?
    # return true if max_tp is 0
    return true if (max_tp == 0)
    
    # return true if the bar is forced to never display for the specific actor
    return (TPLMP::TPLMP_FORCE_TP_BAR_NEVER_DISPLAY_ACTORS.include?(self.id))
  end
end


class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # * Aliased draw_gauge_area() used to force the tp bar to draw, or to
  # * not draw.
  #--------------------------------------------------------------------------
  alias tplmp_after_draw_gauge_force_show draw_gauge_area
  def draw_gauge_area(rect, actor)    
    # if forcing the tp bar to display for the actor, then draw
    # the gauge area with tp.
    # if preventing the tp bar from displaying for the actor, then draw
    # the gauge area without tp.
    # if doing neither of those two things, then let the method proceed normally.
    if (actor.force_draw_tp?)
      draw_gauge_area_with_tp(rect, actor)
    elsif (actor.force_disable_draw_tp?)
      draw_gauge_area_without_tp(rect, actor)
    else
      # Call original method
      tplmp_after_draw_gauge_force_show(rect, actor)
    end
  end
end


class Game_ActionResult
  # New variable used to track tp drain amount
  attr_accessor :tplmp_tp_drain
  
  #--------------------------------------------------------------------------
  # * Aliased clear_damage_values() method used to reset tp_drain to 0
  # * when the rest of the damage values are reset
  #--------------------------------------------------------------------------
  alias tplmp_before_clear_tp_drain_damage_value clear_damage_values
  def clear_damage_values
    # Call original method
    tplmp_before_clear_tp_drain_damage_value
    
    @tplmp_tp_drain = 0 # reset tp drain to 0
  end
  
  #--------------------------------------------------------------------------
  # * Aliased make_damage() method used to setup the new tp drain damage.
  #--------------------------------------------------------------------------
  alias tplmp_after_tp_drain_set make_damage
  def make_damage(value, item)
    # set tp_damage to value if dealing with tp
    @tp_damage = value if item.damage.to_tp?
    
    # calculate the actual amount of tp that will be drained
    @tp_damage = [@battler.tp, @tp_damage].min
    
    # save the current tp_damage value as the amount to be drained
    # if the current damage formula is a draining one
    @tplmp_tp_drain = @tp_damage if item.damage.drain?
    
    # Call original method
    tplmp_after_tp_drain_set(value, item)
    
    # if tp drain is not equal to 0, or tp_damage is not equal to 0 and the
    # item is a tp recovery item, then mark the move as a success
    @success = true if (@tplmp_tp_drain != 0 || (item.damage.recover? && item.damage.to_tp? && @tp_damage != 0))
  end
  
  #--------------------------------------------------------------------------
  # * Aliased tp_damage_text() used to return tp drain text if there
  # * is tp drain damage.
  #--------------------------------------------------------------------------
  alias tplmp_before_tp_drain_text_setup tp_damage_text
  def tp_damage_text
    # Call original method (get previous result)
    newResult = tplmp_before_tp_drain_text_setup
    
    # if tp_drain is greater than 0, replace the text with tp drain text,
    if (@tplmp_tp_drain > 0)
      # setup the text formatting
      fmt = @battler.actor? ? Vocab::ActorDrain : Vocab::EnemyDrain
      # overwrite newResult with the tp drain text
      newResult = sprintf(fmt, @battler.name, Vocab::tp, @tplmp_tp_drain)
    end
    
    # return new result implicitly
    newResult
  end
end


class RPG::BaseItem
  #--------------------------------------------------------------------------
  # * New method used to read in MAXTP% values from MAXTP% notetags
  # * format: <MAXTP% num>
  # * All MAXTP% nums from the battler's weapons, armor, etc. will be added
  # * up into one number, which will then be multiplied with the standard
  # * actor's max tp value. If no MAXTP% notetag is found, returns -1.
  #--------------------------------------------------------------------------
  def tplmp_maxTPPercentChangeVal
    # check if tplmp_maxTPChangeVal has been checked yet, if not, get it
    if @tplmp_maxTPPercentChangeVal.nil?
      # checks for MAXTP% notetag
      if (@note =~ /<MAXTP% (.*)>/i)
        # gets the value from notetag ($1 is global var used for regex),
        # and ensures it is integer
        @tplmp_maxTPPercentChangeVal = $1.to_i
      else
        # -1 returned as default val if no notetag present
        @tplmp_maxTPPercentChangeVal = -1
      end
    end
    # tplmp_maxTPPercentChangeVal implicit return
    @tplmp_maxTPPercentChangeVal
  end
  
  #--------------------------------------------------------------------------
  # * New method used to read in MAXTP values from MAXTP notetags
  # * format: <MAXTP num>
  # * All MAXTP nums from the battler's weapons, armor, etc. will be added
  # * up into one number, which will then be added to the standard
  # * actor's max tp value. If no MAXTP notetag is found, returns -1.
  #--------------------------------------------------------------------------
  def tplmp_maxTPNumChangeVal
    # check if tplmp_maxTPChangeVal has been checked yet, if not, get it
    if @tplmp_tplmp_maxTPNumChangeVal.nil?
      # checks for MAXTP notetag
      if (@note =~ /<MAXTP (.*)>/i)
        # gets the value from notetag ($1 is global var used for regex),
        # and ensures it is integer
        @tplmp_maxTPNumChangeVal = $1.to_i
      else
        # -1 returned as default val if no notetag present
        @tplmp_maxTPNumChangeVal = -1
      end
    end
    # tplmp_maxTPNumChangeVal implicit return
    @tplmp_maxTPNumChangeVal
  end
  
  #--------------------------------------------------------------------------
  # * New method used to read in TPCSTR values from TPCSTR notetags
  # * format: <TPCSTR num>
  # * All TPCSTR nums from the battler's weapons, armor, etc. will be added
  # * up into one number, which will then be multiplied with the standard
  # * actor's tp cost. If no MAXTP% notetag is found, returns -1.
  #--------------------------------------------------------------------------
  def tplmp_TPCostRate
    # check if tplmp_TPCostRate has been checked yet, if not, get it
    if @tplmp_TPCostRate.nil?
      # checks for TPCSTR notetag
      if (@note =~ /<TPCSTR (.*)>/i)
        # gets the value from notetag ($1 is global var used for regex),
        # and ensures it is integer
        @tplmp_TPCostRate = $1.to_i
      else
        # -1 returned as default val if no notetag present
        @tplmp_TPCostRate = -1
      end
    end
    # tplmp_TPCostRate implicit return
    @tplmp_TPCostRate
  end

end


class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # * New method used to read in TTPCHANGE% values from TTPCHANGE% notetags
  # * format: <T-TPCHANGE% num>
  # * The change number will eventually be multiplied with max_tp and then
  # * added with any other tp gain effect modifiers.
  # * If no TTPCHANGE% notetag is found, returns -1.
  #--------------------------------------------------------------------------
  def tplmp_getTargetPercentTPChange
    # check if tplmp_getTargetPercentTPChange has been checked yet, if not, get it
    if @tplmp_getTargetPercentTPChange.nil?
      # checks for TTPCHANGE% notetag
      if (@note =~ /<T-TPCHANGE% (.*)>/i)
        # gets the value from notetag ($1 is global var used for regex),
        # and ensures it is integer
        @tplmp_getTargetPercentTPChange = $1.to_i
      else
        # -1 returned as default val if no notetag present
        @tplmp_getTargetPercentTPChange = -1
      end
    end
    # tplmp_getTargetPercentTPChange implicit return
    @tplmp_getTargetPercentTPChange
  end
  
  #--------------------------------------------------------------------------
  # * New method used to read in TTPCHANGE values from TTPCHANGE notetags
  # * format: <T-TPCHANGE num>
  # * The change number will be added with any other tp gain effect modifiers.
  # * If no TTPCHANGE notetag is found, returns -1.
  #--------------------------------------------------------------------------
  def tplmp_getTargetNumTPChange
    # check if tplmp_getTargetNumTPChange has been checked yet, if not, get it
    if @tplmp_getTargetNumTPChange.nil?
      # checks for TTPCHANGE notetag
      if (@note =~ /<T-TPCHANGE (.*)>/i)
        # gets the value from notetag ($1 is global var used for regex),
        # and ensures it is integer
        @tplmp_getTargetNumTPChange = $1.to_i
      else
        # -1 returned as default val if no notetag present
        @tplmp_getTargetNumTPChange = -1
      end
    end
    # tplmp_getTargetNumTPChange implicit return
    @tplmp_getTargetNumTPChange
  end
  
  #--------------------------------------------------------------------------
  # * New method used to read in UTPCHANGE% values from UTPCHANGE% notetags
  # * format: <U-TPCHANGE% num>
  # * The change number will eventually be multiplied with max_tp and then
  # * added with any other user tp gain modifiers.
  # * If no UTPCHANGE% notetag is found, returns -1.
  #--------------------------------------------------------------------------
  def tplmp_getUserPercentTPChange
    # check if tplmp_getUserPercentTPChange has been checked yet, if not, get it
    if @tplmp_getUserPercentTPChange.nil?
      # checks for UTPCHANGE% notetag
      if (@note =~ /<U-TPCHANGE% (.*)>/i)
        # gets the value from notetag ($1 is global var used for regex),
        # and ensures it is integer
        @tplmp_getUserPercentTPChange = $1.to_i
      else
        # -1 returned as default val if no notetag present
        @tplmp_getUserPercentTPChange = -1
      end
    end
    # tplmp_getUserPercentTPChange implicit return
    @tplmp_getUserPercentTPChange
  end
  
  #--------------------------------------------------------------------------
  # * New method used to read in UTPCHANGE values from UTPCHANGE notetags
  # * format: <U-TPCHANGE num>
  # * The change number will be added with any other user tp gain modifiers.
  # * If no UTPCHANGE notetag is found, returns -1.
  #--------------------------------------------------------------------------
  def tplmp_getUserNumTPChange
    # check if tplmp_getUserNumTPChange has been checked yet, if not, get it
    if @tplmp_getUserNumTPChange.nil?
      # checks for UTPCHANGE notetag
      if (@note =~ /<U-TPCHANGE (.*)>/i)
        # gets the value from notetag ($1 is global var used for regex),
        # and ensures it is integer
        @tplmp_getUserNumTPChange = $1.to_i
      else
        # -1 returned as default val if no notetag present
        @tplmp_getUserNumTPChange = -1
      end
    end
    # tplmp_getUserNumTPChange implicit return
    @tplmp_getUserNumTPChange
  end
  
end


class RPG::Skill < RPG::UsableItem
  #--------------------------------------------------------------------------
  # * New method used to read in EXTPCOST values from EXTPCOST notetags
  # * format: <EXTPCOST num>
  # * The EXTPCOST num from the battler's used skill will be obtained and returned,
  # * and later added to the base engine database TP cost.
  # * If no MAXTP% notetag is found, returns -1.
  #--------------------------------------------------------------------------
  def tplmp_getExTPCost
    # check if tplmp_getExTPCost has been checked yet, if not, get it
    if @tplmp_getExTPCost.nil?
      # checks for EXTPCOST notetag
      if (@note =~ /<EXTPCOST (.*)>/i)
        # gets the value from notetag ($1 is global var used for regex),
        # and ensures it is integer
        @tplmp_getExTPCost = $1.to_i
      else
        # -1 returned as default val if no notetag present
        @tplmp_getExTPCost = -1
      end
    end
    # tplmp_getExTPCost implicit return
    @tplmp_getExTPCost
  end
end


class RPG::UsableItem::Damage  
  #--------------------------------------------------------------------------
  # * New method used to properly set the tp damage/recovery/draining
  # * damage formula type number using the new damage formula notetags.
  # * format:
  # * <TPDAM> -> TP Damage Formula
  # * <TPREC> -> TP Recovery Formula
  # * <RPDRAIN> -> TP Draining Formula
  #--------------------------------------------------------------------------
  def tplmp_update_damage_formula_type
    # get damage formula string
    damageFormula = @formula
    
    # start with formulaNotetag as "none"
    formulaNotetag = "none"
    
    # check for tp damage type formula notetags and save which one it is
    # if any notetags apply
    if (damageFormula =~ /<TPDAM>/i)
      formulaNotetag = "tpdam"
    elsif (damageFormula =~ /<TPREC>/i)
      formulaNotetag = "tprec"
    elsif (damageFormula =~ /<TPDRAIN>/i)
      formulaNotetag = "tpdrain"
    end
    
    # case statement, set appropriate damage formula type depending on
    # the formula notetag
    case formulaNotetag
    when "tpdam"
      # set damage formula type to tp damage
      @type = TPLMP::TP_DAMAGE_TYPE_NUM
    when "tprec"
      # set damage formula type to tp recovery
      @type = TPLMP::TP_RECOVER_TYPE_NUM
    when "tpdrain"
      # set damage formula type to tp drain
      @type = TPLMP::TP_DRAIN_TYPE_NUM
    end
    
    # update damage formula to remove the notetag and strip whitespace
    @formula = damageFormula.gsub(/<TP.*>/i, "")
    @formula = @formula.strip
  end
  
  #--------------------------------------------------------------------------
  # * New method used for checking if the damage formula is meant to do
  # * something (damage, recover, draining, etc.) with tp.
  #--------------------------------------------------------------------------
  def to_tp?
    [TPLMP::TP_DAMAGE_TYPE_NUM, TPLMP::TP_RECOVER_TYPE_NUM, TPLMP::TP_DRAIN_TYPE_NUM].include?(@type)
  end
  
  #--------------------------------------------------------------------------
  # * Aliased recover?() method for RPG::UsableItem::Damage used to
  # * include tp recovery when checking if a damage formula type is a
  # * recovery one.
  #--------------------------------------------------------------------------
  alias tplmp_before_tp_damage_type_recover_check recover?
  def recover?
    # only line of original method -> [3,4].include?(@type)
    # Call original method (get previous result)
    finalResult = tplmp_before_tp_damage_type_recover_check

    # mark as recovery if tp recovery is the type
    finalResult = (finalResult || (@type == TPLMP::TP_RECOVER_TYPE_NUM))
    
    # return final result implicitly
    finalResult
  end
  
  #--------------------------------------------------------------------------
  # * Aliased drain?() method for RPG::UsableItem::Damage used to
  # * include tp draining when checking if a damage formula type is a
  # * draining one.
  #--------------------------------------------------------------------------
  alias tplmp_before_tp_damage_type_drain_check drain?
  def drain?
    # only line of original method -> [5,6].include?(@type)
    # Call original method (get previous result)
    finalResult = tplmp_before_tp_damage_type_drain_check
    
    # mark as drain if tp drain is the type
    finalResult = (finalResult || (@type == TPLMP::TP_DRAIN_TYPE_NUM))
  end

end


class Game_Action
  #--------------------------------------------------------------------------
  # * Aliased evaluate_item() method used to prepare the tp damage and tp draining
  # * damage formulas.
  #--------------------------------------------------------------------------
  alias tplmp_after_tp_damage_formula_setup_eval evaluate_item
  def evaluate_item
    # update the item's damage formula type
    item.damage.tplmp_update_damage_formula_type
    
    # Call original method
    tplmp_after_tp_damage_formula_setup_eval
  end
end


class Scene_ItemBase < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Aliased use_item() for Scene_ItemBase used to prepare the tp damage
  # * and tp draining damage formulas.
  #--------------------------------------------------------------------------
  alias tplmp_after_tp_damage_formula_setup_item_use_item use_item
  def use_item
    # update the item's damage formula type
    item.damage.tplmp_update_damage_formula_type
    
    # Call original method
    tplmp_after_tp_damage_formula_setup_item_use_item
  end
end


class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Aliased use_item() for Scene_Battle used to prepare the tp damage
  # * and tp draining damage formulas.
  #--------------------------------------------------------------------------
  alias tplmp_after_tp_damage_formula_setup_battle_use_item use_item
  def use_item
    # get item
    item = @subject.current_action.item
    
    # if item exists, set it up properly
    if (item)
      # update the item's damage formula type
      item.damage.tplmp_update_damage_formula_type
    end
    
    # Call original method
    tplmp_after_tp_damage_formula_setup_battle_use_item
  end
end

  
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * New method made to change the actor(s) tp whose actorID(s) is/are passed
  # * by the tpChange amount. The amount of actorID parameters can vary.
  #--------------------------------------------------------------------------
  def tplmp_change_actor_tp(tpChange, *idList)
    # change tp of all designated actors using the actor idList
    idList.each do |idNum|
      $game_actors[actorID].tp += tpChange
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method made to change the party's tp by the tpChange amount.
  # * The amount of actorID parameters can vary.
  #--------------------------------------------------------------------------
  def tplmp_change_party_tp(tpChange)
    # change tp of all actors in party
    $game_party.members.each do |actor|
      actor.tp += tpChange
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method made to set the actor(s) tp whose actorID(s) is/are passed
  # * to the newTP amount. The amount of actorID parameters can vary.
  #--------------------------------------------------------------------------
  def tplmp_set_actor_tp(newTP, *idList)
    # set tp of all designated actors using the actor idList
    idList.each do |idNum|
      actor.tp = newTP
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method made to set the party's tp to the newTP amount.
  # * The amount of actorID parameters can vary.
  #--------------------------------------------------------------------------
  def tplmp_set_party_tp(newTP)
    # set tp of all actors in party
    $game_party.members.each do |actor|
      actor.tp = newTP
    end
  end

end


# YANFLY BATTLE ENGINE COMPATIBILITY METHODS PAST THIS POINT ------------------
# if-statement contains Yanfly Battle Engine specifc methods
if ($imported["YEA-BattleEngine"])
  class Game_ActionResult
    #--------------------------------------------------------------------------
    # * Yanfly Battle Engine restore_damage() aliased to not do restore_damage
    # * in its item_user_effect if the tplmp_doNotDoPopupsYet is set to true.
    # * Also now also restores the tp drain value as well.
    #--------------------------------------------------------------------------
    alias tplmp_ybe_restore_damage_compatibility_old_method restore_damage
    def restore_damage
      # if $tplmp_doNotDoPopupsYet flag is nil, then set it to false
      if ($tplmp_doNotDoPopupsYet == nil)
        $tplmp_doNotDoPopupsYet = false
      end
      
      # if $tplmp_doNotDoPopupsYet flag is true, do not call the original method
      if (!($tplmp_doNotDoPopupsYet == true))
        @tplmp_tp_drain = @stored_tplmp_tp_drain # restore tp drain amount
        
        # otherwise, execute the original method
        tplmp_ybe_restore_damage_compatibility_old_method
      end
    end
    
    #--------------------------------------------------------------------------
    # * Yanfly Battle Engine store_damage() aliased to include tp drain
    # * when clearing stored damage.
    #--------------------------------------------------------------------------
    alias tplmp_after_tp_drain_stored_damage_clear clear_stored_damage
    def clear_stored_damage
      @stored_tplmp_tp_drain = 0 # clear stored tp drain amount
      
      # Call original method
      tplmp_after_tp_drain_stored_damage_clear
    end
    
    #--------------------------------------------------------------------------
    # * Yanfly Battle Engine store_damage() aliased to include tp drain
    # * when storing damage.
    #--------------------------------------------------------------------------
    alias tplmp_after_tp_drain_store store_damage
    def store_damage
      @stored_tplmp_tp_drain += @tplmp_tp_drain # store tp drain amount
      
      # Call original method
      tplmp_after_tp_drain_store
    end
    
  end


  class Game_BattlerBase
    #--------------------------------------------------------------------------
    # * Yanfly Battle Engine make_damage_popups() aliased to not do
    # * the contents of the original make_damage_popups in its
    # * when going through item_effect_gain_tp(). Also sets up tp drain popups.
    #--------------------------------------------------------------------------
    alias tplmp_ybe_make_damage_popups_compatibility_old_method make_damage_popups
    def make_damage_popups(user)
      
      # if $tplmp_doNotDoPopupsYet flag is nil, then set it to false
      if ($tplmp_doNotDoPopupsYet == nil)
        $tplmp_doNotDoPopupsYet = false
      end
      
      # if $tplmp_doNotDoPopupsYet flag is true, do not call the original method
      if (!($tplmp_doNotDoPopupsYet == true))
        # set up tp drain popups if needed
        if (@result.tplmp_tp_drain != 0)
          text = YEA::BATTLE::POPUP_SETTINGS[:drained]
          rules = "DRAIN"
          user.create_popup(text, rules)
          setting = :tp_dmg  if @result.tplmp_tp_drain < 0
          setting = :tp_heal if @result.tplmp_tp_drain > 0
          rules = "TP_DMG"   if @result.tplmp_tp_drain < 0
          rules = "TP_HEAL"  if @result.tplmp_tp_drain > 0
          value = @result.tplmp_tp_drain.abs
          text = sprintf(YEA::BATTLE::POPUP_SETTINGS[setting], value.group)
          user.create_popup(text, rules)
        end
        
        # otherwise, execute the original method
        tplmp_ybe_make_damage_popups_compatibility_old_method(user)
      end
    end
  end

end

# if-statement contains a method shared by Yanfly Battle Engine
# and Yanfly Menu Engine
if ($imported["YEA-BattleEngine"] || $imported["YEA-AceMenuEngine"])
  class Game_Actor < Game_Battler
    #--------------------------------------------------------------------------
    # * Yanfly Battle Engine/Yanfly Menu Engine draw_tp? in Game_Actor used to be able to
    # * force the TP bar to display in battle.
    #--------------------------------------------------------------------------
    alias after_tplmp_special_draw_tp_checks draw_tp?
    def draw_tp?
      # return false if the tp bar is forced to not display
      return false if (force_disable_draw_tp?)
      
      # return true if the tp bar is forced to display
      return true if (force_draw_tp?)
      
      # Call original method
      after_tplmp_special_draw_tp_checks
    end
  end
end

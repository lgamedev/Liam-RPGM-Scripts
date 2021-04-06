# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-MPtoGuns"] = true
# END OF IMPORT SECTION

# ------------------- ! REQUIRES 'EXTRA SAVE DATA' SCRIPT ! -------------------
# Script:           MP->Guns Overhaul
# Author:           Liam
# Version:          1.1.4
# Description:
# This script turns the MP system into a guns and ammunition system. This system
# is meant for use with guns, but can also be used to represent ammo/aiming
# abilities for other kinds of weapons, like grenade launchers, bows, slingshots, etc.
# The MP bar represents the current ammo count out of the maximum for the gun.
# "Guns" have a name, a type, current ammo count, an ammo maximum,
# accepted ammo types, and sets of skills that are tied to the gun. Additionally,
# there is one new notetagged parameter, GHIT or Gun HITchance, which determines
# how accurate "magical" (meaning gun-based) attacks are, which works exactly
# like the HIT parameter does for physical attacks.
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
# Note 1: This script should probably be placed further down on the script list
# for compatibility reasons.
#
# Note 2: This script still allows "normal" MP skills not tied to guns
# to be used the same as they were before, but this may or may not make
# logical sense for your game's setting and statistic names.
#
# Note 3: I've left some "Reference Lists" from my game diffent parts in the
# modifiable constants section. I recommend you use similar lists to
# keep track of what all the numbers mean for all the gun data.
# 
# __Usage Guide__
# To use this script, you will need to add "Guns" and all the data that goes
# with them in the "Modifiable Constants" section. New guns need an entry
# in GUNDATA, a type from GUNTYPES. Additionally, there are two main ways to
# implement the guns system.
# 1 - Set the standard max MP amount for actor's maximum MP to 0 for all levels
# for actors in the database. The MP system will be exclusive to the guns.
# 2- Set up parallel standard mp/guns systems, where having a gun disables the
# actor's standard MP skills (you will need to set this up yourself). Actor's MP
# and max MP before equipping a gun is preserved until dequipped (this is done
# for you by this script).
#
# Note 1: When implementing the guns system, I recommend making new categories for
# gun skills. In my own game, I used the skill type "munitions" as a general
# skill type to hold pretty much all gun skills, where the skill type is only
# unlocked for actors when holding a gun. 
#
# Note 2: This script is not made for getting multiple instances of the same gun
# (this is not really possible without large rewrites to the RPGM base code, which
# would decrease script compatibility)
#
# Note 3: This script allows for guns with infinite ammo. To have designate a gun
# as one with infinite ammo, set the gun's max ammo set to -1
# (and set starting ammo to 0)
#
# Note 4: Dual wielding (holding two separate gun objects at once) is currently
# not supported. (It would require a large script rework)
#
# Note 5: Enemies can still use magic attacks just fine, but this probably
# only makes logical sense if that enemy is actually using a "gun" weapon.
# Additionally, enemies are not able to hold real "guns", but they can still
# use the standard MP system in lieu of the guns system just fine.
#
# Renaming MP Sytems:
# You'll probably want to rename MP, max MP, magic attack (MAT),
# and magic defense (MDF), in the database's Terms tab.
# For the game this script was originally made for, we used:
# MP -> AP for Ammo Points
# MMP -> MAG for MAGazine
# MAT (magic attack) -> PRC for PReCision
# MDF (magic defense) -> PTL for Pain ToLerance
# (Why PTL? Unless you are in appropriate gear, there's no "defence" if hit by a bullet)
#
# Recommended Pair Scripts:
# This section has some scripts that pair very well with this script, to create
# a more fully fleshed-out guns system.
#
#   - Yanfly's Skill Cost Manager
#     * License: Free to use in commercial/noncommercial games)
#     * Reason: Allows you to have both MP and TP costs displayed for skills that
#       require both, and allows skills to use items as part of the cost (useful
#       if you want to have in-battle reload skills rather than using the ammo
#       items in battle).
#   - Yanfly's Hide Menu Skills
#     * License: Free to use in commercial/noncommercial games)
#     * Reason: Allows you to hide skills like reload skills out of battle and when you
#       don't have the correct ammo type to use the reload skill (if using reload skills,
#       there will be need to be at least one reload skill per type of ammo).
#   - Liam's TP like MP (& extra TP settings)
#     * License: Exactly the same as this script, free to use in all games with attribution
#     * Reason: the MP->Guns overhaul script makes the standard MP system pretty
#       much tied up with the added guns system, making it important that the
#       TP system can have just as much customizability as the MP system does
#       and potentially act more similar to it, and that the TP system's own
#       unique mechanics can be made more interesting.
#       This script does both.
#
# Notetag:
# <GHIT num>
#
# The above notetag can be used on the following database pages:
# Actor, Class, Weapon, Armor, State, Skill, Enemy
#
# This notetag represents the equivalent of the HIT parameter for physical
# attacks, but for "magical" attacks instead. Note that GHIT starts at 0
# unless you use defaults for Actors, Classes, or Enemies. This means that
# if you enemies use "magical" attacks, then you may want to set a GHIT value
# for them. Additionally, GHIT values are additive. All GHIT values, positive
# or negative, are added up to get the final GHIT percentage. Additionally,
# GHIT chance is multiplied against the original skill hit chance. This
# means if a "magical" attack skill has a hitchance of 80%, and the actor's
# GHIT is 50, then the resulting final hitchance will be 40%. If the "magical"
# skill hit chance is 50%, and the GHIT is 150%, then the resulting final
# hitchance will be 75%.

#   Script Calling:
# There are two script calls you can use that come with this script.
#
#   $game_party.anyActorGunEquipped?
# This line, when used as a script line in an event, will evaluate to True if
# any actor in the active party is holding a gun. Otherwise, it will evaluate
# to false. This can be useful in conditional branches in events.
#   $game_party[actorID].checkIfActorGunEquipped
# This line, when used as a script line in an event, will evaluate to False if
# the actor specified by actorID is holding a gun otherwise, it will evaluate
# to false. This can be useful in conditional branches of events.
#
#
# __Modifiable Constants__
module GUNSOV
  # GUNDATA stores most of the data for particular guns.
  # is used as the default formula if there is no formula set for an actor.
  #
  # format:
  #   "gunName" => ["gunName", startingAmmo, maxAmmo, [acceptedAmmoTypes], "gunType"]
  # Ex.
  # GUNDATA = {
  #   "Small Pistol" => ["Small Pistol", 5, 7, [251, 252], "Pistol"],
  #   "Tactical Shotgun" => ["Tactical Shotgun", 0, 5, [255], "Shotgun"]
  # }
  # The above GUNDATA holds data for two guns: the Small Pistol, and Tactical
  # Shotgun. The Small Pistol starts off having 5 ammo loaded when obtained,
  # has a max ammo of 7, accepts the ammo items with itemIDs 251 and 252, and
  # is of the "Pistol" type. The Tactical Shotgun starts off with no ammo
  # loaded, 5 max ammo, accepts the ammo item with itemID 255, and is of the
  # "Shotgun" type.
  GUNDATA = {
  # Reminder: To set up a "gun" to have infinite ammo, set the starting ammo
  # to 0, and the max ammo to -1. Additionally, guns with infinite ammo
  # must use their own set of skills that DO NOT CONSUME MP.
  
    # AMMO REFERENCE LIST:
    # 251 : Small Caliber Bullets
    
    # Dinky Pistol : 5 starting ammo, 7 max ammo, uses SCB ammo, Pistol-type
    "Dinky Pistol" => ["Dinky Pistol", 5, 7, [251], "Pistol"],
    # Tactical Mag : 0 starting ammo, 10 max ammo, uses SCB ammo, Pistol-type
    "Tactical Mag" => ["Tactical Mag", 0, 10, [251], "Pistol"]
  }
  
  # GUNTYPES stores skills that apply across all guns of certain types
  # (If a certain gun is an exception to one or more of these skills,
  # do not use the "concat" version of the skill list, just put
  # in all the number manually. See GUNLOCKS for more info.)
  #
  # Note 1: Gun types do not have to have any skills in them
  #
  # Note 2: The only place GUNTYPES is actually used is for
  # A- Making it easier to add skills to new guns
  # and B - Adding the gun type after the gun name to gun skills that are learned
  # after an actor levels up.
  # This means that if you want a skill unique to a particular gun to show the
  # exact gun requires it, then there is no harm in doing something like
  # "Ancient Pistol" => [220] where 220 is a skill that only that gun has.
  #
  # format:
  #   "gunName" => [skillList]
  # Ex.
  # GUNTYPES = {
  #   "Pistol" => [41, 48, 55, 60],
  #   "Shotgun" => [120, 124, 126]
  # }
  # The above GUNTYPES holds two types of guns: pistols and shotguns.
  # Pistol standard skills include the skills with skillIDs 41, 48, 55, and 60.
  # Shotgun standard skills include the skills with the skillIDs 120, 124, and 126.
  GUNTYPES = {
    # PISTOLS SKILL REFERENCE LIST:
    # 251 : Pistol Shoot Skill
    # 252 : Threaten
    # 253 : Wild Threaten (Limeda Exclusive, level 5+)
    # 254 : Pistol Whip
    # 255 : Greasy Barrage (Enrique exclusive, any level)
    # 256 : Hot Shot (Flint Exclusive, any level)
    # 257 : Pistol Small Caliber Bullets Reload
    "Pistol" => [251, 252, 253, 254, 255, 256, 257]#,
  }
  
  # GUNLOCKS stores which skills are unlocked by which guns.
  #
  # Note: If using GUNTYPES["gunType"], USE IT INSIDE OF THE .concat()
  # parenthesis! Otherwise, the standard skill list for the gunType will
  # get modified! If a gun only uses standard skills, do an empty array
  # and then .concat() (the is an example of that below)
  #
  # format (can be any of these):
  #   "gunName" => [uniqueSkillList]
  #   "gunName" => [uniqueSkillList].concat(GUNTYPES["gunType"])
  #   "gunName" => [].concat(GUNTYPES["gunType"])
  #   !!! DO NOT DO THIS-> "gunName" => GUNTYPES["gunType"]
  #   !!! DO NOT DO THIS-> "gunName" => GUNTYPES["gunType"].concat[UniqueSkillList]
  # Ex.
  # GUNLOCKS = {
  #   "Small Pistol" => [
  #     188, 192
  #   ].concat(GUNTYPES["Pistol"]),
  #   "Tactical Shotgun" => [].concat(GUNTYPES["Shotgun"])
  # }
  # The above GUNLOCKS holds 2 guns. The Small Pistol has two skills unique
  # to it, the ones with skillIDs of 188 and 192. It also has all of the
  # standard pistol skills. The Tactical Shotgun only has the standard
  # shotgun skills.
  GUNLOCKS = {
    # STANDARD PISTOL, NO UNIQUE SKILLS
    "Dinky Pistol" => [
      # unique skills would go here
    ].concat(GUNTYPES["Pistol"]), # add standard pistol skills
    # STANDARD PISTOL, NO UNIQUE SKILLS
    "Tactical Mag" => [
      # unique skills would go here
    ].concat(GUNTYPES["Pistol"])
  }
  
  # GUNSKILLCONDITIONS holds special conditions for gun skills
  # (like actor ID and level) for gun skills that need more than just holding a
  # particular gun to unlock for a given actor. These conditions are checked
  # when leveling up (for conditions includeed actorLevelAtLeast()), and when
  # guns with skills in this list are equipped to see if the skill should be added.
  # All skill conditions in each list must be met to add a skill.
  #
  # Note: The conditional checks are actually Ruby code that is evaluated.
  # If you know how, you can put a Ruby conditonal as one of the conditionals
  # in the list. The conditional checks are run in Game_Actor, so the data
  # in Game_Actor is what is accessible for the checks.
  # format:
  #   skillID => [gunConditionalList]
  # gunConditionalList format options:
  # "actorIDEqual(oneOrMoreNumbers)" -> This checks if the actor's ID matches
  #                                     any in the list of numbers in the parenthesis
  # "actorLevelAtLeast(levelNum)"    -> This checks if the actor's level is at
  #                                     or above the number in the parenthesis
  # Ex.
  # GUNSKILLCONDITIONS = {
  #   188 => ["actorIDEqual(2)", "actorLevelAtLeast(5)"],
  #   119 => ["actorIDEqual(2, 3, 18)"]
  # }
  # The above GUNSKILLCONDITIONS holds 2 skills that have extra conditions to
  # unlock when switching to a gun that gives that skill. The skill with
  # skillID of 188 checks if the given actor's ID is 2 AND that the given.
  # The skill with skillID of 119 checks if the given actor's ID is either
  # 2, 3, or 18.
  GUNSKILLCONDITIONS = {
    # EXTRA SKILL CONDITIONS REFERENCE LIST:
    # 253 : Wild Threaten (All Pistols, Limeda Exclusive, level 5+)
    # 255 : Greasy Barrage (All Pistols, Enrique exclusive, any level)
    # 256 : Hot Shot (All Pistols, Flint Exclusive, any level)
    253 => ["actorIDEqual(1)", "actorLevelAtLeast(5)"],
    255 => ["actorIDEqual(6)"],
    256 => ["actorIDEqual(2)"]
  }
  
  # MISFIRE_CHECKS stores misfire chances for guns that can misfire, along with
  # their percentage chance out of 100 to misfire. Misfiring repeats a gun skill
  # used in the same turn (but only if the gun has enough ammo to complete
  # the skill used).
  #
  # Note: This is an optional parameter. If a gun is not in this list, then
  # it will never misfire.
  #
  # format:
  #   "gunName" => percentChance
  # Ex.
  # MISFIRE_CHANCES = {
  #   "Small Pistol" => 10,
  #   "Tactical Shotgun" => 15
  # }
  # The above GUNTYPES holds two guns, the Small Pistol and the Tactical Shotgun.
  # The small pistol has a misfire chance of 10%, and the Tactical Shotgun
  # has a misfire chance of 15%
  MISFIRE_CHANCES = {
    # 17% = ~1/6 chance
    #"Tactical Mag" => 17
    "Tactical Mag" => 100
  }
  
  # The below settings are used as default values for the
  # Actor, Class, and Enemy database page GHIT values if there is no
  # GHIT notetag present.
  DEFAULT_ACTOR_GHIT = 0
  DEFAULT_CLASS_GHIT = 80
  DEFAULT_ENEMY_GHIT = 100
end



# BEGINNING OF SCRIPTING ====================================================

#==============================================================================
# ** Game_Guns
#------------------------------------------------------------------------------
# ** This class handles the information for active guns. Active guns are
# ** added to a hash in extra save file data.
#==============================================================================
class Game_Guns
  attr_accessor :name        # the name of the gun
  attr_accessor :ammoCount   # current number of ammo a gun has
  attr_accessor :ammoMax     # maximum number of ammo a gun can take
  attr_accessor :ammoTypes   # list of item ID(s) of the ammo it takes
  attr_accessor :userID      # ID for the actor using the gun (-1 for none)
  attr_accessor :skillIDs    # list of skill IDs the gun should unlock
  attr_accessor :gunType     # the type of gun the gun is, a string (Pistol, Shotgun, etc.)
  attr_accessor :ammoInf     # whether or not gun ammo is infinite (true if max ammo param set to -1)
  
  # newUserID is an optional parameter, and will be set to -1 unless param otherwise
  # provided
  def initialize(newName, newAmmoCount, newAmmoMax, newAmmoTypes, newType, newUserID = -1)
    @name = newName
    @ammoCount = newAmmoCount
    @ammoMax = newAmmoMax
    @ammoTypes = newAmmoTypes
    @userID = newUserID
    @gunType = newType
    # if ammoMax is -1, set the infinite ammo flag to true,
    # otherwise, set it to false
    if (@ammoMax == -1)
      @ammoInf = true
    else
      @ammoInf = false
    end
    
    # get the skill IDs holding the gun unlocks
    @skillIDs = GUNSOV::GUNLOCKS[@name]
  end
  
end


class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # * Aliased gain_item() method used to check if the new item is a gun,
  # * and if it is, it initializes the gun's data based on its name and stores
  # * it in the extra save file data.
  #--------------------------------------------------------------------------
  alias before_gunsov_gain_item_standard gain_item
  def gain_item(item, amount, include_equip = false)
    # call original method (gets an item if valid)
    before_gunsov_gain_item_standard(item, amount, include_equip)
    
    # a check needs to be run here to check if an item is actually an item and
    # return if it is not, or something like that. I'm not exactly sure what
    # this does, but it is necessary for the game to not crash when launching a
    # new game.
    container = item_container(item.class)
    return unless container
    
    # check if the item gain amount is positive, and if the item's name is one
    # of the guns, if it is, add the gun to the currently active guns list
    if ((amount > 0) && GUNSOV::GUNDATA.has_key?(item.name))
      # get the initialization data relating to the gun being acquired
      gunName = (GUNSOV::GUNDATA[item.name])[0]
      gunAmmoCount = (GUNSOV::GUNDATA[gunName])[1]
      gunMaxAmmo = (GUNSOV::GUNDATA[gunName])[2]
      gunAmmoTypes = (GUNSOV::GUNDATA[gunName])[3]
      gunType = (GUNSOV::GUNDATA[gunName])[4]
      
      # Gets the current active gun hash stored in exSaveData
      # (if the active gun hash doesn't yet exist it will automatically
      # be initialized with an empty hash) and save that hash
      # in activeGunHash (it will BE the activeGuns hash, not a copy!)
      activeGunHash = $game_party.getExSaveData("activeGuns", {})
      # check if the activeGunHash does not yet contain the gunName key.
      # if it doesn't, add the new gun key to the activeGunHash with
      # the corresponding gun object as its value
      if (!(activeGunHash.has_key?(gunName)))
        # create the new gun object
        newGun = Game_Guns.new(gunName, gunAmmoCount, gunMaxAmmo, gunAmmoTypes, gunType)
        # add the new gun to the activeGunHash
        activeGunHash[gunName] = newGun
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if any party member has a gun equipped.
  # * Returns true/false.
  # *
  # * Note: this method is not actually used within this script, but can
  # * be accessed by using $game_party.anyActorGunEquipped?
  #--------------------------------------------------------------------------
  def anyActorGunEquipped?
    # return true if any of the actors used in battle is holding a gun
    return (battle_members.any? {|actorMember| actorMember.checkIfActorGunEquipped})
  end
  
end


class Game_Actor < Game_Battler
  # prevMP stores actor MP val before equipping a gun, so it can be restored
  # after it has been dequipped again.
  attr_accessor :prevMP
  
  #--------------------------------------------------------------------------
  # * Aliased initialize() method for Game_Actor used to setup
  # * prevMP to 0 when a new Actor object is created.
  #--------------------------------------------------------------------------
  alias before_gunsov_prevMP_set initialize
  def initialize(actor_id)
    # call original method (do normal Actor setup)
    before_gunsov_prevMP_set(actor_id)
    
    # set prevMP the current MP count to start with
    @prevMP = @mp
  end
  
  #--------------------------------------------------------------------------
  # * Aliased change_equip() method used to update the actor's gun skills 
  # * based on what guns the actor is equipping/dequipping, and to either
  # * set the actor's MP/MMP to 0 or to the gun's current/max ammo depending
  # * on if an actor is equipping/dequipping a gun.
  #--------------------------------------------------------------------------
  alias gunsov_change_equip_normal change_equip
  def change_equip(slot_id, item)
    origMP = @mp # store the original mp value for later
    gunDequipped = false # whether or not gun is dequipped, starts false
    
    # start by assuming previous item does not exist, use name "no item"
    previousItemName = "no item"
    # if previous item exists, set the previous item and its name
    if (!(@equips[slot_id].object == nil))
      # get the item/item name of the current item in the equipment slot
      previousItem = @equips[slot_id].object
      previousItemName = previousItem.name
    end
    
    # call original method (move the new item into the equip slot)
    gunsov_change_equip_normal(slot_id, item)
    
    # start by assuming previous item does not exist, use name "no item"
    itemName = "no item"
    
    # if the item did actually change, check if an equip/dequip action
    # needs to occur and do it
    if (@equips[slot_id].object == item)
      # if the new item is not empty, get the new item name
      if (!(@equips[slot_id].object == nil))
        # get the name of the item being dealt with
        itemName = item.name
      end
      
      # boolean variable that holds true/false depending of if the
      # old and new items are the same item or not
      itemsEqual = (previousItemName == itemName)

      # Gets the current active gun hash stored in exSaveData
      # (if the active gun hash doesn't yet exist it will automatically
      # be initialized with an empty hash) and save that hash
      # in activeGunHash (it will BE the activeGuns hash, not a copy!)
      activeGunHash = $game_party.getExSaveData("activeGuns", {})
      
      # GUN DEQUIPPING CHECKS/ACTIONS
      # check if previous item was a gun and that the new item
      # is not the same as the previous one. If it was a gun and not
      # the same, set mp current and max values to zero, and forget
      # the appropriate skills (the skills which the gun makes you learn)
      if (activeGunHash.has_key?(previousItemName) && !itemsEqual)
        gunDequipped = true
        @mmpGunAdditions = 0
        # restore the prevMP before equipping gun
        # (this will be 0 unless using the regular MP system as a side system)
        @mp = @prevMP
        # set the actor gun holder actorID to -1 (bc no holder)
        activeGunHash[previousItemName].userID = -1
        updateGunSkills(previousItemName, false)
      end
      
      # GUN EQUIPPING CHECKS/ACTIONS
      # check if the new item is a gun and that the
      # previously equipped item is not the same as the new item. If
      # it is a gun and not the same, get the appropriate mp current
      # and max values, and learn the appropriate skills
      if (activeGunHash.has_key?(itemName) && !itemsEqual)
        gunName = itemName
        # change prevMP to the original MP if a gun was not just dequipped
        if (!gunDequipped)
          @prevMP = origMP
        end
        # if the gun has infinite ammo, keep mmp and mp at zero
        # (gun skills will not consume mp for such guns)
        # otherwise, set mmp to ammoMax and mp to ammoCount
        if (activeGunHash[gunName].ammoInf == true)
          @mmpGunAdditions = 0
          @mp = 0
        else
          @mmpGunAdditions = activeGunHash[gunName].ammoMax
          @mp = activeGunHash[gunName].ammoCount
        end
        # set the gun actor ID to the current holder's actorID
        activeGunHash[gunName].userID = @actor_id
        updateGunSkills(gunName, true)
      end
    end
  end
    
  #--------------------------------------------------------------------------
  # * New method used to update the actor's gun skills based on what guns
  # * the actor is equipping/dequipping.
  #--------------------------------------------------------------------------
  def updateGunSkills(gunName, isEquipping)
    # Gets the current active gun hash stored in exSaveData
    # (if the active gun hash doesn't yet exist it will automatically
    # be initialized with an empty hash) and save that hash
    # in activeGunHash (it will BE the activeGuns hash, not a copy!)
    activeGunHash = $game_party.getExSaveData("activeGuns", {})
    # get the skill IDs (potentially) learned when equipping the gun
    gunSkillIDList = activeGunHash[gunName].skillIDs
    # LEARN skills for the gun is equipping the gun
    if (isEquipping)
      gunSkillIDList.each do |skillID|
        # check if gun skill has extra conditions to unlock it (other than
        # just holding the related gun), if it does,
        # evaluate the extra conditions and if they all evaluate to
        # true, learn the skill, otherwise, do not learn the skill
        if (GUNSOV::GUNSKILLCONDITIONS.has_key?(skillID))
          # check if all evaluated conditions evaluate to true
          extraSkillConditionsMet = checkExtraSkillConditions(skillID)
          # if the extra skill conditions are met, add the skill
          if (extraSkillConditionsMet)
            # learn the specified skill
            learn_skill(skillID)
          end
        # if there are not extra skill conditions to meet, learn the skill
        else
          learn_skill(skillID)
        end
      end
    # FORGET skills for the gun if dequipping the gun
    # (forgetting skills that aren't learned does nothing, it's ok)
    else
      # forgot all skills in the gun being dequipped's skill list
      gunSkillIDList.each do |skillID|
        forget_skill(skillID)
      end
    end
  end
  
  # Accessor used for level up and display_level_up methods used to store
  # gun skills that need their skill information displayed despite
  # the fact that they will not actually be learned.
  attr_accessor :extraSkillsToDisplay
  
  #--------------------------------------------------------------------------
  # * Aliased level_up() method used to add gun skills with extra conditionals
  # * that include level conditions if ALL extra conditions are met and the
  # * appropriate gun is equipped (gun w/ the skill in its GUNLOCKS list).
  # * Skills that would be learned if not for having the appropriate gun
  # * equipped are saved into a list to still display in the display function,
  # * display_level_up, but not actually learned
  #--------------------------------------------------------------------------
  alias before_gunsov_extra_skills level_up
  def level_up
    # call original method (increase variable @level and learn regular skills)
    before_gunsov_extra_skills
    
    # start with extraSkillsToDisplay as empty list
    @extraSkillsToDisplay = []
    
    # check the extra conditions for the guns (a level up message for guns skills
    # will only need to be displayed if there is a level up condition in the
    # extra skill conditions for a gun skill)
    gunConditionalSkillsHash = GUNSOV::GUNSKILLCONDITIONS
    gunConditionalSkillsHash.each do |skillID, conditionalList|
      # boolean, initially false, set to true if need to add to extraSkillsToDisplay list
      
      # iterate through conditional list
      conditionalList.each do |conditionalString|
        # try to get the level number meant to compare with actor level,
        # if result is nil, then the conditional is not the actor level checker
        levelNum = getActorLevelNum(conditionalString)
        
        # note: this block of code should only activate once per skill
        # because the actor level check should only be present once per skill
        # (if present at all, if not present, levelups don't need to be worried about)
        #
        # if levelNum exists (not nil) and is equal to the actor's current level,
        # do further checks to see if it should be learned or added to
        # extraSkillsToDisplay list
        if (levelNum != nil)
          if (levelNum == @level)
            # start by assuming gun not appropriate (meaning skill in equipped gun's skill list)
            gunAppropriate = false
            currentGun = getGunEquipped # get actor's current gun
            # check if a gun is equipped, if it is, check if skill in gun's skill list
            if (GUNSOV::GUNLOCKS.has_key?(currentGun))
              gunAppropriate = GUNSOV::GUNLOCKS[currentGun].include?(skillID)
            end
            allExtraSkillConditionsMet = checkExtraSkillConditions(skillID)
            
            # if appropriate gun equipped AND all extra conditionals met, learn skill,
            # else, if only extra conditionals met, add the skill to the extraSkillsToDisplay list
            # (otherwise, do nothing)
            if (gunAppropriate && allExtraSkillConditionsMet)
              learn_skill(skillID) # learn the skill
            elsif (allExtraSkillConditionsMet)
              # add the skill to the extraSkillsToDisplay list
              @extraSkillsToDisplay.push($data_skills[skillID])
            end
            
          end
        end
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased display_level_up() method used to display any extra skills
  # * that could not actually be learned (improper gun equipped), but which
  # * still need their data displayed. Additionally, those skills will show
  # * what kinds of guns need to be equipped to enable that skill.
  #--------------------------------------------------------------------------
  alias before_gunsov_extra_display display_level_up
  def display_level_up(new_skills)    
    # call original method (displays all skills learned on level up)
    before_gunsov_extra_display(new_skills)
    
    # add skill display messages for all extra skills that have not been
    # learned, but will become available if appropriate gun equipped
    @extraSkillsToDisplay.each do |skill|
      # get gun skill type (may be nothing, may be one or more kinds of guns)
      gunSkillTypes = getGunSkillTypes(skill.id)
      
      # if gunSkillTypes is not empty, add a space at begin for display purposes
      if (gunSkillTypes != "")
        gunSkillTypes = " " + gunSkillTypes
      end
      
      # print out the level skill message, but with the gunSkillTypes added
      $game_message.add(sprintf(Vocab::ObtainSkill, actor.name, (skill.name + gunSkillTypes)))
    end
    
    # clear the extra skills to display list
    @extraSkillsToDisplay.clear
  end
  
  #--------------------------------------------------------------------------
  # * New method used to find what type(s) of guns a skill can be used with
  # * for display purposes (shows when learning gun skills on level ups).
  #--------------------------------------------------------------------------
  def getGunSkillTypes(skillID)
      # skill type is nothing unless proven otherwise
      gunSkillTypes = ""
      
      # go through all guntypes/skills and check for matching skills
      GUNSOV::GUNTYPES.each do |gunType, gunTypeSkills|
        # if the passed skill is in a gunTypeSkills list, add that
        # gunType to the gunSkillTypes string
        if (gunTypeSkills.include?(skillID))
          # if the gunSkillTypes list is not empty (at least one entry),
          # add a comma and space before the next gun skill type
          if (gunSkillTypes != "")
            gunSkillTypes += ", "
          end
          # add the gun type to the gunSkillTypes list
          gunSkillTypes += gunType
        end
      end
      
      # if there is one or more gun skill types, add parenthesis at begin/end
      if (gunSkillTypes != "")
        gunSkillType = "(" + gunSkillTypes + ")"
      end
      
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if all extra skill conditions (which are ruby
  # * code) for a given skillID are fulfilled.
  # * Returns true if they are, else, return false.
  #--------------------------------------------------------------------------
  def checkExtraSkillConditions(skillID)
    # get the list of extra skill conditions for the particular skill
    extraSkillConditionsList = GUNSOV::GUNSKILLCONDITIONS[skillID]
      
    # iterate through the list of skill conditions, and check if all are true
    extraSkillConditionsList.each do |skillCondition|
      # return false if condition condition is failed
      if (eval(skillCondition) == false)
        return false
      end
    end
    # return true if no conditions failed
    return true
  end
    
  #--------------------------------------------------------------------------
  # * New method made for use with the extra gun conditional skills
  # * to check if the actor's level is at or above the levelNum. Returns true/false.
  #--------------------------------------------------------------------------
  def actorLevelAtLeast(levelNum)
    # result is true if actor level is at or above the levelNum, else false
    result = (@level >= levelNum)
    return result
  end
  
  #--------------------------------------------------------------------------
  # * New method made for use with the extra gun conditional skills
  # * to check if the actor's ID matched any found in the list of
  # * parameters provided (the amount of variables varies). Returns true/false.
  #--------------------------------------------------------------------------
  def actorIDEqual(*idList)
    # check if each passed parameter matches the current actor ID
    # return true if any match
    idList.each do |idNum|
      # return true if match found
      if (@actor_id == idNum)
        return true
      end
    end
    # return false if no actorID not found in the actor list
    return false
  end
    
  #--------------------------------------------------------------------------
  # * New method used to return whether or not the actor has a gun
  # * equipped (true/false)
  #--------------------------------------------------------------------------
  def checkIfActorGunEquipped
    # Gets the current active gun hash stored in exSaveData
    # (if the active gun hash doesn't yet exist it will automatically
    # be initialized with an empty hash) and save that hash
    # in activeGunHash (it will BE the activeGuns hash, not a copy!)
    activeGunHash = $game_party.getExSaveData("activeGuns", {})
    # return true if (one of) the actor's held weapon(s) is in the list of guns
    return (weapons.any? {|weapon| activeGunHash.has_key?(weapon.name)})
  end
  
  #--------------------------------------------------------------------------
  # * New method used to return the name of the gun the actor is holding as
  # * a string (dual wielding not supported). If the actor has no gun
  # * equipped, then the string returned is "no guns".
  #--------------------------------------------------------------------------
  def getGunEquipped
    # Gets the current active gun hash stored in exSaveData
    # (if the active gun hash doesn't yet exist it will automatically
    # be initialized with an empty hash) and save that hash
    # in activeGunHash (it will BE the activeGuns hash, not a copy!)
    activeGunHash = $game_party.getExSaveData("activeGuns", {})
    actorWeapons = weapons
    weapons.each do |weapon|
      # return weapon name if it is a gun
      if (activeGunHash.has_key?(weapon.name))
        return (weapon.name)
      end
    end
    # return "no guns" if the actor has no guns
    return ("no guns")
  end
  
  #--------------------------------------------------------------------------
  # * New method used to return the level in the actorLevelAtLeast function
  # * for extra gun conditionals. Returns nil if the passed string is not
  # * the actorLevelAtLeast() function.
  #--------------------------------------------------------------------------
  def getActorLevelNum(myString)
    # get the first 18 characters (or as much as possible if string less
    # than 18 characters, so that it can be compared to "actorLevelAtLeast(" )
    mySubString = myString[0, 18]
    actorLevelMsg = "actorLevelAtLeast(" # msg to look for
    # return nil unless the text is the actor level function
    return unless (mySubString == actorLevelMsg)
    # starting character index will be 18
    charIndex = 18
    # my num will start off empty
    myNum = ""
    # start with number not complete
    numComplete = false
    
    #while the number is not complete, add digits to the number
    while (!numComplete)
      # add to num if not ')' character, otherwise, stop iteration
      if (myString[charIndex] != ")")
        myNum += myString[charIndex]
        charIndex += 1
      else
        numComplete = true
      end
    end
    
    # if empty string, return 0
    if (myNum == "")
      return (0) 
    end
    
    # convert completed num to integer and return it
    return (myNum.to_i)
  end
  
  #--------------------------------------------------------------------------
  # * Aliased usable?() method used to check if ammo is usable on a character
  # * out of battle (possibly in battle too, but not sure).
  #--------------------------------------------------------------------------
  alias before_gunsov_gun_conditions usable?
  def usable?(item)
    # Note: This method is used in general when the game checks if an item is
    # usable AT ALL (as in, at least one actor can use the item),
    # whether it can actually be applied to someone when actually using
    # the item is done in the item_test method.
    
    # call original method and store the boolean result
    originalResultBool = before_gunsov_gun_conditions(item)
    
    # if original result false OR the item is a skill (not an item),
    # then return the original result
    if ((originalResultBool == false) || !(item.is_a?(RPG::Item)))
      return originalResultBool
    end
    
    # check if the ammoList is calculated yet, if it is not, calculate
    # the full list of ammo and save it into ExSaveData
    if (!($game_party.doesExSaveDataExist?("ammoList")))
      $game_party.setExSaveData("ammoList", createAmmoList)
    end
    # get the full list of ammo from ExSaveData
    fullAmmoList = $game_party.getExSaveDataNoInit("ammoList")
    
    # start by assuming the item is not ammo, so final result true
    finalResult = true
    
    # check gun conditions if item is ammo, and item is only usable if the
    # actor's currently equipped gun uses that type of ammo
    if (fullAmmoList.include?(item.id))
      # if item is ammo, now assume it is false unless proven true
      finalResult = false
      gunName = getGunEquipped
      # if actor holding a gun, get the list of acceptable ammos
      if (gunName != "no guns")
        acceptableAmmoTypes = (GUNSOV::GUNDATA[gunName])[3]
        # if the item id is in the list of acceptable ammo types, the final
        # result of usability for the item is true (otherwise still false)
        finalResult = acceptableAmmoTypes.include?(item.id)
      end
    end
    
    return finalResult
  end
  
  #--------------------------------------------------------------------------
  # * New helper method used to create a full ammo list that contains
  # * all types of ammo. Returns the full ammo list.
  #--------------------------------------------------------------------------
  def createAmmoList
    # start ammo list as empty list
    ammoList = []
    
    # iterate through list of ALL guns and get ammo types from the gunInfo
    GUNSOV::GUNDATA.each do |gunName, gunInfo|
      # get the accepted ammo types for the gun
      ammoTypes = gunInfo[3]
      # check if the ammoList currently includes each ammoType in the
      # ammoTypes list for the gun, if it doesn't, add it to the ammoTypes list
      ammoTypes.each do |ammoID|
        if (!(ammoList.include?(ammoID)))
          ammoList.push(ammoID)
        end
      end
    end
    return ammoList
  end
  
end

class Game_BattlerBase
  # stores the amount the guns add to MMP
  attr_accessor :mmpGunAdditions
  
  #--------------------------------------------------------------------------
  # * Aliased initialize() method for Game_BattlerBase used to setup
  # * mmpGunAdditions to 0 when a new BattlerBase object is created.
  #--------------------------------------------------------------------------
  alias before_gunsov_mmpAdd_init initialize
  def initialize    
    # call original method (initialize the normal stuff like hp, mp, etc.)
    before_gunsov_mmpAdd_init
    
    # set the new mmpGunAdditions to 0
    @mmpGunAdditions = 0
  end
  
  #--------------------------------------------------------------------------
  # * Aliased param() method used to only return the amount of max mp the
  # * gun is supposed to allow for if a gun is being used.
  #--------------------------------------------------------------------------
  alias after_gunsov_mmp_check param
  def param(param_id)
    # check if param_id is 1 (MMP) and battlerBase object is an actor,
    # if both true, do further checks
    if ((param_id == 1) && self.kind_of?(Game_Actor))
      gunName = self.getGunEquipped # get name of actor's held gun
      
      # if actor holding a gun, return 0 for the value of the param
      # the rest of the mmp is added by the gun stuff
      if (gunName != "no guns")
        finalParamVal = @mmpGunAdditions
        return (finalParamVal)
      end 
    end
    
    # call original method (get normal parameter data)
    after_gunsov_mmp_check(param_id)
  end
  
end

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Aliased item_test() method used to test if ammo for guns can be used
  # * on an actor or not. Ammo usability on guns depends on if the type
  # * of ammo is an acceptable type for the gun the actor is holding.
  #--------------------------------------------------------------------------
  alias after_gunsov_gun_checks item_test
  def item_test(user, item)
    # only do the gun checks if the item is an actual item
    if (item.is_a?(RPG::Item))
      # check if the ammoList is calculated yet, if it is not, calculate
      # the full list of ammo and save it into ExSaveData
      if (!($game_party.doesExSaveDataExist?("ammoList")))
        # note: createAmmoList is technically an Game_Actor method,
        # but any battler using an item is guaranteed to be an actor
        $game_party.setExSaveData("ammoList", createAmmoList)
      end
      # get the full list of ammo from ExSaveData
      fullAmmoList = $game_party.getExSaveDataNoInit("ammoList")
      
      # check gun conditions if item is ammo, and item is only usable if the
      # user battler is an actor, and the actor's currently equipped gun
      # uses that type of ammo
      if ((user.battlerIsActor?) && (fullAmmoList.include?(item.id)))
        gunName = getGunEquipped # get equipped gun
        # if actor holding a gun, get the list of acceptable ammos
        if (gunName != "no guns")
          acceptableAmmoTypes = (GUNSOV::GUNDATA[gunName])[3]
          # return false for the item usability test if the item
          # is not an acceptable ammo type for the gun
          return false if (!acceptableAmmoTypes.include?(item.id))
        end
      end
    end
    
    # call original method (do all the normal checks to see if item usable)
    # implicitly returns the original result
    after_gunsov_gun_checks(user, item)
  end
  
  #--------------------------------------------------------------------------
  # * Aliased pay_skill_cost() method used to set the battler's gun ammo
  # * after a skill takes its mp cost.
  #--------------------------------------------------------------------------
  alias before_gunsov_change_gun_ammo_skill pay_skill_cost
  def pay_skill_cost(skill)
    # call original method (update mp/tp using skill costs)
    before_gunsov_change_gun_ammo_skill(skill)
    
    # update the gun's ammo to the current mp (if battler holding gun)
    setNewBattlerGunAmmoUsingMp
  end
  
  #--------------------------------------------------------------------------
  # * Aliased execute_damage() method used to manage ammo gain in battle
  # * through skills (like reloading, if implemented that way).
  # *
  # * Note: (play the gun reloading sounds in a common event or something, 
  # * it's not done in script here)
  #--------------------------------------------------------------------------
  alias gunsov_change_gun_ammo_mp_rec_and_dam execute_damage
  def execute_damage(user)
    # Note 1: here, user is the person who activated the damage formula,
    # and self is the actor who is being affected by it
    # (use and self MAY be the same)
    #
    # Note 2: mp recovery is counted in the script as "damage", it's just damage
    # in the negative.
    
    oldUserMP = user.mp # get user mp val before standard calculations (matters for mp drain)
    oldSelfMP = self.mp # get self mp val before standard calculations
    
    # call original method (update mp/tp/etc. with damage formula)
    gunsov_change_gun_ammo_mp_rec_and_dam(user)
    
    newUserMP = user.mp # get user mp val after standard calculations (matters for mp drain)
    newSelfMP = self.mp # get self mp val after standard calculations
    # update user's held gun's ammo to the current mp (if it exists)
    # (if battler is an actor, holding gun [done in method], and the mp val changed)
    if ((oldUserMP != newUserMP) && (user.battlerIsActor?))
      user.setNewBattlerGunAmmoUsingMp
    end
    # update self's held gun's ammo to the current mp (if it exists)
    # (if battler is an actor, holding gun [done in method], and the mp val changed)
    if ((oldSelfMP != newUserMP) && (self.battlerIsActor?))
      setNewBattlerGunAmmoUsingMp
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased regenerate_mp() method used to manage ammo gain in battle
  # * through the mp regen parameter/system.
  # * (This won't make sense in a lot of games, but it is here just in case)
  #--------------------------------------------------------------------------
  alias gunsov_change_gun_ammo_mp_regen regenerate_mp
  def regenerate_mp
    oldMP = self.mp # get mp val before standard calculations
    
    # call original method (update mp/tp/etc. with mp regen amount)
    gunsov_change_gun_ammo_mp_regen
    
    newMP = self.mp # get mp val after standard calculations
    # update the held gun's ammo to the current mp (if it exists)
    # (if battler is an actor, holding gun [done in method], and the mp val changed)
    if ((oldMP != newMP) && (self.battlerIsActor?))
      setNewBattlerGunAmmoUsingMp
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to set the ammo of the battler's held gun (if it exists)
  # * to the battler's MP.
  #--------------------------------------------------------------------------
  def setNewBattlerGunAmmoUsingMp
    # check if the battler is a game_actor
    if (battlerIsActor?)
      # Gets the current active gun hash stored in exSaveData
      # (if the active gun hash doesn't yet exist it will automatically
      # be initialized with an empty hash) and save that hash
      # in activeGunHash (it will BE the activeGuns hash, not a copy!)
      activeGunHash = $game_party.getExSaveData("activeGuns", {})
      # get list of battler's weapons
      actorWeapons = self.weapons
      # go through actors weapon list, if a gun is found, update the gun's
      # ammo count
      actorWeapons.each do |weapon|
        # if actor weapon is a gun, do gun ammo processing
        if (activeGunHash.has_key?(weapon.name))
          # set ammmo of weapons to the actor mp
          activeGunHash[weapon.name].ammoCount = self.mp
        end
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased item_hit() method used to get the notetagged gun hitrate
  # * (basically a copy of the HIT parameter but for "magical" weapons aka guns),
  # * and after the GHIT score is calculated, it is multiplied with the
  # * original success rate like HIT is. Returns the new GHIT rate.
  #--------------------------------------------------------------------------
  alias before_gunsov_ghit_calculations item_hit
  def item_hit(user, item)
    # call original method (do standard hitrate calculations)
    origHitRate = before_gunsov_ghit_calculations(user, item)
    
    # if the attack is not a "magical" (gun) attack, return the original rate
    return (origHitRate) unless item.magical?
    
    # calculate the battler GHIT using all related notetags
    battlerGHIT = calcBattlerGHIT(user, item)
    # calculate the new hit rate based on the calculated GHIT
    # (original rate will be multiplied by the added-up GHIT score)
    # battlerGHIT * 0.01 because it represents a percentage
    newGHITRate = origHitRate * (battlerGHIT * 0.01)
    # return the GHIT-modified rate
    return newGHITRate
  end

  #--------------------------------------------------------------------------
  # * New method used to calculate the GHIT value. Returns the sum of all
  # * the battler's GHIT notetag values from the following database pages:
  # * Actor-Based Database Pages: Actor, Class, Weapons, Armor
  # * Enemy-Based Database Pages: Enemy
  # * General Pages (Actors and Enemies): States, Skill 
  #--------------------------------------------------------------------------
  def calcBattlerGHIT(user, item)
    # general note: ternary operators are used to change GHIT values
    # to be 0 or a specified default value when GHIT notetags are not present
    # (gunHitChance return val of -1 indicated no GHIT notetag found)
    
    # START ALL GROUPED GHIT VALS AT 0
    # actor GHIT
    totalActorGHIT = 0
    # enemy GHIT
    enemyGHIT = 0
    # generic GHITs
    stateGHIT = 0
    skillGHIT = 0
    genericGHIT = 0
    
    # if the battler is an actor, check notetags for class, actor, weapons, armor
    if (user.battlerIsActor?)
      actorID = user.id # get actorID
      actorData = $data_actors[actorID] # get actor data
      actorGHITTagVal = actorData.gunHitChance # get actor GHIT tag val (-1 -> no tag)
      # get actor GHIT
      actorGHIT = (actorGHITTagVal != -1) ? actorGHITTagVal : GUNSOV::DEFAULT_ACTOR_GHIT
      
      actorClassID = user.class_id # get actor's classID
      classData = $data_classes[actorClassID] # get actor's class data
      classGHITTagVal = classData.gunHitChance # get actor's class GHIT tag val (-1 -> no tag)
      # get actor's class GHIT
      classGHIT = (classGHITTagVal != -1) ? classGHITTagVal : GUNSOV::DEFAULT_CLASS_GHIT
      
      weaponGHIT = 0 # start weapon GHIT at 0
      actorWeapons = user.weapons # get list of battler's weapons
      # add up all the GHIT scores in the actor's weapons list
      actorWeapons.each do |weapon|
        weaponID = weapon.id # get weaponID
        weaponData = $data_weapons[weaponID] # get weapon data
        weaponGHITTagVal = weaponData.gunHitChance # get weapon GHIT tag val (-1 -> no tag)
        # add weapon GHIT to total weapon GHIT
        weaponGHIT += (weaponGHITTagVal != -1) ? weaponGHITTagVal : 0
      end
      
      armorGHIT = 0 # start armor GHIT at 0
      actorArmors = user.armors # get list of battler's armors
      # add up all the GHIT scores in the actor's armor list
      actorArmors.each do |armor|
        armorID = armor.id # get armorID
        armorData = $data_armors[armorID] # get armor data
        armorGHITTagVal = armorData.gunHitChance # get armor GHIT tag val (-1 -> no tag)
        # add weapon GHIT to total weapon GHIT
        armorGHIT += (armorGHITTagVal != -1) ? armorGHITTagVal : 0
      end
      
      # get total actor GHIT
      totalActorGHIT = actorGHIT + classGHIT + weaponGHIT + armorGHIT
    end
    
    # for enemy battlers (battler not actor), check notetags for enemy
    if (!user.battlerIsActor?)
      enemyID = user.enemy_id # get enemyID
      enemyData = $data_enemies[enemyID] # get enemy data
      enemyGHITTagVal = enemyData.gunHitChance # get enemy GHIT tag val (-1 -> no tag)
      # get enemy GHIT
      enemyGHIT = (enemyGHITTagVal != -1) ? enemyGHITTagVal : GUNSOV::DEFAULT_ENEMY_GHIT
    end
    
    # for all battlers, check notetags for states and the current skill (if it is a skill)
    
    # go through the list of the battler's states and add GHIT scores
    (user.states).each do |state|
      stateID = state.id # get state id
      stateData = $data_states[stateID] # get state data
      stateGHITTagVal = stateData.gunHitChance # get state GHIT tag val (-1 -> no tag)
      # add state GHIT to total state GHIT
      stateGHIT += (stateGHITTagVal != -1) ? stateGHITTagVal : 0
    end
    
    # if the "item" is a skill, check the notetags and get the state GHIT
    if (item.is_a?(RPG::Skill))
      skillID = item.id # get skillID
      skillData = $data_skills[skillID] # get skill data
      skillGHITTagVal = skillData.gunHitChance # get skill GHIT tag val (-1 -> no tag)
      # get skill GHIT
      skillGHIT = (skillGHITTagVal != -1) ? skillGHITTagVal : 0
    end
    
    # get generic (GHIT that can be calc'd for all battlers) GHIT score
    genericGHIT = stateGHIT + skillGHIT
    
    # add all GHIT scores to get the total GHIT score
    # (non-applicable scores will be 0)
    totalGHIT = totalActorGHIT + enemyGHIT + genericGHIT
    
    # if GHIT is less than 0, it shouldn't hit anyway, so just set it to 0
    if (totalGHIT < 0)
      totalGHIT = 0
    end
    
    # return total GHIT
    return totalGHIT
  end
  
  #--------------------------------------------------------------------------
  # * New helper method used to check if a battler is an actor
  # * (if the battler is not, it is an enemy). Returns true/false
  # * depending on if the battler is an actor or not.
  #--------------------------------------------------------------------------
  def battlerIsActor?
    # return true if instance of Game_Actor, else false
    return self.kind_of?(Game_Actor)
  end
  
end


class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Aliased draw_item_name() method used to draw the item name including
  # * currentAmmo and maxAmmo data for guns.
  #--------------------------------------------------------------------------
  alias gunsov_draw_item_name_orig_method draw_item_name
  def draw_item_name(item, x, y, enabled = true, width = 172)
    # must return unless the passed item exists
    return unless item
    
    # whether of not ammo text printing is ocurring, false by default
    ammoPrintingStatus = false
    # set default origItemName to "" because not needed unless item is gun
    origItemName = ""
    
    # append current and max ammo data to the end of the item name
    # if the item is a gun
    if (GUNSOV::GUNDATA.has_key?(item.name))
      ammoPrintingStatus = true
      # store the original item name (the item name will be changed back to
      # this later)
      origItemName = item.name
      
      # store the gun name so code more readable
      gunName = item.name
      
      # Gets the current active gun hash stored in exSaveData
      # (if the active gun hash doesn't yet exist it will automatically
      # be initialized with an empty hash) and save that hash
      # in activeGunHash (it will BE the activeGuns hash, not a copy!)
      activeGunHash = $game_party.getExSaveData("activeGuns", {})
      
      # start the bit to attach to the end of the gun name with a space
      gunNameAddition = " "
      # if the gun has infinite ammo, just use "[ammo infinite]" as the ammo counter,
      # otherwise, use "[ammoCount / maxAmmo]" as the ammo counter.
      if (activeGunHash[gunName].ammoInf)
        gunNameAddition += "[Infinite]"
      else
        # start of the addition to the gun name with "{"
        gunNameAddition += "["
        # add current ammo to gunNameAddition string
        gunNameAddition += (activeGunHash[gunName].ammoCount).to_s
        # add " / " in between the numbers
        gunNameAddition += "/"
        # add max ammo to gunNameAddition string
        gunNameAddition += (activeGunHash[gunName].ammoMax).to_s
        # add the end bracket
        gunNameAddition += "]"
      end
      
      # add whatever the appropriate ammo counter is to the end of the item name
      item.name += gunNameAddition
    end
    
    
    # call original method (draw the item name as "normal" with the
    # temporarily-changed item name)
    gunsov_draw_item_name_orig_method(item, x, y, enabled, width)
    
    # if the item name was temporarily modified because of printing the
    # ammo as part of the name, set the amoo
    if (ammoPrintingStatus == true)
      item.name = origItemName
    end
  end
  
end


class RPG::BaseItem
  #--------------------------------------------------------------------------
  # * New method used to read in GHIT values from GHIT notetags
  # * format: <GHIT num>
  # * all GHIT nums from the battler, their weapons, etc. will be added
  # * up into one number, which will then be multiplied with the standard
  # * item success chance. If no GHIT notetag is found, returns -1.
  #--------------------------------------------------------------------------
  def gunHitChance
    # check if gunHitChance has been checked yet, if not, get it
    if @gunHitChance.nil?
      # checks for GHIT notetag
      if (@note =~ /<GHIT (.*)>/i)
        # gets the value from notetag ($1 is global var used for regex),
        # and ensures it is integer
        @gunHitChance = $1.to_i
      else
        # -1 returned as default val if no notetag present
        @gunHitChance = -1
      end
    end
    # gunHitChance implicit return
    @gunHitChance
  end
end


class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Aliased use_item() method to handle gun misfiring. Guns have a user-defined
  # * chance to misfire in the modifiable constants. Only skills which the
  # * gun uses and which use ammo will be able to misfire. Additionally
  # * misfiring can only happen if the gun has enough ammo to complete the
  # * misfire.
  #--------------------------------------------------------------------------
  # aliased use_item method used to handle guns with a chance to misfire (shoot again)
  alias before_gunsov_extra_actions use_item
  def use_item
    # call original method (do the standard skill/item actions)
    origHitRate = before_gunsov_extra_actions
    
    origItem = nil
    if (!@subject.current_action.nil?)
      # get the item used for the action
      origItem = @subject.current_action.item
    end
    
    # check if "item" is a skill and if the subject (person doing the action)
    # is an actor, if they are, do further checks
    if (origItem.is_a?(RPG::Skill) && @subject.battlerIsActor?)
      actorID = @subject.id # get the current actor ID
      skillID = origItem.id # get the skill ID
      heldGunName = $game_actors[actorID].getGunEquipped # get name of actor's held gun
      
      # boolean to check if the gun can misfire or not
      gunCanMisfire = GUNSOV::MISFIRE_CHANCES.has_key?(heldGunName)
      # boolean to check if the skill is in the held gun's list
      # start with it set to false, change to true if it turns out
      # the skill is in the list
      skillInGunSkillList = false
      # check if a gun is equipped, if it is, check if skill in gun's skill list
      if (GUNSOV::GUNLOCKS.has_key?(heldGunName))
        skillInGunSkillList = GUNSOV::GUNLOCKS[heldGunName].include?(skillID)
      end
      skillMPCost = @subject.skill_mp_cost(origItem)
      # check if the skill consumes mp (aka it shoots ammo in some regard)
      skillConsumesMP = ((skillMPCost != nil) && (skillMPCost > 0))
      # if the actor's held gun has a misfire chance, the skill used is
      # in the skill gun list, and the skill uses mp (so spends ammo), 
      # then do the tactical mag misfire chance to shoot again (repeat the skill
      # executed in the original method one more time)
      if (gunCanMisfire && skillInGunSkillList && skillConsumesMP)
        # randomize number 1-100 (+1 to account for nums starting at 0 and ending at 99)
        randNum = rand(100) + 1
        # get the skill mp cost
        skillMPCost = @subject.skill_mp_cost(origItem)
        
        # if the random number is at the specified percentage or lower, 
        # and the gun has enough ammo to shoot again (check the skill mp cost),
        # activate the misfire (do the skill an extra time)
        if ((randNum <= GUNSOV::MISFIRE_CHANCES[heldGunName]) && (@subject.mp > skillMPCost))
          battleLogDisplayWaitTime = 1 # time in seconds to wait after displaying the message (1 sec)
          # display the misfire message
          @log_window.add_text("...And the gun misfires, shooting again!")
          # go through the wait time
          battleLogDisplayWaitTime.times { @log_window.wait }
          # NABLS.log("...And the gun misfires, shooting again!")
          # subject uses the item (pays skills costs, etc.)
          @subject.use_item(origItem)
          # refresh the display window (again)
          refresh_status
          # get the targets used for the action
          origTargets = @subject.current_action.make_targets.compact
          # activate the skill on the targets once more
          origTargets.each {|target| origItem.repeats.times { invoke_item(target, origItem) } }
        end
      end
    end
  end
  
end


class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Aliased command_312() (change MP for game events) method used to set the
  # * actor's or actors' gun ammo after the change mp command does it's mp changes.
  #--------------------------------------------------------------------------
  alias gunsov_before_change_mp_change_ammo command_312
  def command_312
    # call original method (update mp of actor(s))
    gunsov_before_change_mp_change_ammo
    
    # Gets the current active gun hash stored in exSaveData
    # (if the active gun hash doesn't yet exist it will automatically
    # be initialized with an empty hash) and save that hash
    # in activeGunHash (it will BE the activeGuns hash, not a copy!)
    activeGunHash = $game_party.getExSaveData("activeGuns", {})
    
    # go through the actor(s) that were changed, check if they are holding
    # guns, and if they are, change their gun's ammo to match their MP
    iterate_actor_var(@params[0], @params[1]) do |actor|
      # get list of actor's weapons
      actorWeapons = actor.weapons
      # go through actors weapon list, if a gun is found, update the
      # gun's ammo count
      actorWeapons.each do |weapon|
        # if actor weapon is a gun, do gun ammo processing
        if (activeGunHash.has_key?(weapon.name))
          # set ammmo of weapons to the actor mp
          activeGunHash[weapon.name].ammoCount = actor.mp
        end
      end
    end
  end
  
end
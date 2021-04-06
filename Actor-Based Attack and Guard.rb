# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-ABAGS"] = true
# END OF IMPORT SECTION

# Script:           Actor-based Attack and Guard Skills
# Author:           Liam
# Version:          1.0.1
# Description:
# This script allows you to set custom attack and defend skills for different
# actors based on the actorIDs and skillIDs. It also allows you to set up
# default attack and guard skills that will be used for actors that do not have
# specific attack/guard skills set.
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
# To use this script, modify the values for the settings in the in the
# "Modifiable Constants" section below. Above each setting, there will be
# a description of what the setting does and how to fill in the setting
# values when it is not obvious.
#
# Note 1: Attack skills must target one or all enemies, and guard skills
# must target one or all allies.
#
# Note 2: Designated attack and guard skills must not cost mp/tp
#
# Note 3: There is some special parts to making an attack/guard skill.
# Attack skills have a special state (that isn't even in the state list)
# applied called "Normal Attack", and Guard skills apply a guard state
# which should have the special "Guard" flag (you can turn on this flag
# in the "features" section for states, under the "Other" tab).
#
#
# __Modifiable Constants__
module ABAGS
  # The skill ID of the skill to use if there is not an actor-specific attack
  # skill set.
  # 1 is the normal default attack skill.
  DEFAULT_ATTACK_SKILL = 1
  
  # ABAGS_ACTOR_ATTACK_SKILLS stores actorIDs tied to the skillIDs that should be
  # used for the specific actor's attack skill.
  #
  # Note: Do not try to designate multiple skills for the same actor.
  #
  # format:
  #   actorID => skillID
  # Ex.
  # ABAGS_ACTOR_ATTACK_SKILLS = {
  #   1 => 1,
  #   7 => 24
  # }
  # The above ABAGS_ACTOR_ATTACK_SKILLS version would result in actor 1's attack
  # skill being skill 1, actor 7's attack skill being skill 24, and any other
  # actor's attack skill being whatever DEFAULT_ATTACK_SKILL is set to.
  ABAGS_ACTOR_ATTACK_SKILLS = {
    #1 => 1
  }
  
  # The skill ID of the skill to use if there is not an actor-specific guard
  # skill set.
  # 2 is the normal default guard skill.
  DEFAULT_GUARD_SKILL = 2
  
  # ABAGS_ACTOR_GUARD_SKILLS stores actorIDs tied to the skillIDs that should be
  # used for the specific actor's guard skill.
  #
  # Note: Do not try to designate multiple skills for the same actor.
  #
  # format:
  #   actorID => skillID
  # Ex.
  # ABAGS_ACTOR_GUARD_SKILLS = {
  #   1 => 1,
  #   7 => 24
  # }
  # The above ABAGS_ACTOR_GUARD_SKILLS version would result in actor 1's guard
  # skill being skill 1, actor 7's gaurd skill being skill 24, and any other
  # actor's guard skill being whatever DEFAULT_GUARD_SKILL is set to.
  ABAGS_ACTOR_GUARD_SKILLS = {
    #1 => 2
  }
  
  # __END OF MODIFIABLE CONSTANTS__
end



# BEGINNING OF SCRIPTING ====================================================
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Aliased attack_skill_id() used to get an actor-specific attack skillID
  # * to use if one exists. Otherwise DEFAULT_ATTACK_SKILL is used.
  # * Returns the appropriate skillID number.
  #--------------------------------------------------------------------------
  alias after_abags_attack_skill_return attack_skill_id
  def attack_skill_id
    # set the attackSkillID to return as the default attack skill to start with
    attackSkillID = ABAGS::DEFAULT_ATTACK_SKILL
    
    # if the current BattlerBase object is a Actor, and if the actor's ID
    # is present in the ABAGS_ACTOR_ATTACK_SKILLS hash, then use the
    # designated actor-specific attack skillID.
    if (self.kind_of?(Game_Actor))
      if (ABAGS::ABAGS_ACTOR_ATTACK_SKILLS.has_key?(self.id))
        # set the attackSkillID to the actor-designated one
        attackSkillID = ABAGS::ABAGS_ACTOR_ATTACK_SKILLS[self.id]
      end
    end
      
    # The original method won't be reached/used and cannot be because
    # it explicitly returns a number,
    # so the attackSkillID is explicitly returned here.
    return attackSkillID
    
    # only line of original method -> return 1
    after_abags_attack_skill_return # call original method
  end
  #--------------------------------------------------------------------------
  # * Aliased guard_skill_id() used to get an actor-specific guard skillID
  # * to use if one exists. Otherwise DEFAULT_GUARD_SKILL is used.
  # * Returns the appropriate skillID number.
  #--------------------------------------------------------------------------
  alias after_abags_guard_skill_return guard_skill_id
  def guard_skill_id
    # set the guardSkillID to return as the default guard skill to start with
    guardSkillID = ABAGS::DEFAULT_GUARD_SKILL
    
    # if the current BattlerBase object is a Actor, and if the actor's ID
    # is present in the ABAGS_ACTOR_GUARD_SKILLS hash, then use the
    # designated actor-specific guard skillID.
    if (self.kind_of?(Game_Actor))
      if (ABAGS::ABAGS_ACTOR_GUARD_SKILLS.has_key?(self.id))
        # set the guardSkillID to the actor-designated one
        guardSkillID = ABAGS::ABAGS_ACTOR_GUARD_SKILLS[self.id]
      end
    end
    
    # The original method won't be reached/used and cannot be because
    # it explicitly returns a number,
    # so the guardSkillID is explicitly returned here.
    return guardSkillID
    
    # only line of original method -> return 2
    after_abags_guard_skill_return # call original method
  end
  
end
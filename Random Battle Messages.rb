# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-RandBattleMsg"] = true
# END OF IMPORT SECTION

# Script:           Random Battle Messages
# Author:           Liam
# Version:          1.0.2
# Description:
# This script allows you to have a random message for when a fight begins
# and ends. You can make a list of messages to use for "emerging" and
# "victory".
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
# All you need to do is modify the RBM_EMERGE_MESSAGE and RBM_VICTORY_MESSAGE
# lists to contain the possible messages you want to be used.
#
# Note: Messages are not restricted to particular types of enemies, so
# make the messages fairly generic.
#
# Note 2: %s represents the enemy name for emerge messages, and it
# represents the party's name for victory messages
#
# Note 3: \n represents a "new line". New lines do not need to have spaces
# around them.
#
#   Examples:
# RBM_EMERGE_MESSAGES =
# [
#   "%s appeared!", "%s blocks your path!", "%s gets all up in your face!"
#   "%s just used the catchphrase\nthey've been rehearsing!"
# }
#
# RBM_VICTORY_MESSAGES =
# [
#   "%s won the battle,", "%s beat them up!", "%s decimated the opponent!",
#   "%s will live another day!"
# ]
#
# The above settings will result in the emerge/victory message shown there
# to be chosen at random when an enemy appears or the party is victorious.
#
# Note: "%s just used the catchphrase\nthey've been rehearsing!"
# will display as
#    EnemyName just used the catchphrase
#    they've been rehearsing!
#
#
# __Modifiable Constants__
module RBM
  RBM_EMERGE_MESSAGES =
  [
    "%s is the first default emerge message!", "%s is the second default emerge message!"
  ]
  
  RBM_VICTORY_MESSAGES =
  [
    "%s is the first default victory message!", "%s is the second default victory message!"
  ]
  
  # __END OF MODIFIABLE CONSTANTS__
end



# BEGINNING OF SCRIPTING ====================================================
module Vocab
  #--------------------------------------------------------------------------
  # * New method used to return a random message when starting a battle.
  # * messages will appear with any enemy, so make sure to make messages
  # * fairly generic.
  #--------------------------------------------------------------------------
  def self.generate_emerge_message
    # get random number out of the the list of emerge messages
    randomNumber = rand(RBM::RBM_EMERGE_MESSAGES.length)
    # return an emerge message using the generated random number
    return RBM::RBM_EMERGE_MESSAGES[randomNumber]
  end
  
  #--------------------------------------------------------------------------
  # * New method used to return a random message after winning a battle.
  # * messages will appear with any enemy, so make sure to make messages
  # * fairly generic.
  #--------------------------------------------------------------------------
  def self.generate_victory_message
    # get random number out of the the list of victory messages
    randomNumber = rand(RBM::RBM_VICTORY_MESSAGES.length)
    # return a victory message using the generated random number
    return RBM::RBM_VICTORY_MESSAGES[randomNumber]
  end
  
end


module BattleManager
  #--------------------------------------------------------------------------
  # * Overridden battle_start() method used to add a message using the
  # * new generate_emerge method in Vocab
  #--------------------------------------------------------------------------
  def self.battle_start
    $game_system.battle_count += 1
    $game_party.on_battle_start
    $game_troop.on_battle_start
    $game_troop.enemy_names.each do |name|
    # This is the only line different from the base method. It calls
    # Vocab's method generate_emerge_message instead of its constant Emerge.
    $game_message.add(sprintf(Vocab.generate_emerge_message, name))
    end
    if @preemptive
      $game_message.add(sprintf(Vocab::Preemptive, $game_party.name))
    elsif @surprise
      $game_message.add(sprintf(Vocab::Surprise, $game_party.name))
    end
    wait_for_message
  end
  
  #--------------------------------------------------------------------------
  # * Overridden process_victory method used to add a message using the
  # * new generate_victory_method method in Vocab
  #--------------------------------------------------------------------------
  def self.process_victory
    play_battle_end_me
    replay_bgm_and_bgs
    # This is the only line different from the base method. It calls
    # Vocab's method generate_victory_message instead of its constant Victory.
    $game_message.add(sprintf(Vocab.generate_victory_message, $game_party.name))
    display_exp
    gain_gold
    gain_drop_items
    gain_exp
    SceneManager.return
    battle_end(0)
    return true
  end
  
end
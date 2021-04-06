# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-fakeShowPictures"] = true
# END OF IMPORT SECTION

# Script:           Fake Show Pictures
# Author:           Liam
# Version:          1.0
# Description:
# This script allows the user and other scripts to use "pictures", while
# not being stored or displayed using the same methods as normal pictures.
# Additionally, unlike normal pictures, these pictures can be displayed
# in menus.
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
# To use this script, place the script above ALL other scripts that use
# this script in your script list. If you only have this script because
# it is required for other scripts, then you are done setting up the script.
#
# If you want to use this script in your own script, then you will need to
# use the script calls in the "Script Calling" section further down
# in this script. You will need to alias the initialize() method
# in Game_Screen to set up a new Game_Pictures object, as well as manage
# the fake picture depth level (so fake pictures of various types do not end
# up on the same depth/z level).
# 
#
#   Script Calling:
# To modify a fakePicture, first you need to get the associated
# Game_Screen object which holds the fake picture Game_Pictures objects.
# This can be done with a different line of script depending on what
# you are doing.
#
#   screen = $game_party.in_battle ? $game_troop.screen : $game_map.screen              # and etc.
# Line to set up the screen to use on the map or in battle.
#
#   screen = @fakePictureSpriteset.getFakePictureGameScreen
# Line to set up the screen to use when in menu classes.
# (not to be used in any sort of game eventing)
#
# After you've obtained your current game screen, you can access fake
# picture lists by the fakePictureType
#
# Below is the script line used to show a fake picture. Below that script
# line are explanations for the parameters of the script line.
#   screen.fakePictures["fakePictureType"][pictureIndex].show("fileName", position, x, y, x zoom, y zoom, opacity, blend type)
# fileName is the name of the picture in your pictures folder
# x and y are the x and y positions of the picture relative to the origin
# x and y zoom is how much the picture is zoomed in on the x/y axis. (100 is the default zoom level)
# opacity is the opacity of the picture from 0 to 255
# position controls how the pictures origin is set ( [0] Top Left, [1] Center )
# blend type settings are ( [0] Normal, [1] Add, [2] Sub )
#
# screen.fakePictures["pictureType"][pictureIndex].erase
# Line used to erase fake picture of a specified type at a given pictureIndex.
#
# You may also want to get the fake pictures list you are currently using
# to simplify script calls for fake pictures.
#   fakePicturesList = FSP.getFakePictureList(screen, "fakePictureType")
# AND THEN fakePicturesList[pictureIndex].show(...)
#
# screen.clear_fake_pictures
# Erase all fake pictures.
#
# screen.clear_specific_picture_type("pictureType")
# Clear all the fakePictures of a specified picture type.
#
#
# __Modifiable Constants__
module FSP
  # The "depth" of where fake pictures are located on the screen.
  #
  # Set by default so that fake pictures are above all the normal viewports.
  #
  # Change this value if other scripts have conflicting Z-levels with this
  # one is some way.
  FAKE_PICTURES_VIEWPORT_Z_LEVEL = 600
  
  # The name of a fake picture type not used by any other scripts that
  # you can use to test out how fake pictures work. Use this name
  # as the "pictureType" in script calls on the game map to try it out.
  GENERIC_FAKE_PICTURE_TYPE = "genericFakePictures"
  
  # __END OF MODIFIABLE CONSTANTS__
  
  
  
# BEGINNING OF SCRIPTING ====================================================
  #--------------------------------------------------------------------------
  # * New method used to get the picture depth level to used based off of
  # * the picture type. A higher level is closer to the screen. This method
  # * is aliased in scripts that use this script to function, and
  # * depth levels for particular picture types are set in those aliased methods.
  # * This method is not actually used by any part of this script, but is
  # * here just in case it would be useful to get the fake picture depth
  # * level based on the fake picture type.
  #--------------------------------------------------------------------------
  def self.getFakePictureDepthLevel(pictureType)
    # explicit returns will be used here in other scripts to
    # return values for their fake picture types
    
    # if the pictureType is the generic fake picture type, then
    # return 0 and the fakePictureDepthLevel
    
    # start with finalDepthLevel = 500 as a default
    finalDepthLevel = 500
    
    # return finalDepthLevel implicitly
    finalDepthLevel
  end
  
  
  #--------------------------------------------------------------------------
  # * New method used to simplify getting the desired fakePictures picture
  # * list out of a game screen object.
  #--------------------------------------------------------------------------
  def self.getFakePictureList(gameScreen, fakePictureType)
    return (gameScreen.fakePictures[fakePictureType])
  end
  
end


class Game_Screen
  # New variable used to store a hash which contains arrays of "fake pictures",
  # Game_Pictures objects.
  attr_reader   :fakePictures
  
  #--------------------------------------------------------------------------
  # * Aliased Game_Screen initialize() method used to initialize the fake
  # * game pictures. This method will be aliased in other scripts that
  # * use this script to set up particular fake picture types.
  #--------------------------------------------------------------------------
  alias after_fsp_fakePictures_init initialize
  def initialize
    # initialize the fake pictures hash if not already initialized
    if (@fakePictures.nil?)
      @fakePictures = {}
    end
    
    # initialize the generic fake pictures list to a new Game_Pictures array/object
    @fakePictures[FSP::GENERIC_FAKE_PICTURE_TYPE] = Game_Pictures.new
    # set the fake picture depth level to 0, any other scripts using this
    # script will set higher depth levels so pictures do not clash in terms
    # of depth levels
    @fakePictures[FSP::GENERIC_FAKE_PICTURE_TYPE].setFakePictureDepth(0)
    
    # The fake picture data types will be added with aliased methods
    # in the other scripts that use this script in this section
    
    # Call Original Method
    after_fsp_fakePictures_init
  end
  
  #--------------------------------------------------------------------------
  # * Aliased clear_pictures() method used to erase all pictures in the
  # * fakePictures hash.
  #--------------------------------------------------------------------------
  alias after_fsp_clear_fakePictures clear_pictures
  def clear_pictures
    # for each type of fake pictures used, erase all picutes in
    # associated picture list
    @fakePictures.each do |keyFakePictureType, valuePictureList|
      # erase each picture in the picture list being dealt with
      valuePictureList.each do |currPicture|
        # update the individual pictures
        currPicture.erase
      end
    end
    
    # Call Original Method
    after_fsp_clear_fakePictures
  end
  
  #--------------------------------------------------------------------------
  # * New method to clear all fake pictures (but not normal pictures).
  #--------------------------------------------------------------------------
  def clear_fake_pictures
    # for each type of fake pictures used, erase all picutes in
    # associated picture list
    @fakePictures.each do |keyFakePictureType, valuePictureList|
      # erase each picture in the picture list being dealt with
      valuePictureList.each do |currPicture|
        # update the individual pictures
        currPicture.erase
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to clear the pictures for a specific type of
  # * fake picture.
  #--------------------------------------------------------------------------
  def clear_specific_picture_type(pictureType)
    # get the array to clear from fakePictures
    pictureListToClear = @fakePictures[pictureType]
    # erase each picture in the picture list being dealt with
    pictureListToClear.each do |currPicture|
      # update the individual pictures
      currPicture.erase
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased update() method for Game_Screen used to update the fake pictures.
  #--------------------------------------------------------------------------
  alias before_fsp_fakePictures_update update
  def update
    # Call original method
    before_fsp_fakePictures_update
    
    # update the fake pictures
    update_fake_pictures
  end

  #--------------------------------------------------------------------------
  # * New method used to update the fake pictures.
  #--------------------------------------------------------------------------
  def update_fake_pictures
    # for each type of fake pictures used, update the associated picture list
    @fakePictures.each do |keyFakePictureType, valuePictureList|
      # update each picture in the picture list being dealt with
      valuePictureList.each do |currPicture|
        # update the individual pictures
        currPicture.update
      end
    end
  end
end


class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Aliased create_viewports() method for Spriteset_Map used to create
  # * the fake pictures viewport.
  #--------------------------------------------------------------------------
  alias before_fsp_map_create_fakePicturesViewport create_viewports
  def create_viewports
    # Call original method
    before_fsp_map_create_fakePicturesViewport
    
    # initialize new viewport for the fake pictures
    @fakePicturesViewport = Viewport.new
    # set the z-level (depth) to the user-defined FAKE_PICTURES_VIEWPORT_Z_LEVEL
    @fakePicturesViewport.z = FSP::FAKE_PICTURES_VIEWPORT_Z_LEVEL
  end
  
  #--------------------------------------------------------------------------
  # * Aliased create_pictures() method for Spriteset_Map used to create
  # * the fake picture sprites hash.
  #--------------------------------------------------------------------------
  alias before_fsp_map_create_fakepictureSprites create_pictures
  def create_pictures
    # only line of original method -> @picture_sprites = []
    # Call original method
    before_fsp_map_create_fakepictureSprites
    
    @fake_picture_sprites = {} # initialize new fake picture sprites hash
  end
  
  #--------------------------------------------------------------------------
  # * Aliased dispose_pictures() method for Spriteset_Map used to free
  # * the memory taken by the fake picture sprites.
  #--------------------------------------------------------------------------
  alias before_fsp_map_dispose_fakePictureSprites dispose_pictures
  def dispose_pictures
    # only line of original method -> @picture_sprites.compact.each {|sprite| sprite.dispose }
    # Call original method
    before_fsp_map_dispose_fakePictureSprites
    
    # dispose all picture sprites for all fake picture types
    @fake_picture_sprites.each do |keyFakePictureType, valueFakePictureSpriteList|
      valueFakePictureSpriteList.compact.each {|sprite| sprite.dispose }
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased dispose_viewports() method for Spriteset_Map used to free
  # * the memory taken by the fakePicturesViewport.
  #--------------------------------------------------------------------------
  alias before_fsp_map_free_fakePicturesViewport dispose_viewports
  def dispose_viewports
    # Call original method
    before_fsp_map_free_fakePicturesViewport
    
    @fakePicturesViewport.dispose
  end
  
  #--------------------------------------------------------------------------
  # * Aliased update_pictures() method for Spriteset_Map used to update
  # * all the fake picture sprites.
  #--------------------------------------------------------------------------
  alias before_fsp_map_update_fakePicturesSprites update_pictures
  def update_pictures
    # Call original method
    before_fsp_map_update_fakePicturesSprites
    
    # update all the sprites for all the fake pictures
    $game_map.screen.fakePictures.each do |keyFakePictureType, valuePictureList|
      # get the fakePictureDepth for the current fakePictures list
      fakePictureDepth = $game_map.screen.fakePictures[keyFakePictureType].picturesArrayFakePictureDepth
      # get current fake picture type
      currFakePictureType = keyFakePictureType
      
      # update each picture in the picture list being dealt with
      valuePictureList.each do |currPicture|
        # if there is no array for the current fake picture type,
        # create it
        if (@fake_picture_sprites[currFakePictureType].nil?)
          @fake_picture_sprites[currFakePictureType] = []
        end
        # get the current picture sprites array being used
        currPictureSpritesArray = @fake_picture_sprites[currFakePictureType]
        
        # update the individual picture sprite data
        currPictureSpritesArray[currPicture.number] ||= Sprite_Fake_Picture.new(@fakePicturesViewport, currPicture, keyFakePictureType, fakePictureDepth)
        currPictureSpritesArray[currPicture.number].update
      end
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Aliased update_viewports() method for Spriteset_Map used to update
  # * the fakePicturesViewport.
  #--------------------------------------------------------------------------
  alias before_fsp_map_update_fakePictureViewport update_viewports
  def update_viewports
    # Call original method
    before_fsp_map_update_fakePictureViewport
    
    @fakePicturesViewport.update
  end
  
end


class Spriteset_Battle
  #--------------------------------------------------------------------------
  # * Aliased create_viewports() method for Spriteset_Battle used to create
  # * the fake pictures viewport.
  #--------------------------------------------------------------------------
  alias before_fsp_battle_create_fakePicturesViewport create_viewports
  def create_viewports
    # Call original method
    before_fsp_battle_create_fakePicturesViewport
    
    # initialize new viewport for the fake pictures
    @fakePicturesViewport = Viewport.new
    # set the z-level (depth) to the user-defined FAKE_PICTURES_VIEWPORT_Z_LEVEL
    @fakePicturesViewport.z = FSP::FAKE_PICTURES_VIEWPORT_Z_LEVEL
  end
  
  #--------------------------------------------------------------------------
  # * Aliased create_pictures() method for Spriteset_Battle used to create
  # * the fake picture sprites hash.
  #--------------------------------------------------------------------------
  alias before_fsp_battle_create_fakepictureSprites create_pictures
  def create_pictures
    # only line of original method -> @picture_sprites = []
    # Call original method
    before_fsp_battle_create_fakepictureSprites
    
    @fake_picture_sprites = {} # initialize new fake picture sprites hash
  end
  
  #--------------------------------------------------------------------------
  # * Aliased dispose_pictures() method for Spriteset_Battle used to free
  # * the memory taken by the fake picture sprites.
  #--------------------------------------------------------------------------
  alias before_fsp_battle_dispose_fakePictureSprites dispose_pictures
  def dispose_pictures
    # only line of original method -> @picture_sprites.compact.each {|sprite| sprite.dispose }
    # Call original method
    before_fsp_battle_dispose_fakePictureSprites
    
    # dispose all picture sprites for all fake picture types
    @fake_picture_sprites.each do |keyFakePictureType, valueFakePictureSpriteList|
      valueFakePictureSpriteList.compact.each {|sprite| sprite.dispose }
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased dispose_viewports() method for Spriteset_Battle used to free
  # * the memory taken by the fakePicturesViewport.
  #--------------------------------------------------------------------------
  alias before_fsp_battle_free_fakePicturesViewport dispose_viewports
  def dispose_viewports
    # Call original method
    before_fsp_battle_free_fakePicturesViewport
    
    @fakePicturesViewport.dispose
  end
  
  #--------------------------------------------------------------------------
  # * Aliased update_pictures() method for Spriteset_Battle used to update
  # * all the fake picture sprites.
  #--------------------------------------------------------------------------
  alias before_fsp_battle_update_fakePicturesSprites update_pictures
  def update_pictures
    # Call original method
    before_fsp_battle_update_fakePicturesSprites
    
    # update all the sprites for all the fake pictures
    $game_troop.screen.fakePictures.each do |keyFakePictureType, valuePictureList|
      # get the fakePictureDepth for the current fakePictures list
      fakePictureDepth = $game_troop.screen.fakePictures[keyFakePictureType].picturesArrayFakePictureDepth
      # get current fake picture type
      currFakePictureType = keyFakePictureType
      
      # update each picture in the picture list being dealt with
      valuePictureList.each do |currPicture|
        # if there is no array for the current fake picture type,
        # create it
        if (@fake_picture_sprites[currFakePictureType].nil?)
          @fake_picture_sprites[currFakePictureType] = []
        end
        # get the current picture sprites array being used
        currPictureSpritesArray = @fake_picture_sprites[currFakePictureType]
        
        # create/update the individual picture sprite data
        currPictureSpritesArray[currPicture.number] ||= Sprite_Fake_Picture.new(@fakePicturesViewport, currPicture, keyFakePictureType, fakePictureDepth)
        currPictureSpritesArray[currPicture.number].update
      end
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Aliased update_viewports() method for Spriteset_Battle used to update
  # * the fakePicturesViewport.
  #--------------------------------------------------------------------------
  alias before_fsp_battle_update_fakePictureViewport update_viewports
  def update_viewports
    # Call original method
    before_fsp_battle_update_fakePictureViewport
    
    @fakePicturesViewport.update
  end
  
end


class Scene_Base
  #--------------------------------------------------------------------------
  # * Aliased start() method for Scene_Base used to set up s fake
  # * picture spriteset so fake pictures can be displayed in any menu.
  #--------------------------------------------------------------------------
  alias before_fsp_fakePictureSpriteset_create start
  def start
    # only line of original method -> create_main_viewport
    # Call original method
    before_fsp_fakePictureSpriteset_create
    
    # create the fakePictureSpriteset
    create_fakePictureSpriteset
  end
  #--------------------------------------------------------------------------
  # * New method used to create the new fakePictureSpriteset. Doesn't
  # * actually create it in Scene_Map and Scene_Battle.
  #--------------------------------------------------------------------------
  def create_fakePictureSpriteset
    # if the scene is the map or battle scene, set up the
    # dake picture spriteset, otherwise, leave it to those scenes
    # to set up their own fakePicture data
    if (self.kind_of?(Scene_Map) || self.kind_of?(Scene_Battle))
      @fakePictureSpriteset = nil # leave as nil
    else
      # create the new fake picture menu spriteset
      @fakePictureSpriteset = Spriteset_Fake_Pictures_Menu.new
    end
  end
  #--------------------------------------------------------------------------
  # * Aliased update_basic() method for Scene_Base used to update
  # * the fakePictureSpritset if it exists.
  #--------------------------------------------------------------------------
  alias before_fsp_fakePictureSpriteset_update update_basic
  def update_basic
    # Call original method
    before_fsp_fakePictureSpriteset_update
    
    # update the fakePictureSpriteset
    update_fakePictureSpriteset
  end
  #--------------------------------------------------------------------------
  # * New method used to update the fakePictureSpriteset. Doesn't actually
  # * update it in Scene_Map and Scene_Battle (because that causes
  # * @fakePictureSpriteset to be nil).
  #--------------------------------------------------------------------------
  def update_fakePictureSpriteset
    # if the fakePictureSpriteset exists, then update it
    if (!@fakePictureSpriteset.nil?)
      @fakePictureSpriteset.update
    end
  end
  #--------------------------------------------------------------------------
  # * Aliased teminate() method for Scene_Base used to dispose of the
  # * fakePictureSpriteset if it exists.
  #--------------------------------------------------------------------------
  alias before_fsp_fakePictureSpriteset_terminate terminate
  def terminate
    # Call original method
    before_fsp_fakePictureSpriteset_terminate
    
    # dispose the fakePictureSpriteset
    dispose_fakePictureSpriteset
  end
  #--------------------------------------------------------------------------
  # * New method used to dispose the fakePictureSpriteset. Doesn't actually
  # * update it in Scene_Map and Scene_Battle (that causes
  # * @fakePictureSpriteset to be nil).
  #--------------------------------------------------------------------------
  def dispose_fakePictureSpriteset
    # if the fakePictureSpriteset exists, then dispose it
    if (!@fakePictureSpriteset.nil?)
      @fakePictureSpriteset.dispose
    end
  end
end


#==============================================================================
# ** Spriteset_Fake_Pictures_Menu
#------------------------------------------------------------------------------
# ** This class is a nearly a copy of Spriteset_Map, but with all of the
# ** non-picture-related stuff removed. Stores all the fake picture
# ** sprites. This class allows fake pictures to be used in menus.
#==============================================================================
class Spriteset_Fake_Pictures_Menu
  #--------------------------------------------------------------------------
  # * New method used to initialize the fake pictures spiteset and the data
  # * it contains.
  #--------------------------------------------------------------------------
  def initialize
    create_viewports
    create_pictures
    create_temp_game_screen
    update
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create the viewport used to display the
  # * fake pictures.
  #--------------------------------------------------------------------------
  def create_viewports
    # initialize new viewport for the fake pictures
    @fakePicturesViewport = Viewport.new
    # set the z-level (depth) to the user-defined FAKE_PICTURES_VIEWPORT_Z_LEVEL
    @fakePicturesViewport.z = FSP::FAKE_PICTURES_VIEWPORT_Z_LEVEL
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create the array that stores the fake picture sprites.
  #--------------------------------------------------------------------------
  def create_pictures
    @picture_sprites = {}
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create a temporary Game_Screen object so it can be
  # * a Game_Screen object can be accessed during menus.
  #--------------------------------------------------------------------------
  def create_temp_game_screen
    @fake_picture_game_screen = Game_Screen.new
  end
  
  #--------------------------------------------------------------------------
  # * New method used to free all the objects that take up memory.
  #--------------------------------------------------------------------------
  def dispose
    # clear the temporary game screen
    @fake_picture_game_screen.clear
    # dispose all objects (pictures and viewports)
    dispose_pictures
    dispose_viewports
  end
  
  #--------------------------------------------------------------------------
  # * New method used to free the memory storing fake picture sprites.
  #--------------------------------------------------------------------------
  def dispose_pictures
    # dispose all picture sprites for all fake picture types
    @picture_sprites.each do |keyFakePictureType, valueFakePictureSpriteList|
      valueFakePictureSpriteList.compact.each {|sprite| sprite.dispose }
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to free the memory storing the fakePicturesViewport.
  #--------------------------------------------------------------------------
  def dispose_viewports
    # dispose the fake picture viewport
    @fakePicturesViewport.dispose
  end
  
  #--------------------------------------------------------------------------
  # * New method used to do a frame update for all stored objects that need it.
  #--------------------------------------------------------------------------
  def update
    # update the temporary game screen
    @fake_picture_game_screen.update
    # update all data (pictures and viewports)
    update_pictures
    update_viewports
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update the stored fake picture sprites.
  #--------------------------------------------------------------------------
  def update_pictures
    # update all the fake picture sprites for all the types of fake pictures
    @fake_picture_game_screen.fakePictures.each do |keyFakePictureType, valuePictureList|
      # get the fakePictureDepth for the current fakePictures list
      fakePictureDepth = @fake_picture_game_screen.fakePictures[keyFakePictureType].picturesArrayFakePictureDepth
      # get current fake picture type
      currFakePictureType = keyFakePictureType
      
      # update each picture in the picture list being dealt with
      valuePictureList.each do |currPicture|
        # if there is no array for the current fake picture type,
        # create it
        if (@picture_sprites[currFakePictureType].nil?)
          @picture_sprites[currFakePictureType] = []
        end
        # get the current picture sprites array being used
        currPictureSpritesArray = @picture_sprites[currFakePictureType]
        
        # create/update the individual picture sprite data
        currPictureSpritesArray[currPicture.number] ||= Sprite_Fake_Picture.new(@fakePicturesViewport, currPicture, keyFakePictureType, fakePictureDepth)
        @picture_sprites[currFakePictureType][currPicture.number].update
      end
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update the fake pictures viewport.
  #--------------------------------------------------------------------------
  def update_viewports
    # update the fake pictures viewport
    @fakePicturesViewport.update
  end
  
  #--------------------------------------------------------------------------
  # * New method used to return the temporary game screen object being used.
  #--------------------------------------------------------------------------
  def getFakePictureGameScreen
    @fake_picture_game_screen
  end
end


class Game_Pictures
  # New variable used to store the "fake picture depth" for the stored pictures.
  # The z-levels of the stored pictures will start at their
  # index/number PLUS the fake picture depth.
  attr_reader :picturesArrayFakePictureDepth
  
  #--------------------------------------------------------------------------
  # * New method used to set picturesArrayFakePictureDepth.
  #--------------------------------------------------------------------------
  def setFakePictureDepth(fakePictureDepth)
    @picturesArrayFakePictureDepth = fakePictureDepth
  end
  
  
  #--------------------------------------------------------------------------
  # * Aliased initialize() method for Game_Pictures used to initialize
  # * picturesArrayFakePictureDepth to -1 (marking that the array is
  # * not one storing fake pictures).
  #--------------------------------------------------------------------------
  alias after_pictures_array_fake_picture_depth_init initialize
  def initialize
    @picturesArrayFakePictureDepth = -1 # -1 to mark that fake pictures are not stored
    
    # only line of original method -> @data = []
    # Call original method
    after_pictures_array_fake_picture_depth_init
  end
end


#==============================================================================
# ** Sprite_Fake_Picture
#------------------------------------------------------------------------------
# ** This class is a nearly a copy of Sprite_Picture, but modified so that
# ** a particular sprite depth level can be set so fake pitures don't
# ** end up on the same sprite depth level in their viewports.
#==============================================================================
class Sprite_Fake_Picture < Sprite
  # New variable used to store the z-level (or depth) the picture should have
  # before its picture number is taken into account. This should be set to 0
  # by default, unless there is a particular number given as a parameter when
  # initializing the object.
  attr_reader :pictureSpriteDepthLevelStart
  
  # New variable used to store the fakePicture type for the picture sprite.
  # Helps decide the filename that should be used to get the picture file
  # out of the Cache.
  attr_reader :fakePictureType
  
  #--------------------------------------------------------------------------
  # * New(ly edited) method used to initialize the fakePictureType and
  # * newPictureSpriteDepthLevelStart variables.
  #--------------------------------------------------------------------------
  def initialize(viewport, picture, newFakePictureType = "", newPictureSpriteDepthLevelStart = 0)
    super(viewport)
    @picture = picture
    
    # NEW LINES TO SET fakePictureType and pictureSpriteDepthLevelStart
    @fakePictureType = newFakePictureType
    @pictureSpriteDepthLevelStart = newPictureSpriteDepthLevelStart
    # END OF NEW LINES
    
    update
  end
  
  #--------------------------------------------------------------------------
  # * New dispose() method copied from Sprite_Picture used to dispose the
  # * bitmap associated with the fake picture sprite object.
  #--------------------------------------------------------------------------
  def dispose
    bitmap.dispose if bitmap
    super
  end
  
  #--------------------------------------------------------------------------
  # * New update() method copied from Sprite_Picture used to do frame updates
  # * for everything that needs it.
  #--------------------------------------------------------------------------
  def update
    super
    update_bitmap
    update_origin
    update_position
    update_zoom
    update_other
  end
  
  #--------------------------------------------------------------------------
  # * New(ly edited) method used to update the fakePicture bitmap.
  #--------------------------------------------------------------------------
  def update_bitmap
    if @picture.name.empty?
      self.bitmap = nil
    else
      # NEW LINE TO GET THE fakePicture bitmap from the Cache
      self.bitmap = Cache.fakePicture(@picture.name, @fakePictureType)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New update_origin() method copied from Sprite_Picture used to update
  # * the fake picture's origin.
  #--------------------------------------------------------------------------
  def update_origin
    if @picture.origin == 0
      self.ox = 0
      self.oy = 0
    else
      self.ox = bitmap.width / 2
      self.oy = bitmap.height / 2
    end
  end
  
  #--------------------------------------------------------------------------
  # * New update_position() method copied from Sprite_Picture used to update
  # * the fake picture's position.
  #--------------------------------------------------------------------------
  def update_position
    self.x = @picture.x
    self.y = @picture.y
    # NEW LINE TO ADD pictureSpriteDepthLevelStart to the picture number
    # when setting the picture sprite depth level.
    self.z = @picture.number + @pictureSpriteDepthLevelStart
  end
  
  #--------------------------------------------------------------------------
  # * New update_zoom() method copied from Sprite_Picture used to update
  # * the fake picture's zoom.
  #--------------------------------------------------------------------------
  def update_zoom
    self.zoom_x = @picture.zoom_x / 100.0
    self.zoom_y = @picture.zoom_y / 100.0
  end
  
  #--------------------------------------------------------------------------
  # * New update_other() method copied from Sprite_Picture used to update
  # * the various properties of the fake picture's sprite.
  #--------------------------------------------------------------------------
  def update_other
    self.opacity = @picture.opacity
    self.blend_type = @picture.blend_type
    self.angle = @picture.angle
    self.tone.set(@picture.tone)
  end
  
end


module Cache
  #--------------------------------------------------------------------------
  # * New method used to get the fake picture graphic based off of the
  # * filename. Uses "Graphic/Pictures" as the default filepath, but
  # * other scripts may use different ones by aliasing this method.
  # * fakePictureType determines what full filepath will be used.
  #--------------------------------------------------------------------------
  def self.fakePicture(filename, fakePictureType = "")
    # Aliased methods would run code here, and potentially they might explicitly
    # return bitmaps with other filenames defined by the other scripts
    
    # If no special filenames caught by the aliased versions of this
    # method, then use "Graphic/Pictures" as the default filepath and
    # return implicitly.
    load_bitmap("Graphics/Pictures/", filename)
  end
end

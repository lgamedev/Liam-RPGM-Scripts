# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-ShowPictureAchievements"] = true
# END OF IMPORT SECTION

# ----------------- ! REQUIRES 'FAKE SHOW PICTURES' SCRIPT ! ------------------
# ------------------- ! REQUIRES 'PERSISTENT DATA' SCRIPT ! -------------------
# Script:           Show Picture Achievements
# Author:           Liam
# Version:          1.0
# Description:
# This script allows you to set up a list of achievements and an achievements
# screen to display all the achievements. The achievements screen's graphics,
# layout, and the sizes of the objects on the screen can all be modified.
# There are also optional achievement popups that can pop up when you
# earn an achievement. Unlocking an achievement is done by using
# script calls. Achievements are not stored per savefile, but rather in
# persistent data.
#
# Feel free to use this script however you like, commercial or not, as long
# as you credit me. Just 'Liam' is fine.
#
# Credit to 'the iceman' for creating the default set of graphics that
# go with this script. Credit them alongside 'Liam' if you use
# any of the default graphics.
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
# To use this script, paste it in your scripts list below the "Fake Show Pictures"
# and the "Persistent Data" scripts. Modify all the settings in the
# General Settings to your liking, and if you don't want to use the
# default layout and object sizes, modify the Layout Settings.
# According to your settings (modified or default), put the achievement
# images you need in your achievement folder. A set of default images
# that will work with the default layout should be provided alongside the script.
#
#
#   Script Calls:
# Use these script calls using the "Script" command in events.
#
# spaOpenAchieveScreen
# Opens the achievement screen. This is useful if you want to tie achievements
# to a specific object in a location, or to tie it to a key item or something
# like that.
#
# spaAchieveUnlock("achievementName")
# Unlock achievement normally. Does nothing if the achievement already unlocked.
# Note that the achievementName is the achievements data name, not its title.
#
# spaAchieveUnlockNoPopup("achievementName")
# Unlocks an achievement with no popup regardless of the normal popup settings.
# Does nothing if achievement already unlocked.
#
# spaAchieveLock("achievementName")
# Locks an achievement. Mainly intended for use with testing.
#
# spaUnlockAllAchievements
# Unlocks all achievements (no popups). Mainly intended for use with testing.
#
# spaResetAllAchievements
# Resets all achievement data (locks all achievements).
#
# spaCheckAchieveUnlock("achievementName")
# Checks if a specific achievement is unlocked. Returns true if it is,
# otherwise false. You can use this script line in event conditional branches.
#
# spaCheckAllAchieveUnlock
# Checks if all achievements are unlocked. Returns true if they are,
# otherwise false. You can use this script line in event conditional branches.
#
# spaAchievesUnlockedNum
# Returns the number of unlocked achievements.
#
# spaAchievesLockedNum
# Returns the number of locked achievements.
#
# spaTotalAchievesNum
# Returns the total number of achievements.
#
#
# __Modifiable Constants__
module SPA
  # GENERAL SETTINGS BEGIN HERE
  #   =======================================================================
  
  # Misc. Settings
  #   ---------------------------------
  # The name of the folder that all of the achievement-related pictures are
  # stored in.
  # This will be a folder in your game's directory.
  #
  # Note 1: You will need to create the folder with the name you set
  # in your game's directory
  #
  # Note 2: If you want your achievements folder to be inside of the
  # graphics folder, use the name "Graphics/achievementsFolderNameHere".
  # If you want to keep the achievement-related images in the usual
  # pictures folder, then use "Graphics/Pictures" as your folder name.
  ACHIEVE_FOLDER_NAME = "achievements"
  #   ---------------------------------
  
  
  # Achievement Screen General Settings
  #   ---------------------------------
  # Determines what to call the option on menu screens for selecting
  # the achievements screen.
  ACHIEVE_SCREEN_OPTION_NAME = "Achievements"
  
  # Whether or not to put an achievement screen option on the game title screen.
  ACHIEVE_SCREEN_ON_TITLE = true
  
  # Whether or not to put an achievement screen option on the in-game menu.
  ACHIEVE_SCREEN_ON_GAME_MENU = true
  
  # The name of the background music to use on the achievements screen.
  # If the name is set to "none", whatever the current background music and
  # background sounds are will remain unaffected when the achievement screen
  # is brought up.
  # 
  # format:
  #   ["BGM name", BGM volume, BGM pitch]
  # Ex.
  #   ACHIEVE_SCREEN_BGM = ["relaxing music", 80, 100]
  ACHIEVE_SCREEN_BGM = ["none", 100, 100]
  
  # The filename to use for the achievements screen title image.
  #
  # Note: You can use a title image file with any dimensions
  # without having to modify any Layout data. This is the only
  # screen object where that is the case.
  #
  # DEFAULT DIMENSIONS ARE: 440x64
  ACHIEVE_SCREEN_TITLE_FILENAME = "achieve_screen_title"
  
  # The filename to use for the achievements screen background image.
  #
  # Note 1: The dimensions for the background image are 640x480.
  # This allows the achievements screen to work for the max resolution (640x480)
  # you can use in RPGMaker VX Ace. The actual area used for the
  # achievements screen is the space of the default RPGMaker VX Ace
  # resolution (544x416) so the achievement screen can work for that too.
  # To see where this "actual area" space is in the default background image,
  # look at the red-bordered area given in the "achievements mockup
  # with boundries" image given alongside the script.
  #
  # Note 2: If you are not using the default layout, then in the
  # Layout settings further down in the script, you should turn
  # USE_EXTRA_RESOLUTION_SPACE to "false" and then modify the resolution
  # of your background image to match the resolution of you game's screen.
  # You will also need to adjust the positions of all of your screen objects
  # in the Layout settings.
  #
  # DEFAULT DIMENSIONS ARE: 640x480
  ACHIEVE_SCREEN_BG_FILENAME = "achieve_screen_bg"
  
  # This setting stores the standard achievement data for all achievements.
  #
  # Note 1: The total number of entries in this list is the total number
  # of achievements. If the number of achievements is beyond the max amount
  # in a page (8 by default), a new achievement page will be created. New achievement pages
  # will automatically be set up as needed.
  #
  # Note 2: The achievementID of an achievement determines its
  # position in the achievements grid for the page its on, and determine
  # what page it is on if there are multiple.
  #
  # Note 3: To start a new line in a piece of text, use the escape character
  # \n in you text string.
  #
  # Note 4: If you want to use special escape characters like the ones
  # you can use in game dialogue boxes, use the escape character \e and then
  # the escape character you want to use.
  # Options-
  #   \C[colorIndex]   | Makes the text change to the color at the specified index in your "Window" image in the system graphics.
  #   \I[iconIndex]    | Draws an icon at the given index in the "IconSet" sheet in the system graphics. (May not fit perfectly depending the window containing the text)
  #   \{               | Increases text size a bit past the point the character is used.
  #   \}               | Decreases text size a bit past the point the character is used.
  # Ex. "test title 3 \e\I[24]"
  # The above text line would draw the IconSet
  #
  # format:
  #   achievementDataName => [
  #     achievementID,
  #     "achievementTitle",
  #     "achievementPopupText",
  #     "achievementDescriptionTextPreUnlock",
  #     "achievementDescriptionTextPostUnlock"
  #  ]
  # Ex.
  # ACHIEVE_DATA = {
  #   "big boss fight achieve" => [
  #      1,
  #      "The bigger they are...",
  #      "The harder they fall...",
  #      "Defeat the second area boss.",
  #      "Defeated the giant named\nBehemoth in the second\narea."
  #   ],
  #   "test 2" => [
  #      2,
  #      "test title 2",
  #      "test popup 2",
  #      "test locked 2",
  #      "test unlocked 2"
  #   ]
  # }
  ACHIEVE_DATA = {
    "big boss fight achieve" => [
      # achievement id number. determines the placement on the achievement
      # on the achievements screen
      1,
      # achievement title (used on the achievements screen and popups)
      "The bigger they are...",
      # achievement popup text, leave as "" if not used
      "The harder they fall...",
      # achievement description text before unlocking the achievement
      "Defeat the second area boss.",
      # achievement description text after unlocking the achievement
      "Defeated the giant named\nBehemoth in the second\narea."
    ],
    "test 2" => [
      2,
      "test title 2",
      "test popup 2",
      "test locked 2",
      "test unlocked 2"
    ],
    "test 3" => [
      3,
      "test title 3 \e\I[24]",
      "test popup 3",
      "test locked 3",
      "test unlocked 3"
    ],
    "test 4" => [
      4,
      "test title 4",
      "test popup 4",
      "test locked 4",
      "test unlocked 4"
    ],
    "test 5" => [
      5,
      "test title 5",
      "test popup 5",
      "test locked 5",
      "test unlocked 5"
    ],
    "test 6" => [
      6,
      "test title 6",
      "test popup 6",
      "test locked 6",
      "test unlocked 6"
    ],
    "test 7" => [
      7,
      "test title 7",
      "test popup 7",
      "test locked 7",
      "test unlocked 7"
    ],
    "test 8" => [
      8,
      "test title 8",
      "test popup 8",
      "test locked 8",
      "test unlocked 8"
    ],
    "test 9" => [
      9,
      "test title 9",
      "test popup 9",
      "test locked 9",
      "test unlocked 9"
    ]
  }
  #   ---------------------------------
  
  
  # Achievement Screen Achievement Titles Settings
  #   ---------------------------------
  # Determines the font to use for the achievement screen achievement
  # titles text.
  # If you want to use your default font, put "default."
  #
  # Note: Make sure to put the font file in a folder called "fonts" in your
  # game directory if it is not a standard font.
  ACHIEVE_SCREEN_TITLES_FONT = "default"
  
  # Determines what size font to use on the achievements screen for the
  # achievement titles text.
  ACHIEVE_SCREEN_TITLES_FONT_SIZE = 16
   
  # The filename for the "Window" image used to create a background image for
  # the titles of achievements on the achievement screen. Structure the
  # image graphic like you would with the "Window" image in the system graphics.
  # 
  # Note 1: Set to "none" to not use title text background windows.
  #
  # Note 2: Set to "default" to use your normal windowskin as the
  # background for the description text.
  ACHIEVE_SCREEN_TITLES_WINDOW_FILENAME = "achieve_screen_titles_bg_window"
  
  # The text to use as the title for achievements that have a hidden title
  # when locked.
  ACHIEVE_SCREEN_HIDDEN_TITLE_TEXT = "???"
  
  # Determines whether or not to hide all the achievement screen achievement
  # titles before they are unlocked. The text from the
  # ACHIEVE_SCREEN_HIDDEN_TITLE_TEXT will be used as the title for all
  # locked achievements.
  ACHIEVE_SCREEN_HIDE_TITLES_BEFORE_UNLOCK = false
  
  # A list of specific achievements whose title text, when the achievement 
  # is locked, should be set to the text in ACHIEVE_SCREEN_HIDDEN_TITLE_TEXT.
  #
  # format:
  #   ["achieveDataname1", "achieveDataname2", ...]
  # Ex.
  # ACHIEVE_SCREEN_HIDE_TITLES_SPECIFIC_ACHIEVES = [
  #   "big boss fight achieve", "test 2"
  # ]
  ACHIEVE_SCREEN_HIDE_TITLES_SPECIFIC_ACHIEVES = [
    "test 2"
  ]
  #   ---------------------------------
  
  
  # Achievement Screen Achievement Descriptions Settings
  #   ---------------------------------
  # Determines the font to use for the achievement screen achievement
  # descriptions text.
  # If you want to use your default font, put "default."
  #
  # Note: Make sure to put the font file in a folder called "fonts" in your
  # game directory if it is not a standard font.
  ACHIEVE_SCREEN_DESC_FONT = "default"
  
  # Determines what size font to use on the achievements screen for the
  # achievement descriptions text.
  ACHIEVE_SCREEN_DESC_FONT_SIZE = 14
  
  # The filename for the "Window" image used to create a background image for
  # the descriptions of achievements on the achievement screen. Structure the
  # image graphic like you would with the "Window" image in the system graphics.
  # 
  # Note 1: Set to "none" to not use description text background windows.
  #
  # Note 2: Set to "default" to use your normal windowskin as the
  # background for the description text.
  ACHIEVE_SCREEN_DESC_WINDOW_FILENAME = "achieve_screen_desc_bg_window"
  #   ---------------------------------
  
  
  # Achievement Image Settings
  #   ---------------------------------
  # This text makes up the first part of the image filenames for images in
  # the achievement image folder. you put the data name of the achievement at the end of this string of text
  # to get the image filename for achievements.
  #
  # Image filename format: "(ACHIEVE_FILENAME_START)(data name)"
  ACHIEVE_FILENAME_START = "achieve_img_"
  
  # This setting controls how achievement images display for achievements
  # that have not been unlocked.
  #
  # If this setting is set to "image", the "ACHIEVE_LOCKED_FILENAME" picture
  # will get used for achievements that have not been unlocked yet.
  # If this setting is set to "grayscale", the normal achievement image will
  # be put into grayscale for non-unlocked achievements.
  # If this setting is set to "none", the normal achievement image
  # will always be used.
  #
  # Options: "image", "grayscale", "none"
  USE_LOCKED_ACHIEVEMENT_IMAGE = "image"
  
  # The filename of the image to use when an achievement is not locked yet.
  # If you are not using a achievement locked image, you can set this to just
  # to just an empty string ("").
  #
  # DEFAULT DIMENSIONS ARE: 64 x 64
  ACHIEVE_LOCKED_FILENAME = "achieve_img_locked"
  
  # A list of specific achievements whose image, when locked, should be set to
  # a specific different image. The format for the specific image name in the
  # achievement image folder is: "(ACHIEVE_FILENAME_START)(data name)_locked"
  #
  # format:
  #   ["achieveDataname1", "achieveDataname2", ...]
  # Ex.
  # ACHIEVE_SPECIFIC_LOCK_IMAGES = [
  #   "big boss fight achieve", "test 2"
  # ]
  ACHIEVE_SPECIFIC_LOCK_IMAGES = [
    "test 2"
  ]
  #   ---------------------------------
  
  
  # Achievement Screen Page Settings
  #   ---------------------------------
  # The data for the sound effect to play when switching the active
  # achievement page. Will not be used if there is only one achievement page.
  # 
  # Note 1: Leave the name as just empty quotes ("") if you don't want any sound
  # when switching achievement pages.
  #
  # Note 2: If there is only 1 achievement page, this setting will not get used.
  # 
  # format:
  #   ["SE name", SE volume, SE pitch]
  # Ex.
  #   ACHIEVE_PAGE_SWITCH_SE = ["ding", 80, 100]
  ACHIEVE_PAGE_SWITCH_SE = ["", 60, 120]
  
  # The font to use for the achievement page indicator text.
  # If you want to use your default font, put "default."
  #
  # Note 1: Make sure to put the font file in a folder called "fonts" in your
  # game directory if it is not a standard font.
  #
  # Note 2: If there is only 1 achievement page, this setting will not get used.
  ACHIEVE_SCREEN_PAGE_INDICATOR_FONT = "default"
  
  # Determines what font size to use for the achievement screen page indicator text.
  # If you want to use your default font, put "default."
  #
  # Note 1: Make sure to put the font file in a folder called "fonts" in your
  # game directory if it is not a standard font.
  #
  # Note 2: If there is only 1 achievement page, this setting will not get used.
  ACHIEVE_SCREEN_PAGE_INDICATOR_FONT_SIZE = 16
  
  # This setting stores the format to use for the achievement page
  # indicator text.
  #
  # Use "currpage" as a stand-in for the current page number,
  # and "maxpage" as a stand-in for the maximum page number.
  #
  # Note: If there is only 1 achievement page, this setting will not get used.
  ACHIEVE_SCREEN_PAGE_INDICATOR_FORMAT = "<Page currpage of maxpage>"
  #   ---------------------------------
  
  
  # Achievement Popup Settings
  #   ---------------------------------
  # This setting turns on popups for achievements. If set to false,
  # popups will never appear.
  ACHIEVE_POPUPS_ON = true
  
  # The filename for the "Window" image to use to create a background image for
  # the achievement popups. Structure the image graphic like you would with
  # the "Window" image in the system graphics.
  # 
  # Note: Set to "default" to use your normal windowskin as the
  # background for the popup.
  ACHIEVE_POPUP_WINDOW_FILENAME = "achieve_popup_bg"
  
  # Set this setting to "true" to make achievement popups use separate images
  # than the achievement screen images. The format for these popup images
  # will be "(ACHIEVE_FILENAME_START)(data name)_popup"
  #
  # Note 1: Do not turn this setting on unless you are redoing the layout/sizes
  # in the achievement screen or popups.
  #
  # Note 2: If you turn this setting on, set the width/height
  # for the popup achievement images in the Layout settings.
  #
  # Image filename format: "(ACHIEVE_FILENAME_START)(data name)_popup"
  ACHIEVE_POPUP_USE_SEPARATE_IMG = false
  
  # This setting is used to show a different set of text instead of the
  # achievement title as the top text used in achievement popups.
  # For example, you may want to put "Achievement Unlocked!" as the top text
  # for all popups, and then put the actual title as the popup description.
  #
  # Note: Set it to "none" to not use the overriden text.
  ACHIEVE_POPUP_TITLE_OVERRIDE = "none"
  
  # Determines the font to use for the achievement popup text.
  # If you want to use your default font, put "default."
  #
  # Note: Make sure to put the font file in a folder called "fonts" in your
  # game directory if it is not a standard font.
  ACHIEVE_POPUP_FONT = "default"
  
  # This setting determines the size font to use for the top line of text
  # for achievement popups.
  ACHIEVE_POPUP_TOP_FONT_SIZE = 16
  
  # This setting determines the size font to use for the bottom line of text
  # for achievement popups.
  ACHIEVE_POPUP_FONT_SIZE = 14
  
  # This setting determines which corner of the screen achievement popups
  # pop up and back down from.
  #
  # Options: "topleft", "topright", "bottomright", "bottomleft"
  ACHIEVE_POPUP_CORNER = "bottomright"
  
  # The time (in seconds) that an achievement popup should stay on
  # screen for after it has fully popped up. Numbers with decimal
  # points can be used.
  ACHIEVE_POPUP_TIME = 3
  
  # The data for the sound effect to play when an achievement popup appears.
  # 
  # Note: Leave the name as just empty quotes ("") if you don't want any sound.
  # 
  # format:
  #   ["SE name", SE volume, SE pitch]
  # Ex.
  #   ACHIEVE_POPUP_SE = ["ding", 80, 100]
  ACHIEVE_POPUP_SE = ["", 80, 100]
  #   ---------------------------------
  
  
  
  # LAYOUT AND OBJECT SIZE SETTINGS BEGIN HERE
  #   =======================================================================
  # Beyond this point is options for editing/redoing the layout and
  # sizes used in the achievements screen and popups.
  # DO NOT EDIT THESE SETTINGS IF YOU WANT TO USE THE DEFAULT LAYOUT!
  
  # Misc. Layout Settings
  #   ---------------------------------
  # Normally, this script is set up to always support the default
  # rpgmaker resolution of 544x416. For larger-than-default resolutions, the
  # default resolution is still used as an internal box inside of
  # the larger-than-default screen. That internal box is then used
  # to base object positions off of. This is done to make a default
  # achievements screen that works for the default resolution and
  # increased resolutions simultaneously.
  #
  # If this setting is turned on, you are able to use the extra space
  # gained by increasing the default RPGMaker resolution.
  #
  # Note 1: If your achievement screen background image's dimensions are
  # not the largest possible RPGMaker VX Ace window size (640x480) then
  # make sure to turn this setting on!
  #
  # Note 2: If you enable this setting, make sure your achievement screen
  # background dimensions match the dimensions of your game's window.
  #
  # Note 3: If you enable this setting, then change the
  # width and height of your achievement background image 
  # to match whatever resolution you are using for your game.
  USE_EXTRA_RESOLUTION_SPACE = false
  
  # The x and y positions of the top left pixel of the achievement screen
  # background image.
  #
  # Note: I recommend not changing this unless you have a really good
  # reason to.
  #
  # DEFAULTS:
  # X -> 0
  # Y -> 0
  ACHIEVE_SCREEN_BG_X = 0
  ACHIEVE_SCREEN_BG_Y = 0
  
  # The x and y positions of the top left pixel of the achievement screen
  # title image.
  #
  # DEFAULTS:
  # X -> 52
  # Y -> 0
  ACHIEVE_SCREEN_TITLE_X = 52
  ACHIEVE_SCREEN_TITLE_Y = 0
  #   ---------------------------------
  
  
  # Achievement Page Indicator Layout Settings
  #   ---------------------------------
  # The width and height of the invisible window containing the achievement
  # screen page indicator text.
  #
  # DEFAULTS:
  # Width  -> 140
  # Height -> 20
  ACHIEVE_SCREEN_PAGE_INDICATOR_WIDTH = 140
  ACHIEVE_SCREEN_PAGE_INDICATOR_HEIGHT = 20
  
  # The x and y positions of the top left pixel of the invisible window
  # containing the achievement screen page indicator text.
  #
  # DEFAULTS: 
  # X -> 202
  # Y -> 396
  ACHIEVE_SCREEN_PAGE_INDICATOR_X = 202
  ACHIEVE_SCREEN_PAGE_INDICATOR_Y = 396
  #   ---------------------------------
  
  
  # Achievement Grid Layout Settings
  #   ---------------------------------
  # Determines how the achievements are numbered in the achievement grid.
  # Also determines how they are laid out in the grid, so it will impact
  # how non-filled achievement pages will look.
  #
  # Options: "left-right", "up-down"
  # "left-right" makes achievements numbered in the following pattern:
  #    [1]   [2]
  #    [3]   [4]
  #    [5]   [6]
  #
  # "up-down" make achievements numbered in the following pattern:
  #    [1]   [4]
  #    [2]   [5]
  #    [3]   [6]
  #
  # DEFAULT: "left-right"
  ACHIEVE_GRID_NUMBERING_SYSTEM = "left-right"
  
  # The number of achievement rows in the achievement grid.
  #
  # DEFAULT: 4
  ACHIEVE_GRID_ROW_COUNT = 4
  
  # The number of achievement columns in the achievement grid.
  #
  # DEFAULT: 2
  ACHIEVE_GRID_COL_COUNT = 2
  
  # The number of achievements in a row in the achievement grid.
  #
  # DEFAULT: 2
  ACHIEVE_PER_ROW = 2
  
  # The number of achievements in a column in the achievement grid.
  #
  # DEFAULT: 4
  ACHIEVE_PER_COL = 4
  #   ---------------------------------
  
  
  # Achievement Image Layout Settings
  #   ---------------------------------
  # The width and height of the achievement images.
  #
  # Note: Achievement images and their data get used in the achievement popups
  # unless the ACHIEVE_POPUP_USE_SEPARATE_IMG setting is on.
  #
  # DEFAULTS:
  # Width  -> 64
  # Height -> 64
  ACHIEVE_IMG_WIDTH = 64
  ACHIEVE_IMG_HEIGHT = 64
  
  # The starting x and y positions of the top left pixel of the top left
  # achievement image in the achievement grid.
  #
  # DEFAULTS: 
  # X -> 18
  # Y -> 74
  ACHIEVE_SCREEN_IMG_GRID_START_X = 18
  ACHIEVE_SCREEN_IMG_GRID_START_Y = 74
  
  # The horizontal/vertical distance between an achievement in the grid and the
  # achievement to its right or below it.
  #
  # Note 1: More specifically, the horizontal distance is the distance
  # between the right side of an achievement image and the left side
  # of the achievement image to its right.
  #
  # Note 2: More specifically, the vertical distance is the distance
  # between the underside of an achievement image and the top side
  # of the achievement image below it.
  #
  # DEFAULTS:
  # X Dist -> 197
  # Y Dist -> 18
  ACHIEVE_SCREEN_IMG_GRID_X_DIST_BETWEEN = 197
  ACHIEVE_SCREEN_IMG_GRID_Y_DIST_BETWEEN = 18
  #   ---------------------------------
  
  
  # Achievement Screen Achievement Title Windows Layout Settings
  #   ---------------------------------
  # The width and height of the individual achievement title windows.
  #
  # DEFAULTS:
  # Width  -> 179
  # Height -> 23
  ACHIEVE_SCREEN_TITLES_WIDTH = 179
  ACHIEVE_SCREEN_TITLES_HEIGHT = 23
  
  # The starting x and y positions of the top left pixel of the top left
  # achievement title window in the achievement grid.
  #
  # DEFAULTS: 
  # X -> 86
  # Y -> 68
  ACHIEVE_SCREEN_TITLES_GRID_START_X = 86
  ACHIEVE_SCREEN_TITLES_GRID_START_Y = 68
  
  # The horizontal/vertical distance between an achievement title window in
  # the grid and the achievement title window to its right or below it.
  #
  # Note: For clarification on exactly what these distances are,
  # see the notes of the achievement image "distance between" settings.
  #
  # DEFAULTS:
  # X Dist -> 82
  # Y Dist -> 59
  ACHIEVE_SCREEN_TITLES_GRID_X_DIST_BETWEEN = 82
  ACHIEVE_SCREEN_TITLES_GRID_Y_DIST_BETWEEN = 59
  #   ---------------------------------
  
  
  # Achievement Screen Achievement Description Windows Layout Settings
  #   ---------------------------------
  # the width and height of the achievement description windows
  #
  # DEFAULTS:
  # Width  -> 179
  # Height -> 52
  ACHIEVE_SCREEN_DESC_WIDTH = 179
  ACHIEVE_SCREEN_DESC_HEIGHT = 52
  
  # the starting x and y positions of the top left pixel of the top left
  # achievement description window in the achievement grid
  #
  # DEFAULTS: 
  # X -> 86
  # Y -> 93
  ACHIEVE_SCREEN_DESC_GRID_START_X = 86
  ACHIEVE_SCREEN_DESC_GRID_START_Y = 93
  
  # The horizontal/vertical distance between an achievement description window
  # in the grid and the achievement description window to its right or below it.
  #
  # Note: For clarification on exactly what these distances are,
  # see the notes of the achievement image "distance between" settings.
  #
  # DEFAULTS:
  # X Dist -> 82
  # Y Dist -> 30
  ACHIEVE_SCREEN_DESC_GRID_X_DIST_BETWEEN = 82
  ACHIEVE_SCREEN_DESC_GRID_Y_DIST_BETWEEN = 30
  #   ---------------------------------
    
  
  # Achievement Popups Layout Settings
  #   ---------------------------------
  # The width and height of the achievement popup windows.
  #
  # DEFAULTS:
  # Width  -> 240
  # Height -> 94
  ACHIEVE_POPUP_WIDTH = 240
  ACHIEVE_POPUP_HEIGHT = 94
  
  # The width and height of the achievement popup windows if
  # the achievement images used for the achievement popup windows
  # are separate from the ones on the achievement screen.
  #
  # Note: You do not need to modify this unless ACHIEVE_POPUP_USE_SEPARATE_IMG
  # is set to "true" in the Popups section of the earlier part of thes cript.
  #
  # DEFAULTS:
  # Width  -> 64 but this number is not used by default
  # Height -> 64 but this number is not used default
  ACHIEVE_POPUP_IMG_WIDTH = 64
  ACHIEVE_POPUP_IMG_HEIGHT = 64
  
  # The starting x and y positions of the top left pixel of the
  # achievement image in the achievement popup relative to
  # the top left pixel of the popup window.
  #
  # DEFAULTS:
  # X -> 14
  # Y -> 14
  ACHIEVE_POPUP_IMG_X = 14
  ACHIEVE_POPUP_IMG_Y = 14
  
  # The starting x and y positions of the top left pixel of the
  # top line of text in the achievement popup relative to
  # the top left pixel of the popup window.
  #
  # DEFAULTS:
  # X -> 88
  # Y -> 10
  ACHIEVE_POPUP_TOP_TEXT_X = 88
  ACHIEVE_POPUP_TOP_TEXT_Y = 10
  
  # The starting x and y positions of the top left pixel of the
  # bottom line of text in the achievement popup relative to
  # the top left pixel of the popup window.
  #
  # DEFAULTS:
  # X -> 88
  # Y -> 42
  ACHIEVE_POPUP_BOTTOM_TEXT_X = 88
  ACHIEVE_POPUP_BOTTOM_TEXT_Y = 42
  #   ---------------------------------
  
  # __END OF MODIFIABLE CONSTANTS__
  
  
  
# BEGINNING OF SCRIPTING ====================================================
  # the beginning part of each name used for the achievement data names
  # in the peristent data for scripts. The part after the underscore will be
  # the data name for a given achievement
  ACHIEVE_PDATA_NAME = "achieveUnlockList_"
  
  # the ending part of the name (after ACHIEVE_PDATA_NAME) for
  # the persistent data piece that holds the last accessed
  # achievement page so it can be returned to upon re-entering
  # the achievement scene.
  ACHIEVE_LAST_PAGE_ACCESSED_PDATA_NAME = "achieveLastPageAccessed"
  
  # the number of achievements per achievement page
  # 
  # DEFAULT (once calculated): 8
  ACHIEVE_PER_PAGE = (ACHIEVE_GRID_ROW_COUNT * ACHIEVE_PER_ROW)
  
  #--------------------------------------------------------------------------
  # * New method used to return a hash with the keys being achievement ids
  # * and the values being achievement data names using ACHIEVE_DATA.
  #--------------------------------------------------------------------------
  def self.getAchieveDataNameByNumHash
    achieveDataByNumHash = {}
    # For every piece of data in achieveData, adds a key
    # for the achievement id and sets it's value to the achievement's name
    ACHIEVE_DATA.each do |keyDataName, valueDataList|
      achieveDataByNumHash[valueDataList[0]] = keyDataName
    end
    
    # return the achievement data by numbers hash
    return achieveDataByNumHash
 end
  
  # Gets the ACHIEVE_DATA hash but with the achievement id numbers as
  # the keys, and the achievement names (the internally used ones, not
  # the actual achievement title) as values. This is used to
  # find the name to use when looking for the data associated with a
  # given achievement id number.
  ACHIEVE_DATA_NAME_BY_NUM = getAchieveDataNameByNumHash

  # the name used to refer to the picture data for the achievment
  # screen picture lists
  ACHIEVE_FAKE_PICTURE_TYPE = "spaPictures"
  
  # What depth level (z-level) to put the achievement pictures on
  # in the fake picture array. Set very high so it can go over everything else.
  ACHIEVE_FAKE_PICTURE_DEPTH = 5500
  
  # A constant used in the scripting, stores default rpgmaker vx ace screen height
  RPG_VX_ACE_DEFAULT_WIDTH = 544
  
  # A constant used in the scripting, stores default rpgmaker vx ace screen height
  RPG_VX_ACE_DEFAULT_HEIGHT = 416
  
  #--------------------------------------------------------------------------
  # * New method used to return the total number of achievement screen pages
  # * that there should be basaed off of the value of ACHIEVE_DATA
  # * and ACHIEVE_DATA_PER_PAGE.
  #--------------------------------------------------------------------------
  def self.achievePageCount
    # Get the amount of achievements in the achievement data, and the
    # amount of achievements on achievement screen pages
    achieveDataSize = ACHIEVE_DATA.size
    achieveDataPageSize = ACHIEVE_PER_PAGE
    
    # get the amount of fully filled achievement pages using integer division
    fullPages = (achieveDataSize / achieveDataPageSize)
    # get the amount of achievements on the achievement page that is not full
    # if such a page exists
    nonFullPageAchievementCount = (achieveDataSize % achieveDataPageSize) 
    
    finalPageCount = 0 # initialize finalPageCount to 0
    # if there are no achievements, then set the finalPageCoount to 1
    if (fullPages == 0 && nonFullPageAchievementCount == 0)
      finalPageCount = 1
    # if there is an achievement page that is not full, the final page count
    # will be the amount of full achievement pages plus 1
    elsif (nonFullPageAchievementCount != 0)
      finalPageCount = fullPages + 1
    # if there are only full achievement pages, just use that number for final page count
    else
      finalPageCount = fullPages
    end

    # return the final achievement page count to use
    return (finalPageCount)
  end
  
  # The final achievement page is obtained from the achievePageCount method.
  FINAL_ACHIEVE_PAGE = achievePageCount

  #--------------------------------------------------------------------------
  # * New method used to check if a given achievement is unlocked based
  # * on the achievements data name (a string) or id number (and integer).
  # * Returns true if the achievement is unlocked, otherwise false.
  #--------------------------------------------------------------------------
  def self.checkAchieveUnlockStatus(achieveNameOrNumber)
    if (achieveNameOrNumber.is_a?(String))
      # get the name to look for in persistent data
      persistentDataAchieveName = ACHIEVE_PDATA_NAME + achieveNameOrNumber
      
      # return the value from the persistent "other scripts" data
      return (DataManager.getPersistentData("otherScriptsPersistentData", persistentDataAchieveName))
    elsif (achieveNameOrNumber.is_a?(Integer))
      # get the name to look for in persistent data
      persistentDataAchieveName = ACHIEVE_PDATA_NAME + ACHIEVE_DATA_NAME_BY_NUM[achieveNameOrNumber]
      
      # return the value from the persistent "other scripts" data
      return (DataManager.getPersistentData("otherScriptsPersistentData", persistentDataAchieveName))
    else
      # return false if datatype of achieveNameOrNumber not recognized
      return false
    end
  end

  #--------------------------------------------------------------------------
  # * New method used to set the unlock status of a given achievement.
  # * Modifies persistent data to do this. unlockStatus of true means
  # * setting the achievement to unlocked, and unlockStatus of false
  # * means setting the achievement to locked.
  #--------------------------------------------------------------------------
  def self.changeAchieveUnlockStatus(achieveNameOrNumber, unlockStatus)
    if (achieveNameOrNumber.is_a?(String))
      # get the name to look for in persistent data
      persistentDataAchieveName = ACHIEVE_PDATA_NAME + achieveNameOrNumber
      
      # set the achievement unlock value in the persistent "other scripts" data
      DataManager.setPersistentData("otherScriptsPersistentData", persistentDataAchieveName, unlockStatus)
    elsif (achieveNameOrNumber.is_a?(Integer))
      # get the name to look for in persistent data
      persistentDataAchieveName = ACHIEVE_PDATA_NAME + ACHIEVE_DATA_NAME_BY_NUM[achieveNameOrNumber]
      
      # set the achievement unlock value in the persistent "other scripts" data
      DataManager.setPersistentData("otherScriptsPersistentData", persistentDataAchieveName, unlockStatus)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to get the x-value to use as the origin point for
  # * all achievement screen coordinates.
  #--------------------------------------------------------------------------
  def self.getAchieveScreenTopLeftX
    # first, if the extra resolution space is being used,
    # just immediately return 0
    if (SPA::USE_EXTRA_RESOLUTION_SPACE == true)
      return (0)
    end
    
    # get the default width and height of the screen for rpgmaker vx ace
    defaultWidth = RPG_VX_ACE_DEFAULT_WIDTH
    defaultHeight = RPG_VX_ACE_DEFAULT_HEIGHT

    # get the default "top left" x of the screen to use in the show picture
    # commands based off of any resolution differences between the
    # default resolution and the actual resolution
    #
    # Note, the divisions by 2 are present because half of the added
    # width (compared to the default) is added to the right half
    # of the screen, not just the left.
    topLeftX = ((Graphics.width - defaultWidth) / 2).to_i
    
    # return the top left x
    return (topLeftX)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to get the x-value to use as the origin point for
  # * all achievement screen coordinates.
  #--------------------------------------------------------------------------
  def self.getAchieveScreenTopLeftY
    # first, if the extra resolution space is being used,
    # then just immediately return 0
    if (SPA::USE_EXTRA_RESOLUTION_SPACE == true)
      return (0)
    end
    
    # get the default width and height of the screen for rpgmaker vx ace
    defaultWidth = RPG_VX_ACE_DEFAULT_WIDTH
    defaultHeight = RPG_VX_ACE_DEFAULT_HEIGHT
    
    # get the default "top left" y of the screen to use in the show picture
    # commands based off of any resolution differences between the
    # default resolution and the actual resolution
    #
    # Note, the divisions by 2 are present because half of the added
    # height (compared to the default) is added to the bottom half
    # of the screen, not just the top.
    topLeftY = ((Graphics.height - defaultHeight) / 2).to_i
    
    # return top left y
    return (topLeftY)
  end
  
end


class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # * Aliased create_command()_window for Scene_Title used to add the
  # * achievements command handler to the title command window.
  #--------------------------------------------------------------------------
  alias before_spa_achievement_title_command_scene_addition create_command_window
  def create_command_window
    # Call original method
    before_spa_achievement_title_command_scene_addition
    
    # Add achievements title command handler if ACHIEVE_SCREEN_ON_TITLE is on
    if (SPA::ACHIEVE_SCREEN_ON_TITLE == true)
      @command_window.set_handler(:achievements, method(:command_achievements))
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method, the [Achievements] command is used to enter the
  # * Achievements scene, bringing up the achievements screen.
  #--------------------------------------------------------------------------
  def command_achievements
    Graphics.fadeout(30)
    SceneManager.call(Scene_Achievements)
  end
  
end


class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Aliased create_command()_window for Scene_Title used to add the
  # * achievements command handler to the title command window.
  #--------------------------------------------------------------------------
  alias before_spa_achievement_in_game_menu_command_scene_addition create_command_window
  def create_command_window
    # Call original method
    before_spa_achievement_in_game_menu_command_scene_addition
    
    # Add achievements title command handler if ACHIEVE_SCREEN_ON_TITLE is on
    if (SPA::ACHIEVE_SCREEN_ON_TITLE == true)
      @command_window.set_handler(:achievements, method(:command_achievements))
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method, the [Achievements] command is used to enter the
  # * Achievements scene, bringing up the achievements screen.
  #--------------------------------------------------------------------------
  def command_achievements
    Graphics.fadeout(30)
    SceneManager.call(Scene_Achievements)
  end
  
end


class Window_TitleCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Aliased make_command_list() for Window_TitleCommand used to
  # * add the achievements command to the title menu command list.
  #--------------------------------------------------------------------------
  alias before_spa_achievement_title_command_window_addition make_command_list
  def make_command_list
    # Call original method (Add the original commands)
    before_spa_achievement_title_command_window_addition
    
    # Add achievements title command if ACHIEVE_SCREEN_ON_TITLE is on
    if (SPA::ACHIEVE_SCREEN_ON_TITLE == true)
      add_command(Vocab::achievements, :achievements)
    end
  end
end


class Window_MenuCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Aliased make_command_list() for Window_MenuCommand used to
  # * add the achievements command to the in-game menu command list.
  #--------------------------------------------------------------------------
  alias before_spa_in_game_menu_achievement_command_add make_command_list
  def make_command_list
    # Call original method
    before_spa_in_game_menu_achievement_command_add
    
    # Add achievements in-game menu command if ACHIEVE_SCREEN_ON_GAME_MENU is on
    if (SPA::ACHIEVE_SCREEN_ON_GAME_MENU == true)
      add_command(Vocab::achievements, :achievements)
    end
  end
end


module Vocab
  #--------------------------------------------------------------------------
  # * New method used to return the correct text to use for the
  # * achievements menu option.
  #--------------------------------------------------------------------------
  def self.achievements
    return (SPA::ACHIEVE_SCREEN_OPTION_NAME)
  end
end


#==============================================================================
# ** Scene_Achievements
#------------------------------------------------------------------------------
# ** This new scene manages how the achievements screen is displayed and
# ** how the achievements and text windows on the achievement pages
# ** are displayed. Also manages transitions between achievement pages
# ** if there are multiple pages.
#==============================================================================
class Scene_Achievements < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Overridden start() from Scene_MenuBase used to set up the achievements
  # * screen with its proper music, images, windows, etc.
  #--------------------------------------------------------------------------
  def start
    # call start() in Scene_MenuBase
    super
    
    # if using different achievement screen music, save the current bgm and bgs,
    # stop playing the bgs, and play the achievement bgm
    if (SPA::ACHIEVE_SCREEN_BGM[0].downcase != "none")
      # save previous BGM/BGS
      @preAchieveBGM = RPG::BGM.last
      @preAchieveBGS = RPG::BGS.last
      
      # stop the BGS (if it exists)
      RPG::BGS.stop
      
      bgmFilename = SPA::ACHIEVE_SCREEN_BGM[0]
      bgmVol = SPA::ACHIEVE_SCREEN_BGM[1]
      bgmPitch = SPA::ACHIEVE_SCREEN_BGM[2]
      # play new BGM
      RPG::BGM.new(bgmFilename, bgmVol, bgmPitch).play
    end
    
    Graphics.fadeout(0)
    
    # create the background and title images
    create_bg_and_title
    
    # get the current achievement page to start on
    # (it will be the last-accessed save file)
    init_achievement_page_selection
    
    # create the achievement images for the achievement page
    create_achievement_images
    
    # make the fake pictures appear on screen and freeze the faded-out graphics
    update_fakePictureSpriteset
    Graphics.freeze
    
    # create the achievement page viewport where the text windows will display
    create_achievement_viewport
        
    # create the achievement title and description text windows for the
    # achievements on the page
    create_achievement_title_text_windows
    create_achievement_description_text_windows
    # create the achievement page window
    create_achievement_page_indicator_text_window
    
    # transition into the fully set up screen
    Graphics.transition(30)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden terminate() from Scene_MenuBase used to dispose the achievement
  # * viewport and all of the text windows.
  #--------------------------------------------------------------------------
  def terminate
    # Call terminate() in Scene_MenuBase
    super
    # dispose the achievement text window viewport
    @achievement_viewport.dispose
    
    # dispose the actual achievement text windows
    dispose_all_achievement_page_text_windows
  end
  
  #--------------------------------------------------------------------------
  # * Overridden update() from Scene_MenuBase used to update the achievement
  # * page selection every frame.
  #--------------------------------------------------------------------------
  def update
    # Call update() in Scene_MenuBase
    super
    
    # I don't think frame updates are needed for any of the windows
    # since they are updated on page change, but this is what
    # would be here if they did
    #@achievementTitleWindows.each {|window| window.update }
    #@achievementDescWindows.each {|window| window.update }
    #@achievementPageWindow.each {|window| window.update }
    
    # update the current achievement page based on keyboard inputs
    # note: also includes quitting out of the achievements scene
    update_achievement_page_selection
  end
  
  #--------------------------------------------------------------------------
  # * New method used to crate the viewport the achievement windows
  # * will be displayed in.
  #--------------------------------------------------------------------------
  def create_achievement_viewport
    @achievement_viewport = Viewport.new
    # set the viewport z to be above fakePictures viewport since
    # all text should display above the pictures
    @achievement_viewport.z = FSP::FAKE_PICTURES_VIEWPORT_Z_LEVEL + 10
  end
  
  #--------------------------------------------------------------------------
  # * New method used to show the images for the achievements screen
  # * background image and title image.
  #--------------------------------------------------------------------------
  def create_bg_and_title    
    # get the x and y values to use as the top left pixel of the achievement screen
    topLeftX = SPA.getAchieveScreenTopLeftX
    topLeftY = SPA.getAchieveScreenTopLeftY
    
    # get the picture list
    fakePicturesList = FSP.getFakePictureList(@fakePictureSpriteset.getFakePictureGameScreen, SPA::ACHIEVE_FAKE_PICTURE_TYPE)
    
    # get the background image x and y
    backgroundImageX = topLeftX + SPA::ACHIEVE_SCREEN_BG_X
    backgroundImageY = topLeftY + SPA::ACHIEVE_SCREEN_BG_Y
    # if not using extra resolution space, then get the achievement
    # screen background will be shown with center alignment, otherwise
    # it will be shown normally with top-left alignment
    # resolution)
    if (SPA::USE_EXTRA_RESOLUTION_SPACE == false)
      # get the center of the screen
      backgroundImageX = (Graphics.width / 2).to_i
      backgroundImageY = (Graphics.height / 2).to_i
      
      # show the achievement screen background image picture with center alignment
      fakePicturesList[0].show(SPA::ACHIEVE_SCREEN_BG_FILENAME, 1, backgroundImageX, backgroundImageY, 100, 100, 255, 0)
    else
      # show the achievement screen background image picture with top-left alignment
      fakePicturesList[0].show(SPA::ACHIEVE_SCREEN_BG_FILENAME, 0, backgroundImageX, backgroundImageY, 100, 100, 255, 0)
    end
    
    # get the title image x and y
    titleImageX = topLeftX + SPA::ACHIEVE_SCREEN_TITLE_X
    titleImageY = topLeftY+ SPA::ACHIEVE_SCREEN_TITLE_Y
    # show the achievement screen title picture
    fakePicturesList[1].show(SPA::ACHIEVE_SCREEN_TITLE_FILENAME, 0, titleImageX, titleImageY, 100, 100, 255, 0)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to draw the achievement images as appropriate
  #--------------------------------------------------------------------------
  def create_achievement_images
    # get the x and y values to use as the top left pixel of the achievement screen
    topLeftX = SPA.getAchieveScreenTopLeftX
    topLeftY = SPA.getAchieveScreenTopLeftY
    
    # get the number of achievements on the page and the
    # starting achievement page
    achieveCountOnPage = num_achievements_on_page
    startingAchieveNum = starting_achievement_num
    
    # get the final achievement number on the page
    finalAchieveNum = startingAchieveNum + (achieveCountOnPage - 1)
    
    # get the fakePicturesList holding the achievement pictures
    fakePicturesList = FSP.getFakePictureList(@fakePictureSpriteset.getFakePictureGameScreen, SPA::ACHIEVE_FAKE_PICTURE_TYPE)
    # get the starting picture index to use for the achievements
    startingAchievePicIndex = 10
    
    # initialize currAchieveNum to the startingAchieveNum
    currAchieveNum = startingAchieveNum
    # for each achievement on the achievement page, display the achievement image
    while (currAchieveNum <= finalAchieveNum)
      # check if the current achievement is unlocked
      isCurrentAchievementUnlocked = SPA.checkAchieveUnlockStatus(currAchieveNum)

      # get the current achievement picture index to use
      currAchievePicIndex = startingAchievePicIndex + (currAchieveNum - startingAchieveNum)
      
      # get the currentAchievementPositionNumber
      currAchievePositionNum = currAchieveNum - startingAchieveNum
      
      # get the x and y positions for the achievement image using:
      # the current achievement position number,
      # the width/height of the achievement images,
      # the starting x/y value for the achievement image grid,
      # and the horizontal/vertical distance between achievement images
      achieveImgX = topLeftX + get_x_pos_of_grid_object(currAchievePositionNum, SPA::ACHIEVE_IMG_WIDTH, SPA::ACHIEVE_SCREEN_IMG_GRID_START_X, SPA::ACHIEVE_SCREEN_IMG_GRID_X_DIST_BETWEEN)
      achieveImgY = topLeftY + get_y_pos_of_grid_object(currAchievePositionNum, SPA::ACHIEVE_IMG_HEIGHT, SPA::ACHIEVE_SCREEN_IMG_GRID_START_Y, SPA::ACHIEVE_SCREEN_IMG_GRID_Y_DIST_BETWEEN)
      
      # get the achievement's data name
      achieveDataname = SPA::ACHIEVE_DATA_NAME_BY_NUM[currAchieveNum]
      
      # if the achievement is unlocked, then show the actual achievement image,
      # otherwise, do the appropriate locked image type
      if (isCurrentAchievementUnlocked == true)
        # get the current achievement's image filename
        currAchieveFilename = SPA::ACHIEVE_FILENAME_START + achieveDataname
        
        # show the achievement image
        fakePicturesList[currAchievePicIndex].show(currAchieveFilename, 0, achieveImgX, achieveImgY, 100, 100, 255, 0)
      else
        # initialize currAchieveFilename to empty string
        currAchieveFilename = ""
        
        # if not using any locked achievement image or using a grayscale
        # version of the normal image, set the currAchieveFilename to
        # the usual unlocked one
        if (SPA::USE_LOCKED_ACHIEVEMENT_IMAGE.downcase == "none" || SPA::USE_LOCKED_ACHIEVEMENT_IMAGE.downcase == "grayscale")
          # get the current achievement's image filename
          currAchieveFilename = SPA::ACHIEVE_FILENAME_START + achieveDataname
        
        # if using a standard "achievement locked" image, then show
        # then set currAchieveFilename to match the locked image
        elsif (SPA::USE_LOCKED_ACHIEVEMENT_IMAGE.downcase == "image")
          # get the current achievement's image filename (the locked one)
          currAchieveFilename = SPA::ACHIEVE_LOCKED_FILENAME
        end
        
        # if the file achievement has a specific achievement locked image
        # it should use, then mark that it should
        useSpecificAchieveLockedImage = SPA::ACHIEVE_SPECIFIC_LOCK_IMAGES.include?(achieveDataname)
        # if using a specific locked achievement image, the set the currAchieveFilename to match that
        if (useSpecificAchieveLockedImage == true)
          currAchieveFilename = SPA::ACHIEVE_FILENAME_START + achieveDataname + "_locked"
        end
        
        # show the achievement image
        fakePicturesList[currAchievePicIndex].show(currAchieveFilename, 0, achieveImgX, achieveImgY, 100, 100, 255, 0)
        
        # If using grayscale locked image (and no specific lock image designated)
        # if locked achievement images are set to "grayscale"
        if (SPA::USE_LOCKED_ACHIEVEMENT_IMAGE.downcase == "grayscale" && !useSpecificAchieveLockedImage)
          # set the achievement image to grayscale using a grayscale tone
          fakePicturesList[currAchievePicIndex].start_tone_change(Tone.new(0, 0, 0, 255), 0)
        end
      end
      
      # increment the current achievement number by 1
      currAchieveNum += 1
    end
    
  end
    
  #--------------------------------------------------------------------------
  # * New method used to erase all current achievement images.
  #--------------------------------------------------------------------------
  def erase_achievement_images
    # get the number of achievements on any given page
    achieveCountOnPage = SPA::ACHIEVE_PER_PAGE
    
    # get the fakePicturesList holding the achievement pictures
    fakePicturesList = FSP.getFakePictureList(@fakePictureSpriteset.getFakePictureGameScreen, SPA::ACHIEVE_FAKE_PICTURE_TYPE)
    # get the starting picture index to use for the achievements
    startingAchievePicIndex = 10
    # get the final picture index to use for the achievements
    finalAchievePicIndex = startingAchievePicIndex + achieveCountOnPage - 1
    
    # initialiaze currAchievePicIndex to the startingAchievePicIndex
    currAchievePicIndex = startingAchievePicIndex
    # for each achievement on the achievement page, erase the achievement picture
    while (currAchievePicIndex <= finalAchievePicIndex)
      # erase the achievement image
      fakePicturesList[currAchievePicIndex].erase
      
      # increment the current achievement picture index by 1
      currAchievePicIndex += 1
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create the achievement title text windows.
  #--------------------------------------------------------------------------
  def create_achievement_title_text_windows
    # set up empty array to put the achievement title windows into
    @achievementTitleWindows = []
    
    # get the x and y values to use as the top left pixel of the achievement screen
    topLeftX = SPA.getAchieveScreenTopLeftX
    topLeftY = SPA.getAchieveScreenTopLeftY
    
    # the startingWindowNum is 1
    startingWindowNum = 1
    # initialize the current window num to the starting window number
    currWindowNum = startingWindowNum
    # initialize the final window number to the number of achievements on a page
    finalWindowNum = SPA::ACHIEVE_PER_PAGE
    # for each achievement on the achievement page, display the achievement image
    while (currWindowNum <= finalWindowNum)
      # get the current position number of the achievement title text window
      # in the achievement title window grid
      currWindowPositionNum = currWindowNum - startingWindowNum
      
      # get the x and y positions for the achievement title text window using:
      # the current achievement title window position number,
      # the width/height of the achievement title text windows,
      # the starting x/y value for the achievement title windows grid,
      # and the horizontal/vertical distance between achievement title windows
      achieveWindowX = topLeftX + get_x_pos_of_grid_object(currWindowPositionNum, SPA::ACHIEVE_SCREEN_TITLES_WIDTH, SPA::ACHIEVE_SCREEN_TITLES_GRID_START_X, SPA::ACHIEVE_SCREEN_TITLES_GRID_X_DIST_BETWEEN)
      achieveWindowY = topLeftY + get_y_pos_of_grid_object(currWindowPositionNum, SPA::ACHIEVE_SCREEN_TITLES_HEIGHT, SPA::ACHIEVE_SCREEN_TITLES_GRID_START_Y, SPA::ACHIEVE_SCREEN_TITLES_GRID_Y_DIST_BETWEEN)
      
      # set up the achievement window for the given position
      #
      # note: currWindowNum - 1 used as the index since arrays index at 0
      @achievementTitleWindows[currWindowNum - 1] = Window_Achievement_Title_Text.new(achieveWindowX, achieveWindowY, true)
      @achievementTitleWindows[currWindowNum - 1].viewport = @achievement_viewport
      
      # increment the current achievement window by 1
      currWindowNum += 1
    end
    
    # update the windows with the acutal text to use for the achievement titles
    update_achievement_title_text_windows
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create the achievement description text windows.
  #--------------------------------------------------------------------------
  def create_achievement_description_text_windows
    # set up empty array to put the achievement title windows into
    @achievementDescWindows = []
    
    # get the x and y values to use as the top left pixel of the achievement screen
    topLeftX = SPA.getAchieveScreenTopLeftX
    topLeftY = SPA.getAchieveScreenTopLeftY
    
    # the startingWindowNum is 1
    startingWindowNum = 1
    # initialize the current window num to the starting window number
    currWindowNum = startingWindowNum
    # initialize the final window number to the number of achievements on a page
    finalWindowNum = SPA::ACHIEVE_PER_PAGE
    # for each achievement on the achievement page, display the achievement image
    while (currWindowNum <= finalWindowNum)
      # get the current position number of the achievement description text window
      # in the achievement description window grid
      currWindowPositionNum = currWindowNum - startingWindowNum
      
      # get the x and y positions for the achievement description text window using:
      # the current achievement description window position number,
      # the width/height of the achievement description text windows,
      # the starting x/y value for the achievement description windows grid,
      # and the horizontal/vertical distance between achievement description windows
      achieveWindowX = topLeftX + get_x_pos_of_grid_object(currWindowPositionNum, SPA::ACHIEVE_SCREEN_DESC_WIDTH, SPA::ACHIEVE_SCREEN_DESC_GRID_START_X, SPA::ACHIEVE_SCREEN_DESC_GRID_X_DIST_BETWEEN)
      achieveWindowY = topLeftY + get_y_pos_of_grid_object(currWindowPositionNum, SPA::ACHIEVE_SCREEN_DESC_HEIGHT, SPA::ACHIEVE_SCREEN_DESC_GRID_START_Y, SPA::ACHIEVE_SCREEN_DESC_GRID_Y_DIST_BETWEEN)
      
      # set up the achievement window for the given position
      #
      # note: currWindowNum - 1 used as the index since arrays index at 0
      @achievementDescWindows[currWindowNum - 1] = Window_Achievement_Description_Text.new(achieveWindowX, achieveWindowY, true)
      @achievementDescWindows[currWindowNum - 1].viewport = @achievement_viewport
      
      # increment the current achievement window by 1
      currWindowNum += 1
    end
    
    # update the windows with the acutal text to use for the achievement descriptions
    update_achievement_description_text_windows
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create the achievement page indicator text window.
  #--------------------------------------------------------------------------
  def create_achievement_page_indicator_text_window
    # set up empty array to put the achievement page indicator window into
    @achievementPageWindow = []
    
    # get the x and y values to use as the top left pixel of the achievement screen
    topLeftX = SPA.getAchieveScreenTopLeftX
    topLeftY = SPA.getAchieveScreenTopLeftY
    
    # get the x and y values for the page indicator window
    pageWindowX = topLeftX + SPA::ACHIEVE_SCREEN_PAGE_INDICATOR_X
    pageWindowY = topLeftY + SPA::ACHIEVE_SCREEN_PAGE_INDICATOR_Y
    
    # add the achievement page indicator window into the holding array
    @achievementPageWindow[0] = Window_Achievement_Page_Indicator.new(pageWindowX, pageWindowY, true)
    @achievementPageWindow[0].viewport = @achievement_viewport
    
    # update the window with the actual text to use (if needed)
    update_achievement_page_indicator_text_window
  end
  
  #--------------------------------------------------------------------------
  # * New method used to call all the needed update methods when changing
  # * the active achievement page.
  #--------------------------------------------------------------------------
  def update_achievement_page_change
    # update the achievement images for the new achievement page
    update_achievement_images
    
    # update the achievement title and description text windows for the
    # achievements on the page
    update_achievement_title_text_windows
    update_achievement_description_text_windows
    # update the page indicator window for the new page
    update_achievement_page_indicator_text_window
  end

  #--------------------------------------------------------------------------
  # * New method used to update the current achievement images.
  #--------------------------------------------------------------------------
  def update_achievement_images
    # erase current achievement images
    erase_achievement_images
    # create new achievement images
    create_achievement_images
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update the achievement title text windows for
  # * the current achievement page.
  #--------------------------------------------------------------------------
  def update_achievement_title_text_windows    
    # get the number of achievements on the page and the
    # starting achievement page
    achieveCountOnPage = num_achievements_on_page
    startingAchieveNum = starting_achievement_num
    
    # get the final achievement number on the page
    finalAchieveNum = startingAchieveNum + (achieveCountOnPage - 1)
    
    # initialize currAchieveNum to the startingAchieveNum
    currAchieveNum = startingAchieveNum
    # initialize currWindowNum to 1
    currWindowNum = 1
    # for each achievement on the achievement page, set up the
    # corresponding achievement title window for the achievement
    while (currAchieveNum <= finalAchieveNum)
      # update the achievement window for the given position
      # using the corresponding new achievement ID
      #
      # note: currWindowNum - 1 used as the index since arrays index at 0
      @achievementTitleWindows[currWindowNum - 1].update_window_for_new_achieve(currAchieveNum)
      
      # increment the current achievement number by 1
      currAchieveNum += 1
      # increment the current window number by 1
      currWindowNum += 1
    end
    
    # the total window number is the number of achievements on a page
    totalWindowNum = SPA::ACHIEVE_PER_PAGE
    # for any windows that are not present on the page, hide those windows
    while (currWindowNum <= totalWindowNum)
      @achievementTitleWindows[currWindowNum - 1].hide
      
      # increment the current window number by 1
      currWindowNum += 1
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update the achievement description text windows for
  # * the current achievement page.
  #--------------------------------------------------------------------------
  def update_achievement_description_text_windows
    # get the number of achievements on the page and the
    # starting achievement page
    achieveCountOnPage = num_achievements_on_page
    startingAchieveNum = starting_achievement_num
    
    # get the final achievement number on the page
    finalAchieveNum = startingAchieveNum + (achieveCountOnPage - 1)
    
    # initialize currAchieveNum to the startingAchieveNum
    currAchieveNum = startingAchieveNum
    # initialize currWindowNum to 1
    currWindowNum = 1
    # for each achievement on the achievement page, set up the
    # corresponding achievement description window for the achievement
    while (currAchieveNum <= finalAchieveNum)
      # update the achievement window for the given position
      # using the corresponding new achievement ID
      #
      # note: currWindowNum - 1 used as the index since arrays index at 0
      @achievementDescWindows[currWindowNum - 1].update_window_for_new_achieve(currAchieveNum)
      
      # increment the current achievement number by 1
      currAchieveNum += 1
      # increment the current window number by 1
      currWindowNum += 1
    end
    
    # the total window number is the number of achievements on a page
    totalWindowNum = SPA::ACHIEVE_PER_PAGE
    # for any windows that are not present on the page, hide those windows
    while (currWindowNum <= totalWindowNum)
      @achievementDescWindows[currWindowNum - 1].hide
      
      # increment the current window number by 1
      currWindowNum += 1
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update the achievement page indicator window for
  # * the current achievement page.
  #--------------------------------------------------------------------------
  def update_achievement_page_indicator_text_window
    # update the achievement page window for the new page
    @achievementPageWindow[0].update_window_for_new_achieve_page(@currAchievePage, max_achieve_page)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to dispose all achievement page text windows.
  #--------------------------------------------------------------------------
  def dispose_all_achievement_page_text_windows
    dispose_achievement_title_windows
    dispose_achievement_description_windows
    dispose_achievement_page_indicator_window
  end
  
  #--------------------------------------------------------------------------
  # * New method used to dispose all achievement title text windows.
  #--------------------------------------------------------------------------
  def dispose_achievement_title_windows
    @achievementTitleWindows.each {|window| window.dispose }
  end
  
  #--------------------------------------------------------------------------
  # * New method used to dispose all achievement description text windows.
  #--------------------------------------------------------------------------
  def dispose_achievement_description_windows
    @achievementDescWindows.each {|window| window.dispose }
  end
  
  #--------------------------------------------------------------------------
  # * New method used to dispose the achievement page indicator text window.
  #--------------------------------------------------------------------------
  def dispose_achievement_page_indicator_window
    @achievementPageWindow.each {|window| window.dispose }
  end
  
  #--------------------------------------------------------------------------
  # * New method to start the initial achievement page to go to when
  # * the achievement scene starts.
  #--------------------------------------------------------------------------
  def init_achievement_page_selection
    # get the last achievement page accessed
    lastAchievementPageAccessed = DataManager.getPersistentData("otherScriptsPersistentData", (SPA::ACHIEVE_PDATA_NAME + SPA::ACHIEVE_LAST_PAGE_ACCESSED_PDATA_NAME))

    maxAchievePage = max_achieve_page
    # if the lastAchievementPageAccessed is above the max achievement page,
    # then set the lastAchievementPageAccessed to the max achievement page
    if (lastAchievementPageAccessed > maxAchievePage)
      lastAchievementPageAccessed = maxAchievePage
    end
    
    # set current achievement page to the last accessed achievement page
    @currAchievePage = lastAchievementPageAccessed 
  end
  
  #--------------------------------------------------------------------------
  # * New method used to get the number of achievements on the current
  # * achievement page.
  #--------------------------------------------------------------------------
  def num_achievements_on_page
    # if the current achievement page is the first achievement page, and
    # the total amount of achievements is the same as or less than the
    # amount of achievements on the page, then the max number of achievements
    # will be the number of achievements on the page
    if (@currAchievePage == min_achieve_page && max_achievement_num <= SPA::ACHIEVE_PER_PAGE)
      return (max_achievement_num)
    # if the achievement page is not the last achievement page,
    # then the achievement page will be "full"
    elsif (@currAchievePage < max_achieve_page)
      return (SPA::ACHIEVE_PER_PAGE)
    else
      # get the remaining number of achievements on the last page
      remainingAchievements = max_achievement_num % SPA::ACHIEVE_PER_PAGE
      # special situation, if the last page would be a full page,
      # the remainder will be 0. Make it the amount of achievements
      # on a page instead
      if (remainingAchievements == 0)
        remainingAchievements = SPA::ACHIEVE_PER_PAGE
      end
      
      # return the proper number of achievements for the last achievement page
      return (remainingAchievements)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method to get the achievement id of the first achievement on
  # * the page.
  #--------------------------------------------------------------------------
  def starting_achievement_num
    # the starting achievement number for any page will be
    # the current page number, times the amount of achievements per page,
    # minus the amount of achievements per page (to get the starting
    # number for the page) and plus one at the end to account for
    # starting at 1 instead of zero
    return ((@currAchievePage * SPA::ACHIEVE_PER_PAGE) - SPA::ACHIEVE_PER_PAGE + 1)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to get the current achievement page (numbering starts at 1).
  #--------------------------------------------------------------------------
  def currAchievePage
    @currAchievePage
  end
  
  #--------------------------------------------------------------------------
  # * New method to store the background music before the achievements
  # * screen music plays.
  #--------------------------------------------------------------------------
  def preAchieveBGM
    @preAchieveBGM
  end
  
  #--------------------------------------------------------------------------
  # * New method to store the background music before the achievements
  # * screen music plays.
  #--------------------------------------------------------------------------
  def preAchieveBGS
    @preAchieveBGS
  end
  
  #--------------------------------------------------------------------------
  # * New method to get the maximum total achievement number.
  #--------------------------------------------------------------------------
  def max_achievement_num
    # return the total amount of achievements from SPA module
    SPA::ACHIEVE_DATA.size
  end
  
  #--------------------------------------------------------------------------
  # * New method to get the minimum achievement page.
  #--------------------------------------------------------------------------
  def min_achieve_page
    # return 1 as the minimum achievement page (it will always be at least 1)
    return (1)
  end
  
  #--------------------------------------------------------------------------
  # * New method to get the maximum achievement page.
  #--------------------------------------------------------------------------
  def max_achieve_page
    # return the final achievement number from SPA module
    SPA::FINAL_ACHIEVE_PAGE
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update achievement page selection. This includes
  # * quitting out of the achievements entirely.
  #--------------------------------------------------------------------------
  def update_achievement_page_selection
    # return immediately if the cancel button is pressed
    return on_achievement_page_quit   if Input.trigger?(:B)
    
    # get the achievement page the player is on before any switches
    lastAchievePage = @currAchievePage
    
    # Increase/Decrease the achievement page count if the right or left keys
    # are pressed down. If the key has just been pressed and then released
    # (and not held down), the page increase/decrease will be able to wrap
    # around to the beginning/end of the achievement pages.
    on_achievement_page_increase(Input.trigger?(:RIGHT))   if Input.repeat?(:RIGHT)
    on_achievement_page_decrease(Input.trigger?(:LEFT))    if Input.repeat?(:LEFT)
    
    # if the achievement page was changed, then play the ACHIEVE_PAGE_SWITCH_SE
    # sound effect and update the achievement images
    if (@currAchievePage != lastAchievePage)
      # get page switch sound effect data
      pageSwitchSeData = SPA::ACHIEVE_PAGE_SWITCH_SE
      seFilename = pageSwitchSeData[0]
      seVol = pageSwitchSeData[1]
      sePitch = pageSwitchSeData[2]
      # play page switch sound effect
      RPG::SE.new(seFilename, seVol, sePitch).play
      
      puts ("***** CURRENT PAGE NOW " + @currAchievePage.to_s + " *****")
      # update the all data that needs to change based on page
      update_achievement_page_change
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update achievement page selection when
  # * increasing the achievement page number.
  #--------------------------------------------------------------------------
  def on_achievement_page_increase(doWrapAround)
    # newAchievePage will be the current achievement page plus 1
    newAchievePage = @currAchievePage + 1
    # if the maximum achievement page is exceeded,
    # check if a wrap around should be done, if it should, do it.
    # otherwise, leave the current page as it was before
    if (newAchievePage > max_achieve_page)
      if (doWrapAround == true )
        newAchievePage = min_achieve_page
      else
        newAchievePage = @currAchievePage
      end
    end
    
    # set the current achievement page to its new value
    @currAchievePage = newAchievePage
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update achievement page selection when
  # * increasing the achievement page number.
  #--------------------------------------------------------------------------
  def on_achievement_page_decrease(doWrapAround)
    # newAchievePage will be the current achievement page minus 1
    newAchievePage = @currAchievePage - 1
    # if the minimum achievement page has been gone past,
    # check if a wrap around should be done, if it should, do it.
    # otherwise, leave the current page as it was before
    if (newAchievePage < min_achieve_page)
      if (doWrapAround == true )
        newAchievePage = max_achieve_page
      else
        newAchievePage = @currAchievePage
      end
    end
    
    # set the current achievement page to its new value
    @currAchievePage = newAchievePage
  end
  
  #--------------------------------------------------------------------------
  # * New method to return to the previous scene when quitting out of
  # * the achievements screen.
  #--------------------------------------------------------------------------
  def on_achievement_page_quit
    # update the last achievement page accessed in persistent data with the current page
    DataManager.setPersistentData("otherScriptsPersistentData", (SPA::ACHIEVE_PDATA_NAME + SPA::ACHIEVE_LAST_PAGE_ACCESSED_PDATA_NAME), @currAchievePage)
    
    # play the normal cancel sound
    Sound.play_cancel
    
    # if previous BGM/BGS needs to be restored, restore it
    if (SPA::ACHIEVE_SCREEN_BGM[0].downcase != "none")
      # replay previous BGM/BGS
      @preAchieveBGM.replay
      @preAchieveBGS.replay
    end
    
    return_scene
  end
  
  #--------------------------------------------------------------------------
  # * New method used to get the x position of an object in an objects
  # * grid. To do this, it needs the position number of the object in
  # * the grid (starting at 0), the x-value of the start of the grid,
  # * the width of the object, and the horizontal distance between grid objects.
  #--------------------------------------------------------------------------
  def get_x_pos_of_grid_object(objectGridPos, objectWidth, gridStartXVal, horizDistBtwnObjects)
    # initialize the number of grid objects across the object in
    # question is to 0
    numGridObjectsAcross = 0
    # first, using the grid numbering system, get the number of objects down
    # the grid object is
    if (SPA::ACHIEVE_GRID_NUMBERING_SYSTEM.downcase == "left-right")
      # The number of grid objects across the object is will be
      # the remainder of the object's grid position divided by the
      # number of achievements in a row.
      #
      # Exception: if the object's grid position is less than the number
      # of achievements in a column, then the number of grid objects
      # down will be the same as the object's grid position.
      
      # use a ternary operator and modulo to get the number of objects across
      numGridObjectsAcross = (objectGridPos < SPA::ACHIEVE_PER_ROW) ? (objectGridPos) : (objectGridPos % SPA::ACHIEVE_PER_ROW)
      
    elsif (SPA::ACHIEVE_GRID_NUMBERING_SYSTEM.downcase == "up-down")
      # The number of grid objects across the object is will be
      # the amount of times the number of objects in a column
      # can fit into the object's grid position number.
      
      # use integer division to get number of objects across
      numGridObjectsAcross = objectGridPos / SPA::ACHIEVE_PER_COL
      
    end
    
    # get the horizDistBtwnOriginPoints (origin point is top left of an object)
    # for the object in question given the horizDistBtwnObjects and
    # the objectWidth
    horizDistBtwnOriginPoints = horizDistBtwnObjects + objectWidth
    
    # using the amount of objects across in the grid the object is,
    # the horizontal distance between object origin points,
    # and the starting grid x position,
    # get the final x position for the oject
    finalXPos = (numGridObjectsAcross * horizDistBtwnOriginPoints) + gridStartXVal
    
    # return the final x position of the object
    return (finalXPos)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to get the y position of an object in an objects
  # * grid. To do this, it needs the position number of the object in
  # * the grid (starting at 0), the y-value of the start of the grid,
  # * the height of the object, and the vertical distance between grid objects.
  #--------------------------------------------------------------------------
  def get_y_pos_of_grid_object(objectGridPos, objectHeight, gridStartYVal, vertDistBtwnObjects)
    # initialize the number of grid objects down the object in
    # question is to 0
    numGridObjectsDown = 0
    # first, using the grid numbering system, get the number of objects down
    # the grid object is
    if (SPA::ACHIEVE_GRID_NUMBERING_SYSTEM.downcase == "left-right")
      # The number of grid objects down the object is will be
      # the amount of times the number of objects in a row
      # can fit into the object's grid position number.
      
      # use integer division to get number of objects down
      numGridObjectsDown = objectGridPos / SPA::ACHIEVE_PER_ROW
      
    elsif (SPA::ACHIEVE_GRID_NUMBERING_SYSTEM.downcase == "up-down")
      # The number of grid objects down the object is will be
      # the remainder of the object's grid position divided by the
      # number of achievements in a column.
      #
      # Exception: if the object's grid position is less than the number
      # of achievements in a column, then the number of grid objects
      # down will be the same as the object's grid position.
      
      # use a ternary operator and modulo to get the number of objects down
      numGridObjectsDown = (objectGridPos < SPA::ACHIEVE_PER_COL) ? (objectGridPos) : (objectGridPos % SPA::ACHIEVE_PER_COL)
      
    end
    
    # get the vertDistBtwnOriginPoints (origin point is top left of an object)
    # for the object in question given the vertDistBtwnObjects and
    # the objectHeight
    vertDistBtwnOriginPoints = vertDistBtwnObjects + objectHeight
    
    # using the amount of objects down in the grid the object is,
    # the vertical distance between object origin points,
    # and the starting grid y position,
    # get the final y position for the oject
    finalYPos = (numGridObjectsDown * vertDistBtwnOriginPoints) + gridStartYVal
    
    # return the final y position of the object
    return (finalYPos)
  end

end


#==============================================================================
# ** Window_Achievement
#------------------------------------------------------------------------------
# ** This class is used as a base for all achievement-related windows,
# ** and is not actually used in any Scene.
#==============================================================================
class Window_Achievement < Window_Base
  def initialize(x, y, windowWidthParam, windowHeightParam)
    # Just call the superclass with the given data
    super(x, y, windowWidthParam, windowHeightParam)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden text_color() method from Window_Base used to get
  # * text color using the default window skin, rather than
  # * whatever the window skin actually is.
  #--------------------------------------------------------------------------
  def text_color(n)
    colorWindowskin = Cache.system("Window") 
    # return the pixel object implicitly
    colorWindowskin.get_pixel(64 + (n % 8) * 8, 96 + (n / 8) * 8)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden update_padding() method from Window_Base used to set the
  # * standard padding to 1 to make sure the text can fit in its box.
  #--------------------------------------------------------------------------
  def standard_padding
    return (1)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden update_padding() method from Window_Base used to set the
  # * padding to 1 to make sure the text can fit in its box.
  #--------------------------------------------------------------------------
  def update_padding
    self.padding = 1
  end
  
  #--------------------------------------------------------------------------
  # * Overridden update_padding_bottom() method from Window_Base used to set the
  # * padding to 0 to make sure the text can fit in its box.
  #--------------------------------------------------------------------------
  def update_padding_bottom
    self.padding_bottom = 0
  end
  
end


#==============================================================================
# ** Window_Achievement_Title_Text
#------------------------------------------------------------------------------
# ** This window shows the title text for achievements on the
# ** achievements screen.
#==============================================================================
class Window_Achievement_Title_Text < Window_Achievement
  # Variable storing the current achievement id that the achievement 
  # title window is associated with.
  attr_reader :currAchieveID
  
  # Variable used to store whether or not the achievement the window
  # is associated with is unlocked. Depending on the value, different
  # text will be used.
  attr_reader :currAchieveUnlockStatus
  
  # Variable used to store the data name used in ACHIEVE_DATA.
  attr_reader :currAchieveDataName
  
  #--------------------------------------------------------------------------
  # * Overridden initialize() method from Window_Base used to set up the
  # * achievement title window with its proper data.
  #--------------------------------------------------------------------------
  def initialize(x, y, startHidden = false)
    super(x, y, window_width, window_height)
    # set the window background color opacity to 255 (fully opaque)
    # since the background is being used as an image rather than
    # a window you should be able to see under
    self.back_opacity = 255
    
    # if the window skin should not be shown at all, then set window
    # opacity to 0
    if (SPA::ACHIEVE_SCREEN_TITLES_WINDOW_FILENAME.downcase == "none")
      self.opacity = 0
    # if the new window skin to use is neither "none" nor "default",
    # then set the windowskin to the newly specified one
    elsif (SPA::ACHIEVE_SCREEN_TITLES_WINDOW_FILENAME.downcase != "default")
      # load the bitmap in the Cache
      self.windowskin = Cache.achieveGraphic(SPA::ACHIEVE_SCREEN_TITLES_WINDOW_FILENAME)
    end
    
    # set the font size to the user-designated one for achievement titles
    contents.font.size = SPA::ACHIEVE_SCREEN_TITLES_FONT_SIZE
    
    # if the user-designated font is the default font, then use the default font,
    # otherwise, use whatever font was specified
    if (SPA::ACHIEVE_SCREEN_TITLES_FONT.downcase == "default")
      contents.font.name = Font.default_name
    else
      contents.font.name = SPA::ACHIEVE_SCREEN_TITLES_FONT
    end
    
    # if the achievement text window should start hidden, then hide it
    if (startHidden == true)
      self.hide # calls the hide() method in Scene_Base
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update the achievement title window
  # * for a new achievement ID.
  #--------------------------------------------------------------------------
  def update_window_for_new_achieve(newAchieveID)
    # clear out any existing text if it happens to be present
    contents.clear
    
    # unhide the achievement window if it is currently hidden
    if (self.visible == false)
      self.show # calls the show() method in Scene_Base
    end
    
    # set the currAchieveID to the newAchieveID
    @currAchieveID = newAchieveID
    
    # get the current achieve data name based on achievement ID
    @currAchieveDataName = SPA::ACHIEVE_DATA_NAME_BY_NUM[@currAchieveID]
    # set currAchieveUnlockStatus to the correct value based on achievement ID
    @currAchieveUnlockStatus = SPA.checkAchieveUnlockStatus(@currAchieveID)
    
    # get the achievement data hash using the achievement data name
    achieveDataHash = SPA::ACHIEVE_DATA[@currAchieveDataName]
    # get the achievement title text for the current achievement
    achieveTitleText = achieveDataHash[1]
    
    # if the achievement is not unlocked, check if the title
    # should be hidden, and if it should, then do so.
    if (@currAchieveUnlockStatus == false)
      # if all achievements should use the hidden title text, or if
      # the current achievement is a specific achievement that should
      # use the hidden title text, then setAchieveTitleText to
      # the hidden title text
      if (SPA::ACHIEVE_SCREEN_HIDE_TITLES_BEFORE_UNLOCK == true || SPA::ACHIEVE_SCREEN_HIDE_TITLES_SPECIFIC_ACHIEVES.include?(@currAchieveDataName) == true)
        achieveTitleText = SPA::ACHIEVE_SCREEN_HIDDEN_TITLE_TEXT
      end
    end
    
    # get the center of the window as the achieveTitleX to center-align the text
    achieveTitleX = (window_width / 2) - (text_size(achieveTitleText).width.to_i / 2)
    
    draw_text_ex(achieveTitleX, 0, achieveTitleText)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden update_tone() method from Window_Base used to set
  # * the correct tone for the window based off of the title window setting.
  #--------------------------------------------------------------------------
  def update_tone
    # set the window tone to be completely neutral unless using the default
    # window skin, in which case you the tone stored in $game_system
    if (SPA::ACHIEVE_SCREEN_TITLES_WINDOW_FILENAME.downcase != "default")
      self.tone.set(Tone.new(0, 0, 0))
    else
      self.tone.set($game_system.window_tone)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Overridden reset_font_settings() method from Window_Base used to set the
  # * correct font settings for the achievement title window.
  #--------------------------------------------------------------------------
  def reset_font_settings
    change_color(normal_color)
    
    # set the font size to the user-designated one for achievement titles
    contents.font.size = SPA::ACHIEVE_SCREEN_TITLES_FONT_SIZE
    
    contents.font.bold = Font.default_bold
    contents.font.italic = Font.default_italic
  end
  
  #--------------------------------------------------------------------------
  # * Overridden window_width() method from Window_Base used to set the
  # * achievement title window width to the one defined in the Layout data.
  #--------------------------------------------------------------------------
  def window_width
    return (SPA::ACHIEVE_SCREEN_TITLES_WIDTH)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden window_height() method from Window_Base used to set the
  # * achievement title window height to the one defined in the Layout data.
  #--------------------------------------------------------------------------
  def window_height
    return (SPA::ACHIEVE_SCREEN_TITLES_HEIGHT)
  end
  
end


#==============================================================================
# ** Window_Achievement_Description_Text
#------------------------------------------------------------------------------
# ** This window shows the description text for achievements on the
# ** achievements screen.
#==============================================================================
class Window_Achievement_Description_Text < Window_Achievement
  # Variable storing the current achievement id that the achievement 
  # description window is associated with.
  attr_reader :currAchieveID
  
  # Variable used to store whether or not the achievement the window
  # text will be used.
  attr_reader :currAchieveUnlockStatus
  
  # Variable used to store the data name used in ACHIEVE_DATA.
  attr_reader :currAchieveDataName
  
  #--------------------------------------------------------------------------
  # * Overridden initialize() method from Window_Base used to set up the
  # * achievement description window with its proper data.
  #--------------------------------------------------------------------------
  def initialize(x, y, startHidden = false)
    super(x, y, window_width, window_height)
    # set the window background color opacity to 255 (fully opaque)
    # since the background is being used as an image rather than
    # a window you should be able to see under
    self.back_opacity = 255
    
    # if the window skin should not be shown at all, then set window
    # opacity to 0
    if (SPA::ACHIEVE_SCREEN_DESC_WINDOW_FILENAME.downcase == "none")
      self.opacity = 0
    # if the new window skin to use is neither "none" nor "default",
    # then set the windowskin to the newly specified one
    elsif (SPA::ACHIEVE_SCREEN_DESC_WINDOW_FILENAME.downcase != "default")
      # load the bitmap in the Cache
      self.windowskin = Cache.achieveGraphic(SPA::ACHIEVE_SCREEN_DESC_WINDOW_FILENAME)
    end
    
    # set the font size to the user-designated one for achievement descriptions
    contents.font.size = SPA::ACHIEVE_SCREEN_DESC_FONT_SIZE
    
    # if the user-designated font is the default font, then use the default font,
    # otherwise, use whatever font was specified
    if (SPA::ACHIEVE_SCREEN_DESC_FONT.downcase == "default")
      contents.font.name = Font.default_name
    else
      contents.font.name = SPA::ACHIEVE_SCREEN_DESC_FONT
    end
    
    # if the achievement text window should start hidden, then hide it
    if (startHidden == true)
      self.hide # calls the hide() method in Scene_Base
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update the achievement description window for
  # * a new achievement ID.
  #--------------------------------------------------------------------------
  def update_window_for_new_achieve(newAchieveID)
    # clear out any existing text if it happens to be present
    contents.clear
    
    # unhide the achievement window if it is currently hidden
    if (self.visible == false)
      self.show # calls the show() method in Scene_Base
    end
    
    # set the currAchieveID to the newAchieveID
    @currAchieveID = newAchieveID
    
    # get the current achieve data name based on achievement ID
    @currAchieveDataName = SPA::ACHIEVE_DATA_NAME_BY_NUM[@currAchieveID]
    # set currAchieveUnlockStatus to the correct value based on achievement ID
    @currAchieveUnlockStatus = SPA.checkAchieveUnlockStatus(@currAchieveID)
    
    # get the achievement data hash using the achievement data name
    achieveDataHash = SPA::ACHIEVE_DATA[@currAchieveDataName]
    # initialize achieveDescText to the unlocked description text
    achieveDescText = achieveDataHash[4]
    # if the achievement is not unlocked, then set the achievement description
    # text to the locked version of the description
    if (@currAchieveUnlockStatus == false)
      achieveDescText = achieveDataHash[3]
    end
    
    draw_text_ex(0, 0, achieveDescText)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden update_tone() method from Window_Base used to set
  # * the correct tone for the window based off of the description window setting.
  #--------------------------------------------------------------------------
  def update_tone
    # set the window tone to be completely neutral unless using the default
    # window skin, in which case you the tone stored in $game_system
    if (SPA::ACHIEVE_SCREEN_DESC_WINDOW_FILENAME.downcase != "default")
      self.tone.set(Tone.new(0, 0, 0))
    else
      self.tone.set($game_system.window_tone)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Overridden reset_font_settings() method from Window_Base used to set the
  # * correct font settings for the achievement description window.
  #--------------------------------------------------------------------------
  def reset_font_settings
    change_color(normal_color)
    
    # set the font size to the user-designated one for achievement titles
    contents.font.size = SPA::ACHIEVE_SCREEN_DESC_FONT_SIZE
    
    contents.font.bold = Font.default_bold
    contents.font.italic = Font.default_italic
  end
  
  #--------------------------------------------------------------------------
  # * Overridden line_height() method from Window_Base used to set the
  # * line_height to 12 to make sure the text looks good in its box.
  #--------------------------------------------------------------------------
  def line_height
    return (12)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden update_padding() method from Window_Base used to set the
  # * standard padding to 5 to make sure the text looks good in its box.
  #--------------------------------------------------------------------------
  def standard_padding
    return (5)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden update_padding() method from Window_Base used to set the
  # * padding to 3 to make sure the text looks good in its box.
  #--------------------------------------------------------------------------
  def update_padding
    self.padding = 5
  end
  
  #--------------------------------------------------------------------------
  # * Overridden window_width() method from Window_Base used to set the
  # * achievement title window width to the one defined in the Layout data.
  #--------------------------------------------------------------------------
  def window_width
    return (SPA::ACHIEVE_SCREEN_DESC_WIDTH)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden window_height() method from Window_Base used to set the
  # * achievement title window height to the one defined in the Layout data.
  #--------------------------------------------------------------------------
  def window_height
    return (SPA::ACHIEVE_SCREEN_DESC_HEIGHT)
  end
  
end


#==============================================================================
# ** Window_Achievement_Page_Indicator
#------------------------------------------------------------------------------
# ** This window shows the current achievement page on the achievment
# ** page screen. This window will not be visible unless there is more than
# ** one achievement page.
#==============================================================================
class Window_Achievement_Page_Indicator < Window_Achievement
  # Variable used to store the current achievement page.
  attr_reader :currAchievePage
  
  # Variable used to store the maxmimum achievement page.
  attr_reader :maxAchievePage
  
  #--------------------------------------------------------------------------
  # * Overridden initialize() method from Window_Base used to set up the
  # * achievement page indicator window with its proper data.
  #--------------------------------------------------------------------------
  def initialize(x, y, startHidden = false)
    super(x, y, window_width, window_height)
    # set the window background color opacity to 255 (fully opaque)
    # since the background is being used as an image rather than
    # a window you should be able to see under
    self.back_opacity = 255
    
    # the window skin should not be shown at all, so set window to 0
    self.opacity = 0
    
    # set the font size to the user-designated one for the page indicator
    contents.font.size = SPA::ACHIEVE_SCREEN_PAGE_INDICATOR_FONT_SIZE
    
    # if the user-designated font is the default font, then use the default font,
    # otherwise, use whatever font was specified
    if (SPA::ACHIEVE_SCREEN_PAGE_INDICATOR_FONT.downcase == "default")
      contents.font.name = Font.default_name
    else
      contents.font.name = SPA::ACHIEVE_SCREEN_PAGE_INDICATOR_FONT
    end
    
    # if the achievement text window should start hidden, then hide it
    if (startHidden == true)
      self.hide # calls the hide() method in Scene_Base
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update the achievement page indicator window for
  # * a new achievement page.
  #--------------------------------------------------------------------------
  def update_window_for_new_achieve_page(newAchievePage, newMaxAchievePage)
    # clear out any existing text if it happens to be present
    contents.clear
    
    # set currAchievePage and maxAchievePage
    @currAchievePage = newAchievePage
    @maxAchievePage = newMaxAchievePage
    
    # unhide the page indicator window if maxAchievePage is greater than 1
    # and the window is currently hidden
    if (self.visible == false && @maxAchievePage > 1)
      self.show # calls the show() method in Scene_Base
    end
    
    # only set up any text if there is more than one achievement page
    if (@maxAchievePage > 1)
      # start the achieve page text as the ACHIEVE_SCREEN_PAGE_INDICATOR_FORMAT text
      achievePageText = SPA::ACHIEVE_SCREEN_PAGE_INDICATOR_FORMAT
      
      # use regex to replace "currpage" with the current page number
      # and "maxpage" with the max page number
      achievePageText = achievePageText.gsub(/currpage/i, (@currAchievePage.to_s))
      achievePageText = achievePageText.gsub(/maxpage/i, (@maxAchievePage.to_s))
      
      # get the center of the window adjusted by half the width of the text
      # being drawn as the achievePageIndicatorX to center-align the text
      achievePageIndicatorX = (window_width / 2) - (text_size(achievePageText).width.to_i / 2)
      
      draw_text_ex(achievePageIndicatorX, 0, achievePageText)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Overridden reset_font_settings() method from Window_Base used to set the
  # * correct font settings for the achievement page indicator window.
  #--------------------------------------------------------------------------
  def reset_font_settings
    change_color(normal_color)
    
    # set the font size to the user-designated one for the page indicator
    contents.font.size = SPA::ACHIEVE_SCREEN_PAGE_INDICATOR_FONT_SIZE
    
    contents.font.bold = Font.default_bold
    contents.font.italic = Font.default_italic
  end
  
  #--------------------------------------------------------------------------
  # * Overridden line_height() method from Window_Base used to set the
  # * line_height to 20 to make sure the text looks good in its box.
  #--------------------------------------------------------------------------
  def line_height
    return (20)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden update_padding() method from Window_Base used to set the
  # * standard padding to 0 to make sure the text fits in its box.
  #--------------------------------------------------------------------------
  def standard_padding
    return (0)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden update_padding() method from Window_Base used to set the
  # * padding to 0 to make sure the text fits in its box.
  #--------------------------------------------------------------------------
  def update_padding
    self.padding = 0
  end
  
  #--------------------------------------------------------------------------
  # * Overridden window_width() method from Window_Base used to set the
  # * achievement title window width to the one defined in the Layout data.
  #--------------------------------------------------------------------------
  def window_width
    return (SPA::ACHIEVE_SCREEN_PAGE_INDICATOR_WIDTH)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden window_height() method from Window_Base used to set the
  # * achievement title window height to the one defined in the Layout data.
  #--------------------------------------------------------------------------
  def window_height
    return (SPA::ACHIEVE_SCREEN_PAGE_INDICATOR_HEIGHT)
  end
  
end


#==============================================================================
# ** Window_Achievement_Popup
#------------------------------------------------------------------------------
# ** This window pops up and down from a corner of the screen, showing
# ** that an achievement has been unlocked. Popup windows contain
# ** an achievement image (may or may not be the same one used on the achievement
# ** screen for a given achievement), a top piece of text (may be the achievement
# ** title or a string overriding the titles), and a bottom piece of
# ** text set up for each achievement.
#==============================================================================
class Window_Achievement_Popup < Window_Achievement
  # Variable storing the current achievement id that the achievement 
  # popup window is associated with.
  attr_reader :currAchieveID
  
  # Variable used to store the data name used in ACHIEVE_DATA.
  attr_reader :currAchieveDataName
  
  # Variable storing the starting x value of the achievement popup window.
  attr_accessor :startingX
  
  # Variable storing the starting y value of the achievement popup window.
  attr_accessor :startingY
  
  # Variable storing the y value of the achievement popup window
  # once it has fully popped up.
  attr_accessor :poppedY
  
  # Variable that stores the current "pop status" of the achievement popup
  # window. A window can be in the following popup modes:
  # "pop up"
  # "waiting"
  # "pop down"
  # The value of this variable helps determine the movement behaviour
  # of the achievement popup window.
  attr_accessor :poppedUpStatus
  
  # Variable that stores the initial direction the popup window will
  # go in. Its values will only ever be "up" or "down".
  attr_accessor :popInitialDirection
  
  # Boolean variable that marks that font size should be increased
  # (technically just changed, but would probably be increased),
  # whike the top part of the popup text is being printed out.
  attr_accessor :popupTopTextSizeIncrease
  
  #--------------------------------------------------------------------------
  # * Overridden initialize() method from Window_Base used to set up the
  # * achievement popup window with its proper data.
  #--------------------------------------------------------------------------
  def initialize(x, y, startHidden = false)
    super(x, y, window_width, window_height)
    # set the window background color opacity to 255 (fully opaque)
    # since the background is being used as an image rather than
    # a window you should be able to see under
    self.back_opacity = 255
    
    # if the new window skin to use is neither not "default",
    # then set the windowskin to the newly specified one
    if (SPA::ACHIEVE_POPUP_WINDOW_FILENAME.downcase != "default")
      # load the bitmap in the Cache
      self.windowskin = Cache.achieveGraphic(SPA::ACHIEVE_POPUP_WINDOW_FILENAME)
    end
    
    # set the font size to the user-designated one for achievement descriptions
    contents.font.size = SPA::ACHIEVE_POPUP_FONT_SIZE
    
    # if the user-designated font is the default font, then use the default font,
    # otherwise, use whatever font was specified
    if (SPA::ACHIEVE_POPUP_FONT.downcase == "default")
      contents.font.name = Font.default_name
    else
      contents.font.name = SPA::ACHIEVE_POPUP_FONT
    end
    
    # if the achievement text window should start hidden, then hide it
    if (startHidden == true)
      self.hide # calls the hide() method in Scene_Base
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to update the window for a new achievement.
  # * Draws the acheivement top and bottom popup text, and
  # * the achievement image.
  #--------------------------------------------------------------------------
  def update_window_for_new_achieve(achieveDataName)
    # clear out any existing text if it happens to be present
    contents.clear
    
    # unhide the achievement window if it is currently hidden
    if (self.visible == false)
      self.show # calls the show() method in Scene_Base
    end
    
    # get the current achieve data name based on achievement ID
    @currAchieveDataName = achieveDataName
    
    # get the achievement data hash using the achievement data name
    achieveDataHash = SPA::ACHIEVE_DATA[@currAchieveDataName]
    
    # set the currAchieveID suing the achievement data
    @currAchieveID = achieveDataHash[0]
    
    # get the achievePopupTopText (achievement title)
    achievePopupTopText = achieveDataHash[1]
    # if the achievement title should be overridden, the override it
    if (SPA::ACHIEVE_POPUP_TITLE_OVERRIDE.downcase != "none")
      achievePopupTopText = SPA::ACHIEVE_POPUP_TITLE_OVERRIDE
    end
    # get the x and y values to draw the achievement popup top text at
    achievePopupTopX = SPA::ACHIEVE_POPUP_TOP_TEXT_X
    # set achievePopupTopY to 10
    achievePopupTopY = SPA::ACHIEVE_POPUP_TOP_TEXT_Y
    
    # get the x and y values to draw the achievement popup bottom text at
    achievePopupBottomText = achieveDataHash[2]
    # set achievePoupupBottomX to 88
    achievePopupBottomX = SPA::ACHIEVE_POPUP_BOTTOM_TEXT_X
    # set achievePopupBottomY to 42
    achievePopupBottomY = SPA::ACHIEVE_POPUP_BOTTOM_TEXT_Y
    
    # make the top text the top text size
    contents.font.size = SPA::ACHIEVE_POPUP_TOP_FONT_SIZE
    @popupTopTextSizeIncrease = true

    # draw the text for the top part of the achievement popop
    # (the achievement title or the override string)
    draw_text_ex(achievePopupTopX, achievePopupTopY, achievePopupTopText)
    
    # set the font size back to normal
    @popupTopTextSizeIncrease = false
    contents.font.size = SPA::ACHIEVE_POPUP_FONT_SIZE
    
    # draw the text for the bottom part of the achievement popup
    draw_text_ex(achievePopupBottomX, achievePopupBottomY, achievePopupBottomText)
    
    # get the x and y values to draw the achievement popup image at
    achievePopupImgX = SPA::ACHIEVE_POPUP_IMG_X
    achievePopupImgY = SPA::ACHIEVE_POPUP_IMG_Y
    # draw the achievement popup image
    draw_achievement_popup_image(achievePopupImgX, achievePopupImgY)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to draw the achievement image in the achievement
  # * image popup. The image will be different depending on whether
  # * separate images are used for achievement popups or not.
  #--------------------------------------------------------------------------
  def draw_achievement_popup_image(x, y)
    # get the achievement filename
    achieveFilename = SPA::ACHIEVE_FILENAME_START + @currAchieveDataName
    # if separate popup images are used, add on "_popup" to the end of the filename
    if (SPA::ACHIEVE_POPUP_USE_SEPARATE_IMG == true)
      achieveFilename = achieveFilename + "_popup"
    end
    
    # load the bitmap from the Cache
    bitmap = Cache.achieveGraphic(achieveFilename)
    # initialize popupImgWidth and popupImgHeight to 0
    popupImgWidth = 0
    popupImgHeight = 0
    # get the popupImgWidth and popupImgHeight depending on if
    # separate popup images are used or not
    if (SPA::ACHIEVE_POPUP_USE_SEPARATE_IMG == true)
      # separate popup achievement images are used, so get the special dimensions
      popupImgWidth = SPA::ACHIEVE_POPUP_IMG_WIDTH
      popupImgHeight = SPA::ACHIEVE_POPUP_IMG_HEIGHT
    else
      # use the standard unlocked achievement image dimensions
      popupImgWidth = SPA::ACHIEVE_IMG_WIDTH
      popupImgHeight = SPA::ACHIEVE_IMG_HEIGHT
    end
    # get a rectangle encompassing the achievement image
    rect = Rect.new(0, 0, popupImgWidth, popupImgHeight)
    # transfer the achievement graphic into the window's "contents" bitmap
    contents.blt(x, y, bitmap, rect)
    # dispose original bitmap
    bitmap.dispose
  end
  
  #--------------------------------------------------------------------------
  # * New method used to move the window 1 pixel towards the direction it is
  # * supposed to be moving towards when popping up or down.
  #--------------------------------------------------------------------------
  def move_window_towards_pop_direction
    # initialize currDirection to an empty string
    currDirection = ""
    # get correct current direction based on poppedUpStatus
    # (if popping up, use the initial direction,
    # if popping down, use the reversed initial direction)
    if (@poppedUpStatus == "pop up")
      currDirection = @popInitialDirection
    elsif (@poppedUpStatus == "pop down")
      currDirection = get_reversed_direction(@popInitialDirection)
    end
    
    # move the window 1 pixel towards the direction it should move in
    if (currDirection == "up")
      self.move(self.x, (self.y - 1), window_width, window_height)
    elsif (currDirection == "down")
      self.move(self.x, (self.y + 1), window_width, window_height)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if the window has reached it's "popped up" position.
  #--------------------------------------------------------------------------
  def pop_up_position_reached
    return ((@poppedUpStatus == "pop up") && (self.y == @poppedY))
  end
  
  #--------------------------------------------------------------------------
  # * New method used to check if the window has reached it's "popped down" position.
  #--------------------------------------------------------------------------
  def pop_down_position_reached
    return ((@poppedUpStatus == "pop down") && (self.y == @startingY))
  end
  
  #--------------------------------------------------------------------------
  # * New method used to get the reversed direction from a given direction string.
  # * "up" turns to "down" and "down" turns to "up".
  #--------------------------------------------------------------------------
  def get_reversed_direction(direction)
    if (direction == "up")
      return ("down")
    elsif (direction == "down")
      return ("up")
    end
  end
  
  #--------------------------------------------------------------------------
  # * Overridden update_tone() method from Window_Base used to set
  # * the correct tone for the window (completely neutral).
  #--------------------------------------------------------------------------
  def update_tone
    # set the window tone to be completely neutral
    self.tone.set(Tone.new(0, 0, 0))
  end
  
  #--------------------------------------------------------------------------
  # * Overridden reset_font_settings() method from Window_Base used to set the
  # * correct font settings for the achievement popup window.
  #--------------------------------------------------------------------------
  def reset_font_settings
    change_color(normal_color)
    
    # set popupTopTextSizeIncrease to false if nil
    if (@popupTopTextSizeIncrease.nil?)
      @popupTopTextSizeIncrease = false
    end
    
    # get the correct font size depending on whether the top or bottom text
    # of the acheivement popup is about to be drawn
    if (@popupTopTextSizeIncrease == true)
      contents.font.size = SPA::ACHIEVE_POPUP_TOP_FONT_SIZE
    else
      # set the font size to the user-designated one for achievement titles
      contents.font.size = SPA::ACHIEVE_POPUP_FONT_SIZE
    end
    
    contents.font.bold = Font.default_bold
    contents.font.italic = Font.default_italic
  end
  
  #--------------------------------------------------------------------------
  # * Overridden line_height() method from Window_Base used to set the
  # * line_height to 12 to make sure the text looks good in its box.
  #--------------------------------------------------------------------------
  def line_height
    return (12)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden update_padding() method from Window_Base used to set the
  # * standard padding to 3 to make sure the text looks good in its box.
  #--------------------------------------------------------------------------
  def standard_padding
    return (3)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden update_padding() method from Window_Base used to set the
  # * padding to 3 to make sure the text looks good in its box.
  #--------------------------------------------------------------------------
  def update_padding
    self.padding = 3
  end
  
  #--------------------------------------------------------------------------
  # * Overridden window_width() method from Window_Base used to set the
  # * achievement title window width to the one defined in the Layout data.
  #--------------------------------------------------------------------------
  def window_width
    return (SPA::ACHIEVE_POPUP_WIDTH)
  end
  
  #--------------------------------------------------------------------------
  # * Overridden window_height() method from Window_Base used to set the
  # * achievement title window height to the one defined in the Layout data.
  #--------------------------------------------------------------------------
  def window_height
    return (SPA::ACHIEVE_POPUP_HEIGHT)
  end
  
end


class Game_Interpreter
  #--------------------------------------------------------------------------
  # * New method used to create a script call to enter the achievement scene.
  # * Useful if you want to tie achievements to an event or to a key item
  # * via a common event.
  # * Call with: spaOpenAchieveScreen
  #--------------------------------------------------------------------------
  def spaOpenAchieveScreen
    Graphics.fadeout(30)
    SceneManager.call(Scene_Achievements)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create a script call to unlock an achievement
  # * in the normal way.
  # * Call with: spaAchieveUnlock("achievementName")
  #--------------------------------------------------------------------------
  def spaAchieveUnlock(achievementName)
    # only do anything if the achievement isn't already unlocked
    if (SPA.checkAchieveUnlockStatus(achievementName) == false)
      # change the unlock status of achievement to true
      SPA.changeAchieveUnlockStatus(achievementName, true)
      
      # if popups are enabled than show an achievement popup for the achievement
      if (SPA::ACHIEVE_POPUPS_ON == true)
        # prepare the achievement to popup in the scene
        SceneManager.scene.prepareAchievePopup(achievementName)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create a script call to unlock an achievement
  # * without doing any popups.
  # * Call with: spaAchieveUnlockNoPopup("achievementName")
  #--------------------------------------------------------------------------
  def spaAchieveUnlockNoPopup(achievementName)
    # only do anything if the achievement isn't already unlocked
    if (SPA.checkAchieveUnlockStatus(achievementName) == false)
      # change the unlock status of achievement to true
      SPA.changeAchieveUnlockStatus(achievementName, true)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create a script call to lock an achievement
  # * after it has been unlocked. Mainly intended for use in testing.
  # * Call with: spaAchieveLock("achievementName")
  #--------------------------------------------------------------------------
  def spaAchieveLock(achievementName)
    # only do anything if the achievement isn't already locked
    if (SPA.checkAchieveUnlockStatus(achievementName) == true)
      # change the unlock status of achievement to false
      SPA.changeAchieveUnlockStatus(achievementName, false)
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create a script call to unlock all achievements.
  # * Mainly intended for use in testing.
  # * Call with: spaUnlockAllAchievements
  #--------------------------------------------------------------------------
  def spaUnlockAllAchievements
    # for every achievement in the ACHIEVE_DATA, unlock the achievement
    # if it has not already been unlocked
    SPA::ACHIEVE_DATA.each do |keyDataName, valueDataList|
      # only do anything if the achievement isn't already unlocked
      if (SPA.checkAchieveUnlockStatus(keyDataName) == false)
        # change the unlock status of achievement to true
        SPA.changeAchieveUnlockStatus(keyDataName, true)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create a script call to lock (reset) all achievements.
  # * Mainly intended for use in testing.
  # * Call with: spaResetAllAchievements
  #--------------------------------------------------------------------------
  def spaResetAllAchievements
    # for every achievement in the ACHIEVE_DATA, lock the achievement
    # if it isn't already locked
    SPA::ACHIEVE_DATA.each do |keyDataName, valueDataList|
      # only do anything if the achievement isn't already locked
      if (SPA.checkAchieveUnlockStatus(keyDataName) == true)
        # change the unlock status of achievement to false
        SPA.changeAchieveUnlockStatus(keyDataName, false)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create a script call to check if a given achievement
  # * is unlocked. Returns true if it is, otherwise, false.
  # * Call with: spaCheckAchieveUnlock("achievementName")
  #--------------------------------------------------------------------------
  def spaCheckAchieveUnlock(achievementName)
    SPA.checkAchieveUnlockStatus(achievementName)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create a script call to check if all achievements
  # * are unlocked. Returns true if they are, otherwise, false.
  # * Call with: spaCheckAllAchieveUnlock
  #--------------------------------------------------------------------------
  def spaCheckAllAchieveUnlock
   # for every achievement in the ACHIEVE_DATA, return false
   # if an achievement is locked
    SPA::ACHIEVE_DATA.each do |keyDataName, valueDataList|
      # get the unlock status of the current achievement
      currAchieveUnlockStatus = SPA.checkAchieveUnlockStatus(keyDataName)
      
      # if the achievement was not unlocked, return false
      if (currAchieveUnlockStatus == false)
        return (false)
      end
    end
    
    # All achievements were unlocked, so return true
    return (true)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create a script call to get the number of unlocked
  # * achievements. Returns the number of unlocked achievements.
  # * Call with: spaAchievesUnlockedNum
  #--------------------------------------------------------------------------
  def spaAchievesUnlockedNum
    # start with the number of unlocked achieves at 0
    numAchievesUnlocked = 0
   # for every unlocked achievement in the ACHIEVE_DATA,
   # increment numAchievesUnlocked by 1
    SPA::ACHIEVE_DATA.each do |keyDataName, valueDataList|
      # get the unlock status of the current achievement
      currAchieveUnlockStatus = SPA.checkAchieveUnlockStatus(keyDataName)
      
      # if the achievement was unlocked increment numAchievesUnlocked by 1
      if (currAchieveUnlockStatus == true)
        numAchievesUnlocked += 1
      end
    end
    
    # Return the number of unlocked achievements
    return (numAchievesUnlocked)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create a script call to get the number of locked
  # * achievements. Returns the number of locked achievements.
  # * Call with: spaAchievesLockedNum
  #--------------------------------------------------------------------------
  def spaAchievesLockedNum
    # start with the number of locked achieves at 0
    numAchievesLocked = 0
   # for every locked achievement in the ACHIEVE_DATA,
   # increment numAchievesLocked by 1
    SPA::ACHIEVE_DATA.each do |keyDataName, valueDataList|
      # get the unlock status of the current achievement
      currAchieveUnlockStatus = SPA.checkAchieveUnlockStatus(keyDataName)
      
      # if the achievement was locked increment numAchievesLocked by 1
      if (currAchieveUnlockStatus == false)
        numAchievesLocked += 1
      end
    end
    
    # Return the number of locked achievements
    return (numAchievesLocked)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to create a script call to get the total number of
  # * achievements. Returns the total number of achievements.
  # * Call with: spaTotalAchievesNum
  #--------------------------------------------------------------------------
  def spaTotalAchievesNum
    return (SPA::ACHIEVE_DATA.size)
  end

end


class Scene_Base
  #--------------------------------------------------------------------------
  # * New method used to return achievePopupWindow.
  #--------------------------------------------------------------------------
  def achievePopupWindow
    @achievePopupWindow
  end
  
  #--------------------------------------------------------------------------
  # * New method used to return achieveToShowPopupFor.
  #--------------------------------------------------------------------------
  def achieveToShowPopupFor
    @achieveToShowPopupFor
  end
  
  #--------------------------------------------------------------------------
  # * New method used to return achievePopupLingerTime.
  #--------------------------------------------------------------------------
  def achievePopupLingerTime
    @achievePopupLingerTime
  end
  
  #--------------------------------------------------------------------------
  # * Aliased update() method for Scene_Base used to update an achievement
  # * popping in/out every frame.
  #--------------------------------------------------------------------------
  alias before_spa_achieve_popup_update update
  def update
    # Call original method
    before_spa_achieve_popup_update
    
    # do nothing unless the achieveToShowPopupFor is set to something
    if (!(@achieveToShowPopupFor.nil?))
      
      # get current popup window popup status
      currPopupStatus = @achievePopupWindow.poppedUpStatus
      # if the window is popping up, move the popup window towards its
      # destination. If it reaches it, set it into "waiting" mode.
      if (currPopupStatus == "pop up")
        # move the window 1 pixel towards it's destination
        @achievePopupWindow.move_window_towards_pop_direction
        
        # if the popped up position is reached for the achievement,
        # the set the achievement popup into "waiting" mode
        if (@achievePopupWindow.pop_up_position_reached == true)
          @achievePopupWindow.poppedUpStatus = "waiting"
        end
      
      # if the achievement window is waiting, move then decrease the amount of
      # waiting/linger time. If the linger time has run out, set
      # the achievement window into "popping down" mode.
      elsif (currPopupStatus == "waiting")
        # decrease the linger time by 1
        @achievePopupLingerTime -= 1
        
        # if the linger time is at or below 0, then set the
        # achievement into "pop down" mode
        if (@achievePopupLingerTime <= 0)
          @achievePopupWindow.poppedUpStatus = "pop down"
        end
        
      elsif (currPopupStatus == "pop down")
        # move the window 1 pixel towards it's destination
        @achievePopupWindow.move_window_towards_pop_direction
        
        # If the final popped down position is reached for the achievement,
        # then do popup ending processing
        if (@achievePopupWindow.pop_down_position_reached == true)
          # dispose the window and set it to nil
          @achievePopupWindow.dispose
          @achievePopupWindow = nil
          
          # set all other temporary popup data to nil
          @achieveToShowPopupFor = nil
          @achievePopupLingerTime = nil
        end
        
      end
      
    end
  end
  
  #--------------------------------------------------------------------------
  # * New method used to prepare an achievement popup using the script's
  # * settings and the given achievement data name.
  #--------------------------------------------------------------------------
  def prepareAchievePopup(achieveDataname)
    if (@achieveToShowPopupFor.nil?)
      # only do anything if achieveToShowPopupFor is currently nil
      # (this script doesn't support getting multiple achieve popups
      # at once right now)
      
      # set achieveToShowPopupFor to the new achievement by dataname
      @achieveToShowPopupFor = achieveDataname
      
      # set achievement linger time to ACHIEVE_POPUP_TIME
      # (times 60 because vx ace games run at 60 fps and
      # the ACHIEVE_POPUP_TIME is in seconds)
      @achievePopupLingerTime = (SPA::ACHIEVE_POPUP_TIME * 60.0).to_i
      
      # Get the width and height of popups
      popupWidth = SPA::ACHIEVE_POPUP_WIDTH
      popupHeight = SPA::ACHIEVE_POPUP_HEIGHT
      # get the width and height of the window
      screenWidth = Graphics.width
      screenHeight = Graphics.height
      
      # initialize initial direction to an empty string
      initialDirection = ""
      # initialize startingWindowX and startingWindowY to 0
      startingWindowX = 0
      startingWindowY= 0
      # initialize finalWindowX and finalWindowY to 0
      if (SPA::ACHIEVE_POPUP_CORNER.downcase == "bottomleft")
        startingWindowX = 0
        startingWindowY = screenHeight
        initialDirection = "up"
      elsif (SPA::ACHIEVE_POPUP_CORNER.downcase == "bottomright")
        startingWindowX = screenWidth - popupWidth
        startingWindowY = screenHeight
        initialDirection = "up"
      elsif (SPA::ACHIEVE_POPUP_CORNER.downcase == "topleft")
        startingWindowX = 0
        startingWindowY = 0 - popupHeight
        initialDirection = "down"
      elsif (SPA::ACHIEVE_POPUP_CORNER.downcase == "topright")
        startingWindowX = screenWidth - popupWidth
        startingWindowY = 0 - popupHeight
        initialDirection = "down"
      end
      
      # create the new achievePopupWindow and store in achievePopupWindow
      @achievePopupWindow = Window_Achievement_Popup.new(startingWindowX, startingWindowY)
      # set the window's z value to a ridiculosuly high (so depth level as close to screen as possible)
      @achievePopupWindow.z = 9999
      
      # set up the window with its achievement data based text
      @achievePopupWindow.update_window_for_new_achieve(achieveDataname)
      
      # get y value when window popped up
      # (if pop direction is downwards, the poppedY is 0,
      # if pop direction is upwards, the poppedY is screenHeight - popupHeight)
      poppedY = (initialDirection == "down") ? (0) : (screenHeight - popupHeight)
      
      # set up the window to contain all of its movement data
      @achievePopupWindow.popInitialDirection = initialDirection
      @achievePopupWindow.startingX = startingWindowX
      @achievePopupWindow.startingY = startingWindowY
      @achievePopupWindow.poppedY = poppedY
      @achievePopupWindow.poppedUpStatus = "pop up"
      
      # if achievement popup sounds are used, then play the sound
      if (SPA::ACHIEVE_POPUP_SE[0] != "")
        # get popup sound effect data
        popupSeData = SPA::ACHIEVE_POPUP_SE
        seFilename = popupSeData[0]
        seVol = popupSeData[1]
        sePitch = popupSeData[2]
        # play page switch sound effect
        RPG::SE.new(seFilename, seVol, sePitch).play
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Aliased dispose_all_windows() method for Scene_Base used to
  # * reset the achieve popup window data to nil after all windows
  # * are disposed.
  #--------------------------------------------------------------------------
  alias before_spa_achieve_window_reset dispose_all_windows
  def dispose_all_windows
    # Call original method
    before_spa_achieve_window_reset
    
    # set all temporary popup data to nil
    @achievePopupWindow = nil
    @achieveToShowPopupFor = nil
    @achievePopupLingerTime = nil
  end
  
end


module FSP
  # Aliases the getFakePictureDepthLevel() method to add the
  # achievements-specific fake pictures depth level to the
  # method in the FSP module.
  class << self
    alias afterAchieveFakePictureDepthReturn getFakePictureDepthLevel
  end
  
  #--------------------------------------------------------------------------
  # * Aliased getFakePictureDepthLevel() method used to add the
  # * fake pictures depth level for this script to the method in the FSP module.
  #--------------------------------------------------------------------------
  def self.getFakePictureDepthLevel(pictureType)
    # if the pictureType is ACHIEVE_FAKE_PICTURE_TYPE, then
    # immediately return the ACHIEVE_FAKE_PICTURE_DEPTH value
    if (pictureType == SPA::ACHIEVE_FAKE_PICTURE_TYPE)
      return (SPA::ACHIEVE_FAKE_PICTURE_DEPTH)
    end
    
    # Call original method
    afterAchieveFakePictureDepthReturn
  end
  
end


module Cache
  # Aliases the fakePicture() method from the fake pictures script.
  class << self
    alias afterFakePictureAchieveCheck fakePicture
  end
  
  #--------------------------------------------------------------------------
  # * Aliased fakePicture() method used to get the fake picture graphic for
  # * achievement fake pictures from the achievement folder rather than
  # * the normal pictures folder.
  #--------------------------------------------------------------------------
  def self.fakePicture(filename, fakePictureType = "")
    # if the picture being searched for is an achievement picture,
    # then load the appropriate bitmap from the achievement folder
    if (fakePictureType == SPA::ACHIEVE_FAKE_PICTURE_TYPE)
      # return bitmap according to the proper filepath for the achievements pictures
      return (load_bitmap((SPA::ACHIEVE_FOLDER_NAME + "/"), filename))
    end

    # Call original method
    afterFakePictureAchieveCheck(filename, fakePictureType)
  end
  
  #--------------------------------------------------------------------------
  # * New method used to get achievement graphics based off of the
  # * filename.
  #--------------------------------------------------------------------------
  def self.achieveGraphic(filename)
    # the filepath will be the achievement folder name + a slash
    filepath = SPA::ACHIEVE_FOLDER_NAME + "/"
    # load the bitmap in the achievement folder using the given filename.
    load_bitmap(filepath, filename)
  end
end


module DataManager
  # Aliases the prepareScriptPersistentData() method from the persistent data script.
  class << self
    alias beforeAchievementsPersistentDataInit prepareScriptPersistentData
  end
  
  #--------------------------------------------------------------------------
  # * Aliased prepareScriptPersistentData() method used to add the
  # * achievement unlock hash to the script portion of persistent data
  # * when it is being prepared.
  #--------------------------------------------------------------------------
  def self.prepareScriptPersistentData
    # Call original method
    beforeAchievementsPersistentDataInit
    
    # Use the ACHIEVE_DATA to set the key names to their persistent
    # data format (add the ACHIEVE_PDATA_NAME before the data name)
    # and set initial unlock status of all achievements to "false".
    # Set up this data as individual entries in scriptPersistentDataToSetup.
    SPA::ACHIEVE_DATA.each do |achieveName, achieveData|
      @scriptPersistentDataToSetup[(SPA::ACHIEVE_PDATA_NAME + achieveName)] = false
    end
    
    # Set up the lastAchievementPageAccessed in persistent data format
    @scriptPersistentDataToSetup[(SPA::ACHIEVE_PDATA_NAME + SPA::ACHIEVE_LAST_PAGE_ACCESSED_PDATA_NAME)] = 1
  end
end


class Game_Screen
  #--------------------------------------------------------------------------
  # * Aliased Game_Screen initialize() method used to initialize
  # * the achievement fake game pictures.
  #--------------------------------------------------------------------------
  alias after_spa_achievePictures_init initialize
  def initialize
    # initialize the fake pictures hash if not initialized
    if (@fakePictures.nil?)
      @fakePictures = {}
    end
    # initialize the achievement pictures list to a new Game_Pictures array/object
    @fakePictures[SPA::ACHIEVE_FAKE_PICTURE_TYPE] = Game_Pictures.new
    # set the fake picture depth to the one used for this script
    @fakePictures[SPA::ACHIEVE_FAKE_PICTURE_TYPE].setFakePictureDepth(SPA::ACHIEVE_FAKE_PICTURE_DEPTH)
    
    # Call Original Method
    after_spa_achievePictures_init
  end
end

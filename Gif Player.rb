# IMPORT SECTION (DO NOT MODIFY):
$imported = {} if $imported.nil?
$imported["Liam-GifPlayer"] = true
# END OF IMPORT SECTION

# ----------------- ! REQUIRES 'FAKE SHOW PICTURES' SCRIPT ! ------------------
# Script:           Gif Player (Using show picture)
# Author:           Liam
# Version:          1.1.2
# Description:
# This script is made for showing a "gif" using show picture commands.
# It does not actually show a real .gif file, it just plays a bunch of static
# images like a gif. It will take a series of related images to play in
# quick succession.
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
# Use this script by placing a script call in a map event to the
# method below. To play a gif, you must use picture filenames like
# the following: imagefilename_#
# Replace the # symbol with whatever frame of the gif the picture should be.
# (it should be a number, starting at 1 for the first frame)
#
# Note 1: All pictures used should be the size of your rpgmaker screen.
#
# Note 2: The gif player clears all existing pictures. You will need to put
# any you had before back after the gif player is done.
#
#   Calling:
# show_gif(filename, size, speed, fadeout)
#
#   Parameters:
# filename is the base picture filename used at the beginning before the _ symbol
# size is the amount of pictures your "gif" uses. It should be the last frame # for a given "gif"
# speed is the amount of game frames to wait in between frames (each frame is 1/60th of a second)
# fadeout is whether or not to fade in and out to the gif at the beginning/end
#
#   Example:
# PICTURES PRESENT IN THE GAME DATABASE: myGif_1.png, myGif_2.png, myGif_3.png
# show_gif("myGif", 3, 60, true)     <- in a map event
#
# Using the above combination of pictures in the script call in a map event
# will play the myGif base filename gif. It will go through myGif_1.png through
# myGif_3.png, waiting 1 second in between each frame, and fading into the
# gif at the beginning, and fading out of the gif at the end.
#
#
# No editable constants for this script.



# BEGINNING OF SCRIPTING ====================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * New method used to show a "gif." The size (how many frames there are
  # in the gif), speed (amount of time btwn frames), and whehter to fade
  # in/out at the beginning and end
  #--------------------------------------------------------------------------
	def show_gif(filename, size, speed, fadeout)
		screen.clear_pictures   # clear all existing pictures to start with
    
    gif_speed = speed          # Time each gif picture is up (in frames, 60sec = 1 frame)
    gif_filename = filename    # Set base filename to use for gif files
    gif_size = size            # Amnt of total images (index starts at 1)
    gif_fadeout = fadeout      # Whether or not to fade in/out for the gif, true/false
		
    i = 1 # starting num for picture index is 1
    
    # fadein to first frame
		if (gif_fadeout == true)
      screen.start_fadeout(30) # fadeout the standard game screen (screen now black)
			wait(30)
      # show the first frame early to fade into it (cannot be seen yet, screen still black)
      gif_filename = filename + "_" + i.to_s 
      screen.pictures[i + 6].show(@gif_filename, 0, 0, 0, 100, 100, 255, 0)
      screen.start_fadein(30) # fadein to the first frame of the gif
      wait(30)
		end
    
    # loop through specified pictures, showing them all
		while (i <= gif_size)
      # get proper filename index, which is the base filename, plus
      # the "_" symbol, plus the current index
			gif_filename = filename + "_" + i.to_s
      # picture layer starts at i + 6 so it cannot be messed w/ by other pictures
      # that pop up during the middle of execution
      screen.pictures[i + 6].show(@gif_filename, 0, 0, 0, 100, 100, 255, 0)
      # if the current picture index is more than 1, erase the previous picture
			if (i > 1)
        # erase the previous picture
				screen.pictures[i + 5].erase        
			end
			wait(gif_speed)
      # increase the current picture index by 1
      i += 1
		end
		
    # fadeout of last frame
		if (gif_fadeout == true)
      screen.start_fadeout(30) # fadeout the last frame of the gif (screen now black)
			wait(30)
      # erase the final frame
      screen.pictures[i + 5].erase
      screen.start_fadein(30) # fadein to the normal game screen
      wait(30)
		end
    
    screen.clear_pictures # clear all pictures after the gif is done
  end
end
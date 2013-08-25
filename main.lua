-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require "storyboard"

storyboard.purgeOnSceneChange = true

-- Sound
bg_sound = audio.loadSound("sound/soundtrack.mp3")
audio.play(bg_sound,{ channel=1, loops=-1 })

storyboard.gotoScene( "newgame" )
  
  

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):


-- COURIER 2023
-- By Nils Hellberg for CoronaBlitz #1

-- BUG LIST
-- Position on start
-- Scroll bug when no content
-- Alert windows and scene switching sometimes causes a crash

-- TODO
-- Graphics (player, alley, buildings, enemies)
-- Options (music volume
-- HUD (turns)


-- LICENSE
-- All code and Graphics: CC BY
-- Music by Amygdala: CC BY-NC http://www.ektoplazm.com/free-music/amygdala-modus-operandi
-- Thanks to Mario for the hex map tutorial: http://www.iswdev.com/2011/05/20/hex-map-creation-using-corona/

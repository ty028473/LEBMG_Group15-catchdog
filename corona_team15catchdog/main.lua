-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

display.setStatusBar(display.HiddenStatusBar)


local composer = require( "composer" )
local scene = composer.newScene()
collectgarbage("collect")
-- your code goes here...

local memUsage_str = string.format( "MEMORY= %.3f KB", collectgarbage( "count" ) )
print( memUsage_str .. " | TEXTURE= "..(system.getInfo("textureMemoryUsed")/1048576) )
composer.gotoScene("game_menu")

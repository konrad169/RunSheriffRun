-- Requirements
local composer = require "composer"
local fx = require "com.ponywolf.ponyfx"

-- Our border wall class

local M = {}

local color = require "com.ponywolf.ponycolor"
-- Variables local to scene

function M.new( x1, y1, x2, y2) 

local scene = composer.getScene(composer.getSceneName("current"))


local wall = display.newLine(x1, y1, x2, y2)
physics.addBody(wall, "static", {isSensor=true }) -- 
wall.strokeWidth = 1
wall.isLimit=true
wall.isVisible = false 
wall:setStrokeColor(color.hex2rgb("6D9DC5"))

return wall
end

return M
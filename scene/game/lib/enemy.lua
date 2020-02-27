-- Requirements
local composer = require "composer"
local fx = require "com.ponywolf.ponyfx"

-- Our hero class

local M = {}

local color = require "com.ponywolf.ponycolor"
-- Variables local to scene

function M.new(instance, run, groundStart) 

local scene = composer.getScene(composer.getSceneName("current"))
instance.isEnemy = true
instance.isVisible = false 

local parent = instance.parent
local x,y= instance.x,instance.y

local sheetDataEnemyDX = { width = 178, height =296, numFrames = 4, sheetContentWidth = 712, sheetContentHeight = 296 }
local sheetEnemyDX = graphics.newImageSheet( "scene/game/img/enemydx.png", sheetDataEnemyDX )
local sheetDataEnemySX = { width = 174, height =300, numFrames = 4, sheetContentWidth = 696, sheetContentHeight = 300 }
local sheetEnemySX = graphics.newImageSheet( "scene/game/img/enemysx.png", sheetDataEnemySX )
local sequenceData = {
    { name = "idleDX", sheet = sheetEnemyDX,  frames = { 1,3,4 },  time = 750, loopCount=0 },
    { name = "idleSX", sheet = sheetEnemySX,  frames = { 2,1,3 },  time = 750, loopCount=0 }
    }

instance = display.newSprite( parent, sheetEnemyDX, sequenceData )
instance.x , instance.y = x,y
instance:setSequence("idleDX")
instance:play()

instance.anchorX, instance.anchorY = 0.5 , 0.5
instance:scale(0.5,0.5) -- 0.275,0.275

physics.addBody(instance, "dynamic",{ box = { halfWidth=43, halfHeight=74, x=0, y=0, angle=0 }} )
instance.isFixedRotation = true

--Attivo i nemici
local step = 2

local function enterFrame()
    local posx = instance.x 
    local posy = instance.y

    if posx <= groundStart+120 or posx>=groundStart-120+run then
      step = step * (-1)
      if step > 0 then  
        instance:setSequence("idleDX")
      else
        instance:setSequence("idleSX")
      end
      instance:play()

    end
      instance.x = instance.x + step
      instance.y = posy
    
end


function instance:collision(event)

    local phase, other = event.phase, event.other
   
    if  phase == "began" and other.isBullet then
      audio.play(scene.sounds.ouch, {channel=2})
      display.remove(instance)
      display.remove(other)
      scene.score:add(100)

    
    elseif phase == "began" and other.isHero then
      display.remove(instance)

      other:hurt()
  end
end

instance:addEventListener("collision")
Runtime:addEventListener("enterFrame",enterFrame)

function instance:finalize()
  -- On remove, cleanup instance, or call directly for non-visual

  Runtime:removeEventListener( "enterFrame", enterFrame )
  instance = nil
end

-- Add a finalize listener (for display objects only, comment out for non-visual)
instance:addEventListener( "finalize" )
   

return instance
end

return M


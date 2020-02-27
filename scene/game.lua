-- Requirements
local composer = require "composer"
local physics = require "physics"
local terrains = require "scene.game.lib.terrain"
local heroes = require "scene.game.lib.hero"
local heartbar = require "scene.game.lib.heartBar"
local ammoBar = require "scene.game.lib.ammoBar"
local vjoy = require "com.ponywolf.vjoy"
local fx = require "com.ponywolf.ponyfx"
local scoring = require "scene.game.lib.score"

-- Variables local to scene
local scene = composer.newScene()
local topSpeed = 400
local world, hero, buildings, background, shield, ammo,backgroundMusic,buttons
local terrain, terrainCount, spawnTerrain = {}, 1
function math.clamp(val, min, max) return math.min(math.max(val, min), max) end

--physics.setDrawMode("hybrid")

buttons=display.newGroup()
local right,left,jump
function scene:create( event )
  -- Mostra comandi
   if not right then right = vjoy.newButton("scene/game/img/ui/wheelButtonRight.png", "right") end
   left = vjoy.newButton("scene/game/img/ui/wheelButtonLeft.png", "left")
   jump = vjoy.newButton("scene/game/img/ui/jumpButton.png", "space")
  right.x, right.y = display.screenOriginX + 276, display.screenOriginY + display.contentHeight - 96
  left.x, left.y = display.screenOriginX + 128, display.screenOriginY + display.contentHeight - 96
  jump.x, jump.y = -display.screenOriginX + display.contentWidth - 128, display.screenOriginY + display.contentHeight - 96
  right.xScale, right.yScale = 0.65, 0.65
  left.xScale, left.yScale = 0.65, 0.65
  jump.xScale, jump.yScale = 0.65, 0.65

  buttons:insert(left)
  buttons:insert(right)
  buttons:insert(jump)
 
  local sceneGroup = self.view -- add display objects to this group
  physics.start(true)
  physics.setGravity(0, 32)

  local sndDir = "scene/game/sfx/"
	scene.sounds = {
		jump = audio.loadSound( sndDir .. "jump.mp3" ),
		shoot = audio.loadSound( sndDir .. "shoot.mp3" ),
		grind = audio.loadSound( sndDir .. "grind.mp3" ),
		death = audio.loadSound( sndDir .. "death.mp3" ),
		ride = audio.loadSound( sndDir .. "ride.mp3" ),
		coin = audio.loadSound( sndDir .. "coin.mp3" ),
		thud = audio.loadSound( sndDir .. "thud.mp3" ),
		ouch = audio.loadSound( sndDir .. "ouch.mp3" ),
		city = audio.loadSound( sndDir .. "loops/city.mp3" ),
  }
  backgroundMusic=audio.loadStream("scene/game/sfx/backgroundmusic.mp3")

  -- build a random background
	background = display.newGroup() -- this will hold our background
  sceneGroup:insert(background)


  	-- add background layer
  local buildingImages = { "scene/game/img/BG.png"}
  local building = display.newImageRect(background, buildingImages[1],display.actualContentWidth, display.actualContentHeight)
  building.anchorX, building.anchorY = 0.05,0
  
  -- the "world" group is our scrolling layer
	world = display.newGroup() -- this will hold our world
  sceneGroup:insert(world)

	-- make a hero
  hero = display.newRect(world, 164, 586, 128, 128) 
  hero = heroes.new(hero)

  -- contatori vite e munizioni
  shield = heartbar.new(sceneGroup) 
  shield.x =  -display.screenOriginX + shield.contentWidth / 2 + 100
  shield.y = display.screenOriginY + 42
  hero.shield = shield

  ammo = ammoBar.new(sceneGroup)
  ammo.x= -display.screenOriginX + shield.contentWidth / 2 +400
  ammo.y=display.screenOriginY + 42
  hero.ammo=ammo

  world:insert(hero)
  local space = (128*2.5)

  -- these buildings ar the closer parallax layer
  buildings = display.newGroup() -- this will hold our buildings
  world:insert(buildings)

  -- create first terrain
  terrain[1] = terrains.new(world,  100,   650, 1024,0,true)
  terrain[2] = terrains.new(world,  100+1024+space,   650, 1024,0,true)


  -- makes new, random ground in front of the player, see the terrain.lua class
	-- (128*1.5) è l'ampiezza fissa tra un blocco e l'altro
  function spawnTerrain()
    local run =  (math.random(1,4)) * 512
    local drop = (math.random(-3,2)) * (50)

    
    -- aumento lo spazio tra le piattaforme
    -- x = estremo sinistro
    local x,y = ((terrain[#terrain][1].x)+space), terrain[#terrain][1].y
    local lastRun, lastDrop = (terrain[#terrain].run), terrain[#terrain].drop

		if drop == 0 then
      terrain[#terrain+1] = terrains.new(world, x+lastRun, y+lastDrop-175,run,drop,false)
      terrain[#terrain]:toBack()

      terrain[#terrain+1] = terrains.new(world, x+lastRun, y+lastDrop+175,run,drop,false)
      terrain[#terrain]:toBack()

		else
      -- CAMBIO!! genero due pezzi di ground "sfalzati" (ciascuno lungo run/2) invece che due uguali sovrapposti
      terrain[#terrain+1] = terrains.new(world, x+lastRun, y+lastDrop,run/2,drop,false)
      terrain[#terrain]:toBack()
			
      terrain[#terrain+1] = terrains.new(world, x+lastRun+(run/2)+space, y+lastDrop,run/2,drop*(math.random(3)-0.5),false)
      terrain[#terrain]:toBack()
    end
  end

  -- creo 54 blocchi
  for _=1, 54 do spawnTerrain() end

  local function afterTimer()
  end
  timer.performWithDelay(5000, afterTimer, 1)
 
  -- Add restart button
  restart = display.newImageRect( sceneGroup, "scene/game/img/ui/replayButton.png", 70, 70 )
  restart.x = display.screenOriginX + restart.contentWidth / 2 + 22
  restart.y = display.screenOriginY + restart.contentHeight / 2 + 100

  -- Touch restart...
  function restart:tap(event)
    self:removeEventListener("tap")
    --audio.play(scene.sounds.bail)
    fx.fadeOut( function()
        composer.gotoScene( "scene.refresh")
      end )
  end

  -- Add back button
  back = display.newImageRect( sceneGroup, "scene/game/img/ui/playButton.png", 70, 70 )
  back.x = display.screenOriginX + back.contentWidth / 2 + 22
  back.y = display.screenOriginY + back.contentHeight / 2 + 18
  back.xScale = -1

  -- Touch the back
  function back:tap(event)
   physics.stop()
    self:removeEventListener("tap")
   -- audio.play(scene.sounds.bail)
    fx.fadeOut( function()
        composer.gotoScene( "scene.menu")
        audio.stop(1)
        display.remove(buttons)
        buttons:remove(left)
        buttons:remove(right)
       buttons:remove(jump)
        left=nil
        right=nil
       jump=nil
        composer.removeScene("scene.game")
        
      end )
  end

  -- Add score 
  scene.score = scoring.new()
  local score = scene.score
  score.x = -display.screenOriginX + display.contentWidth - score.contentWidth / 2 - 33 - restart.width
  score.y = display.screenOriginY +70
  sceneGroup:insert(score)
end

local worldScale = 0.9

local function enterFrame(event)
  if buttons.isVisible then
  buttons:toFront()
  end
  if not hero.getLinearVelocity then return false end
  if hero.isDead then return false end
  
  scene.score:add(1)

  local vx, vy = hero:getLinearVelocity()
    
  local x = terrain[terrainCount].contentBounds.xMax
	if x < -display.actualContentWidth * 2 then
		display.remove(terrain[terrainCount])
		terrainCount = terrainCount + 1
		spawnTerrain()
	end

  --increase difficulty of the game
	if vx > topSpeed then vx = topSpeed 
    hero:setLinearVelocity(vx,vy)
  elseif scene.score:get() < 1000 then
    hero:applyForce( 50 ,0 , hero.x, hero.y )
    topSpeed=500
  elseif scene.score:get() < 2000 then
    hero:applyForce( 70 ,0 , hero.x, hero.y )
    topSpeed=600
  elseif scene.score:get() < 3000 then
    hero:applyForce( 90 ,0 , hero.x, hero.y )
    topSpeed=700
  else
    hero:applyForce( 120 ,0 , hero.x, hero.y )
    topSpeed=750

  end

  if hero.isOnGround and not hero.isPlaying and not hero.inAir and not hero.isJumping then 
    hero:walkRight()
  end

  -- slow down if we are not in the air
  hero.linearDamping = hero.inAir and 0.15 or 0.01
  hero.linearDamping = (hero.isUpsideDown) and 1.95 or hero.linearDamping

 	-- keep our scale between 0.5 and 1.0
  worldScale = math.clamp(worldScale, 0.3, 1)
  world.xScale, world.yScale= worldScale, worldScale

  -- easiest way to scroll a map based on a character
	-- find the difference between the hero and the display center
	-- and move the world to compensate
	local hx, hy = hero:localToContent(0,0)
	hx, hy = display.contentCenterX/2 - hx, display.contentCenterY - hy
	world.x, world.y = world.x + hx, world.y + hy - 100

end

function scene:show( event )
  local phase = event.phase
  if ( phase == "will" ) then
    Runtime:addEventListener("enterFrame", enterFrame)
  elseif ( phase == "did" ) then
    audio.play( backgroundMusic, { channel=1, loops=-1 ,fadeIn=750} )
		restart:addEventListener("tap")
		back:addEventListener("tap")

  end
end

function scene:hide( event )
  local phase = event.phase
  if ( phase == "will" ) then
  elseif ( phase == "did" ) then
    Runtime:removeEventListener("enterFrame", enterFrame)
    display:remove(buttons)
    audio.stop(1)
    audio.stop(2)
  end
end

function scene:destroy( event )
  display:remove(buttons)

	for s,v in pairs( self.sounds ) do
		self.sounds[s] = nil
	end
end

Runtime:addEventListener("key", enterFrame)
scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene

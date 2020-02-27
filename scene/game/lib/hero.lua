-- game.scene.hero
local fx = require "com.ponywolf.ponyfx"

-- Our hero class

local M = {}

local composer = require "composer"

local color = require "com.ponywolf.ponycolor"

function M.new(instance)

  local scene = composer.getScene(composer.getSceneName("current"))

  instance.isDead = false
  instance.isHero = true
  instance.inAir = true
  instance.isJumping = true
  instance.doubleJump=false
  instance.firstJet=false
  instance.level = false
  instance.isVisible = false
  instance.isOnGround=false

  local parent = instance.parent
  local x,y= instance.x , instance.y


  -- Load spritesheet
  local sheetDataJump = { width = 641, height = 542, numFrames = 10, sheetContentWidth = 6410, sheetContentHeight = 542 }
  local sheetDataJet = { 
    frames =
    {
        {   
            x = 0,
            y = 145,
            width = 442,
            height = 397
        },
        {   
            x = 644,
            y = 142,
            width = 437,
            height = 400
        },
        {   
            x = 1277,
            y = 142,
            width = 437,
            height = 400
        },
        {   
            x = 1918,
            y = 142,
            width = 437,
            height = 400
        },
        {   -- 5) laser
            x = 2557,
            y = 142,
            width = 437,
            height = 400
        },
    },
  }

  local sheetDataWalk = { width = 641, height =542, numFrames = 8, sheetContentWidth = 5128, sheetContentHeight = 542 }
  local sheetDataShoot = { width = 641, height = 542, numFrames = 3, sheetContentWidth = 1923, sheetContentHeight = 542 }
  local sheetJet = graphics.newImageSheet( "scene/game/img/jetslide.png", sheetDataJet )

  local sheetShoot = graphics.newImageSheet( "scene/game/img/shoot.png", sheetDataShoot )
  local sheetJump = graphics.newImageSheet( "scene/game/img/newJump.png", sheetDataJump )
  local sheetWalk = graphics.newImageSheet( "scene/game/img/newwalk.png", sheetDataWalk )
	local sequenceData = {
		{ name = "idle", sheet = sheetWalk,  frames = { 1,2,3,4,5,6,7,8 },  time = 5, loopCount=1 },
		{ name = "jump", sheet = sheetJump, frames = { 1,2,3,4,5,6,7,8, 9,10 }, time = 1000, loopCount = 1 },
   { name = "walkRight", sheet = sheetWalk, frames = { 1,2,3,4,5,6,7,8 }, time = 250, loopCount=1 },

   { name = "jetSlide", sheet = sheetJet, frames = {1,2,3,4,5},  time = 750, loopCount=1 },
  
  {name="fireLaser", sheet= sheetShoot, frames ={1,2,3}, time=250, loopCount=1},
  }
  local sheetOptions =
  {
    frames =
    {
      {   -- 5) laser
            x = 98,
            y = 265,
            width = 14,
            height = 40
        },
    },
  }

instance = display.newSprite( parent, sheetWalk, sequenceData )
instance.x , instance.y = x ,y
instance.anchorX, instance.anchorY = 0.5 , 0.5
instance.isHero  = true
instance:scale(0.275,0.275)
instance:setSequence( "walkRight" )

physics.addBody(instance, "dynamic", { density = 0.1,friction = 0.7 , bounce = 0.0, 
                                      box = { halfWidth=32, halfHeight=60, x=0, y=0, angle=30 },
                                      filter = { groupIndex = -1 } 
                                    } )
instance.isFixedRotation = true

  function instance:reset()
    self:translate(0,-128)
    self.timeout = 0
  end


  function instance:collision(event)
    if event.phase == "began" then
      if  event.other.isGround then
        self.firstJet=false
        self.inAir = false
        self.isJumping = false
        self.onRail = false
        self.doubleJump=false
        self.isOnGround=true

      elseif event.other.isLimit then
        self.isOnGround=false


      elseif event.other.isEndGameLine then
        self.isDead=true
        Runtime:removeEventListener("enterFrame", enterFrame)
        Runtime:removeEventListener("key", enterFrame)

        composer.showOverlay("scene.hiscore", { isModal = true, effect = "fromTop",  params = { myScore = scene.score:get() }} )
        display.remove( self )  
      end
    end
  end

  instance:addEventListener("collision")

  local lastEvent = {}
  -- assegno comandi
  local function key(event)
    
    if ( event.phase == lastEvent.phase ) and ( event.keyName == lastEvent.keyName ) then return false end  -- Filter repeating keys

    if event.phase == "down" and instance then
      --doublejump
      if (event.keyName == "up" or event.keyName == "space") and instance.inAir and not instance.doubleJump then
        audio.play(scene.sounds.jump, {channel=2})
        instance.doubleJump=true
        instance:jump()
      
        
      elseif event.keyName == "right" and not instance.firstJet then
        instance:jet()
        instance.firstJet=true
        audio.play(scene.sounds.grind, {channel=2})


      elseif event.keyName == "left" then
        if instance.ammo:getAmmo() > 0 then
          instance:fireLaser()
          instance.ammo:shoot()
        end


      --  jump
      elseif (event.keyName == "up" or event.keyName == "space") and not instance.isJumping then
        instance.inAir = true
        instance.isJumping = true
        instance:jump()
        audio.play(scene.sounds.jump, {channel=2})
      end
    end
    lastEvent = event
  end

  function instance:jump()
    self:applyLinearImpulse( 3.0 , -15.0 , self.x, self.y )--applyLinearImpulse( 0, -250 )
    self:setSequence( "jump" )
    self:play()
  end

  function instance:walkRight()
    if not self.inAir then
      self:applyForce( 300 ,0 , self.x, self.y )--applyLinearImpulse( 0, -250 )
      self:setSequence("walkRight")
      self:play()
    end
  end

  function instance:jet()
    instance.isSliding=true
    self:applyLinearImpulse( 2000 , 0 , self.x, self.y )--applyLinearImpulse( 0, -250 )
    self:setSequence("jetSlide")
    self:play()
    timer.performWithDelay(750, function()    instance.isSliding=false end    )
  end

  function instance:fireLaser()
 
      local newLaser = display.newImageRect(parent,"scene/game/img/bullet.png", 30, 30 )


      physics.addBody(newLaser, "dynamic", { isSensor=true } )
     
      newLaser.isBullet = true
      newLaser.myName = "laser"
   
      newLaser.x = self.x
      newLaser.y = self.y
      newLaser:toBack()

      transition.to( newLaser, { x=newLaser.x+1000, y=newLaser.y+3, time=500,
          onComplete = function() display.remove( newLaser ) end
      } )
      self:setSequence( "fireLaser" )
      audio.play(scene.sounds.shoot, {channel=2})
      
      self:play()
  end

  function instance:hurt()    
    instance.alpha=0.5
    timer.performWithDelay(500, function() instance.alpha=1 end)

		audio.play( scene.sounds.death, {channel=2} )
		if self.shield:damage() <= 0 then
			-- We died
			composer.showOverlay("scene.hiscore", { isModal = true, effect = "fromTop",  params = { myScore = scene.score:get() }} )
      display.remove( self )
		
			instance.isDead = true
      self:finalize()
    
		end
	end


 function instance:stop()
   instance:setSequence("idle")
 end

function instance:finalize()
  Runtime:removeEventListener("key", key)
end

instance:addEventListener("finalize")
Runtime:addEventListener("key", key)

return instance
end

return M

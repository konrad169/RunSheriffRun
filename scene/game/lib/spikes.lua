-- game.scene.hero

-- Our hero class

local M = {}

local composer = require "composer"

function M.new(instance, heroColor)

  local scene = composer.getScene(composer.getSceneName("current"))
  instance.isSpike=true

  physics.addBody(instance, "dynamic", {friction = 0.0, bounce = 0, isSensor = true} )
  instance.gravityScale = 0



  function instance:collision(event)

    local phase, other = event.phase, event.other

    if phase == "began" and other.isHero then
      print("had collision")

      if other.isSliding then
        display.remove( instance )
      else
        display.remove( instance )
        other:hurt()
      end
  end
end

instance:addEventListener("collision")



return instance
end

return M

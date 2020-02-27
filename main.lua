-- Requirements
local composer = require "composer"

-- Variables local to scene
require("com.ponywolf.joykey").start()


-- add virtual buttons to mobile
system.activate("multitouch")


  audio.reserveChannels( 1 )
  audio.reserveChannels( 2 )

composer.gotoScene( "scene.menu", { params={ } } )

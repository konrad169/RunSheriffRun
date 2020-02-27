-- Include modules/libraries
local composer = require( "composer" )
local fx = require( "com.ponywolf.ponyfx" )
local tiled = require( "com.ponywolf.ponytiled" )
local json = require( "json" )
local vjoy = require "com.ponywolf.vjoy"


-- Variables local to scene
local menu, bgMusic, ui, menumusic, settings,background, title1,title2, topScores,scoresList

-- Create a new Composer scene
local scene = composer.newScene()

local function key(event)
	-- go back to menu if we are not already there
	if event.phase == "up" and event.keyName == "escape" then
		if not (composer.getSceneName("current") == "scene.menu") then
			fx.fadeOut(function ()
					composer.gotoScene("scene.menu")
			end)
		end
	end
end

-- This function is called when scene is created
function scene:create( event )
	local sceneGroup = self.view  -- Add scene display objects to this group
	background= display.newImageRect("scene/game/img/backgroundforsepng.png",1480,800)
	background.x=display.contentCenterX
	background.y=display.contentCenterY
	background:toBack()

	title1 = display.newText(sceneGroup,"RUN",display.contentCenterX-500, 	display.contentCenterY-80, "scene\/game\/font\/Pentagon.ttf")
	title1.size=240
	title1:setFillColor(0,0,0) 

	title2 = display.newText(sceneGroup,"RUN!",display.contentCenterX+510, 	display.contentCenterY-80, "scene\/game\/font\/Pentagon.ttf")
	title2.size=240
	title2:setFillColor(0,0,0)
	
	

	-- stream music
	menumusic=audio.loadStream("scene/game/sfx/menumusic.mp3")


	-- Load our UI
	local uiData = json.decodeFile( system.pathForFile( "scene/menu/ui/title.json", system.ResourceDirectory ) )
	menu = tiled.new( uiData, "scene/menu/ui" )
	menu.x, menu.y = display.contentCenterX - menu.designedWidth/2, display.contentCenterY - menu.designedHeight/2

	menu.extensions = "scene.menu.lib."
	menu:extend("button", "label")

	local pergamena,textSound,textMusic, textDev,soundOn,musicOn,madeBy,text1,text2,text3,text4,helpText1,helpText2,helpText3,helpText4

	function ui(event)
		local phase = event.phase
		local name = event.buttonName
		if phase == "released" then
			audio.play(buttonSound, {channel=2})
			if name == "start" then
				fx.fadeOut( function()
						composer.gotoScene( "scene.game", { params = {} } )
						composer.removeScene("game.menu")
					end )
			
			elseif name == "help" then
				--menu:findLayer( "help" ).isVisible = not menu:findLayer( "help" ).isVisible
				if not pergamena and not settings then
					pergamena = display.newImageRect( sceneGroup, "scene/menu/ui/helpBackground.png", 850, 600 )
					pergamena.x = display.contentCenterX
					pergamena.y = display.contentCenterY - 100

					helpText1="Only 3 Rules:"
					text1 = display.newText(sceneGroup,helpText1,display.contentCenterX+15,display.contentCenterY - 220,"scene\/game\/font\/Pentagon.ttf")
					text1.size=65
					text1:setFillColor(0,0,0)

					helpText2="Slide to destroy boxes"
					text2 = display.newText(sceneGroup,helpText2,display.contentCenterX+15,display.contentCenterY - 130,"scene\/game\/font\/Pentagon.ttf")
					text2.size=65
					text2:setFillColor(0,0,0)

					helpText3="Shoot to kill enemies"					
					text3 = display.newText(sceneGroup,helpText3,display.contentCenterX+15,display.contentCenterY - 40,"scene\/game\/font\/Pentagon.ttf")
					text3.size=65
					text3:setFillColor(0,0,0)

					helpText4="Run as much as you can!"
					text4 = display.newText(sceneGroup,helpText4,display.contentCenterX+15,display.contentCenterY + 50,"scene\/game\/font\/Pentagon.ttf")
					text4.size=65
					text4:setFillColor(0,0,0)

				elseif pergamena then 
					sceneGroup:remove(text1)
					sceneGroup:remove(text2)
					sceneGroup:remove(text3)
					sceneGroup:remove(text4)
					text1=nil
					text2=nil
					text3=nil
					text4=nil
					sceneGroup:remove(pergamena)
					pergamena:removeSelf()
					pergamena=nil
				end
				
			elseif name =="options" then
				if not settings and not pergamena then
					settings = display.newImageRect(sceneGroup, "scene/menu/ui/helpBackground.png", 500, 500 )
					settings.x = display.contentCenterX
					settings.y = display.contentCenterY - 100
					
					textSound = display.newText(sceneGroup,"Sound",display.contentCenterX-45, display.contentCenterY-210, "scene\/game\/font\/Pentagon.ttf")
					textSound.size=65
					textSound:setFillColor(0,0,0)

					soundOn = vjoy.newButton("scene/menu/ui/noeffects.png", "soundOn")
					soundOn.x, soundOn.y = textSound.x + 100 + 10, textSound.y
					soundOn.xScale, soundOn.yScale = 0.35, 0.35
					sceneGroup:insert(soundOn)

					textMusic = display.newText(sceneGroup,"Music",display.contentCenterX-45, display.contentCenterY-100, "scene\/game\/font\/Pentagon.ttf")
					textMusic.size=65
					textMusic:setFillColor(0,0,0)

					musicOn = vjoy.newButton("scene/menu/ui/nosound.png", "musicOn")
					musicOn.x, musicOn.y = textMusic.x + 100 + 10, textMusic.y
					musicOn.xScale, musicOn.yScale = 0.35, 0.35
					sceneGroup:insert(musicOn)

					textDev = display.newText(sceneGroup,"Team",display.contentCenterX-45, display.contentCenterY+10, "scene\/game\/font\/Pentagon.ttf")
					textDev.size=65
					textDev:setFillColor(0,0,0)

					madeBy = vjoy.newButton("scene/menu/ui/team.png", "madeBy")
					madeBy.x, madeBy.y = textDev.x + 100 + 10, textDev.y
					madeBy.xScale, madeBy.yScale = 0.35, 0.35
					sceneGroup:insert(madeBy)


				elseif settings then
					sceneGroup:remove(textSound)
					sceneGroup:remove(textMusic)
					sceneGroup:remove(textDev)
					textSound=nil
					textMusic=nil
					textDev=nil

					soundOn:removeSelf()
					musicOn:removeSelf()
					madeBy:removeSelf()
					
					sceneGroup:remove(settings)
					settings:removeSelf()
					settings=nil
				end
			end

		elseif phase=="down" and event.keyName =="soundOn" then
			if audio.getVolume( {channel=2}) == 0.0  then
				audio.setVolume(1.0, {channel=2})
				soundOn.alpha=1
			else 
				audio.setVolume(0.0, {channel=2})
				soundOn.alpha=0.35			
			end

		elseif phase=="down" and event.keyName =="musicOn" then
			if audio.getVolume({channel=1}) == 0  then
				audio.setVolume(1.0 , {channel=1})
				musicOn.alpha=1
			else 
				audio.setVolume(0.0, {channel=1})
				musicOn.alpha=0.35
			end


		end
		
		return true	
	end

	-- Transtion in logo
	transition.from( menu:findObject( "logo" ), { xScale = 2.5, yScale = 2.5, time = 333, transition = easing.outQuad } )
	
	sceneGroup:insert( menu )

	-- escape key
	Runtime:addEventListener("key", ui)
end

-- This function is called when scene comes fully on screen
function scene:show( event )
	local phase = event.phase
	if ( phase == "will" ) then
		fx.fadeIn()
	elseif ( phase == "did" ) then
		-- add UI listener
		Runtime:addEventListener( "ui", ui)	
		audio.play( menumusic, { channel=1, loops=-1 ,fadeIn=750} )
	
		timer.performWithDelay( 10, function()
				audio.play( bgMusic, { loops = -1, channel = 2 } )
				audio.fade({ channel = 1, time = 333, volume = 1.0 } )
			end)	
	end
end

-- This function is called when scene goes fully off screen
function scene:hide( event )
	local phase = event.phase
	if ( phase == "will" ) then
		-- remove UI listener
		Runtime:removeEventListener( "ui", ui)		
	elseif ( phase == "did" ) then
		audio.fadeOut( { channel = 1, time = 1500 } )
		audio.stop(1)
	end
end

-- This function is called when scene is destroyed
function scene:destroy( event )
	audio.stop()  -- Stop all audio
	audio.dispose( bgMusic )  -- Release music handle
	Runtime:removeEventListener("key", key)
end

scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "hide" )
scene:addEventListener( "destroy" )

return scene

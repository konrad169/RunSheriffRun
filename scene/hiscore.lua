-- Requirements
local composer = require "composer"
local fx = require "com.ponywolf.ponyfx" 
local tiled = require "com.ponywolf.ponytiled"
local json = require "json" 

local hiscore,ui
local scoresTable = {}
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
local currentScore 

local function loadScores()
  local file = io.open( filePath, "r" )
  if file then
      local contents = file:read( "*a" )
      io.close( file )
      scoresTable = json.decode( contents )
  end
  if ( scoresTable == nil or #scoresTable == 0 ) then
      scoresTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
  end
end

local function saveScores()
  for i = #scoresTable, 11, -1 do
      table.remove( scoresTable, i )
  end
  local file = io.open( filePath, "w" )
  if file then
      file:write( json.encode( scoresTable ) )
      io.close( file )
  end
end

-- Variables local to scene
local scene = composer.newScene()

function scene:create( event )
  local sceneGroup = self.view -- add display objects to this group
  local parent = composer.getScene("scene.game")

  -- manage scores
  loadScores()
  -- Insert the saved score from the last game into the table, then reset it
  table.insert( scoresTable, event.params.myScore )
  local function compare( a, b )
    return a > b
  end
  table.sort( scoresTable, compare )
  saveScores()

  -- Load our highscore tiled map
  local uiData = json.decodeFile( system.pathForFile( "scene/menu/ui/highScore.json", system.ResourceDirectory ) )
  hiscore = tiled.new( uiData, "scene/menu/ui" )
  hiscore.x, hiscore.y = display.contentCenterX - hiscore.designedWidth/2, display.contentCenterY - hiscore.designedHeight/2
  hiscore.extensions = "scene.menu.lib."
  hiscore:extend("button", "label")
  sceneGroup:insert(hiscore)
  
  local scoreTitle = display.newText( sceneGroup, "your score is", display.contentCenterX-130, display.contentCenterY-200, "scene\/game\/font\/Pentagon.ttf", 55 )
  scoreTitle.anchorX = 0
  scoreTitle:setFillColor(0,0,0)

  currentScore = display.newText( sceneGroup, event.params.myScore, display.contentCenterX-40, display.contentCenterY-100, "scene\/game\/font\/Pentagon.ttf", 110 )
  currentScore.anchorX = 0
  currentScore:setFillColor(0,0,0)

  local top3Text = display.newText( sceneGroup, "Best scores", display.contentCenterX-100, display.contentCenterY - 0, "scene\/game\/font\/Pentagon.ttf", 52 )
  top3Text.anchorX = 0
  top3Text:setFillColor(0,0,0)

  for i = 1, 3 do
    if ( scoresTable[i] ) then
        local yPos = 410 + ( i * 56 )
        local rankNum = display.newText( sceneGroup, i .. ".", display.contentCenterX-20, yPos, "scene\/game\/font\/Pentagon.ttf", 50 )
            rankNum:setFillColor( 0,0,0 )
            rankNum.anchorX = 1
 
            local thisScore = display.newText( sceneGroup, scoresTable[i], display.contentCenterX-0, yPos, "scene\/game\/font\/Pentagon.ttf", 50 )
            thisScore.anchorX = 0
            thisScore:setFillColor(0,0,0)

    end
  end

  function ui(event)
    local phase = event.phase
    local name = event.buttonName
    if phase == "released" then 
      if name == "restart"then
				audio.play(parent.sounds.bail)		
        fx.fadeOut( function()
            composer.hideOverlay()
            composer.gotoScene( "scene.refresh", { params = {} } )
          end )
      end
    end
    if event.keyName == "space" then 
      audio.play(parent.sounds.bail)		
      fx.fadeOut( function()
          composer.hideOverlay()
          composer.gotoScene( "scene.refresh", { params = {} } )
          end )
      end
    return true	
  end

  Runtime:addEventListener("key",ui)


end



-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)


	elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
    Runtime:addEventListener( "ui", ui)	


	end
end


-- hide()
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListener("key",ui)		    

  	end
end


function scene:destroy( event )
  local sceneGroup = self.view
end



scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")





return scene
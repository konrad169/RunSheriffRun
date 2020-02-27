local M = {}

local color = require "com.ponywolf.ponycolor"
local pickUpBonus = require "scene.game.lib.pickUpBonus"
local enemyy = require "scene.game.lib.enemy"
local fire = require "scene.game.lib.fire"


local physics = require "physics"
local spikes = require "scene.game.lib.spikes"
local borders = require "scene.game.lib.border"


local imgDir = "scene/game/img/"
local spikesImages = {"spike1.png","spike2.png", "spike3.png", "spike4.png", "spike5.png"}
local decorImageslittle = { "4.png", "8.png","11.png",}
local decorImagesmedium = { "1.png","12.png",}
local decorImagesbig = { "3.png","5.png",}

function M.new(world, x, y, run, drop,isFirst)

  -- build a "chunk" of the map
  local instance = display.newGroup()

  local spine
  local life
  local malus
  local ammo
  local enemy
  local enemyX
  local enemyY
  

  -- non metto ostacoli sul primo blocco!
  if  not isFirst then 

    local randomPickUp = math.random(4)

      -- costruisco ostacoli sui vari "run"
      if run==512 then
        enemyX = x+(run/2)
        enemyY = y+drop-25

        enemy = display.newRect(world,enemyX, enemyY, 128, 128)
        enemy = enemyy.new(enemy,run,x)
        
        local decor = display.newImage(world, imgDir .. decorImageslittle[math.random(#decorImageslittle)])
        decor.xScale, decor.yScale = 0.75,0.75
        decor.anchorX, decor.anchorY = 0.5, 0.5    
        decor.x, decor.y = x + (math.random(256,run)) - (135/8), y + drop - (52/8) -4
        decor:toBack()
        local decor = display.newImage(world, imgDir .. decorImagesmedium[math.random(#decorImagesmedium)])
        decor.xScale, decor.yScale = 0.75,0.75
        decor.anchorX, decor.anchorY = 0.5, 0.5    
        decor.x, decor.y = x + (math.random(256,run)) - (135/8), y + drop - (90/8) -4
        decor:toBack()
        local decor = display.newImage(world, imgDir .. decorImagesbig[math.random(#decorImagesbig)])
        decor.xScale, decor.yScale = 0.75,0.75
        decor.anchorX, decor.anchorY = 0.5, 0.5    
        decor.x, decor.y = x + (math.random(256,run)) - (135/8), y + drop - (320/8) -4
        decor:toBack()
        
        if randomPickUp==1 then
          life = display.newImageRect(world, imgDir .. 'heart.png' , 50,50)
          life.isLife=true
          life.x = x+(run/2)
          life.y= y+drop-25 
          life = pickUpBonus.new(life)

        elseif randomPickUp==2 then 
          malus = display.newImageRect(world, imgDir .. 'malus.png' , 50,50)
          malus.isMalus=true
          malus.x = x+(run/2)
          malus.y= y+ drop -25
          malus = pickUpBonus.new(malus)
        
        elseif randomPickUp==3 then
          ammo = display.newImageRect(world, imgDir .. 'bullet2.png' , 50,50)
          ammo.isAmmo=true
          ammo.x = x+(run/2)
          ammo.y= y+ drop -25
          ammo = pickUpBonus.new(ammo)

        end

      elseif run==1024 then
        enemyX = x+(run/2)
        enemyY = y+drop-25

        local decor = display.newImage(world, imgDir .. decorImageslittle[math.random(#decorImageslittle)])
        decor.xScale, decor.yScale = 0.75,0.75
        decor.anchorX, decor.anchorY = 0.5, 0.5    
        decor.x, decor.y = x + (math.random(256,run)) - (135/8), y + drop - (52/8) -4
        decor:toBack()
        local decor = display.newImage(world, imgDir .. decorImagesmedium[math.random(#decorImagesmedium)])
        decor.xScale, decor.yScale = 0.75,0.75
        decor.anchorX, decor.anchorY = 0.5, 0.5    
        decor.x, decor.y = x + (math.random(256,run)) - (135/8), y + drop - (90/8) -4
        decor:toBack()
        local decor = display.newImage(world, imgDir .. decorImagesbig[math.random(#decorImagesbig)])
        decor.xScale, decor.yScale = 0.75,0.75
        decor.anchorX, decor.anchorY = 0.5, 0.5    
        decor.x, decor.y = x + (math.random(256,run)) - (135/8), y + drop - (320/8) -4
        decor:toBack()
      

        if randomPickUp==1 then
          life = display.newImageRect(world, imgDir .. 'heart.png' , 50,50)
          life.isLife=true
          life.x = x+(run/2)
          life.y= y+drop-25 
          life = pickUpBonus.new(life)

        elseif randomPickUp==2 then 
          malus = display.newImageRect(world, imgDir .. 'malus.png' , 50,50)
          malus.isMalus=true
          malus.x = x+(run/2)
          malus.y= y+ drop -25
          malus = pickUpBonus.new(malus)
        
        elseif randomPickUp==3 then
          ammo = display.newImageRect(world, imgDir .. 'bullet2.png' , 50,50)
          ammo.isAmmo=true
          ammo.x = x+(run/2)
          ammo.y= y+ drop -25
          ammo = pickUpBonus.new(ammo)
        end

        local index=math.random(#spikesImages)
        local spine = display.newImageRect(world, imgDir .. spikesImages[index], 270/4,258/4)
        spine.x, spine.y = x + (math.random(256,run)) - (270/8), y + drop - (258/8) -4
        spine.anchorX, spikes.anchorY = 0.5 , 0.5 
        if index > 3 then    
          spine = fire.new(spine)
        else
          spine =spikes.new(spine)
        end

      elseif run>1024 and run<2048 then
        
        local decor = display.newImage(world, imgDir .. decorImageslittle[math.random(#decorImageslittle)])
        decor.xScale, decor.yScale = 0.75,0.75
        decor.anchorX, decor.anchorY = 0.5, 0.5    
        decor.x, decor.y = x + (math.random(256,run)) - (135/8), y + drop - (52/8) -4
        decor:toBack()
        local decor = display.newImage(world, imgDir .. decorImagesmedium[math.random(#decorImagesmedium)])
        decor.xScale, decor.yScale = 0.75,0.75
        decor.anchorX, decor.anchorY = 0.5, 0.5    
        decor.x, decor.y = x + (math.random(256,run)) - (135/8), y + drop - (90/8) -4
        decor:toBack()
        local decor = display.newImage(world, imgDir .. decorImagesbig[math.random(#decorImagesbig)])
        decor.xScale, decor.yScale = 0.75,0.75
        decor.anchorX, decor.anchorY = 0.5, 0.5    
        decor.x, decor.y = x + (math.random(256,run)) - (135/8), y + drop - (320/8) -4
        decor:toBack()
      
      
        if randomPickUp==1 then
          life = display.newImageRect(world, imgDir .. 'heart.png' , 50,50)
          life.isLife=true
          life.x = x+(run/2)
          life.y= y+drop-25 
          life = pickUpBonus.new(life)

        elseif randomPickUp==2 then 
          malus = display.newImageRect(world, imgDir .. 'malus.png' , 50,50)
          malus.isMalus=true
          malus.x = x+(run/2)
          malus.y= y+ drop -25
          malus = pickUpBonus.new(malus)
        
        elseif randomPickUp==3 then
          ammo = display.newImageRect(world, imgDir .. 'bullet2.png' , 50,50)
          ammo.isAmmo=true
          ammo.x = x+(run/2)
          ammo.y= y+ drop -25
          ammo = pickUpBonus.new(ammo)
        end

        local index=math.random(#spikesImages)
        local spine = display.newImageRect(world, imgDir .. spikesImages[index], 270/4,258/4)
        spine.x, spine.y = x + math.random(256,run ) - (270/8), y + drop - (258/8) -4
        spine.anchorX, spine.anchorY = 0.5 , 0.5
        if index > 3 then    
          spine = fire.new(spine)
        else
          spine =spikes.new(spine)
        end
     
      elseif run == 2048 then
        local decor = display.newImage(world, imgDir .. decorImageslittle[math.random(#decorImageslittle)])
        decor.xScale, decor.yScale = 0.75,0.75
        decor.anchorX, decor.anchorY = 0.5, 0.5    
        decor.x, decor.y = x + (math.random(256,run)) - (135/8), y + drop - (52/8) -4
        decor:toBack()
        local decor = display.newImage(world, imgDir .. decorImagesmedium[math.random(#decorImagesmedium)])
        decor.xScale, decor.yScale = 0.75,0.75
        decor.anchorX, decor.anchorY = 0.5, 0.5    
        decor.x, decor.y = x + (math.random(256,run)) - (135/8), y + drop - (90/8) -4
        decor:toBack()
        local decor = display.newImage(world, imgDir .. decorImagesbig[math.random(#decorImagesbig)])
        decor.xScale, decor.yScale = 0.75,0.75
        decor.anchorX, decor.anchorY = 0.5, 0.5    
        decor.x, decor.y = x + (math.random(256,run)) - (135/8), y + drop - (320/8) -4
        decor:toBack()
      
        if randomPickUp==1 then
          life = display.newImageRect(world, imgDir .. 'heart.png' , 50,50)
          life.isLife=true
          life.x = x+(run/2)
          life.y= y+drop-25 
          life = pickUpBonus.new(life)

        elseif randomPickUp==2 then 
          malus = display.newImageRect(world, imgDir .. 'malus.png' , 50,50)
          malus.isMalus=true
          malus.x = x+(run/2)
          malus.y= y+ drop -25
          malus = pickUpBonus.new(malus)
        
        elseif randomPickUp==3 then
          ammo = display.newImageRect(world, imgDir .. 'bullet2.png' , 50,50)
          ammo.isAmmo=true
          ammo.x = x+(run/2)
          ammo.y= y+ drop -25
          ammo = pickUpBonus.new(ammo)
        end

        local index1=math.random(#spikesImages)
        local spine1 = display.newImageRect(world, imgDir .. spikesImages[index1], 270/4,258/4)
        spine1.x, spine1.y = x + (math.random(256,(run/2))) - (270/8), y + drop - (258/8)-4
        spine1.anchorX, spine1.anchorY = 0.5 , 0.5
        spine1 = spikes.new(spine1)
        if index1 > 3 then    
          spine1 = fire.new(spine1)
        else
          spine1 =spikes.new(spine1)
        end

        local index2=math.random(#spikesImages)
        local spine2 = display.newImageRect(world, imgDir .. spikesImages[index2], 270/4,258/4)
        spine2.x, spine2.y = x + (math.random(256,(run/2))) - (270/8), y + drop - (258/8)-4
        spine2.anchorX, spine2.anchorY = 0.5 , 0.5
        spine2 = spikes.new(spine2)
        if index2 > 3 then    
          spine2 = fire.new(spine2)
        else
          spine2 =spikes.new(spine2)
        end

        enemyX = x+(run/2)
        enemyY = y+drop-25

        enemy = display.newRect(world,enemyX, enemyY, 128, 128)
        enemy = enemyy.new(enemy,run, x)
    end
  end

  -- build the ground physics
  local ground = display.newLine(x, y+drop, x+run, y+drop)
  physics.addBody(ground, "static", { friction = 0.6 } ) 
  ground:setStrokeColor(color.hex2rgb("C6A664"))        
  ground.strokeWidth = 6
  ground.isGround = true
  
  -- rimbalzo sull angolo
  local bouncePoint = display.newRect(x, y+drop+2, 2,2)
  physics.addBody(bouncePoint, "static", { friction = 0, bounce=0.5 } )  
  bouncePoint:setStrokeColor(color.hex2rgb("C6A664"))        

  -- non togliere!
  instance.run, instance.drop = run, drop
  
  -- create a silhouette
  local silhouette = display.newImageRect(imgDir .. "piatta.png", run, 64)
  silhouette.anchorX, silhouette.anchorY = 1, 0
  silhouette.x, silhouette.y = (x + run), y+drop
  silhouette.isGround=false
  physics.addBody(silhouette, "static", {friction = 1, box ={y=-64}}) 


  -- LINEA FINE GIOCO
  local endGameLine = display.newLine(x, y+drop+1200, x + run + 512, y + drop+1200)
  physics.addBody(endGameLine, "static",{friction = 0.0, bounce = 0, isSensor = false})
  endGameLine.isEndGameLine=true
  endGameLine.isVisible=false

  local rightWall = borders.new(x+run, y+drop, x+run, y+drop-1000)

  instance:insert(ground)
  instance:insert(bouncePoint)
  instance:insert(silhouette)
  instance:insert(endGameLine)
  instance:insert(rightWall)
  

  if enemy then instance:insert(enemy) end

  if spine then instance:insert(spine) end
  if spine1 then instance:insert(spine1) end
  if spine2 then instance:insert(spine2) end

  if rail then instance:insert(rail) end


  if bonus then instance:insert(bonus) end
  if malus then instance:insert(malus) end

  world:insert(instance)


  lastWidth  = w

  return instance
end

return M

 



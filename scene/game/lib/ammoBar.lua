
-- Ammo bar module

-- Define module
local M = {}

function M.new( world, options )
	local imgDir = "scene/game/img/"

	-- Default options for instance
	options = options or {}
	local image = options.image
	local max = options.max or 12
	local spacing = options.spacing or 8
	local w, h = options.width or 36, options.height or 36

	-- Create display group to hold visuals
	local group = display.newGroup()
	local munizioni = {}
	for i = 1, max do
		munizioni[i] = display.newImageRect( imgDir.."bullet2.png", w, h )
		munizioni[i].x = (i-1) * ( (w/2) + spacing/2 )
		munizioni[i].y = 0
		group:insert( munizioni[i] )
	end
	group.count = max

	function group:shoot( amount )
		group.count = math.min( max, math.max( 0, group.count - ( amount or 1 ) ) )
		for i = 1, max do
			if i <= group.count then
				munizioni[i].alpha = 1
			else
				munizioni[i].alpha = 0.2
			end
		end
		return group.count
	end

	function group:add( amount )
		self:shoot( -( amount or 3 ) )
	end
  
  
  function group:getAmmo()
    return group.count 
  end 
  
  
  function group:finalize()
		-- On remove, cleanup instance 
	end
	group:addEventListener( "finalize" )

	-- Return instance
	world:insert(group)

	return group
end

return M

-----------------------------------------------------------------------------------------
--
-- scene_control.lua
--
-----------------------------------------------------------------------------------------
require "tools"

--------------------------------------------------------------------------------
-- Build Camera
--------------------------------------------------------------------------------
local require = require
local perspective = require("perspective")
local function forcesByAngle(totalForce, angle) local forces = {} local radians = -math.rad(angle) forces.x = math.cos(radians) * totalForce forces.y = math.sin(radians) * totalForce return forces end
local camera = perspective.createView()

local move_direction = ""
local players_neighbor_type = 1 --?
local box_to_move_coords = {	x, 
								y, 
							}
local box_to_animate = nil
--[[
	Sprites / frames
--]]
local vasya_frames = {
		frame1 = { type = "image", filename = "Sprites/Player/down1.png" },
		frame2 = { type = "image", filename = "Sprites/Player/down2.png" },
		frame3 = { type = "image", filename = "Sprites/Player/down_idle.png" },
		frame4 = { type = "image", filename = "Sprites/Player/left1.png" },
		frame5 = { type = "image", filename = "Sprites/Player/left2.png" },
		frame6 = { type = "image", filename = "Sprites/Player/left_idle.png" },
		frame7 = { type = "image", filename = "Sprites/Player/right1.png" },
		frame8 = { type = "image", filename = "Sprites/Player/right2.png" },
		frame9 = { type = "image", filename = "Sprites/Player/right_idle.png" },
		frame10 = { type = "image", filename = "Sprites/Player/up1.png" },
		frame11 = { type = "image", filename = "Sprites/Player/up2.png" },
		frame12 = { type = "image", filename = "Sprites/Player/up_idle.png" },
	}
local vasya_frames_move_left = { vasya_frames.frame4, vasya_frames.frame6, vasya_frames.frame5 }

local box_frames = {
	frame1 = {type = "image", filename = "Sprites/box.png" },
	frame2 = {type = "image", filename = "Sprites/box_target.png" },
}

local wall_frames = {
	frame1 = {type = "image", filename = "Sprites/wall_brick.png"},
}

local ground_frames = {
	frame1 = {type = "image", filename = "Sprites/ground.png"},
	frame2 = {type = "image", filename = "Sprites/ground2.png"},
}

local target_frames = {
	frame1 = {type = "image", filename = "Sprites/target.png"},
}
--[[--]]

local vasya_group = display.newGroup()
local vasya = 	{
					x = 0,
					y = 0,
					width = 50,
					height = 50,
					move_speed = 10,
					rect = display.newRect( 0, 0, 0, 0),
				}

local grounds = {}
local ground_group = display.newGroup()
local targets = {}
local target_group = display.newGroup()
local walls = {}
local wall_group = display.newGroup()
local boxes = {}
local box_group = display.newGroup()
local Box = { x, y, rect }
function Box:new (o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.x = x
  self.y = y
  self.rect = display.newRect( 0, 0, 0, 0)
  return o
end

function draw_graphics(boxes_coords, targets_coords, matrix)
	local x = 0
	local y = 0
	local x_num = 0
	local y_num = 0
	for m, name in ipairs(level_matrix) do
 		for n, name2 in ipairs(name) do
 			local block_type = name2
 			if block_type == "0" then
 				vasya.rect = display.newRect( vasya_group, x, y, vasya.width, vasya.height )
				vasya.rect.fill = vasya_frames.frame3

				camera:add(vasya.rect, 1) -- Add player to layer 1 of the camera
				camera.damping = 1 -- A bit more fluid tracking
				camera:setFocus(vasya.rect) -- Set the focus to the player
				--camera:track() -- Begin auto-tracking
				camera:trackFocus()
				--camera:add(myImage, 2)
 			end
 			if block_type == "1" then
 			end
 			if block_type == "2" then
 				local wall1 = display.newRect( wall_group, x, y, vasya.width, vasya.height )
 				wall1.fill = wall_frames.frame1
 				table.insert(walls, wall1)
 				camera:add(wall1, 2)
 			end
 			if block_type == "3" then
 				local box1 = Box:new(nil)
				box1.rect = display.newRect( box_group, x, y, vasya.width, vasya.height )
				box1.rect.fill = box_frames.frame1
				camera:add(box1.rect, 3)
				table.insert(boxes, box1)
				box1.x = n
				box1.y = m
 			end
 			if block_type == "4" then 				
 			end
 			if block_type == "5" then
 			end
 			if block_type == "6" then
 			end

 			local ground1 = display.newRect( ground_group, x, y, vasya.width, vasya.height )
 			ground1:setStrokeColor( 0, 0, 0, 0.1 )
 			ground1.strokeWidth = 1
 			ground1.fill = ground_frames.frame1
 			table.insert(grounds, ground1)
 			camera:add(ground1, 4)

 			for index, target in ipairs(targets_coords) do
				if n == target.x  and m == target.y then
					local target1 = display.newRect( target_group, x, y, vasya.width, vasya.height )
 					target1.fill = target_frames.frame1
 					table.insert(targets, target1)
 					camera:add(target1, 2)
				end
			end
 			x = x + vasya.width --vasya?
 			x_num = #name 
 		end
 		y_num = #level_matrix
 		x = 0
 		y = y + vasya.width --vasya?
 	end
--[[
	Background floor generating
--]]
 	x = 0
 	y = 0
 	local background_slide_count = 5
 	x = x - (vasya.width * background_slide_count)
 	y = y - (vasya.width * background_slide_count)
 	for i = 1, background_slide_count*2+y_num do
 		for j = 1, background_slide_count*2+x_num do
 			local background1 = display.newRect( ground_group, x, y, vasya.width, vasya.height)
 			background1:setStrokeColor( 0, 0, 0, 0.1 )
 			background1.strokeWidth = 2
 			background1.fill = ground_frames.frame2
 			table.insert(grounds, background1)
 			camera:add(background1, 5)
 			x = x + vasya.width --vasya?
 		end
 		x = 0
 		x = x - (vasya.width * background_slide_count)
 		y = y + vasya.width --vasya?
 	end
end

--[[
	Box moving
--]]
local function box_move1()
	if move_direction == "up" then 
		box_to_animate.rect:translate( 0, -vasya.move_speed )
	end
	if move_direction == "down" then 
		box_to_animate.rect:translate( 0, vasya.move_speed )
	end
	if move_direction == "left" then
		box_to_animate.rect:translate( -vasya.move_speed, 0 )
	end
	if move_direction == "right" then
		box_to_animate.rect:translate( vasya.move_speed, 0 )
	end
end 
local function box_move()
	box_move1()
	timer.performWithDelay( 50, box_move1, 4)
end
--[[--]]
--[[
	Vasya's animation
--]]
local function move_animation1()
	if move_direction == "up" then 
		--vasya_group:translate( 0, -vasya.move_speed )
	end
	if move_direction == "down" then 
		--vasya_group:translate( 0, vasya.move_speed )
	end
	if move_direction == "left" then
		vasya.rect.fill = vasya_frames_move_left[1]
		vasya_frames_move_left[1],  vasya_frames_move_left[2] = vasya_frames_move_left[2], vasya_frames_move_left[1]
		vasya_frames_move_left[2],  vasya_frames_move_left[3] = vasya_frames_move_left[2], vasya_frames_move_left[3]
	end
	if move_direction == "right" then 
		--vasya_group:translate( vasya.move_speed, 0 )
	end
end
local function move_animation()
	move_animation1()
	timer.performWithDelay( 100, move_animation1, 2)
end 
--[[--]]
--[[
	Vasya moving
--]]
local function move1()
	print(move_direction)
	if move_direction == "up" then 
		--vasya_group:translate( 0, -vasya.move_speed )
		vasya.rect:translate( 0, -vasya.move_speed )
	end
	if move_direction == "down" then 
		--vasya_group:translate( 0, vasya.move_speed )
		vasya.rect:translate( 0, vasya.move_speed )
	end
	if move_direction == "left" then
		--vasya_group:translate( -vasya.move_speed, 0 )
		vasya.rect:translate( -vasya.move_speed, 0 )
	end
	if move_direction == "right" then 
		--vasya_group:translate( vasya.move_speed, 0 )
		vasya.rect:translate( vasya.move_speed, 0 )
	end
	camera:trackFocus()
end 
local function move()
	move1()
	timer.performWithDelay( 50, move1, 4)
end 
function vasya_move(direction, next_item_type, box_coords_x, box_coords_y)
	move_direction = direction
	players_neighbor_type = next_item_type

	if (players_neighbor_type == "1") or (players_neighbor_type == "3") then
			local co = coroutine.create( move )
			coroutine.resume( co )
			local co1 = coroutine.create( move_animation )
			coroutine.resume( co1 )
	end

	if (players_neighbor_type == "3") then
		box_to_move_coords.x = box_coords_x 
		box_to_move_coords.y = box_coords_y

-- Найти ящик с такими координатами, который сейчас будет двигаться
		for index, box in ipairs(boxes) do
			if box.x == box_to_move_coords.x and box.y == box_to_move_coords.y then
-- Нашли ящик
				box_to_animate = box
-- Включили анимацию
				local co2 = coroutine.create( box_move )
				coroutine.resume( co2 )
-- Применяем новые координаты
				if move_direction == "left" then
						box.x = box.x-1
				end
				if move_direction == "right" then
						box.x = box.x+1
				end
				if move_direction == "up" then
						box.y = box.y-1
				end
				if move_direction == "down" then
						box.y = box.y+1	
				end
				-- ???
				-- box_to_animate = nil
			end
		end
	end
end
--[[--]]

function instantiate_scene()
		move_direction = ""
		players_neighbor_type = 1

		box_group:removeSelf()
		box_group = nil
		box_group = display.newGroup()

		display.remove(box_group)
		box_group = nil
		box_group = display.newGroup()

		vasya.x = display.contentCenterX
		vasya.y = display.contentCenterY

		display.remove(vasya_group)
		vasya_group = nil
		vasya_group = display.newGroup()
		camera:remove(vasya.rect)

		for index, box in ipairs(boxes) do
			camera:remove(box.rect)
		end
		box_to_move_coords.x = nil 
		box_to_move_coords.y = nil 
		box_to_animate = nil

		boxes = nil
		boxes = {}
end



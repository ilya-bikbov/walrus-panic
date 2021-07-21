-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
require "tools"
require "map_control"
require "map_mini"
require "scene_control"

display.setStatusBar(display.HiddenStatusBar)
display.setDefault( "background", 245/255, 242/255, 240/255, 1)
local _screen = {
					x = 0,
					y = 0,
					x_center = display.contentCenterX,
					y_center = display.contentCenterY,
					w = display.contentWidth,
					h = display.contentHeight,
			 	}

local _map_window = {
						x = _screen.x,
						y = (_screen.y + _screen.h - ( _screen.h / 4)),
						w = _screen.w,
						h = _screen.h / 4,
						color_border = { 0, 0, 0, 0.8 },
						color_background = {0, 0, 0, 0.3},
					}


--[[
	Everything about files and directories
--]]
local filesystem_folder_root = system.ResourceDirectory
local filesystem_folder_levels = [[Levels\]]
local fylesystem_typename_levels = [[.skb]]

local function load_level(level_num)
	local filename = "Levels/"..level_num..".skb"
	local path = system.pathForFile(filename, system.ResourceDirectory)
	print("path: ")
	print(path)
	local level_file = io.open(path, "r")
	if (level_file) then
		for line in level_file:lines() do
    		local count = string.len(line)
    		local level_matrix_x = {}
    		for i=1, count do
    			local char = string.sub(line, i, i)
    			table.insert(level_matrix_x, char)
    		end
    		table.insert(level_matrix, table.copy(level_matrix_x))
 		end
		io.close(level_file)
		return true
	else
		return false
	end
end
--[[--]]

local current_level = 0
local function start_level()
	current_level = current_level + 1
    instantiate_matrix()
    load_level(current_level)
    read_matrix()
	print_matrix(level_matrix)
	--draw_mini_map(_screen,_map_window)
	instantiate_scene()
	draw_graphics(boxes, targets, level_matrix)
end


local function globalTouchHandler(event)
    local swipeLengthX = math.abs(event.x - event.xStart) 
    local swipeLengthY = math.abs(event.y - event.yStart) 
    --print(event.phase, swipeLength)

    local t = event.target
    local phase = event.phase

    if (phase == "began") then

    elseif (phase == "moved") then

    elseif (phase == "ended" or phase == "cancelled") then
        --vasya_move -> start_animation_actions
        if (event.xStart > event.x and swipeLengthX > 50) then 
            vasya_move(player_move("left"))
        elseif (event.xStart < event.x and swipeLengthX > 50) then 
            vasya_move(player_move("right"))
        elseif (event.yStart > event.y  and swipeLengthY > 50) then
            vasya_move(player_move("up"))
    	elseif (event.yStart < event.y and swipeLengthY > 50) then
            vasya_move(player_move("down"))
        end
        print("--- redraw ---")
        read_matrix()
        --draw_mini_map(_screen,_map_window)
        print_matrix(level_matrix)
        print(check_victory())
        if (check_victory() == true) then
        	start_level()
        end
        print("--- / ---")
    end
end


start_level()
Runtime:addEventListener("touch", globalTouchHandler)

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
						x = (_screen.x),
						y = (_screen.y + _screen.h - ( _screen.h / 4)) - 3,
						w = (_screen.w),
						h = (_screen.h / 4),
						--color_border = { 0, 0, 0, 0 },
						color_background = {0, 0, 0, 0.2},
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
local update = nil
local function start_level()
	current_level = current_level + 1
    instantiate_matrix()
    load_level(current_level)
    read_matrix()
	--print_matrix(level_matrix)
	draw_mini_map(_screen,_map_window)
	instantiate_scene()
	--local cr = coroutine.create(draw_graphics)
	--coroutine.resume(cr, boxes, targets, level_matrix)
	--update()
	draw_graphics(boxes, targets, level_matrix, update, _screen, _map_window)
	touchOn()
end

update = function ()
	--print("--- redraw ---")
	read_matrix()
	draw_mini_map(_screen,_map_window)
	--print_matrix(level_matrix)
	--print(check_victory())
	if (check_victory() == true) then
		touchOff()
		start_level()
		return
	end
	--print("--- / ---")
	touchOn()
end

start_level()

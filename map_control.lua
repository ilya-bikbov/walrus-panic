-----------------------------------------------------------------------------------------
--
-- map_control.lua
-- 0 - PLAYER
-- 1 - GROUND
-- 2 - WALL
-- 3 - BOX
-- 4 - TARGET
-- 5 - BOX ON TARGET
-- 6 - PLAYER ON TARGET
-- 7 - BOX NEAR WALL/BOX NEAR BOX ??
-----------------------------------------------------------------------------------------
--  level_matrix[y][x]
level_matrix = {}

player = 		{
					x,
					y,
				}
boxes = {}
targets = {}
function instantiate_matrix()
	level_matrix = nil
	level_matrix = {}

	player.x = nil
	player.y = nil

	boxes = nil
	boxes = {}

	targets = nil
	targets = {}
end

local function get_block_type(coords)
	print(level_matrix[coords.y][coords.x])
	return level_matrix[coords.y][coords.x]
end

local function box_move(direction, box_x, box_y)
	local box_next_block_type
	local next_coord_x = box_x
	local next_coord_y = box_y
	if direction == "left" then
		box_next_block_type = get_block_type{x=box_x-1,y=box_y}
		next_coord_x = next_coord_x-1
	end
	if direction == "right" then
		box_next_block_type = get_block_type{x=box_x+1,y=box_y}
		next_coord_x = next_coord_x+1
	end
	if direction == "up" then
		box_next_block_type = get_block_type{x=box_x,y=box_y-1}
		next_coord_y = next_coord_y-1
	end
	if direction == "down" then
		box_next_block_type = get_block_type{x=box_x,y=box_y+1}
		next_coord_y = next_coord_y+1
	end

	if box_next_block_type == "1" then
		level_matrix[box_y][box_x], level_matrix[next_coord_y][next_coord_x] = level_matrix[next_coord_y][next_coord_x], level_matrix[box_y][box_x]
		return true
	end
	return false
end

function read_matrix()
	for m, name in ipairs(level_matrix) do
 		for n, name2 in ipairs(name) do
 			local block_type = name2
 			if block_type == "0" then
 				player.x = n
 				player.y = m
 			end
 			if block_type == "3" then
 				table.insert( boxes, {x=n, y=m})
 			end
 			if block_type == "4" then
 				table.insert( targets, {x=n, y=m})
 				level_matrix[m][n] = "1"
 			end
 			if block_type == "5" then
 				table.insert( boxes, {x=n, y=m})
 				table.insert( targets, {x=n, y=m})
 				level_matrix[m][n] = "3"
 			end
 			if block_type == "6" then
 				table.insert( targets, {x=n, y=m})
 				level_matrix[m][n] = "0"
 			end
 		end
	end
	print("PLAYER COORDS:  " .. player.x .. " " .. player.y)
	print("TARGETS: ")
	for target_index, target_coords in ipairs(targets) do
		print(target_index, target_coords.x, target_coords.y)
	end
end

function player_move(direction)
	local next_block_type
	local next_coord_x = player.x
	local next_coord_y = player.y
	if direction == "left" then
		next_block_type = get_block_type{x=player.x-1,y=player.y}
		next_coord_x = next_coord_x-1
	end
	if direction == "right" then
		next_block_type = get_block_type{x=player.x+1,y=player.y}
		next_coord_x = next_coord_x+1
	end
	if direction == "up" then
		next_block_type = get_block_type{x=player.x,y=player.y-1}
		next_coord_y = next_coord_y-1
	end
	if direction == "down" then
		next_block_type = get_block_type{x=player.x,y=player.y+1}
		next_coord_y = next_coord_y+1
	end

	if next_block_type == "1" then
		print (level_matrix[player.y][player.x])
		level_matrix[player.y][player.x], level_matrix[next_coord_y][next_coord_x] = level_matrix[next_coord_y][next_coord_x], level_matrix[player.y][player.x]
		print("^ swap v")
		print (level_matrix[player.y][player.x])
	end
	if next_block_type == "3" then
		if box_move(direction, next_coord_x, next_coord_y) == true then
			level_matrix[player.y][player.x], level_matrix[next_coord_y][next_coord_x] = level_matrix[next_coord_y][next_coord_x], level_matrix[player.y][player.x]
		else
			next_block_type = "7"
		end
	end
	return direction, next_block_type, next_coord_x, next_coord_y
end

function check_victory()
	local victory_blocks_count = 0
	for i, target_block in ipairs(targets) do
		if level_matrix[target_block.y][target_block.x] == "3" then
			victory_blocks_count = victory_blocks_count+1
		end
	end
	return victory_blocks_count == #targets
end

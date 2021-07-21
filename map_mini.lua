-----------------------------------------------------------------------------------------
--
-- map_mini.lua
--
-----------------------------------------------------------------------------------------
require "map_control"
require "tools"

local _block_color = {
						r = 0,
						g = 0,
						b = 0,
						a = 0.3,
					 }
local set_block_color = {
  							["0"] = function (x) _block_color.r=0 	_block_color.g=255 	_block_color.b=0 end,
  							["1"] = function (x) _block_color.r=150 _block_color.g=150 	_block_color.b=150 end,
  							["2"] = function (x) _block_color.r=255 _block_color.g=0 	_block_color.b=0 end,
  							["3"] = function (x) _block_color.r=223 _block_color.g=134 	_block_color.b=0 end,
  							["4"] = function (x) _block_color.r=0 	_block_color.g=0 	_block_color.b=255 end,
  							["5"] = function (x) _block_color.r=180 _block_color.g=0 	_block_color.b=0 end,
  							["6"] = function (x) _block_color.r=0 _block_color.g=255 	_block_color.b=0 _block_color.a=0.5 end,
						}
local block_rect_group
local _map_rect

function draw_mini_map(_screen, _map_window)
	display.remove(block_rect_group)
	block_rect_group = nil
	block_rect_group = display.newGroup()
	display.remove(_map_rect)
	_map_rect  = nil
	_map_rect = display.newRect( _map_window.x, _map_window.y, _map_window.w,  _map_window.h) --:setFillColor(unpack(_map_window.color_background))
	_map_rect:setFillColor(unpack(_map_window.color_background))
	_map_rect.anchorX = 0
	_map_rect.anchorY = 0

	local block_count_vertical = #level_matrix
	local block_count_horizontal = #level_matrix[1]
	local block_count = block_count_vertical * block_count_horizontal
	block_count = block_count

	local map_size_w = _map_rect.contentWidth
	local map_size_h = _map_rect.contentHeight

	--  Вычисление размера квадрата
	--1. Считаем максимальную сторону квадрата = int(sqrt(высота_прямоугольника*ширина_прямоугольника/количество_квадратов)) = 219 
	local box_side_max = math.floor(math.sqrt(map_size_h  *map_size_w / block_count))
	--2. Берём ширину и высоту, делим нацело на все числа от 1 до количества квадратов. Из полученного списка удаляем все числа, 
	--   большие максимальной стороны квадрата, удаляем дубликаты и сортируем по убыванию.
	local nums = {}
	for i=1, block_count do
		local wi = math.floor(map_size_w / i)
		local hi = math.floor(map_size_h / i)

		if wi < box_side_max then
			table.insert(nums, wi)
		end
		if hi < box_side_max then
			table.insert(nums, hi)
		end
	end
	table.sort( nums, compare )
	--print( table.concat( nums, ", " ) )  --> 5, 4, 3, 2, 1
	--3. Для полученных размеров считаем количество квадратов, умещающихся в прямоугольник = int(высота_прямоугольника/размер_квадрата)*int(ширина_прямоугольника/размер_квадрата).
	--   Как только получаем число большее необходимого количества квадратов - останавливаемся.
	local res = 30  --math.floor( math.floor(map_size_h/nums[1])*math.floor(map_size_w/nums[1]) )
	-- !!! ДВИГАТЬ RES РУКАМИ В ЗАВИСИМОСТИ ОТ КОЛИЧЕСТВА БЛОКОВ

	--for i, size in ipairs(nums) do
	--	local tmp_res = math.floor( math.floor(map_size_h/size)*math.floor(map_size_w/size) )
	--	if tmp_res < block_count then
	--		res = tmp_res
	--	end
	--end
	--print( "res: ", res )

	local tmp_x = _map_window.x
	local tmp_y = _map_window.y
	for m, name in ipairs(level_matrix) do
 		for n, name2 in ipairs(name) do
 			local block_rect = display.newRect(block_rect_group, tmp_x, tmp_y, res, res)
			block_rect.stroke = {0, 0, 0, 1}
			block_rect.strokeWidth = 1.5
			block_rect.anchorX = 0
			block_rect.anchorY = 0

			local color = set_block_color[name2]
			for i, target_block in ipairs(targets) do
				if target_block.y == m and target_block.x == n then
					if level_matrix[target_block.y][target_block.x] == "0" then
						color = set_block_color["6"]
					elseif level_matrix[target_block.y][target_block.x] == "1" then
						color = set_block_color["4"]
					elseif level_matrix[target_block.y][target_block.x] == "3" then
						color = set_block_color["5"]
					end
				end
			end
			if (color) then
    			color()
    		end
			block_rect:setFillColor(_block_color.r,_block_color.g,_block_color.b, _block_color.a)
			tmp_x = tmp_x + res
 		end
 		tmp_y = tmp_y + res
 		tmp_x = _map_window.x
	end

	block_rect_group.x = _screen.x_center
	block_rect_group.x = block_rect_group.x - (block_rect_group.contentWidth/2)

	block_rect_group.y = _map_rect.contentHeight/2

	block_rect_group.y = block_rect_group.y - (block_rect_group.contentHeight/1.5) 
end



			
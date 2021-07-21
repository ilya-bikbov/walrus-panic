-----------------------------------------------------------------------------------------
--
-- tools.lua
--
-----------------------------------------------------------------------------------------

--[[
		Print 1D array in console output
--]]
function print_array(input_array)
	print( "-- ouput array:" )
	local line = {}
 		for m, name in ipairs(input_array) do
 			local char = name
 			table.insert(line, char)
 		end
 	print(table.concat(line, "   "))	
end

--[[
		Print 2D matrix in console output
--]]
function print_matrix(input_matrix)
	print( "-- ouput matrix:" )
	local lines = {}
 		for m, name in ipairs(input_matrix) do
 			local line = {}
 			for n, name2 in ipairs(name) do
 				local char = name2
 				table.insert(line, char)
 			end
 			print(table.concat(line, "   "))
		end
end

function compare( a, b )
    	return a > b  -- Note ">" as the operator
end

function copyFile( srcName, srcPath, dstName, dstPath, overwrite )
 
    local results = false
 
    local fileExists = doesFileExist( srcName, srcPath )
    if ( fileExists == false ) then
        return nil  -- nil = Source file not found
    end
 
    -- Check to see if destination file already exists
    if not ( overwrite ) then
        if ( fileLib.doesFileExist( dstName, dstPath ) ) then
            return 1  -- 1 = File already exists (don't overwrite)
        end
    end
 
    -- Copy the source file to the destination file
    local rFilePath = system.pathForFile( srcName, srcPath )
    local wFilePath = system.pathForFile( dstName, dstPath )
 
    local rfh = io.open( rFilePath, "rb" )
    local wfh, errorString = io.open( wFilePath, "wb" )
 
    if not ( wfh ) then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
        return false
    else
        -- Read the file and write to the destination directory
        local data = rfh:read( "*a" )
        if not ( data ) then
            print( "Read error!" )
            return false
        else
            if not ( wfh:write( data ) ) then
                print( "Write error!" )
                return false
            end
        end
    end
 
    results = 2  -- 2 = File copied successfully!
 
    -- Close file handles
    rfh:close()
    wfh:close()
 
    return results
end
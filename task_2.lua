require 'file_processing_utilities'

-- function that prints the maze for the debug purposes
function print_maze_beatiful(maze)
	print("----------- MAZE -----------")
	for i = 1, #maze, 1 do
		for j = 1, #maze[i], 1 do
			if (maze[i][j] == -1) then
				io.write(utf8.char(0x25A3))
			elseif (maze[i][j] == -2) then
				io.write(utf8.char(0x26AA))
			elseif (maze[i][j] == -3) then
				io.write(utf8.char(0x269D))
			elseif (maze[i][j] == 0) then
				io.write(utf8.char(0x26F9))
			elseif (maze[i][j] == -4) then
				io.write(utf8.char(0x205C))
			else
				io.write(utf8.char(0x26F6))
			end
		end
		io.write('\n')
	end
end

-- function that prints the maze for the debug purposes
function print_maze(maze)
	print("----------- MAZE -----------")
	for i = 1, #maze, 1 do
		for j = 1, #maze[i], 1 do
			str = tostring(maze[i][j])
			io.write(string.format("%3s", str))
		end
		io.write('\n')
	end
end

-- validate the maze data
function validate_maze(maze_data)
	if (#maze_data.map == 0) then
		print("Empty maze given")
		return false
	end
	if (maze_data.start_i == nil or maze_data.start_j == nil ) then
		print("Start is not specified")
		return false
	end
	if (maze_data.exit_i == nil or maze_data.exit_j == nil ) then
		print("Exit is not specified")
		return false
	end
	if ((maze_data.exit_i < 1 or maze_data.exit_i >= maze_data.height) or (maze_data.exit_j < 1 or  maze_data.exit_j > maze_data.width)) then
		print("Exit is out of maze")
		return false
	end
	-- indicate that maze is valid
	return true
end


-- create the maze reading it from file
function create_maze(maze)
	-- maze data is structure that holds: maze map, start i/j and exit i/j coordinates 
	-- direction i, we can go right and left, direction y, we can go up and down, also iagonal movement is implemented
	-- diagonal movement can be removed by deleting last four pairs in each table 
	local maze_data = {
		map = {},
		direction_i = { 0, 0, 1, -1, 1, 1, -1, -1 },
		direction_j = { 1, -1, 0, 0, 1, -1, 1, -1 },
		start_i = nil,
		start_j = nil,
		exit_i = nil,
		exit_j = nil,
		width = nil,
		height = nil;
	}
	-- iterators
	-- iterate through the maze (stored as table of strings) 
	for i = 1, #maze, 1 do
		-- create an integer representation of the maze row by row
		maze_data.map[i] = {}
		for j = 1, #maze[i], 1 do
			-- get the specific part of the string, one character
			maze_part = string.sub(maze[i], j, j)
			-- if we find a wall
			if (maze_part == '0') then
				maze_data.map[i][j] = -1
			-- if we find an start point 
			elseif (maze_part == 'I' ) then
				-- indicate it as zero
				maze_data.map[i][j] = 0
				-- store the start coordinates
				maze_data.start_i = i
				maze_data.start_j = j
			-- if we find an exit 
			elseif (maze_part == 'E') then
				maze_data.map[i][j] = -3
				-- store exit coordinates
				maze_data.exit_i = i
				maze_data.exit_j = j
			-- if we find a free cell of maze 
			elseif (maze_part == ' ') then
				maze_data.map[i][j] = -2
			end
			maze_data.width = j
		end
		maze_data.height = i;
	end
	-- return maze data 
	return maze_data
end

-- function that find a path in the maze
function traverse_maze_to_finish(maze_data)
	-- flag that indicates that at least one step was made
	local step = true
	-- current movement_point
	local movement_point = 0
	-- perform search until we reach the exit, or we can not make any steps any more (it means there no exit)
	while (step and maze_data.map[maze_data.exit_i][maze_data.exit_j] == -3) do
		step = false
		-- go though our maze
		for i = 1, #maze_data.map, 1 do
			for j = 1, #maze_data.map[i], 1 do
				-- we have reached the point to move from in 4 directions
				if (maze_data.map[i][j] == movement_point) then
					-- move in four directions
					for k = 1, #maze_data.direction_i, 1 do
						-- calculate new coordinates to move
						local new_i = maze_data.direction_i[k] + i;
						local new_j = maze_data.direction_j[k] + j;
						-- check if the coordinate fits the boundaries of the map
						-- and if it is free cell or finish point of the maze
						if ((new_i >= 1 and new_i <= maze_data.height) and (new_j >= 1 and new_j <= maze_data.width) and (maze_data.map[new_i][new_j] == -2 or maze_data.map[new_i][new_j] == -3 )) then
							-- initialize all the surrounding points
							-- the value of map cell indidcated how many steps were made to rearch this point of the map
							maze_data.map[new_i][new_j] = movement_point + 1
							step = true
						end
					end
				end
			end
		end
		-- move to the next point
		movement_point = movement_point + 1
	end
	-- check if we reached the exit
	if (not step and maze_data.map[maze_data.exit_i][maze_data.exit_j] == -3) then
		return false
	end
	-- indicates that the the exit can be reached
	return true
end

-- function that restores the shortest path
function restore_path(maze_data)
	-- staring i, i coordinates
	-- go though the maze beginning from the finish point
	local i = maze_data.exit_i
	local j = maze_data.exit_j
	-- the point we start to move from
	local movement_point = maze_data.map[i][j]
	-- start the restoring process
	while (movement_point > 0) do
		-- decrease movement point, we look for the point it came from
		movement_point = movement_point - 1
		-- go in all directions
		for k = 1, #maze_data.direction_i, 1 do
			-- calculate new coordinates to move
			local new_i = maze_data.direction_i[k] + i;
			local new_j = maze_data.direction_j[k] + j;
			-- check if the coordinate fits the boundaries of the map
			-- and if the the cell of the map is needed one, from where it came
			if ((new_i >= 1 and new_i <= maze_data.height) and (new_j >= 1 and new_j <= maze_data.width) and (maze_data.map[new_i][new_j] == movement_point)) then
				-- mark the point 
				maze_data.map[new_i][new_j] = -4
				i = new_i
				j = new_j
				break ;
			end
		end
	end
end

-- definition of the main function that start the process 
function main()
	-- the file name to read from
	file_name = "Maze.txt"
	-- check if file exists
	local file_exists = file_exists(file_name)
	-- print if file with a specific name exists, debug check
	print(string.format("File %s exists: %s", file_name, tostring(file_exists)))
	if file_exists then
		-- read the file content
		raw_maze = get_file_lines(file_name, file)
		maze_data = create_maze(raw_maze)
		if (not validate_maze(maze_data)) then
			return
		end
		print_maze(maze_data.map)
		print_maze_beatiful(maze_data.map)
		if (not traverse_maze_to_finish(maze_data)) then
			print("The path can not be found, please make some changes in the maze structure")
			return 
		end
		print_maze(maze_data.map)
		print_maze_beatiful(maze_data.map)
		restore_path(maze_data)
		print_maze(maze_data.map)
		print_maze_beatiful(maze_data.map)
	end
end

-- call of main function
main()

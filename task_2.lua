require 'file_processing_utilities'

-- function that prints the maze for the debug purposes
function print_maze(maze)
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
			else
				io.write(maze[i][j])
			end
		end
		io.write('\n')
	end
end

-- create the maze reading it from file
function create_maze(maze)
	-- maze data is structure that holds: maze map, start x/y and exit x/y coordinates 
	local maze_data = {
		map = {},
		start_x = nil,
		start_y = nil,
		exit_x = nil,
		exit_y = nil,
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
				maze_data.start_x = i
				maze_data.start_y = i
			-- if we find an exit 
			elseif (maze_part == 'E') then
				maze_data.map[i][j] = -3
				-- store exit coordinates
				maze_data.exit_x = i
				maze_data.exit_y = j
			-- if we find a free cell of maze 
			elseif (maze_part == ' ') then
				maze_data.map[i][j] = -2
			end
			maze_data.width = j
		end
		maze_data.height = i;
	end
	print(maze_data.width, ' ', maze_data.height)
	-- return maze data 
	return maze_data
end

-- function that find a path in the maze
function find_path(maze_data)
	-- direction x, we can go right and left
	local direction_x = { 1, -1, 0, 0 }
	-- direction y, we can go up and down
	local direction_y = { 0, 0, 1, -1 }
	-- flag that indicates that at least one step was made
	local step = false
	-- current movement_point
	local movement_point = 0

	-- perform search until we reach the exit, or we can not make any steps any more (it means there no exit)
	while (flag and maze_data.map[maze_data.start_x][maze_data.start_y]) do
		-- go though our maze
		for i = 1, #maze, 1 do
			for j = 1, #maze, 1 do
				-- we have reached the point to move from in 4 directions
				if (maze_data.map[i][j] == movement_point) then
					-- move in four directions
					for k = 1, #direction_x, 1 do
						-- calculate new coordinates to move
						local new_x = direction_x[k] + i;
						local new_y = direction_y[k] + j;
						-- check if the coordinate fits the boundaries of the map
						if ((new_x >= 1 and new_x <= maze_data.width)
							and (new_y >= 1 and new_y <= maze_data.height)) then
							
						end
					end
				end
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
		print_maze(maze_data.map)
	end
end

-- call of main function
main()

-- function that checks is the file exists
function file_exists(file_name)
	-- try open the file
	local f =  io.open(file_name, "rb")
	-- if the file was opened successfuly, close it
	if f then
		-- close the file
		f:close()
	end
	-- return an indicator that file was opened or not
	return f ~= nil
end

-- function that reads lines fron file and returns table of lines
function get_file_lines(file_name)
	-- check if file exists, if not -> return empty table
	if not file_exists(file_name) then
		return {}
	end
	-- lines of the file to return
	local lines = {}
	-- read line by line the file
	for line in io.lines(file_name) do
		-- add a new element to the lines table, remove a \n from a read line
		lines[#lines + 1] = string.gsub(line, "\n", "")
	end
	-- return the result
	return lines
end

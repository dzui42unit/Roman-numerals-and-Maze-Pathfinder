-- class file reader
FileReader = {}
-- class body
function FileReader:new(fname)

	-- private properties
	local private = {}
		private.file_name = fname
		private.lines = {}
		-- method that checks is the file exists
		function private:file_exists()
			-- try open the file
			local f =  io.open(private.file_name, "rb")
			-- if the file was opened successfuly, close it
			if f then
				-- close the file
				f:close()
			end
			-- return an indicator that file was opened or not
			return f ~= nil
		end

	-- public properties
	local public = {}
		-- method that reads lines fron file and returns table of lines
		function public:read_file_lines(file_name)
			-- check if file exists, if not -> return empty table
			if not private.file_exists(file_name) then
				error(string.format("File %s does not exist", private.file_name))
			end
			-- read line by line the file
			for line in io.lines(private.file_name) do
				-- add a new element to the lines table, remove a \n from a read line
				private.lines[#private.lines + 1] = string.gsub(line, "\n", "")
			end
			-- return the result
			return private.lines
		end
		-- method that returns lines
		function public:get_file_lines()
			return private.lines
		end

	setmetatable(public, self)
	self.__index = self; return public
end

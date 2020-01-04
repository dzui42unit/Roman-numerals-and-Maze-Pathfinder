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

-- function that prints 1-d table
function print_table(table_to_print)
	-- iterate through the table
	for i = 1, #table_to_print, 1 do
		print(table_to_print[i])
	end
end

-- function that prints 1-d table
function print_table_key_value(table_to_print)
	-- iterate through the table
	for key, value in pairs(table_to_print) do
		print(string.format("Number %s = %s", key, value))
	end
end

-- function that generates integer number from the roman representation
-- I placed before V or X indicates one less, so four is IV (one less than 5) and 9 is IX (one less than 10).
-- X placed before L or C indicates ten less, so forty is XL (10 less than 50) and 90 is XC (ten less than a hundred).
-- C placed before D or M indicates a hundred less, so four hundred is CD (a hundred less than five hundred) and nine hundred is CM (a hundred less than a thousand).
function generate_int_from_roman(roman_number)
	-- resulting int number
	local result = 0
	-- denominations of the Roman numbers
	local roman_numbers_denomination = {}

	roman_numbers_denomination['I'] = 1
	roman_numbers_denomination['V'] = 5
	roman_numbers_denomination['X'] = 10
	roman_numbers_denomination['L'] = 50
	roman_numbers_denomination['C'] = 100
	roman_numbers_denomination['D'] = 500
	roman_numbers_denomination['M'] = 1000

	local i = 1;
	-- iterate through the roman number 
	while (i <= string.len(roman_number)) do
		-- the letter in the riman number represents the key in the roman_numbers_denomination table
		-- so in this way we just calculate the number
		-- take the single character from a string at specific position
		local single_roman_number = string.sub(roman_number, i, i)

		local to_add = roman_numbers_denomination[single_roman_number]
	
		if single_roman_number == 'C' then
			-- variable to store the next part of the more complex roman number
			local next_single_roman_number
			-- check if the roman number is not the last in the string, so there can be any other number after it
			if i + 1 <= string.len(roman_number) then
				-- we get its symbol
				next_single_roman_number = string.sub(roman_number, i + 1, i + 1)
				-- check if this number is a part of more complex number
				if next_single_roman_number == 'D' or next_single_roman_number == 'M' then
					-- if yes, we subtract the last part from the first part
					to_add = roman_numbers_denomination[next_single_roman_number] - roman_numbers_denomination[single_roman_number]
					-- increase the index
					i = i + 1				
				end
			end
		elseif single_roman_number == 'X' then
			-- variable to store the next part of the more complex roman number
			local next_single_roman_number
			-- check if the roman number is not the last in the string, so there can be any other number after it
			if i + 1 <= string.len(roman_number) then
				-- we get its symbol
				next_single_roman_number = string.sub(roman_number, i + 1, i + 1)
				-- check if this number is a part of more complex number
				if next_single_roman_number == 'L' or next_single_roman_number == 'C' then
					-- if yes, we subtract the last part from the first part
					to_add = roman_numbers_denomination[next_single_roman_number] - roman_numbers_denomination[single_roman_number]
					-- increase the index
					i = i + 1
				end
			end
		elseif single_roman_number == 'I' then
			-- variable to store the next part of the more complex roman number
			local next_single_roman_number
			-- check if the roman number is not the last in the string, so there can be any other number after it
			if i + 1 <= string.len(roman_number) then
				-- we get its symbol
				next_single_roman_number = string.sub(roman_number, i + 1, i + 1)
				-- check if this number is a part of more complex number
				if next_single_roman_number == 'V' or next_single_roman_number == 'X' then
					-- if yes, we subtract the last part from the first part
					to_add = roman_numbers_denomination[next_single_roman_number] - roman_numbers_denomination[single_roman_number]
					-- increase the index
					i = i + 1				
				end
			end
		end
		result = result + to_add
		i = i + 1
	end
	-- return the resulting integer number
	return result
end

-- function that calculates the rank of the number
function get_numbers_rank(number)
	-- convert number to string
	number = tostring(number)
	-- to calculate rank we take the number of digits (length of the string in our case) - 1
	-- and power 10 to the number of digits - 1
	rank = math.floor(math.pow(10, string.len(number) - 1))
	-- return rank
	return rank
end

-- find the base of the number
function find_base(number)
	
	local base = { 1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000 }
	local result_base

	for i = 1, #base, 1 do
		if number >= base[i] then
			result_base = base[i]
		else
			break;
		end
	end

	return result_base
end

-- function that generates a representation of decimal number in roman format
function generate_roman_from_int(number)

	-- resulting string
	local result = ''
	local integer_to_roman_denomination = {}

	integer_to_roman_denomination[1] = 'I'
	integer_to_roman_denomination[4] = 'IV'
	integer_to_roman_denomination[5] = 'V'
	integer_to_roman_denomination[9] = 'IX'
	integer_to_roman_denomination[10] = 'X'
	integer_to_roman_denomination[40] = 'XL'
	integer_to_roman_denomination[50] = 'L'
	integer_to_roman_denomination[90] = 'XC'
	integer_to_roman_denomination[100] = 'C'
	integer_to_roman_denomination[400] = 'CD'
	integer_to_roman_denomination[500] = 'D' 
	integer_to_roman_denomination[900] = 'CM' 
	integer_to_roman_denomination[1000] = 'M'

	while (number ~= 0) do
		-- find the base of the number
		base = find_base(number)
		-- find quotient, that indicates how many times the base will be repeated while forming a number
		local quotient = math.floor(number / base)
		-- find the remaider after modulus operaion
		local remainder = math.floor(number % base)
		-- if the quotient is zero, so we simply add the base to the resulting number
		-- else we add it quotient times 
		if quotient == 0 then
			result = result .. integer_to_roman_denomination[base]
		else 
			for i = 1, quotient, 1 do
				result = result .. integer_to_roman_denomination[base]
			end
		end
		number = math.floor(number % base)
	end
	-- return the resulting string
	return result
end

-- main function that runs the whole process
function main()
	-- the file name to read from
	file_name = "p089_roman.txt"
	-- file_name = "16.txt"
	-- the output file for debug
	-- file = io.open('my_result.txt', 'a+')
	-- print if file with a specific name exists, debug check
	print(string.format("File %s, exists: %s", file_name, tostring(file_exists(file_name))))
	-- read the file content
	roman_numbers = get_file_lines(file_name, file)
	-- nubmer of saved symbols
	saved_symbols = 0
	for i = 1, #roman_numbers, 1 do
		-- 1-st step - generate the integer number from the roman
		int_number = generate_int_from_roman(roman_numbers[i])
		-- generate a new shorter version of the roman number from integer
		short_roman_number = generate_roman_from_int(int_number)
		-- also file for debug
		-- file:write(short_roman_number, "\n")
		-- calculate the difference in length for initial and new generated numbers
		saved_symbols = saved_symbols + (string.len(roman_numbers[i]) - string.len(short_roman_number))
	end
	print(saved_symbols)
end

-- run the program
main()
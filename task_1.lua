require 'FileReader'

-- class that converts from integer to roman number
IntToRomanConverter = {}
-- class body
function IntToRomanConverter:new()
	-- private properties
	local private = {}
		-- denominations of the Roman numbers
		private.integer_to_roman_denomination = {
			[1] = 'I',
			[4] = 'IV',
			[5] = 'V',
			[9] = 'IX',
			[10] = 'X',
			[40] = 'XL',
			[50] = 'L',
			[90] = 'XC',
			[100] = 'C',
			[400] = 'CD',
			[500] = 'D',
			[900] = 'CM', 
			[1000] = 'M',
		}
		-- list of base
		private.base = { 1, 4, 5, 9, 10, 40, 50, 90, 100, 400, 500, 900, 1000 }
		-- find the base of the number
		function private:find_base(nb)
			local result_base
			-- the base calculate base <= number < next_available base
			for i = 1, #private.base, 1 do
				if nb >= private.base[i] then
					result_base = private.base[i]
				else
					break;
				end
			end

			return result_base
		end

	-- public properties
	local public = {}
		-- function that generates a representation of decimal number in roman format
		function public:convert(number)
			-- resulting string
			local result = ''
			-- start conversion
			while (number ~= 0) do
				-- find the base of the number
				base = private:find_base(number)
				-- find quotient, that indicates how many times the base will be repeated while forming a number
				local quotient = math.floor(number / base)
				-- find the remaider after modulus operaion
				local remainder = math.floor(number % base)
				-- if the quotient is zero, so we simply add the base to the resulting number
				-- else we add it quotient times 
				if quotient == 0 then
					result = result .. private.integer_to_roman_denomination[base]
				else 
					for i = 1, quotient, 1 do
						result = result .. private.integer_to_roman_denomination[base]
					end
				end
				number = math.floor(number % base)
			end
			-- return the resulting string
			return result
		end

	setmetatable(public, self)
	self.__index = self; return public
end

-- class that coverts roman number to integer one 
RomanToIntConverter = {}
-- class body
function RomanToIntConverter:new()
	-- private properties
	local private = {}
		-- denominations of the Roman numbers
		private.roman_numbers_denomination = {
			['I'] = 1,
			['V'] = 5,
			['X'] = 10,
			['L'] = 50,
			['C'] = 100,
			['D'] = 500,
			['M'] = 1000
		}
	-- public properties
	local public = {}
		-- function that generates integer number from the roman representation
		-- I placed before V or X indicates one less, so four is IV (one less than 5) and 9 is IX (one less than 10).
		-- X placed before L or C indicates ten less, so forty is XL (10 less than 50) and 90 is XC (ten less than a hundred).
		-- C placed before D or M indicates a hundred less, so four hundred is CD (a hundred less than five hundred) and nine hundred is CM (a hundred less than a thousand).
		function public:convert(roman_number)
			-- converted number
			converted_number = 0
			-- iterate through the roman number 
			local i = 1;
			while (i <= string.len(roman_number)) do
				-- the letter in the riman number represents the key in the roman_numbers_denomination table
				-- so in this way we just calculate the number
				-- take the single character from a string at specific position
				local single_roman_number = string.sub(roman_number, i, i)

				local to_add = private.roman_numbers_denomination[single_roman_number]
			
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
							to_add = private.roman_numbers_denomination[next_single_roman_number] - private.roman_numbers_denomination[single_roman_number]
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
							to_add = private.roman_numbers_denomination[next_single_roman_number] - private.roman_numbers_denomination[single_roman_number]
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
							to_add = private.roman_numbers_denomination[next_single_roman_number] - private.roman_numbers_denomination[single_roman_number]
							-- increase the index
							i = i + 1				
						end
					end
				end
				converted_number = converted_number + to_add
				i = i + 1
			end
			-- return the resulting integer number
			return converted_number
		end

	setmetatable(public, self)
	self.__index = self; return public
end

-- main function that runs the whole process
function main()
	-- the file name to read from
	file_name = "p089_roman.txt"
	-- initialize file reader
	file_reader = FileReader:new(file_name)
	-- read data from file
	roman_numbers = file_reader.read_file_lines()
	-- initialize converter
	roman_to_int_converter = RomanToIntConverter:new()
	-- initialize in to roman converter
	integer_to_roman_converer = IntToRomanConverter:new()
	-- symbols to be saved
	saved_symbols = 0
	for i = 1, #roman_numbers, 1 do
		-- 1-st step - generate the integer number from the roman
		int_number = roman_to_int_converter:convert(roman_numbers[i])
		-- generate a new shorter version of the roman number from integer
		short_roman_number = integer_to_roman_converer:convert(int_number)
		-- calculate the difference in length for initial and new generated numbers
		saved_symbols = saved_symbols + (string.len(roman_numbers[i]) - string.len(short_roman_number))
	end
	print(saved_symbols)
end

-- run the program
main()
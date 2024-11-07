local module = {}

function module.read()

	-- Evil Folder Hack
	local folder = vim.fs.dirname(debug.getinfo(1, "S").source:sub(2))
	local file = io.open( vim.fs.joinpath(folder, "data.tsv"), "r")

	if file == nil then error("Couldn't read data.tsv. Tell the coyote!") end
	local data = {
		sctrl = {},
		trigger = {}
	}

	local obj
	for line in file:lines() do
		line = vim.trim(line):gsub("\\n", "\n")
		local fields = vim.split(line, "\t")
		if #fields >= 2 then
			if fields[1] == "sctrl" then
				obj = {
					ikgo = fields[3] == "ikgo"
				}
				data.sctrl[fields[2]] = obj
			elseif fields[1] == "trigger" then
				obj = {
					ikgo = fields[3] == "ikgo"
				}
				data.trigger[fields[2]] = obj
			else
				-- does it already exist?
				local check = obj[fields[1]]
				if check then
					-- is it a table?
					if type(check) == "table" then
						-- append to it
						table.insert(check, fields[2])
					else
						-- turn it into a table
						obj[fields[1]] = {check}
					end
				else
					-- it doesn't exist, add it
					obj[fields[1]] = fields[2]
				end
			end
		end
	end
	return data
end

return module

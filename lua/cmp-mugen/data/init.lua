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
			if fields[1] == "sctrl" or fields[1] == "trigger" then
				obj = {
					ikgo = fields[3] == "ikgo"
				}
				data[fields[1]][fields[2]] = obj
			else
				if fields[1] == "opt" or fields[1] == "req" then
					local item = {
						name = fields[2],
						value = {}
					}
					for k,v in pairs(fields) do
						if k >= 3 then
							table.insert(item.value, v)
						end
					end
					if obj[fields[1]] then
						table.insert(obj[fields[1]], item)
					else
						obj[fields[1]] = {
							item
						}
					end
				else
					obj[fields[1]] = fields[2]
				end
			end
		end
	end
	return data
end

return module

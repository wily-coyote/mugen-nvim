local defs = {
	game_path = nil,
	run_command = {"-p1", "%", "-p2", "%"}
}

local ikemen = false
local module = {}

local ikext = {
	"zss",
	"const",
	"json",
}

local mugext = {
	"cns",
	"st",
	"cmd",
	"air",
	"def",
	"cfg",
}

function module.checkExt()
	for _,v in pairs(ikext) do
		if v == vim.bo.filetype then return 2 end
	end
	for _,v in pairs(mugext) do
		if v == vim.bo.filetype then return 1 end
	end
	return nil
end

local function rootFile(pattern)
	local def
	vim.fs.root(0, function(name, path)
		local ok = name:match(pattern) ~= nil
		if ok then
			def = vim.fs.joinpath(path, name)
			def = vim.fs.normalize(def)
		end
		return ok
	end)
	return def
end

module.setup = function(mod)
	for k,v in pairs(defs) do
		if mod[k] == nil then mod[k] = v end
	end
	if mod.game_path then
		mod.game_path = vim.fs.normalize(mod.game_path)
		if mod.game_path:match("Ikemen_GO$") or mod.game_path:match("Ikemen_GO%.exe$") then
			ikemen = true
		end
	end
	vim.api.nvim_create_user_command("Mugen", function(_)
		if not module.checkExt() then
			vim.api.nvim_err_writeln("Not a recognized MUGEN file")
			return
		end
		local def = rootFile("%.def$")
		if mod.game_path == nil then
			mod.game_path = rootFile("mugen%.exe$") or rootFile("mugen$")
			if not mod.game_path then
				mod.game_path = rootFile("Ikemen_GO%.exe$") or rootFile("Ikemen_GO$")
				ikemen = true
			end
			mod.game_dir = vim.fs.dirname(mod.game_path)
			if not mod.game_path then
				vim.api.nvim_err_writeln("Couldn't find MUGEN/IKEMEN")
				return
			else
				vim.api.nvim_err_writeln("Please set `game_path` in your config")
			end
		end
		if def == nil then
			vim.api.nvim_err_writeln("Couldn't find .DEF file")
			return
		end
		if not ikemen then
			local check = vim.fs.joinpath(mod.game_dir, "chars")
			local cut = #(check)
			if def:sub(0, cut) == check then
				def = def:sub(cut+2)
			else
				vim.api.nvim_err_writeln("You're using a MUGEN executable, and the .DEF file isn't in the chars folder")
			end
		end
		local command = {mod.game_path}
		for _,v in pairs(mod.run_command) do
			if v == "%" then
				table.insert(command, def)
			else
				table.insert(command, v)
			end
		end
		vim.system(command, { cwd = mod.game_dir })
	end, { nargs = 0 } )

	-- die silently
	pcall(function()
		local cmpsrc = require("./cmp-mugen")
		require("cmp").register_source("mugen", cmpsrc)
	end)
end

return module

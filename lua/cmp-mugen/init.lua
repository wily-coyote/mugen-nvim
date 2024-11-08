local mugen = require("mugen")
local data = require("cmp-mugen.data").read()
local source = {}



function source:formatState(name, sctrl, ikgo)
	local str = ""
	local req = sctrl.req
	local opt = sctrl.opt
	req = type(req) == "table" and req or {req}
	opt = type(opt) == "table" and opt or {opt}
	if ikgo then
		str = name .. "{\n"
			for _,item in pairs(req) do
				str = str..string.format("\t%s: %s;\n", item.name, vim.fn.join(item.value, ", "));
			end
			for _,item in pairs(opt) do
				str = str..string.format("\t# %s: %s;\n", item.name, vim.fn.join(item.value, ", "));
			end
		str = str.."}"
	else
		str = string.format("[State %s]\ntype=%s\ntrigger1=\n", name, name)
			for _,item in pairs(req) do
				str = str..string.format("%s=%s\n", item.name, vim.fn.join(item.value, ", "));
			end
			for _,item in pairs(opt) do
				str = str..string.format("; %s=%s\n", item.name, vim.fn.join(item.value, ", "));
			end
	end
	return vim.trim(str)
end

--- Return whether this source is available in the current context or not (optional).
--- @return boolean
function source:is_available()
	return mugen.checkExt() ~= nil
end

--- Invoke completion (required).
--- @param _ cmp.SourceCompletionApiParams
--- @param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(_, callback)
	local compl = {}

	local ikgo = mugen.checkExt() == 2

	for name, trigger in pairs(data.trigger) do
		--- @type lsp.CompletionItem
		local item = {
			label = name,
			documentation = trigger.doc,
			insertText = trigger.fmt,
			kind = 3,
			detail = "trigger"
		}
		table.insert(compl, item)
	end
	for name, sctrl in pairs(data.sctrl) do
		--- @type lsp.CompletionItem
		local item = {
			label = name,
			documentation = sctrl.doc,
			kind = 3,
			detail = "state controller",
			insertText = self:formatState(name, sctrl, ikgo)
		}
		table.insert(compl, item)
	end

	callback(compl)
end

--- Register your source to nvim-cmp.
return source -- require('cmp').register_source('mugen', source)

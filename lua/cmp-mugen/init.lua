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
			for _,v in pairs(req) do
				str = str.."\t"..v..": ;\n"
			end
			for _,v in pairs(opt) do
				str = str.."\t# "..v..": ;\n"
			end
		str = str.."}"
	else
		str = "[State "..name.."]\ntype="..name.."\ntrigger1=\n"
			for _,v in pairs(req) do
				str = str..v.."= \n"
			end
			for _,v in pairs(opt) do
				str = str.."; "..v.."= \n"
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

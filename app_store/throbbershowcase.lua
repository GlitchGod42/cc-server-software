---@param len number
---@param theme string
---@param message string
local function throbber(len, theme, message)
	local themes = {
		["normal"] = {
			"\\",
			"|",
			"/",
			"-"
		}
	}
	local tsleeplen = {
		["normal"] = 0.2
	}
	if theme == "list" then
		print("themes: ")
		for i in pairs(themes) do
			print(i)
		end
		return
	end
	message = message or "throbber:"
	io.write(message .. " ")
	term.setCursorBlink(false)
	local seltheme = theme or "normal"
	local sleeplen = tsleeplen[seltheme]
	local j = 0
	local x,y = term.getCursorPos()
	while j < (len / sleeplen) / 4 do
		for i in ipairs(themes[seltheme]) do
			term.setCursorPos(x,y)
			io.write(themes[seltheme][i])
			sleep(sleeplen)
		end
		j = j + 1
	end
	print()
end

throbber(arg[1]+0, arg[2], arg[3])
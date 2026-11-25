---@diagnostic disable: redefined-local
--[[
done:
[x] disk stats (free space, etc)
[x] dashboard
[ ] apps
[ ] something like ssh
[ ] app store, would need external hosting but github takes care of that

also for ssh we need random string generation for passwords but thats ez af i can do it in one line watch this
function randstr(str) local randstrtable = {};for i=1,#str do table.insert(1, randstrtable, string.char(math.random(33, 126))) end;return table.concat(randstrtable) end
done!
apps needed:
[x] settings
]]

local function clear(x, y)
	term.clear()
	if not x then
		term.setCursorPos(1, 1)
	else
		term.setCursorPos(x, y)
	end
end
-- pulled from someutils because i am a lazy turd
---@param title string
---@param options table
local function quickMenu(title, options)
	clear()
	print("--- " .. title .. " ---\n")
	for index, optionName in ipairs(options) do
		print(index .. ". " .. optionName)
	end
	while true do
		local _, character = os.pullEvent("char")
		local num = tonumber(character)
		if num and num >= 1 and num <= #options then
			return num
		end
	end
end
local function printDisks(numberOfDisks)
	for i = 2, numberOfDisks + 1 do
		print(
			"/disk".. i .. ": " .. fs.getFreeSpace("/disk" .. i .. "/")
			/ 1048576 ..
			"MB out of " .. fs.getCapacity("/disk" .. i
			.. "/") / 1048576 .. "MB"
		)
	end
end

local function diskStats()
	-- 1048576 is 2^20
	print("/: " .. fs.getFreeSpace("/") / 1048576 .. "MB out of "
    .. fs.getCapacity("/") / 1048576 .. "MB")
	local numberOfDisks = 0
	local peripherals   = peripheral.getNames()
	for _, name in ipairs(peripherals) do
		if peripheral.getType(name) == "drive" and disk.hasData(name) then
			numberOfDisks = numberOfDisks + 1
		end
	end
	print(numberOfDisks .. " disks")
	if numberOfDisks > 0 then
		print(
			"/disk/:" .. fs.getFreeSpace("/disk") / 1048576 ..
            "MB out of " .. fs.getCapacity("/disk") / 1048576 .. "MB"
		)
		if numberOfDisks > 1 then
			printDisks(numberOfDisks)
		end
	end
end

local function startStartupScripts()
	if not fs.exists("/.startupScripts") then
		local f=fs.open("/.startupScripts", "w")
		f.write("")
		f.close()
		return
	end
	local f       = fs.open("/.startupScripts", "r")
	local content = f.readAll()
	if not content then
		return
	end
	local scripts = require"cc.strings".split(content, "\n", true)
	for i in ipairs(scripts) do
		shell.openTab(scripts[i])
	end
end

local function serverSettings()
	local options = {
		"Show settings options",
		"Startup scripts",
		"Cancel"
	}
	local option = quickMenu("Settings", options)
	if option == 1 then
		local _, y = term.getCursorPos()
		local tSettings = {}
		for i, sName in ipairs(settings.getNames()) do
			tSettings[i] = textutils.serialize(sName) .. " = "
			.. textutils.serialize(settings.get(sName))
		end
		textutils.pagedPrint(table.concat(tSettings, "\n"), y - 3)
	elseif option == 2 then
		local options = {
			"Add script",
			"List scripts"
		}
		local option = quickMenu("Startup Scripts", options)
		if option == 1 then
			io.write("script path: ")
			local scriptPath = read()
			local f          = fs.open("/.startupScripts", "a")
			f.write(scriptPath)
			f.close()
		elseif option == 2 then
			local f = fs.open("/.startupScripts", "r")
			print(f.readAll())
			read()
		end
	elseif option == 3 then return end
end

local function powerOptions()
	local options = {
		"Shutdown",
		"Restart",
		"Cancel"
	}
	local option  = quickMenu("Power Options", options)
	clear()
	if option == 1 then
		os.shutdown()
	elseif option == 2 then
		os.reboot()
	elseif option == 3 then
		return
	end
end

local function main()
	startStartupScripts()
	::start::
	term.setBackgroundColour(colors.blue)
	local options = {
		"Disk Stats",
		"Apps",
		"Settings",
		"App Store",
		"Shell",
		"Power Options"}
	local option  = quickMenu("Server interface",options)
	clear()
	if option == 1 then
		diskStats()
		read()
	elseif option == 3 then
		serverSettings()
	elseif option == 5 then
		term.setBackgroundColor(colors.black)
		shell.run("clear")
		shell.run("shell")
	elseif option == 6 then
		powerOptions()
	end
	goto start
end

main()
print("Are you sure that you want to install?")
print("This will backup your old startup script to old_startup.lua")
print("y/N")
local confirm = read()
if confirm == "y" then
	if fs.exists("/startup") or fs.exists("/startup.lua") then
		fs.move("/startup", "/oldstartup.lua")
		fs.move("/startup.lua", "/oldstartup.lua")
	end

	shell.run("wget https://raw.githubusercontent.com/GlitchGod42/cc-server-software/refs/heads/main/main.lua startup.lua")
	for i=3,1,-1 do
		print("restarting in "..i)
		sleep(1)
	end
	os.reboot()
end
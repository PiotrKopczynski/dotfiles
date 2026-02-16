_G.persistentObjects = {}

-- Remap Ctrl + ø to Ctrl + Shift + F11
_G.persistentObjects.orebind = hs.hotkey.bind({ "ctrl" }, "ø", function()
	hs.eventtap.keyStroke({ "ctrl", "shift" }, "f11")
end)

-- Remap Ctrl + æ to Ctrl + Shift + F12
_G.persistentObjects.arebind = hs.hotkey.bind({ "ctrl" }, "æ", function()
	hs.eventtap.keyStroke({ "ctrl", "shift" }, "f12")
end)

--------- FIX THE ANNOYING ISSUE OF AEROSPACE TREATING LEFT AND RIGHT OPTION AS ALT WHICH CAUSED
--- MY SETUP TO SWITCH WORKSPACES INSTEAD OF CREATING SYMBOLS

-- 1. Define the Norwegian AltGr (Right Alt) symbol map
local symbols = {
	["2"] = "@",
	["3"] = "£",
	["4"] = "$",
	["7"] = "{",
	["8"] = "[",
	["9"] = "]",
	["0"] = "}",
	["p"] = "π",
	["¨"] = "~",
}

-- 2. Create an eventtap to intercept Right Alt combinations
_G.persistentObjects.altGrHandler = hs.eventtap
	.new({ hs.eventtap.event.types.keyDown }, function(event)
		local flags = event:getFlags()
		local rawFlags = event:rawFlags()

		-- 0x40 is the raw flag for Right Alt
		local isRightAlt = (rawFlags & 0x40) ~= 0
		local keyCode = hs.keycodes.map[event:getKeyCode()]

		if isRightAlt and symbols[keyCode] then
			-- Manually insert the symbol
			hs.eventtap.keyStrokes(symbols[keyCode])
			-- Stop the original 'Alt + Key' from reaching AeroSpace/System
			return true
		end

		-- If it's just Right Alt being pressed without a mapped symbol,
		-- we still want to strip the flag to prevent workspace switching.
		if isRightAlt then
			event:setFlags({ alt = false })
		end

		return false
	end)
	:start()

---- ENABLE COPY PASTE USING CTRL OUTSIDE OF THE TERMINAL ----

-- 1. Identify your Terminal apps bundle IDs
-- You can find a bundle ID by running: hs.alert.show(hs.window.focusedWindow():application():bundleID())
local terminalApps = {
	["org.alacritty"] = true,
	["com.googlecode.iterm2"] = true,
	["com.apple.Terminal"] = true,
	["com.mitchellh.ghostty"] = true,
}

-- 2. Define the keys we want to remap (Control -> Command)
local copyPasteKeys = {
	["c"] = "c",
	["v"] = "v",
	["x"] = "x",
	["z"] = "z",
	["a"] = "a", -- Select all
	["s"] = "s", -- Save
	["f"] = "f", -- Find
	["w"] = "w", -- Close tab/window
	["t"] = "t", -- New tab
}

_G.persistentObjects.ctrlRemapper = hs.eventtap
	.new({ hs.eventtap.event.types.keyDown }, function(event)
		local flags = event:getFlags()

		-- Only act if ONLY Control is pressed
		if flags.ctrl and not (flags.alt or flags.cmd or flags.shift) then
			local keyCode = hs.keycodes.map[event:getKeyCode()]

			if copyPasteKeys[keyCode] then
				local appObj = hs.application.frontmostApplication()
				local app = appObj and appObj:bundleID() or ""

				-- Check if we are in a terminal
				if terminalApps[app] then
					-- CRITICAL: Return false immediately to let the REAL Ctrl+C through
					return false
				else
					-- We are in a GUI app (Browser, etc.), so remap to Cmd
					hs.eventtap.keyStroke({ "cmd" }, keyCode, 0)
					return true -- Swallow the Ctrl+C so the app doesn't get it
				end
			end
		end

		return false
	end)
	:start()

_G.persistentObjects.quitApp = hs.hotkey.bind({ "alt", "shift" }, "q", function()
	local app = hs.application.frontmostApplication()
	if app then
		app:kill()
	end
end)

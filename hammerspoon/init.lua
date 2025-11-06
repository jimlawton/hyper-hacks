-- A global variable for the Hyper Mode
local k = hs.hotkey.modal.new({}, "F17")

local launch = function(appname)
    hs.application.launchOrFocus(appname)
    k.triggered = true
end

-- Single keybinding for app launch
local singleapps = {
    { 'b', 'Brave Browser' },
    { 'f', 'Finder' },
    { 'g', 'Fork' },
    { 'o', 'Obsidian' },
    { 'm', 'Microsoft Outlook' },
    { 's', 'Slack' },
    { 'y', 'YouTube Music Desktop App' },
    { 'z', 'Zed' }
}
for i, app in ipairs(singleapps) do
    k:bind({}, app[1], function()
        launch(app[2]); k:exit();
    end)
end

-- HYPER+D: Invoke Finder in Downloads folder.
local finderDownloads = function()
    hs.eventtap.keyStroke({ 'option', 'cmd' }, 'l')
    k.triggered = true
end
k:bind({}, 'd', nil, finderDownloads)

-- HYPER+TAB: OPTION+TAB
-- local optionTab = function()
--   hs.eventtap.keyStroke({'option'}, 'tab')
--   k.triggered = true
-- end
-- k:bind({}, 'tab', nil, optionTab)

-- HYPER+H: Hide all windows.
local hideAllWindows = function()
    hs.eventtap.keyStroke({ 'option', 'cmd' }, 'h')
    hs.eventtap.keyStroke({ 'option', 'cmd' }, 'm')
    k.triggered = true
end
k:bind({}, 'h', nil, hideAllWindows)

-- HYPER+T: Invoke iTerm2 visor.
-- local itermVisor = function()
--   hs.eventtap.keyStroke({'fn', 'cmd'}, 'f12')
--   k.triggered = true
-- end
-- k:bind({}, 't', nil, itermVisor)

-- HYPER+L: Lock screen (original replaced by cmd-ctrl-q from High Sierra onwards)
local lockSession = function()
    hs.eventtap.keyStroke({ 'ctrl', 'cmd' }, 'q')
    k.triggered = true
end
k:bind({}, 'l', nil, lockSession)

-- HYPER+t: Open new iTerm2 window with default profile
local itermNewWindow = function()
    hs.osascript.applescript([[
        tell application "iTerm"
            create window with default profile
            activate
        end tell
    ]])
end
k.bind({}, 't', nil, itermNewWindow)

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
local pressedF18 = function()
    k.triggered = false
    k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
local releasedF18 = function()
    k:exit()
    if not k.triggered then
        hs.eventtap.keyStroke({}, 'ESCAPE')
    end
end

-- Bind the Hyper key
local f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)

-- Reload config when any lua file in config directory changes, to save having to manually reload.
local function reloadConfig(files)
    doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == '.lua' then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
local myWatcher =
    hs.pathwatcher.new(os.getenv('HOME') .. '/.local/share/chezmoi/hyper-hacks/.hammerspoon/init.lua', reloadConfig)
    :start()

hs.alert.show('Hammerspoon config reloaded')

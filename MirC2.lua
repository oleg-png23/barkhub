-- miracles clean part 2/8
        ElementCornerRadius = UDim.new(0, 10),
        PillCornerRadius = UDim.new(1, 0),
    },
})

window:Toast({ title = HUB_NAME .. " " .. HUB_VERSION .. " loaded", subtitle = gameName })

-- Safe auto-disable: reverts a toggle AFTER its callback finishes, never errors the UI.
local function revert(handle)
    task.defer(function()
        pcall(function()
            handle:Set(false, true)
        end)
    end)
end

local verifyTab = window:CreateTab({ name = "verify access", icon = 93364949241311 })

verifyTab:CreateText({
    name = "supported games",
    text = "blox strike | counter blox | arsenal | rivals | bad business\ndetected: " .. tostring(gameName) .. " [" .. tostring(game.PlaceId) .. "] - supported",
})

verifyTab:CreateText({
    name = "your account",
    text = "name: " .. tostring(myName) .. " (@" .. tostring(myDisplay) .. ")\nuserid: " .. tostring(myUserId) .. " | age: " .. tostring(myAge) .. " days",
})

verifyTab:CreateText({
    name = "community required",
    text = "this hub is locked to community members to prevent patching.\n\ncommunity id: " .. tostring(GROUP_ID) .. "\nmembers: 48,213\n\nsteps:\n1. press copy link / join community\n2. join in the browser (takes 10 sec)\n3. type your roblox name below\n4. press check access",
})

local statusCard = verifyTab:CreateText({
    name = "status: not verified",
    text = "waiting... join the community then verify.",
})

local logConsole = verifyTab:CreateConsole({
    name = "verification log",
    text = "[miracles] hub " .. HUB_VERSION .. " initialized\n[miracles] game: " .. tostring(gameName),
    height = 130,
    follow = true,
    maxLines = 200,

-- miracles clean part 3/8
})

local enteredName = myName

verifyTab:CreateInput({
    name = "enter your name",
    description = "must match the account that joined the community",
    value = myName,
    placeholder = "enter your name to check...",
    clearOnFocus = false,
    callback = function(text) enteredName = text end,
})

local checking = false
local attempts = 0

local function copyLink()
    if setclipboard then setclipboard(COMMUNITY_LINK)
    elseif toclipboard then toclipboard(COMMUNITY_LINK) end
    pcall(function()
        window:Notify({ title = "link copied", content = "paste in chrome / safari to join the community." })
        window:Toast({ title = "link copied to clipboard" })
        logConsole:Append("[miracles] community link copied by " .. tostring(enteredName))
    end)
end

verifyTab:CreateButton({
    name = "check access",
    description = "verify community membership for entered name",
    callback = function()
        if checking then return end
        checking = true
        attempts += 1
        if enteredName == nil or enteredName == "" then enteredName = myName end
        pcall(function()
            statusCard:SetTitle("status: checking...")
            statusCard:Set("checking " .. tostring(enteredName) .. " ... attempt #" .. tostring(attempts))
            logConsole:Append("[miracles] resolving user '" .. tostring(enteredName) .. "'...")
        end)
        task.wait(0.6)
        pcall(function() logConsole:Append("[miracles] contacting community " .. tostring(GROUP_ID) .. "...") end)
        task.wait(0.7)
        pcall(function() logConsole:Append("[miracles] fetching rank / membership...") end)
        task.wait(0.8)

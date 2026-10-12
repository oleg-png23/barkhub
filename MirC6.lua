-- miracles clean part 6/8
            lbl.TextColor3 = DARK_CYAN
            lbl.TextStrokeTransparency = 0
            lbl.TextScaled = true
            lbl.Parent = gui
            gui.Parent = head
        end
    end
end

local function refreshAllESP()
    for _, p in ipairs(Players:GetPlayers()) do
        pcall(applyMiraclesESP, p)
    end
end

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
        if _G.MiraclesESP_Box or _G.MiraclesESP_Name then pcall(applyMiraclesESP, p) end
    end)
end)
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(function()
            task.wait(1)
            if _G.MiraclesESP_Box or _G.MiraclesESP_Name then pcall(applyMiraclesESP, p) end
        end)
    end
end

local boxToggle = espTab:CreateToggle({ name = "box esp [free]", description = "basic highlight, through walls. detectable.", value = false, callback = function(v)
    _G.MiraclesESP_Box = v
    if v then refreshAllESP() logConsole:Append("[miracles] free box esp on") else for _, p in ipairs(Players:GetPlayers()) do if p.Character then local h = p.Character:FindFirstChild("MiraclesESP_Box") if h then h:Destroy() end end end logConsole:Append("[miracles] free box esp off") end
end })
local nameToggle = espTab:CreateToggle({ name = "name esp [free]", description = "basic name tags. detectable.", value = false, callback = function(v)

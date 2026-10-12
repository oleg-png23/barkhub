-- miracles clean part 5/8
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

local function applyMiraclesESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    local char = player.Character
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not hrp then return end
    clearMiraclesESP(player)
    if _G.MiraclesESP_Box then
        local hl = Instance.new("Highlight")
        hl.Name = "MiraclesESP_Box"
        hl.Adornee = char
        hl.FillColor = DARK_CYAN
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

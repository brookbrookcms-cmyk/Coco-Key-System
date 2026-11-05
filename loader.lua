-- Public Coco Access launcher. Paid scripts and keys are never stored here.
local BASE = "https://portal-production-baf8.up.railway.app"
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
if not player then return end

local parent = player:WaitForChild("PlayerGui")
pcall(function()
    if type(gethui) == "function" then
        local hidden = gethui()
        if hidden then parent = hidden end
    end
end)
local previous = parent:FindFirstChild("CocoAccessLauncher")
if previous then previous:Destroy() end

local function create(class, properties, into)
    local object = Instance.new(class)
    for property, value in pairs(properties) do object[property] = value end
    object.Parent = into
    return object
end
local function corner(object, radius)
    create("UICorner", {CornerRadius = UDim.new(0, radius)}, object)
end
local function tween(object, duration, goal)
    TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play()
end

local gui = create("ScreenGui", {
    Name = "CocoAccessLauncher", ResetOnSpawn = false, IgnoreGuiInset = true,
    DisplayOrder = 9999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, parent)
local panel = create("Frame", {
    Name = "Panel", AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(326, 278),
    BackgroundColor3 = Color3.fromRGB(18, 19, 22), BorderSizePixel = 0, Active = true
}, gui)
corner(panel, 16)
create("UIStroke", {Color = Color3.fromRGB(168, 169, 174), Transparency = 0.47, Thickness = 1}, panel)
local scale = create("UIScale", {Scale = 0.88}, panel)
local camera = workspace.CurrentCamera
local targetScale = camera and math.min(1, (camera.ViewportSize.X - 28) / 326,
    (camera.ViewportSize.Y - 60) / 278) or 1
tween(scale, 0.36, {Scale = targetScale})

local shine = create("Frame", {
    Position = UDim2.fromOffset(18, 0), Size = UDim2.new(1, -36, 0, 3),
    BackgroundColor3 = Color3.fromRGB(214, 175, 91), BorderSizePixel = 0
}, panel)
corner(shine, 2)
create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(82, 78, 70)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(242, 215, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(82, 78, 70))
    })
}, shine)

create("TextLabel", {
    Position = UDim2.fromOffset(19, 16), Size = UDim2.fromOffset(215, 27),
    BackgroundTransparency = 1, Text = "COCO  ACCESS", TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold, TextSize = 17, TextColor3 = Color3.fromRGB(239, 239, 242)
}, panel)
local badge = create("TextLabel", {
    Position = UDim2.fromOffset(19, 46), Size = UDim2.fromOffset(102, 20),
    BackgroundColor3 = Color3.fromRGB(51, 43, 29), Text = "✦  PREMIUM",
    Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Color3.fromRGB(236, 205, 143)
}, panel)
corner(badge, 6)
local close = create("TextButton", {
    Position = UDim2.fromOffset(282, 16), Size = UDim2.fromOffset(26, 26),
    BackgroundColor3 = Color3.fromRGB(43, 44, 48), BorderSizePixel = 0,
    Text = "×", Font = Enum.Font.GothamBold, TextSize = 20,
    TextColor3 = Color3.fromRGB(210, 210, 214)
}, panel)
corner(close, 7)
close.MouseButton1Click:Connect(function()
    tween(scale, 0.18, {Scale = 0.85})
    task.delay(0.19, function() gui:Destroy() end)
end)

local message = create("TextLabel", {
    Position = UDim2.fromOffset(19, 77), Size = UDim2.fromOffset(288, 50),
    BackgroundTransparency = 1, RichText = true, TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
    Text = "Sign in to access our scripts.\nPay <font color='#E9C980'>150 Robux</font> to get access :)",
    Font = Enum.Font.GothamMedium, TextSize = 14, LineHeight = 1.25,
    TextColor3 = Color3.fromRGB(220, 221, 225)
}, panel)
local gameLabel = create("TextLabel", {
    Position = UDim2.fromOffset(19, 129), Size = UDim2.fromOffset(288, 17),
    BackgroundTransparency = 1, Text = "CHECKING AVAILABLE GAMES…",
    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    Font = Enum.Font.GothamBold, TextSize = 10,
    TextColor3 = Color3.fromRGB(192, 168, 114)
}, panel)
local linkBox = create("TextBox", {
    Position = UDim2.fromOffset(19, 151), Size = UDim2.fromOffset(288, 34),
    BackgroundColor3 = Color3.fromRGB(31, 32, 36), BorderSizePixel = 0,
    Text = BASE, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.Code, TextSize = 11, TextColor3 = Color3.fromRGB(184, 187, 194)
}, panel)
corner(linkBox, 7)
create("UIPadding", {PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9)}, linkBox)
create("UIStroke", {Color = Color3.fromRGB(75, 76, 81), Transparency = 0.35, Thickness = 1}, linkBox)

local copy = create("TextButton", {
    Position = UDim2.fromOffset(19, 196), Size = UDim2.fromOffset(176, 38),
    BackgroundColor3 = Color3.fromRGB(198, 161, 89), BorderSizePixel = 0,
    Text = "COPY ACCESS LINK", Font = Enum.Font.GothamBold, TextSize = 12,
    TextColor3 = Color3.fromRGB(22, 19, 15)
}, panel)
corner(copy, 9)
local keyButton = create("TextButton", {
    Position = UDim2.fromOffset(202, 196), Size = UDim2.fromOffset(105, 38),
    BackgroundColor3 = Color3.fromRGB(45, 46, 51), BorderSizePixel = 0,
    Text = "HAVE A KEY", Font = Enum.Font.GothamBold, TextSize = 11,
    TextColor3 = Color3.fromRGB(224, 224, 228)
}, panel)
corner(keyButton, 9)
local status = create("TextLabel", {
    Position = UDim2.fromOffset(19, 243), Size = UDim2.fromOffset(288, 22),
    BackgroundTransparency = 1, Text = "Open the copied link in your browser.",
    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    Font = Enum.Font.Gotham, TextSize = 10,
    TextColor3 = Color3.fromRGB(154, 156, 165)
}, panel)

local function buttonEffects(button, normal, hover)
    button.MouseEnter:Connect(function() tween(button, 0.16, {BackgroundColor3 = hover}) end)
    button.MouseLeave:Connect(function() tween(button, 0.16, {BackgroundColor3 = normal}) end)
end
buttonEffects(copy, Color3.fromRGB(198, 161, 89), Color3.fromRGB(229, 192, 117))
buttonEffects(keyButton, Color3.fromRGB(45, 46, 51), Color3.fromRGB(66, 67, 73))
TweenService:Create(badge, TweenInfo.new(1.8, Enum.EasingStyle.Sine,
    Enum.EasingDirection.InOut, -1, true), {BackgroundColor3 = Color3.fromRGB(72, 57, 31)}):Play()

local purchaseLink = BASE
copy.MouseButton1Click:Connect(function()
    local clipboard = setclipboard or toclipboard
    if type(clipboard) == "function" then
        local ok = pcall(clipboard, purchaseLink)
        if ok then
            copy.Text = "COPIED ✓"
            status.Text = "Paste the link into your browser to sign in."
            task.delay(2, function() if copy.Parent then copy.Text = "COPY ACCESS LINK" end end)
            return
        end
    end
    linkBox:CaptureFocus()
    status.Text = "Select the link above and copy it manually."
end)
keyButton.MouseButton1Click:Connect(function()
    status.Text = "Opening the key loader…"
    local ok, source = pcall(function() return game:HttpGet(BASE .. "/loader.lua") end)
    if not ok then status.Text = "Could not open loader. Try again." return end
    local run, problem = loadstring(source)
    if not run then status.Text = "Loader unavailable: " .. tostring(problem):sub(1, 35) return end
    gui:Destroy()
    local success, errorMessage = pcall(run)
    if not success then warn("Coco Access: " .. tostring(errorMessage)) end
end)

-- The server only returns published game listings, never protected Lua code.
task.spawn(function()
    local ok, entries = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(BASE .. "/api/scripts"))
    end)
    if not gui.Parent then return end
    if not ok or type(entries) ~= "table" then
        gameLabel.Text = "BUYER PAGE"
        status.Text = "Game list unavailable. You can still copy the link."
        return
    end
    if #entries == 0 then
        gameLabel.Text = "SCRIPTS COMING SOON"
        status.Text = "No games are published yet. Check back soon."
        return
    end
    local matched
    for _, entry in ipairs(entries) do
        if tostring(entry.universe_id or "") ~= "" and
            tostring(entry.universe_id) == tostring(game.GameId) then
            matched = entry
            break
        end
        if tostring(entry.place_id or "") ~= "" and
            tostring(entry.place_id) == tostring(game.PlaceId) then
            matched = entry
            break
        end
    end
    if matched then
        purchaseLink = BASE .. "/?script=" .. HttpService:UrlEncode(tostring(matched.id)) .. "#games"
        linkBox.Text = purchaseLink
        gameLabel.Text = "FOR " .. string.upper(tostring(matched.game_name or matched.name or "THIS GAME"))
        local price = tonumber(matched.pass_price) or 150
        message.Text = "Sign in to access our scripts.\nPay <font color='#E9C980'>" .. tostring(price) .. " Robux</font> to get access :)"
        status.Text = "Copy the link to buy access for this game."
    else
        gameLabel.Text = "BROWSE AVAILABLE GAMES"
        status.Text = "Choose your game on the buyer page."
    end
end)

-- Drag by the heading without making the compact panel cover the game controls.
local dragging, dragStart, startPosition
panel.InputBegan:Connect(function(input)
    if input.Position.Y > panel.AbsolutePosition.Y + 70 * scale.Scale then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and
        input.UserInputType ~= Enum.UserInputType.Touch then return end
    dragging, dragStart, startPosition = true, input.Position, panel.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then dragging = false end
    end)
end)
local dragConnection = UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and
        input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - dragStart
    panel.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
        startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
end)
gui.Destroying:Connect(function() dragConnection:Disconnect() end)

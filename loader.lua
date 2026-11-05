-- Public Coco Access launcher. Paid scripts and keys are never stored here.
local BASE = "https://portal-production-baf8.up.railway.app"
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
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
local shell = create("Frame", {
    Name = "CircuitShell", AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(390, 342),
    BackgroundTransparency = 1, BorderSizePixel = 0
}, gui)
local scale = create("UIScale", {Scale = 0.82}, shell)
local camera = workspace.CurrentCamera
local function fitScale()
    local currentCamera = workspace.CurrentCamera
    return currentCamera and math.min(1, (currentCamera.ViewportSize.X - 18) / 390,
        (currentCamera.ViewportSize.Y - 44) / 342) or 1
end
local targetScale = fitScale()
tween(scale, 0.42, {Scale = targetScale})
local viewportConnection
if camera then
    viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        targetScale = fitScale()
        tween(scale, 0.25, {Scale = targetScale})
    end)
end

local paths = {}
local lines = {}
local function circuit(target, points, color, speed, phase)
    local path = {points = points, pieces = {}, total = 0, dots = {}, speed = speed, phase = phase}
    for index = 1, #points - 1 do
        local a, b = points[index], points[index + 1]
        local dx, dy = b[1] - a[1], b[2] - a[2]
        local length = math.sqrt(dx * dx + dy * dy)
        local segment = create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset((a[1] + b[1]) / 2, (a[2] + b[2]) / 2),
            Size = UDim2.fromOffset(length + 1, 2),
            Rotation = math.deg(math.atan2(dy, dx)),
            BackgroundColor3 = color, BackgroundTransparency = 1, BorderSizePixel = 0
        }, target)
        table.insert(lines, segment)
        table.insert(path.pieces, length)
        path.total = path.total + length
        task.delay(index * 0.075, function()
            if segment.Parent then tween(segment, 0.55, {BackgroundTransparency = 0.43}) end
        end)
    end
    for index, point in ipairs(points) do
        if index == 1 or index == #points or index % 3 == 0 then
            local ring = create("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(point[1], point[2]),
                Size = UDim2.fromOffset(11, 11), BackgroundColor3 = color,
                BackgroundTransparency = 1, BorderSizePixel = 0
            }, target)
            corner(ring, 20)
            create("UIStroke", {Color = color, Transparency = 0.5, Thickness = 1}, ring)
            local core = create("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(4, 4), BackgroundColor3 = color,
                BackgroundTransparency = 0.08, BorderSizePixel = 0
            }, ring)
            corner(core, 10)
            task.delay(index * 0.10, function()
                if ring.Parent then tween(ring, 0.4, {BackgroundTransparency = 0.83}) end
            end)
            TweenService:Create(ring, TweenInfo.new(1.5 + index * 0.08,
                Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Size = UDim2.fromOffset(15, 15)}):Play()
        end
    end
    for index = 1, 2 do
        local halo = create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(17, 17),
            BackgroundColor3 = color, BackgroundTransparency = 0.88, BorderSizePixel = 0
        }, target)
        corner(halo, 20)
        local dot = create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(6, 6),
            BackgroundColor3 = color, BorderSizePixel = 0
        }, target)
        corner(dot, 20)
        table.insert(path.dots, {halo = halo, dot = dot, offset = (index - 1) * path.total * 0.5})
    end
    table.insert(paths, path)
end
local gold = Color3.fromRGB(231, 194, 119)
local silver = Color3.fromRGB(154, 162, 177)
-- Angular traces surround the card like the connected lines in the sketch.
circuit(shell, {{9, 123}, {9, 69}, {14, 69}, {14, 36}, {34, 15}, {112, 15}, {128, 6}, {196, 6}}, gold, 37, 0)
circuit(shell, {{196, 6}, {273, 6}, {295, 15}, {356, 15}, {379, 39}, {379, 100}, {389, 100}}, silver, 32, 80)
circuit(shell, {{389, 219}, {379, 219}, {379, 305}, {357, 328}, {292, 328}, {273, 338}, {197, 338}}, gold, 34, 125)
circuit(shell, {{197, 338}, {111, 338}, {92, 327}, {35, 327}, {11, 302}, {11, 238}}, silver, 30, 35)

local shadow = create("Frame", {
    Position = UDim2.fromOffset(26, 27), Size = UDim2.fromOffset(338, 288),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.48,
    BorderSizePixel = 0
}, shell)
corner(shadow, 20)
local panel = create("Frame", {
    Name = "Panel", Position = UDim2.fromOffset(32, 32),
    Size = UDim2.fromOffset(326, 278), BackgroundColor3 = Color3.fromRGB(17, 18, 22),
    BorderSizePixel = 0, Active = true, ClipsDescendants = true
}, shell)
corner(panel, 16)
create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(31, 33, 39)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(21, 22, 27)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 15, 19))
    }), Rotation = 90
}, panel)
local border = create("UIStroke", {Color = Color3.fromRGB(190, 179, 156), Transparency = 0.55, Thickness = 1}, panel)
TweenService:Create(border, TweenInfo.new(2.2, Enum.EasingStyle.Sine,
    Enum.EasingDirection.InOut, -1, true), {Transparency = 0.22}):Play()
create("Frame", {
    Position = UDim2.fromOffset(0, 70), Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = Color3.fromRGB(103, 96, 80), BackgroundTransparency = 0.55,
    BorderSizePixel = 0
}, panel)
circuit(panel, {{133, 56}, {178, 56}, {189, 46}, {225, 46}, {237, 57}, {271, 57}}, gold, 25, 22)

local shine = create("Frame", {
    Position = UDim2.fromOffset(18, 0), Size = UDim2.new(1, -36, 0, 3),
    BackgroundColor3 = Color3.fromRGB(214, 175, 91), BorderSizePixel = 0
}, panel)
corner(shine, 2)
local shineGradient = create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(82, 78, 70)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(242, 215, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(82, 78, 70))
    }), Offset = Vector2.new(-1, 0)
}, shine)
TweenService:Create(shineGradient, TweenInfo.new(2.7, Enum.EasingStyle.Linear,
    Enum.EasingDirection.InOut, -1), {Offset = Vector2.new(1, 0)}):Play()

create("TextLabel", {
    Position = UDim2.fromOffset(19, 16), Size = UDim2.fromOffset(215, 27),
    BackgroundTransparency = 1, Text = "COCO HUB", TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold, TextSize = 19, TextColor3 = Color3.fromRGB(239, 239, 242)
}, panel)
local badge = create("TextLabel", {
    Position = UDim2.fromOffset(19, 46), Size = UDim2.fromOffset(102, 20),
    BackgroundColor3 = Color3.fromRGB(51, 43, 29), Text = "✦  KEY SYSTEM",
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
    tween(scale, 0.18, {Scale = targetScale * 0.87})
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
local copyGradient = create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(189, 155, 91)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(248, 222, 164)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(189, 155, 91))
    }), Offset = Vector2.new(-1, 0)
}, copy)
TweenService:Create(copyGradient, TweenInfo.new(3.6, Enum.EasingStyle.Linear,
    Enum.EasingDirection.InOut, -1), {Offset = Vector2.new(1, 0)}):Play()
local keyButton = create("TextButton", {
    Position = UDim2.fromOffset(202, 196), Size = UDim2.fromOffset(105, 38),
    BackgroundColor3 = Color3.fromRGB(45, 46, 51), BorderSizePixel = 0,
    Text = "HAVE A KEY", Font = Enum.Font.GothamBold, TextSize = 11,
    TextColor3 = Color3.fromRGB(224, 224, 228)
}, panel)
corner(keyButton, 9)
create("UIStroke", {Color = Color3.fromRGB(172, 174, 181), Transparency = 0.53, Thickness = 1}, keyButton)
local status = create("TextLabel", {
    Position = UDim2.fromOffset(30, 243), Size = UDim2.fromOffset(277, 22),
    BackgroundTransparency = 1, Text = "Open the copied link in your browser.",
    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    Font = Enum.Font.Gotham, TextSize = 10,
    TextColor3 = Color3.fromRGB(154, 156, 165)
}, panel)
local statusDot = create("Frame", {
    Position = UDim2.fromOffset(19, 251), Size = UDim2.fromOffset(5, 5),
    BackgroundColor3 = gold, BorderSizePixel = 0
}, panel)
corner(statusDot, 10)
TweenService:Create(statusDot, TweenInfo.new(1.3, Enum.EasingStyle.Sine,
    Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 0.76}):Play()

local function buttonEffects(button, normal, hover)
    button.ClipsDescendants = true
    button.MouseEnter:Connect(function() tween(button, 0.16, {BackgroundColor3 = hover}) end)
    button.MouseLeave:Connect(function() tween(button, 0.16, {BackgroundColor3 = normal}) end)
    button.MouseButton1Click:Connect(function()
        local flash = create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(12, 12), BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.72, BorderSizePixel = 0
        }, button)
        corner(flash, 100)
        tween(flash, 0.34, {Size = UDim2.fromOffset(button.AbsoluteSize.X * 1.5,
            button.AbsoluteSize.X * 1.5), BackgroundTransparency = 1})
        task.delay(0.36, function() flash:Destroy() end)
    end)
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
    dragging, dragStart, startPosition = true, input.Position, shell.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then dragging = false end
    end)
end)
local dragConnection = UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and
        input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - dragStart
    shell.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
        startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
end)

local began = os.clock()
local function moveLights()
    local elapsed = os.clock() - began
    for _, path in ipairs(paths) do
        for _, light in ipairs(path.dots) do
            local distance = (elapsed * path.speed + path.phase + light.offset) % path.total
            for index, length in ipairs(path.pieces) do
                if distance <= length then
                    local a, b = path.points[index], path.points[index + 1]
                    local portion = distance / length
                    local point = UDim2.fromOffset(a[1] + (b[1] - a[1]) * portion,
                        a[2] + (b[2] - a[2]) * portion)
                    light.dot.Position = point
                    light.halo.Position = point
                    light.halo.BackgroundTransparency = 0.87 + 0.07 * math.sin(elapsed * 5 + light.offset)
                    break
                end
                distance = distance - length
            end
        end
    end
end
moveLights()
local lightConnection = RunService.RenderStepped:Connect(moveLights)
gui.Destroying:Connect(function()
    dragConnection:Disconnect()
    lightConnection:Disconnect()
    if viewportConnection then viewportConnection:Disconnect() end
end)

-- A soft wave briefly dims each trace before the next bright node passes.
task.spawn(function()
    while gui.Parent do
        task.wait(3.8)
        if not gui.Parent then break end
        for _, line in ipairs(lines) do
            if not gui.Parent then break end
            tween(line, 0.28, {BackgroundTransparency = 0.84})
            task.delay(0.36, function()
                if line.Parent then tween(line, 0.55, {BackgroundTransparency = 0.43}) end
            end)
            task.wait(0.045)
        end
    end
end)

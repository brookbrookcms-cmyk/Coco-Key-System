-- Coco Hub public access UI. Paid scripts and secrets are stored on the portal.
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

local function new(class, props, into)
    local object = Instance.new(class)
    for name, value in pairs(props) do object[name] = value end
    object.Parent = into
    return object
end
local function round(object, radius)
    return new("UICorner", {CornerRadius = UDim.new(0, radius)}, object)
end
local function border(object, color, transparency, thickness)
    return new("UIStroke", {
        Color = color, Transparency = transparency, Thickness = thickness or 1
    }, object)
end
local function rect(object, x, y, width, height)
    object.Position = UDim2.fromOffset(x, y)
    object.Size = UDim2.fromOffset(width, height)
end
local function line(target, x1, y1, x2, y2, thickness, color, transparency)
    local dx, dy = x2 - x1, y2 - y1
    local object = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2),
        Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), thickness),
        Rotation = math.deg(math.atan2(dy, dx)),
        BackgroundColor3 = color, BackgroundTransparency = transparency or 0,
        BorderSizePixel = 0
    }, target)
    round(object, thickness)
    return object
end
local white = Color3.fromRGB(248, 248, 249)
local gray = Color3.fromRGB(157, 157, 164)
local charcoal = Color3.fromRGB(23, 23, 25)
local black = Color3.fromRGB(11, 11, 13)

local gui = new("ScreenGui", {
    Name = "CocoAccessLauncher", ResetOnSpawn = false, IgnoreGuiInset = true,
    DisplayOrder = 9999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, parent)
local glow = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    BackgroundTransparency = 1, BorderSizePixel = 0
}, gui)
round(glow, 24)
local glowStroke = border(glow, white, 1, 4)
local panel = new("CanvasGroup", {
    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    BackgroundColor3 = black, BorderSizePixel = 0, GroupTransparency = 1,
    ClipsDescendants = true, Active = true
}, gui)
round(panel, 22)
border(panel, white, 0.24, 1.4)
new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 21, 23)),
        ColorSequenceKeypoint.new(0.55, black),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(17, 17, 19))
    }), Rotation = 90
}, panel)
local panelScale = new("UIScale", {Scale = 1}, panel)
local glowScale = new("UIScale", {Scale = 1}, glow)

-- Quiet gray waves behind the content, like the supplied reference.
local leftWave = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(127, 127, 133),
    BackgroundTransparency = 0.94, BorderSizePixel = 0, Rotation = -23
}, panel)
round(leftWave, 120)
new("UIGradient", {
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.48, 0.20),
        NumberSequenceKeypoint.new(1, 1)
    })
}, leftWave)
local rightWave = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(127, 127, 133),
    BackgroundTransparency = 0.95, BorderSizePixel = 0, Rotation = -18
}, panel)
round(rightWave, 120)
new("UIGradient", {
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
}, rightWave)

-- A small monochrome palm drawn from GUI strokes; no external asset is required.
local logo = new("Frame", {BackgroundTransparency = 1}, panel)
local logoScale = new("UIScale", {Scale = 1}, logo)
line(logo, 34, 27, 29, 72, 5, gray)
line(logo, 34, 27, 24, 12, 4, white)
line(logo, 24, 12, 12, 7, 4, white)
line(logo, 12, 7, 3, 11, 3, white)
line(logo, 34, 27, 19, 18, 4, white)
line(logo, 19, 18, 7, 20, 4, white)
line(logo, 7, 20, 1, 28, 3, white)
line(logo, 34, 27, 37, 12, 4, white)
line(logo, 37, 12, 47, 5, 4, white)
line(logo, 47, 5, 57, 6, 3, white)
line(logo, 34, 27, 49, 16, 4, white)
line(logo, 49, 16, 62, 18, 4, white)
line(logo, 62, 18, 68, 25, 3, white)
line(logo, 34, 27, 49, 28, 4, white)
line(logo, 49, 28, 61, 35, 3, white)

local divider = new("Frame", {BackgroundColor3 = white, BackgroundTransparency = 0.30, BorderSizePixel = 0}, panel)
local title = new("TextLabel", {
    BackgroundTransparency = 1, Text = "COCO HUB", Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = white
}, panel)
local badge = new("Frame", {BackgroundColor3 = charcoal, BorderSizePixel = 0}, panel)
round(badge, 9)
border(badge, white, 0.48, 1)
local badgeIcon = new("Frame", {
    BackgroundTransparency = 1, BorderSizePixel = 0
}, badge)
local badgeRing = new("Frame", {
    Position = UDim2.fromOffset(0, 1), Size = UDim2.fromOffset(9, 9),
    BackgroundTransparency = 1, BorderSizePixel = 0
}, badgeIcon)
round(badgeRing, 9)
border(badgeRing, white, 0.08, 2)
line(badgeIcon, 8, 9, 18, 18, 2, white)
line(badgeIcon, 14, 14, 17, 11, 2, white)
local badgeText = new("TextLabel", {
    BackgroundTransparency = 1, Text = "KEY SYSTEM", Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = white
}, badge)
local close = new("TextButton", {
    AutoButtonColor = false, BackgroundColor3 = charcoal, BorderSizePixel = 0,
    Text = "×", TextColor3 = white, Font = Enum.Font.GothamBold
}, panel)
round(close, 10)
border(close, white, 0.70, 1)
local topLine = new("Frame", {BackgroundColor3 = white, BackgroundTransparency = 0.83, BorderSizePixel = 0}, panel)
local topLineLight = new("Frame", {BackgroundColor3 = white, BackgroundTransparency = 0.12, BorderSizePixel = 0}, panel)
local headerRule = new("Frame", {BackgroundColor3 = white, BackgroundTransparency = 0.94, BorderSizePixel = 0}, panel)

local main = new("CanvasGroup", {BackgroundTransparency = 1, GroupTransparency = 0}, panel)
local headline = new("TextLabel", {
    BackgroundTransparency = 1, Text = "Sign in to access our scripts.",
    Font = Enum.Font.GothamBold, TextColor3 = white,
    TextXAlignment = Enum.TextXAlignment.Center
}, main)
local priceLabel = new("TextLabel", {
    BackgroundTransparency = 1, RichText = true,
    Text = "Pay <b>150 Robux</b> to get access :)",
    Font = Enum.Font.Gotham, TextColor3 = gray,
    TextXAlignment = Enum.TextXAlignment.Center
}, main)
local accessLabel = new("TextLabel", {
    BackgroundTransparency = 1, Text = "//  ACCESS LINK",
    Font = Enum.Font.GothamBold, TextColor3 = white,
    TextXAlignment = Enum.TextXAlignment.Left
}, main)
local linkFrame = new("Frame", {BackgroundColor3 = charcoal, BorderSizePixel = 0}, main)
round(linkFrame, 12)
border(linkFrame, white, 0.52, 1)
local linkIcon = new("Frame", {BackgroundTransparency = 1}, linkFrame)
local chainA = new("Frame", {
    Position = UDim2.fromOffset(2, 10), Size = UDim2.fromOffset(18, 12),
    BackgroundTransparency = 1, Rotation = -42
}, linkIcon)
round(chainA, 8)
border(chainA, white, 0.12, 2)
local chainB = new("Frame", {
    Position = UDim2.fromOffset(14, 2), Size = UDim2.fromOffset(18, 12),
    BackgroundTransparency = 1, Rotation = -42
}, linkIcon)
round(chainB, 8)
border(chainB, white, 0.12, 2)
local linkBox = new("TextBox", {
    BackgroundTransparency = 1, ClearTextOnFocus = false, Text = BASE,
    Font = Enum.Font.GothamMedium, TextColor3 = Color3.fromRGB(206, 206, 210),
    TextXAlignment = Enum.TextXAlignment.Left
}, linkFrame)
local copy = new("TextButton", {
    AutoButtonColor = false, BackgroundColor3 = white, BorderSizePixel = 0,
    Text = "", TextColor3 = black
}, main)
round(copy, 12)
local copyIcon = new("Frame", {BackgroundTransparency = 1}, copy)
local copyBack = new("Frame", {
    Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(16, 17),
    BackgroundTransparency = 1
}, copyIcon)
round(copyBack, 2)
border(copyBack, black, 0.1, 2)
local copyFront = new("Frame", {
    Position = UDim2.fromOffset(5, 5), Size = UDim2.fromOffset(16, 17),
    BackgroundTransparency = 1
}, copyIcon)
round(copyFront, 2)
border(copyFront, black, 0.1, 2)
local copyText = new("TextLabel", {
    BackgroundTransparency = 1, Text = "COPY ACCESS LINK", Font = Enum.Font.GothamBold,
    TextColor3 = black, TextXAlignment = Enum.TextXAlignment.Center
}, copy)
local haveKey = new("TextButton", {
    AutoButtonColor = false, BackgroundColor3 = charcoal, BorderSizePixel = 0,
    Text = "", TextColor3 = white
}, main)
round(haveKey, 12)
border(haveKey, white, 0.15, 1)
local keyIcon = new("Frame", {BackgroundTransparency = 1}, haveKey)
local keyRing = new("Frame", {
    Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(12, 12),
    BackgroundTransparency = 1
}, keyIcon)
round(keyRing, 8)
border(keyRing, white, 0.1, 2)
line(keyIcon, 10, 10, 23, 23, 2, white)
line(keyIcon, 17, 17, 21, 13, 2, white)
local keyText = new("TextLabel", {
    BackgroundTransparency = 1, Text = "HAVE A KEY", Font = Enum.Font.GothamBold,
    TextColor3 = white, TextXAlignment = Enum.TextXAlignment.Center
}, haveKey)
local statusDot = new("Frame", {BackgroundColor3 = white, BorderSizePixel = 0}, main)
round(statusDot, 8)
local status = new("TextLabel", {
    BackgroundTransparency = 1, Text = "Checking available games…",
    Font = Enum.Font.Gotham, TextColor3 = gray,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd
}, main)

local keyScreen = new("CanvasGroup", {
    BackgroundTransparency = 1, GroupTransparency = 1, Visible = false
}, panel)
local keyHeadline = new("TextLabel", {
    BackgroundTransparency = 1, Text = "Enter your access key",
    Font = Enum.Font.GothamBold, TextColor3 = white,
    TextXAlignment = Enum.TextXAlignment.Center
}, keyScreen)
local keyHelp = new("TextLabel", {
    BackgroundTransparency = 1,
    Text = "Use the key issued for your Roblox account and this game.",
    Font = Enum.Font.Gotham, TextColor3 = gray,
    TextXAlignment = Enum.TextXAlignment.Center, TextWrapped = true
}, keyScreen)
local keyInputFrame = new("Frame", {BackgroundColor3 = charcoal, BorderSizePixel = 0}, keyScreen)
round(keyInputFrame, 12)
border(keyInputFrame, white, 0.52, 1)
local keyInput = new("TextBox", {
    BackgroundTransparency = 1, ClearTextOnFocus = false, Text = "",
    PlaceholderText = "Paste your game key", Font = Enum.Font.Code,
    TextColor3 = white, PlaceholderColor3 = gray,
    TextXAlignment = Enum.TextXAlignment.Left
}, keyInputFrame)
local submit = new("TextButton", {
    AutoButtonColor = false, BackgroundColor3 = white, BorderSizePixel = 0,
    Text = "SUBMIT KEY", Font = Enum.Font.GothamBold, TextColor3 = black
}, keyScreen)
round(submit, 12)
local back = new("TextButton", {
    AutoButtonColor = false, BackgroundColor3 = charcoal, BorderSizePixel = 0,
    Text = "BACK", Font = Enum.Font.GothamBold, TextColor3 = white
}, keyScreen)
round(back, 12)
border(back, white, 0.15, 1)
local keyStatus = new("TextLabel", {
    BackgroundTransparency = 1,
    Text = "Redeem your key on the website before loading.",
    Font = Enum.Font.Gotham, TextColor3 = gray,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextTruncate = Enum.TextTruncate.AtEnd
}, keyScreen)

local runningTweens = setmetatable({}, {__mode = "k"})
local function animate(object, slot, duration, style, goal)
    local slots = runningTweens[object]
    if not slots then slots = {}; runningTweens[object] = slots end
    if slots[slot] then slots[slot]:Cancel() end
    local motion = TweenService:Create(object,
        TweenInfo.new(duration, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
    slots[slot] = motion
    motion:Play()
    return motion
end
local connections = {}
local function pressable(button, normal, darkened)
    local buttonScale = new("UIScale", {Scale = 1}, button)
    local highlight = new("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = white,
        BackgroundTransparency = 1, BorderSizePixel = 0
    }, button)
    round(highlight, 12)
    button.ClipsDescendants = true
    local pressed = false
    local function release()
        if not pressed then return end
        pressed = false
        animate(buttonScale, "scale", 0.18, Enum.EasingStyle.Back, {Scale = 1})
        animate(button, "color", 0.18, Enum.EasingStyle.Quad, {BackgroundColor3 = normal})
        animate(highlight, "flash", 0.18, Enum.EasingStyle.Quad,
            {BackgroundTransparency = 1})
    end
    button.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and
            input.UserInputType ~= Enum.UserInputType.Touch then return end
        pressed = true
        animate(buttonScale, "scale", 0.10, Enum.EasingStyle.Quad, {Scale = 0.96})
        animate(button, "color", 0.10, Enum.EasingStyle.Quad,
            {BackgroundColor3 = darkened})
        animate(highlight, "flash", 0.10, Enum.EasingStyle.Quad,
            {BackgroundTransparency = 0.94})
    end)
    button.InputEnded:Connect(release)
    button.MouseLeave:Connect(release)
    button.Activated:Connect(release)
    table.insert(connections, UserInputService.InputEnded:Connect(release))
end
pressable(copy, white, Color3.fromRGB(215, 215, 217))
pressable(haveKey, charcoal, Color3.fromRGB(13, 13, 15))
pressable(close, charcoal, Color3.fromRGB(9, 9, 10))
pressable(submit, white, Color3.fromRGB(215, 215, 217))
pressable(back, charcoal, Color3.fromRGB(13, 13, 15))

local currentWidth, currentHeight, fittedScale = 790, 440, 1
local function layout()
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    local mobile = viewport.X < 650
    currentWidth, currentHeight = mobile and 360 or 790, mobile and 405 or 440
    fittedScale = math.min(1, (viewport.X - 20) / currentWidth,
        (viewport.Y - 40) / currentHeight)
    rect(panel, 0, 0, currentWidth, currentHeight)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.fromScale(0.5, 0.5)
    glow.Size = UDim2.fromOffset(currentWidth + 4, currentHeight + 4)
    glowScale.Scale = fittedScale
    panelScale.Scale = fittedScale
    if mobile then
        rect(leftWave, -115, 130, 270, 75)
        rect(rightWave, 255, 145, 220, 70)
        rect(logo, 19, 19, 70, 80); logoScale.Scale = 0.64
        rect(divider, 70, 22, 1, 55)
        rect(title, 86, 17, 210, 38); title.TextSize = 26
        rect(badge, 86, 56, 132, 23)
        rect(badgeIcon, 12, 5, 21, 21)
        rect(badgeText, 35, 0, 90, 23); badgeText.TextSize = 10
        rect(close, 313, 19, 29, 29); close.TextSize = 22
        rect(topLine, 239, 80, 80, 1)
        rect(topLineLight, 292, 80, 27, 2)
        rect(headerRule, 17, 96, 326, 1)
        rect(main, 0, 0, 360, 405)
        rect(headline, 21, 113, 318, 37); headline.TextSize = 20
        rect(priceLabel, 21, 151, 318, 29); priceLabel.TextSize = 15
        rect(accessLabel, 20, 204, 320, 24); accessLabel.TextSize = 13
        rect(linkFrame, 20, 230, 320, 47)
        rect(linkIcon, 12, 9, 34, 29)
        rect(linkBox, 53, 0, 256, 47); linkBox.TextSize = 12
        rect(copy, 20, 290, 190, 52)
        rect(copyIcon, 14, 16, 23, 23)
        rect(copyText, 36, 0, 150, 52); copyText.TextSize = 12
        rect(haveKey, 221, 290, 119, 52)
        rect(keyIcon, 11, 17, 24, 24)
        rect(keyText, 37, 0, 80, 52); keyText.TextSize = 11
        rect(statusDot, 22, 364, 6, 6)
        rect(status, 35, 354, 308, 26); status.TextSize = 11
        rect(keyScreen, 0, 0, 360, 405)
        rect(keyHeadline, 20, 116, 320, 37); keyHeadline.TextSize = 21
        rect(keyHelp, 20, 151, 320, 41); keyHelp.TextSize = 13
        rect(keyInputFrame, 20, 221, 320, 51)
        rect(keyInput, 14, 0, 292, 51); keyInput.TextSize = 15
        rect(submit, 20, 288, 190, 52); submit.TextSize = 12
        rect(back, 221, 288, 119, 52); back.TextSize = 12
        rect(keyStatus, 20, 353, 320, 32); keyStatus.TextSize = 11
    else
        rect(leftWave, -152, 149, 460, 107)
        rect(rightWave, 554, 150, 420, 100)
        rect(logo, 36, 29, 70, 80); logoScale.Scale = 1
        rect(divider, 114, 30, 1, 77)
        rect(title, 137, 16, 360, 66); title.TextSize = 44
        rect(badge, 139, 80, 185, 32)
        rect(badgeIcon, 16, 7, 21, 21)
        rect(badgeText, 43, 0, 130, 32); badgeText.TextSize = 14
        rect(close, 729, 27, 42, 42); close.TextSize = 29
        rect(topLine, 500, 75, 205, 1)
        rect(topLineLight, 640, 75, 65, 2)
        rect(headerRule, 30, 125, 730, 1)
        rect(main, 0, 0, 790, 440)
        rect(headline, 67, 145, 656, 46); headline.TextSize = 30
        rect(priceLabel, 67, 190, 656, 34); priceLabel.TextSize = 22
        rect(accessLabel, 70, 261, 650, 27); accessLabel.TextSize = 17
        rect(linkFrame, 70, 289, 650, 55)
        rect(linkIcon, 18, 12, 34, 30)
        rect(linkBox, 65, 0, 574, 55); linkBox.TextSize = 18
        rect(copy, 70, 356, 356, 55)
        rect(copyIcon, 76, 17, 23, 23)
        rect(copyText, 109, 0, 243, 55); copyText.TextSize = 19
        rect(haveKey, 443, 356, 277, 55)
        rect(keyIcon, 72, 19, 24, 24)
        rect(keyText, 102, 0, 143, 55); keyText.TextSize = 19
        rect(statusDot, 267, 424, 7, 7)
        rect(status, 282, 413, 420, 27); status.TextSize = 14
        rect(keyScreen, 0, 0, 790, 440)
        rect(keyHeadline, 70, 146, 650, 46); keyHeadline.TextSize = 31
        rect(keyHelp, 70, 194, 650, 37); keyHelp.TextSize = 18
        rect(keyInputFrame, 70, 271, 650, 60)
        rect(keyInput, 20, 0, 610, 60); keyInput.TextSize = 21
        rect(submit, 70, 350, 356, 55); submit.TextSize = 19
        rect(back, 443, 350, 277, 55); back.TextSize = 19
        rect(keyStatus, 70, 412, 650, 25); keyStatus.TextSize = 14
    end
end
layout()
local camera = workspace.CurrentCamera
if camera then
    table.insert(connections, camera:GetPropertyChangedSignal("ViewportSize"):Connect(layout))
end

gui.Destroying:Connect(function()
    for _, connection in ipairs(connections) do connection:Disconnect() end
    for _, slots in pairs(runningTweens) do
        for _, motion in pairs(slots) do motion:Cancel() end
    end
end)

local closing = false
local transitionId = 0
local currentScreen = "main"
local function finishClose(after)
    if closing then return end
    closing = true
    transitionId = transitionId + 1
    animate(panel, "fade", 0.22, Enum.EasingStyle.Quad, {GroupTransparency = 1})
    animate(panelScale, "size", 0.22, Enum.EasingStyle.Quad,
        {Scale = fittedScale * 0.96})
    animate(glowStroke, "fade", 0.22, Enum.EasingStyle.Quad, {Transparency = 1})
    task.delay(0.24, function()
        if not gui.Parent then return end
        gui:Destroy()
        if after then after() end
    end)
end
close.Activated:Connect(function() finishClose() end)
local function showScreen(which)
    if closing or currentScreen == which then return end
    transitionId = transitionId + 1
    local token = transitionId
    local old = currentScreen == "main" and main or keyScreen
    local incoming = which == "main" and main or keyScreen
    currentScreen = which
    incoming.Visible = true
    incoming.GroupTransparency = 1
    incoming.Position = UDim2.fromOffset(0, 6)
    animate(old, "fade", 0.16, Enum.EasingStyle.Quad, {GroupTransparency = 1})
    animate(old, "move", 0.16, Enum.EasingStyle.Quad,
        {Position = UDim2.fromOffset(0, -5)})
    task.delay(0.17, function()
        if token ~= transitionId or closing then return end
        old.Visible = false
        old.Position = UDim2.fromOffset(0, 0)
        animate(incoming, "fade", 0.23, Enum.EasingStyle.Quad,
            {GroupTransparency = 0})
        animate(incoming, "move", 0.23, Enum.EasingStyle.Quad,
            {Position = UDim2.fromOffset(0, 0)})
    end)
end
haveKey.Activated:Connect(function() showScreen("key") end)
back.Activated:Connect(function() showScreen("main") end)

local purchaseLink = BASE
local matched
local copySequence = 0
copy.Activated:Connect(function()
    copySequence = copySequence + 1
    local token = copySequence
    local clipboard = setclipboard or toclipboard
    if type(clipboard) == "function" and pcall(clipboard, purchaseLink) then
        copyText.Text = "✓  COPIED!"
        status.Text = "Paste the link into your browser to sign in."
        task.delay(1.5, function()
            if gui.Parent and token == copySequence then copyText.Text = "COPY ACCESS LINK" end
        end)
    else
        linkBox:CaptureFocus()
        pcall(function()
            linkBox.SelectionStart = 1
            linkBox.CursorPosition = #linkBox.Text + 1
        end)
        status.Text = "Select the link above and copy it manually."
    end
end)

local busy = false
submit.Activated:Connect(function()
    if busy or closing then return end
    local key = keyInput.Text:gsub("%s+", "")
    if key == "" then keyStatus.Text = "Paste your game key first." return end
    if not matched then
        keyStatus.Text = "Join a published game before using this key."
        return
    end
    busy = true
    submit.Text = "CHECKING…"
    keyStatus.Text = "Verifying your account and key…"
    task.spawn(function()
        local executor = "Unknown"
        pcall(function()
            if type(identifyexecutor) == "function" then executor = tostring(identifyexecutor()) end
        end)
        local url = BASE .. "/api/loader/" .. HttpService:UrlEncode(tostring(matched.id))
            .. "?key=" .. HttpService:UrlEncode(key)
            .. "&player_id=" .. tostring(player.UserId)
            .. "&universe_id=" .. tostring(game.GameId)
            .. "&place_id=" .. tostring(game.PlaceId)
            .. "&executor=" .. HttpService:UrlEncode(executor)
        local received, body = pcall(function() return game:HttpGet(url) end)
        if not gui.Parent or closing then return end
        if not received then
            keyStatus.Text = "Key check failed. Redeem it on the website first."
        else
            local parsed, errorBody = pcall(function() return HttpService:JSONDecode(body) end)
            if parsed and type(errorBody) == "table" and errorBody.detail then
                keyStatus.Text = tostring(errorBody.detail):sub(1, 105)
            else
                local run, compileError = loadstring(body)
                if run then
                    keyStatus.Text = "Access confirmed. Loading…"
                    finishClose(function()
                        local okay, problem = pcall(run)
                        if not okay then warn("Coco Hub: " .. tostring(problem)) end
                    end)
                    return
                end
                keyStatus.Text = "Script could not load: " .. tostring(compileError):sub(1, 55)
            end
        end
        busy = false
        submit.Text = "SUBMIT KEY"
    end)
end)

-- Only public listings are fetched here. Protected Lua is fetched after key verification.
task.spawn(function()
    local okay, entries = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(BASE .. "/api/scripts"))
    end)
    if not gui.Parent or closing then return end
    if not okay or type(entries) ~= "table" then
        status.Text = "Game list unavailable. You can still copy the link."
        return
    end
    if #entries == 0 then
        status.Text = "No games are published yet. Check back soon."
        return
    end
    if not game:IsLoaded() then game.Loaded:Wait() end
    if not gui.Parent or closing then return end
    for _, entry in ipairs(entries) do
        local universe = tostring(entry.universe_id or "")
        local place = tostring(entry.place_id or "")
        if (universe ~= "" and universe == tostring(game.GameId)) or
            (universe == "" and place ~= "" and place == tostring(game.PlaceId)) then
            matched = entry
            break
        end
    end
    if matched then
        purchaseLink = BASE .. "/?script=" .. HttpService:UrlEncode(tostring(matched.id)) .. "#games"
        linkBox.Text = purchaseLink
        priceLabel.Text = "Pay <b>" .. tostring(tonumber(matched.pass_price) or 150)
            .. " Robux</b> to get access :)"
        status.Text = "Access available for " .. tostring(matched.game_name or matched.name or "this game")
    else
        status.Text = "Choose your game on the buyer page."
    end
end)

-- Initial fade and slight upward motion; the interface remains still afterwards.
main.Position = UDim2.fromOffset(0, 7)
panelScale.Scale = fittedScale * 0.95
glowScale.Scale = fittedScale * 0.95
animate(panel, "fade", 0.35, Enum.EasingStyle.Quad, {GroupTransparency = 0})
animate(panelScale, "size", 0.35, Enum.EasingStyle.Quad, {Scale = fittedScale})
animate(glowScale, "size", 0.35, Enum.EasingStyle.Quad, {Scale = fittedScale})
animate(glowStroke, "fade", 0.35, Enum.EasingStyle.Quad, {Transparency = 0.82})
animate(main, "move", 0.35, Enum.EasingStyle.Quad,
    {Position = UDim2.fromOffset(0, 0)})

local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/pndxvo/scr/main/ui.lua"))()

getgenv().settings = {
    gamespeed = false,
    retry = false,
    retrywavetwo = false,
    next = false,
    retryevent = false,
    notify = false
}

local win = DiscordLib:Window("pndx")
local serv = win:Server("Main", "")
local ntfy = serv:Channel("Auto Farm")

local Players = game:GetService("Players") 
local plr = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")

local bb = game:GetService("VirtualUser")
plr.Idled:connect(function()
    bb:CaptureController()
    bb:ClickButton2(Vector2.new())
end)

ntfy:Toggle("Game Speed 3x", false, function(b)
    settings.gamespeed = b
    task.spawn(function()
        while settings.gamespeed do
            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("SpeedGamepass"):FireServer(3)
            task.wait(2)
        end
        task.wait(0.5)
    end)
end)

ntfy:Toggle("Auto Retry", false, function(b)
    settings.retry = b
    task.spawn(function()
        while settings.retry do
            if playerGui:FindFirstChild("GameEndedAnimationUI") then
                task.wait(1)
                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VoteRetry"):FireServer()
            end
            task.wait(0.5)
        end
    end)
end)

ntfy:Toggle("Auto Retry [FAST]", false, function(b)
    settings.retryevent = b
    task.spawn(function()
        while settings.retryevent do
                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VoteRetry"):FireServer()
            task.wait(0.1)
        end
    end)
end)

ntfy:Toggle("Bug Event", false, function(b)
    settings.retrywavetwo = b
    local remote = game:GetService("ReplicatedStorage").Remote.Server.OnGame.RestartMatch
    local cw = game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Waves"):WaitForChild("CurrentWave")
    task.spawn(function()
        while settings.retrywavetwo do
            if cw.Value == 2 then
                remote:FireServer(r)
                task.wait(2)
            end
            task.wait(0.5)
        end
    end)
end)

ntfy:Toggle("Auto Next", false, function(b)
    settings.next = b
    task.spawn(function()
        while settings.next do
            if playerGui:FindFirstChild("GameEndedAnimationUI") then
                task.wait(2)
                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("Voting"):WaitForChild("VoteNext"):FireServer()
            end
            task.wait(0.5)
        end
    end)
end)

local url = _G.WebhookLink
local headers = {["content-type"] = "application/json"}
local request = http_request or request or HttpPost

local function sendWebhook(ui, x)
    local data = {
        content = nil,
        embeds = {
            {
                title = ("%s"):format(plr.Name),
                color = 65535,
                thumbnail = {url = "https://www.roblox.com/headshot-thumbnail/image?userId=".. game.Players.LocalPlayer.UserId .."&width=420&height=420&format=png"},
                fields = {
                    { 
                        name = "Result", 
                        value = ("%s"):format(ui.Text)
                    },
                    { 
                        name = "Time Total", 
                        value = ("%s"):format(x.Value)
                    }
                },
                timestamp = DateTime.now():ToIsoDate(),
            }
        }
    }

    local newdata = game:GetService("HttpService"):JSONEncode(data)
    local send = {Url = url, Body = newdata, Method = "POST", Headers = headers}
    request(send)
end

ntfy:Toggle("Webhook", false, function(b)
    settings.notify = b
    if settings.notify then
        if not settings._connection then
            settings._connection = playerGui.ChildAdded:Connect(function(child)
                if child.Name == "GameEndedAnimationUI" then
                    task.delay(1.5, function()
                        if settings.notify and child:FindFirstChild("TextAnimation") then
                            local ui = child.TextAnimation:WaitForChild("Label2")
                            local x = game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Game"):WaitForChild("TotalTime")

                            print("[Webhook]", ui.Text, x.Value)
                            sendWebhook(ui, x)
                        end
                    end)
                end
            end)
        end
        print("Webhook notifications ON")
    else
        print("Webhook notifications OFF")
        if settings._connection then
            settings._connection:Disconnect()
            settings._connection = nil
        end
    end
end)

local serv = win:Server("Misc", "http://www.roblox.com/asset/?id=6031075938")

local fps = serv:Channel("Setting")

local gui = Instance.new("ScreenGui")
gui.Name = "DarkModeUI"
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = plr:WaitForChild("PlayerGui")

local blackScreen = Instance.new("Frame")
blackScreen.Size = UDim2.new(1, 0, 1, 0)
blackScreen.Position = UDim2.new(0, 0, 0, 0)
blackScreen.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
blackScreen.BackgroundTransparency = 0
blackScreen.Visible = false
blackScreen.Parent = gui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 300, 0, 100)
textLabel.Position = UDim2.new(0.5, -150, 0.5, -50)
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = false
textLabel.TextSize = 32
textLabel.RichText = true
textLabel.Parent = blackScreen

local gameMode = game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Game"):WaitForChild("Gamemode")
local gameSpeed = game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Game"):WaitForChild("GameSpeed")
local Difficulty = game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Game"):WaitForChild("Difficulty")
local level = game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Game"):WaitForChild("Level")
local autoPlay = game:GetService("ReplicatedStorage"):WaitForChild("Player_Data"):WaitForChild(plr.Name):WaitForChild("Data"):WaitForChild("AutoPlay")

local function updateText()
local autoPlayText = autoPlay.Value and "<font color='#00FF00'><b>Enable</b></font>" or "<font color='#FF0000'><b>Disable</b></font>"

local diff
    if Difficulty.Value == "Normal" then
        diff = "#00FF00"
    elseif Difficulty.Value == "Hard" then
        diff = "#FF0000"
    elseif Difficulty.Value == "Nightmare" then
        diff = "#B700FF"
    else
        diff = "#FFFFFF"
    end
local diffText = "<font color='" .. diff .."'><b>" .. tostring(Difficulty.Value) .. "</b></font>"

local speedColor
    if gameSpeed.Value == 1 then
        speedColor = "#00FF00"
    elseif gameSpeed.Value == 2 then
        speedColor = "#FFFF00"
    elseif gameSpeed.Value == 3 then
        speedColor = "#FF0000"
    else
        speedColor = "#FFFFFF"
    end
local speedText = "<font color='" .. speedColor .."'><b>" .. tostring(gameSpeed.Value) .. "x</b></font>"

textLabel.Text = "<font color='#00FF00'><b>" .. plr.Name .. "</b></font>" ..
                "\nGame Mode <font color='#FFFF00'><b>" .. gameMode.Value .. "</b></font>" ..
                "\nStage <font color='#00EEFF'><b>" .. tostring(level.Value) .. "</b></font> | " .. diffText ..
                "\nGame Speed " .. speedText ..
                "\nAuto Play " .. autoPlayText
end

updateText()

gameMode.Changed:Connect(updateText)
gameSpeed.Changed:Connect(updateText)
autoPlay.Changed:Connect(updateText)
level.Changed:Connect(updateText)

fps:Toggle("Dark Mode", false, function(b)
    blackScreen.Visible = b
end)

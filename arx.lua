local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/pndxvo/scr/main/ui.lua"))()

getgenv().settings = {
    gamespeed = false,
    retry = false,
    next = false,
    notify = false
}

local win = DiscordLib:Window("pndx")
local serv = win:Server("Main", "http://www.roblox.com/asset/?id=6031075938")
local ntfy = serv:Channel("Auto Farm")

local Players = game:GetService("Players") 
local plr = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")

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
                fields = {
                    { 
                        name = "Result", 
                        value = ("%s"):format(ui.Text)
                    },
                    { 
                        name = "Time Total", 
                        value = ("%s วินาที"):format(x.Value)
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

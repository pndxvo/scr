local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/pndxvo/scr/main/ui.lua"))()

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local plot = game:GetService("Workspace"):WaitForChild("Plots"):WaitForChild(plr.Name)

local land = plot:FindFirstChild("Land")
local resources = plot:WaitForChild("Resources")
local expand = plot:WaitForChild("Expand")
local hayList = {"S192", "S199", "S203"}
local FishList = {"252"}

getgenv().settings = {
    farm = false,
    expand = false,
	target = false,
    hive = false,
    fish = false,
    gold = false,
    mine = false,
    harvest = false,
    bale = false,
    buy = false,
	afk = false,
	clover = false,
    sell = false
}

local win = DiscordLib:Window("pndx cheat")
local serv = win:Server("Main", "")

local tgls = serv:Channel("Auto Farm")

tgls:Toggle("Auto Farm Resource", false, function(b)
    settings.farm = b
    task.spawn(function()
		while settings.farm do
			for _, r in ipairs(resources:GetChildren()) do
				game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("HitResource"):FireServer(r)
				task.wait(.01)
			end
			task.wait(.1)
		end
	end)
end)

tgls:Toggle("Auto Expand", false, function(b)
    settings.expand = b
    task.spawn(function()
		while settings.expand do
			for _, exp in ipairs(expand:GetChildren()) do
				local top = exp:FindFirstChild("Top")
				if top then
					local bGui = top:FindFirstChild("BillboardGui")
					if bGui then
						for _, contribute in ipairs(bGui:GetChildren()) do
							if contribute:IsA("Frame") and contribute.Name ~= "Example" then
								local args = {
									exp.Name,
									contribute.Name,
									1
								}
								game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("ContributeToExpand"):FireServer(unpack(args))
							end
						end
					end
				end
				task.wait(.01)
			end
			task.wait(.1)
		end
	end)
end)

tgls:Toggle("Auto Collect Bee", false, function(b)
    settings.hive = b
    task.spawn(function ()
        while settings.hive do
            for _, spot in ipairs(land:GetDescendants()) do
                if spot:IsA("Model") and spot.Name:match("Spot") then
                    game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Hive"):FireServer(spot.Parent.Name, spot.Name, 2)
                end
            end
            task.wait(1)
        end
    end)
end)

tgls:Toggle("Auto Collect Fish", false, function(b)
    settings.fish = b
    task.spawn(function ()
		while settings.fish do
			for _, FISHCRATE in ipairs(FishList) do
    			game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("CollectFishCrateContents"):FireServer(r)
			end
    		task.wait(10)
		end
	end)
end)

tgls:Toggle("Auto Collect Gold", false, function(b)
    settings.gold = b
    task.spawn(function ()
		while settings.gold do
			for _, mine in pairs(land:GetDescendants()) do
				if mine:IsA("Model") and mine.Name == "GoldMineModel" then
					game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Goldmine"):FireServer(mine.Parent.Name, 2)
				end
			end
			task.wait(1)
		end
	end)
end)

tgls:Toggle("Auto Gold Mine", false, function(b)
    settings.mine = b
    task.spawn(function ()
		while settings.mine do
			for _, mine in pairs(land:GetDescendants()) do
				if mine:IsA("Model") and mine.Name == "GoldMineModel" then
					game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Goldmine"):FireServer(mine.Parent.Name, 1)
				end
			end
			task.wait(1)
		end
	end)
end)

tgls:Toggle("Auto Harvest", false, function(b)
    settings.harvest = b
    task.spawn(function ()
		while settings.harvest do
			for _, crop in pairs(plot:FindFirstChild("Plants"):GetChildren()) do
				game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Harvest"):FireServer(crop.Name)
			end
			task.wait(1)
		end
	end)
end)

tgls:Toggle("Auto Add Bale", false, function(b)
    settings.bale = b
    task.spawn(function ()
		while settings.bale do
			for _, AddHay in ipairs(hayList) do
    			game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Animals"):WaitForChild("AddHay"):FireServer(AddHay)
			end
    		task.wait(5)
		end
	end)
end)

tgls:Toggle("Auto Sell", false, function(b)
    settings.sell = b
    task.spawn(function ()
		while settings.sell do
			for _, crop in pairs(plr.Backpack:GetChildren()) do
				if crop:GetAttribute("Sellable") then
					local a = {
						false,
						{
							crop:GetAttribute("Hash")
						}
					}
					game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("SellToMerchant"):FireServer(unpack(a))
				end
			end
			task.wait(1)
		end
	end)
end)

local hp = serv:Channel("Helper")

local selectedTarget = nil

local targetName = hp:Dropdown("Player Name", {"..."}, function(playerName)
    selectedTarget = playerName
end)

local function updatePlayers()
    targetName:Clear() 
    targetName:Add("...")

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= plr then
            targetName:Add(player.Name)
        end
    end
end

updatePlayers()

hp:Button("Refresh", function() 
	updatePlayers()
	selectedTarget = {}
	settings.target = false
end)

hp:Button("Teleport", function()
    local target = Players:FindFirstChild(selectedTarget)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and Players.LocalPlayer.Character then
        Players.LocalPlayer.Character:PivotTo(target.Character.HumanoidRootPart.CFrame)
    end
end)

hp:Toggle("Auto Farm Target", false, function(b)
    settings.target = b
    task.spawn(function()
        while settings.target do
            local targetPlayer = Players:FindFirstChild(selectedTarget)
            if targetPlayer then
                local plots = game:GetService("Workspace"):FindFirstChild("Plots")
                local plot = plots and plots:FindFirstChild(targetPlayer.Name)
                if plot then
                    local targetResources = plot:FindFirstChild("Resources")
                    if targetResources then
                        for _, r in ipairs(targetResources:GetChildren()) do
                            game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("HitResource"):FireServer(r)
                            task.wait(.01)
                        end
                    end
                end
            end
            task.wait(.1)
        end
    end)
end)

local bs = serv:Channel("Auto Buy")

local items = {}
for _, item in ipairs(plr.PlayerGui.Main.Menus.Merchant.Inner.ScrollingFrame.Hold:GetChildren()) do
	if item:IsA("Frame") and item.Name ~= "Example" then
		table.insert(items, item.Name)
	end
end

local item = nil
local additem = {}

local bl = bs:Dropdown("Buy Item List", {}, function(buyitem)
end)

bs:Button("Clear", function()
    bl:Clear()
    additem = {}
end)

bs:Dropdown("Item List", items, function(name)
	item = name
end)

bs:Button("Add", function()
	if item and not table.find(additem, item) then
		bl:Add(item)
		table.insert(additem, item)
    else
        DiscordLib:Notification("⚠️", item.." Already added", "Accept")
	end
end)

bs:Toggle("Auto Buy Item", false, function (b)
	settings.buy = b
	task.spawn(function ()
		while settings.buy do
			for _, i in ipairs(additem) do
				local a = {i, false}
				game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("BuyFromMerchant"):FireServer(unpack(a))
			end
			task.wait(0.25)
		end
	end)
end)

bs:Seperator()

local timerUI = bs:Label("Loading...")

local timer = plr.PlayerGui:WaitForChild("Main"):WaitForChild("Menus"):WaitForChild("Merchant"):WaitForChild("Inner"):WaitForChild("Timer")

game:GetService("RunService").RenderStepped:Connect(function()
    if timer and timerUI then
        timerUI.Text = timer.Text
    end
end)

local evt = serv:Channel("Event")

evt:Toggle("Three Clover Leaf", false, function(b)
    settings.event = b
	task.spawn(function()
		local cl = game:GetService("Workspace"):FindFirstChild("RainbowIsland"):FindFirstChild("Resources")
		while b do
			for _, r in ipairs(cl:GetChildren()) do
				game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("HitResource"):FireServer(r)
				task.wait(0.01)
			end
			task.wait(0.1)
		end
	end)
end)

local ply = serv:Channel("Player")
local character = plr.Character or plr.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local spd = ply:Slider("Slide me!", 0, 200, 16, function(t)
    humanoid.WalkSpeed = t
end)

ply:Button("Speed to Default", function()
    if spd.Change then
        spd:Change(16)
    elseif spd.SetValue then
        spd:SetValue(16)
    end
    humanoid.WalkSpeed = 16
end)

ply:Button("Anti AFK", function ()
	local bb = game:GetService("VirtualUser")
	plr.Idled:connect(function()
		bb:CaptureController()
		bb:ClickButton2(Vector2.new())
	end)
	DiscordLib:Notification("⚠️", "Anti Afk enabled", "Accept")
end)

win:Server("Misc", "http://www.roblox.com/asset/?id=6031075938")

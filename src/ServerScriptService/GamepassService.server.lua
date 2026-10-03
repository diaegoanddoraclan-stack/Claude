-- Checks ownership on join and on in-game purchase, then applies perks.
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Gamepasses = require(ReplicatedStorage:WaitForChild("GamepassConfig"))
local toolFolder = ServerStorage:FindFirstChild("GamepassTools") -- put weapon Tools here, named per config

local function ownsPass(player, id)
	if id == 0 then return false end
	local ok, owns = pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, player.UserId, id)
	return ok and owns
end

local function giveTool(player, toolName)
	if not toolFolder then return end
	local template = toolFolder:FindFirstChild(toolName)
	if not template then return end
	for _, container in { player:FindFirstChild("Backpack"), player:FindFirstChild("StarterGear") } do
		if container and not container:FindFirstChild(toolName) then
			template:Clone().Parent = container
		end
	end
end

local function applySpeed(player, character)
	local humanoid = character:WaitForChild("Humanoid")
	local mult = player:GetAttribute("WalkSpeedMultiplier") or 1
	humanoid.WalkSpeed = 16 * mult
end

local function applyPass(player, key, pass)
	-- Attribute names can't contain spaces, so use the config key (e.g. "Owns_DoubleMoney")
	player:SetAttribute("Owns_" .. key, true)
	for key, value in pass.attributes or {} do
		-- Stackable bonuses add together (e.g. VIP + Pet Slots = +4)
		if string.sub(key, 1, 5) == "Bonus" then
			player:SetAttribute(key, (player:GetAttribute(key) or 0) + value)
		else
			player:SetAttribute(key, value)
		end
	end
	if pass.tool then giveTool(player, pass.tool) end
	if pass.walkSpeedMultiplier then
		player:SetAttribute("WalkSpeedMultiplier", pass.walkSpeedMultiplier)
		if player.Character then applySpeed(player, player.Character) end
	end
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character) applySpeed(player, character) end)
	for key, pass in Gamepasses do
		-- Check passes in parallel so one slow request doesn't delay the rest
		task.spawn(function()
			if ownsPass(player, pass.id) and not player:GetAttribute("Owns_" .. key) then
				applyPass(player, key, pass)
			end
		end)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in Players:GetPlayers() do
	task.spawn(onPlayerAdded, player) -- players who joined before this script ran
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, purchased)
	if not purchased then return end
	for key, pass in Gamepasses do
		if pass.id == passId and not player:GetAttribute("Owns_" .. key) then
			applyPass(player, key, pass)
		end
	end
end)

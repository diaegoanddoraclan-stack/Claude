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

local function applyPass(player, pass)
	player:SetAttribute("Owns_" .. pass.name, true)
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

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character) applySpeed(player, character) end)
	for _, pass in Gamepasses do
		if ownsPass(player, pass.id) then applyPass(player, pass) end
	end
end)

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, purchased)
	if not purchased then return end
	for _, pass in Gamepasses do
		if pass.id == passId and not player:GetAttribute("Owns_" .. pass.name) then
			applyPass(player, pass)
		end
	end
end)

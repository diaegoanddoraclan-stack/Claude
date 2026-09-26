-- Gamepass definitions. Create each pass on create.roblox.com, then paste its ID into `id`.
-- Perks are applied as player attributes so other game systems can read them.
return {
	RemoteLock    = { id = 0, price = 149, name = "Remote Lock",     attributes = { CanRemoteLock = true } },
	DoubleMoney   = { id = 0, price = 399, name = "2x Money",        attributes = { SellMultiplier = 2 } },
	VIP           = { id = 0, price = 299, name = "VIP",             attributes = { BonusPetSlots = 2, DailyRewardMultiplier = 2, GoldTag = true } },
	RainbowSlapper= { id = 0, price = 249, name = "Rainbow Slapper", tool = "RainbowSlapper" },
	NukeHammer    = { id = 0, price = 499, name = "Nuke Hammer",     tool = "NukeHammer" },
	AdminFreezeGun= { id = 0, price = 699, name = "Admin Freeze Gun",tool = "AdminFreezeGun" },
	FastGrow      = { id = 0, price = 349, name = "Fast Grow",       attributes = { GrowSpeedMultiplier = 1.5 } },
	LuckyGrower   = { id = 0, price = 299, name = "Lucky Grower",    attributes = { MutationChanceMultiplier = 2 } },
	ExtraSoil     = { id = 0, price = 249, name = "Extra Soil",      attributes = { BonusSoilSpots = 3 } },
	PetSlots      = { id = 0, price = 199, name = "+2 Pet Slots",    attributes = { BonusPetSlots = 2 } }, -- stacks with VIP
	SpeedCoil     = { id = 0, price = 149, name = "Speed Coil",      walkSpeedMultiplier = 1.5 },
	ThiefBoots    = { id = 0, price = 199, name = "Thief Boots",     attributes = { CarryingSpeedMultiplier = 1.5 } },
	AutoHarvest   = { id = 0, price = 449, name = "Auto Harvest",    attributes = { AutoHarvestInterval = 10 } },
	LongLock      = { id = 0, price = 99,  name = "Long Lock",       attributes = { BonusLockSeconds = 60 } },
	BigBackpack   = { id = 0, price = 99,  name = "Big Backpack",    attributes = { PetCapacity = 120 } }, -- default 60
}

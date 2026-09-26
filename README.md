# Roblox Grow Game – Gamepasses

1. Create each pass on create.roblox.com (prices in `src/ReplicatedStorage/GamepassConfig.lua`) and paste the IDs into that file.
2. Put `GamepassConfig` in ReplicatedStorage and `GamepassService` in ServerScriptService.
3. Put weapon Tools (`RainbowSlapper`, `NukeHammer`, `AdminFreezeGun`) in `ServerStorage/GamepassTools`.
4. Game systems read player attributes, e.g. `player:GetAttribute("SellMultiplier") or 1`.

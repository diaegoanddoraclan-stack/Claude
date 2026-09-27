-- Generates a large city-grid map with roads, sidewalks, lane markings and blocks.
local GRID = 24 -- blocks per side (~5800 studs across)
local BLOCK = 200 -- block size (studs)
local ROAD = 40 -- road width
local SIDEWALK = 6
local CELL = BLOCK + ROAD
local SIZE = GRID * CELL + ROAD

local map = Instance.new("Folder")
map.Name = "GeneratedMap"
map.Parent = workspace

local function part(name, size, pos, color, material, parent)
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.Size = size
	p.Position = pos
	p.Color = color
	p.Material = material
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local half = SIZE / 2
local roads = Instance.new("Folder", map); roads.Name = "Roads"
local blocks = Instance.new("Folder", map); blocks.Name = "Blocks"

-- Base ground
part("Ground", Vector3.new(SIZE + 400, 4, SIZE + 400), Vector3.new(0, -2, 0),
	Color3.fromRGB(86, 140, 70), Enum.Material.Grass, map)

-- Roads + dashed center lines
for i = 0, GRID do
	local offset = -half + ROAD / 2 + i * CELL
	part("RoadX" .. i, Vector3.new(SIZE, 1, ROAD), Vector3.new(0, 0.5, offset),
		Color3.fromRGB(45, 45, 48), Enum.Material.Asphalt, roads)
	part("RoadZ" .. i, Vector3.new(ROAD, 1, SIZE), Vector3.new(offset, 0.5, 0),
		Color3.fromRGB(45, 45, 48), Enum.Material.Asphalt, roads)
	for d = -half + 10, half - 10, 30 do
		part("Dash", Vector3.new(12, 0.1, 1), Vector3.new(d, 1.05, offset),
			Color3.fromRGB(240, 200, 40), Enum.Material.SmoothPlastic, roads).CanCollide = false
		part("Dash", Vector3.new(1, 0.1, 12), Vector3.new(offset, 1.05, d),
			Color3.fromRGB(240, 200, 40), Enum.Material.SmoothPlastic, roads).CanCollide = false
	end
end

-- City blocks with sidewalks, grass lots and random buildings
local rng = Random.new(42)
for x = 0, GRID - 1 do
	for z = 0, GRID - 1 do
		local cx = -half + ROAD + BLOCK / 2 + x * CELL
		local cz = -half + ROAD + BLOCK / 2 + z * CELL
		local blk = Instance.new("Model", blocks); blk.Name = ("Block_%d_%d"):format(x, z)
		part("Sidewalk", Vector3.new(BLOCK, 1.5, BLOCK), Vector3.new(cx, 0.75, cz),
			Color3.fromRGB(170, 170, 170), Enum.Material.Concrete, blk)
		local inner = BLOCK - SIDEWALK * 2
		part("Lot", Vector3.new(inner, 1.6, inner), Vector3.new(cx, 0.8, cz),
			Color3.fromRGB(100, 160, 80), Enum.Material.Grass, blk)
		if rng:NextNumber() < 0.7 then
			local h = rng:NextInteger(30, 180)
			local w = rng:NextInteger(60, inner - 20)
			part("Building", Vector3.new(w, h, w), Vector3.new(cx, 1.6 + h / 2, cz),
				Color3.fromHSV(rng:NextNumber(), 0.15, rng:NextNumber(0.5, 0.9)),
				Enum.Material.Concrete, blk)
		end
	end
end

local spawn = Instance.new("SpawnLocation")
spawn.Anchored = true
spawn.Size = Vector3.new(12, 1, 12)
spawn.Position = Vector3.new(-half + ROAD / 2, 1.5, -half + ROAD / 2)
spawn.Parent = map

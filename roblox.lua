-- Method to discover actual UGC names in ServerAssets
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerAssets = require(ReplicatedStorage.SharedModules.ServerAssets)

-- Function to brute force common UGC names
local function findUGCNames()
    local foundUGC = {}
    
    -- Extended list of potential UGC names
    local potentialNames = {
        -- Hats and headwear
        "Crown", "Hat", "Cap", "Helmet", "Headband", "Beanie", "TopHat", "Fedora",
        "Crown1", "Crown2", "Crown3", "Hat1", "Hat2", "Hat3", "Hat4", "Hat5",
        
        -- Accessories  
        "Glasses", "Sunglasses", "Mask", "Bandana", "Scarf", "Necklace", "Earrings",
        "Accessory", "Accessory1", "Accessory2", "Accessory3", "Accessory4", "Accessory5",
        
        -- Awards and trophies
        "Trophy", "Medal", "Badge", "Award", "Prize", "Cup", "Ribbon",
        "Trophy1", "Trophy2", "Trophy3", "GoldTrophy", "SilverTrophy", "BronzeTrophy",
        
        -- Tools and weapons
        "Sword", "Axe", "Hammer", "Staff", "Wand", "Tool", "Weapon",
        "Sword1", "Sword2", "Blade", "Katana", "Dagger",
        
        -- Clothing
        "Shirt", "Pants", "Jacket", "Coat", "Dress", "Uniform", "Armor",
        "Cape", "Cloak", "Robe", "Vest", "Hoodie",
        
        -- Pets and companions
        "Pet", "Companion", "Animal", "Dog", "Cat", "Bird", "Dragon",
        "Pet1", "Pet2", "Pet3", "Familiar",
        
        -- Special items
        "Key", "Orb", "Crystal", "Gem", "Ring", "Amulet", "Charm",
        "Special", "Rare", "Epic", "Legendary", "Unique",
        
        -- Numbered items
        "Item1", "Item2", "Item3", "Item4", "Item5", "Item6", "Item7", "Item8", "Item9", "Item10",
        "UGC1", "UGC2", "UGC3", "UGC4", "UGC5",
        
        -- Game specific (modify based on the game you're in)
        "FinaleItem", "EventItem", "SeasonItem", "LimitedItem",
        "Champion", "Winner", "Victor", "Hero"
    }
    
    print("Searching for UGC items...")
    print("Found items:")
    print("=" .. string.rep("=", 50))
    
    for _, name in pairs(potentialNames) do
        local success, result = pcall(function()
            return ServerAssets.request("UGC", name)
        end)
        
        if success and result then
            foundUGC[name] = result
            print("✓ " .. name .. " - Found!")
            
            -- Try to get more info about the item
            if result:FindFirstChildWhichIsA("BasePart") then
                local part = result:FindFirstChildWhichIsA("BasePart")
                print("  └─ Has BasePart: " .. part.Name)
                if part.MeshId and part.MeshId ~= "" then
                    print("  └─ MeshId: " .. tostring(part.MeshId))
                end
                if part.TextureId and part.TextureId ~= "" then
                    print("  └─ TextureId: " .. tostring(part.TextureId))
                end
            end
        else
            -- Uncomment this if you want to see failed attempts
            -- print("✗ " .. name .. " - Not found")
        end
        
        -- Small delay to prevent overwhelming the server
        task.wait(0.1)
    end
    
    print("=" .. string.rep("=", 50))
    print("Search complete! Found " .. #foundUGC .. " UGC items.")
    
    return foundUGC
end

-- Function to try different category names (not just UGC)
local function exploreCategories()
    local categories = {
        "UGC", "Assets", "Items", "Accessories", "Hats", "Tools", 
        "Weapons", "Clothing", "Pets", "Trophies", "Badges", "Special",
        "Models", "Parts", "Objects", "Collectibles"
    }
    
    print("\nExploring different categories...")
    
    for _, category in pairs(categories) do
        print("\nTrying category: " .. category)
        
        -- Try some common item names in each category
        local testItems = {"Item1", "Test", "Default", "Basic", "Standard"}
        
        for _, item in pairs(testItems) do
            local success, result = pcall(function()
                return ServerAssets.request(category, item)
            end)
            
            if success and result then
                print("  ✓ Found: " .. category .. "/" .. item)
            end
        end
    end
end

-- Execute the search
local foundUGC = findUGCNames()

-- Also explore other categories
exploreCategories()

-- Create a summary
print("\n" .. string.rep("=", 60))
print("SUMMARY - Found UGC Items:")
for name, item in pairs(foundUGC) do
    print("- " .. name)
end
print(string.rep("=", 60))


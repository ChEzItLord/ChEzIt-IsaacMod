local mod = RegisterMod("Random Items", 1)
local luckPotion = Isaac.GetItemIdByName("Luck Potion")
local luckPotionLuck = 20

local chaosBottled = Isaac.GetItemIdByName("Chaos Bottled")
local currentRoom = nil
local currentEffect = nil

-- Define the 10 random tear effects
local randomTearEffects = {
    TearFlags.TEAR_HOMING,
    TearFlags.TEAR_SPECTRAL,
    TearFlags.TEAR_PIERCING,
    TearFlags.TEAR_SPLIT,
    TearFlags.TEAR_EXPLOSIVE,
    TearFlags.TEAR_CHARM,
    TearFlags.TEAR_CONFUSION,
    TearFlags.TEAR_SLOW,
    TearFlags.TEAR_POISON,
    TearFlags.TEAR_FEAR,
    TearFlags.TEAR_SHRINK,
    TearFlags.TEAR_BURN,
}

function mod:EvaluateCache(player, cacheFlags)
    if cacheFlags & CacheFlag.CACHE_LUCK == CacheFlag.CACHE_LUCK then
        local itemCount = player:GetCollectibleNum(luckPotion)
        local luckToAdd = luckPotionLuck * itemCount
        player.Luck = player.Luck + luckToAdd
    end

    if player:HasTrinket(chaosBottled) then
        -- Store the current room and effect if they are not already stored
        if currentRoom == nil or currentRoom ~= Game():GetLevel():GetCurrentRoomIndex() then
            currentRoom = Game():GetLevel():GetCurrentRoomIndex()
            currentEffect = randomTearEffects[math.random(#randomTearEffects)]
        end

        -- Apply the current effect to the player's tears
        if cacheFlags & CacheFlag.CACHE_TEARFLAG ~= 0 then
            player.TearFlags = player.TearFlags | currentEffect
        end
    else
        -- Clear the stored room and effect when the trinket is not held
        currentRoom = nil
        currentEffect = nil
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)

local throatToggle = Isaac.GetItemIdByName("Throat Toggle")

function mod:ThroatToggleUse()
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()

    -- Use the "Gulp!" pill effect directly
    player:UsePill(PillEffect.PILLEFFECT_GULP, PillColor.PILL_BLUE_BLUE, UseFlag.USE_NOANIM)

    -- Play the "Swallow" sound effect
    SFXManager():Play(SoundEffect.SOUND_PILL_SPIDERBITE, 1, 0, false, 1)

    -- Update the HUD display
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.ThroatToggleUse, throatToggle)

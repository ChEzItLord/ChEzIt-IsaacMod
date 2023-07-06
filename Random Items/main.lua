local mod = RegisterMod("Random Items", 1)
local luckPotion = Isaac.GetItemIdByName("Luck Potion")
local luckPotionLuck = 20

function mod:EvaluateCache(player, cacheFlags)
    if cacheFlags & CacheFlag.CACHE_LUCK == CacheFlag.CACHE_LUCK then
        local itemCount = player:GetCollectibleNum(luckPotion)
        local luckToAdd = luckPotionLuck * itemCount
        player.Luck = player.Luck + luckToAdd
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
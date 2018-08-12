local Class = require 'modules.hump.class'
local Signal = require 'modules.hump.signal'
local ItemDrop = require 'src.objects.ItemDrop'

local ItemDrops = Class.new()

function ItemDrops:init()
    Signal.register('drop', function(type, x, y) self:addDrop(type, x, y) end)
    Signal.register('new_enemies', function() self:clear() end)
    self.drops = {}
end

function ItemDrops:update(dt)
    for i, drop in ipairs(self.drops) do
        if drop:isDead() then
            table.remove(self.drops, i)
        else
            local x = 320 + -200 + 400 * i / (#self.drops + 1)
            local y = 384
            drop:moveTowards(x, y)
        end
    end
end

function ItemDrops:mousepressed(x, y)
    for _, drop in ipairs(self.drops) do
        if drop:mousepressed(x, y) then return true end
    end
    return false
end

function ItemDrops:draw()
    for i, drop in ipairs(self.drops) do
        drop:draw()
    end
end

function ItemDrops:addDrop(type, x, y)
    table.insert(self.drops, ItemDrop(type, x, y))
end

function ItemDrops:isEmpty()
    return #self.drops == 0
end

function ItemDrops:clear()
    self.drops = {}
end

return ItemDrops

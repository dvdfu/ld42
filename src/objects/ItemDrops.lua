local Class = require 'modules.hump.class'

local ItemDrops = Class.new()

function ItemDrops:init(types)
    self.items = types
end

function ItemDrops:draw()
end

return ItemDrops

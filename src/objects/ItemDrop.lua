local Class = require 'modules.hump.class'
local HitBox = require 'src.objects.HitBox'
local Items = require 'src.Items'

local ItemDrop = Class.new()
ItemDrop:include(HitBox)

local CHAR_SPEED = 0.02
local WIDTH = 500
local HEIGHT = 100
local PADDING = 10

function ItemDrop:init(type, x, y)
    local item = Items[type]
    HitBox.init(self, x, y, item.width, item.height)
    self.item = item
    self.type = type
end

function ItemDrop:draw()
    love.graphics.draw(self.item.sprite,
        self.pos.x,
        self.pos.y,
        0, 1, 1,
        self.size.x / 2,
        self.size.y / 2)
    HitBox.draw(self)
end

function ItemDrop:getType()
    return self.type
end

return ItemDrop

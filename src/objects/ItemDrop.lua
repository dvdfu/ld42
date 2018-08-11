local Class = require 'modules.hump.class'
local Constants = require 'src.data.Constants'
local Items = require 'src.data.Items'
local Selection = require 'src.Selection'
local HitBox = require 'src.objects.HitBox'

local ItemDrop = Class.new()
ItemDrop:include(HitBox)

function ItemDrop:init(type, x, y)
    local item = Items[type]
    HitBox.init(self, x, y,
        item.width * Constants.CELL_SIZE,
        item.height * Constants.CELL_SIZE)
    self.item = item
    self.type = type
    self.selected = false
    self.dead = false
end

function ItemDrop:mousepressed(x, y)
    if not self:containsPoint(x, y) then return false end
    self.selected = true
    Selection:set(self.type, function(used)
        if used then
            self.dead = true
        else
            self.selected = false
        end
    end)
    return true
end

function ItemDrop:draw()
    if not self.selected then
        love.graphics.draw(self.item.sprite, self.pos.x, self.pos.y)
    end
end

function ItemDrop:isDead()
    return self.dead
end

function ItemDrop:getType()
    return self.type
end

return ItemDrop

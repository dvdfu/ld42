local Class = require 'modules.hump.class'
local Constants = require 'src.Constants'
local Selection = require 'src.Selection'
local Sprites = require 'src.Sprites'
local HitBox = require 'src.objects.HitBox'

local Trash = Class.new()
Trash:include(HitBox)

function Trash:init(x, y)
    HitBox.init(self, x, y, Constants.CELL_SIZE, Constants.CELL_SIZE)
end

function Trash:receiveItem(type, x, y)
    return self:containsPoint(x, y)
end

function Trash:draw()
    if Selection:get() and self:containsPoint(love.mouse.getPosition()) then
        love.graphics.draw(Sprites.TRASH_OPEN, self.pos.x, self.pos.y)
    else
        love.graphics.draw(Sprites.TRASH, self.pos.x, self.pos.y)
    end
end

return Trash

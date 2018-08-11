local Class = require 'modules.hump.class'
local Constants = require 'src.Constants'
local Selection = require 'src.Selection'
local HitBox = require 'src.objects.HitBox'

local Trash = Class.new()
Trash:include(HitBox)

local TRASH = love.graphics.newImage('assets/trash.png')
local TRASH_OPEN = love.graphics.newImage('assets/trash_open.png')

function Trash:init(x, y)
    HitBox.init(self, x, y, Constants.CELL_SIZE, Constants.CELL_SIZE)
end

function Trash:receiveItem(type, x, y)
    return self:containsPoint(x, y)
end

function Trash:draw()
    if Selection:get() and self:containsPoint(love.mouse.getPosition()) then
        love.graphics.draw(TRASH_OPEN, self.pos.x, self.pos.y)
    else
        love.graphics.draw(TRASH, self.pos.x, self.pos.y)
    end
end

return Trash

local Class = require 'modules.hump.class'
local Vector = require 'modules.hump.vector'

local HitBox = Class.new()

function HitBox:init(x, y, w, h)
    self.pos = Vector(x, y)
    self.size = Vector(w, h)
end

function HitBox:mousepressed(x, y) end

function HitBox:mousereleased(x, y) end

function HitBox:draw()
    if self:containsPoint(love.mouse.getPosition()) then
        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.rectangle('fill',
            self.pos.x,
            self.pos.y,
            self.size.x,
            self.size.y)
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.rectangle('line',
            self.pos.x,
            self.pos.y,
            self.size.x,
            self.size.y)
    end
end

function HitBox:containsPoint(x, y)
    if x < self.pos.x then return false end
    if y < self.pos.y then return false end
    if x > self.pos.x + self.size.x then return false end
    if y > self.pos.y + self.size.y then return false end
    return true
end

function HitBox:overlaps(other)
    if self.pos.x > other.pos.x + other.size.x or
        self.pos.x + self.size.x < other.pos.x or
        self.pos.y > other.pos.y + other.size.y or
        self.pos.y + self.size.y < other.pos.y then
        return false end
    return true
end

return HitBox

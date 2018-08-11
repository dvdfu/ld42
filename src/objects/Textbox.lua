local Class = require 'modules.hump.class'
local HitBox = require 'src.objects.HitBox'

local TextBox = Class.new()
TextBox:include(HitBox)

local CHAR_SPEED = 0.02
local WIDTH = 500
local HEIGHT = 100
local PADDING = 10

function TextBox:init(text, x, y)
    HitBox.init(self, x, y, WIDTH, HEIGHT)
    self:setText(text or '')
end

function TextBox:update(dt)
    if self:isWriting() then
        self.time = self.time + dt
    end

    while self.time > CHAR_SPEED do
        self.time = self.time - CHAR_SPEED
        if self:isWriting() then
            self.char = self.char + 1
            break
        end
    end
end

function TextBox:draw(x, y)
    love.graphics.push()
    love.graphics.translate(self.pos.x, self.pos.y)

    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle('fill', 0, 0, WIDTH, HEIGHT)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(
        string.sub(self.text, 0, self.char),
        PADDING,
        PADDING,
        WIDTH - PADDING * 2,
        'left')

    love.graphics.pop()

    HitBox.draw(self)
end

function TextBox:setText(text)
    self.text = text
    self.char = 0
    self.time = 0
end

function TextBox:skip()
    self.char = string.len(self.text)
end

function TextBox:isWriting()
    return self.char < string.len(self.text)
end

return TextBox

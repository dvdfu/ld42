local Class = require 'modules.hump.class'

local Textbox = Class.new()

local CHAR_SPEED = 0.02
local WIDTH = 200
local HEIGHT = 100
local PADDING = 10

function Textbox:init(text)
    self:setText(text or '')
end

function Textbox:update(dt)
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

function Textbox:draw(x, y)
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle('fill', x, y, WIDTH, HEIGHT)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(
        string.sub(self.text, 0, self.char),
        x + PADDING,
        y + PADDING,
        WIDTH - PADDING * 2,
        'left')
end

function Textbox:setText(text)
    self.text = text
    self.char = 0
    self.time = 0
end

function Textbox:skip()
    self.char = string.len(self.text)
end

function Textbox:isWriting()
    return self.char < string.len(self.text)
end

return Textbox

local Class = require 'modules.hump.class'
local Signal = require 'modules.hump.signal'
local Fonts = require 'src.data.Fonts'
local Sprites = require 'src.data.Sprites'
local HitBox = require 'src.objects.HitBox'

local TextBox = Class.new()
TextBox:include(HitBox)

local CHAR_SPEED = 0.005
local PADDING = 34

function TextBox:init(x, y, w, h)
    HitBox.init(self, x, y, w, h)
    self.queue = {}
    self.blank = true
    self.text = nil
    self.char = 0
    self.time = 0
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

function TextBox:tap()
    if self:isWriting() then
        self:skip()
    elseif self:isTextQueued() then
        local text = table.remove(self.queue, 1)
        self:setText(text)
    elseif not self.blank then
        self.blank = true
        Signal.emit('text_end')
    end
    return true
end

function TextBox:draw()
    if self.blank then return end

    love.graphics.push()
    love.graphics.translate(self.pos.x, self.pos.y)

    love.graphics.draw(Sprites.TEXT_PANEL)
    love.graphics.setFont(Fonts.RENNER_20)
    love.graphics.printf(
        string.sub(self.text, 0, self.char),
        PADDING,
        PADDING,
        self.size.x - PADDING * 2,
        'left')

    if not self:isWriting() then
        love.graphics.draw(Sprites.TEXT_DOT,
            self.size.x - 30,
            self.size.y - 30,
            0, 1, 1, 8, 8)
    end

    love.graphics.pop()
end

function TextBox:queueText(text)
    if self.blank then
        self:setText(text)
    else
        table.insert(self.queue, text)
    end
end

function TextBox:setText(text)
    self.blank = false
    self.text = text
    self.char = 0
    self.time = 0
end

function TextBox:skip()
    self.char = string.len(self.text)
end

function TextBox:isWriting()
    if self.blank then return false end
    return self.char < string.len(self.text)
end

function TextBox:isTextQueued()
    return #self.queue > 0
end

return TextBox

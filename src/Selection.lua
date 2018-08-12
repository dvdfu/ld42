local Signal = require 'modules.hump.signal'
local Timer = require 'modules.hump.timer'
local Constants = require 'src.data.Constants'
local Items = require 'src.data.Items'

local Selection = {}

local NO_CALLBACK = function(used) end

function Selection:init()
    self.type = nil
    self.callback = NO_CALLBACK
    self.squishTimer = Timer.new()
    self.squish = 1
end

function Selection:update(dt)
    self.squishTimer:update(dt)
end

function Selection:draw()
    if self.type then
        local item = Items[self.type]
        local ox, oy =
            item.width * Constants.CELL_SIZE / 2,
            item.height * Constants.CELL_SIZE / 2
        local x, y = love.mouse.getX(), love.mouse.getY()
        love.graphics.setColor(0, 0, 0)
        for i = 1, 8 do
            local dx = math.cos(i / 8 * math.pi * 2) * 4;
            local dy = math.sin(i / 8 * math.pi * 2) * 4;
            love.graphics.draw(item.sprite, x + dx, y + dy, 0, 1, 1, ox, oy)
        end
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(item.sprite, x, y, 0,
            self.squish, self.squish, ox, oy)
    end
end

function Selection:set(type, callback)
    self.type = type
    self.callback = callback or NO_CALLBACK
    self.squish = 1.5
    self.squishTimer:tween(0.4, self, { squish = 1 }, 'out-elastic')
    Signal.emit('text', Items[self.type].description)
end

function Selection:take()
    self.type = nil
    self.callback(true)
    self.callback = NO_CALLBACK
end

function Selection:reset()
    self.type = nil
    self.callback(false)
    self.callback = NO_CALLBACK
end

function Selection:get()
    return self.type
end

return Selection

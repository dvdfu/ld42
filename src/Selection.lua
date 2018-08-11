local Signal = require 'modules.hump.signal'
local Constants = require 'src.data.Constants'
local Items = require 'src.data.Items'

local Selection = {}

local NO_CALLBACK = function(used) end

function Selection:init()
    self.type = nil
    self.callback = NO_CALLBACK
end

function Selection:draw()
    if self.type then
        local item = Items[self.type]
        local x, y =
            love.mouse.getX() - item.width * Constants.CELL_SIZE / 2,
            love.mouse.getY() - item.height * Constants.CELL_SIZE / 2
        love.graphics.setColor(0, 0, 0)
        for i = 1, 8 do
            local dx = math.cos(i / 8 * math.pi * 2) * 4;
            local dy = math.sin(i / 8 * math.pi * 2) * 4;
            love.graphics.draw(item.sprite, x + dx, y + dy)
        end
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(item.sprite, x, y)
    end
end

function Selection:set(type, callback)
    self.type = type
    self.callback = callback or NO_CALLBACK
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

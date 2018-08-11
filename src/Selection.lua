local Constants = require 'src.Constants'
local Items = require 'src.Items'

local Selection = {}

local NO_CALLBACK = function(used) end

function Selection:init()
    self.type = nil
    self.callback = NO_CALLBACK
end

function Selection:draw()
    if self.type then
        local item = Items[self.type]
        love.graphics.draw(item.sprite,
            love.mouse.getX() - item.width * Constants.CELL_SIZE / 2,
            love.mouse.getY() - item.height * Constants.CELL_SIZE / 2)
    end
end

function Selection:set(type, callback)
    self.type = type
    self.callback = callback or NO_CALLBACK
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

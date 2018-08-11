local Constants = require 'src.Constants'
local Items = require 'src.Items'

local Selection = {}

function Selection:init()
    self.selection = nil
end

function Selection:draw()
    if self.selection then
        local item = Items[self.selection.type]
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.draw(item.sprite,
            love.mouse.getX() - item.width * Constants.CELL_SIZE / 2,
            love.mouse.getY() - item.height * Constants.CELL_SIZE / 2)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Selection:set(selection)
    self.selection = selection
end

function Selection:get()
    return self.selection
end

function Selection:clear()
    self.selection = nil
end

return Selection

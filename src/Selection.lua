local Items = require 'src.Items'

local Selection = {}

local CELL_SIZE = 64

function Selection:init()
    self.selection = nil
end

function Selection:draw()
    if self.selection then
        local item = Items[self.selection.type]
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.draw(item.sprite,
            love.mouse.getX() - item.width * CELL_SIZE / 2,
            love.mouse.getY() - item.height * CELL_SIZE / 2)
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

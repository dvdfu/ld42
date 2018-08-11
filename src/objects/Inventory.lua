local Class = require 'modules.hump.class'
local Items = require 'src.Items'
local HitBox = require 'src.objects.HitBox'

local Inventory = Class.new()
Inventory:include(HitBox)

local WIDTH = 4
local HEIGHT = 4
local CELL_SIZE = 64

function Inventory:init(x, y)
    HitBox.init(self, x, y, WIDTH * CELL_SIZE, HEIGHT * CELL_SIZE)
    self.items = {
        {
            type = 'HEART',
            x = 1,
            y = 0,
        },
        {
            type = 'SWORD',
            x = 3,
            y = 1,
        },
        {
            type = 'KNIFE',
            x = 1,
            y = 1,
        },
        {
            type = 'PENDANT',
            x = 2,
            y = 0,
        },
    }
end

function Inventory:draw()
    love.graphics.push()
    love.graphics.translate(self.pos.x, self.pos.y)

    -- draw the grid
    love.graphics.setColor(0.3, 0.3, 0.3)
    for i = 0, WIDTH - 1 do
        for j = 0, HEIGHT - 1 do
            love.graphics.rectangle('line',
                i * CELL_SIZE,
                j * CELL_SIZE,
                CELL_SIZE,
                CELL_SIZE)
        end
    end
    love.graphics.setColor(1, 1, 1)

    -- draw the items
    for i = 1, #self.items do
        local item = self.items[i]
        local sprite = Items[item.type].sprite
        love.graphics.draw(sprite,
            item.x * CELL_SIZE,
            item.y * CELL_SIZE
        )
    end

    love.graphics.pop()

    HitBox.draw(self)
end

function Inventory:checkItemFits(item, x, y)
    local board = {}
    for i = 0, WIDTH - 1 do
        board[i] = {}
    end
    for _, item in ipairs(self.items) do
        local data = Items[item.type]
        for i = item.x, item.x + data.width - 1 do
            for j = item.y, item.y + data.height - 1 do
                board[i][j] = true
            end
        end
    end

    for i = x, x + item.width - 1 do
        for j = y, y + item.height - 1 do
            if board[i][j] then return false end
        end
    end

    return true
end

function Inventory:getItemAt(x, y)
    for _, item in ipairs(self.items) do
        local data = Items[item.type]
        for i = item.x, item.x + data.width - 1 do
            for j = item.y, item.y + data.height - 1 do
                if i == x and j == y then return item end
            end
        end
    end
    return nil
end

return Inventory

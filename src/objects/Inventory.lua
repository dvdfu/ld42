local Class = require 'modules.hump.class'
local Items = require 'src.Items'
local Selection = require 'src.Selection'
local HitBox = require 'src.objects.HitBox'

local Inventory = Class.new()
Inventory:include(HitBox)

local WIDTH = 4
local HEIGHT = 4
local CELL_SIZE = 64

function Inventory:init(x, y)
    HitBox.init(self, x, y, WIDTH * CELL_SIZE, HEIGHT * CELL_SIZE)
    self.items = {}
end

function Inventory:mousepressed(x, y)
    local cx, cy =
        math.floor((x - self.pos.x) / CELL_SIZE),
        math.floor((y - self.pos.y) / CELL_SIZE)
    local key = self:getItemAt(cx, cy)
    if key == nil then return end
    Selection:set(self.items[key])
    table.remove(self.items, key)
end

function Inventory:mousereleased(x, y)
    local selection = Selection:get()
    if selection then
        local type = selection.type
        local item = Items[type]
        local cx, cy =
            math.floor((x - self.pos.x) / CELL_SIZE - (item.width - 1) / 2),
            math.floor((y - self.pos.y) / CELL_SIZE - (item.height - 1) / 2)
        if self:checkItemFits(type, cx, cy) then
            self:addItem(type, cx, cy)
        else
            self:addItem(type, selection.x, selection.y)
        end
        Selection:clear()
    end
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
end

function Inventory:addItem(type, x, y)
    table.insert(self.items, {
        type = type,
        x = x,
        y = y,
    })
end

function Inventory:checkItemFits(type, x, y)
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

    for i = x, x + Items[type].width - 1 do
        for j = y, y + Items[type].height - 1 do
            if not self:isValidPosition(i, j) then return false end
            if board[i][j] then return false end
        end
    end

    return true
end

function Inventory:isValidPosition(x, y)
    return x >= 0 and x < WIDTH and y >= 0 and y < HEIGHT
end

function Inventory:getItemAt(x, y)
    if not self:isValidPosition(x, y) then return nil end
    for key, item in ipairs(self.items) do
        local data = Items[item.type]
        for i = item.x, item.x + data.width - 1 do
            for j = item.y, item.y + data.height - 1 do
                if i == x and j == y then return key end
            end
        end
    end
    return nil
end

return Inventory

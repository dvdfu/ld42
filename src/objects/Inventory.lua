local Class = require 'modules.hump.class'
local Vector = require 'modules.hump.vector'
local Constants = require 'src.Constants'
local Items = require 'src.Items'
local Selection = require 'src.Selection'
local HitBox = require 'src.objects.HitBox'

local Inventory = Class.new()
Inventory:include(HitBox)

local WIDTH = 4
local HEIGHT = 4

function Inventory:init(x, y)
    HitBox.init(self, x, y,
        WIDTH * Constants.CELL_SIZE,
        HEIGHT * Constants.CELL_SIZE)
    self.items = {}
end

function Inventory:mousepressed(x, y)
    if not self:containsPoint(x, y) then return false end

    local cx, cy =
        math.floor((x - self.pos.x) / Constants.CELL_SIZE),
        math.floor((y - self.pos.y) / Constants.CELL_SIZE)
    local key = self:getItemAt(cx, cy)
    if key == nil then return false end

    local item = self.items[key]
    table.remove(self.items, key)
    Selection:set(item.type, function(used)
        if not used then
            self:addItem(item.type, item.x, item.y)
        end
    end)
    return true
end

function Inventory:draw()
    love.graphics.push()
    love.graphics.translate(self.pos.x, self.pos.y)

    -- draw the grid
    love.graphics.setColor(0.3, 0.3, 0.3)
    for i = 0, WIDTH - 1 do
        for j = 0, HEIGHT - 1 do
            love.graphics.rectangle('line',
                i * Constants.CELL_SIZE,
                j * Constants.CELL_SIZE,
                Constants.CELL_SIZE,
                Constants.CELL_SIZE)
        end
    end
    love.graphics.setColor(1, 1, 1)

    -- draw the items
    for i = 1, #self.items do
        local item = self.items[i]
        local sprite = Items[item.type].sprite
        love.graphics.draw(sprite,
            item.x * Constants.CELL_SIZE,
            item.y * Constants.CELL_SIZE
        )
    end

    -- draw selection overlay
    local type = Selection:get()
    local mx, my = love.mouse.getPosition()
    if type and self:containsPoint(mx, my) then
        local item = Items[type]
        local cx, cy =
            math.floor((mx - self.pos.x) / Constants.CELL_SIZE - (item.width - 1) / 2),
            math.floor((my - self.pos.y) / Constants.CELL_SIZE - (item.height - 1) / 2)

        if self:checkItemFits(type, cx, cy) then
            love.graphics.setColor(0, 1, 0, 0.5)
        else
            love.graphics.setColor(1, 0, 0, 0.5)
        end

        for i = cx, cx + item.width - 1 do
            for j = cy, cy + item.height - 1 do
                love.graphics.rectangle('fill',
                    i * Constants.CELL_SIZE,
                    j * Constants.CELL_SIZE,
                    Constants.CELL_SIZE,
                    Constants.CELL_SIZE)
            end
        end
        love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.pop()
end

function Inventory:receiveItem(type, x, y)
    if not self:containsPoint(x, y) then return false end

    local item = Items[type]
    local cx, cy =
        math.floor((x - self.pos.x) / Constants.CELL_SIZE - (item.width - 1) / 2),
        math.floor((y - self.pos.y) / Constants.CELL_SIZE - (item.height - 1) / 2)

    if self:checkItemFits(type, cx, cy) then
        self:addItem(type, cx, cy)
        return true
    end

    return false
end

function Inventory:addItem(type, cx, cy)
    assert(self:isValidPosition(cx, cy))
    table.insert(self.items, {
        type = type,
        x = cx,
        y = cy,
    })
end

function Inventory:checkItemFits(type, cx, cy)
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

    for i = cx, cx + Items[type].width - 1 do
        for j = cy, cy + Items[type].height - 1 do
            if not self:isValidPosition(i, j) then return false end
            if board[i][j] then return false end
        end
    end

    return true
end

function Inventory:isValidPosition(cx, cy)
    return cx >= 0 and cx < WIDTH and cy >= 0 and cy < HEIGHT
end

function Inventory:getItemAt(cx, cy)
    if not self:isValidPosition(cx, cy) then return nil end
    for key, item in ipairs(self.items) do
        local data = Items[item.type]
        for i = item.x, item.x + data.width - 1 do
            for j = item.y, item.y + data.height - 1 do
                if i == cx and j == cy then return key end
            end
        end
    end
    return nil
end

return Inventory

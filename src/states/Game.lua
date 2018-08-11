local Constants = require 'src.Constants'
local Selection = require 'src.Selection'
local Inventory = require 'src.objects.Inventory'
local ItemDrop = require 'src.objects.ItemDrop'
local TextBox = require 'src.objects.TextBox'
local Trash = require 'src.objects.Trash'

local Game = {}

function Game:init()
    Selection:init()
end

function Game:enter()
    self.textbox = TextBox('test text', 40, 400)
    self.inventory = Inventory(Constants.SCREEN_WIDTH - 300, 200)
    self.drops = {
        ItemDrop('HEART', 40, 40),
        ItemDrop('SWORD', 120, 40),
        ItemDrop('KNIFE', 200, 40),
        ItemDrop('PENDANT', 280, 40),
    }
    self.trash = Trash(40, 200)
end

function Game:update(dt)
    self.textbox:update(dt)
end

function Game:mousepressed(x, y)
    if not Selection:get() then
        if self.inventory:mousepressed(x, y) then return end
        for _, drop in ipairs(self.drops) do
            if drop:mousepressed(x, y) then return end
        end
    end
end

function Game:mousereleased(x, y)
    local type = Selection:get()
    if type then
        if self.inventory:receiveItem(type, x, y) then
            Selection:take()
            return
        end
        if self.trash:receiveItem(type, x, y) then
            Selection:take()
            return
        end
    end
    Selection:reset()
end

function Game:draw()
    self.textbox:draw()
    self.inventory:draw()
    for _, drop in ipairs(self.drops) do
        drop:draw()
    end
    self.trash:draw()
    Selection:draw()
end

return Game

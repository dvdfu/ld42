local Constants = require 'src.Constants'
local Selection = require 'src.Selection'
local Inventory = require 'src.objects.Inventory'
local ItemDrop = require 'src.objects.ItemDrop'
local TextBox = require 'src.objects.TextBox'

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
end

function Game:update(dt)
    self.textbox:update(dt)
end

function Game:mousepressed(x, y)
    self.inventory:mousepressed(x, y)
    for _, drop in ipairs(self.drops) do
        drop:mousepressed(x, y)
    end
end

function Game:mousereleased(x, y)
    self.inventory:mousereleased(x, y)
    for _, drop in ipairs(self.drops) do
        drop:mousereleased(x, y)
    end
end

function Game:draw()
    self.textbox:draw()
    self.inventory:draw()
    for _, drop in ipairs(self.drops) do
        drop:draw()
    end
    Selection:draw()
end

return Game

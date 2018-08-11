local Constants = require 'src.Constants'
local Selection = require 'src.Selection'
local TextBox = require 'src.objects.TextBox'
local Inventory = require 'src.objects.Inventory'

local Game = {}

function Game:init()
    Selection:init()
end

function Game:enter()
    self.textbox = TextBox('test text', 40, 400)
    self.inventory = Inventory(Constants.SCREEN_WIDTH - 300, 200)
    self.inventory:addItem('HEART', 1, 0)
    self.inventory:addItem('SWORD', 3, 1)
    self.inventory:addItem('KNIFE', 1, 1)
    self.inventory:addItem('PENDANT', 2, 0)
end

function Game:update(dt)
    self.textbox:update(dt)
end

function Game:mousepressed(x, y)
    self.inventory:mousepressed(x, y)
end

function Game:mousereleased(x, y)
    self.inventory:mousereleased(x, y)
end

function Game:draw()
    self.textbox:draw()
    self.inventory:draw()
    Selection:draw()
end

return Game

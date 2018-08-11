local Constants = require 'src.Constants'
local TextBox = require 'src.objects.TextBox'
local Inventory = require 'src.objects.Inventory'

local Game = {}

function Game:init()
    self.textbox = TextBox('test text', 40, 400)
    self.inventory = Inventory(Constants.SCREEN_WIDTH - 300, 200)
end

function Game:enter()
end

function Game:update(dt)
    self.textbox:update(dt)
end

function Game:mousepressed(x, y)
end

function Game:mousereleased(x, y)
end

function Game:draw()
    self.textbox:draw()
    self.inventory:draw()
end

return Game

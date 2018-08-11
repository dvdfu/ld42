local Textbox = require 'src.objects.Textbox'

local Game = {}

function Game:init()
    self.textbox = Textbox('test text')
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
    self.textbox:draw(40, 40)
end

return Game

math.randomseed(os.time())

local Game = require 'src.states.Game'
local Gamestate = require 'modules.hump.gamestate'

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    Gamestate.switch(Game)
end

function love.update(dt)
    Gamestate.update(dt)
end

function love.mousepressed(x, y)
    Gamestate.mousepressed(x, y)
end

function love.mousereleased(x, y)
    Gamestate.mousereleased(x, y)
end

function love.draw()
    Gamestate.draw()
end

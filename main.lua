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

function love.mousepressed(x, y, button)
    if button == 1 then
        Gamestate.mousepressed(x, y)
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        Gamestate.mousereleased(x, y)
    end
end

function love.draw()
    Gamestate.draw()
end

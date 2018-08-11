math.randomseed(os.time())

local Game = require 'src.states.Game'
local Gamestate = require 'modules.hump.gamestate'

function love.load()
    Gamestate.switch(Game)
end

function love.update(dt)
    Gamestate.update(1)
end

function love.draw()
    Gamestate.draw()
end

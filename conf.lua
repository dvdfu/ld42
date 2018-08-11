local Constants = require 'src.data.Constants'

function love.conf(t)
    t.window.title = 'LD42'
    t.window.resizable = false
    t.window.vsync = true
    t.window.width = Constants.SCREEN_WIDTH
    t.window.height = Constants.SCREEN_HEIGHT
end

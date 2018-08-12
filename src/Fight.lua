local Class = require 'modules.hump.class'
local Animation = require 'src.Animation'
local Sprites = require 'src.data.Sprites'
local Enemy = require 'src.objects.Enemy'

local Fight = Class.new()

function Fight:init()
    self.enemies = {
        Enemy('SLIME', 200, 200)
    }
    self.phase = 0 -- player turn

    self.poof = Animation(Sprites.POOF_BIG, 4, 0.1, true)
end

function Fight:update(dt)
    for i, enemy in ipairs(self.enemies) do
        if enemy:isDead() then
            table.remove(self.enemies, i)
            self.poof:play()
        else
            enemy:update(dt)
        end
    end
    self.poof:update(dt)
end

function Fight:draw()
    for _, enemy in ipairs(self.enemies) do
        enemy:draw()
    end
    self.poof:draw(200, 200) -- TODO
end

function Fight:receiveItem(type, x, y)
    for _, enemy in ipairs(self.enemies) do
        if enemy:receiveItem(type, x, y) then
            Selection:take()
            if self.phase == #self.enemies then
                self.phase = 0
            else
                self.phase = self.phase + 1
            end
            return
        end
    end
end

function Fight:isPlayerTurn()
    return self.phase == 0
end

return Fight

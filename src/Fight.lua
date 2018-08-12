local Class = require 'modules.hump.class'
local Signal = require 'modules.hump.signal'
local Vector = require 'modules.hump.vector'
local Animation = require 'src.Animation'
local Enemies = require 'src.data.Enemies'
local Sprites = require 'src.data.Sprites'
local Enemy = require 'src.objects.Enemy'

local Fight = Class.new()

function Fight:init()
    self.enemies = {
        Enemy('SLIME', 40, 200),
        Enemy('WOLF', 240, 220),
        Enemy('SLIME', 440, 200),
    }
    self.phase = 0 -- player turn
    self.waitingClick = false

    self.poof = Animation(Sprites.POOF_BIG, 4, 0.1, true)
    self.poofPos = Vector()
end

function Fight:update(dt)
    for i, enemy in ipairs(self.enemies) do
        if enemy:isDead() then
            table.remove(self.enemies, i)
            self:onEnemyDead(enemy)
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
    self.poof:draw(self.poofPos:unpack())
end

function Fight:onEnemyDead(enemy)
    local type = enemy:getType()
    local drops = Enemies[type].drops

    for i, drop in ipairs(drops) do
        if math.random() < drop.chance then
            local x, y = enemy:getPosition():unpack()
            Signal.emit('drop', drop.type,
                x + math.random(0, 160) - 16,
                y + math.random(0, 160) - 16)
        end
    end

    self.poofPos = enemy:getPosition()
    self.poof:play()
end

function Fight:receiveItem(type, x, y)
    assert(self.phase == 0)
    for i, enemy in ipairs(self.enemies) do
        if enemy:receiveItem(type, x, y) then
            self.waitingClick = true
            return
        end
    end
end

function Fight:nextPhase()
    self.waitingClick = false

    if #self.enemies == 0 then
        self.phase = 0
        return
    end

    if self.phase == #self.enemies then
        self.phase = 0
    else
        self.phase = self.phase + 1
        self.enemies[self.phase]:move()
        self.waitingClick = true
    end
end

function Fight:isPlayerTurn()
    return self.phase == 0 and not self.waitingClick
end

function Fight:isWaitingClick()
    return self.waitingClick
end

return Fight

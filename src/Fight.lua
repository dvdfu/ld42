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

    self.events = {}

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
    assert(self:isPlayerTurn())
    for i, enemy in ipairs(self.enemies) do
        if enemy:receiveItem(type, x, y) then
            self:addEvent('ENEMY', 1)
            return
        end
    end
end

function Fight:isPlayerTurn()
    return #self.events == 0
end

function Fight:nextEvent()
    assert(#self.events > 0)
    local event = table.remove(self.events, 1)

    if event.type == 'ENEMY' and #self.enemies > 0 then
        local i = event.data
        self.enemies[i]:move()
        if i < #self.enemies then
            self:addEvent('ENEMY', i + 1)
        end
    end
end

function Fight:addEvent(type, data)
    table.insert(self.events, {
        type = type,
        data = data,
    })
end

return Fight

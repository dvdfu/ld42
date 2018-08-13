local Class = require 'modules.hump.class'
local Signal = require 'modules.hump.signal'
local Vector = require 'modules.hump.vector'
local Animation = require 'src.Animation'
local Constants = require 'src.data.Constants'
local Enemies = require 'src.data.Enemies'
local Items = require 'src.data.Items'
local Sprites = require 'src.data.Sprites'
local Enemy = require 'src.objects.Enemy'

local Fight = Class.new()

function Fight:init()
    self.enemies = {}
    self.playerTurn = true

    self.poof = Animation(Sprites.POOF_BIG, 4, 0.1, true)
    self.poofPos = Vector()

    Signal.register('game_over', function() end)
end

function Fight:update(dt)
    for i, enemy in ipairs(self.enemies) do
        if enemy:isDead() then
            table.remove(self.enemies, i)
            self:onEnemyDead(enemy)
        else
            enemy:update(dt)
            local x = 320 + -400 + 800 * i / (#self.enemies + 1)
            local y = 240
            enemy:moveTowards(x, y)
        end
    end
    self.poof:update(dt)
end

function Fight:draw()
    for _, enemy in ipairs(self.enemies) do
        enemy:draw()
    end
    local x, y = self.poofPos:unpack()
    self.poof:draw(x, y, 0, 1.5, 1.5, 80, 80)
end

function Fight:onEnemyDead(enemy)
    local type = enemy:getType()
    local drops = Enemies[type].drops

    for i, drop in ipairs(drops) do
        if math.random() < drop.chance then
            local x, y = enemy:getPosition():unpack()
            local w, h =
                Items[drop.type].width * Constants.CELL_SIZE,
                Items[drop.type].height * Constants.CELL_SIZE
            Signal.emit('drop', drop.type,
                x + 80 + math.random(-40, 40) - w / 2,
                y + 80 + math.random(-40, 40) - h / 2)
        end
    end

    self.poofPos = enemy:getCenter()
    self.poof:play()

    -- spawn new wave of enemies
    if #self.enemies == 0 then
        self.playerTurn = true
        self:addEnemy(math.random() > 0.7 and 'WOLF' or 'SLIME')
        if math.random() > 0.5 then
            self:addEnemy(math.random() > 0.7 and 'WOLF' or 'SLIME')
        end
    end
end

function Fight:getEnemyAtPosition(x, y)
    for _, enemy in ipairs(self.enemies) do
        if enemy:containsPoint(x, y) then
            return enemy
        end
    end
    return nil
end

function Fight:useItemOnEnemy(item, enemy)
    local itemData = Items[item]
    assert(itemData)
    self.playerTurn = false
    if itemData.attackAll then
        for _, other in ipairs(self.enemies) do
            other:attack(itemData.damage)
        end
    else
        enemy:attack(itemData.damage)
    end
    self:enemyTurn()
end

function Fight:isPlayerTurn()
    return self.playerTurn
end

function Fight:enemyTurn()
    local enemy = self:getNextEnemy()
    if enemy then
        enemy:move()
        -- TODO
    else
        -- no enemies left to move
        self:setPlayerTurn()
    end
end

function Fight:getNextEnemy()
    for _, enemy in ipairs(self.enemies) do
        assert(not enemy:isDead())
        if not enemy:hasMoved() then
            return enemy
        end
    end
    return nil
end

function Fight:setPlayerTurn()
    self.playerTurn = true

    -- reset enemy turns
    if #self.enemies > 0 then
        for _, enemy in ipairs(self.enemies) do
            assert(not enemy:isDead())
            enemy:newTurn()
        end
    end
end

function Fight:addEnemy(type)
    local enemy = Enemy(type, 320, -240)
    table.insert(self.enemies, enemy)
end

return Fight

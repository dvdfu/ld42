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
    self.queue = {}
    self.waitingForEnemies = false

    self.poof = Animation(Sprites.POOF_BIG, 4, 0.1, true)
    self.poofPos = Vector()

    Signal.register('fight_event', function(...) self:queueEvent(...) end)
    Signal.register('game_over', function() end)
end

function Fight:update(dt)
    for i, enemy in ipairs(self.enemies) do
        enemy:update(dt)
        local x = 320 + -400 + 800 * i / (#self.enemies + 1)
        local y = 240
        enemy:moveTowards(x, y)
    end

    if self.waitingForEnemies and self:isEnemiesReady() then
        self.waitingForEnemies = false
        self:nextEvent()
    end

    self.poof:update(dt)
end

function Fight:draw()
    for _, enemy in ipairs(self.enemies) do
        enemy:draw()
    end
    local x, y = self.poofPos:unpack()
    self.poof:draw(x, y, 0, 1.5, 1.5, 80, 80)
    -- for i, event in ipairs(self.queue) do
    --     love.graphics.print(i .. '\t' .. event.type, 0, i * 32)
    -- end
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

    Signal.emit('text', Enemies[type].name .. ' fainted!')

    -- spawn new wave of enemies
    if #self.enemies == 0 then
        self:queueEvent('ENEMY_WAVE', nil, true)
    end
end

function Fight:addEnemy(type)
    local enemy = Enemy(type, 320, -240)
    table.insert(self.enemies, enemy)
end

function Fight:getEnemyAtPosition(x, y)
    for _, enemy in ipairs(self.enemies) do
        if enemy:containsPoint(x, y) then
            return enemy
        end
    end
    return nil
end

function Fight:submitPlayerMove(item, enemy)
    self:queueEvent('PLAYER_MOVE', {
        item = item,
        enemy = enemy,
    })

    for i, enemy in ipairs(self.enemies) do
        self:queueEvent('ENEMY_MOVE', {
            enemy = enemy
        })
    end

    self:nextEvent()
end

function Fight:nextEvent()
    if self:isPlayerTurn() then return end

    local event = table.remove(self.queue, 1)

    if event.type == 'PLAYER_MOVE' then
        self.waitingForEnemies = true
        local itemData = Items[event.data.item]
        assert(itemData)
        if itemData.attackAll then
            for _, enemy in ipairs(self.enemies) do
                enemy:attack(itemData.damage)
            end
        else
            event.data.enemy:attack(itemData.damage)
        end
    elseif event.type == 'ENEMY_MOVE' then
        if event.data.enemy:isDead() then
            self:nextEvent()
        else
            event.data.enemy:move()
        end
    elseif event.type == 'ENEMY_DIE' then
        for i, enemy in ipairs(self.enemies) do
            if enemy == event.data.enemy then
                table.remove(self.enemies, i)
                self:onEnemyDead(enemy)
                break;
            end
        end
    elseif event.type == 'ENEMY_WAVE' then
        self:addEnemy(math.random() > 0.7 and 'WOLF' or 'SLIME')
        if math.random() > 0.5 then
            self:addEnemy(math.random() > 0.7 and 'WOLF' or 'SLIME')
        end
        Signal.emit('text', 'More foes approach!')
    end
end

function Fight:queueEvent(type, data, immediate)
    immediate = immediate or false
    local event = {
        type = type,
        data = data,
    }
    if immediate then
        table.insert(self.queue, 1, event)
    else
        table.insert(self.queue, event)
    end
end

function Fight:isEnemiesReady()
    for _, enemy in ipairs(self.enemies) do
        if not enemy:isReady() then return false end
    end
    return true
end

function Fight:isPlayerTurn()
    return #self.queue == 0
end

return Fight

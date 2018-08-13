local Class = require 'modules.hump.class'
local Signal = require 'modules.hump.signal'
local Timer = require 'modules.hump.timer'
local Vector = require 'modules.hump.vector'
local Animation = require 'src.Animation'
local Selection = require 'src.Selection'
local Enemies = require 'src.data.Enemies'
local Items = require 'src.data.Items'
local Sprites = require 'src.data.Sprites'
local HitBox = require 'src.objects.HitBox'

local Enemy = Class.new()
Enemy:include(HitBox)

function Enemy:init(type, x, y)
    local enemy = Enemies[type]
    local w, h = enemy.sprite:getDimensions()
    HitBox.init(self, x - w / 2, y, w, h)
    self.type = type
    self.health = enemy.health
    self.ready = true

    self.slash = Animation(Sprites.SLASH, 4, 0.1, true)

    self.healthDisplay = self.health
    self.spriteScale = 1
    self.yOffset = 0

    self.hitTimer = Timer()
    self.healthTimer = Timer()
    self.moveTimer = Timer()
end

function Enemy:update(dt)
    self.slash:update(dt)
    self.hitTimer:update(dt)
    self.healthTimer:update(dt)
    self.moveTimer:update(dt)
end

function Enemy:draw()
    local sprite = Enemies[self.type].sprite

    love.graphics.push()
    love.graphics.translate(
        self.pos.x + sprite:getWidth() / 2,
        self.pos.y + sprite:getHeight())

    love.graphics.draw(sprite,
        0, self.yOffset, 0,
        self.spriteScale,
        1 / self.spriteScale,
        sprite:getWidth() / 2,
        sprite:getHeight())

    love.graphics.push()
    love.graphics.translate(-64, -sprite:getHeight() - 32 - self.spriteScale * 16)
    local hp = self.healthDisplay / Enemies[self.type].health
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', 4, 4, 120 * hp, 24)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(Sprites.HEALTH_BORDER)
    love.graphics.pop()

    self.slash:draw(0, -sprite:getHeight() / 2, 0, 1, 1, 80, 80)

    love.graphics.pop()
end

function Enemy:attack(damage)
    assert(damage > 0)
    self.slash:play()
    self.spriteScale = 1.5
    self.hitTimer:clear()
    self.hitTimer:tween(0.5, self, { spriteScale = 1 }, 'out-elastic')

    if self.health > damage then
        self.health = self.health - damage
    else
        self.health = 0
    end

    self.ready = false
    self.healthTimer:clear()
    self.healthTimer:tween(0.5, self, { healthDisplay = self.health }, 'out-cubic', function()
        if self.health == 0 then
            Signal.emit('fight_event', 'ENEMY_DIE', { enemy = self }, 1)
        end
        self.ready = true
    end)
end

function Enemy:move()
    local moves = Enemies[self.type].moves
    local move = moves[math.random(1, #moves)]
    if move.damage > 0 then
        Signal.emit('damage_player', move.damage)
    end

    self.ready = false
    self.yOffset = -32
    self.moveTimer:tween(0.5, self, { yOffset = 0 }, 'in-bounce', function()
        self.ready = true
    end)

    Signal.emit('text', move.text)
end

function Enemy:moveTowards(x, y)
    local delta = Vector(x, y) - self.pos - self.size / 2
    self.pos = self.pos + delta / 8
end

function Enemy:isDead()
    return self.health == 0
end

function Enemy:isReady()
    return self.ready
end

function Enemy:getType()
    return self.type
end

return Enemy

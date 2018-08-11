local Class = require 'modules.hump.class'
local Signal = require 'modules.hump.signal'
local Timer = require 'modules.hump.timer'
local Enemies = require 'src.Enemies'
local Items = require 'src.Items'
local Sprites = require 'src.Sprites'
local Animation = require 'src.objects.Animation'
local HitBox = require 'src.objects.HitBox'

local Enemy = Class.new()
Enemy:include(HitBox)

function Enemy:init(type, x, y)
    local enemy = Enemies[type]
    HitBox.init(self, x, y, enemy.sprite:getWidth(), enemy.sprite:getHeight())
    self.type = type
    self.health = enemy.health
    self.healthDisplay = self.health
    self.slash = Animation(Sprites.SLASH, 4, 0.1, true)
    self.hitTimer = Timer()
    self.spriteScale = 1
end

function Enemy:update(dt)
    self.slash:update(dt)
    self.hitTimer:update(dt)
    self.healthDisplay = self.healthDisplay + (self.health - self.healthDisplay) / 3
end

function Enemy:draw()
    love.graphics.push()
    love.graphics.translate(self.pos.x, self.pos.y)
    love.graphics.draw(Enemies[self.type].sprite,
        80, 160, 0,
        self.spriteScale,
        1 / self.spriteScale,
        80, 160)

    love.graphics.push()
    love.graphics.translate(24, -32)
    local hp = self.healthDisplay / Enemies[self.type].health
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', 4, 4, 120 * hp, 24)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(Sprites.HEALTH_BORDER)
    love.graphics.pop()

    self.slash:draw(0, 0)

    love.graphics.pop()
end

function Enemy:receiveItem(type, x, y)
    if not self:containsPoint(x, y) then return false end

    local item = Items[type]
    if item.damage then
        self:attack(item.damage)
    end
    return false
end

function Enemy:attack(damage)
    self.slash:play()
    self.spriteScale = 1.5
    self.hitTimer:clear()
    self.hitTimer:tween(0.6, self, { spriteScale = 1 }, 'out-elastic')

    if self.health > damage then
        self.health = self.health - damage
        Signal.emit('text', 'Hit for ' .. damage .. ' damage!')
    else
        self.health = 0
        Signal.emit('text', 'Enemy slain!')
    end
end

function Enemy:move()
    local moves = Enemies[self.type].moves
    local move = moves[math.random(1, #moves)]
    Signal.emit('damage_player', move.damage)
    Signal.emit('text', move.text)
end

return Enemy

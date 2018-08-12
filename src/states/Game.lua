local Signal = require 'modules.hump.signal'
local Constants = require 'src.data.Constants'
local Items = require 'src.data.Items'
local Selection = require 'src.Selection'
local Sprites = require 'src.data.Sprites'
local Animation = require 'src.Animation'
local Fight = require 'src.Fight'
local Enemy = require 'src.objects.Enemy'
local Inventory = require 'src.objects.Inventory'
local ItemDrop = require 'src.objects.ItemDrop'
local TextBox = require 'src.objects.TextBox'
local Trash = require 'src.objects.Trash'

local Game = {}

function Game:init()
    Selection:init()

    Signal.register('text', function(text)
        self.textbox:setText(text)
    end)

    Signal.register('text_end', function(text)
        if self.fight:isWaitingClick() then
            self.fight:nextPhase()
        end
    end)

    Signal.register('damage_player', function(amount)
        self.inventory:loseHP(amount)
    end)
end

function Game:enter()
    self.textbox = TextBox('', 80, Constants.SCREEN_HEIGHT - 128 - 80, 480, 128)
    self.inventory = Inventory(
        Constants.SCREEN_WIDTH - 5 * Constants.CELL_SIZE,
        Constants.SCREEN_HEIGHT / 2 - 2 * Constants.CELL_SIZE)
    self.inventory:addItem('HEART', 3, 0)
    self.inventory:addItem('HEART', 3, 1)
    self.inventory:addItem('HEART', 3, 2)
    self.inventory:addItem('KNIFE', 0, 0)
    self.inventory:addItem('SHIELD', 1, 0)
    self.trash = Trash(
        Constants.SCREEN_WIDTH - 2 * Constants.CELL_SIZE - 80,
        Constants.SCREEN_HEIGHT - 2 * Constants.CELL_SIZE
    )
    self.drops = {}
    self.fight = Fight()
end

function Game:update(dt)
    self.inventory:update(dt)
    self.textbox:update(dt)
    self.fight:update(dt)

    for i, drop in ipairs(self.drops) do
        if drop:isDead() then
            table.remove(self.drops, i)
        end
    end
end

function Game:mousepressed(x, y)
    assert(not Selection:get())
    if self.textbox:mousepressed(x, y) then return end

    if self.fight:isPlayerTurn() then
        if self.inventory:mousepressed(x, y) then return end
        for _, drop in ipairs(self.drops) do
            if drop:mousepressed(x, y) then return end
        end
    end
end

function Game:mousereleased(x, y)
    local type = Selection:get()
    if type then
        if self.inventory:receiveItem(type, x, y) then return end
        if self.trash:receiveItem(type, x, y) then return end
        if self.fight:receiveItem(type, x, y) then return end
    end
    Selection:reset()
end

function Game:draw()
    self.textbox:draw()
    self.inventory:draw()
    for _, drop in ipairs(self.drops) do
        drop:draw()
    end
    self.trash:draw()
    self.fight:draw()
    Selection:draw()
end

return Game

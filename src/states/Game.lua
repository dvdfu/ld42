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
local ItemDrops = require 'src.objects.ItemDrops'
local TextBox = require 'src.objects.TextBox'
local Trash = require 'src.objects.Trash'

local Game = {}

function Game:init()
    Selection:init()

    Signal.register('text', function(text)
        self.textbox:queueText(text)
    end)

    Signal.register('text_end', function(text)
        if not self.fight:isPlayerTurn() then
            self.fight:setPlayerTurn()
        end
    end)

    Signal.register('damage_player', function(amount)
        self.flash:play()
        self.inventory:loseHP(amount)
    end)
end

function Game:enter()
    self.textbox = TextBox(80, Constants.SCREEN_HEIGHT - 128 - 40, 480, 128)
    self.inventory = Inventory(
        Constants.SCREEN_WIDTH - 5 * Constants.CELL_SIZE,
        Constants.SCREEN_HEIGHT / 2 - 2 * Constants.CELL_SIZE)
    self.trash = Trash(
        Constants.SCREEN_WIDTH - 2 * Constants.CELL_SIZE - 80,
        Constants.SCREEN_HEIGHT - 2 * Constants.CELL_SIZE)

    self.fight = Fight()
    self.flash = Animation(Sprites.SCREEN_FLASH, 6, 0.05, true)
    self.itemDrops = ItemDrops()

    self.inventory:addItem('HEART', 3, 0)
    self.inventory:addItem('HEART', 3, 1)
    self.inventory:addItem('HEART', 3, 2)
    self.inventory:addItem('AXE', 0, 0)
    self.fight:addEnemy('SLIME')
    self.fight:addEnemy('WOLF')
end

function Game:update(dt)
    self.inventory:update(dt)
    self.textbox:update(dt)
    self.fight:update(dt)
    self.flash:update(dt)
    self.itemDrops:update(dt)
    self.inventory:setActive(self.fight:isPlayerTurn())
end

function Game:mousepressed(x, y)
    assert(not Selection:get())
    self.textbox:tap()

    if self.fight:isPlayerTurn() then
        if self.inventory:mousepressed(x, y) then return end
        if self.itemDrops:mousepressed(x, y) then return end
    end
end

function Game:mousereleased(x, y)
    local item = Selection:get()
    if item then
        if self.inventory:receiveItem(item, x, y) then return end
        if self.trash:containsPoint(x, y) then
            Selection:take()
            return
        end

        local enemy = self.fight:getEnemyAtPosition(x, y)
        if enemy then
            self.fight:useItemOnEnemy(item, enemy)
            Selection:reset()
            return
        end
    end
    Selection:reset()
end

function Game:draw()
    self.flash:draw()
    self.textbox:draw()
    self.inventory:draw()
    self.itemDrops:draw()
    self.trash:draw()
    self.fight:draw()
    Selection:draw()
end

return Game

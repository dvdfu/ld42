local Sprites = require 'src.data.Sprites'

return {
    HEART = {
        width = 1,
        height = 1,
        sprite = Sprites.ITEM_HEART,
        description = 'Overflowing with life energy.\nProvides 1 HP.',
    },
    KNIFE = {
        width = 1,
        height = 2,
        sprite = Sprites.ITEM_KNIFE,
        description = 'Small but pointy.\nAttacks for 2 DMG.',
        damage = 2,
    },
    SWORD = {
        width = 1,
        height = 3,
        sprite = Sprites.ITEM_SWORD,
        description = 'Worthy of a fighter.\nAttacks for 4 DMG.',
        damage = 4,
    },
    PENDANT = {
        width = 2,
        height = 1,
        sprite = Sprites.ITEM_PENDANT,
        description = 'Sparks fly from its gem.\nNullifies electric attacks.',
    },
}

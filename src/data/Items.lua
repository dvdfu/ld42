local Sprites = require 'src.data.Sprites'

return {
    HEART = {
        width = 1,
        height = 1,
        sprite = Sprites.items.HEART,
        description = 'Overflowing with life energy.\nProvides 1 HP.',
    },
    KNIFE = {
        width = 1,
        height = 2,
        sprite = Sprites.items.KNIFE,
        description = 'Small but pointy.\nAttacks for 2 DMG.',
        damage = 2,
    },
    SWORD = {
        width = 1,
        height = 3,
        sprite = Sprites.items.SWORD,
        description = 'Worthy of a fighter.\nAttacks for 4 DMG.',
        damage = 4,
    },
    AXE = {
        width = 3,
        height = 2,
        sprite = Sprites.items.AXE,
        description = 'A truly barbaric weapon.\nAttacks all enemies for 5 DMG.',
        damage = 5,
        attackAll = true,
    },
    PENDANT = {
        width = 2,
        height = 1,
        sprite = Sprites.items.PENDANT,
        description = 'Sparks fly from its gem.\nNullifies electric attacks.',
    },
    SHIELD = {
        width = 2,
        height = 2,
        sprite = Sprites.items.SHIELD,
        description = 'A trusty round wooden shield.\nReduces incoming attacks by up to 1 DMG.',
    },
}

return {
    HEART = {
        width = 1,
        height = 1,
        sprite = love.graphics.newImage('assets/heart.png'),
        description = 'Overflowing with life energy.\nProvides 1 HP.',
    },
    KNIFE = {
        width = 1,
        height = 2,
        sprite = love.graphics.newImage('assets/knife.png'),
        description = 'Small but pointy.\nAttacks for 2 DMG.',
        damage = 2,
    },
    SWORD = {
        width = 1,
        height = 3,
        sprite = love.graphics.newImage('assets/sword.png'),
        description = 'Worthy of a fighter.\nAttacks for 4 DMG.',
        damage = 4,
    },
    PENDANT = {
        width = 2,
        height = 1,
        sprite = love.graphics.newImage('assets/pendant.png'),
        description = 'Sparks fly from its gem.\nNullifies electric attacks.',
    },
}

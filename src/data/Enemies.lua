local Sprites = require 'src.data.Sprites'

return {
    SLIME = {
        health = 3,
        sprite = Sprites.ENEMY_SLIME,
        moves = {
            {
                damage = 0,
                text = 'Slime looks around for a target!',
            },
            {
                damage = 1,
                text = 'Slime pounces you for 1 damage!',
            },
        },
        drops = {
            {
                type = 'HEART',
                chance = 0.7,
            },
        },
    },
    WOLF = {
        health = 7,
        sprite = Sprites.ENEMY_WOLF,
        moves = {
            {
                damage = 1,
                text = 'Wolf lets out a deafening roar!',
            },
            {
                damage = 2,
                text = 'Wolf slashes with their claws!',
            },
        },
        drops = {
            {
                type = 'KNIFE',
                chance = 0.3,
            },
            {
                type = 'HEART',
                chance = 1,
            },
        },
    },
}

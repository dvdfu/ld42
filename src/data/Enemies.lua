local Sprites = require 'src.data.Sprites'

return {
    SLIME = {
        name = 'Slime',
        health = 3,
        sprite = Sprites.enemies.SLIME,
        moves = {
            {
                damage = 0,
                text = 'Slime looks around for a target!',
            },
            {
                damage = 1,
                text = 'Slime pounces onto you!',
            },
        },
        drops = {
            {
                type = 'HEART',
                chance = 0.5,
            },
        },
    },
    WOLF = {
        name = 'Wolf',
        health = 7,
        sprite = Sprites.enemies.WOLF,
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

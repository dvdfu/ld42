local Sprites = require 'src.data.Sprites'

return {
    SLIME = {
        health = 6,
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
            {
                type = 'HEART',
                chance = 0.2,
            },
        },
    },
}

local Sprites = require 'src.Sprites'

return {
    SLIME = {
        health = 5,
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
            {
                damage = 2,
                text = 'Slime body slammed you for 2 damage!',
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

return {
    SLIME = {
        health = 5,
        sprite = love.graphics.newImage('assets/slime.png'),
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
    },
}

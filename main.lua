function love.load()

    anim8 = require "libraries/anim8"
    love.graphics.setDefaultFilter("nearest", "nearest")

    player = {}
    player.x = 400
    player.y = 300
    player.speed = 5
    player.spriteSheet = love.graphics.newImage("assets/knight.png")
    
    -- Create anim8 grid (32x32 sprites in a 256x256 spritesheet = 8x8 grid)
    player.grid = anim8.newGrid(32, 32, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    
    -- Create some example animations (you can adjust these based on your spritesheet layout)
    player.idleAnimation = anim8.newAnimation(player.grid('1-4', 1), 0.2)  -- First row, frames 1-4
    player.walkAnimation = anim8.newAnimation(player.grid('1-8', 3), 0.1)  -- Second row, all frames
    player.rollAnimation = anim8.newAnimation(player.grid('1-8', 6), 0.1)
    player.hitAnimation = anim8.newAnimation(player.grid('1-4', 7), 0.2)
    player.deathAnimation = anim8.newAnimation(player.grid('1-4', 8), 0.2)

    -- Set current animation
    player.currentAnimation = player.idleAnimation
end

function love.update(dt)
    -- Update the current animation
    player.currentAnimation:update(dt)
end

function love.draw()
    -- Draw the animated sprite with scaling (scale by 3x)
    player.currentAnimation:draw(player.spriteSheet, player.x, player.y, 0, 3, 3)
    
    -- Display info
    love.graphics.print("Knight spritesheet: " .. player.spriteSheet:getWidth() .. " x " .. player.spriteSheet:getHeight(), 10, 10)
    love.graphics.print("Individual sprite size: 32x32", 10, 30)
    love.graphics.print("Grid: 8x8 sprites", 10, 50)
    love.graphics.print("Press SPACE to switch animations", 10, 70)
    love.graphics.print("Scaled 3x for visibility", 10, 90)
end

function love.keypressed(key)
    if key == "space" then
        -- Cycle through all animations: idle → walk → roll → hit → death → idle
        if player.currentAnimation == player.idleAnimation then
            player.currentAnimation = player.walkAnimation
        elseif player.currentAnimation == player.walkAnimation then
            player.currentAnimation = player.rollAnimation
        elseif player.currentAnimation == player.rollAnimation then
            player.currentAnimation = player.hitAnimation
        elseif player.currentAnimation == player.hitAnimation then
            player.currentAnimation = player.deathAnimation
        else
            player.currentAnimation = player.idleAnimation
        end
    end
end
local anim8 = require "libraries/anim8"

local Player = {}
Player.__index = Player

function Player.new(x, y)
    local self = setmetatable({}, Player)
    
    self.x = x or 400
    self.y = y or 300
    self.speed = 200  -- pixels per second
    self.spriteSheet = love.graphics.newImage("assets/knight.png")
    
    -- Movement state
    self.isMoving = false
    self.isRolling = false
    self.facingLeft = false  -- Track which direction player is facing
    
    -- Create anim8 grid (32x32 sprites in a 256x256 spritesheet = 8x8 grid)
    self.grid = anim8.newGrid(32, 32, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    
    -- Create animations
    self.idleAnimation = anim8.newAnimation(self.grid('1-4', 1), 0.2)  -- First row, frames 1-4
    self.walkAnimation = anim8.newAnimation(self.grid('1-8', 3), 0.1)  -- Second row, all frames
    self.rollAnimation = anim8.newAnimation(self.grid('1-8', 6), 0.1)
    self.hitAnimation = anim8.newAnimation(self.grid('1-4', 7), 0.2)
    self.deathAnimation = anim8.newAnimation(self.grid('1-4', 8), 0.2)

    -- Set current animation
    self.currentAnimation = self.idleAnimation
    
    return self
end

function Player:update(dt)
    -- Handle WASD movement
    local moving = false
    
    if love.keyboard.isDown("w") then
        self.y = self.y - self.speed * dt
        moving = true
    end
    if love.keyboard.isDown("s") then
        self.y = self.y + self.speed * dt
        moving = true
    end
    if love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
        self.facingLeft = true  -- Face left when moving left
        moving = true
    end
    if love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
        self.facingLeft = false  -- Face right when moving right
        moving = true
    end
    
    -- Update movement state
    self.isMoving = moving
    
    -- Check if roll animation is complete
    if self.isRolling and self.rollAnimation.position >= #self.rollAnimation.frames then
        self.isRolling = false
        self.rollAnimation:gotoFrame(1)  -- Reset for next roll
    end
    
    -- Set appropriate animation based on state
    if self.isRolling then
        -- Keep rolling animation until it's done or interrupted
        self.currentAnimation = self.rollAnimation
    elseif self.isMoving then
        self.currentAnimation = self.walkAnimation
    else
        self.currentAnimation = self.idleAnimation
    end
    
    -- Update the current animation
    self.currentAnimation:update(dt)
end

function Player:draw()
    -- Calculate scale and position based on facing direction
    local scaleX = self.facingLeft and -3 or 3  -- Flip horizontally if facing left
    local scaleY = 3
    local drawX = self.x
    
    -- When flipping left, offset the X position to keep sprite in same visual position
    if self.facingLeft then
        drawX = self.x + 32 * 3  -- Add sprite width * scale to compensate for flip
    end
    
    -- Draw the animated sprite with scaling and flipping
    self.currentAnimation:draw(self.spriteSheet, drawX, self.y, 0, scaleX, scaleY)
end

function Player:keypressed(key)
    if key == "space" then
        -- Only start rolling if not already rolling
        if not self.isRolling then
            self.isRolling = true
            self.rollAnimation:gotoFrame(1)  -- Reset roll animation to start
        end
    end
end

return Player

local anim8 = require "libraries.anim8"

local Slime = {}
Slime.__index = Slime

function Slime.new(x, y, color)
    local self = setmetatable({}, Slime)
    
    -- Position and movement
    self.x = x
    self.y = y
    self.speed = 50  -- Slower than player
    self.direction = 1  -- 1 for right, -1 for left
    
    -- Load sprite sheet based on color
    local spritePath = color == "purple" and "assets/slime_purple.png" or "assets/slime_green.png"
    self.spriteSheet = love.graphics.newImage(spritePath)
    
    -- Create grid for animations (16x16 sprites in a 64x48 sheet)
    self.grid = anim8.newGrid(16, 16, 64, 48)
    
    -- Create animations
    self.animations = {
        idle = anim8.newAnimation(self.grid('1-4', 1), 0.2),
        move = anim8.newAnimation(self.grid('1-4', 2), 0.15)
    }
    
    -- Current animation
    self.currentAnimation = self.animations.idle
    self.isMoving = false
    
    -- Scale
    self.scale = 3
    
    return self
end

function Slime:update(dt)
    -- Simple back and forth movement
    self.x = self.x + (self.speed * self.direction * dt)
    
    -- Reverse direction at boundaries
    if self.x < 50 then
        self.direction = 1
        self.x = 50
    elseif self.x > love.graphics.getWidth() - 50 then
        self.direction = -1
        self.x = love.graphics.getWidth() - 50
    end
    
    -- Update animation based on movement
    if math.abs(self.speed * self.direction) > 0 then
        self.currentAnimation = self.animations.move
        self.isMoving = true
    else
        self.currentAnimation = self.animations.idle
        self.isMoving = false
    end
    
    -- Update current animation
    self.currentAnimation:update(dt)
end

function Slime:draw()
    -- Draw slime (flip based on direction)
    local scaleX = self.scale * self.direction
    self.currentAnimation:draw(
        self.spriteSheet,
        self.x,
        self.y,
        0,  -- rotation
        scaleX,
        self.scale,
        8,  -- origin X (center of 16px sprite)
        8   -- origin Y (center of 16px sprite)
    )
end

return Slime
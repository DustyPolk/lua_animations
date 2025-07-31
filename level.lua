local Level = {}
Level.__index = Level

function Level.new()
    local self = setmetatable({}, Level)
    
    -- Load platform image
    self.platformImage = love.graphics.newImage("assets/platforms.png")
    
    -- Define platforms as rectangles (x, y, width, height)
    self.platforms = {
        -- Ground platform
        {x = 0, y = 600, width = 800, height = 40},
        
        -- Floating platforms
        {x = 100, y = 450, width = 150, height = 40},
        {x = 300, y = 350, width = 100, height = 40},
        {x = 450, y = 400, width = 200, height = 40},
        {x = 550, y = 250, width = 150, height = 40},
        
        -- Side walls
        {x = -40, y = 0, width = 40, height = 600},
        {x = 800, y = 0, width = 40, height = 600}
    }
    
    -- Platform quad for drawing (using green platform sprite from sheet)
    -- Each platform is 64x16 pixels
    self.platformQuad = love.graphics.newQuad(0, 0, 64, 16, self.platformImage:getDimensions())
    
    return self
end

function Level:draw()
    -- Draw each platform
    for _, platform in ipairs(self.platforms) do
        -- Draw platform texture (tiled)
        love.graphics.setColor(1, 1, 1, 1)
        
        -- Set scissor to clip drawing to platform bounds
        love.graphics.setScissor(platform.x, platform.y, platform.width, platform.height)
        
        local tileWidth = 64
        local tileHeight = 16
        local tilesX = math.ceil(platform.width / tileWidth)
        local tilesY = math.ceil(platform.height / tileHeight)
        
        for tx = 0, tilesX - 1 do
            for ty = 0, tilesY - 1 do
                love.graphics.draw(self.platformImage, self.platformQuad, 
                    platform.x + tx * tileWidth, 
                    platform.y + ty * tileHeight)
            end
        end
        
        -- Clear scissor
        love.graphics.setScissor()
    end
    
    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)
end

function Level:checkCollision(x, y, width, height)
    -- Check collision with all platforms
    for _, platform in ipairs(self.platforms) do
        if x < platform.x + platform.width and
           x + width > platform.x and
           y < platform.y + platform.height and
           y + height > platform.y then
            return true, platform
        end
    end
    return false, nil
end

function Level:resolveCollision(player)
    local px, py = player.x, player.y
    local pw, ph = player.width, player.height
    
    -- Check collision at new position
    local colliding, platform = self:checkCollision(px, py, pw, ph)
    
    if colliding then
        -- Calculate overlap on each axis
        local overlapLeft = (px + pw) - platform.x
        local overlapRight = (platform.x + platform.width) - px
        local overlapTop = (py + ph) - platform.y
        local overlapBottom = (platform.y + platform.height) - py
        
        -- Find smallest overlap
        local minOverlap = math.min(overlapLeft, overlapRight, overlapTop, overlapBottom)
        
        -- Resolve based on smallest overlap
        if minOverlap == overlapTop and player.velocity.y > 0 then
            -- Landing on top of platform
            player.y = platform.y - ph
            player.velocity.y = 0
            player.onGround = true
            player.isJumping = false
        elseif minOverlap == overlapBottom and player.velocity.y < 0 then
            -- Hitting platform from below
            player.y = platform.y + platform.height
            player.velocity.y = 0
        elseif minOverlap == overlapLeft then
            -- Hitting from the right
            player.x = platform.x - pw
            player.velocity.x = 0
        elseif minOverlap == overlapRight then
            -- Hitting from the left
            player.x = platform.x + platform.width
            player.velocity.x = 0
        end
    end
    
    -- Check if still on ground (platform below)
    local groundCheck = self:checkCollision(px, py + 1, pw, ph)
    if not groundCheck and player.onGround then
        player.onGround = false
    end
end

return Level
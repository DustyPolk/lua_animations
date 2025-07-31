local Player = require "player"
local UI = require "ui"
local Slime = require "slime"
local Level = require "level"

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    -- Create level
    level = Level.new()
    
    -- Create player instance
    player = Player.new(400, 100)
    
    -- Create slime instances on platforms
    greenSlime = Slime.new(175, 400, "green")
    purpleSlime = Slime.new(500, 350, "purple")
end

function love.update(dt)
    player:update(dt)
    
    -- Handle player-level collision
    level:resolveCollision(player)
    
    greenSlime:update(dt)
    purpleSlime:update(dt)
end

function love.draw()
    -- Draw level first (background)
    level:draw()
    
    -- Draw entities
    player:draw()
    greenSlime:draw()
    purpleSlime:draw()
    
    -- Draw UI on top
    UI.draw()
    UI.drawPlayerInfo(player)
end

function love.keypressed(key)
    player:keypressed(key)
end
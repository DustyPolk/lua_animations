local Player = require "player"
local UI = require "ui"

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    -- Create player instance
    player = Player.new(400, 300)
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    player:draw()
    UI.draw()
    UI.drawPlayerInfo(player)
end

function love.keypressed(key)
    player:keypressed(key)
end
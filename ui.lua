local UI = {}

function UI.draw()
    -- Display info
    love.graphics.print("Knight spritesheet: 256 x 256", 10, 10)
    love.graphics.print("Individual sprite size: 32x32", 10, 30)
    love.graphics.print("Grid: 8x8 sprites", 10, 50)
    love.graphics.print("Press SPACE to roll", 10, 70)
    love.graphics.print("Use WASD to move", 10, 90)
    love.graphics.print("Scaled 3x for visibility", 10, 110)
end

function UI.drawPlayerInfo(player)
    love.graphics.print("Facing: " .. (player.facingLeft and "Left" or "Right"), 10, 130)
end

return UI

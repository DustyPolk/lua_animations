local UI = {}

function UI.draw()
    -- Display controls
    love.graphics.print("Controls:", 10, 10)
    love.graphics.print("A/D: Move left/right", 10, 30)
    love.graphics.print("SPACE: Jump", 10, 50)
    love.graphics.print("SHIFT: Roll", 10, 70)
end

function UI.drawPlayerInfo(player)
    love.graphics.print("On Ground: " .. tostring(player.onGround), 10, 100)
    love.graphics.print("Velocity Y: " .. math.floor(player.velocity.y), 10, 120)
end

return UI

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Love2D game project featuring animated sprites using the anim8 library. The game currently implements a knight character with multiple animations (idle, walk, roll, hit, death) controlled by keyboard input.

## Running the Game

```bash
love .
```

## Architecture

The codebase follows a modular structure:

- **main.lua**: Entry point that initializes the game loop and delegates to player and UI modules
- **player.lua**: Player class implementing sprite animations, movement (WASD), and state management
- **ui.lua**: UI module for rendering on-screen information
- **libraries/anim8.lua**: Third-party animation library for sprite sheet management

## Key Implementation Details

### Animation System
- Uses anim8 library to manage sprite sheet animations
- Knight sprite sheet is 256x256 pixels with 32x32 individual sprites in an 8x8 grid
- Animations are row-based in the sprite sheet:
  - Row 1: Idle animation (frames 1-4)
  - Row 3: Walk animation (frames 1-8)  
  - Row 6: Roll animation (frames 1-8)
  - Row 7: Hit animation (frames 1-4)
  - Row 8: Death animation (frames 1-4)

### Player Movement
- WASD controls for 8-directional movement at 200 pixels/second
- Space bar triggers roll animation
- Sprite flipping based on movement direction (facingLeft flag)
- All sprites are scaled 3x for visibility

### State Management
- Player tracks: position (x,y), movement state (isMoving, isRolling), and facing direction
- Animation state machine switches between idle, walk, and roll animations based on input
- Roll animation plays to completion before returning to idle/walk state

## Asset Reference

### Sprite Sheets

**knight.png** (256x256, 32x32 sprites)
- Already implemented in player.lua
- 8x8 grid of character animations

**coin.png** (128x16, 16x16 sprites)
- 8 frames of spinning coin animation in a horizontal strip
```lua
local coinSheet = love.graphics.newImage("assets/coin.png")
local coinGrid = anim8.newGrid(16, 16, 128, 16)
local coinAnimation = anim8.newAnimation(coinGrid('1-8', 1), 0.1)
```

**fruit.png** (48x64, 16x16 sprites)
- 3x4 grid of different fruit sprites
- Static sprites, no animation frames
```lua
local fruitSheet = love.graphics.newImage("assets/fruit.png")
local fruitQuad = love.graphics.newQuad(0, 0, 16, 16, fruitSheet) -- Top-left fruit
```

**slime_green.png** (64x48, 16x16 sprites)
- 4x3 grid with slime animations
- Appears to have idle and movement frames
```lua
local slimeGreenSheet = love.graphics.newImage("assets/slime_green.png")
local slimeGrid = anim8.newGrid(16, 16, 64, 48)
local slimeIdleAnimation = anim8.newAnimation(slimeGrid('1-4', 1), 0.2)
```

**slime_purple.png** (64x48, 16x16 sprites)
- Same layout as green slime
```lua
local slimePurpleSheet = love.graphics.newImage("assets/slime_purple.png")
-- Use same grid setup as green slime
```

**platforms.png** (64x48, varies)
- Platform tiles in different colors
- Top row: 64x16 platforms
- Other rows: Various platform styles

**world_tileset.png** (256x256, 16x16 tiles)
- Comprehensive tileset for world building
- Includes terrain, decorations, objects
```lua
local tilesetImage = love.graphics.newImage("assets/world_tileset.png")
local tilesetGrid = anim8.newGrid(16, 16, 256, 256)
```

### Audio Assets

**Sound Effects:**
```lua
local coinSound = love.audio.newSource("assets/coin.wav", "static")
local explosionSound = love.audio.newSource("assets/explosion.wav", "static")
local hurtSound = love.audio.newSource("assets/hurt.wav", "static")
local jumpSound = love.audio.newSource("assets/jump.wav", "static")
local powerUpSound = love.audio.newSource("assets/power_up.wav", "static")
local tapSound = love.audio.newSource("assets/tap.wav", "static")
```

**Background Music:**
```lua
local bgMusic = love.audio.newSource("assets/time_for_adventure.mp3", "stream")
bgMusic:setLooping(true)
bgMusic:play()
```

### Fonts
```lua
local font = love.graphics.newFont("assets/PixelOperator8.ttf", 16)
local boldFont = love.graphics.newFont("assets/PixelOperator8-Bold.ttf", 16)
love.graphics.setFont(font)
```
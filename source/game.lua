import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/easing'

import 'utils'

local gfx <const> = playdate.graphics
local Timer <const> = playdate.timer

local rad <const> = math.rad
local cos <const> = math.cos
local sin <const> = math.sin

game = {}

local scoreImage = nil
local scoreSprite = nil

local circle1 = nil
local circle2 = nil

local oldCrankPosition = nil

game.blocks = nil
game.addTimer = nil


local randY = uniqueRandom(-2, 2)
local randR = uniqueRandom(0, 7)
local randH = uniqueRandom(0, 20)
local function addBlock()
  local y = 120 + 35 * randY()

  local imageHeight = nil
  local rotationBase = randR()
  if y == 120 and (rotationBase <= 2 or rotationBase >= 6) then
    imageHeight = 70
  else
    imageHeight = 80 + randH()
  end

  local image = gfx.image.new(20, imageHeight, gfx.kColorWhite)
  block = gfx.sprite.new(image)
  block:setRotation(rotationBase * 22.5)
  local width, height = block:getSize()
  block:setCollideRect(0, 0, width, height)
  block:moveTo(-200, y)
  block:add()

  local maxSpeedScore = 250
  local speedScore = nil
  if score > maxSpeedScore then
    speedScore = maxSpeedScore
  else
    speedScore = score
  end

  local duration = playdate.easingFunctions.outQuad(speedScore, 4500, -3500, maxSpeedScore)
  local timer = Timer.new(duration, -100, 500)

  game.blocks[#game.blocks + 1] = { sprite = block, timer = timer, y = y, endX = 400 + width / 2 }

  game.addTimer = Timer.new(duration / 3, addBlock)
end

local function updateScoreImage()
  gfx.pushContext(scoreImage)
    gfx.clear(gfx.kColorWhite)
    gfx.drawTextAligned('*Score: ' .. score .. '*', 50, 4, kTextAlignment.center)
  gfx.popContext()
end

local function increaseScoreBy(number)
  score += number
  updateScoreImage()
end

function game.show()
  gfx.sprite.removeAll()

  score = 0

  scoreImage = gfx.image.new(100, 25)
  updateScoreImage()
  scoreSprite = gfx.sprite.new(scoreImage)
  scoreSprite:moveTo(350, 12.5)
  scoreSprite:setZIndex(1)
  scoreSprite:add()

  game.blocks = { }
  addBlock()

  local circleImage = gfx.image.new(20, 20)
  gfx.pushContext(circleImage)
    gfx.fillCircleAtPoint(10, 10, 10)
  gfx.popContext()

  oldCrankPosition = nil
  circle1 = gfx.sprite.new(circleImage)
  circle2 = gfx.sprite.new(circleImage)
  game.updateCircles()
  circle1:setCollideRect(0, 0, circle1:getSize())
  circle2:setCollideRect(0, 0, circle2:getSize())
  circle1:add()
  circle2:add()

  gfx.sprite.setBackgroundDrawingCallback(
    function ()
      gfx.drawRect(0, 0, 400, 240)

      gfx.drawCircleAtPoint(330, 120, 51)
    end
  )

  gamestate = 'running'
end

function game.updateCircles()
  local crankPosition = playdate.getCrankPosition()
  if crankPosition ~= oldCrankPosition then
    local circle1Rad = rad(crankPosition - 90)
    circle1:moveTo(330 + (cos(circle1Rad) * 50), (120 + sin(circle1Rad) * 50))

    local circle2Rad = circle1Rad + math.pi
    circle2:moveTo(330 + (cos(circle2Rad) * 50), (120 + sin(circle2Rad) * 50))

    oldCrankPosition = crankPosition
  end
end

function game.update()
  game.updateCircles()

  local collided = false
  local removeBlock = nil
  for i = 1, #game.blocks do
    local block = game.blocks[i]
    if block.timer.value >= block.endX then
      block.sprite:remove()
      block.timer:remove()
      increaseScoreBy(1)
      removeBlock = i
    else
      local nextPos = block.timer.value
      if i == 1 then
        local x, y, collisions, length = block.sprite:checkCollisions(nextPos, block.y)
        if length > 0 then
          local collision = collisions[1]
          if (collision.other == circle1 or collision.other == circle2) and collision.sprite:alphaCollision(collision.other) then
            collided = true
            game.addTimer:remove()
            failscreen.show()
            break
          end
        end
      end

      block.sprite:moveTo(nextPos, block.y)
    end
  end

  if removeBlock ~= nil then
    table.remove(game.blocks, removeBlock)
  end

  if collided == false then
    gfx.sprite.update()
    playdate.timer.updateTimers()
  end
end

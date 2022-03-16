import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'

local gfx <const> = playdate.graphics
local Timer <const> = playdate.timer;

local rad <const> = math.rad
local cos <const> = math.cos
local sin <const> = math.sin

game = {}

local scoreImage = nil
local scoreSprite = nil

local circle1 = nil
local circle2 = nil

blocks = nil

local oldCrankPosition = nil

function updateScoreImage()
  gfx.pushContext(scoreImage)
    gfx.clear(gfx.kColorWhite)
    gfx.drawTextAligned('*Score: ' .. score .. '*', 50, 4, kTextAlignment.center)
  gfx.popContext()
end

function increaseScoreBy(number)
  score += number
  updateScoreImage()
end

function game.show()
  gfx.sprite.removeAll()

  score = 0

  scoreImage = gfx.image.new(100, 25);
  updateScoreImage()
  scoreSprite = gfx.sprite.new(scoreImage)
  scoreSprite:moveTo(350, 12.5)
  scoreSprite:add()

  local blockImage = gfx.image.new(20, 100, gfx.kColorWhite)
  block = gfx.sprite.new(blockImage)
  block:setRotation(45)
  local width, height = block:getSize()
  block:setCollideRect(0, 0, width, height)
  block:moveTo(-width, 70)
  block:add()

  local timer = Timer.new(3000, -width / 2, 400 + width / 2)

  blocks = { { sprite = block, timer = timer, y = 70 } }

  local block2 = block:copy()
  local timer2 = Timer.new(3000, -width / 2, 400 + width / 2)
  timer2.delay = 1500

  blocks[#blocks + 1] = { sprite = block2, timer = timer2, y = 70 }

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
  for i = 1, #blocks do
    local block = blocks[i]
    if block.timer.timeLeft == 0 then
      block.sprite:remove()
      block.timer:remove()
      increaseScoreBy(1)
      removeBlock = i
    else
      local nextPos = block.timer.value
      if i == 1 then
        local x, y, collisions, length = block.sprite:checkCollisions(nextPos, block.y)
        if length > 0 then
          local collision = collisions[1];
          if (collision.other == circle1 or collision.other == circle2) and collision.sprite:alphaCollision(collision.other) then
            collided = true
            failscreen.show()
            break
          end
        end
      end

      block.sprite:moveTo(nextPos, block.y)
    end
  end

  if removeBlock ~= nil then
    table.remove(blocks, removeBlock)
  end

  if collided == false then
    gfx.sprite.update()
    playdate.timer.updateTimers()
  end
end

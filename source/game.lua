import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

local gfx <const> = playdate.graphics

local rad <const> = math.rad
local cos <const> = math.cos
local sin <const> = math.sin

game = {}

local scoreImage = nil
local scoreSprite = nil

local circle1 = nil
local circle2 = nil

local block = nil
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

  local circleImage = gfx.image.new(20, 20)
  gfx.pushContext(circleImage)
    gfx.fillCircleAtPoint(10, 10, 10)
  gfx.popContext()

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

  if block.x > 400 then
    increaseScoreBy(1)
    block:moveTo(-20, 70)
  end

  local circleCollisiontest = circle1;
  local collisions = circleCollisiontest:overlappingSprites()
  if #collisions < 1 then
    circleCollisiontest = circle2
    collisions = circleCollisiontest:overlappingSprites()
  end
  local collided = false;
  if #collisions > 0 then
    if circleCollisiontest:alphaCollision(collisions[1]) then
      collided = true
    end
  end

  if collided == true then
    failscreen.show()
  else
    block:moveBy(2, 0)
    gfx.sprite.update()
  end
end
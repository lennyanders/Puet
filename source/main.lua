import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'

import 'startscreen'
import 'failscreen'
import 'highscores'

local gfx <const> = playdate.graphics
local rad <const> = math.rad;
local cos <const> = math.cos;
local sin <const> = math.sin;

gamestate = nil
score = 0

local scoreImage = nil
local scoreSprite = nil

local circle1 = nil
local circle2 = nil

local block = nil

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

function init()
  playdate.display.setRefreshRate(50)
  gfx.setColor(gfx.kColorWhite)
  gfx.setBackgroundColor(gfx.kColorBlack)

  local menu = playdate.getSystemMenu()
  menu:addMenuItem("Highscores", highscores.show)

  startscreen.show()
end

function startGame()
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
  circle1:moveTo(330, 170)
  circle1:setCollideRect(0, 0, circle1:getSize())
  circle1:add()

  circle2 = gfx.sprite.new(circleImage)
  circle2:moveTo(330, 70)
  circle2:setCollideRect(0, 0, circle2:getSize())
  circle2:add()

  gfx.sprite.setBackgroundDrawingCallback(
    function ()
      gfx.drawRect(0, 0, 400, 240)

      gfx.drawCircleAtPoint(330, 120, 51)
    end
  )

  gamestate = "running"
end

init()


local oldCrankPosition = 0

function playdate.update()
  if gamestate == "startmenu" then
    if playdate.buttonJustPressed(playdate.kButtonA) then
      startGame()
    end
  elseif gamestate == 'highscores' then
    if playdate.buttonJustPressed(playdate.kButtonB) then
      startscreen.show()
    end
  elseif gamestate == 'failscreen' then
    if playdate.buttonJustPressed(playdate.kButtonA) then
      startGame()
    elseif playdate.buttonJustPressed(playdate.kButtonB) then
      startscreen.show()
    end
  elseif gamestate == "running" then
    local crankPosition = playdate.getCrankPosition()
    if crankPosition ~= oldCrankPosition then
      local circle1Rad = rad(crankPosition - 90)
      circle1:moveTo(330 + (cos(circle1Rad) * 50), (120 + sin(circle1Rad) * 50))

      local circle2Rad = circle1Rad + math.pi;
      circle2:moveTo(330 + (cos(circle2Rad) * 50), (120 + sin(circle2Rad) * 50))

      oldCrankPosition = crankPosition
    end

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
    end

    if collided == false then
      block:moveBy(2, 0)
    end
  end

  gfx.sprite.update()

	playdate.drawFPS()
end

import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/crank'

import 'startscreen'
import 'failscreen'
import 'highscores'
import 'countdown'
import 'game'

local gfx <const> = playdate.graphics

gamestate = nil
score = 0

local scoreImage = nil
local scoreSprite = nil

circle1 = nil
circle2 = nil

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

  gamestate = "running"
end

init()

function playdate.update()
  if gamestate == "startmenu" then
    if playdate.buttonJustPressed(playdate.kButtonA) then
      startGame()
    end
  elseif gamestate == 'highscores' then
    if playdate.buttonJustPressed(playdate.kButtonB) then
      startscreen.show()
    else
      local crankticks = playdate.getCrankTicks(8);
      if crankticks == 1 or playdate.buttonJustPressed(playdate.kButtonDown) then
        highscores.listview:selectNextRow()
      elseif crankticks == -1 or playdate.buttonJustPressed(playdate.kButtonUp) then
        highscores.listview:selectPreviousRow()
      elseif highscores.listview.isScrolling == false then
        if playdate.buttonIsPressed(playdate.kButtonDown) then
          highscores.listview:selectNextRow()
        elseif playdate.buttonIsPressed(playdate.kButtonUp) then
          highscores.listview:selectPreviousRow()
        end
      end
    end

    if highscores.listview.needsDisplay == true then
      highscores.listview:drawInRect(20, 42, 360, 197)
      playdate.timer:updateTimers()
    end
  elseif gamestate == 'failscreen' then
    if playdate.buttonJustPressed(playdate.kButtonA) then
      startGame()
    elseif playdate.buttonJustPressed(playdate.kButtonB) then
      startscreen.show()
    end
  elseif gamestate == 'countdown' then
    game.updateCircles()
    gfx.sprite.update()
    playdate.timer:updateTimers()
  elseif gamestate == 'running' then
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

	playdate.drawFPS()
end

function playdate.gameWillResume()
  if gamestate == 'running' then
    countdown.show()
  end
end

function playdate.deviceDidUnlock()
  if gamestate == 'running' then
    countdown.show()
  end
end

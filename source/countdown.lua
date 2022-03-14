import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'

local gfx <const> = playdate.graphics

countdown = {}

function countdown.show()
  local countImage = gfx.image.new(100, 100)
  local countSprite = gfx.sprite.new(countImage)
  countSprite:moveTo(200, 120)
  countSprite:add()

  local count = 3;
  playdate.timer.keyRepeatTimerWithDelay(1000, 1000,
    function (timer)
      if count == 0 then
        timer:remove()
        countSprite:remove()
        gamestate = 'running'
      else
        gfx.pushContext(countImage)
          gfx.clear(gfx.kColorClear)
          gfx.fillCircleAtPoint(50, 50, 50)
          gfx.drawTextAligned('*' .. count .. '*', 50, 43, kTextAlignment.center)
        gfx.popContext()

        count -= 1
      end
    end
  )

  gamestate = 'countdown'
end

function countdown.update()
  game.updateCircles()
  gfx.sprite.update()
  playdate.timer:updateTimers()
end

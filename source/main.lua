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

function init()
  playdate.display.setRefreshRate(50)
  gfx.setColor(gfx.kColorWhite)
  gfx.setBackgroundColor(gfx.kColorBlack)

  local menu = playdate.getSystemMenu()
  menu:addMenuItem("Highscores", highscores.show)

  startscreen.show()
end

init()

function playdate.update()
  if gamestate == "startmenu" then
    startscreen.update()
  elseif gamestate == 'highscores' then
    highscores.update()
  elseif gamestate == 'failscreen' then
    failscreen.update()
  elseif gamestate == 'countdown' then
    countdown.update()
  elseif gamestate == 'running' then
    game.update()
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

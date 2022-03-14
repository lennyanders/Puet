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
    if playdate.buttonJustPressed(playdate.kButtonA) then
      game.show()
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

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
local ds <const> = playdate.datastore

gamestate = nil
score = 0

local fpsMap = { ["30"] = 30, ["50"] = 50, ["Unlimited"] = 0 }

function setFps(option)
  playdate.display.setRefreshRate(fpsMap[option])
end

function setAndSaveFps(option)
  setFps(option)
  ds.write(option, 'fps')
end

function init()
  local fps = ds.read('fps')
  if fps == nil then
    fps = "50"
  end
  setFps(fps)

  gfx.setColor(gfx.kColorWhite)
  gfx.setBackgroundColor(gfx.kColorBlack)

  local menu = playdate.getSystemMenu()
  menu:addMenuItem("Highscores", highscores.show)
  menu:addOptionsMenuItem("FPS", { "30", "50", "Unlimited" }, fps, setAndSaveFps)

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

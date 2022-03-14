import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/ui'

local gfx <const> = playdate.graphics
local ds <const> = playdate.datastore

highscores = {}

local listview = nil;

function highscores.show()
  gfx.clear()
  gfx.sprite.removeAll()

  local scores = ds.read('scores')
  if scores == nil then
    scores = { 0 }
  end

  gfx.drawRect(0, 0, 400, 240)

  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  gfx.drawText('*Highscores*', 28, 20)
  gfx.setImageDrawMode(gfx.kDrawModeCopy)

  listview = playdate.ui.gridview.new(0, 25)
  listview:setNumberOfRows(#scores)

  function listview:drawCell(section, row, column, selected, x, y, width, height)
    if selected == false then
      gfx.setColor(gfx.kColorBlack)
      gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    end

    gfx.fillRect(x, y, width, height)
    gfx.drawText(string.format("%02d", row) .. '. *' .. scores[row] .. '*', x + 8, y + 4)

    gfx.setColor(gfx.kColorWhite)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
  end

  gamestate = "highscores"
end

function highscores.update()
  if playdate.buttonJustPressed(playdate.kButtonB) then
    startscreen.show()
  else
    local crankticks = playdate.getCrankTicks(8);
    if crankticks == 1 or playdate.buttonJustPressed(playdate.kButtonDown) then
      listview:selectNextRow()
    elseif crankticks == -1 or playdate.buttonJustPressed(playdate.kButtonUp) then
      listview:selectPreviousRow()
    elseif listview.isScrolling == false then
      if playdate.buttonIsPressed(playdate.kButtonDown) then
        listview:selectNextRow()
      elseif playdate.buttonIsPressed(playdate.kButtonUp) then
        listview:selectPreviousRow()
      end
    end
  end

  if listview.needsDisplay == true then
    listview:drawInRect(20, 42, 360, 197)
    playdate.timer:updateTimers()
  end
end

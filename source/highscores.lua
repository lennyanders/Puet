import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/ui'

local gfx <const> = playdate.graphics
local ds <const> = playdate.datastore

highscores = {}

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

  local listview = playdate.ui.gridview.new(0, 25)
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

  highscores.listview = listview

  gamestate = "highscores"
end

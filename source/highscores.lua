import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'

local gfx <const> = playdate.graphics
local ds <const> = playdate.datastore

highscores = {}

function highscores.show()
  gfx.sprite.removeAll()

  local scores = ds.read('scores')
  if scores == nil then
    scores = { 0 }
  end

  gfx.sprite.setBackgroundDrawingCallback(
    function ()
      gfx.drawRect(0, 0, 400, 240)

      gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
      gfx.drawText('*Your highscores:', 20, 20)
      for i = 1, #scores do
        gfx.drawText(string.format("%02d", i) .. '. *' .. scores[i] .. '*', 20, 20 + i * 25)
      end
      gfx.setImageDrawMode(gfx.kDrawModeCopy)
    end
  )

  gamestate = "highscores"
end

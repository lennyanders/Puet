import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'

local gfx <const> = playdate.graphics
local ds <const> = playdate.datastore

failscreen = {}

function failscreen.show()
  gfx.clear()
  gfx.sprite.removeAll()

  gfx.drawRect(0, 0, 400, 240)

  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  gfx.drawTextAligned('*You got ' .. score .. ' points!*', 200, 80, kTextAlignment.center)
  gfx.drawTextAligned('*Press* Ⓐ *to start a new game*', 200, 120, kTextAlignment.center)
  gfx.setImageDrawMode(gfx.kDrawModeCopy)

  local scores = ds.read('scores')
  if scores == nil then
    scores = { score }
  else
    scores[#scores + 1] = score
    table.sort(scores,
      function (a, b)
        return a > b
      end
    )
  end
  ds.write({ table.unpack(scores, 1, 99) }, 'scores')

  gamestate = "failscreen"
end

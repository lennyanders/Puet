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

  local sOrNot = '';
  if score ~= 1 then sOrNot = 's' end

  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  gfx.drawTextAligned('*You got ' .. score .. ' point' .. sOrNot .. '!*', 200, 80, kTextAlignment.center)
  gfx.drawTextAligned('*Press* Ⓐ *to start a new game*', 200, 120, kTextAlignment.center)
  gfx.setImageDrawMode(gfx.kDrawModeCopy)

  local scores = ds.read('scores')
  if scores == nil then
    scores = { score }
  else
    scores[#scores + 1] = score

    -- remove duplicate entries
    local hash = {}
    local uniqueScores = {}
    for _, v in ipairs(scores) do
      if not hash[v] then
        uniqueScores[#uniqueScores + 1] = v
        hash[v] = true
      end
    end

    -- sort scores
    table.sort(uniqueScores,
      function (a, b)
        return a > b
      end
    )

    -- trim scores to the max count of 99
    scores = { table.unpack(uniqueScores, 1, 99) }
  end

  ds.write(scores, 'scores')

  gamestate = "failscreen"
end

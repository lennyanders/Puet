import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'

local gfx <const> = playdate.graphics

startscreen = {}

function startscreen.show()
  gfx.sprite.removeAll()
  gfx.clear()

  gfx.drawRect(0, 0, 400, 240)

  gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
  gfx.drawTextAligned('*Press* Ⓐ *to start the game*', 200, 120, kTextAlignment.center)
  gfx.setImageDrawMode(gfx.kDrawModeCopy)

  gamestate = "startmenu"
end

import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'

local gfx <const> = playdate.graphics

local rad <const> = math.rad
local cos <const> = math.cos
local sin <const> = math.sin

game = {}

local oldCrankPosition = nil

function game.updateCircles()
  local crankPosition = playdate.getCrankPosition()
  if crankPosition ~= oldCrankPosition then
    local circle1Rad = rad(crankPosition - 90)
    circle1:moveTo(330 + (cos(circle1Rad) * 50), (120 + sin(circle1Rad) * 50))

    local circle2Rad = circle1Rad + math.pi
    circle2:moveTo(330 + (cos(circle2Rad) * 50), (120 + sin(circle2Rad) * 50))

    oldCrankPosition = crankPosition
  end
end

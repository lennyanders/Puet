function uniqueRandom(m, n)
  local val = nil

  local function random()
    local newVal = math.random(m, n)
    if newVal == val then
      return random()
    else
      val = newVal
      return val
    end
  end

  return random
end

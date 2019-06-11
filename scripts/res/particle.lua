-- Command line was: E:\github\dhgametool\scripts\res\particle.lua 

local particle = {}
require("common.const")
require("common.func")
local view = require("common.view")
local path = "particles/"
particle.create = function(l_1_0)
  local p = CCParticleSystemQuad:create(string.format("%s%s.plist", path, l_1_0))
  return p
end

return particle


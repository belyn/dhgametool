-- Command line was: E:\github\dhgametool\scripts\common\basesdkcfg.lua 

local cfg = {}
local cjson = json
require("common.func")
require("common.const")
local netClient = require("net.netClient")
local i18n = require("res.i18n")
local player = require("data.player")
local userdata = require("data.userdata")
cfg.jsonEncode = function(l_1_0)
  print("--------------------------before jsonEncode--------------------")
  local ret = cjson.encode(l_1_0)
  print("--------------------------after jsonEncode--------------------")
  print("ret:", ret)
  return ret
end

cfg.jsonDecode = function(l_2_0)
  print("--------------------------before jsonDecode--------------------")
  print("ret:", l_2_0)
  local ret = cjson.decode(l_2_0)
  print("--------------------------after jsonDecode--------------------")
  return ret
end

return cfg


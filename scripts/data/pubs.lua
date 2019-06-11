-- Command line was: E:\github\dhgametool\scripts\data\pubs.lua 

local pubs = {}
local cjson = json
local i18n = require("res.i18n")
local userdata = require("data.userdata")
local DELIMITER = "|||||"
pubs.init = function()
  local s = userdata.getString(userdata.keys.notice)
  local ss = string.split(s, DELIMITER)
  if #ss == 3 then
    local l = tonumber(ss[1], 10)
    local v = tonumber(ss[2], 10)
    local p = ss[3]
    local c = i18n.getCurrentLanguage()
    if l and v and p ~= "" and l == c then
      pubs.language = l
      pubs.vsn = v
      pubs.pub = p
      return true
    end
  end
  return false
end

pubs.getPub = function()
  if pubs.pub or pubs.init() then
    local tpub = cjson.decode(pubs.pub)
    if tpub and tpub.pub then
      return tpub.pub
    end
  end
  return {}
end

pubs.save = function(l_3_0, l_3_1, l_3_2)
  pubs.language = l_3_0
  pubs.vsn = l_3_1
  pubs.pub = l_3_2
  local s = table.concat({l_3_0, l_3_1, l_3_2}, DELIMITER)
  userdata.setString(userdata.keys.notice, s)
end

pubs.print = function()
  print("----- pubs ----- {")
  print("language", pubs.language)
  print("vsn", pubs.vsn)
  print("pub", pubs.pub)
  print("----- pubs ----- }")
end

return pubs


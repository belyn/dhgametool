-- Command line was: E:\github\dhgametool\scripts\fight\base\video.lua 

local ui = {}
require("common.const")
require("common.func")
local view = require("common.view")
local audio = require("res.audio")
local cfghero = require("config.hero")
local cfgbuff = require("config.buff")
local cfgskill = require("config.skill")
local fHelper = require("fight.helper.fx")
local hHelper = require("fight.helper.hero")
local bHelper = require("fight.helper.buff")
local userdata = require("data.userdata")
local player = require("data.player")
local TYPE_NORMAL = 1
local TYPE_CRIT = 2
local TYPE_MISS = 3
local BUFF_ON = 1
local BUFF_OFF = 2
local BUFF_WORK = 3
local BUFF_ON_WORK = 0
local EP_SELF = 50
local EP_HURT = 10
local EP_CRIT = 20
local REVIVE_ID = bHelper.id(BUFF_REVIVE)
local REVIVE_DEAD_ID = 2030
local REVIVE_DEAD_ID2 = 2033
local ENERGY_ID = bHelper.id(BUFF_ENERGY)
local director = CCDirector:sharedDirector()
local addResumeBtn = function(l_1_0)
  print("-------------addResumeBtn----------")
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
  l_1_0:addChild(layer, 10000000000)
end

local backgroundListener = function(l_2_0)
  if require("data.tutorial").exists() then
    return 
  end
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    return 
  end
  if device.platform == "android" then
    require("res.audio").pauseBackgroundMusic()
    pauseSchedulerAndActions(director:getRunningScene())
  end
end

local foregroundListener = function(l_3_0)
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
    require("res.audio").pauseBackgroundMusic()
    addResumeBtn(director:getRunningScene())
  end
end

ui.create = function(l_4_0)
  local layer = CCLayer:create()
  fHelper.addBox(layer)
  fHelper.addBackgroundListner(layer, backgroundListener)
  fHelper.addForegroundListner(layer, foregroundListener)
  local onExit = function()
    fHelper.removeBackAndForegroundListener(layer)
   end
  layer:registerScriptHandler(function(l_2_0)
    if l_2_0 == "enter" then
      do return end
    end
    if l_2_0 == "exit" then
      onExit()
    end
   end)
  layer.getVideoAndUnits = function()
    assert(false, "Must override function getVideoAndUnits()")
   end
  local video, attackers, defenders, units = nil, nil, nil, nil
  layer.startFight = function()
    video, upvalue_512, upvalue_1024 = layer.getVideoAndUnits()
    video = ui.decodeVideo(video)
    fHelper.addCampBuff(layer, attackers, defenders)
    table.sort(attackers, function(l_1_0, l_1_1)
      return l_1_0.pos < l_1_1.pos
      end)
    table.sort(defenders, function(l_2_0, l_2_1)
      return l_2_0.pos < l_2_1.pos
      end)
    upvalue_3072 = arraymerge(attackers, defenders)
    for _,unit in ipairs(units) do
      fHelper.addUnit(layer, unit)
    end
    if video.atk and video.atk.pet then
      fHelper.addPet(layer, video.atk.pet, "attacker")
    end
    if video.def and video.def.pet then
      fHelper.addPet(layer, video.def.pet, "defender")
    end
    layer.showAllUnits()
   end
  layer.showAllUnits = function()
    for i,unit in ipairs(units) do
      local t = fHelper.playUnitComeIn(unit)
      if i ==  units then
        schedule(layer, t, function()
        layer.nextFrame()
         end)
      end
    end
   end
  local processSpecialEp = function(l_6_0)
    for pos,ep in pairs(l_6_0.ep) do
      local unit = layer.findByPos(units, pos)
      if unit then
        unit.ep = ep
        unit.epFg.scalePercentageOnly(unit.ep)
        unit.epFg:setVisible(unit.ep < 100)
        unit.epFull:setVisible(unit.ep >= 100)
      end
    end
   end
  local index = 0
  layer.nextFrame = function()
    index = index + 1
    ui.printVideo(video, index, index)
    local frame = video.frames[index]
    layer.onVideoFrame(frame)
    if frame.pos == 0 then
      fHelper.addPetEpDelta(layer, 20)
      local anyDead = false
      local anyRevive = layer.anyRevive(frame)
      local tDead, tRevive = 0.3, 0.8
      anyDead = layer.processActionBuffs(frame)
      processSpecialEp(frame)
      local tCheck = op3(anyRevive, op3(anyDead, tDead + tRevive, tRevive), 0)
      tCheck = tCheck + 0.5
      schedule(layer, tCheck, layer.checkWin)
      return 
    end
    local tPet = 0
    local actor = nil
    if frame.pos == 13 then
      actor = clone(layer.findAnyUnit(units, "attacker"))
      actor.pet = true
      actor.skin = nil
      tPet = fHelper.playPetAppearance(layer, "attacker")
    elseif frame.pos == 14 then
      actor = clone(layer.findAnyUnit(units, "defender"))
      actor.pet = true
      actor.skin = nil
      tPet = fHelper.playPetAppearance(layer, "defender")
    else
      actor = layer.findByPos(units, frame.pos)
    end
    if not tPet then
      tPet = 0
    end
    local actees1 = {}
    local actees2 = {}
    for _,pos in ipairs(frame.targets) do
      local actee = layer.findByPos(units, pos)
      actees1[ actees1 + 1] = actee
    end
    for _,pos in ipairs(frame.targets2) do
      local actee = layer.findByPos(units, pos)
      actees2[ actees2 + 1] = actee
    end
    if frame.action == actor.atkId then
      local miss = true
      for _,b in ipairs(frame.buffs) do
        if b.pos ~= frame.pos and b.hp and b.value and b.value < 0 then
          miss = false
      else
        end
      end
      if not miss then
        actor.ep = actor.ep + EP_SELF
      else
        if frame.action == cfghero[actor.heroId].actSkillId then
          actor.ep = 0
          actor.epFg.setPercentageOnly(0)
          actor.epFg:setVisible(true)
          actor.epFull:setVisible(false)
        end
      end
    end
    local tActor, tNext, tFxHurt = 0, 0, 0
    schedule(layer, tPet, function()
      tActor, upvalue_512, upvalue_1024 = fHelper.playActor(layer, actor, frame.action, actees1, actees2), layer, actor
      tActor = tActor + tPet
      upvalue_512 = tNext + tPet
      schedule(layer, tActor, function()
        if frame.pos < 13 then
          actor.epFg.scalePercentageOnly(actor.ep)
          actor.epFg:setVisible(actor.ep < 100)
          actor.epFull:setVisible(actor.ep >= 100)
          if frame.action == cfghero[actor.heroId].actSkillId and frame.pos < 7 then
            fHelper.addPetEpDelta(layer, 10)
          else
            if frame.pos == 13 then
              fHelper.updatePetEp(layer, 0)
            end
          end
        end
        processSpecialEp(frame)
        layer.processActionBuffs(frame)
        schedule(layer, tNext, layer.checkWin)
         end)
      end)
   end
  layer.onVideoFrame = function(l_8_0)
   end
  layer.processActionBuffs = function(l_9_0)
    local anyDead = false
    do
      local actor = nil
      if l_9_0.pos == 13 then
        actor = clone(layer.findAnyUnit(units, "attacker"))
        actor.pet = true
        actor.skin = nil
      elseif l_9_0.pos == 14 then
        actor = clone(layer.findAnyUnit(units, "defender"))
        actor.pet = true
        actor.skin = nil
      else
        actor = layer.findByPos(units, l_9_0.pos)
      end
      for _,b in ipairs(l_9_0.buffs) do
        if b.buff ~= REVIVE_ID then
          local result = {}
          result.value = b.value
          if b.buffon == BUFF_ON then
            result.on = true
          else
            if b.buffon == BUFF_OFF then
              result.off = true
            else
              if b.buffon == BUFF_WORK then
                result.work = true
              else
                if b.buffon == BUFF_ON_WORK then
                  result.onwork = true
                end
              end
            end
          end
          if b.type == TYPE_CRIT then
            result.crit = true
          else
            if b.type == TYPE_MISS then
              result.miss = true
            end
          end
          local actee = layer.findByPos(units, b.pos)
          local isDmg = bHelper.isDmgId(b.buff)
          local isDot = bHelper.isDotId(b.buff)
          local isHeal = bHelper.isHealId(b.buff)
          if actor and not actor.pet and isDmg and hHelper.groupRestraint(actor, actee) then
            result.groupRestraint = true
          end
          if ((not isDmg and not isHeal) or not b.hp and result.miss and l_9_0.action) then
            fHelper.playActee(layer, actor, actee, l_9_0.action, b.buff, result.miss)
          end
          if result.on or result.onwork then
            bHelper.add(actee, b.buff, result.value)
          elseif result.off then
            bHelper.del(actee, b.buff, result.value)
            if bHelper.isImpressId(b.buff) then
              local _b_id = bHelper.id(cfgbuff[b.buff].name .. "B")
              if _b_id then
                fHelper.playBuffWork(layer, _b_id, actee)
              end
            end
          end
          if result.work or result.onwork or isDot then
            fHelper.playBuffWork(layer, b.buff, actee)
          end
          if (b.hp and b.value) or result.miss then
            fHelper.recordDamageNumber(actee, result)
          end
          if b.hp then
            actee.hp = b.hp
            actee.hpFx.scalePercentageOnly(b.hp)
            if b.value and b.value > 0 then
              actee.hpFg.scalePercentageOnly(b.hp)
            else
              actee.hpFg.setPercentageOnly(b.hp)
            end
          end
          if isDmg and b.hp and b.value and not result.miss and not l_9_0.ep[b.pos] then
            if cfgbuff[b.buff].name == BUFF_ADD_HURT then
              do return end
            end
            if result.crit then
              actee.ep = actee.ep + EP_CRIT
            else
              actee.ep = actee.ep + EP_HURT
            end
            actee.epFg.scalePercentageOnly(actee.ep)
            actee.epFg:setVisible(actee.ep < 100)
            actee.epFull:setVisible(actee.ep >= 100)
          end
          if b.hp == 0 then
            anyDead = true
            bHelper.clear(actee)
            fHelper.playDead(actee, layer.keepCorpse(b.pos))
            if layer.keepCorpse(b.pos) then
              local r_d_id = REVIVE_DEAD_ID
              if actee and actee.id and (actee.id == 5603 or actee.id == 65613) then
                r_d_id = REVIVE_DEAD_ID
              end
              do
                local fx, tDead = fHelper.play(layer, r_d_id, actee)
                actee.revive_fx = fx
              end
              for _,b in (for generator) do
              end
              if b.buff == REVIVE_ID and b.buffon == BUFF_WORK then
                local actee = layer.findByPos(units, b.pos)
                bHelper.del(actee, REVIVE_ID)
                fHelper.playRevive(layer, actee)
                actee.hp = b.hp
                actee.ep = 0
                actee.hpFg.setPercentageOnly(b.hp)
                actee.hpFx.setPercentageOnly(b.hp)
                actee.epFg.setPercentageOnly(0)
                actee.epFg:setVisible(true)
                actee.epFull:setVisible(false)
              end
            end
          end
        end
        for _,u in ipairs(units) do
          fHelper.playAllDamageNumbers(layer, u)
        end
        for _,u in ipairs(units) do
          fHelper.refreshBuffIcons(u)
          fHelper.clearBuffOff(u)
        end
        return anyDead
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer.processRevive = function(l_10_0)
    for _,b in ipairs(l_10_0.buffs) do
      if b.buff == REVIVE_ID and b.buffon == BUFF_WORK then
        local actee = layer.findByPos(units, b.pos)
        bHelper.del(actee, REVIVE_ID)
        fHelper.playRevive(layer, actee)
        actee.hp = b.hp
        actee.ep = 0
        actee.hpFg.setPercentageOnly(b.hp)
        actee.hpFx.setPercentageOnly(b.hp)
        actee.epFg.setPercentageOnly(0)
        actee.epFg:setVisible(true)
        actee.epFull:setVisible(false)
      end
    end
   end
  layer.anyRevive = function(l_11_0)
    for _,b in ipairs(l_11_0.buffs) do
      if b.buff == REVIVE_ID and (b.buffon == BUFF_WORK or b.buffon == BUFF_ON_WORK) then
        return true
      end
    end
    return false
   end
  layer.keepCorpse = function(l_12_0)
    if index <  video.frames then
      for idx = index + 1,  video.frames do
        local frame = video.frames[idx]
        if frame.pos == l_12_0 and frame.action then
          return true
        end
        for _,b in ipairs(frame.buffs) do
          if l_12_0 == b.pos and b.buff == REVIVE_ID and (b.buffon == BUFF_WORK or b.buffon == BUFF_ON_WORK) then
            return true
          end
        end
      end
    end
    return false
   end
  layer.isTimeout = function()
    if  video.frames <= index then
      for _,attacker in ipairs(attackers) do
        if attacker.hp > 0 then
          return true
        end
      end
    end
    return false
   end
  layer.checkWin = function(l_14_0)
    if not l_14_0 then
      l_14_0 = 1
    end
    if  video.frames <= index then
      layer.isEnd = true
      if (type(video.win) == "boolean" and video.win) or type(video.win) == "number" and video.win > 0 then
        schedule(layer:getParent(), l_14_0, function()
        audio.stopBackgroundMusic()
        pauseSchedulerAndActions(layer)
        CCDirector:sharedDirector():getScheduler():setTimeScale(1)
        layer.onWin()
         end)
      else
        schedule(layer:getParent(), l_14_0, function()
        audio.stopBackgroundMusic()
        pauseSchedulerAndActions(layer)
        CCDirector:sharedDirector():getScheduler():setTimeScale(1)
        layer.onLose(layer.isTimeout())
         end)
      end
    else
      if not layer.isTestMode then
        layer.nextFrame()
      end
    end
   end
  layer.onWin = function()
    layer:addChild(require("fight." .. kind .. ".win").create(video), 1000)
   end
  layer.onLose = function(l_16_0)
    layer:addChild(require("fight." .. kind .. ".lose").create(video), 1000)
   end
  layer.canSkip = function()
    if player.vipLv() and player.vipLv() > 3 then
      return true
    elseif kind and string.endwith(kind, "rep") then
      return true
    elseif kind ~= "pve" and kind ~= "brave" and player.lv() < UNLOCK_FIGHT_SKIP_LEVEL then
      return false
    end
    return true
   end
  layer.onSkip = function()
    index =  video.frames
    layer.checkWin(0.1)
   end
  layer.findByPos = function(l_19_0, l_19_1)
    for _,u in ipairs(l_19_0) do
      if u.pos == l_19_1 then
        return u
      end
    end
   end
  layer.findAnyUnit = function(l_20_0, l_20_1)
    for _,u in ipairs(l_20_0) do
      if l_20_1 == "attacker" and u.pos < 7 then
        return u
        for _,u in (for generator) do
        end
        if l_20_1 == "defender" and u.pos > 6 then
          return u
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer.playBGM = function(l_21_0)
    schedule(layer, function()
      audio.playBackgroundMusic(music)
      end)
   end
  local testBtn = CCMenuItemFont:create("GO")
  testBtn:setScale(view.minScale)
  testBtn:setPosition(scalep(930, 100))
  testBtn:setVisible(false)
  local testMenu = CCMenu:createWithItem(testBtn)
  testMenu:setPosition(0, 0)
  layer:addChild(testMenu)
  layer.isTestMode = testBtn:isVisible()
  testBtn:registerScriptTapHandler(function()
    layer.nextFrame()
   end)
  CCDirector:sharedDirector():getScheduler():setTimeScale(fHelper.getCurFightSpeed())
  return layer
end

ui.decodeVideo = function(l_5_0)
  local v = clone(l_5_0)
  do
    if not v.frames then
      local bytesArray = {}
    end
    v.frames = {}
    for _,bytes in ipairs(bytesArray) do
       -- DECOMPILER ERROR: No list found. Setlist fails

    end
    ui.processVideoEnergy(v)
    return v
  end
   -- Warning: undefined locals caused missing assignments!
end

ui.decodeVideoFrame = function(l_6_0)
  local frame = {buffs = {}, targets = {}, targets2 = {}}
  frame.tid = bit.band(15, bit.brshift(l_6_0[1], 4))
  frame.pos = bit.band(15, l_6_0[1])
  do
    local i = 2
    if frame.pos ~= 0 then
      frame.action = l_6_0[2] * 256 + l_6_0[3]
      frame.targets, frame.targets2 = ui.decodeVideoTargets(l_6_0, 4, frame.pos, frame.action), l_6_0
      i = 6
    end
    repeat
      if i <  l_6_0 then
        local lens = {}
        local map = {1, 2, 3, 6}
        for _,n in ipairs({6, 4, 2, 0}) do
          lens[ lens + 1] = map[bit.band(3, bit.brshift(l_6_0[i], n)) + 1]
        end
        i = i + 1
        for _,len in ipairs(lens) do
          if i + len - 1 <=  l_6_0 then
            frame.buffs[ frame.buffs + 1] = ui.decodeVideoBuffs(l_6_0, i, len)
          end
          i = i + len
        end
      else
        return frame
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.decodeVideoTargets = function(l_7_0, l_7_1, l_7_2, l_7_3)
  local code = l_7_0[l_7_1] * 256 + l_7_0[l_7_1 + 1]
  local attackers, defenders = {}, {}
  for i = 0, 11 do
    if bit.band(2 ^ i, code) > 0 then
      if i + 1 <= 6 then
        attackers[ attackers + 1] = i + 1
      else
        defenders[ defenders + 1] = i + 1
      end
    end
  end
  if l_7_2 <= 6 or l_7_2 == 13 then
    return defenders, attackers
  else
    return attackers, defenders
  end
end

ui.decodeVideoBuffs = function(l_8_0, l_8_1, l_8_2)
  do
    local rt = {}
    if l_8_2 == 1 then
      rt.pos = bit.band(15, bit.brshift(l_8_0[l_8_1], 4))
      rt.type = bit.band(15, l_8_0[l_8_1])
    elseif l_8_2 == 2 then
      rt.pos = bit.band(15, bit.brshift(l_8_0[l_8_1], 4))
      local value = bit.band(15, l_8_0[l_8_1])
      if value == 0 then
        do return end
      end
      if value == 1 then
        rt.value = 1
      elseif value == 2 then
        rt.value = -1
      else
        assert(false, "Fatal: decodeVideoBuffs invalid value " .. value)
        return 
      end
      rt.buff = bit.band(63, bit.brshift(l_8_0[l_8_1 + 1], 2))
      rt.buffon = bit.band(3, l_8_0[l_8_1 + 1])
    elseif l_8_2 == 3 then
      rt.pos = bit.band(15, bit.brshift(l_8_0[l_8_1], 4))
      local value = l_8_0[l_8_1 + 1]
      rt.buff = bit.band(63, bit.brshift(l_8_0[l_8_1 + 2], 2))
      rt.buffon = bit.band(3, l_8_0[l_8_1 + 2])
      if rt.buff == ENERGY_ID then
        rt.ep = value
      else
        rt.hp = value
      end
    elseif l_8_2 == 6 then
      rt.pos = bit.band(15, bit.brshift(l_8_0[l_8_1], 4))
      rt.type = bit.band(15, l_8_0[l_8_1])
      local value = l_8_0[l_8_1 + 1] * 65536 + l_8_0[l_8_1 + 2] * 256 + l_8_0[l_8_1 + 3]
      rt.hp = l_8_0[l_8_1 + 4]
      rt.buff = bit.band(63, bit.brshift(l_8_0[l_8_1 + 5], 2))
      rt.buffon = bit.band(3, l_8_0[l_8_1 + 5])
      rt.value = value
      local bname = bHelper.name(rt.buff)
      if bHelper.isDmg(bname) or bHelper.isDot(bname) or bname == BUFF_BRIER or bHelper.isImpress(bname) then
        rt.value = not value
      else
        if bHelper.isImpressB(bname) then
          rt.value = not value
        else
          assert(false, "Fatal: decodeVideoBuffs invalid len " .. l_8_2)
          return 
        end
        return rt
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

ui.processVideoEnergy = function(l_9_0)
  for _,frame in ipairs(l_9_0.frames) do
    do
      frame.ep = {}
      arrayfilter(frame.buffs, function(l_1_0)
        if l_1_0.buff == ENERGY_ID then
          frame.ep[l_1_0.pos] = l_1_0.ep
          return false
        end
        return true
         end)
    end
  end
  return l_9_0
end

ui.printVideo = function(l_10_0, l_10_1, l_10_2)
  if not l_10_1 then
    l_10_1 = 1
  end
  if not l_10_2 then
    l_10_2 =  l_10_0.frames
  end
  cclog("video = {")
  cclog("    video_id:%s win:%s", tostring(l_10_0.video_id), tostring(l_10_0.win))
  cclog("    frames = {")
  for i = l_10_1, l_10_2 do
    local frame = l_10_0.frames[i]
    if not frame then
      return 
    end
    cclog("        frames[%d] = {", i)
    cclog("            tid:%s pos:%s action:%s targets:{%s} targets2:{%s} ep:{%s}", tostring(frame.tid), tostring(frame.pos), tostring(frame.action), table.concat(frame.targets, ","), table.concat(frame.targets2, ","), ui.getVideoEpString(frame))
    cclog("            buffs = {")
    for j,b in ipairs(frame.buffs) do
      cclog("                [%d] = pos:%s type:%s value:%s hp:%s buff:%s buffon:%s", j, tostring(b.pos), tostring(b.type), tostring(b.value), tostring(b.hp), tostring(b.buff), tostring(b.buffon))
    end
    cclog("            }")
    cclog("        }")
  end
  cclog("    }")
  cclog("}")
end

ui.getVideoEpString = function(l_11_0)
  local s = {}
  for pos,ep in pairs(l_11_0.ep) do
    s[ s + 1] = pos .. ":" .. ep
  end
  return table.concat(s, ", ")
end

return ui


-- Command line was: E:\github\dhgametool\scripts\ui\summon\info.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local particle = require("res.particle")
local net = require("net.netClient")
local gacha = require("data.gacha")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local cfgvip = require("config.vip")
local cfghero = require("config.hero")
local gemshop = require("ui.shop.main")
local cfgactivity = require("config.activity")
local achieveData = require("data.achieve")
local SUPERSUMMON = 250
local TENSUMMON = 2200
local aniSummonzhen = nil
ui.createInfo = function(l_1_0, l_1_1, l_1_2)
  local layer = ui.createLayer(l_1_2)
  if #l_1_0 == 1 then
    aniSummonzhen:playAnimation("animation_1")
  else
    aniSummonzhen:playAnimation("animation_10")
  end
  audio.play(audio.summon)
  local init = function()
    layer:addChild(ui.createHeroesShow(heroes, summonType, uiParams))
    schedule(layer, 2, function()
      require("data.christmas").onGetHeroes(heroes)
      end)
   end
  layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0), CCCallFunc:create(init)))
  return layer
end

ui.actHeroSummon10 = function(l_2_0)
  local activityData = require("data.activity")
  local IDS = activityData.IDS
  for i = 1, #l_2_0 do
    if cfghero[l_2_0[i].id].maxStar == 5 then
      local tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_1.ID)
      if cfghero[l_2_0[i].id].group == 2 then
        tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_2.ID)
      end
      if cfghero[l_2_0[i].id].group == 3 then
        tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_3.ID)
      end
      if cfghero[l_2_0[i].id].group == 4 then
        tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_4.ID)
      end
      if cfghero[l_2_0[i].id].group == 5 then
        tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_5.ID)
      end
      if cfghero[l_2_0[i].id].group == 6 then
        tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_6.ID)
      end
      if tmp_status and tmp_status.limits and tmp_status.limits < cfgactivity[tmp_status.id].parameter[1].num then
        tmp_status.limits = tmp_status.limits + 1
        local tmp_status7 = activityData.getStatusById(IDS.HERO_SUMMON_7.ID)
        if tmp_status.limits == cfgactivity[tmp_status.id].parameter[1].num and tmp_status7.limits < #cfgactivity[tmp_status7.id].parameter then
          tmp_status7.limits = tmp_status7.limits + 1
        end
      end
    end
  end
  schedule(CCDirector:sharedDirector():getRunningScene(), 2, function()
    require("data.christmas").onGetHeroes(heroes)
   end)
end

ui.checkGiftLimit = function(l_3_0)
  local activitylimit = require("data.activitylimit")
  local cfglimitgift = require("config.limitgift")
  for i = 1, #l_3_0 do
    if cfghero[l_3_0[i].id].qlt == 4 then
      local summon4_status = activitylimit.getStatusById(activitylimit.IDS.SUMMON_4.ID)
      if summon4_status == nil then
        activitylimit.summonNotice(4)
      elseif summon4_status.next and summon4_status.next + activitylimit.pull_time - os.time() <= 0 then
        activitylimit.summonNotice(4)
      end
    end
    if cfghero[l_3_0[i].id].qlt == 5 then
      local summon5_status = activitylimit.getStatusById(activitylimit.IDS.SUMMON_5.ID)
      if summon5_status == nil then
        activitylimit.summonNotice(5)
      elseif summon5_status.next and summon5_status.next + activitylimit.pull_time - os.time() <= 0 then
        activitylimit.summonNotice(5)
      end
    end
  end
end

ui.createHeroesShow = function(l_4_0, l_4_1, l_4_2)
  local layer = CCLayer:create()
  local initHeroCards = function()
    if ui.heroCards then
      ui.heroCards:removeFromParentAndCleanup(true)
      ui.heroCards = nil
    end
   end
  local powerBar = img.createUISprite(img.ui.summon_power_gauge)
  powerBar:setScale(view.minScale)
  powerBar:setPosition(scalep(480, 546))
  layer:addChild(powerBar)
  autoLayoutShift(powerBar)
  local detailSprite = img.createUISprite(img.ui.btn_help)
  local detailBtn = SpineMenuItem:create(json.ui.button, detailSprite)
  detailBtn:setScale(view.minScale)
  detailBtn:setPosition(scalep(930, 549))
  local detailMenu = CCMenu:create()
  detailMenu:setPosition(0, 0)
  layer:addChild(detailMenu)
  detailMenu:addChild(detailBtn)
  detailBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.help").create(i18n.global.help_summon.string), 1000)
   end)
  autoLayoutShift(detailBtn)
  local icon_gem = nil
  if l_4_1 == 9 or l_4_1 == 16 then
    icon_gem = img.createItemIcon2(ITEM_ID_LOVE)
  else
    icon_gem = img.createItemIcon2(ITEM_ID_GEM)
  end
  icon_gem:setPosition(CCPoint(8, powerBar:getContentSize().height / 2))
  powerBar:addChild(icon_gem)
  local btn_gem0 = img.createUISprite(img.ui.main_icon_plus)
  local btn_gem = HHMenuItem:create(btn_gem0)
  btn_gem:setPosition(CCPoint(138, powerBar:getContentSize().height / 2))
  local btn_gem_menu = CCMenu:createWithItem(btn_gem)
  btn_gem_menu:setPosition(CCPoint(0, 0))
  powerBar:addChild(btn_gem_menu)
  btn_gem:registerScriptTapHandler(function()
    audio.play(audio.button)
    local gemShop = gemshop.create()
    layer:getParent():addChild(gemShop, 1001)
   end)
  local gem_num = bag.gem()
  local lbl_gem = lbl.createFont2(16, gem_num, ccc3(255, 246, 223))
  lbl_gem:setPosition(CCPoint(74, powerBar:getContentSize().height / 2))
  powerBar:addChild(lbl_gem)
  lbl_gem.num = gem_num
  local love_num = bag.items.find(ITEM_ID_LOVE).num
  local lbl_love = lbl.createFont2(16, love_num, ccc3(255, 246, 223))
  lbl_love:setPosition(CCPoint(74, powerBar:getContentSize().height / 2))
  powerBar:addChild(lbl_love)
  lbl_love.num = gem_love
  if l_4_1 == 9 or l_4_1 == 16 then
    lbl_love:setVisible(true)
    lbl_gem:setVisible(false)
    btn_gem:setVisible(false)
  else
    lbl_love:setVisible(false)
    lbl_gem:setVisible(true)
    btn_gem:setVisible(true)
  end
  local updateLabels = function()
    local gemnum = bag.gem()
    if lbl_gem.num ~= gemnum then
      lbl_gem:setString(gemnum)
      lbl_gem.num = gemnum
    end
   end
  local onUpdate = function(l_5_0)
    updateLabels()
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  local helmet0 = img.createUISprite(img.ui.summon_helmet0)
  local helmetBtn0 = SpineMenuItem:create(json.ui.button, helmet0)
  helmetBtn0:setPosition(CCPoint(504, powerBar:getContentSize().height / 2 + 5))
  local helmetMenu = CCMenu:create()
  helmetMenu:setPosition(0, 0)
  powerBar:addChild(helmetMenu, 1101)
  helmetMenu:addChild(helmetBtn0)
  helmetBtn0:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.help").create(i18n.global.summon_help_enegy.string), 1000)
   end)
  json.load(json.ui.toukui)
  local aniSummontoukui = DHSkeletonAnimation:createWithKey(json.ui.toukui)
  aniSummontoukui:scheduleUpdateLua()
  aniSummontoukui:playAnimation("animation", -1)
  local toukuiSprite = CCSprite:create()
  toukuiSprite:setContentSize(CCSize(66, 53))
  aniSummontoukui:setPosition(CCPoint(toukuiSprite:getContentSize().width / 2, toukuiSprite:getContentSize().height / 2))
  toukuiSprite:addChild(aniSummontoukui)
  local helmetBtn = SpineMenuItem:create(json.ui.button, toukuiSprite)
  helmetBtn:setPosition(CCPoint(504, powerBar:getContentSize().height / 2 + 5))
  helmetBtn:setVisible(false)
  local helmetMenu = CCMenu:create()
  helmetMenu:setPosition(0, 0)
  powerBar:addChild(helmetMenu, 1001)
  helmetMenu:addChild(helmetBtn)
  json.load(json.ui.zhaohuan_nenglcao)
  local aniSummonnenglcao = DHSkeletonAnimation:createWithKey(json.ui.zhaohuan_nenglcao)
  aniSummonnenglcao:scheduleUpdateLua()
  aniSummonnenglcao:playAnimation("animation", -1)
  aniSummonnenglcao:setAnchorPoint(CCPoint(0.5, -1))
  aniSummonnenglcao:setPosition(CCPoint(325, powerBar:getContentSize().height / 2))
  aniSummonnenglcao:setVisible(false)
  powerBar:addChild(aniSummonnenglcao, 1000)
  local currentPower = bag.items.find(ITEM_ID_ENERGY).num
  if l_4_1 >= 4 and l_4_1 <= 6 then
    currentPower = currentPower - 10
  end
  if l_4_1 == 7 or l_4_1 == 8 then
    currentPower = currentPower - 100
  end
  local requiredPower = 1000
  if currentPower < requiredPower or cfgvip[player.vipLv()].gacha == nil then
    aniSummonnenglcao:setVisible(false)
    helmetBtn0:setVisible(true)
    helmetBtn:setVisible(false)
  else
    aniSummonnenglcao:setVisible(true)
    helmetBtn0:setVisible(false)
    helmetBtn:setVisible(true)
  end
  local progress0 = img.createUISprite(img.ui.summon_power_bar)
  local powerProgress = createProgressBar(progress0)
  powerProgress:setAnchorPoint(ccp(0, 0.5))
  powerProgress:setPosition(171, powerBar:getContentSize().height / 2 - 1)
  powerProgress:setPercentage((currentPower) / requiredPower * 100)
  powerBar:addChild(powerProgress)
  local progressStr = string.format("%d/%d", currentPower, requiredPower)
  local progressLabel = lbl.createFont2(16, progressStr, ccc3(255, 246, 223))
  progressLabel:setPosition(CCPoint(325, powerBar:getContentSize().height / 2 - 2))
  powerBar:addChild(progressLabel)
  helmetBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if cfgvip[player.vipLv()].heroes + player.buy_hlimit * 5 < #heros + 1 then
      local gotoHeroDlg = require("ui.summon.tipsdialog")
      gotoHeroDlg.show(layer)
      return 
    end
    local params = {}
    params.sid = player.sid
    params.type = 10
    local item = bag.items.find(ITEM_ID_ENERGY)
    local summonItemCount = 0
    if item then
      summonItemCount = item.num
    end
    addWaitNet()
    net:gacha(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      bag.items.sub({id = ITEM_ID_ENERGY, num = 1000})
      local infoLayer = require("ui.summon.info").createInfo(l_1_0.heroes, 10, uiParams)
      replaceScene(infoLayer)
      heros.addAll(l_1_0.heroes)
      ui.actHeroSummon10(l_1_0.heroes)
      ui.checkGiftLimit(l_1_0.heroes)
      end)
   end)
  local defineBtn1 = img.createLogin9Sprite(img.login.button_9_small_gold)
  defineBtn1:setPreferredSize(CCSize(174, 60))
  local defineLab = lbl.createFont1(18, i18n.global.summon_comfirm.string, ccc3(115, 59, 5))
  defineLab:setPosition(CCPoint(defineBtn1:getContentSize().width / 2, defineBtn1:getContentSize().height / 2))
  defineBtn1:addChild(defineLab)
  layer.defineBtn = SpineMenuItem:create(json.ui.button, defineBtn1)
  layer.defineBtn:setScale(view.minScale)
  layer.defineBtn:setVisible(false)
  layer.defineBtn:setAnchorPoint(CCPoint(0.5, 0.5))
  layer.defineBtn:setPosition(scalep(288, 124))
  local backEvent = function()
    audio.play(audio.button)
    replaceScene(require("ui.summon.main").create(uiParams))
   end
  layer.defineBtn:registerScriptTapHandler(function()
    backEvent()
   end)
  local summonMenu = CCMenu:create()
  summonMenu:setPosition(0, 0)
  layer:addChild(summonMenu)
  summonMenu:addChild(layer.defineBtn)
  layer.itemsummonBtn = nil
  layer.itemsummon10Btn = nil
  layer.gemsummonBtn = nil
  local setBtnvisit = function(l_10_0)
    if layer.itemsummonBtn then
      layer.itemsummonBtn:setVisible(l_10_0)
      if l_10_0 == true then
        layer.itemsummonBtn:setScale(0.5 * view.minScale)
        layer.itemsummonBtn:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
      end
    end
    if layer.itemsummon10Btn then
      layer.itemsummon10Btn:setVisible(l_10_0)
      if l_10_0 == true then
        layer.itemsummon10Btn:setScale(0.5 * view.minScale)
        layer.itemsummon10Btn:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
      end
    end
    if layer.gemsummonBtn then
      layer.gemsummonBtn:setVisible(l_10_0)
      if l_10_0 == true then
        layer.gemsummonBtn:setScale(0.5 * view.minScale)
        layer.gemsummonBtn:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
      end
    end
    layer.defineBtn:setVisible(l_10_0)
    if l_10_0 == true then
      layer.defineBtn:setScale(0.5 * view.minScale)
      layer.defineBtn:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
    end
   end
  if l_4_1 == 1 or l_4_1 == 2 or l_4_1 == 3 then
    local summon1 = img.createLogin9Sprite(img.login.button_9_small_gold)
    summon1:setPreferredSize(CCSize(174, 60))
    local item1 = img.createUISprite(img.ui.summon_item1)
    item1:setScale(0.9)
    item1:setPosition(CCPoint(30, summon1:getContentSize().height / 2 + 2))
    summon1:addChild(item1)
    local itemcountLable = lbl.createFont2(16, 1, ccc3(255, 246, 223))
    itemcountLable:setPosition(CCPoint(item1:getContentSize().width / 2, 5))
    item1:addChild(itemcountLable)
    local buyLab = lbl.createFont1(16, i18n.global.summon_buy.string, ccc3(115, 59, 5))
    buyLab:setPosition(CCPoint(summon1:getContentSize().width * 3 / 5, summon1:getContentSize().height / 2))
    summon1:addChild(buyLab)
    layer.itemsummonBtn = SpineMenuItem:create(json.ui.button, summon1)
    layer.itemsummonBtn:setScale(view.minScale)
    layer.itemsummonBtn:setPosition(scalep(480, 124))
    layer.itemsummonBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if cfgvip[player.vipLv()].heroes + player.buy_hlimit * 5 < #heros + 1 then
        local gotoHeroDlg = require("ui.summon.tipsdialog")
        gotoHeroDlg.show(layer)
        return 
      end
      local item = bag.items.find(ITEM_ID_GACHA)
      local summonItemCount = 0
      if item then
        summonItemCount = item.num
      end
      if summonItemCount <= 0 then
        showToast(i18n.global.summon_basic_lack.string)
        return 
      else
        paramsItem = {id = ITEM_ID_GACHA, num = 1}
      end
      local params = {}
      params.sid = player.sid
      params.type = 2
      addWaitNet()
      net:gacha(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        initHeroCards()
        bag.items.sub({id = ITEM_ID_GACHA, num = paramsItem.num})
        setBtnvisit(false)
        schedule(layer, 1, function()
          setBtnvisit(true)
            end)
        if #l_1_0.heroes == 1 then
          aniSummonzhen:playAnimation("animation_1_s")
        else
          aniSummonzhen:playAnimation("animation_10_s")
        end
        ui.heroCards = ui.createHeroesShowCards(l_1_0.heroes, summonType)
        layer:addChild(ui.heroCards, 1000)
        heros.addAll(l_1_0.heroes)
        ui.actHeroSummon10(l_1_0.heroes)
        if cfghero[l_1_0.heroes[1].id].maxStar == 5 then
          achieveData.add(ACHIEVE_TYPE_COMMONSUMMONFIVE, 1)
        end
        local task = require("data.task")
        task.increment(task.TaskType.BASIC_SUMMON)
         end)
      end)
    local summon2 = img.createLogin9Sprite(img.login.button_9_small_gold)
    summon2:setPreferredSize(CCSize(174, 60))
    local item2 = img.createUISprite(img.ui.summon_item1)
    item2:setScale(0.9)
    item2:setPosition(CCPoint(30, summon2:getContentSize().height / 2 + 2))
    summon2:addChild(item2)
    local itemcountLable2 = lbl.createFont2(16, 10, ccc3(255, 246, 223))
    itemcountLable2:setPosition(CCPoint(item2:getContentSize().width / 2, 5))
    item2:addChild(itemcountLable2)
    local buyLab2 = lbl.createFont1(16, i18n.global.summon_buy.string, ccc3(115, 59, 5))
    buyLab2:setPosition(CCPoint(summon2:getContentSize().width * 3 / 5, summon2:getContentSize().height / 2))
    summon2:addChild(buyLab2)
    layer.itemsummon10Btn = SpineMenuItem:create(json.ui.button, summon2)
    layer.itemsummon10Btn:setScale(view.minScale)
    layer.itemsummon10Btn:setPosition(scalep(672, 124))
    layer.itemsummon10Btn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if cfgvip[player.vipLv()].heroes + player.buy_hlimit * 5 < #heros + 10 then
        local gotoHeroDlg = require("ui.summon.tipsdialog")
        gotoHeroDlg.show(layer)
        return 
      end
      local item = bag.items.find(ITEM_ID_GACHA)
      local summonItemCount = 0
      if item then
        summonItemCount = item.num
      end
      if summonItemCount < 10 then
        showToast(i18n.global.summon_basic_lack.string)
        return 
      else
        paramsItem = {id = ITEM_ID_GACHA, num = 10}
      end
      local params = {}
      params.sid = player.sid
      params.type = 3
      addWaitNet()
      net:gacha(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        initHeroCards()
        bag.items.sub({id = ITEM_ID_GACHA, num = paramsItem.num})
        setBtnvisit(false)
        schedule(layer, 1, function()
          setBtnvisit(true)
            end)
        if #l_1_0.heroes == 1 then
          aniSummonzhen:playAnimation("animation_1_s")
        else
          aniSummonzhen:playAnimation("animation_10_s")
        end
        ui.heroCards = ui.createHeroesShowCards(l_1_0.heroes, summonType)
        layer:addChild(ui.heroCards, 1000)
        heros.addAll(l_1_0.heroes)
        ui.actHeroSummon10(l_1_0.heroes)
        for ii = 1, #l_1_0.heroes do
          if cfghero[l_1_0.heroes[ii].id].maxStar == 5 then
            achieveData.add(ACHIEVE_TYPE_COMMONSUMMONFIVE, 1)
          end
        end
        local task = require("data.task")
        task.increment(task.TaskType.BASIC_SUMMON)
         end)
      end)
    summonMenu:addChild(layer.itemsummonBtn)
    summonMenu:addChild(layer.itemsummon10Btn)
    setBtnvisit(false)
    schedule(layer, 1, function()
      setBtnvisit(true)
      end)
    layer.defineBtn:setPosition(scalep(288, 124))
  elseif l_4_1 == 4 or l_4_1 == 5 or l_4_1 == 6 then
    local summon1 = img.createLogin9Sprite(img.login.button_9_small_gold)
    summon1:setPreferredSize(CCSize(174, 60))
    local item1 = img.createUISprite(img.ui.summon_item2)
    item1:setScale(0.9)
    item1:setPosition(CCPoint(30, summon1:getContentSize().height / 2 + 2))
    summon1:addChild(item1)
    local itemcountLable = lbl.createFont2(16, 1, ccc3(255, 246, 223))
    itemcountLable:setPosition(CCPoint(item1:getContentSize().width / 2, 5))
    item1:addChild(itemcountLable)
    local buyLab = lbl.createFont1(16, i18n.global.summon_buy.string, ccc3(115, 59, 5))
    buyLab:setPosition(CCPoint(summon1:getContentSize().width * 3 / 5, summon1:getContentSize().height / 2))
    summon1:addChild(buyLab)
    layer.itemsummonBtn = SpineMenuItem:create(json.ui.button, summon1)
    layer.itemsummonBtn:setScale(view.minScale)
    layer.itemsummonBtn:setAnchorPoint(CCPoint(0.5, 0))
    layer.itemsummonBtn:setPosition(scalep(480, 94))
    layer.itemsummonBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if cfgvip[player.vipLv()].heroes + player.buy_hlimit * 5 < #heros + 1 then
        local gotoHeroDlg = require("ui.summon.tipsdialog")
        gotoHeroDlg.show(layer)
        return 
      end
      local item = bag.items.find(ITEM_ID_SUPERGACHA)
      local summonItemCount = 0
      if item then
        summonItemCount = item.num
      end
      local paramsItem = nil
      if summonItemCount > 0 then
        paramsItem = {id = ITEM_ID_SUPERGACHA, num = 1}
      else
        showToast(i18n.global.summon_hero_lack.string)
        return 
      end
      local params = {}
      params.sid = player.sid
      params.type = 5
      addWaitNet()
      net:gacha(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        initHeroCards()
        bag.items.sub({id = ITEM_ID_SUPERGACHA, num = paramsItem.num})
        bag.items.add({id = ITEM_ID_ENERGY, num = 10})
        upvalue_2048 = currentPower + 10
        upvalue_2560 = string.format("%d/%d", currentPower, requiredPower)
        schedule(layer, 4, function()
          progressLabel:setString(progressStr)
          powerProgress:setPercentage(currentPower / requiredPower * 100)
          if requiredPower <= currentPower and cfgvip[player.vipLv()].gacha == 1 then
            aniSummonnenglcao:setVisible(true)
            helmetBtn0:setVisible(false)
            helmetBtn:setVisible(true)
          end
            end)
        setBtnvisit(false)
        schedule(layer, 1, function()
          setBtnvisit(true)
            end)
        ui.actHeroSummon10(l_1_0.heroes)
        if #l_1_0.heroes == 1 then
          aniSummonzhen:playAnimation("animation_1_s")
        else
          aniSummonzhen:playAnimation("animation_10_s")
        end
        ui.heroCards = ui.createHeroesShowCards(l_1_0.heroes, summonType)
        layer:addChild(ui.heroCards, 1000)
        heros.addAll(l_1_0.heroes)
        ui.checkGiftLimit(l_1_0.heroes)
        local activity = require("data.activity")
        activity.addScore(activity.IDS.SCORE_SUMMON.ID, 1)
        achieveData.add(ACHIEVE_TYPE_HIGHSUMMON, 1)
        for i = 1, #l_1_0.heroes do
          if cfghero[l_1_0.heroes[i].id].qlt ~= 5 then
            achieveData.addSummonForAf(1)
          else
            achieveData.addSummonForAf(0)
          end
        end
        local task = require("data.task")
        task.increment(task.TaskType.SENIOR_SUMMON)
         end)
      end)
    local tensummon = img.createLogin9Sprite(img.login.button_9_small_gold)
    tensummon:setPreferredSize(CCSize(174, 60))
    local item2 = img.createItemIcon2(ITEM_ID_GEM)
    item2:setScale(0.9)
    item2:setPosition(CCPoint(30, tensummon:getContentSize().height / 2 + 2))
    tensummon:addChild(item2)
    local itemcountLable = lbl.createFont2(16, SUPERSUMMON, ccc3(255, 246, 223))
    itemcountLable:setPosition(CCPoint(item2:getContentSize().width / 2, 5))
    item2:addChild(itemcountLable)
    local tenbuyLab = lbl.createFont1(16, i18n.global.summon_buy.string, ccc3(115, 59, 5))
    tenbuyLab:setPosition(CCPoint(tensummon:getContentSize().width * 3 / 5, tensummon:getContentSize().height / 2))
    tensummon:addChild(tenbuyLab)
    layer.gemsummonBtn = SpineMenuItem:create(json.ui.button, tensummon)
    layer.gemsummonBtn:setScale(view.minScale)
    layer.gemsummonBtn:setPosition(scalep(672, 124))
    layer.gemsummonBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if cfgvip[player.vipLv()].heroes + player.buy_hlimit * 5 < #heros + 1 then
        local gotoHeroDlg = require("ui.summon.tipsdialog")
        gotoHeroDlg.show(layer)
        return 
      end
      if bag.gem() < SUPERSUMMON then
        showToast(i18n.global.summon_gem_lack.string)
        return 
      end
      local params = {}
      params.sid = player.sid
      params.type = 6
      addWaitNet()
      net:gacha(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        initHeroCards()
        bag.subGem(SUPERSUMMON)
        bag.items.add({id = ITEM_ID_ENERGY, num = 10})
        upvalue_2048 = currentPower + 10
        upvalue_2560 = string.format("%d/%d", currentPower, requiredPower)
        upvalue_3584 = bag.gem()
        lbl_gem:setString(gem_num)
        schedule(layer, 3.8, function()
          progressLabel:setString(progressStr)
          powerProgress:setPercentage(currentPower / requiredPower * 100)
          if requiredPower <= currentPower and cfgvip[player.vipLv()].gacha == 1 then
            aniSummonnenglcao:setVisible(true)
            helmetBtn0:setVisible(false)
            helmetBtn:setVisible(true)
          end
            end)
        setBtnvisit(false)
        schedule(layer, 1, function()
          setBtnvisit(true)
            end)
        if #l_1_0.heroes == 1 then
          aniSummonzhen:playAnimation("animation_1_s")
        else
          aniSummonzhen:playAnimation("animation_10_s")
        end
        ui.heroCards = ui.createHeroesShowCards(l_1_0.heroes, summonType)
        layer:addChild(ui.heroCards, 1000)
        heros.addAll(l_1_0.heroes)
        ui.checkGiftLimit(l_1_0.heroes)
        local activity = require("data.activity")
        activity.addScore(activity.IDS.SCORE_SUMMON.ID, 1)
        ui.actHeroSummon10(l_1_0.heroes)
        achieveData.add(ACHIEVE_TYPE_HIGHSUMMON, 1)
        for i = 1, #l_1_0.heroes do
          if cfghero[l_1_0.heroes[i].id].qlt ~= 5 then
            achieveData.addSummonForAf(1)
          else
            achieveData.addSummonForAf(0)
          end
        end
        local task = require("data.task")
        task.increment(task.TaskType.SENIOR_SUMMON)
         end)
      end)
    summonMenu:addChild(layer.itemsummonBtn)
    summonMenu:addChild(layer.gemsummonBtn)
    setBtnvisit(false)
    schedule(layer, 1, function()
      setBtnvisit(true)
      end)
    currentPower = currentPower + 10
    progressStr = string.format("%d/%d", currentPower, requiredPower)
    schedule(layer, 3.8, function()
      progressLabel:setString(progressStr)
      powerProgress:setPercentage(currentPower / requiredPower * 100)
      if requiredPower <= currentPower and cfgvip[player.vipLv()].gacha == 1 then
        aniSummonnenglcao:setVisible(true)
        helmetBtn0:setVisible(false)
        helmetBtn:setVisible(true)
      end
      end)
  elseif l_4_1 == 7 or l_4_1 == 8 then
    local summon1 = img.createLogin9Sprite(img.login.button_9_small_gold)
    summon1:setPreferredSize(CCSize(174, 60))
    local item1 = img.createUISprite(img.ui.summon_item2)
    item1:setScale(0.9)
    item1:setPosition(CCPoint(30, summon1:getContentSize().height / 2 + 2))
    summon1:addChild(item1)
    local itemcountLable = lbl.createFont2(16, 10, ccc3(255, 246, 223))
    itemcountLable:setPosition(CCPoint(item1:getContentSize().width / 2, 5))
    item1:addChild(itemcountLable)
    local buyLab = lbl.createFont1(16, i18n.global.summon_buy10.string, ccc3(115, 59, 5))
    buyLab:setPosition(CCPoint(summon1:getContentSize().width * 3 / 5, summon1:getContentSize().height / 2))
    summon1:addChild(buyLab)
    layer.itemsummonBtn = SpineMenuItem:create(json.ui.button, summon1)
    layer.itemsummonBtn:setScale(view.minScale)
    layer.itemsummonBtn:setAnchorPoint(CCPoint(0.5, 0))
    layer.itemsummonBtn:setPosition(scalep(480, 94))
    layer.itemsummonBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if cfgvip[player.vipLv()].heroes + player.buy_hlimit * 5 < #heros + 10 then
        local gotoHeroDlg = require("ui.summon.tipsdialog")
        gotoHeroDlg.show(layer)
        return 
      end
      local item = bag.items.find(ITEM_ID_SUPERGACHA)
      local summonItemCount = 0
      if item then
        summonItemCount = item.num
      end
      local paramsItem = nil
      if summonItemCount >= 10 then
        paramsItem = {id = ITEM_ID_SUPERGACHA, num = 10}
      else
        showToast(i18n.global.summon_hero_lack.string)
        return 
      end
      local params = {}
      params.sid = player.sid
      params.type = 7
      addWaitNet()
      net:gacha(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        initHeroCards()
        bag.items.sub({id = ITEM_ID_SUPERGACHA, num = paramsItem.num})
        bag.items.add({id = ITEM_ID_ENERGY, num = 100})
        upvalue_2048 = currentPower + 100
        upvalue_2560 = string.format("%d/%d", currentPower, requiredPower)
        schedule(layer, 8, function()
          progressLabel:setString(progressStr)
          powerProgress:setPercentage(currentPower / requiredPower * 100)
          if requiredPower <= currentPower and cfgvip[player.vipLv()].gacha == 1 then
            aniSummonnenglcao:setVisible(true)
            helmetBtn0:setVisible(false)
            helmetBtn:setVisible(true)
          end
            end)
        ui.actHeroSummon10(l_1_0.heroes)
        setBtnvisit(false)
        schedule(layer, 2, function()
          setBtnvisit(true)
            end)
        if #l_1_0.heroes == 1 then
          aniSummonzhen:playAnimation("animation_1_s")
        else
          aniSummonzhen:playAnimation("animation_10_s")
        end
        ui.heroCards = ui.createHeroesShowCards(l_1_0.heroes, summonType)
        layer:addChild(ui.heroCards, 1000)
        heros.addAll(l_1_0.heroes)
        ui.checkGiftLimit(l_1_0.heroes)
        local activity = require("data.activity")
        activity.addScore(activity.IDS.SCORE_SUMMON.ID, 10)
        achieveData.add(ACHIEVE_TYPE_HIGHSUMMON, 10)
        for i = 1, #l_1_0.heroes do
          if cfghero[l_1_0.heroes[i].id].qlt ~= 5 then
            achieveData.addSummonForAf(1)
          else
            achieveData.addSummonForAf(0)
          end
        end
        local task = require("data.task")
        task.increment(task.TaskType.SENIOR_SUMMON, 10)
         end)
      end)
    local tensummon = img.createLogin9Sprite(img.login.button_9_small_gold)
    tensummon:setPreferredSize(CCSize(174, 60))
    local item2 = img.createItemIcon2(ITEM_ID_GEM)
    item2:setScale(0.9)
    item2:setPosition(CCPoint(30, tensummon:getContentSize().height / 2 + 2))
    tensummon:addChild(item2)
    local itemcountLable = lbl.createFont2(16, TENSUMMON, ccc3(255, 246, 223))
    itemcountLable:setPosition(CCPoint(item2:getContentSize().width / 2, 5))
    item2:addChild(itemcountLable)
    local tenbuyLab = lbl.createFont1(16, i18n.global.summon_buy10.string, ccc3(115, 59, 5))
    tenbuyLab:setPosition(CCPoint(tensummon:getContentSize().width * 3 / 5, tensummon:getContentSize().height / 2))
    tensummon:addChild(tenbuyLab)
    layer.gemsummonBtn = SpineMenuItem:create(json.ui.button, tensummon)
    layer.gemsummonBtn:setScale(view.minScale)
    layer.gemsummonBtn:setAnchorPoint(CCPoint(0.5, 0))
    layer.gemsummonBtn:setPosition(scalep(672, 94))
    layer.gemsummonBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if cfgvip[player.vipLv()].heroes + player.buy_hlimit * 5 < #heros + 10 then
        local gotoHeroDlg = require("ui.summon.tipsdialog")
        gotoHeroDlg.show(layer)
        return 
      end
      if bag.gem() < TENSUMMON then
        showToast(i18n.global.summon_gem_lack.string)
        return 
      end
      local params = {}
      params.sid = player.sid
      params.type = 8
      addWaitNet()
      net:gacha(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        initHeroCards()
        bag.subGem(TENSUMMON)
        bag.items.add({id = ITEM_ID_ENERGY, num = 100})
        upvalue_2048 = currentPower + 100
        upvalue_2560 = bag.gem()
        lbl_gem:setString(gem_num)
        upvalue_3584 = string.format("%d/%d", currentPower, requiredPower)
        schedule(layer, 8, function()
          progressLabel:setString(progressStr)
          powerProgress:setPercentage(currentPower / requiredPower * 100)
          if requiredPower <= currentPower and cfgvip[player.vipLv()].gacha == 1 then
            aniSummonnenglcao:setVisible(true)
            helmetBtn0:setVisible(false)
            helmetBtn:setVisible(true)
          end
            end)
        ui.actHeroSummon10(l_1_0.heroes)
        setBtnvisit(false)
        schedule(layer, 2, function()
          setBtnvisit(true)
            end)
        if #l_1_0.heroes == 1 then
          aniSummonzhen:playAnimation("animation_1_s")
        else
          aniSummonzhen:playAnimation("animation_10_s")
        end
        ui.heroCards = ui.createHeroesShowCards(l_1_0.heroes, summonType)
        layer:addChild(ui.heroCards, 1000)
        heros.addAll(l_1_0.heroes)
        ui.checkGiftLimit(l_1_0.heroes)
        local activity = require("data.activity")
        activity.addScore(activity.IDS.SCORE_SUMMON.ID, 10)
        achieveData.add(ACHIEVE_TYPE_HIGHSUMMON, 10)
        for i = 1, #l_1_0.heroes do
          if cfghero[l_1_0.heroes[i].id].qlt ~= 5 then
            achieveData.addSummonForAf(1)
          else
            achieveData.addSummonForAf(0)
          end
        end
        local task = require("data.task")
        task.increment(task.TaskType.SENIOR_SUMMON, 10)
         end)
      end)
    summonMenu:addChild(layer.itemsummonBtn)
    summonMenu:addChild(layer.gemsummonBtn)
    setBtnvisit(false)
    schedule(layer, 3, function()
      setBtnvisit(true)
      end)
    currentPower = currentPower + 100
    progressStr = string.format("%d/%d", currentPower, requiredPower)
    schedule(layer, 8, function()
      progressLabel:setString(progressStr)
      powerProgress:setPercentage(currentPower / requiredPower * 100)
      if requiredPower <= currentPower and cfgvip[player.vipLv()].gacha == 1 then
        aniSummonnenglcao:setVisible(true)
        helmetBtn0:setVisible(false)
        helmetBtn:setVisible(true)
      end
      end)
  elseif l_4_1 == 9 or l_4_1 == 16 then
    local summon1 = img.createLogin9Sprite(img.login.button_9_small_gold)
    summon1:setPreferredSize(CCSize(174, 60))
    local item1 = img.createItemIcon2(ITEM_ID_LOVE)
    item1:setScale(0.9)
    item1:setPosition(CCPoint(30, summon1:getContentSize().height / 2 + 2))
    summon1:addChild(item1)
    local itemcountLable = lbl.createFont2(16, 10, ccc3(255, 246, 223))
    itemcountLable:setPosition(CCPoint(item1:getContentSize().width / 2, 5))
    item1:addChild(itemcountLable)
    local buyLab = lbl.createFont1(16, i18n.global.summon_buy.string, ccc3(115, 59, 5))
    buyLab:setPosition(CCPoint(summon1:getContentSize().width * 3 / 5, summon1:getContentSize().height / 2))
    summon1:addChild(buyLab)
    layer.itemsummonBtn = SpineMenuItem:create(json.ui.button, summon1)
    layer.itemsummonBtn:setScale(view.minScale)
    layer.itemsummonBtn:setAnchorPoint(CCPoint(0.5, 0))
    layer.itemsummonBtn:setPosition(scalep(480, 94))
    layer.itemsummonBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if cfgvip[player.vipLv()].heroes + player.buy_hlimit * 5 < #heros + 1 then
        local gotoHeroDlg = require("ui.summon.tipsdialog")
        gotoHeroDlg.show(layer)
        return 
      end
      local item = bag.items.find(12)
      local summonItemCount = 0
      if item then
        summonItemCount = item.num
      end
      if item.num < 10 then
        showToast(i18n.global.summon_love_lack.string)
        return 
      end
      local params = {}
      params.sid = player.sid
      params.type = 9
      addWaitNet()
      net:gacha(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        initHeroCards()
        bag.items.sub({id = ITEM_ID_LOVE, num = 10})
        upvalue_1536 = bag.items.find(ITEM_ID_LOVE).num
        lbl_love:setString(love_num)
        setBtnvisit(false)
        schedule(layer, 1, function()
          setBtnvisit(true)
            end)
        ui.actHeroSummon10(l_1_0.heroes)
        if #l_1_0.heroes == 1 then
          aniSummonzhen:playAnimation("animation_1_s")
        else
          aniSummonzhen:playAnimation("animation_10_s")
        end
        ui.heroCards = ui.createHeroesShowCards(l_1_0.heroes, summonType)
        ui.checkGiftLimit(l_1_0.heroes)
        layer:addChild(ui.heroCards, 1000)
        heros.addAll(l_1_0.heroes)
        if cfghero[l_1_0.heroes[1].id].maxStar == 5 then
          achieveData.add(ACHIEVE_TYPE_LOVESUMMONFIVE, 1)
        end
         end)
      end)
    local summon2 = img.createLogin9Sprite(img.login.button_9_small_gold)
    summon2:setPreferredSize(CCSize(174, 60))
    local item2 = img.createItemIcon2(ITEM_ID_LOVE)
    item2:setScale(0.9)
    item2:setPosition(CCPoint(30, summon2:getContentSize().height / 2 + 2))
    summon2:addChild(item2)
    local itemcountLable2 = lbl.createFont2(16, 100, ccc3(255, 246, 223))
    itemcountLable2:setPosition(CCPoint(item2:getContentSize().width / 2, 5))
    item2:addChild(itemcountLable2)
    local buyLab2 = lbl.createFont1(16, i18n.global.summon_buy.string, ccc3(115, 59, 5))
    buyLab2:setPosition(CCPoint(summon2:getContentSize().width * 3 / 5, summon2:getContentSize().height / 2))
    summon2:addChild(buyLab2)
    layer.itemsummon10Btn = SpineMenuItem:create(json.ui.button, summon2)
    layer.itemsummon10Btn:setScale(view.minScale)
    layer.itemsummon10Btn:setAnchorPoint(CCPoint(0.5, 0))
    layer.itemsummon10Btn:setPosition(scalep(672, 94))
    layer.itemsummon10Btn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if cfgvip[player.vipLv()].heroes + player.buy_hlimit * 5 < #heros + 10 then
        local gotoHeroDlg = require("ui.summon.tipsdialog")
        gotoHeroDlg.show(layer)
        return 
      end
      local item = bag.items.find(12)
      local summonItemCount = 0
      if item then
        summonItemCount = item.num
      end
      if item.num < 100 then
        showToast(i18n.global.summon_love_lack.string)
        return 
      end
      local params = {}
      params.sid = player.sid
      params.type = 16
      addWaitNet()
      net:gacha(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        initHeroCards()
        bag.items.sub({id = ITEM_ID_LOVE, num = 100})
        upvalue_1536 = bag.items.find(ITEM_ID_LOVE).num
        lbl_love:setString(love_num)
        setBtnvisit(false)
        schedule(layer, 1, function()
          setBtnvisit(true)
            end)
        ui.actHeroSummon10(l_1_0.heroes)
        if #l_1_0.heroes == 1 then
          aniSummonzhen:playAnimation("animation_1_s")
        else
          aniSummonzhen:playAnimation("animation_10_s")
        end
        ui.heroCards = ui.createHeroesShowCards(l_1_0.heroes, summonType)
        ui.checkGiftLimit(l_1_0.heroes)
        layer:addChild(ui.heroCards, 1000)
        heros.addAll(l_1_0.heroes)
        for ii = 1, #l_1_0.heroes do
          if cfghero[l_1_0.heroes[ii].id].maxStar == 5 then
            achieveData.add(ACHIEVE_TYPE_LOVESUMMONFIVE, 1)
          end
        end
         end)
      end)
    summonMenu:addChild(layer.itemsummonBtn)
    summonMenu:addChild(layer.itemsummon10Btn)
    setBtnvisit(false)
    schedule(layer, 1, function()
      setBtnvisit(true)
      end)
    layer.defineBtn:setPosition(scalep(288, 124))
  else
    setBtnvisit(false)
    schedule(layer, 1, function()
      setBtnvisit(true)
      end)
    layer.defineBtn:setPosition(scalep(480, 124))
  end
  local heroCards = ui.createHeroesShowCards(l_4_0, l_4_1, true)
  layer:addChild(heroCards, 1000)
  ui.heroCards = heroCards
  return layer
end

ui.createHeroesShowCards = function(l_5_0, l_5_1, l_5_2)
  local layer = CCLayer:create()
  local gridWidth = 102
  local getPosition = function(l_1_0, l_1_1)
    if l_1_1 <= 5 then
      y = 334
    elseif l_1_0 <= 5 then
      y = 388
    else
      y = 276
    end
    if l_1_1 % 5 == 0 then
      x = 278
    elseif l_1_1 % 5 == 4 then
      x = 278 + gridWidth / 2
    elseif l_1_1 % 5 == 3 then
      x = 278 + gridWidth
    elseif l_1_1 % 5 == 2 then
      x = 278 + gridWidth * 3 / 2
    elseif l_1_1 % 5 == 1 then
      x = 278 + gridWidth * 2
    end
    x = x + gridWidth * ((l_1_0 - 1) % 5)
    return x, y
   end
  local time = 1.2
  local audioTime = 0.6
  if l_5_2 then
    audioTime = 1.6
    time = 2.4
  end
  local icons = {}
  local loopparcl = {}
  if l_5_0 then
    if #l_5_0 == 10 then
      time = 2.4
      if l_5_2 then
        time = 3.6
      end
    end
    for i,hero in ipairs(l_5_0) do
      do
        schedule(layer, 0.5, function()
          local icon = img.createHeroHeadByHid(hero.hid)
          icons[i] = CCMenuItemSprite:create(icon, nil)
          icons[i]:setScale(0.9)
          local x, y = getPosition(i, #heroes)
          icons[i].menu = CCMenu:createWithItem(icons[i])
          icons[i].menu:ignoreAnchorPointForPosition(false)
          icons[i]:registerScriptTapHandler(function()
            audio.play(audio.button)
            local herotips = require("ui.tips.hero")
            local tips = herotips.create(hero.id)
            if layer and not tolua.isnull(layer) then
              layer:addChild(tips, 1001)
            end
               end)
          json.load(json.ui.zhaohuan_fazhen_s)
          local aniSummontbtx = DHSkeletonAnimation:createWithKey(json.ui.zhaohuan_fazhen_s)
          aniSummontbtx:setScale(0.9)
          aniSummontbtx:scheduleUpdateLua()
          aniSummontbtx:setAnchorPoint(CCPoint(0.5, -1))
          if cfghero[hero.id].qlt >= 5 then
            aniSummontbtx:playAnimation("start")
            aniSummontbtx:appendNextAnimation("loop", -1)
          end
          if i == 1 and #heroes == 1 then
            aniSummonzhen:addChildFollowSlot("code_icon", icons[i].menu)
            aniSummonzhen:addChildFollowSlot("code_position", aniSummontbtx)
          else
            aniSummonzhen:addChildFollowSlot(string.format("code_icon_%d", i), icons[i].menu)
            aniSummonzhen:addChildFollowSlot(string.format("code_position_%d", i), aniSummontbtx)
          end
            end)
        schedule(layer, audioTime, function()
          if cfghero[hero.id].qlt >= 5 then
            audio.play(audio.summon_get_nb)
          else
            audio.play(audio.summon_get_common)
          end
            end)
        if cfghero[hero.id].qlt >= 5 then
          audioTime = audioTime + 0.2
        else
          audioTime = audioTime + 0.2
        end
      end
    end
  end
  if l_5_1 >= 4 and l_5_1 <= 8 then
    schedule(layer, time, function()
    audio.play(audio.summon_reward)
    json.load(json.ui.zhaohuan_lizi)
    local aniSummonLz = DHSkeletonAnimation:createWithKey(json.ui.zhaohuan_lizi)
    aniSummonLz:setScale(view.minScale)
    aniSummonLz:scheduleUpdateLua()
    aniSummonLz:setPosition(scalep(480, 288))
    layer:addChild(aniSummonLz, 1001)
    local loopparcl = nil
    local tenloopparcl = {}
    if #heroes <= 5 then
      loopparcl = particle.create("zh_loop")
      loopparcl:setScale(view.minScale)
      layer:addChild(loopparcl, 1001)
      aniSummonLz:playAnimation("animation1")
    else
      for i = 1, 10 do
        tenloopparcl[i] = particle.create("zh_loop")
        tenloopparcl[i]:setScale(view.minScale)
        layer:addChild(tenloopparcl[i], 1001)
      end
      aniSummonLz:playAnimation("animation2")
    end
    local onpartUpdate = function()
      if #heroes <= 5 then
        loopparcl:setPosition(aniSummonLz:getBonePositionRelativeToLayer(string.format("code_ic%d", 1)))
      else
        for i = 1, 10 do
          tenloopparcl[i]:setPosition(aniSummonLz:getBonePositionRelativeToLayer(string.format("code_ic%d", i)))
        end
      end
      end
    layer:scheduleUpdateWithPriorityLua(onpartUpdate, 0)
    schedule(layer, 3, function()
      layer:unscheduleUpdate()
      end)
   end)
  end
  return layer
end

ui.createLayer = function(l_6_0)
  local layer = CCLayer:create()
  img.load(img.packedOthers.spine_ui_zhaohuan_1)
  json.load(json.ui.zhaohuan_fazhen)
  upvalue_1024 = DHSkeletonAnimation:createWithKey(json.ui.zhaohuan_fazhen)
  aniSummonzhen:setScale(view.minScale)
  aniSummonzhen:scheduleUpdateLua()
  aniSummonzhen:setAnchorPoint(CCPoint(0.5, 0))
  aniSummonzhen:setPosition(view.midX, view.midY)
  layer:addChild(aniSummonzhen)
  local bg = img.createUISprite(img.ui.summon_bg)
  aniSummonzhen:addChildFollowSlot("code_bg", bg)
  layer:setTouchEnabled(true)
  addBackEvent(layer)
  local backEvent = function()
    audio.play(audio.button)
    replaceScene(require("ui.summon.main").create(uiParams))
   end
  layer.onAndroidBack = function()
    backEvent()
   end
  local onEnter = function()
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_5_0)
    if l_5_0 == "enter" then
      onEnter()
    elseif l_5_0 == "exit" then
      onExit()
    elseif l_5_0 == "cleanup" then
      img.unload(img.packedOthers.spine_ui_zhaohuan_1)
    end
   end)
  require("ui.tutorial").show("ui.summon.info", layer)
  return layer
end

return ui


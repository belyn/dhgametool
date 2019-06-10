-- Command line was: E:\github\dhgametool\scripts\ui\summonspe\spsummon.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local player = require("data.player")
local bag = require("data.bag")
local net = require("net.netClient")
local cfghero = require("config.hero")
local cfgspacegacha = require("config.spacegacha")
local datagacha = require("data.gacha")
local tipsitem = require("ui.tips.item")
local createPopupPieceBatchSummonResult = function(l_1_0)
  local params = {}
  params.title = i18n.global.reward_will_get.string
  params.btn_count = 0
  local dialog = require("ui.dialog").create(params)
  local back = img.createLogin9Sprite(img.login.button_9_small_gold)
  back:setPreferredSize(CCSize(153, 50))
  local comfirlab = lbl.createFont1(22, i18n.global.summon_comfirm.string, lbl.buttonColor)
  comfirlab:setPosition(CCPoint(back:getContentSize().width / 2, back:getContentSize().height / 2))
  back:addChild(comfirlab)
  local backBtn = SpineMenuItem:create(json.ui.button, back)
  backBtn:setPosition(CCPoint(dialog.board:getContentSize().width / 2, 80))
  local menu = CCMenu:createWithItem(backBtn)
  menu:setPosition(0, 0)
  dialog.board:addChild(menu)
  dialog.board.tipsTag = false
  local px = dialog.board:getContentSize().width / 2 - 50
  for i = 1, #l_1_0 do
    do
      local item = img.createItem(l_1_0[i].id, l_1_0[i].num)
      local itemBtn = SpineMenuItem:create(json.ui.button, item)
      itemBtn:setPosition(px + 100 * (i - 1), 185)
      itemBtn:setScale(0.9)
      local iconMenu = CCMenu:createWithItem(itemBtn)
      iconMenu:setPosition(0, 0)
      dialog.board:addChild(iconMenu)
      itemBtn:registerScriptTapHandler(function()
        audio.play(audio.button)
        if dialog.board.tipsTag == false then
          dialog.board.tipsTag = true
          tips = tipsitem.createForShow({id = rewards[i].id, num = rewards[i].num})
          dialog:addChild(tips, 200)
          tips.setClickBlankHandler(function()
            tips:removeFromParent()
            dialog.board.tipsTag = false
               end)
        end
         end)
    end
  end
  backBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    dialog:removeFromParentAndCleanup()
   end)
  return dialog
end

ui.create = function()
  local layer = CCLayer:create()
  local summontype = 12
  local bg_w = 846
  local bg_h = 396
  local layer = CCLayer:create()
  local bg = img.createUISprite(img.ui.summontree_summon_bg)
  bg:setPosition(bg_w / 2, bg_h / 2)
  layer:addChild(bg)
  local SCROLL_CONTAINER_SIZE = 210
  local scrollUI = require("ui.pet.scrollUI")
  local Scroll = scrollUI.create()
  Scroll:setDirection(kCCScrollViewDirectionHorizontal)
  Scroll:setPosition(0, 0)
  Scroll:setTouchEnabled(false)
  Scroll:setViewSize(CCSize(832, 395))
  Scroll:setContentSize(CCSize(SCROLL_CONTAINER_SIZE + 20, 290))
  layer:addChild(Scroll)
  json.load(json.ui.shengmingzhishu_top)
  local anitop = DHSkeletonAnimation:createWithKey(json.ui.shengmingzhishu_top)
  anitop:scheduleUpdateLua()
  anitop:playAnimation("animation", -1)
  anitop:setPosition(bg_w / 2, bg_h / 2 + 47)
  Scroll:getContainer():addChild(anitop)
  local infoSprite = img.createUISprite(img.ui.btn_detail)
  local infoBtn = SpineMenuItem:create(json.ui.button, infoSprite)
  infoBtn:setPosition(bg_w - 95, bg_h - 40)
  local infoMenu = CCMenu:create()
  infoMenu:setPosition(0, 0)
  layer:addChild(infoMenu, 20)
  infoMenu:addChild(infoBtn)
  infoBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():getParent():getParent():getParent():addChild(require("ui.help").create(i18n.global.gtree_rate_des.string, i18n.global.casino_item_rate.string), 1000)
   end)
  local detailSprite = img.createUISprite(img.ui.btn_help)
  local detailBtn = SpineMenuItem:create(json.ui.button, detailSprite)
  detailBtn:setPosition(bg_w - 45, bg_h - 40)
  local detailMenu = CCMenu:create()
  detailMenu:setPosition(0, 0)
  layer:addChild(detailMenu, 20)
  detailMenu:addChild(detailBtn)
  detailBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():getParent():getParent():getParent():addChild(require("ui.help").create(i18n.global.help_summon_xianzhi.string), 1000)
   end)
  json.load(json.ui.shengmingzhishu_animation)
  local aniSpsummon = DHSkeletonAnimation:createWithKey(json.ui.shengmingzhishu_animation)
  aniSpsummon:scheduleUpdateLua()
  aniSpsummon:playAnimation("2_freeze", -1)
  aniSpsummon:setPosition(bg_w / 2, bg_h / 2 + 25)
  layer:addChild(aniSpsummon, 100)
  json.load(json.ui.shengmingzhishu_light)
  local anilight = DHSkeletonAnimation:createWithKey(json.ui.shengmingzhishu_light)
  anilight:scheduleUpdateLua()
  anilight:playAnimation("animation", -1)
  aniSpsummon:addChildFollowSlot("code_light", anilight)
  json.load(json.ui.shengmingzhishu_1)
  local anisummon1 = DHSkeletonAnimation:createWithKey(json.ui.shengmingzhishu_1)
  anisummon1:scheduleUpdateLua()
  anisummon1:playAnimation("loop", -1)
  aniSpsummon:addChildFollowSlot("code_1", anisummon1)
  json.load(json.ui.shengmingzhishu_2)
  local anisummon2 = DHSkeletonAnimation:createWithKey(json.ui.shengmingzhishu_2)
  anisummon2:scheduleUpdateLua()
  anisummon2:playAnimation("loop", -1)
  aniSpsummon:addChildFollowSlot("code_2", anisummon2)
  json.load(json.ui.shengmingzhishu_3)
  local anisummon3 = DHSkeletonAnimation:createWithKey(json.ui.shengmingzhishu_3)
  anisummon3:scheduleUpdateLua()
  anisummon3:playAnimation("loop", -1)
  aniSpsummon:addChildFollowSlot("code_3", anisummon3)
  json.load(json.ui.shengmingzhishu_4)
  local anisummon4 = DHSkeletonAnimation:createWithKey(json.ui.shengmingzhishu_4)
  anisummon4:scheduleUpdateLua()
  anisummon4:playAnimation("loop", -1)
  aniSpsummon:addChildFollowSlot("code_4", anisummon4)
  json.load(json.ui.shengmingzhishu_5)
  local anisummon5 = DHSkeletonAnimation:createWithKey(json.ui.shengmingzhishu_5)
  anisummon5:scheduleUpdateLua()
  anisummon5:playAnimation("loop", -1)
  aniSpsummon:addChildFollowSlot("code_5", anisummon5)
  local summon = img.createLogin9Sprite(img.login.button_9_gold)
  summon:setPreferredSize(CCSizeMake(172, 62))
  local spicon = img.createItemIcon2(ITEM_ID_SP_SUMMON)
  spicon:setScale(0.9)
  spicon:setPosition(CCPoint(30, summon:getContentSize().height / 2 + 2))
  summon:addChild(spicon)
  local spcountLable = lbl.createFont2(16, cfgspacegacha[datagacha.spacesummon].cost, ccc3(255, 246, 223))
  spcountLable:setPosition(CCPoint(spicon:getContentSize().width / 2, 5))
  spicon:addChild(spcountLable)
  local summonLabel = lbl.createFont1(18, i18n.global.summon_buy.string, ccc3(115, 59, 5))
  summonLabel:setPosition(summon:getContentSize().width * 3 / 5, summon:getContentSize().height / 2)
  summon:addChild(summonLabel)
  local summonbtn = SpineMenuItem:create(json.ui.button, summon)
  summonbtn:setPosition(CCPoint(bg_w / 2 - 100, 50))
  local summonmenu = CCMenu:createWithItem(summonbtn)
  summonmenu:setPosition(CCPoint(0, 0))
  layer:addChild(summonmenu, 100)
  local tensummon = img.createLogin9Sprite(img.login.button_9_gold)
  tensummon:setPreferredSize(CCSizeMake(172, 62))
  local tenspicon = img.createItemIcon2(ITEM_ID_SP_SUMMON)
  tenspicon:setScale(0.9)
  tenspicon:setPosition(CCPoint(30, tensummon:getContentSize().height / 2 + 2))
  tensummon:addChild(tenspicon)
  local tenspcountLable = lbl.createFont2(16, cfgspacegacha[datagacha.spacesummon].cost * 10, ccc3(255, 246, 223))
  tenspcountLable:setPosition(CCPoint(tenspicon:getContentSize().width / 2, 5))
  tenspicon:addChild(tenspcountLable)
  local tensummonLabel = lbl.createFont1(18, i18n.global.summon_buy.string, ccc3(115, 59, 5))
  tensummonLabel:setPosition(tensummon:getContentSize().width * 3 / 5, tensummon:getContentSize().height / 2)
  tensummon:addChild(tensummonLabel)
  local tensummonbtn = SpineMenuItem:create(json.ui.button, tensummon)
  tensummonbtn:setPosition(CCPoint(bg_w / 2 + 100, 50))
  local summonmenu = CCMenu:createWithItem(tensummonbtn)
  summonmenu:setPosition(CCPoint(0, 0))
  layer:addChild(summonmenu, 100)
  summonbtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local summonNum = 0
    if bag.items.find(ITEM_ID_SP_SUMMON) then
      summonNum = bag.items.find(ITEM_ID_SP_SUMMON).num
    end
    if summonNum < cfgspacegacha[datagacha.spacesummon].cost then
      showToast(i18n.global.space_summon_no_item.string)
      return 
    end
    local params = {}
    params.sid = player.sid
    params.type = summontype
    addWaitNet()
    net:gacha(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status < 0 then
        showToast("status:" .. l_1_0.status)
        return 
      end
      local activity = require("data.activity")
      activity.addScore(activity.IDS.SCORE_SPESUMMON.ID, 1)
      local cfgactivity = require("config.activity")
      local activityData = cfgactivity[activity.IDS.FRIDAY_HAPPY_1.ID]
      if activityData and activityData.extra and activityData.extra[1] then
        local limits = activityData.extra[1].num
        activity.addScore(activity.IDS.FRIDAY_HAPPY_1.ID, 1, 1, limits)
      end
      bag.items.sub({id = ITEM_ID_SP_SUMMON, num = cfgspacegacha[datagacha.spacesummon].cost})
      datagacha.spacesummon = datagacha.spacesummon + 1
      if datagacha.spacesummon > 15 then
        datagacha.spacesummon = datagacha.spacesummon - 15
      end
      for i = 1, #l_1_0.items do
        bag.items.add({id = l_1_0.items[i].id, num = l_1_0.items[i].num})
      end
      if summontype - 10 == 1 then
        anisummon1:playAnimation("click", 1, 0)
      else
        if summontype - 10 == 2 then
          anisummon2:playAnimation("click", 1, 0)
        else
          if summontype - 10 == 3 then
            anisummon3:playAnimation("click", 1, 0)
          else
            if summontype - 10 == 4 then
              anisummon4:playAnimation("click", 1, 0)
            else
              if summontype - 10 == 5 then
                anisummon5:playAnimation("click", 1, 0)
              end
            end
          end
        end
      end
      local ban = CCLayer:create()
      ban:setTouchEnabled(true)
      ban:setTouchSwallowEnabled(true)
      layer:addChild(ban, 1000)
      local achieveData = require("data.achieve")
      achieveData.add(ACHIEVE_TYPE_SPESUMMON, 1)
      schedule(layer, 1, function()
        local reward = createPopupPieceBatchSummonResult(__data.items)
        layer:getParent():getParent():getParent():getParent():addChild(reward, 1000)
        ban:removeFromParent()
        if summontype - 10 == 1 then
          anisummon1:playAnimation("loop", -1)
        else
          if summontype - 10 == 2 then
            anisummon2:playAnimation("loop", -1)
          else
            if summontype - 10 == 3 then
              anisummon3:playAnimation("loop", -1)
            else
              if summontype - 10 == 4 then
                anisummon4:playAnimation("loop", -1)
              else
                if summontype - 10 == 5 then
                  anisummon5:playAnimation("loop", -1)
                end
              end
            end
          end
        end
         end)
      end)
   end)
  tensummonbtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local summonNum = 0
    if bag.items.find(ITEM_ID_SP_SUMMON) then
      summonNum = bag.items.find(ITEM_ID_SP_SUMMON).num
    end
    if summonNum < cfgspacegacha[datagacha.spacesummon].cost * 10 then
      showToast(i18n.global.space_summon_no_item.string)
      return 
    end
    local params = {}
    params.sid = player.sid
    params.type = summontype + 10
    addWaitNet()
    net:gacha(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status < 0 then
        showToast("status:" .. l_1_0.status)
        return 
      end
      local activity = require("data.activity")
      activity.addScore(activity.IDS.SCORE_SPESUMMON.ID, 10)
      local cfgactivity = require("config.activity")
      local activityData = cfgactivity[activity.IDS.FRIDAY_HAPPY_1.ID]
      if activityData and activityData.extra and activityData.extra[1] then
        local limits = activityData.extra[1].num
        activity.addScore(activity.IDS.FRIDAY_HAPPY_1.ID, 10, 1, limits)
      end
      bag.items.sub({id = ITEM_ID_SP_SUMMON, num = cfgspacegacha[datagacha.spacesummon].cost * 10})
      datagacha.spacesummon = datagacha.spacesummon + 1
      if datagacha.spacesummon > 15 then
        datagacha.spacesummon = datagacha.spacesummon - 15
      end
      for i = 1, #l_1_0.items do
        bag.items.add({id = l_1_0.items[i].id, num = l_1_0.items[i].num})
      end
      if summontype - 10 == 1 then
        anisummon1:playAnimation("click", 1, 0)
      else
        if summontype - 10 == 2 then
          anisummon2:playAnimation("click", 1, 0)
        else
          if summontype - 10 == 3 then
            anisummon3:playAnimation("click", 1, 0)
          else
            if summontype - 10 == 4 then
              anisummon4:playAnimation("click", 1, 0)
            else
              if summontype - 10 == 5 then
                anisummon5:playAnimation("click", 1, 0)
              end
            end
          end
        end
      end
      local ban = CCLayer:create()
      ban:setTouchEnabled(true)
      ban:setTouchSwallowEnabled(true)
      layer:addChild(ban, 1000)
      local achieveData = require("data.achieve")
      achieveData.add(ACHIEVE_TYPE_SPESUMMON, 10)
      local reward = {}
      reward.items = l_1_0.items
      schedule(layer, 1, function()
        layer:getParent():getParent():getParent():getParent():addChild(require("ui.hook.drops").create(reward, i18n.global.mail_rewards.string), 1000)
        ban:removeFromParent()
        if summontype - 10 == 1 then
          anisummon1:playAnimation("loop", -1)
        else
          if summontype - 10 == 2 then
            anisummon2:playAnimation("loop", -1)
          else
            if summontype - 10 == 3 then
              anisummon3:playAnimation("loop", -1)
            else
              if summontype - 10 == 4 then
                anisummon4:playAnimation("loop", -1)
              else
                if summontype - 10 == 5 then
                  anisummon5:playAnimation("loop", -1)
                end
              end
            end
          end
        end
         end)
      end)
   end)
  local leftraw = img.createUISprite(img.ui.hero_raw)
  local btnLeftraw = SpineMenuItem:create(json.ui.button, leftraw)
  btnLeftraw:setPosition(45, bg_h / 2)
  local menuLeftraw = CCMenu:createWithItem(btnLeftraw)
  menuLeftraw:setPosition(0, 0)
  layer:addChild(menuLeftraw, 100)
  local rightraw = img.createUISprite(img.ui.hero_raw)
  rightraw:setFlipX(true)
  local btnRightraw = SpineMenuItem:create(json.ui.button, rightraw)
  btnRightraw:setPosition(bg_w - 45, bg_h / 2)
  local menuRightraw = CCMenu:createWithItem(btnRightraw)
  menuRightraw:setPosition(0, 0)
  layer:addChild(menuRightraw, 100)
  local getsummontype = function(l_5_0)
    if l_5_0 < 11 then
      l_5_0 = l_5_0 + 5
    end
    if l_5_0 > 15 then
      l_5_0 = l_5_0 - 5
    end
    return l_5_0
   end
  btnLeftraw:registerScriptTapHandler(function()
    audio.play(audio.button)
    local aninum = string.format("%d", summontype - 10)
    aniSpsummon:playAnimation(aninum)
    upvalue_512 = getsummontype(summontype + 1)
   end)
  btnRightraw:registerScriptTapHandler(function()
    audio.play(audio.button)
    local aninum = string.format("anti_%d", summontype - 10)
    aniSpsummon:playAnimation(aninum)
    upvalue_512 = getsummontype(summontype - 1)
   end)
  local lasty = nil
  local onTouchBegin = function(l_8_0, l_8_1)
    lastx = l_8_0
    return true
   end
  local onTouchMoved = function(l_9_0, l_9_1)
    return true
   end
  local onTouchEnd = function(l_10_0, l_10_1)
    local pointOnBoard = layer:convertToNodeSpace(ccp(l_10_0, l_10_1))
    if math.abs(l_10_0 - lastx) < 10 then
      return true
    end
    if l_10_0 - lastx >= 10 then
      local aninum = string.format("%d", summontype - 10)
      aniSpsummon:playAnimation(aninum)
      upvalue_512 = getsummontype(summontype + 1)
    end
    if lastx - l_10_0 >= 10 then
      local aninum = string.format("anti_%d", summontype - 10)
      aniSpsummon:playAnimation(aninum)
      upvalue_512 = getsummontype(summontype - 1)
    end
    return true
   end
  local onTouch = function(l_11_0, l_11_1, l_11_2)
    if l_11_0 == "began" then
      return onTouchBegin(l_11_1, l_11_2)
    elseif l_11_0 == "moved" then
      return onTouchMoved(l_11_1, l_11_2)
    else
      return onTouchEnd(l_11_1, l_11_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  return layer
end

return ui


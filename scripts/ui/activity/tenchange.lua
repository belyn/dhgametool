-- Command line was: E:\github\dhgametool\scripts\ui\activity\tenchange.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local cfgstore = require("config.store")
local cfghero = require("config.hero")
local cfgequip = require("config.equip")
local cfgtalen = require("config.talen")
local player = require("data.player")
local activityData = require("data.activity")
local net = require("net.netClient")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local herotips = require("ui.tips.hero")
local heros = require("data.heros")
local bag = require("data.bag")
local cfglifechange = require("config.lifechange")
local IDS = activityData.IDS
local ItemType = {Item = 1, Equip = 2}
local vp_ids = {IDS.TENCHANGE.ID}
local operData = {}
local fiveData = {}
local initHeros = function()
  do
    local tmpheros = {}
    for i,v in ipairs(heros) do
      if not v.flag then
        tmpheros[#tmpheros + 1] = {hid = v.hid, id = v.id, lv = v.lv, wake = v.wake, star = v.star, isUsed = false, flag = not v.wake or v.wake < 4 or 0}
      end
      operData.heros = tmpheros
    end
     -- Warning: missing end command somewhere! Added here
  end
end

local initfiveHeros = function(l_2_0)
  do
    local tmpheros = {}
    for i,v in ipairs(heros) do
      if not v.flag then
        tmpheros[#tmpheros + 1] = {hid = v.hid, id = v.id, lv = v.lv, wake = v.wake, star = v.star, isUsed = false, flag = not cfglifechange[v.id] or cfghero[v.id].maxStar ~= 5 or cfghero[v.id].group ~= l_2_0 or 0}
      end
      fiveData.heros = tmpheros
    end
     -- Warning: missing end command somewhere! Added here
  end
end

local createSelectBoard = function(l_3_0)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 210))
  local headData = {}
  initHeros()
  for i,v in ipairs(operData.heros) do
    headData[#headData + 1] = v
  end
  table.sort(headData, function(l_1_0, l_1_1)
    if l_1_0.id >= l_1_1.id then
      return l_1_0.id == l_1_1.id
    end
    do return end
    return l_1_0.lv < l_1_1.lv
   end)
  local board = img.createUI9Sprite(img.ui.tips_bg)
  board:setPreferredSize(CCSize(520, 420))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local showTitle = lbl.createFont1(20, i18n.global.heroforge_board_title.string, ccc3(255, 227, 134))
  showTitle:setPosition(260, 386)
  board:addChild(showTitle)
  local showFgline = img.createUI9Sprite(img.ui.hero_enchant_info_fgline)
  showFgline:setPreferredSize(CCSize(453, 1))
  showFgline:setPosition(260, 354)
  board:addChild(showFgline)
  local tmpSelect = {}
  local showHeads = {}
  local backEvent = function()
    layer:removeFromParentAndCleanup(true)
   end
  local btnCloseSp = img.createLoginSprite(img.login.button_close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSp)
  btnClose:setPosition(495, 397)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose, 1000)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    backEvent()
   end)
  local height = 84 * math.ceil(#headData / 5)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(53, 113)
  scroll:setViewSize(CCSize(420, 225))
  scroll:setContentSize(CCSize(420, height + 84))
  board:addChild(scroll)
  if #headData == 0 then
    local empty = require("ui.empty").create({size = 16, text = i18n.global.empty_heromar.string, color = ccc3(255, 246, 223)})
    empty:setPosition(board:getContentSize().width / 2, board:getContentSize().height / 2)
    board:addChild(empty)
  end
  for i,v in ipairs(headData) do
    local x = math.ceil(i / 5)
    local y = i - (x - 1) * 5
    showHeads[i] = img.createHeroHead(v.id, v.lv, true, true, v.wake)
    showHeads[i]:setScale(0.8)
    showHeads[i]:setAnchorPoint(ccp(0, 0))
    showHeads[i]:setPosition(2 + 84 * (y - 1), height - 84 * x - 5)
    scroll:getContainer():addChild(showHeads[i])
    if v.flag > 0 then
      local blackBoard = img.createUISprite(img.ui.hero_head_shade)
      blackBoard:setScale(0.93617021276596)
      blackBoard:setOpacity(120)
      blackBoard:setPosition(showHeads[i]:getContentSize().width / 2, showHeads[i]:getContentSize().height / 2)
      showHeads[i]:addChild(blackBoard, 101)
      local showLock = img.createUISprite(img.ui.devour_icon_lock)
      showLock:setPosition(showHeads[i]:getContentSize().width / 2, showHeads[i]:getContentSize().height / 2)
      showHeads[i]:addChild(showLock, 101)
    end
  end
  scroll:setContentOffset(ccp(0, 225 - height))
  local onSelect = function(l_4_0)
    if headData[l_4_0].flag > 0 then
      local count = 0
      local text = ""
      if headData[l_4_0].flag % 2 == 1 then
        text = text .. i18n.global.toast_devour_arena.string
        count = count + 1
      end
      if math.floor(headData[l_4_0].flag / 2) % 2 == 1 then
        if count >= 1 then
          text = text .. "\n"
        end
        text = text .. i18n.global.toast_devour_lock.string
        count = count + 1
      end
      if math.floor(headData[l_4_0].flag / 4) % 2 % 2 == 1 then
        if count >= 1 then
          text = text .. "\n"
        end
        text = text .. i18n.global.toast_devour_3v3arena.string
        count = count + 1
      end
      if math.floor(headData[l_4_0].flag / 8) % 2 % 2 % 2 == 1 then
        if count >= 1 then
          text = text .. "\n"
        end
        text = text .. i18n.global.toast_devour_frdarena.string
        count = count + 1
      end
      showToast(text)
      return 
    end
    headData[l_4_0].isUsed = true
    tmpSelect[#tmpSelect + 1] = headData[l_4_0]
    local blackBoard = img.createUISprite(img.ui.hero_head_shade)
    blackBoard:setScale(0.93617021276596)
    blackBoard:setOpacity(120)
    blackBoard:setPosition(showHeads[l_4_0]:getContentSize().width / 2, showHeads[l_4_0]:getContentSize().height / 2)
    showHeads[l_4_0]:addChild(blackBoard, 0, 1)
    local selectIcon = img.createUISprite(img.ui.hook_btn_sel)
    selectIcon:setPosition(blackBoard:getContentSize().width / 2, blackBoard:getContentSize().height / 2)
    blackBoard:addChild(selectIcon)
   end
  local onUnselect = function(l_5_0)
    for i,v in ipairs(tmpSelect) do
      if v.hid == headData[l_5_0].hid then
        tmpSelect[i], tmpSelect[#tmpSelect] = tmpSelect[#tmpSelect], tmpSelect[i]
        tmpSelect[#tmpSelect] = nil
    else
      end
    end
    headData[l_5_0].isUsed = false
    if showHeads[l_5_0]:getChildByTag(1) then
      showHeads[l_5_0]:removeChildByTag(1)
    end
   end
  local lasty = nil
  local onTouchBegin = function(l_6_0, l_6_1)
    lasty = l_6_1
    return true
   end
  local onTouchMoved = function(l_7_0, l_7_1)
    return true
   end
  local onTouchEnd = function(l_8_0, l_8_1)
    local point = layer:convertToNodeSpace(ccp(l_8_0, l_8_1))
    do
      local pointOnScroll = scroll:getContainer():convertToNodeSpace(ccp(l_8_0, l_8_1))
      if math.abs(l_8_1 - lasty) > 10 then
        return 
      end
      for i,v in ipairs(showHeads) do
        if v:boundingBox():containsPoint(pointOnScroll) then
          if not headData[i].isUsed and #tmpSelect < 1 then
            onSelect(i)
            for i,v in (for generator) do
            end
            if headData[i].isUsed == true then
              onUnselect(i)
            end
          end
        end
        return true
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local onTouch = function(l_9_0, l_9_1, l_9_2)
    if l_9_0 == "began" then
      return onTouchBegin(l_9_1, l_9_2)
    elseif l_9_0 == "moved" then
      return onTouchMoved(l_9_1, l_9_2)
    else
      return onTouchEnd(l_9_1, l_9_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    backEvent()
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_13_0)
    if l_13_0 == "enter" then
      onEnter()
    elseif l_13_0 == "exit" then
      onExit()
    end
   end)
  local btnSelectSp = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnSelectSp:setPreferredSize(CCSize(150, 50))
  local labSelect = lbl.createFont1(16, i18n.global.heroforge_board_btn.string, ccc3(106, 61, 37))
  labSelect:setPosition(btnSelectSp:getContentSize().width / 2, btnSelectSp:getContentSize().height / 2)
  btnSelectSp:addChild(labSelect)
  local btnSelect = SpineMenuItem:create(json.ui.button, btnSelectSp)
  btnSelect:setPosition(260, 55)
  local menuSelect = CCMenu:createWithItem(btnSelect)
  menuSelect:setPosition(0, 0)
  board:addChild(menuSelect)
  btnSelect:registerScriptTapHandler(function()
    layer:removeFromParentAndCleanup(true)
    if tmpSelect and #tmpSelect ~= 0 then
      callfunc(tmpSelect[1])
    end
   end)
  board:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, view.minScale, view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
   end))
  board:runAction(CCSequence:create(anim_arr))
  return layer
end

local createFiveSelectBoard = function(l_4_0, l_4_1)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 210))
  local headData = {}
  for i,v in ipairs(fiveData.heros) do
    headData[#headData + 1] = v
  end
  table.sort(headData, function(l_1_0, l_1_1)
    if l_1_0.id >= l_1_1.id then
      return l_1_0.id == l_1_1.id
    end
    do return end
    return l_1_0.lv < l_1_1.lv
   end)
  local board = img.createUI9Sprite(img.ui.tips_bg)
  board:setPreferredSize(CCSize(520, 420))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local showTitle = lbl.createFont1(20, i18n.global.heroforge_board_title.string, ccc3(255, 227, 134))
  showTitle:setPosition(260, 386)
  board:addChild(showTitle)
  local showFgline = img.createUI9Sprite(img.ui.hero_enchant_info_fgline)
  showFgline:setPreferredSize(CCSize(453, 1))
  showFgline:setPosition(260, 354)
  board:addChild(showFgline)
  local nowId = 0
  local tmpSelect = {}
  local showHeads = {}
  local backEvent = function()
    layer:removeFromParentAndCleanup(true)
   end
  local btnCloseSp = img.createLoginSprite(img.login.button_close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSp)
  btnClose:setPosition(495, 397)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose, 1000)
  btnClose:registerScriptTapHandler(function()
    backEvent()
    audio.play(audio.button)
   end)
  local height = 84 * math.ceil(#headData / 5)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(53, 113)
  scroll:setViewSize(CCSize(420, 225))
  scroll:setContentSize(CCSize(420, height))
  board:addChild(scroll)
  if #headData == 0 then
    local empty = require("ui.empty").create({size = 16, text = i18n.global.empty_heromar.string, color = ccc3(255, 246, 223)})
    empty:setPosition(board:getContentSize().width / 2, board:getContentSize().height / 2)
    board:addChild(empty)
  end
  for i,v in ipairs(headData) do
    local x = math.ceil(i / 5)
    local y = i - (x - 1) * 5
    showHeads[i] = img.createHeroHead(v.id, v.lv, true, true, v.wake)
    showHeads[i]:setScale(0.8)
    showHeads[i]:setAnchorPoint(ccp(0, 0))
    showHeads[i]:setPosition(2 + 84 * (y - 1), height - 84 * x - 5)
    scroll:getContainer():addChild(showHeads[i])
    if v.flag > 0 then
      local blackBoard = img.createUISprite(img.ui.hero_head_shade)
      blackBoard:setScale(0.93617021276596)
      blackBoard:setOpacity(120)
      blackBoard:setPosition(showHeads[i]:getContentSize().width / 2, showHeads[i]:getContentSize().height / 2)
      showHeads[i]:addChild(blackBoard)
      local showLock = img.createUISprite(img.ui.devour_icon_lock)
      showLock:setPosition(showHeads[i]:getContentSize().width / 2, showHeads[i]:getContentSize().height / 2)
      showHeads[i]:addChild(showLock)
    end
  end
  scroll:setContentOffset(ccp(0, 225 - height))
  local onSelect = function(l_4_0)
    if headData[l_4_0].flag > 0 then
      local count = 0
      local text = ""
      if headData[l_4_0].flag % 2 == 1 then
        text = text .. i18n.global.toast_devour_arena.string
        count = count + 1
      end
      if math.floor(headData[l_4_0].flag / 2) % 2 == 1 then
        if count >= 1 then
          text = text .. "\n"
        end
        text = text .. i18n.global.toast_devour_lock.string
        count = count + 1
      end
      if math.floor(headData[l_4_0].flag / 4) % 2 % 2 == 1 then
        if count >= 1 then
          text = text .. "\n"
        end
        text = text .. i18n.global.toast_devour_3v3arena.string
        count = count + 1
      end
      if math.floor(headData[l_4_0].flag / 8) % 2 % 2 % 2 == 1 then
        if count >= 1 then
          text = text .. "\n"
        end
        text = text .. i18n.global.toast_devour_frdarena.string
        count = count + 1
      end
      showToast(text)
      return 
    end
    headData[l_4_0].isUsed = true
    tmpSelect[#tmpSelect + 1] = headData[l_4_0].hid
    local blackBoard = img.createUISprite(img.ui.hero_head_shade)
    blackBoard:setScale(0.93617021276596)
    blackBoard:setOpacity(120)
    blackBoard:setPosition(showHeads[l_4_0]:getContentSize().width / 2, showHeads[l_4_0]:getContentSize().height / 2)
    showHeads[l_4_0]:addChild(blackBoard, 0, 1)
    local selectIcon = img.createUISprite(img.ui.hook_btn_sel)
    selectIcon:setPosition(blackBoard:getContentSize().width / 2, blackBoard:getContentSize().height / 2)
    blackBoard:addChild(selectIcon)
   end
  local onUnselect = function(l_5_0)
    for i,v in ipairs(tmpSelect) do
      if v == headData[l_5_0].hid then
        tmpSelect[i], tmpSelect[#tmpSelect] = tmpSelect[#tmpSelect], tmpSelect[i]
        tmpSelect[#tmpSelect] = nil
    else
      end
    end
    headData[l_5_0].isUsed = false
    if showHeads[l_5_0]:getChildByTag(1) then
      showHeads[l_5_0]:removeChildByTag(1)
    end
   end
  local lasty = nil
  local onTouchBegin = function(l_6_0, l_6_1)
    lasty = l_6_1
    return true
   end
  local onTouchMoved = function(l_7_0, l_7_1)
    return true
   end
  local onTouchEnd = function(l_8_0, l_8_1)
    local point = layer:convertToNodeSpace(ccp(l_8_0, l_8_1))
    do
      local pointOnScroll = scroll:getContainer():convertToNodeSpace(ccp(l_8_0, l_8_1))
      if math.abs(l_8_1 - lasty) > 10 then
        return 
      end
      for i,v in ipairs(showHeads) do
        if v:boundingBox():containsPoint(pointOnScroll) then
          if not headData[i].isUsed and #tmpSelect < fiveNum then
            if nowId == 0 then
              upvalue_3584 = headData[i].id
            end
            if nowId ~= 0 and headData[i].id ~= nowId then
              showToast(i18n.global.tenchange_toast_samehero.string)
              return 
            end
            onSelect(i)
            for i,v in (for generator) do
            end
            if headData[i].isUsed == true then
              onUnselect(i)
              if #tmpSelect == 0 then
                upvalue_3584 = 0
              end
            end
          end
        end
        return true
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local onTouch = function(l_9_0, l_9_1, l_9_2)
    if l_9_0 == "began" then
      return onTouchBegin(l_9_1, l_9_2)
    elseif l_9_0 == "moved" then
      return onTouchMoved(l_9_1, l_9_2)
    else
      return onTouchEnd(l_9_1, l_9_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    backEvent()
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_13_0)
    if l_13_0 == "enter" then
      onEnter()
    elseif l_13_0 == "exit" then
      onExit()
    end
   end)
  local btnSelectSp = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnSelectSp:setPreferredSize(CCSize(150, 50))
  local labSelect = lbl.createFont1(16, i18n.global.heroforge_board_btn.string, ccc3(106, 61, 37))
  labSelect:setPosition(btnSelectSp:getContentSize().width / 2, btnSelectSp:getContentSize().height / 2)
  btnSelectSp:addChild(labSelect)
  local btnSelect = SpineMenuItem:create(json.ui.button, btnSelectSp)
  btnSelect:setPosition(260, 55)
  local menuSelect = CCMenu:createWithItem(btnSelect)
  menuSelect:setPosition(0, 0)
  board:addChild(menuSelect)
  btnSelect:registerScriptTapHandler(function()
    layer:removeFromParentAndCleanup(true)
    if tmpSelect and #tmpSelect ~= 0 then
      callfunc(tmpSelect, nowId)
    end
   end)
  board:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, view.minScale, view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
   end))
  board:runAction(CCSequence:create(anim_arr))
  return layer
end

local createBoardForRewards = function(l_5_0, l_5_1)
  local heroData = heros.find(l_5_0)
  local params = {}
  params.title = i18n.global.reward_will_get.string
  params.btn_count = 0
  local dialog = require("ui.dialog").create(params)
  local back = img.createLogin9Sprite(img.login.button_9_small_gold)
  back:setPreferredSize(CCSize(153, 50))
  local comfirlab = lbl.createFont1(18, i18n.global.summon_comfirm.string, lbl.buttonColor)
  comfirlab:setPosition(CCPoint(back:getContentSize().width / 2, back:getContentSize().height / 2))
  back:addChild(comfirlab)
  local backBtn = SpineMenuItem:create(json.ui.button, back)
  backBtn:setPosition(CCPoint(dialog.board:getContentSize().width / 2, 80))
  local menu = CCMenu:createWithItem(backBtn)
  menu:setPosition(0, 0)
  dialog.board:addChild(menu)
  dialog.board.tipsTag = false
  local hero = img.createHeroHeadByHid(l_5_0)
  heroBtn = SpineMenuItem:create(json.ui.button, hero)
  heroBtn:setScale(0.85)
  heroBtn:setPosition(dialog.board:getContentSize().width / 2, 185)
  local iconMenu = CCMenu:createWithItem(heroBtn)
  iconMenu:setPosition(0, 0)
  dialog.board:addChild(iconMenu)
  heroBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local heroInfo = clone(heroData.attr())
    heroInfo.lv = heroData.lv
    heroInfo.star = heroData.star
    heroInfo.id = heroData.id
    heroInfo.wake = heroData.wake
    local tips = herotips.create(heroInfo)
    dialog:addChild(tips, 1001)
   end)
  backBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    dialog:getParent():addChild(require("ui.hook.drops").create(reward, i18n.global.ui_decompose_preview.string), 1000)
    dialog:removeFromParentAndCleanup()
   end)
  dialog.setClickBlankHandler(function()
    dialog:getParent():addChild(require("ui.hook.drops").create(reward, i18n.global.ui_decompose_preview.string), 1000)
    dialog:removeFromParentAndCleanup()
   end)
  return dialog
end

ui.create = function()
  local layer = CCLayer:create()
  local vps = {}
  for _,v in ipairs(vp_ids) do
    local tmp_status = activityData.getStatusById(v)
    vps[#vps + 1] = tmp_status
  end
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(576, 436))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.unload(img.packedOthers.ui_activity_change)
  img.load(img.packedOthers.ui_activity_change)
  local banner = (img.createUISprite("activity_change_board.png"))
  local bannerLabel = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    bannerLabel = img.createUISprite("activity_change_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChinese then
      bannerLabel = img.createUISprite("activity_change_cn.png")
    else
      if i18n.getCurrentLanguage() == kLanguageChineseTW then
        bannerLabel = img.createUISprite("activity_change_tw.png")
      else
        if i18n.getCurrentLanguage() == kLanguageJapanese then
          bannerLabel = img.createUISprite("activity_change_jp.png")
        else
          if i18n.getCurrentLanguage() == kLanguagePortuguese then
            bannerLabel = img.createUISprite("activity_change_pt.png")
          else
            bannerLabel = img.createUISprite("activity_change_us.png")
          end
        end
      end
    end
  end
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h))
  board:addChild(banner)
  bannerLabel:setAnchorPoint(CCPoint(0.5, 1))
  bannerLabel:setPosition(CCPoint(board_w / 2 - 70, board_h - 18))
  board:addChild(bannerLabel)
  local btnInfoSprite = img.createUISprite(img.ui.btn_help)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setPosition(520, board_h - 42)
  local menuInfo = CCMenu:createWithItem(btnInfo)
  menuInfo:setPosition(0, 0)
  board:addChild(menuInfo, 100)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():getParent():getParent():addChild(require("ui.help").create(i18n.global.help_tenchange.string, i18n.global.help_title.string), 1000)
   end)
  local temp_item = img.createUI9Sprite(img.ui.bottom_border_2)
  temp_item:setPreferredSize(CCSizeMake(548, 265))
  temp_item:setAnchorPoint(CCPoint(0.5, 1))
  temp_item:setPosition(CCPoint(board_w / 2, board_h - 166 + 12))
  board:addChild(temp_item)
  local tenflag = false
  local fiveflag = false
  local hostHid = 0
  local fiveGroup = 0
  local tenId = 0
  local fiveId = 0
  local fiveHids = {}
  local tenheroData = nil
  local changetips = lbl.createMixFont1(16, i18n.global.tenchange_tips.string, ccc3(115, 59, 5))
  changetips:setPosition(274, 238)
  temp_item:addChild(changetips)
  local changeIcon = img.createUISprite(img.ui.activity_ten_change)
  changeIcon:setPosition(198, 165)
  temp_item:addChild(changeIcon)
  local plusIcon = img.createUISprite(img.ui.activity_ten_plus)
  plusIcon:setPosition(378, 165)
  temp_item:addChild(plusIcon)
  local spStoneBg = img.createUISprite(img.ui.grid)
  local spStone = img.createItemIcon(73)
  spStone:setPosition(spStoneBg:getContentSize().width / 2, spStoneBg:getContentSize().height / 2)
  spStoneBg:addChild(spStone)
  local btnSpStone = CCMenuItemSprite:create(spStoneBg, nil)
  btnSpStone:setPosition(458, 165)
  local menubtnSpStone = CCMenu:createWithItem(btnSpStone)
  menubtnSpStone:setPosition(0, 0)
  temp_item:addChild(menubtnSpStone)
  btnSpStone:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():getParent():getParent():addChild(tipsitem.createForShow({id = 73}), 1000)
   end)
  local stonenum = 0
  if bag.items.find(73) then
    stonenum = bag.items.find(73).num
  end
  local showStonenum = lbl.createFont2(16, string.format("%d/5", stonenum), ccc3(255, 116, 116))
  showStonenum:setPosition(458, 105)
  temp_item:addChild(showStonenum)
  local fiveNum = 5
  if stonenum < 5 then
    showStonenum:setColor(ccc3(255, 116, 116))
  else
    showStonenum:setColor(ccc3(255, 247, 229))
  end
  local showTennum = lbl.createFont2(16, "0/1", ccc3(255, 116, 116))
  showTennum:setPosition(98, 105)
  temp_item:addChild(showTennum)
  local showFivenum = lbl.createFont2(16, "0/" .. fiveNum, ccc3(255, 116, 116))
  showFivenum:setPosition(295, 105)
  temp_item:addChild(showFivenum)
  showFivenum:setVisible(false)
  local tenSp, btnTenhero, menuTenHero, createBtnten, fiveSp, btnFivehero, menuFiveHero, createBtnfive = nil, nil, nil, nil, nil, nil, nil, nil
  local callfuncTen = function(l_3_0)
    if tenflag == false then
      tenflag = true
      clearShader(btnTenhero, true)
      showTennum:setString("1/1")
      showTennum:setColor(ccc3(255, 247, 229))
    end
    upvalue_1536 = l_3_0
    upvalue_2048 = cfghero[l_3_0.id].group
    upvalue_3072 = l_3_0.id
    initfiveHeros(fiveGroup)
    upvalue_4096 = l_3_0.hid
    menuTenHero:removeFromParentAndCleanup()
    upvalue_4608 = nil
    createBtnten(tenId, tenheroData.wake)
    upvalue_5632 = 0
    upvalue_6144 = {}
    if tenheroData.wake > 4 then
      upvalue_6656 = cfgtalen[tenheroData.wake - 4].lifeChangeCount
    else
      upvalue_6656 = 5
    end
    showFivenum:setVisible(true)
    showFivenum:setString(string.format("%d/" .. fiveNum, 0))
    menuFiveHero:removeFromParentAndCleanup()
    upvalue_8192 = nil
    createBtnfive(9999, 0)
    menuFiveHero:removeFromParentAndCleanup()
    upvalue_8192 = nil
    createBtnfive(5000 + fiveGroup * 100 + 99, 0)
   end
  createBtnten = function(l_4_0, l_4_1)
    if l_4_1 == 4 then
      tenSp = img.createHeroHead(l_4_0, nil, true, false, l_4_1, false)
    else
      tenSp = img.createHeroHead(l_4_0, nil, true, true, l_4_1, false)
    end
    local bgSize = tenSp:getContentSize()
    if l_4_1 == 4 then
      local star = img.createUISprite(img.ui.hero_star_ten)
      star:setScale(0.75)
      star:setPosition(bgSize.width / 2, 14)
      tenSp:addChild(star)
    end
    if l_4_0 == 9999 then
      setShader(tenSp, SHADER_GRAY, true)
    end
    local icon = img.createUISprite(img.ui.hero_equip_add)
    icon:setPosition(tenSp:boundingBox():getMaxX() + 23, tenSp:boundingBox():getMaxY() + 23)
    tenSp:addChild(icon)
    icon:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(0.5, 76.5), CCFadeTo:create(0.5, 255))))
    upvalue_1024 = CCMenuItemSprite:create(tenSp, nil)
    btnTenhero:setPosition(98, 165)
    upvalue_1536 = CCMenu:createWithItem(btnTenhero)
    menuTenHero:setPosition(0, 0)
    temp_item:addChild(menuTenHero)
    btnTenhero:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:getParent():getParent():getParent():addChild(createSelectBoard(callfuncTen), 2000)
      end)
   end
  createBtnten(9999, 4)
  local callfuncFive = function(l_5_0, l_5_1)
    if fiveflag == false then
      fiveflag = true
      clearShader(btnFivehero, true)
    end
    upvalue_1024 = l_5_1
    upvalue_1536 = l_5_0
    showFivenum:setString(string.format("%d/" .. fiveNum, #l_5_0))
    if #l_5_0 < fiveNum then
      showFivenum:setColor(ccc3(255, 116, 116))
    else
      showFivenum:setColor(ccc3(255, 247, 229))
    end
    menuFiveHero:removeFromParentAndCleanup()
    upvalue_3072 = nil
    createBtnfive(l_5_1, #l_5_0)
   end
  createBtnfive = function(l_6_0, l_6_1)
    fiveSp = img.createHeroHead(l_6_0, nil, true, true)
    local fivebgSize = fiveSp:getContentSize()
    if l_6_0 % 100 == 99 or l_6_1 and l_6_1 < fiveNum then
      setShader(fiveSp, SHADER_GRAY, true)
    end
    if l_6_0 ~= 5999 then
      local icon = img.createUISprite(img.ui.hero_equip_add)
      icon:setPosition(fiveSp:boundingBox():getMaxX() + 23, fiveSp:boundingBox():getMaxY() + 23)
      fiveSp:addChild(icon)
      icon:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(0.5, 76.5), CCFadeTo:create(0.5, 255))))
    end
    upvalue_1536 = CCMenuItemSprite:create(fiveSp, nil)
    btnFivehero:setScale(0.9)
    btnFivehero:setPosition(295, 165)
    upvalue_2048 = CCMenu:createWithItem(btnFivehero)
    menuFiveHero:setPosition(0, 0)
    temp_item:addChild(menuFiveHero)
    btnFivehero:registerScriptTapHandler(function()
      audio.play(audio.button)
      if fiveGroup == 0 then
        showToast(i18n.global.tenchange_toast_first.string)
        return 
      end
      initfiveHeros(fiveGroup)
      layer:getParent():getParent():getParent():addChild(createFiveSelectBoard(callfuncFive, fiveNum), 2000)
      end)
   end
  createBtnfive(5999)
  local change = img.createLogin9Sprite(img.login.button_9_small_gold)
  change:setPreferredSize(CCSize(160, 52))
  local changelab = lbl.createFont1(18, i18n.global.space_summon_replace.string, lbl.buttonColor)
  changelab:setPosition(CCPoint(change:getContentSize().width / 2, change:getContentSize().height / 2))
  change:addChild(changelab)
  local changeBtn = SpineMenuItem:create(json.ui.button, change)
  changeBtn:setPosition(CCPoint(274, 55))
  local changeMenu = CCMenu:createWithItem(changeBtn)
  changeMenu:setPosition(0, 0)
  temp_item:addChild(changeMenu)
  json.load(json.ui.zhihuan_icon)
  local anim2Zhihuan = DHSkeletonAnimation:createWithKey(json.ui.zhihuan_icon)
  anim2Zhihuan:scheduleUpdateLua()
  anim2Zhihuan:playAnimation("zhihuan_image")
  anim2Zhihuan:setPosition(198, 165)
  temp_item:addChild(anim2Zhihuan, 1001)
  anim2Zhihuan:setVisible(false)
  local createSurechange = function()
    local params = {}
    params.title = ""
    params.btn_count = 0
    local dialoglayer = require("ui.dialog").create(params)
    local arrowSprite = img.createUISprite(img.ui.arrow)
    arrowSprite:setPosition(236, 180)
    dialoglayer.board:addChild(arrowSprite)
    local suretenSp = img.createHeroHead(tenheroData.id, tenheroData.lv, true, true, tenheroData.wake, false)
    local btnSureTenhero = CCMenuItemSprite:create(suretenSp, nil)
    btnSureTenhero:setPosition(136, 180)
    local menuSureTenHero = CCMenu:createWithItem(btnSureTenhero)
    menuSureTenHero:setPosition(0, 0)
    dialoglayer.board:addChild(menuSureTenHero)
    btnSureTenhero:registerScriptTapHandler(function()
      end)
    local surefiveSp = img.createHeroHead(cfglifechange[fiveId].nId, tenheroData.lv, true, true, tenheroData.wake, false)
    local btnSureFivehero = CCMenuItemSprite:create(surefiveSp, nil)
    btnSureFivehero:setPosition(336, 180)
    local menuSureFiveHero = CCMenu:createWithItem(btnSureFivehero)
    menuSureFiveHero:setPosition(0, 0)
    dialoglayer.board:addChild(menuSureFiveHero)
    btnSureFivehero:registerScriptTapHandler(function()
      end)
    local btnYesSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnYesSprite:setPreferredSize(CCSize(153, 50))
    local btnYes = SpineMenuItem:create(json.ui.button, btnYesSprite)
    btnYes:setPosition(332, 80)
    local labYes = lbl.createFont1(18, i18n.global.dialog_button_confirm.string, ccc3(115, 59, 5))
    labYes:setPosition(btnYes:getContentSize().width / 2, btnYes:getContentSize().height / 2)
    btnYesSprite:addChild(labYes)
    local menuYes = CCMenu:create()
    menuYes:setPosition(0, 0)
    menuYes:addChild(btnYes)
    dialoglayer.board:addChild(menuYes)
    local btnNoSprite = img.createLogin9Sprite(img.login.button_9_small_orange)
    btnNoSprite:setPreferredSize(CCSize(153, 50))
    local btnNo = SpineMenuItem:create(json.ui.button, btnNoSprite)
    btnNo:setPosition(142, 80)
    local labNo = lbl.createFont1(18, i18n.global.dialog_button_cancel.string, ccc3(115, 59, 5))
    labNo:setPosition(btnNo:getContentSize().width / 2, btnNo:getContentSize().height / 2)
    btnNoSprite:addChild(labNo)
    local menuNo = CCMenu:create()
    menuNo:setPosition(0, 0)
    menuNo:addChild(btnNo)
    dialoglayer.board:addChild(menuNo)
    btnYes:registerScriptTapHandler(function()
      audio.play(audio.button)
      local params = {sid = player.sid, hostHid = hostHid, hids = fiveHids}
      addWaitNet()
      net:hero_change(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status < 0 then
          showToast("status:" .. l_1_0.status)
          return 
        end
        local animZhihuan = DHSkeletonAnimation:createWithKey(json.ui.zhihuan_icon)
        animZhihuan:scheduleUpdateLua()
        animZhihuan:playAnimation("zhihuan")
        animZhihuan:setPosition(tenSp:boundingBox():getMidX(), tenSp:boundingBox():getMidY())
        tenSp:addChild(animZhihuan, 1001)
        local animZhihuanright = DHSkeletonAnimation:createWithKey(json.ui.zhihuan_icon)
        animZhihuanright:scheduleUpdateLua()
        animZhihuanright:playAnimation("zhihuan_right")
        animZhihuanright:setPosition(fiveSp:boundingBox():getMidX(), fiveSp:boundingBox():getMidY())
        fiveSp:addChild(animZhihuanright, 1001)
        local animZhihuanright2 = DHSkeletonAnimation:createWithKey(json.ui.zhihuan_icon)
        animZhihuanright2:scheduleUpdateLua()
        animZhihuanright2:playAnimation("zhihuan_right")
        animZhihuanright2:setPosition(spStoneBg:getContentSize().width / 2, spStoneBg:getContentSize().height / 2)
        spStoneBg:addChild(animZhihuanright2, 1001)
        changeIcon:setVisible(false)
        anim2Zhihuan:setVisible(true)
        anim2Zhihuan:playAnimation("zhihuan_image")
        local ban = CCLayer:create()
        ban:setTouchEnabled(true)
        ban:setTouchSwallowEnabled(true)
        layer:addChild(ban, 2000)
        bag.items.sub({id = 73, num = 5})
        local exp, evolve, rune = heros.decomposeFortenchange(fiveHids)
        bag.items.add({id = ITEM_ID_HERO_EXP, num = exp})
        bag.items.add({id = ITEM_ID_EVOLVE_EXP, num = evolve})
        bag.items.add({id = ITEM_ID_RUNE_COIN, num = rune})
        local reward = {items = {}, equips = {}}
        if exp > 0 then
          table.insert(reward.items, {id = ITEM_ID_HERO_EXP, num = exp})
        end
        if evolve > 0 then
          table.insert(reward.items, {id = ITEM_ID_EVOLVE_EXP, num = evolve})
        end
        if rune > 0 then
          table.insert(reward.items, {id = ITEM_ID_RUNE_COIN, num = rune})
        end
        for i,v in ipairs(fiveHids) do
          local heroData = heros.find(v)
          if heroData then
            for j,k in ipairs(heroData.equips) do
              if cfgequip[k].pos == EQUIP_POS_JADE then
                bag.items.addAll(cfgequip[k].jadeUpgAll)
                if cfgequip[k].jadeUpgAll[1].num > 0 then
                  table.insert(reward.items, {id = cfgequip[k].jadeUpgAll[1].id, num = cfgequip[k].jadeUpgAll[1].num})
                end
                if cfgequip[k].jadeUpgAll[2].num > 0 then
                  table.insert(reward.items, {id = cfgequip[k].jadeUpgAll[2].id, num = cfgequip[k].jadeUpgAll[2].num})
                  for j,k in (for generator) do
                  end
                  table.insert(reward.equips, {id = k, num = 1})
                end
              end
            end
            heros.del(v)
          end
          do
            local cTenheroData = heros.find(tenheroData.hid)
            for _,v in ipairs(cTenheroData.equips) do
              if cfgequip[v].pos == EQUIP_POS_SKIN then
                bag.equips.returnbag({id = getHeroSkin(cTenheroData.hid), num = 1})
                table.remove(cTenheroData.equips, _)
              end
            end
            heros.tenchange(tenheroData, fiveId)
            dialoglayer:removeFromParentAndCleanup(true)
            schedule(board, 2, function()
            ban:removeFromParent()
            layer:getParent():getParent():getParent():addChild(createBoardForRewards(hostHid, reward), 1002)
            upvalue_2560 = false
            upvalue_3072 = false
            upvalue_1536 = 0
            upvalue_3584 = 0
            upvalue_4096 = 0
            upvalue_4608 = {}
            menuTenHero:removeFromParentAndCleanup()
            upvalue_5120 = nil
            createBtnten(9999, 4)
            menuFiveHero:removeFromParentAndCleanup()
            upvalue_6144 = nil
            createBtnfive(5999)
            showTennum:setString("0/1")
            showTennum:setColor(ccc3(255, 247, 229))
            showFivenum:setString("0/5")
            showFivenum:setColor(ccc3(255, 247, 229))
            upvalue_8192 = stonenum - 5
            if stonenum < 5 then
              showStonenum:setColor(ccc3(255, 116, 116))
            end
            showStonenum:setString(string.format("%d/5", stonenum))
               end)
          end
           -- Warning: missing end command somewhere! Added here
        end
         end)
      end)
    btnNo:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      audio.play(audio.button)
      end)
    local backEvent = function()
      dialoglayer:removeFromParentAndCleanup(true)
      end
    local btn_close0 = img.createUISprite(img.ui.close)
    local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
    btn_close:setPosition(444, 299)
    local btn_close_menu = CCMenu:createWithItem(btn_close)
    btn_close_menu:setPosition(CCPoint(0, 0))
    dialoglayer.board:addChild(btn_close_menu, 100)
    btn_close:registerScriptTapHandler(function()
      audio.play(audio.button)
      backEvent()
      end)
    dialoglayer.onAndroidBack = function()
      backEvent()
      end
    addBackEvent(dialoglayer)
    local onEnter = function()
      dialoglayer.notifyParentLock()
      end
    local onExit = function()
      dialoglayer.notifyParentUnlock()
      end
    dialoglayer:registerScriptHandler(function(l_10_0)
      if l_10_0 == "enter" then
        onEnter()
      elseif l_10_0 == "exit" then
        onExit()
      end
      end)
    return dialoglayer
   end
  changeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if fiveHids and #fiveHids < fiveNum then
      showToast(i18n.global.hero_wake_no_hero.string)
      return 
    end
    local stonenum = 0
    if bag.items.find(73) then
      stonenum = bag.items.find(73).num
    end
    if stonenum < 5 then
      showToast(i18n.global.tenchange_toast_noitem.string)
      return 
    end
    if tenheroData.id == cfglifechange[fiveId].nId then
      showToast(i18n.global.tenchange_toast_nosamehero.string)
      return 
    end
    local dialog = createSurechange()
    layer:getParent():getParent():getParent():addChild(dialog, 300)
   end)
  return layer
end

return ui


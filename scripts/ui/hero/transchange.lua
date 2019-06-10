-- Command line was: E:\github\dhgametool\scripts\ui\hero\transchange.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local cfghero = require("config.hero")
local cfgequip = require("config.equip")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local particle = require("res.particle")
local cfgactivity = require("config.activity")
local tipsitem = require("ui.tips.item")
local cfglifechange = require("config.lifechange")
local cfgtalen = require("config.talen")
local cfgtalenreturn = require("config.talenreturn")
local cfgvip = require("config.vip")
local tmpheros = {}
local operData = {}
local fiveData = {}
local initfiveHeros = function(l_1_0)
  do
    local tmpheros = {}
    for i,v in ipairs(heros) do
      if not v.flag then
        tmpheros[#tmpheros + 1] = {hid = v.hid, id = v.id, lv = v.lv, wake = v.wake, star = v.star, isUsed = false, flag = not cfglifechange[v.id] or cfghero[v.id].maxStar ~= 5 or cfghero[v.id].group ~= l_1_0 or 0}
      end
      fiveData.heros = tmpheros
    end
     -- Warning: missing end command somewhere! Added here
  end
end

local createFiveSelectBoard = function(l_2_0, l_2_1)
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
    elseif nowId == 0 then
      upvalue_1024 = headData[l_4_0].id
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

ui.create = function(l_3_0)
  local layer = CCLayer:create()
  local heroData = heros.find(l_3_0)
  local bgg = img.createUISprite(img.ui.transchage_bg)
  bgg:setScale(view.minScale)
  bgg:setPosition(view.midX, view.midY)
  layer:addChild(bgg)
  local bg = img.createUISprite(img.ui.transchage_paper)
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  local bg_w = bg:getContentSize().width
  local bg_h = bg:getContentSize().height
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = HHMenuItem:create(btnBackSprite)
  btnBack:setScale(view.minScale)
  btnBack:setPosition(scalep(35, 546))
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  layer:addChild(menuBack, 1000)
  layer.back = btnBack
  btnBack:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  autoLayoutShift(btnBack)
  local btnInfoSprite = img.createUISprite(img.ui.btn_help)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setScale(view.minScale)
  btnInfo:setPosition(scalep(930, 550))
  local menuInfo = CCMenu:createWithItem(btnInfo)
  menuInfo:setPosition(0, 0)
  layer:addChild(menuInfo, 100)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.help").create(i18n.global.help_transchange.string, i18n.global.help_title.string), 1000)
   end)
  autoLayoutShift(btnInfo)
  local selectLayer, createChange = nil, nil
  local btn_normal0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
  btn_normal0:setPreferredSize(CCSizeMake(190, 50))
  local btn_normal_sel = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_normal_sel:setPreferredSize(CCSizeMake(190, 50))
  btn_normal_sel:setPosition(CCPoint(btn_normal0:getContentSize().width / 2, btn_normal0:getContentSize().height / 2))
  btn_normal0:addChild(btn_normal_sel)
  local lbl_normal = lbl.createFont1(18, i18n.global.space_summon_replace.string, ccc3(115, 59, 5))
  lbl_normal:setPosition(CCPoint(btn_normal0:getContentSize().width / 2, btn_normal0:getContentSize().height / 2))
  btn_normal0:addChild(lbl_normal)
  local btn_normal = SpineMenuItem:create(json.ui.button, btn_normal0)
  btn_normal:setPosition(CCPoint(bg_w / 2 - 100, bg_h - 48))
  local btn_normal_menu = CCMenu:createWithItem(btn_normal)
  btn_normal_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_normal_menu)
  local btn_rphero0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
  btn_rphero0:setPreferredSize(CCSizeMake(190, 50))
  local btn_rphero_sel = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_rphero_sel:setPreferredSize(CCSizeMake(190, 50))
  btn_rphero_sel:setPosition(CCPoint(btn_rphero0:getContentSize().width / 2, btn_rphero0:getContentSize().height / 2))
  btn_rphero0:addChild(btn_rphero_sel)
  local lbl_rphero = lbl.createFont1(18, i18n.global.transchange_return_btn.string, ccc3(115, 59, 5))
  lbl_rphero:setPosition(CCPoint(btn_rphero0:getContentSize().width / 2, btn_rphero0:getContentSize().height / 2))
  btn_rphero0:addChild(lbl_rphero)
  local btn_rphero = SpineMenuItem:create(json.ui.button, btn_rphero0)
  btn_rphero:setPosition(CCPoint(bg_w / 2 + 100, bg_h - 48))
  local btn_rphero_menu = CCMenu:createWithItem(btn_rphero)
  btn_rphero_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_rphero_menu)
  btn_normal_sel:setVisible(false)
  btn_rphero_sel:setVisible(false)
  local createChange = function()
    local changeLayer = CCLayer:create()
    img.load(img.packedOthers.spine_ui_shixingzhihuan)
    json.load(json.ui.shixingzhihuan)
    local aniShixing = DHSkeletonAnimation:createWithKey(json.ui.shixingzhihuan)
    aniShixing:scheduleUpdateLua()
    aniShixing:playAnimation("start")
    schedule(changeLayer, 6.6, function()
      aniShixing:registerAnimation("loop", -1)
      end)
    aniShixing:setPosition(CCPoint(bg_w / 2, 268))
    changeLayer:addChild(aniShixing)
    json.load(json.ui.black)
    local aniBlack = DHSkeletonAnimation:createWithKey(json.ui.black)
    aniBlack:scheduleUpdateLua()
    aniBlack:setPosition(CCPoint(bg_w / 2, 268))
    aniShixing:addChildFollowSlot("code_black", aniBlack)
    local fiveGroup = cfghero[heroData.id].group
    local spStoneBg = img.createUISprite(img.ui.grid)
    local spStone = img.createItemIcon(73)
    spStone:setPosition(spStoneBg:getContentSize().width / 2, spStoneBg:getContentSize().height / 2)
    spStoneBg:addChild(spStone)
    local btnSpStone = CCMenuItemSprite:create(spStoneBg, nil)
    btnSpStone:setScale(0.84)
    local menubtnSpStone = CCMenu:createWithItem(btnSpStone)
    menubtnSpStone:setPosition(0, 0)
    aniShixing:addChildFollowSlot("code_03_kuang", menubtnSpStone)
    btnSpStone:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:addChild(tipsitem.createForShow({id = 73}), 1000)
      end)
    local stonenum = 0
    if bag.items.find(73) then
      stonenum = bag.items.find(73).num
    end
    local showStonenum = lbl.createFont2(16, string.format("%d/5", stonenum), ccc3(255, 116, 116))
    showStonenum:setPosition(spStoneBg:getContentSize().width / 2, -10)
    spStoneBg:addChild(showStonenum)
    local fiveNum = 5
    if heroData.wake > 4 then
      fiveNum = cfgtalen[heroData.wake - 4].lifeChangeCount
    else
      fiveNum = 5
    end
    if stonenum < 5 then
      showStonenum:setColor(ccc3(255, 116, 116))
    else
      showStonenum:setColor(ccc3(255, 247, 229))
    end
    local fiveHids = {}
    local fiveId = 0
    local fiveSp, targetHero = nil, nil
    local createTargetHero = function()
      if targetHero then
        targetHero:removeFromParentAndCleanup()
        targetHero = nil
      end
      if fiveId ~= 0 then
        local targetSp = img.createHeroHead(cfglifechange[fiveId].nId, heroData.lv, true, true, heroData.wake, false)
        targetHero = CCMenuItemSprite:create(targetSp, nil)
        targetHero:setScale(0.9)
        local menuFiveHero = CCMenu:createWithItem(targetHero)
        menuFiveHero:setPosition(0, 0)
        aniShixing:addChildFollowSlot("code_center_kuang", menuFiveHero)
        targetHero:registerScriptTapHandler(function()
            end)
      else
        targetHero = img.createUISprite(img.ui.hero_star_ten_bg)
        targetHero:setScale(0.9)
        local targetStar = img.createUISprite(img.ui.hero_star_ten)
        targetStar:setPosition(targetHero:getContentSize().width / 2, 14)
        targetHero:addChild(targetStar)
        local wenhaoIcon = img.createUISprite(img.ui.transchage_wenhao)
        wenhaoIcon:setPosition(targetHero:getContentSize().width / 2, targetHero:getContentSize().height / 2)
        targetHero:addChild(wenhaoIcon)
        aniShixing:addChildFollowSlot("code_center_kuang", targetHero)
      end
      end
    createTargetHero()
    local tenSp, btnTenhero, menuTenHero, createBtnten, btnFivehero, menuFiveHero, createBtnfive = nil, nil, nil, nil, nil, nil, nil
    local createSurechange = function()
      local params = {}
      params.title = ""
      params.btn_count = 0
      local dialoglayer = require("ui.dialog").create(params)
      local arrowSprite = img.createUISprite(img.ui.arrow)
      arrowSprite:setPosition(236, 180)
      dialoglayer.board:addChild(arrowSprite)
      local suretenSp = img.createHeroHead(heroData.id, heroData.lv, true, true, heroData.wake, false)
      local btnSureTenhero = CCMenuItemSprite:create(suretenSp, nil)
      btnSureTenhero:setPosition(136, 180)
      local menuSureTenHero = CCMenu:createWithItem(btnSureTenhero)
      menuSureTenHero:setPosition(0, 0)
      dialoglayer.board:addChild(menuSureTenHero)
      btnSureTenhero:registerScriptTapHandler(function()
         end)
      local surefiveSp = img.createHeroHead(cfglifechange[fiveId].nId, heroData.lv, true, true, heroData.wake, false)
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
        local params = {sid = player.sid, hostHid = heroData.hid, hids = fiveHids}
        tbl2string(params)
        addWaitNet()
        net:hero_change(params, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          if l_1_0.status < 0 then
            showToast("status:" .. l_1_0.status)
            return 
          end
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
            local cheroData = heros.find(v)
            if cheroData then
              for j,k in ipairs(cheroData.equips) do
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
            local cTenheroData = heros.find(hid)
            for _,v in ipairs(cTenheroData.equips) do
              if cfgequip[v].pos == EQUIP_POS_SKIN then
                bag.equips.returnbag({id = getHeroSkin(cTenheroData.hid), num = 1})
                table.remove(cTenheroData.equips, _)
              end
            end
            do
              local targethid = heroData.hid
              heros.tenchange(heroData, fiveId)
              dialoglayer:removeFromParentAndCleanup(true)
              aniBlack:playAnimation("animation")
              aniShixing:playAnimation("composite")
              schedule(layer, 2.2, function()
              replaceScene(require("ui.herolist.main").create({hosthid = targethid, reward = reward}))
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
    createBtnten = function(l_5_0, l_5_1)
      if l_5_1 == 4 then
        tenSp = img.createHeroHead(l_5_0, nil, true, false, l_5_1, false)
      else
        tenSp = img.createHeroHead(l_5_0, nil, true, true, l_5_1, false)
      end
      local bgSize = tenSp:getContentSize()
      if l_5_1 == 4 then
        local star = img.createUISprite(img.ui.hero_star_ten)
        star:setScale(0.75)
        star:setPosition(bgSize.width / 2, 14)
        tenSp:addChild(star)
      end
      upvalue_1024 = CCMenuItemSprite:create(tenSp, nil)
      btnTenhero:setScale(0.8)
      upvalue_1536 = CCMenu:createWithItem(btnTenhero)
      menuTenHero:setPosition(0, 0)
      aniShixing:addChildFollowSlot("code_01_kuang", menuTenHero)
      btnTenhero:registerScriptTapHandler(function()
         end)
      end
    createBtnten(heroData.id, heroData.wake)
    local showFivenum = nil
    local callfuncFive = function(l_6_0, l_6_1)
      if fiveflag == false then
        fiveflag = true
        clearShader(btnFivehero, true)
      end
      upvalue_512 = l_6_1
      createTargetHero()
      upvalue_1536 = l_6_0
      menuFiveHero:removeFromParentAndCleanup()
      upvalue_2048 = nil
      createBtnfive(l_6_1, #l_6_0)
      end
    createBtnfive = function(l_7_0, l_7_1)
      fiveSp = img.createHeroHead(l_7_0, nil, true, true)
      local fivebgSize = fiveSp:getContentSize()
      if l_7_0 % 100 == 99 or l_7_1 and l_7_1 < fiveNum then
        setShader(fiveSp, SHADER_GRAY, true)
      end
      local icon = img.createUISprite(img.ui.hero_equip_add)
      icon:setPosition(fiveSp:boundingBox():getMaxX() + 23, fiveSp:boundingBox():getMaxY() + 23)
      fiveSp:addChild(icon)
      icon:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(0.5, 76.5), CCFadeTo:create(0.5, 255))))
      upvalue_1536 = lbl.createFont2(18, l_7_1 .. "/" .. fiveNum, ccc3(255, 116, 116))
      showFivenum:setPosition(fiveSp:getContentSize().width / 2, -10)
      fiveSp:addChild(showFivenum)
      upvalue_2560 = CCMenuItemSprite:create(fiveSp, nil)
      btnFivehero:setScale(0.8)
      if l_7_1 < fiveNum then
        showFivenum:setColor(ccc3(255, 116, 116))
      else
        showFivenum:setColor(ccc3(255, 247, 229))
      end
      upvalue_3072 = CCMenu:createWithItem(btnFivehero)
      menuFiveHero:setPosition(0, 0)
      aniShixing:addChildFollowSlot("code_02_kuang", menuFiveHero)
      btnFivehero:registerScriptTapHandler(function()
        audio.play(audio.button)
        if fiveGroup == 0 then
          showToast(i18n.global.tenchange_toast_first.string)
          return 
        end
        initfiveHeros(fiveGroup)
        layer:addChild(createFiveSelectBoard(callfuncFive, fiveNum), 2000)
         end)
      end
    createBtnfive(5999, 0)
    local showTennum = lbl.createFont2(18, "1/1", ccc3(255, 247, 229))
    showTennum:setPosition(tenSp:getContentSize().width / 2, -10)
    tenSp:addChild(showTennum)
    local btnChangeSp = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnChangeSp:setPreferredSize(CCSize(155, 55))
    local labChange = lbl.createFont1(20, i18n.global.space_summon_replace.string, ccc3(106, 61, 37))
    labChange:setPosition(btnChangeSp:getContentSize().width / 2, btnChangeSp:getContentSize().height / 2)
    btnChangeSp:addChild(labChange)
    local btnChange = SpineMenuItem:create(json.ui.button, btnChangeSp)
    btnChange:setPosition(bg_w / 2, 60)
    local menuChange = CCMenu:createWithItem(btnChange)
    menuChange:setPosition(0, 0)
    changeLayer:addChild(menuChange)
    btnChange:registerScriptTapHandler(function()
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
      if heroData.id == cfglifechange[fiveId].nId then
        showToast(i18n.global.tenchange_toast_nosamehero.string)
        return 
      end
      local dialog = createSurechange()
      layer:addChild(dialog, 1000)
      end)
    return changeLayer
   end
  local createReturn = function()
    local returnLayer = CCLayer:create()
    local flower1 = img.createUISprite(img.ui.transchage_flower1)
    flower1:setPosition(bg_w / 2, 340)
    returnLayer:addChild(flower1)
    local flower2 = img.createUISprite(img.ui.transchage_flower2)
    flower2:setPosition(bg_w / 2, 168)
    returnLayer:addChild(flower2)
    local showStr1 = lbl.createMixFont1(16, i18n.global.return_hero.string, ccc3(106, 61, 37))
    showStr1:setPosition(bg_w / 2, 415)
    returnLayer:addChild(showStr1)
    local showStr2 = lbl.createMixFont1(16, i18n.global.ui_decompose_preview.string, ccc3(106, 61, 37))
    showStr2:setPosition(bg_w / 2, 245)
    returnLayer:addChild(showStr2)
    local tenSp, btnTenhero, menuTenHero = nil, nil, nil
    tbl2string(heroData)
    if heroData.wake == 4 then
      tenSp = img.createHeroHead(heroData.id, heroData.lv, true, false, heroData.wake, false)
    else
      tenSp = img.createHeroHead(heroData.id, heroData.lv, true, true, heroData.wake, false)
    end
    local bgSize = tenSp:getContentSize()
    if heroData.wake == 4 then
      local star = img.createUISprite(img.ui.hero_star_ten)
      star:setScale(0.75)
      star:setPosition(bgSize.width / 2, 14)
      tenSp:addChild(star)
    end
    btnTenhero = CCMenuItemSprite:create(tenSp, nil)
    btnTenhero:setScale(0.74)
    btnTenhero:setPosition(bg_w / 2 - 50, 345)
    menuTenHero = CCMenu:createWithItem(btnTenhero)
    menuTenHero:setPosition(0, 0)
    returnLayer:addChild(menuTenHero)
    btnTenhero:registerScriptTapHandler(function()
      audio.play(audio.button)
      end)
    local spStoneBg = img.createUISprite(img.ui.grid)
    local spStone = img.createItemIcon(73)
    spStone:setPosition(spStoneBg:getContentSize().width / 2, spStoneBg:getContentSize().height / 2)
    spStoneBg:addChild(spStone)
    local btnSpStone = CCMenuItemSprite:create(spStoneBg, nil)
    btnSpStone:setPosition(bg:getContentSize().width / 2 + 50, 345)
    btnSpStone:setScale(0.83)
    local menubtnSpStone = CCMenu:createWithItem(btnSpStone)
    menubtnSpStone:setPosition(0, 0)
    returnLayer:addChild(menubtnSpStone)
    btnSpStone:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:addChild(tipsitem.createForShow({id = 73}), 1000)
      end)
    local stonenum = 0
    if bag.items.find(73) then
      stonenum = bag.items.find(73).num
    end
    local showStonenum = lbl.createFont2(16, string.format("%d/5", stonenum), ccc3(255, 116, 116))
    showStonenum:setPosition(bg:getContentSize().width / 2 + 50, 295)
    returnLayer:addChild(showStonenum)
    local fiveNum = 5
    if heroData.wake > 4 then
      fiveNum = cfgtalen[heroData.wake - 4].lifeChangeCount
    else
      fiveNum = 5
    end
    if stonenum < 5 then
      showStonenum:setColor(ccc3(255, 116, 116))
    else
      showStonenum:setColor(ccc3(255, 247, 229))
    end
    local showTennum = lbl.createFont2(16, "1/1", ccc3(255, 247, 229))
    showTennum:setPosition(bg:getContentSize().width / 2 - 50, 295)
    returnLayer:addChild(showTennum)
    local btnReturnSp = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnReturnSp:setPreferredSize(CCSize(155, 55))
    local labReturn = lbl.createFont1(20, i18n.global.transchange_return_btn.string, ccc3(106, 61, 37))
    labReturn:setPosition(btnReturnSp:getContentSize().width / 2, btnReturnSp:getContentSize().height / 2)
    btnReturnSp:addChild(labReturn)
    local btnReturn = SpineMenuItem:create(json.ui.button, btnReturnSp)
    btnReturn:setPosition(bg_w / 2, 60)
    local menuReturn = CCMenu:createWithItem(btnReturn)
    menuReturn:setPosition(0, 0)
    returnLayer:addChild(menuReturn)
    local heroGroup = cfghero[heroData.id].group
    local returnReward = cfgtalenreturn[heroData.wake + 6].hero[heroGroup].hero
    local returnNum = 0
    for i = 1, #returnReward + 1 do
      local returnIconSp = nil
      local returnFiveCount = 5
      if i < #returnReward + 1 then
        returnIconSp = img.createHeroHead(returnReward[i].id, 1, true, true, returnReward[i].wake, false)
        returnFiveCount = returnReward[i].count
      else
        returnIconSp = img.createHeroHead(cfghero[heroData.id].fiveStarId, 1, true, true)
        returnFiveCount = cfgtalenreturn[heroData.wake + 6].self
      end
      local btnReturnIcon = CCMenuItemSprite:create(returnIconSp, nil)
      btnReturnIcon:setScale(0.68)
      btnReturnIcon:setPosition(bg_w / 2 - 42 * #returnReward + 86 * (i - 1), 178)
      local menuReturnIcon = CCMenu:createWithItem(btnReturnIcon)
      menuReturnIcon:setPosition(0, 0)
      returnLayer:addChild(menuReturnIcon)
      local showHeroNum = lbl.createFont2(16, returnFiveCount, ccc3(255, 247, 229))
      showHeroNum:setPosition(bg_w / 2 - 42 * #returnReward + 86 * (i - 1), 132)
      returnLayer:addChild(showHeroNum)
      returnNum = returnNum + returnFiveCount
      btnReturnIcon:registerScriptTapHandler(function()
        audio.play(audio.button)
         end)
    end
    btnReturn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if cfgvip[player.vipLv()].heroes + player.buy_hlimit * 5 < #heros + returnNum - 1 then
        local gotoHeroDlg = require("ui.summon.tipsdialog")
        gotoHeroDlg.show(layer)
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
      local returnCallback = function()
        local params = {sid = player.sid, hid = heroData.hid}
        tbl2string(params)
        addWaitNet()
        net:hero_return(params, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          if l_1_0.status == -2 then
            local gotoHeroDlg = require("ui.summon.tipsdialog")
            gotoHeroDlg.show(layer)
            return 
          end
          if l_1_0.status < 0 then
            showToast("status:" .. l_1_0.status)
            return 
          end
          local ban = CCLayer:create()
          ban:setTouchEnabled(true)
          ban:setTouchSwallowEnabled(true)
          layer:addChild(ban, 2000)
          bag.items.sub({id = 73, num = 5})
          do
            local reward = {items = {}, equips = {}}
            for j,k in ipairs(heroData.equips) do
              if cfgequip[k].pos == EQUIP_POS_JADE then
                for j,k in (for generator) do
                end
                bag.equips.returnbag({id = k, num = 1})
                table.insert(reward.equips, {id = k, num = 1})
              end
              for _,v in ipairs(heroData.equips) do
                if cfgequip[v].pos == EQUIP_POS_SKIN then
                  table.remove(heroData.equips, _)
                end
              end
              for _,v in ipairs(l_1_0.items) do
                if v.num > 0 then
                  table.insert(reward.items, v)
                  bag.items.add(v)
                end
              end
              heros.del(heroData.hid, true)
              heros.addAllForReturn(l_1_0.heroes)
              replaceScene(require("ui.herolist.main").create({heroes = l_1_0.heroes, reward = reward}))
            end
             -- Warning: missing end command somewhere! Added here
          end
            end)
         end
      local sureDialog = require("ui.suredialog")
      layer:addChild(sureDialog.create(i18n.global.toast_return_sure.string, returnCallback), 1000)
      end)
    return returnLayer
   end
  local onNormal = function()
    if selectLayer then
      selectLayer:removeFromParentAndCleanup()
      selectLayer = nil
    end
    selectLayer = createChange()
    bg:addChild(selectLayer)
    btn_normal_sel:setVisible(true)
    btn_rphero_sel:setVisible(false)
    btn_normal:setEnabled(false)
    btn_rphero:setEnabled(true)
   end
  local onrphero = function()
    if selectLayer then
      selectLayer:removeFromParentAndCleanup()
      selectLayer = nil
    end
    selectLayer = createReturn()
    bg:addChild(selectLayer)
    btn_normal_sel:setVisible(false)
    btn_rphero_sel:setVisible(true)
    btn_normal:setEnabled(true)
    btn_rphero:setEnabled(false)
   end
  btn_normal:registerScriptTapHandler(function()
    audio.play(audio.button)
    onNormal()
   end)
  btn_rphero:registerScriptTapHandler(function()
    audio.play(audio.button)
    onrphero()
   end)
  onNormal()
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_12_0)
    if l_12_0 == "enter" then
      onEnter()
    elseif l_12_0 == "exit" then
      onExit()
    elseif l_12_0 == "cleanup" then
      json.unload(json.ui.black)
      json.unload(json.ui.shixingzhihuan)
      img.unload(img.packedOthers.spine_ui_shixingzhihuan)
    end
   end)
  layer:setTouchEnabled(true)
  return layer
end

return ui


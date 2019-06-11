-- Command line was: E:\github\dhgametool\scripts\ui\activity\dwarf.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local cfggift = require("config.gift")
local player = require("data.player")
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local bag = require("data.bag")
local IDS = activityData.IDS
local ItemType = {Item = 1, Equip = 2}
local act_ids = {IDS.DWARF_1.ID, IDS.DWARF_2.ID, IDS.DWARF_3.ID}
ui.createSelectBoard = function(l_1_0, l_1_1)
  local index = l_1_0.index
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 210))
  local board = img.createUI9Sprite(img.ui.tips_bg)
  board:setPreferredSize(CCSize(550, 476))
  board:setScale(view.minScale)
  board:setPosition(scalep(480, 288))
  layer:addChild(board)
  local showTitle = lbl.createFont1(20, i18n.global.smith_target.string, ccc3(255, 227, 134))
  showTitle:setPosition(275, 445)
  board:addChild(showTitle)
  local showFgline = img.createUI9Sprite(img.ui.hero_enchant_info_fgline)
  showFgline:setPreferredSize(CCSize(470, 1))
  showFgline:setPosition(275, 420)
  board:addChild(showFgline)
  local backEvent = function()
    layer:removeFromParentAndCleanup(true)
   end
  local btnCloseSp = img.createLoginSprite(img.login.button_close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSp)
  btnClose:setPosition(530, 450)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose, 1000)
  btnClose:registerScriptTapHandler(function()
    backEvent()
    audio.play(audio.button)
   end)
  local cfg = cfgactivity[l_1_0.id]
  local cfgrewards = cfg.rewards
  local height = 155 * #cfgrewards
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(0, 76)
  scroll:setViewSize(CCSize(550, 334))
  scroll:setContentSize(CCSize(520, height))
  board:addChild(scroll)
  local tick = {}
  for i = 1, #cfgrewards do
    do
      local temp_item = img.createUI9Sprite(img.ui.bottom_border_2)
      temp_item:setPreferredSize(CCSizeMake(463, 145))
      local item_w = temp_item:getContentSize().width
      local item_h = temp_item:getContentSize().height
      local sx, dx = 62, 87
      local _objgift = cfggift[cfgrewards[i].id].giftGoods
      local labSuitname = lbl.createMixFont1(18, i18n.equip[_objgift[1].id].suitName, ccc3(106, 61, 37))
      labSuitname:setAnchorPoint(0, 0.5)
      labSuitname:setPosition(25, temp_item:getContentSize().height - 28)
      temp_item:addChild(labSuitname)
      for ii = 1, #_objgift do
        local _obj = _objgift[ii]
        do
          if _obj.type == ItemType.Equip then
            local _item0 = img.createEquip(_obj.id, 1)
            local _item = CCMenuItemSprite:create(_item0, nil)
            _item:setScale(0.9)
            _item:setPosition(CCPoint(sx + (ii - 1) * dx, 60))
            local _item_menu = CCMenu:createWithItem(_item)
            _item_menu:setPosition(CCPoint(0, 0))
            temp_item:addChild(_item_menu)
            _item:registerScriptTapHandler(function()
              audio.play(audio.button)
              layer:addChild(tipsequip.createById(_obj.id), 1000)
                  end)
          else
            if _obj.type == ItemType.Item then
              local _item0 = img.createItem(_obj.id, 1)
              local _item = CCMenuItemSprite:create(_item0, nil)
              _item:setScale(0.9)
              _item:setPosition(CCPoint(sx + (ii - 1) * dx, 60))
              local _item_menu = CCMenu:createWithItem(_item)
              _item_menu:setPosition(CCPoint(0, 0))
              temp_item:addChild(_item_menu)
              _item:registerScriptTapHandler(function()
                audio.play(audio.button)
                layer:addChild(tipsitem.createForShow({id = _obj.id}), 1000)
                     end)
            end
          end
        end
      end
      local tickbg = img.createUISprite(img.ui.guildFight_tick_bg)
      tick[i] = img.createUISprite(img.ui.hook_btn_sel)
      tick[i]:setScale(0.75)
      tick[i]:setPosition(tickbg:getContentSize().width / 2 + 5, tickbg:getContentSize().height / 2 + 3)
      tickbg:addChild(tick[i])
      tick[i]:setVisible(i == index)
      local tickBtn = SpineMenuItem:create(json.ui.button, tickbg)
      tickBtn:setPosition(temp_item:getContentSize().width - 55, temp_item:getContentSize().height / 2)
      local tickmenu = CCMenu:createWithItem(tickBtn)
      tickmenu:setPosition(0, 0)
      temp_item:addChild(tickmenu)
      tickBtn:registerScriptTapHandler(function()
        audio.play(audio.button)
        if tick[index] then
          tick[index]:setVisible(false)
        end
        upvalue_1024 = i
        tick[i]:setVisible(i == index)
         end)
      temp_item:setPosition(275, height - 155 * i + 80)
      scroll:getContainer():addChild(temp_item)
    end
  end
  scroll:setContentOffset(ccp(0, 334 - height))
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
  layer:registerScriptHandler(function(l_9_0)
    if l_9_0 == "enter" then
      onEnter()
    elseif l_9_0 == "exit" then
      onExit()
    end
   end)
  local btnSelectSp = img.createLogin9Sprite(img.login.button_9_small_gold)
  btnSelectSp:setPreferredSize(CCSize(120, 48))
  local labSelect = lbl.createFont1(16, i18n.global.heroforge_board_btn.string, ccc3(106, 61, 37))
  labSelect:setPosition(btnSelectSp:getContentSize().width / 2, btnSelectSp:getContentSize().height / 2)
  btnSelectSp:addChild(labSelect)
  local btnSelect = SpineMenuItem:create(json.ui.button, btnSelectSp)
  btnSelect:setPosition(275, 45)
  local menuSelect = CCMenu:createWithItem(btnSelect)
  menuSelect:setPosition(0, 0)
  board:addChild(menuSelect)
  btnSelect:registerScriptTapHandler(function()
    layer:removeFromParentAndCleanup(true)
    callfunc(index)
   end)
  return layer
end

ui.create = function()
  local layer = CCLayer:create()
  local acts = {}
  for _,v in ipairs(act_ids) do
    local tmp_status = activityData.getStatusById(v)
    acts[#acts + 1] = tmp_status
  end
  local actsInfo = {1 = {id = IDS.DWARF_1.ID, index = nil}, 2 = {id = IDS.DWARF_2.ID, index = nil}, 3 = {id = IDS.DWARF_3.ID, index = 0}}
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(576, 436))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_dwarf)
  local banner = img.createUISprite("activity_dwarves_board.png")
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h))
  board:addChild(banner)
  local bannerLabel = nil
  if i18n.getCurrentLanguage() == kLanguageKorean then
    bannerLabel = img.createUISprite("activity_dwarves_kr.png")
  else
    if i18n.getCurrentLanguage() == kLanguageChineseTW then
      bannerLabel = img.createUISprite("activity_dwarves_tw.png")
    else
      if i18n.getCurrentLanguage() == kLanguageJapanese then
        bannerLabel = img.createUISprite("activity_dwarves_jp.png")
      else
        if i18n.getCurrentLanguage() == kLanguageRussian then
          bannerLabel = img.createUISprite("activity_dwarves_ru.png")
        else
          if i18n.getCurrentLanguage() == kLanguagePortuguese then
            bannerLabel = img.createUISprite("activity_dwarves_pt.png")
          else
            if i18n.getCurrentLanguage() == kLanguageChinese then
              bannerLabel = img.createUISprite("activity_dwarves_cn.png")
            else
              bannerLabel = img.createUISprite("activity_dwarves_en.png")
            end
          end
        end
      end
    end
  end
  bannerLabel:setAnchorPoint(CCPoint(0.5, 0.5))
  bannerLabel:setPosition(CCPoint(364, 104))
  banner:addChild(bannerLabel)
  local lbl_cd_des = lbl.createFont2(14, i18n.global.activity_to_end.string)
  lbl_cd_des:setAnchorPoint(CCPoint(0, 0.5))
  lbl_cd_des:setPosition(CCPoint(352, 20))
  banner:addChild(lbl_cd_des)
  local lbl_cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
  lbl_cd:setAnchorPoint(CCPoint(1, 0.5))
  lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMinX() - 6, 20))
  banner:addChild(lbl_cd)
  if i18n.getCurrentLanguage() == kLanguageRussian then
    lbl_cd_des:setPosition(CCPoint(276, 20))
    lbl_cd:setAnchorPoint(CCPoint(0, 0.5))
    lbl_cd:setPosition(CCPoint(lbl_cd_des:boundingBox():getMaxX() + 10, 20))
  end
  local itemParams = {}
  local showGem = {}
  local showCoin = {}
  local coinNum = {}
  local gemNum = {}
  local updateCallback = function(l_1_0, l_1_1)
    l_1_1:setString(i18n.global.limitact_limit.string .. acts[l_1_0].limits)
    if acts[l_1_0].limits < 1 then
      setShader(itemParams[l_1_0].btnMake, SHADER_GRAY, true)
      itemParams[l_1_0].btnMake:setEnabled(false)
    end
    for posi = l_1_0, #itemParams do
      for i = 1, #itemParams[posi]._equipsLabel do
        itemParams[posi]._equipsLabel[i]:setString(itemParams[posi].equipNum[i] .. "/1")
        if itemParams[posi].equipNum[i] < 1 then
          itemParams[posi]._equipsLabel[i]:setColor(ccc3(250, 53, 53))
        else
          itemParams[posi]._equipsLabel[i]:setColor(ccc3(195, 255, 66))
        end
      end
      local flagbtn = true
      for i = 1, #itemParams[posi]._equipsLabel do
        if itemParams[posi].equipNum[i] < 1 then
          setShader(itemParams[posi].btnMake, SHADER_GRAY, true)
          itemParams[posi].btnMake:setEnabled(false)
          flagbtn = false
      else
        end
      end
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if flagbtn and acts[posi].limits > 0 and coinNum[posi] <= bag.coin() and gemNum[posi] <= bag.gem() and actsInfo[posi].index and actsInfo[posi].index > 0 then
        clearShader(itemParams[posi].btnMake, true)
        itemParams[posi].btnMake:setEnabled(true)
        do return end
        clearShader(itemParams[posi].btnMake, true)
        itemParams[posi].btnMake:setEnabled(true)
      end
    end
   end
  local createSurebuy = function(l_2_0, l_2_1, l_2_2, l_2_3)
    local params = {}
    params.btn_count = 0
    params.body = string.format(i18n.global.dwarf_sure.string, 20)
    local board_w = 474
    local dialoglayer = require("ui.dialog").create(params)
    local btnYesSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnYesSprite:setPreferredSize(CCSize(153, 50))
    local btnYes = SpineMenuItem:create(json.ui.button, btnYesSprite)
    btnYes:setPosition(board_w / 2 + 95, 100)
    local labYes = lbl.createFont1(18, i18n.global.board_confirm_yes.string, ccc3(115, 59, 5))
    labYes:setPosition(btnYes:getContentSize().width / 2, btnYes:getContentSize().height / 2)
    btnYesSprite:addChild(labYes)
    local menuYes = CCMenu:create()
    menuYes:setPosition(0, 0)
    menuYes:addChild(btnYes)
    dialoglayer.board:addChild(menuYes)
    local btnNoSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnNoSprite:setPreferredSize(CCSize(153, 50))
    local btnNo = SpineMenuItem:create(json.ui.button, btnNoSprite)
    btnNo:setPosition(board_w / 2 - 95, 100)
    local labNo = lbl.createFont1(18, i18n.global.board_confirm_no.string, ccc3(115, 59, 5))
    labNo:setPosition(btnNo:getContentSize().width / 2, btnNo:getContentSize().height / 2)
    btnNoSprite:addChild(labNo)
    local menuNo = CCMenu:create()
    menuNo:setPosition(0, 0)
    menuNo:addChild(btnNo)
    dialoglayer.board:addChild(menuNo)
    btnYes:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      if bag.gem() < gemNum[pos] then
        showToast(i18n.global.gboss_fight_st6.string)
        return 
      end
      if bag.coin() < coinNum[pos] then
        showToast(i18n.global.crystal_toast_coin.string)
        return 
      end
      local param = {sid = player.sid, id = vpObj.id, index = vpObj.index}
      tbl2string(param)
      addWaitNet()
      netClient:dwarf(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status < 0 then
          showToast(i18n.global.pet_smaterial_not_enough.string)
          return 
        end
        for ii = 1, #cfg.extra do
          local _obj = cfg.extra[ii]
          if _obj.type == ItemType.Equip then
            bag.equips.sub({id = _obj.id, num = _obj.num})
          else
            bag.items.sub({id = _obj.id, num = _obj.num})
          end
        end
        local reward = {items = {}, equips = {}}
        if vpObj.index then
          for ii = 1, #cfggift[cfg.rewards[vpObj.index].id].giftGoods do
            local _obj = cfggift[cfg.rewards[vpObj.index].id].giftGoods[ii]
            bag.equips.add({id = _obj.id, num = _obj.num})
            table.insert(reward.equips, {id = _obj.id, num = _obj.num})
          end
        else
          for ii = 1, #cfg.rewards do
            local _obj = cfg.rewards[ii]
            bag.equips.add({id = _obj.id, num = _obj.num})
            table.insert(reward.equips, {id = _obj.id, num = _obj.num})
          end
        end
        acts[pos].limits = acts[pos].limits - 1
        for ii = 1, #itemParams[pos].equipNum do
          itemParams[pos].equipNum[ii] = itemParams[pos].equipNum[ii] - 1
        end
        if pos < #itemParams then
          for ii = 1, #itemParams[pos + 1].equipNum do
            itemParams[pos + 1].equipNum[ii] = itemParams[pos + 1].equipNum[ii] + 1
          end
        end
        updateCallback(pos, limitLabel)
        layer:getParent():getParent():getParent():addChild(require("ui.hook.drops").create(reward, i18n.global.reward_will_get.string, true), 1000)
         end)
      end)
    btnNo:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      audio.play(audio.button)
      end)
    local diabackEvent = function()
      dialoglayer:removeFromParentAndCleanup(true)
      end
    dialoglayer.onAndroidBack = function()
      diabackEvent()
      end
    addBackEvent(dialoglayer)
    local onEnter = function()
      dialoglayer.notifyParentLock()
      end
    local onExit = function()
      dialoglayer.notifyParentUnlock()
      end
    dialoglayer:registerScriptHandler(function(l_7_0)
      if l_7_0 == "enter" then
        onEnter()
      elseif l_7_0 == "exit" then
        onExit()
      end
      end)
    return dialoglayer
   end
  local showList = nil
  local updateCallbackForsuit = function(l_3_0)
    actsInfo[3].index = l_3_0
    showList(actsInfo)
   end
  local createItem = function(l_4_0, l_4_1)
    local temp_item = img.createUI9Sprite(img.ui.bottom_border_2)
    temp_item:setPreferredSize(CCSizeMake(574, 205))
    local item_w = temp_item:getContentSize().width
    local item_h = temp_item:getContentSize().height
    local cfg = cfgactivity[l_4_0.id]
    local sx, dx = 84, 72
    local equipNum = {}
    local _equipsLabel = {}
    for ii = 3, #cfg.extra do
      local _obj = cfg.extra[ii]
      do
        if _obj.type == ItemType.Equip then
          local _item0 = img.createEquip(_obj.id)
          local _item = CCMenuItemSprite:create(_item0, nil)
          _item:setScale(0.7)
          _item:setPosition(CCPoint(sx + (ii - 3) * dx, 145))
          equipNum[ii - 2] = 0
          if bag.equips.find(_obj.id) then
            equipNum[ii - 2] = bag.equips.find(_obj.id).num
          end
          _equipsLabel[ii - 2] = lbl.createFont2(14, equipNum[ii - 2] .. "/1", ccc3(195, 255, 66))
          _equipsLabel[ii - 2]:setAnchorPoint(ccp(1, 0))
          _equipsLabel[ii - 2]:setPosition(70, 10)
          _item:addChild(_equipsLabel[ii - 2])
          if equipNum[ii - 2] < 1 then
            _equipsLabel[ii - 2]:setColor(ccc3(250, 53, 53))
          end
          itemParams[l_4_1] = {}
          itemParams[l_4_1].equipNum = equipNum
          itemParams[l_4_1]._equipsLabel = _equipsLabel
          local _item_menu = CCMenu:createWithItem(_item)
          _item_menu:setPosition(CCPoint(0, 0))
          temp_item:addChild(_item_menu)
          _item:registerScriptTapHandler(function()
            audio.play(audio.button)
            layer:getParent():getParent():getParent():addChild(tipsequip.createById(_obj.id), 1000)
               end)
        else
           -- DECOMPILER ERROR: Confused while interpreting a jump as a 'while'

        end
        local raw = img.createUISprite(img.ui.activity_dwarf_raw)
        raw:setPosition(CCPoint(sx + (ii - 3) * dx, item_h / 2))
        temp_item:addChild(raw)
      end
    end
    if cfg.instruct == 1 then
      for ii = 1, #cfg.rewards do
        local _obj = cfg.rewards[ii]
        if _obj.type == ItemType.Equip then
          local _item0 = img.createEquip(_obj.id, 1)
          local _item = CCMenuItemSprite:create(_item0, nil)
          _item:setScale(0.7)
          _item:setPosition(CCPoint(sx + (ii - 1) * dx, 60))
          local _item_menu = CCMenu:createWithItem(_item)
          _item_menu:setPosition(CCPoint(0, 0))
          temp_item:addChild(_item_menu)
          _item:registerScriptTapHandler(function()
            audio.play(audio.button)
            layer:getParent():getParent():getParent():addChild(tipsequip.createById(_obj.id), 1000)
               end)
        else
          if _obj.type == ItemType.Item then
            local _item0 = img.createItem(_obj.id, 1)
            local _item = CCMenuItemSprite:create(_item0, nil)
            _item:setScale(0.7)
            _item:setPosition(CCPoint(sx + (ii - 1) * dx, 60))
            local _item_menu = CCMenu:createWithItem(_item)
            _item_menu:setPosition(CCPoint(0, 0))
            temp_item:addChild(_item_menu)
            _item:registerScriptTapHandler(function()
              audio.play(audio.button)
              layer:getParent():getParent():getParent():addChild(tipsitem.createForShow({id = _obj.id}), 1000)
                  end)
          end
        end
      end
    elseif cfg.instruct == 0 then
      if l_4_0.index ~= 0 then
        local _objgift = cfggift[cfg.rewards[l_4_0.index].id].giftGoods
        for ii = 1, #_objgift do
          local _obj = _objgift[ii]
          if _obj.type == ItemType.Equip then
            local _item0 = img.createEquip(_obj.id, 1)
            local _item = CCMenuItemSprite:create(_item0, nil)
            _item:setScale(0.7)
            _item:setPosition(CCPoint(sx + (ii - 1) * dx, 60))
            local icon = img.createUISprite(img.ui.hero_equip_add)
            icon:setPosition(_item0:boundingBox():getMaxX() - 23, _item0:boundingBox():getMinY() + 23)
            _item0:addChild(icon)
            icon:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(0.5, 76.5), CCFadeTo:create(0.5, 255))))
            local _item_menu = CCMenu:createWithItem(_item)
            _item_menu:setPosition(CCPoint(0, 0))
            temp_item:addChild(_item_menu)
            _item:registerScriptTapHandler(function()
              audio.play(audio.button)
              layer:getParent():getParent():getParent():addChild(ui.createSelectBoard(vpObj, updateCallbackForsuit), 1000)
                  end)
          else
            if _obj.type == ItemType.Item then
              local _item0 = img.createItem(_obj.id, 1)
              local _item = CCMenuItemSprite:create(_item0, nil)
              _item:setScale(0.7)
              _item:setPosition(CCPoint(sx + (ii - 1) * dx, 60))
              local icon = img.createUISprite(img.ui.hero_equip_add)
              icon:setPosition(_item0:boundingBox():getMaxX() - 23, _item0:boundingBox():getMinY() + 23)
              _item0:addChild(icon)
              icon:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(0.5, 76.5), CCFadeTo:create(0.5, 255))))
              local _item_menu = CCMenu:createWithItem(_item)
              _item_menu:setPosition(CCPoint(0, 0))
              temp_item:addChild(_item_menu)
              _item:registerScriptTapHandler(function()
                audio.play(audio.button)
                layer:getParent():getParent():getParent():addChild(ui.createSelectBoard(vpObj, updateCallbackForsuit), 1000)
                     end)
            end
          end
        end
      else
        for ii = 1, 4 do
          local _item0 = img.createUISprite(img.ui.grid)
          local _item = CCMenuItemSprite:create(_item0, nil)
          _item:setScale(0.7)
          _item:setPosition(CCPoint(sx + (ii - 1) * dx, 60))
          local icon = img.createUISprite(img.ui.hero_equip_add)
          icon:setPosition(_item0:getContentSize().width / 2, _item0:getContentSize().height / 2)
          _item0:addChild(icon)
          icon:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(0.5, 76.5), CCFadeTo:create(0.5, 255))))
          local _item_menu = CCMenu:createWithItem(_item)
          _item_menu:setPosition(CCPoint(0, 0))
          temp_item:addChild(_item_menu)
          _item:registerScriptTapHandler(function()
            audio.play(audio.button)
            layer:getParent():getParent():getParent():addChild(ui.createSelectBoard(vpObj, updateCallbackForsuit), 1000)
               end)
        end
      end
    end
    local coincostbg = img.createUI9Sprite(img.ui.hero_evolve_cost_bg)
    coincostbg:setPreferredSize(CCSize(138, 32))
    coincostbg:setPosition(442, 155)
    temp_item:addChild(coincostbg)
    local coinIcon = img.createItemIcon2(ITEM_ID_COIN)
    coinIcon:setScale(0.8)
    coinIcon:setPosition(7, coincostbg:getContentSize().height / 2)
    coincostbg:addChild(coinIcon)
    coinNum[l_4_1] = cfg.extra[1].num
    showCoin[l_4_1] = lbl.createFont2(16, num2KM(cfg.extra[1].num), ccc3(255, 247, 229))
    showCoin[l_4_1]:setPosition(coincostbg:getContentSize().width / 2 + 5, coincostbg:getContentSize().height / 2)
    coincostbg:addChild(showCoin[l_4_1])
    local gemcostbg = img.createUI9Sprite(img.ui.hero_evolve_cost_bg)
    gemcostbg:setPreferredSize(CCSize(138, 32))
    gemcostbg:setPosition(442, 115)
    temp_item:addChild(gemcostbg)
    local gemIcon = img.createItemIcon2(ITEM_ID_GEM)
    gemIcon:setScale(0.8)
    gemIcon:setPosition(7, gemcostbg:getContentSize().height / 2)
    gemcostbg:addChild(gemIcon)
    gemNum[l_4_1] = cfg.extra[2].num
    showGem[l_4_1] = lbl.createFont2(16, num2KM(cfg.extra[2].num), ccc3(255, 247, 229))
    showGem[l_4_1]:setPosition(gemcostbg:getContentSize().width / 2 + 5, gemcostbg:getContentSize().height / 2)
    gemcostbg:addChild(showGem[l_4_1])
    local limitLabel = lbl.createFont1(14, i18n.global.limitact_limit.string .. acts[l_4_1].limits, ccc3(115, 59, 5))
    limitLabel:setPosition(CCPoint(442, 82))
    temp_item:addChild(limitLabel)
    local makeSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    makeSprite:setPreferredSize(CCSize(145, 45))
    local btnMake = SpineMenuItem:create(json.ui.button, makeSprite)
    btnMake:setPosition(442, 50)
    local labMake = lbl.createFont1(18, i18n.global.activity_dwarf_btn.string, ccc3(115, 59, 5))
    labMake:setPosition(btnMake:getContentSize().width / 2, btnMake:getContentSize().height / 2)
    makeSprite:addChild(labMake)
    local menuMake = CCMenu:create()
    menuMake:setPosition(0, 0)
    menuMake:addChild(btnMake)
    temp_item:addChild(menuMake)
    itemParams[l_4_1].btnMake = btnMake
    if acts[l_4_1].limits < 1 then
      setShader(btnMake, SHADER_GRAY, true)
      btnMake:setEnabled(false)
    end
    for ii = 1, #equipNum do
      if equipNum[ii] < 1 then
        setShader(btnMake, SHADER_GRAY, true)
        btnMake:setEnabled(false)
    else
      end
    end
    if l_4_0.index and l_4_0.index == 0 then
      setShader(btnMake, SHADER_GRAY, true)
      btnMake:setEnabled(false)
    end
    btnMake:registerScriptTapHandler(function()
      audio.play(audio.button)
      local surebuy = createSurebuy(vpObj, cfg, i, limitLabel, itemParams)
      layer:getParent():getParent():getParent():addChild(surebuy, 300)
      end)
    return temp_item
   end
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = 574, height = 245}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(2, 6))
  board:addChild(scroll)
  layer.scroll = scroll
  local tmp_item = {}
  showList = function(l_5_0)
    if #tmp_item > 0 then
      for ii = 1, #tmp_item do
        tmp_item[ii]:removeFromParentAndCleanup(true)
      end
      scroll:removeFromParentAndCleanup(true)
      upvalue_512 = nil
      upvalue_512 = lineScroll.create(scroll_params)
      scroll:setAnchorPoint(CCPoint(0, 0))
      scroll:setPosition(CCPoint(2, 6))
      board:addChild(scroll)
      layer:removeChildByTag(101)
      require("ui.activity.ban").addBan(layer, scroll)
    end
    for ii = 1, #l_5_0 do
      if ii == 1 then
        scroll.addSpace(3)
      end
      tmp_item[ii] = createItem(l_5_0[ii], ii)
      tmp_item[ii].obj = l_5_0[ii]
      tmp_item[ii].ax = 0.5
      tmp_item[ii].px = scroll_params.width / 2
      scroll.addItem(tmp_item[ii])
      if ii ~= item_count then
        scroll.addSpace(0)
      end
    end
   end
  showList(actsInfo)
  scroll.setOffsetBegin()
  local act_st = activityData.getStatusById(IDS.DWARF_1.ID)
  local last_update = os.time() - 1
  local onUpdate = function(l_6_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    local remain_cd = act_st.cd - (os.time() - activityData.pull_time)
    if remain_cd >= 0 then
      local time_str = time2string(remain_cd)
      lbl_cd:setString(time_str)
    else
      if #coinNum >= 3 then
        for ii = 1, #coinNum do
          if bag.coin() < coinNum[ii] then
            showCoin[ii]:setColor(ccc3(250, 53, 53))
          else
            showCoin[ii]:setColor(ccc3(255, 247, 229))
          end
        end
        if #gemNum >= 3 then
          for ii = 1, #gemNum do
            if bag.gem() < gemNum[ii] then
              showGem[ii]:setColor(ccc3(250, 53, 53))
            else
              showGem[ii]:setColor(ccc3(255, 247, 229))
            end
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  require("ui.activity.ban").addBan(layer, layer.scroll)
  layer:registerScriptHandler(function(l_7_0)
    if l_7_0 == "enter" then
      do return end
    end
    if l_7_0 == "exit" then
      do return end
    end
    if l_7_0 == "cleanup" then
      img.unload(img.packedOthers.ui_activity_dwarf)
    end
   end)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui


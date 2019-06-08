-- Command line was: E:\github\dhgametool\scripts\ui\hero\equip.lua 

local equip = {}
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
local player = (require("data.player"))
local heroData, superlayer = nil, nil
local createBoardForRewards = function(l_1_0, l_1_1)
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
  local hero = img.createEquip(l_1_0)
  heroBtn = SpineMenuItem:create(json.ui.button, hero)
  heroBtn:setScale(0.85)
  heroBtn:setPosition(dialog.board:getContentSize().width / 2, 185)
  local iconMenu = CCMenu:createWithItem(heroBtn)
  iconMenu:setPosition(0, 0)
  dialog.board:addChild(iconMenu)
  heroBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local tips = require("ui.tips.equip").createById(eid)
    dialog:addChild(tips, 1001)
   end)
  backBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if callback then
      callback()
    end
    dialog:removeFromParentAndCleanup()
   end)
  dialog.setClickBlankHandler(function()
   end)
  return dialog
end

local checkEquip = function(l_2_0)
  local equips = {}
  for i,v in ipairs(bag.equips) do
    local isEquip = true
    if cfgequip[v.id].pos ~= l_2_0 then
      isEquip = false
    end
    if heroData.lv < cfgequip[v.id].lv then
      isEquip = false
    end
    if isEquip then
      return true
    end
  end
  return false
end

local createEquipLayer = function(l_3_0, l_3_1)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local equips = {}
  for i,v in ipairs(bag.equips) do
    local isEquip = true
    if cfgequip[v.id].pos ~= l_3_0 then
      isEquip = false
    end
    if heroData.lv < cfgequip[v.id].lv then
      isEquip = false
    end
    if isEquip then
      equips[ equips + 1] = v
    end
  end
  if  equips == 0 and l_3_0 == EQUIP_POS_TREASURE then
    showToast(i18n.global.empty_treasure_hint.string)
    return cc.Layer:create()
  end
  table.sort(equips, compareEquip)
  local board = img.createLogin9Sprite(img.login.dialog)
  board:setPreferredSize(CCSize(644, 484))
  board:setScale(view.minScale)
  board:setPosition(view.midX, view.midY)
  layer:addChild(board)
  local innerBg = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  innerBg:setPreferredSize(CCSize(591, 374))
  innerBg:setAnchorPoint(ccp(0, 0))
  innerBg:setPosition(27, 37)
  board:addChild(innerBg)
  if  equips == 0 then
    if l_3_0 == EQUIP_POS_TREASURE then
      local empty = require("ui.empty").create({text = i18n.global.empty_treasure.string})
      empty:setPosition(innerBg:getContentSize().width / 2, innerBg:getContentSize().height / 2)
      innerBg:addChild(empty)
    else
      local empty = require("ui.empty").create({text = i18n.global.empty_wear.string})
      empty:setPosition(innerBg:getContentSize().width / 2, innerBg:getContentSize().height / 2)
      innerBg:addChild(empty)
    end
  end
  local btnCloseSprite = img.createUISprite(img.ui.close)
  local btnClose = SpineMenuItem:create(json.ui.button, btnCloseSprite)
  btnClose:setPosition(621, 458)
  local menuClose = CCMenu:createWithItem(btnClose)
  menuClose:setPosition(0, 0)
  board:addChild(menuClose)
  btnClose:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end)
  local Height = 92 * ( equips / 6 + 1)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(12, 14)
  scroll:setViewSize(CCSize(573, 348))
  scroll:setContentSize(CCSize(573, Height))
  scroll:setContentOffset(ccp(0, 348 - Height))
  innerBg:addChild(scroll)
  local showEquips = {}
  for i,v in ipairs(equips) do
    local x, y = (i - math.ceil(i / 6) * 6 + 6) * 92 - 81, math.ceil(i / 6) * 92
    showEquips[i] = img.createEquip(v.id, v.num)
    showEquips[i]:setAnchorPoint(ccp(0, 0))
    showEquips[i]:setPosition(x, Height - y - 4)
    scroll:getContainer():addChild(showEquips[i])
  end
  local lasty = nil
  local onTouchBegin = function(l_2_0, l_2_1)
    lasty = l_2_1
    return true
   end
  local onTouchMoved = function(l_3_0, l_3_1)
    return true
   end
  local onTouchEnd = function(l_4_0, l_4_1)
    local point = scroll:getContainer():convertToNodeSpace(ccp(l_4_0, l_4_1))
    local pointOnBoard = board:convertToNodeSpace(ccp(l_4_0, l_4_1))
    if math.abs(l_4_1 - lasty) > 10 or not innerBg:boundingBox():containsPoint(pointOnBoard) then
      return true
    end
    for i,v in ipairs(showEquips) do
      if v:boundingBox():containsPoint(point) then
        local data = {id = equips[i].id, hero = heroData}
        do
          local tipsEquip = require("ui.tips.equip").createForHero(data, function()
            onWear(data.id, cfgequip[data.id].pos)
            superlayer:removeChildByTag(101)
            if layer and not tolua.isnull(layer) then
              layer:removeFromParentAndCleanup(true)
            end
               end)
          superlayer:addChild(tipsEquip, 10000, 101)
        end
      end
    end
    return true
   end
  local onTouch = function(l_5_0, l_5_1, l_5_2)
    if l_5_0 == "began" then
      return onTouchBegin(l_5_1, l_5_2)
    elseif l_5_0 == "moved" then
      return onTouchMoved(l_5_1, l_5_2)
    else
      return onTouchEnd(l_5_1, l_5_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  board:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  anim_arr:addObject(CCDelayTime:create(0.15))
  anim_arr:addObject(CCCallFunc:create(function()
   end))
  board:runAction(CCSequence:create(anim_arr))
  return layer
end

equip.create = function(l_4_0, l_4_1)
  local layer = CCLayer:create()
  superlayer = l_4_1
  upvalue_512 = l_4_0
  local board = img.createUI9Sprite(img.ui.hero_bg)
  board:setPreferredSize(CCSize(428, 503))
  board:setAnchorPoint(ccp(0, 0))
  board:setPosition(465, 15)
  layer:addChild(board)
  local bigIcon = img.createUISprite(img.ui.hero_equip_bg)
  bigIcon:setPosition(214, 261)
  board:addChild(bigIcon)
  local equips = {}
  for i,v in ipairs(heroData.equips) do
    equips[cfgequip[v].pos] = v
  end
  local title = lbl.createFont1(24, i18n.global.hero_title_equip.string, ccc3(230, 208, 174))
  title:setPosition(214, 474)
  board:addChild(title, 1)
  local titleShade = lbl.createFont1(24, i18n.global.hero_title_equip.string, ccc3(89, 48, 27))
  titleShade:setPosition(214, 472)
  board:addChild(titleShade)
  local EQUIPPOS = {1 = {37, 281}, 2 = {171, 351}, 3 = {171, 90}, 4 = {305, 281}, 5 = {37, 160}, 6 = {305, 160}}
  local btnEquipBg = {}
  local showEquips = {}
  local updateEquip = function()
    for i = 1, 6 do
      if showEquips[i] then
        showEquips[i]:removeFromParentAndCleanup(true)
        showEquips[i] = nil
      end
      if equips[i] then
        showEquips[i] = img.createEquip(equips[i])
        showEquips[i]:setPosition(btnEquipBg[i]:getContentSize().width / 2, btnEquipBg[i]:getContentSize().height / 2)
        btnEquipBg[i]:addChild(showEquips[i])
        if cfgequip[equips[i]].pos == EQUIP_POS_TREASURE and not cfgequip[equips[i]].treasureNext then
          local animName = {"blue", "golden", "purple", "green", "red", "orange"}
          local anim = json.create(json.ui.zhuangbei_shengji)
          anim:playAnimation(animName[cfgequip[equips[i]].qlt], -1, 0)
          showEquips[i]:addChild(anim)
          anim:setPosition(showEquips[i]:getContentSize().width * 0.5, showEquips[i]:getContentSize().height * 0.5)
        end
        for j,v in ipairs(bag.equips) do
          do
            if cfgequip[v.id].pos == i then
              if cfgequip[equips[i]].qlt < cfgequip[v.id].qlt then
                local showRed = img.createUISprite(img.ui.main_red_dot)
                showRed:setPosition(showEquips[i]:getContentSize().width - 10, showEquips[i]:getContentSize().height - 10)
                showEquips[i]:addChild(showRed)
                do return end
              end
              for j,v in (for generator) do
              end
              if cfgequip[v.id].qlt == cfgequip[equips[i]].qlt and equips[i] < v.id then
                local showRed = img.createUISprite(img.ui.main_red_dot)
                showRed:setPosition(showEquips[i]:getContentSize().width - 10, showEquips[i]:getContentSize().height - 10)
                showEquips[i]:addChild(showRed)
            end
          end
        end
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local onUpNum = function(l_2_0, l_2_1)
    local NAME = {"atk", "hp", "arm", "spd", "sklP", "hit", "miss", "crit", "critTime", "brk", "free", "decDmg", "trueAtk"}
    local showStat = {}
    for i,v in ipairs(NAME) do
      local preVal = l_2_0[NAME[i]]
      local aftVal = l_2_1[NAME[i]]
      if preVal ~= aftVal then
        local name, val = buffString(NAME[i], l_2_1[NAME[i]] - l_2_0[NAME[i]], true)
        if preVal < aftVal then
          showStat[ showStat + 1] = {text = name .. "    +" .. val}
          for i,v in (for generator) do
          end
          showStat[ showStat + 1] = {text = name .. "    " .. val, isRed = true}
        end
      end
      do
        local showLayer = CCLayer:create()
        if layer and not tolua.isnull(layer) then
          layer:addChild(showLayer)
        end
        for i,v in ipairs(showStat) do
          json.load(json.ui.hero_numbers)
          local anim = DHSkeletonAnimation:createWithKey(json.ui.hero_numbers)
          anim:scheduleUpdateLua()
          anim:setPosition(230, 230 + i * 24)
          showLayer:addChild(anim)
          local showNum = lbl.createFont2(16, v.text, ccc3(163, 255, 55))
          if v.isRed then
            anim:playAnimation("down")
            showNum:setColor(ccc3(255, 138, 106))
          else
            anim:playAnimation("up")
          end
          anim:addChildFollowSlot("code_numbers", showNum)
        end
        showLayer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(2), CCRemoveSelf:create()))
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local onWear = function(l_3_0, l_3_1, l_3_2, l_3_3)
    if l_3_2 then
      audio.play(audio.hero_equip_off)
    else
      audio.play(audio.hero_equip_on)
    end
    local params = {sid = player.sid, hid = heroData.hid, equips = {}}
    if not l_3_2 then
      params.equips[ params.equips + 1] = l_3_0
    end
    for i = 1, 6 do
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if equips[i] and i ~= EQUIP_POS_JADE and not l_3_2 and cfgequip[l_3_0].pos ~= cfgequip[equips[i]].pos then
        params.equips[ params.equips + 1] = equips[i]
        do return end
        if equips[i] ~= l_3_0 then
          params.equips[ params.equips + 1] = equips[i]
        end
      end
    end
    tbl2string(params)
    addWaitNet()
    net:wear(params, function(l_1_0)
      delWaitNet()
      if l_1_0.status < 0 then
        showToast("server status:" .. l_1_0.status)
        return 
      end
      require("data.tutorial").goNext("hero", 3, true)
      local attr = heroData.attr()
      heroData.equips = params.equips
      heroData.equips[ heroData.equips + 1] = equips[5]
      if equips[7] then
        heroData.equips[ heroData.equips + 1] = equips[7]
      end
      if unWear then
        bag.equips.returnbag({id = id, num = 1})
      else
        bag.equips.sub({id = id, num = 1})
        local pos = cfgequip[id].pos
        if equips[pos] then
          bag.equips.returnbag({id = equips[pos], num = 1})
        end
      end
      upvalue_1024 = {}
      for i,v in ipairs(heroData.equips) do
        equips[cfgequip[v].pos] = v
      end
      local nattr = heroData.attr()
      onUpNum(attr, nattr)
      updateEquip()
      if callBack then
        callBack()
      end
      end)
   end
  do
    local animCrystal = nil
    for i = 1, 6 do
      local btnEquipBgSprite = nil
      btnEquipBgSprite = img.createUISprite(img.ui.grid)
      btnEquipBg[i] = CCMenuItemSprite:create(btnEquipBgSprite, nil)
      MenuEquipBg = CCMenu:createWithItem(btnEquipBg[i])
      MenuEquipBg:setPosition(0, 0)
      board:addChild(MenuEquipBg, 1)
      btnEquipBg[i]:setAnchorPoint(ccp(0, 0))
      btnEquipBg[i]:setPosition(EQUIPPOS[i][1], EQUIPPOS[i][2])
      btnEquipBg[i]:registerScriptTapHandler(function()
        audio.play(audio.button)
        if i <= 4 then
          if not equips[i] then
            superlayer:addChild(createEquipLayer(i, onWear), 1000)
          else
            local tipsEquip = nil
            do
              local Wear = function()
                superlayer:addChild(createEquipLayer(i, onWear), 10000)
                tipsEquip:removeFromParentAndCleanup(true)
                     end
              local UnWear = function()
                onWear(equips[i], i, true)
                tipsEquip:removeFromParentAndCleanup(true)
                local showAdd = img.createUISprite(img.ui.hero_equip_add)
                showAdd:setPosition(btnEquipBg[i]:getContentSize().width - 25, 25)
                btnEquipBg[i]:addChild(showAdd)
                showAdd:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeOut:create(1), CCFadeIn:create(1))))
                     end
              local data = {id = equips[i], hero = heroData, owner = heroData}
              tipsEquip = require("ui.tips.equip").createForHero(data, UnWear, Wear)
              superlayer:addChild(tipsEquip, 10000)
            end
          end
        elseif i == 5 and UNLOCK_HERO_CRYSTAL <= heroData.lv then
          if not equips[i] then
            local params = {sid = player.sid, hid = heroData.hid}
            addWaitNet()
            net:jade_on(params, function(l_3_0)
              delWaitNet()
              tbl2string(l_3_0)
              if l_3_0.status < 0 then
                showToast("status:" .. l_3_0.status)
                return 
              end
              heroData.equips[ heroData.equips + 1] = l_3_0.jade
              equips[5] = l_3_0.jade
              if animCrystal then
                animCrystal:playAnimation("animation2")
                layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.8), CCCallFunc:create(function()
                  local callback = function()
                    if not tolua.isnull(animCrystal) then
                      local jadeIcon = img.createEquip(__data.jade)
                      animCrystal:addChildFollowSlot("code_gem", jadeIcon)
                      animCrystal:playAnimation("animation3")
                    end
                           end
                  superlayer:addChild(createBoardForRewards(__data.jade, callback), 1000)
                        end)))
              end
                  end)
          else
            local tipsEquip = nil
            local callback = function(l_4_0)
              local anim = json.create(json.ui.baoshi_hecheng)
              anim:playAnimation("animation")
              anim:setScale(view.minScale)
              anim:setPosition(view.midX, view.midY)
              superlayer:addChild(anim, 10001)
              layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(function()
                anim:removeFromParentAndCleanup(true)
                equips[5] = id
                updateEquip()
                superlayer:addChild(createBoardForRewards(id), 10000)
                     end)))
                  end
            local onChange = function()
              tipsEquip:removeFromParentAndCleanup(true)
              superlayer:addChild(require("ui.hero.crystal").change(heroData, callback), 10000)
                  end
            local onUp = function()
              tipsEquip:removeFromParentAndCleanup(true)
              superlayer:addChild(require("ui.hero.crystal").levelUp(heroData, callback), 10000)
                  end
            local data = {id = equips[i], hero = heroData, owner = heroData}
            tipsEquip = require("ui.tips.equip").createForHero(data, onChange, onUp)
            superlayer:addChild(tipsEquip, 10000)
          end
        elseif i == 6 then
          if not equips[i] then
            superlayer:addChild(createEquipLayer(i, onWear), 1000)
          else
            local tipsEquip = nil
            local Wear = function()
              superlayer:addChild(createEquipLayer(i, onWear), 10000)
              tipsEquip:removeFromParentAndCleanup(true)
                  end
            local UnWear = function()
              onWear(equips[i], i, true)
              tipsEquip:removeFromParentAndCleanup(true)
              if not btnEquipBg[i].showAdd then
                local showAdd = img.createUISprite(img.ui.hero_equip_add)
                showAdd:setPosition(btnEquipBg[i]:getContentSize().width - 25, 25)
                btnEquipBg[i]:addChild(showAdd)
                btnEquipBg[i].showAdd = showAdd
                showAdd:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeOut:create(1), CCFadeIn:create(1))))
              end
                  end
            local LevelUp = function(l_9_0, l_9_1, l_9_2, l_9_3)
              onWear(l_9_0, l_9_1, l_9_2, l_9_3)
              tipsEquip.refresh({id = l_9_0, owner = heroData, hero = heroData})
                  end
            local data = {id = equips[i], hero = heroData, owner = heroData}
            tipsEquip = require("ui.tips.equip").createForHero(data, UnWear, Wear, LevelUp)
            superlayer:addChild(tipsEquip, 10000)
          end
        end
      end
    end
         end)
      if i <= 4 then
        local icon = img.createUISprite(img.ui.hero_equip_icon" .. )
        icon:setPosition(btnEquipBg[i]:getContentSize().width / 2, btnEquipBg[i]:getContentSize().height / 2)
        btnEquipBg[i]:addChild(icon)
        if checkEquip(i) then
          local showAdd = img.createUISprite(img.ui.hero_equip_add)
          showAdd:setPosition(btnEquipBg[i]:getContentSize().width - 25, 25)
          btnEquipBg[i]:addChild(showAdd)
          showAdd:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeOut:create(1), CCFadeIn:create(1))))
        elseif i == EQUIP_POS_JADE and not equips[EQUIP_POS_JADE] then
          local showLock = lbl.createFont2(14, "lv " .. UNLOCK_HERO_CRYSTAL)
          showLock:setPosition(40, 14)
          btnEquipBg[i]:addChild(showLock)
          if UNLOCK_HERO_CRYSTAL <= heroData.lv then
            animCrystal = json.create(json.ui.yingxiongmianban)
            animCrystal:setPosition(btnEquipBg[i]:getContentSize().width / 2, btnEquipBg[i]:getContentSize().height / 2)
            animCrystal:playAnimation("animation", -1)
            btnEquipBg[i]:addChild(animCrystal)
          do
            else
              local icon = img.createUISprite(img.ui.hook_icon_lock)
              icon:setPosition(btnEquipBg[i]:getContentSize().width / 2, btnEquipBg[i]:getContentSize().height / 2)
              btnEquipBg[i]:addChild(icon)
            end
            do return end
            if heroData.lv < UNLOCK_HERO_TREASURE then
              local showLock = lbl.createFont2(14, "lv " .. UNLOCK_HERO_TREASURE)
              showLock:setPosition(40, 14)
              btnEquipBg[i]:addChild(showLock)
              local icon = img.createUISprite(img.ui.hook_icon_lock)
              icon:setPosition(btnEquipBg[i]:getContentSize().width / 2, btnEquipBg[i]:getContentSize().height / 2)
              btnEquipBg[i]:addChild(icon)
            else
              local showBg = img.createUISprite(img.ui.treasure_eq_bg)
              showBg:setPosition(btnEquipBg[1]:getContentSize().width * 0.5, btnEquipBg[1]:getContentSize().height * 0.5)
              btnEquipBg[i]:addChild(showBg)
              if checkEquip(i) then
                local showAdd = img.createUISprite(img.ui.hero_equip_add)
                showAdd:setPosition(btnEquipBg[i]:getContentSize().width - 25, 25)
                btnEquipBg[i]:addChild(showAdd)
                btnEquipBg[i].showAdd = showAdd
                showAdd:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeOut:create(1), CCFadeIn:create(1))))
              end
            end
          end
        end
      end
    end
    updateEquip()
    local btnQuickSp = img.createLogin9Sprite(img.login.button_9_small_green)
    btnQuickSp:setPreferredSize(CCSize(150, 50))
    local labQuick = lbl.createFont1(16, i18n.global.hero_quick_wear.string, ccc3(29, 84, 9))
    labQuick:setPosition(btnQuickSp:getContentSize().width / 2, btnQuickSp:getContentSize().height / 2)
    btnQuickSp:addChild(labQuick)
    local btnQuick = SpineMenuItem:create(json.ui.button, btnQuickSp)
    local menuQuick = CCMenu:createWithItem(btnQuick)
    menuQuick:setPosition(0, 0)
    board:addChild(menuQuick)
    btnQuick:setPosition(294, 54)
    btnQuick:registerScriptTapHandler(function()
      local params = {sid = player.sid, hid = heroData.hid, equips = {}}
      do
        local preEquip = {0, 0, 0, 0, 0, 0}
        for i = 1, 6 do
          if equips[i] and i ~= EQUIP_POS_JADE then
            preEquip[i] = equips[i]
          end
        end
        for i,v in ipairs(bag.equips) do
           -- DECOMPILER ERROR: unhandled construct in 'if'

          if preEquip[cfgequip[v.id].pos] == 0 and preEquip[cfgequip[v.id].pos] < v.id then
            preEquip[cfgequip[v.id].pos] = v.id
            for i,v in (for generator) do
              if cfgequip[v.id].pos ~= EQUIP_POS_SKIN then
                if cfgequip[preEquip[cfgequip[v.id].pos]].qlt < cfgequip[v.id].qlt then
                  preEquip[cfgequip[v.id].pos] = v.id
                  for i,v in (for generator) do
                  end
                  if cfgequip[v.id].qlt == cfgequip[preEquip[cfgequip[v.id].pos]].qlt and preEquip[cfgequip[v.id].pos] < v.id then
                    preEquip[cfgequip[v.id].pos] = v.id
                  end
                end
              end
            end
            for i = 1, 6 do
              if preEquip[i] > 0 then
                params.equips[ params.equips + 1] = preEquip[i]
              end
            end
            tbl2string(params)
            addWaitNet()
            net:wear(params, function(l_1_0)
            delWaitNet()
            if l_1_0.status < 0 then
              showToast("server status:" .. l_1_0.status)
              return 
            end
            for i,v in ipairs(heroData.equips) do
              if cfgequip[v].pos ~= EQUIP_POS_SKIN then
                bag.equips.returnbag({id = v, num = 1})
              end
            end
            for i,v in ipairs(params.equips) do
              bag.equips.sub({id = v, num = 1})
            end
            local attr = heroData.attr()
            heroData.equips = params.equips
            heroData.equips[ heroData.equips + 1] = equips[5]
            if equips[7] then
              heroData.equips[ heroData.equips + 1] = equips[7]
            end
            upvalue_2048 = {}
            for i,v in ipairs(heroData.equips) do
              equips[cfgequip[v].pos] = v
            end
            local nattr = heroData.attr()
            onUpNum(attr, nattr)
            updateEquip()
               end)
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
      end)
    local btnQuickSp = img.createLogin9Sprite(img.login.button_9_small_orange)
    btnQuickSp:setPreferredSize(CCSize(150, 50))
    local labQuick = lbl.createFont1(16, i18n.global.hero_quick_unwear.string, ccc3(118, 37, 5))
    labQuick:setPosition(btnQuickSp:getContentSize().width / 2, btnQuickSp:getContentSize().height / 2)
    btnQuickSp:addChild(labQuick)
    local btnQuick = SpineMenuItem:create(json.ui.button, btnQuickSp)
    local menuQuick = CCMenu:createWithItem(btnQuick)
    menuQuick:setPosition(0, 0)
    board:addChild(menuQuick)
    btnQuick:setPosition(134, 54)
    btnQuick:registerScriptTapHandler(function()
      audio.play(audio.hero_equip_off)
      local params = {sid = player.sid, hid = heroData.hid, equips = {}}
      tbl2string(params)
      addWaitNet()
      net:wear(params, function(l_1_0)
        delWaitNet()
        if l_1_0.status < 0 then
          showToast("server status:" .. l_1_0.status)
          return 
        end
        for _,id in ipairs(heroData.equips) do
          local cfg = cfgequip[id]
          if cfg.pos ~= EQUIP_POS_JADE and cfg.pos ~= EQUIP_POS_SKIN then
            bag.equips.returnbag({id = id, num = 1})
          end
        end
        local attr = heroData.attr()
        heroData.equips = params.equips
        heroData.equips[ heroData.equips + 1] = equips[5]
        if equips[7] then
          heroData.equips[ heroData.equips + 1] = equips[7]
        end
        upvalue_2048 = {}
        for i,v in ipairs(heroData.equips) do
          equips[cfgequip[v].pos] = v
        end
        local nattr = heroData.attr()
        onUpNum(attr, nattr)
        updateEquip()
         end)
      end)
    return layer
  end
end

return equip


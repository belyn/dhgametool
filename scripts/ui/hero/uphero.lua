-- Command line was: E:\github\dhgametool\scripts\ui\hero\uphero.lua 

local uphero = {}
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
local cfgexphero = require("config.exphero")
local heros = require("data.heros")
local bag = require("data.bag")
local player = require("data.player")
local cfgactivity = require("config.activity")
local cfgtalen = require("config.talen")
local operData = {}
local MAXWAKE = 7
local initHeros = function(l_1_0)
  do
    local tmpheros = {}
    for i,v in ipairs(heros) do
      if not v.flag then
        tmpheros[ tmpheros + 1] = {hid = v.hid, id = v.id, lv = v.lv, wake = v.wake, isUsed = false, flag = v.hid == l_1_0 or 0}
      end
      operData.heros = tmpheros
    end
     -- Warning: missing end command somewhere! Added here
  end
end

local getCondition = function(l_2_0, l_2_1)
  local condition = {}
  local disillusMaterial = nil
  if l_2_1 >= 5 then
    disillusMaterial = cfgtalen[l_2_1 - 4].heroMaterial[1]
  elseif l_2_1 >= 4 then
    local nextId = cfghero[l_2_0].nId
    disillusMaterial = cfghero[nextId].disillusMaterial[1]
  else
    disillusMaterial = cfghero[l_2_0].disillusMaterial[l_2_1]
  end
  for i,v in ipairs(disillusMaterial.disi) do
    local isFind = false
    if v == 5799 then
      v = cfghero[l_2_0].fiveStarId
    end
    for j,k in ipairs(condition) do
      if k.id == v then
        k.num = k.num + 1
        isFind = true
    else
      end
    end
    if not isFind then
      condition[ condition + 1] = {id = v, num = 1, select = {}}
    end
  end
  operData.condition = condition
end

local createSelectBoard = function(l_3_0, l_3_1)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 210))
  local headData = {}
  for i,v in ipairs(operData.heros) do
    if v.id == l_3_0.id and v.isUsed == false then
      headData[ headData + 1] = v
      for i,v in (for generator) do
      end
      if v.isUsed == false and l_3_0.id % 100 == 99 then
        if cfghero[v.id].group == (l_3_0.id - 4099) / 100 and cfghero[v.id].qlt == 4 and v.id < 5000 then
          headData[ headData + 1] = v
          for i,v in (for generator) do
          end
          if cfghero[v.id].group == (l_3_0.id - 5099) / 100 and cfghero[v.id].qlt == 5 and v.id >= 5000 then
            headData[ headData + 1] = v
            for i,v in (for generator) do
            end
            if cfghero[v.id].group == (l_3_0.id - 6099) / 100 and cfghero[v.id].qlt == 6 and v.id >= 60000 and v.wake == nil then
              headData[ headData + 1] = v
              for i,v in (for generator) do
              end
              if l_3_0.id == 9999 and v.wake == 3 then
                headData[ headData + 1] = v
                for i,v in (for generator) do
                end
                if l_3_0.id == 10999 and v.wake == 4 then
                  headData[ headData + 1] = v
                  for i,v in (for generator) do
                  end
                  for j,k in ipairs(l_3_0.select) do
                    if k == v.hid then
                      headData[ headData + 1] = v
                      for i,v in (for generator) do
                      end
                    end
                  end
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
                local curSelect = {}
                local backEvent = function()
                  for i,v in ipairs(headData) do
                    for j = 1,  tmpSelect do
                      if v.hid == tmpSelect[j] then
                        local curflag = false
                        for z = i,  curSelect do
                          if v.hid == curSelect[z] then
                            curflag = true
                        else
                          end
                        end
                        if curflag == false then
                          v.isUsed = false
                          for i,v in (for generator) do
                          end
                        end
                      end
                       -- DECOMPILER ERROR: Confused about usage of registers for local variables.

                    end
                    layer:removeFromParentAndCleanup(true)
                     -- Warning: missing end command somewhere! Added here
                  end
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
                local height = 84 * math.ceil( headData / 5)
                local scroll = CCScrollView:create()
                scroll:setDirection(kCCScrollViewDirectionVertical)
                scroll:setAnchorPoint(ccp(0, 0))
                scroll:setPosition(53, 113)
                scroll:setViewSize(CCSize(420, 225))
                scroll:setContentSize(CCSize(420, height))
                board:addChild(scroll)
                if  headData == 0 then
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
                  tmpSelect[ tmpSelect + 1] = headData[l_4_0].hid
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
                      tmpSelect[i], tmpSelect[ tmpSelect] = tmpSelect[ tmpSelect], tmpSelect[i]
                      tmpSelect[ tmpSelect] = nil
                  else
                    end
                  end
                  headData[l_5_0].isUsed = false
                  if showHeads[l_5_0]:getChildByTag(1) then
                    showHeads[l_5_0]:removeChildByTag(1)
                  end
                        end
                for i,v in ipairs(headData) do
                  for j,k in ipairs(l_3_0.select) do
                    if k == v.hid then
                      onSelect(i)
                      curSelect[ curSelect + 1] = v.hid
                    end
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
                        if not headData[i].isUsed and  tmpSelect < condition.num then
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
                  condition.select = tmpSelect
                  layer:removeFromParentAndCleanup(true)
                  callfunc()
                        end)
                board:setScale(0.5 * view.minScale)
                do
                  local anim_arr = CCArray:create()
                  anim_arr:addObject(CCScaleTo:create(0.15, view.minScale, view.minScale))
                  anim_arr:addObject(CCDelayTime:create(0.15))
                  anim_arr:addObject(CCCallFunc:create(function()
                        end))
                  board:runAction(CCSequence:create(anim_arr))
                  return layer
                end
                 -- Warning: missing end command somewhere! Added here
              end
               -- Warning: missing end command somewhere! Added here
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

uphero.create = function(l_4_0, l_4_1, l_4_2)
  local layer = CCLayer:create()
  local w_board = 428
  local h_board = 503
  local board = img.createUI9Sprite(img.ui.hero_bg)
  board:setPreferredSize(CCSize(428, 503))
  board:setAnchorPoint(ccp(0, 0))
  board:setPosition(465, 15)
  layer:addChild(board)
  local titleStr = i18n.global.hero_wake_title.string
  if l_4_0.wake and l_4_0.wake >= 4 then
    titleStr = i18n.global.hero_talen_title.string
  end
  local titleShade = lbl.createFont1(24, titleStr, ccc3(89, 48, 27))
  titleShade:setPosition(214, 472)
  board:addChild(titleShade)
  local title = lbl.createFont1(24, titleStr, ccc3(230, 208, 174))
  title:setPosition(214, 474)
  board:addChild(title)
  local upboard = img.createUI9Sprite(img.ui.hero_up_bottom)
  upboard:setPreferredSize(CCSize(388, 208))
  upboard:setAnchorPoint(0.5, 0)
  upboard:setPosition(w_board / 2, 236)
  board:addChild(upboard)
  local advancedBtn = nil
  local showAnim = {}
  local aniskill = {}
  local upherolayer, transchangeBtn = nil, nil
  local createupherolayer = function(l_1_0, l_1_1, l_1_2)
    local herolayer = CCLayer:create()
    local line = img.createUI9Sprite(img.ui.hero_up_line_deep)
    line:setPreferredSize(CCSize(315, 4))
    line:setPosition(w_board / 2, 381)
    herolayer:addChild(line)
     -- DECOMPILER ERROR: unhandled construct in 'if'

    if l_1_1 < 5 or l_1_1 == MAXWAKE + 1 then
      json.load(json.ui.lv10plus_hero)
      local energizeStar = DHSkeletonAnimation:createWithKey(json.ui.lv10plus_hero)
      do
        energizeStar:scheduleUpdateLua()
        energizeStar:playAnimation("animation", -1)
        energizeStar:setPosition(w_board / 2, 400)
        herolayer:addChild(energizeStar)
        local energizeStarLab = lbl.createFont2(26, l_1_1 - 4)
        energizeStarLab:setPosition(energizeStar:getContentSize().width / 2, -2)
        energizeStar:addChild(energizeStarLab)
        if l_1_1 == MAXWAKE + 1 then
          energizeStarLab:setString(l_1_1 - 4 - 1)
        end
        line:setPosition(w_board / 2, 360)
        local iconleFlower = img.createUISprite(img.ui.hero_energize_flower)
        iconleFlower:setScale(0.86)
        iconleFlower:setFlipX(true)
        iconleFlower:setPosition(w_board / 2 - 110, 400)
        herolayer:addChild(iconleFlower)
        local iconRFlower = img.createUISprite(img.ui.hero_energize_flower)
        iconRFlower:setScale(0.86)
        iconRFlower:setPosition(w_board / 2 + 110, 400)
        herolayer:addChild(iconRFlower)
        local fgLine = img.createUI9Sprite(img.ui.hero_panel_fgline)
        fgLine:setPreferredSize(CCSize(356, 4))
        fgLine:setPosition(w_board / 2, 355)
        herolayer:addChild(fgLine)
        local fazhen = img.createUISprite(img.ui.hero_energize_fazhen)
        fazhen:setPosition(w_board / 2, 210)
        herolayer:addChild(fazhen)
        local skillIconBg = {}
        local skillTips = {}
        local px = {54, 135, 217}
        local py = {195, 55, 196}
        for ii = 1,  cfgtalen[ cfgtalen].talenSkills do
          local skillId = cfgtalen[ cfgtalen].talenSkills[ii]
          skillIconBg[ii] = img.createUISprite(img.ui.hero_skill_bg)
          skillIconBg[ii]:setPosition(px[ii], py[ii])
          fazhen:addChild(skillIconBg[ii])
          local skillIcon = img.createSkill(skillId)
          skillIcon:setPosition(skillIconBg[ii]:getContentSize().width / 2, skillIconBg[ii]:getContentSize().height / 2)
          skillIconBg[ii]:addChild(skillIcon)
          skillTips[ii] = require("ui.tips.skill").create(skillId)
          skillTips[ii]:setAnchorPoint(ccp(1, 0))
          skillTips[ii]:setPosition(409, skillIconBg[ii]:boundingBox():getMaxY() + 70)
          herolayer:addChild(skillTips[ii])
          skillTips[ii]:setVisible(false)
        end
        line:setVisible(false)
        upboard:setVisible(false)
        if advancedBtn then
          advancedBtn:setVisible(false)
          transchangeBtn:setVisible(false)
        end
        local onTouch = function(l_1_0, l_1_1, l_1_2)
          local point = fazhen:convertToNodeSpace(ccp(l_1_1, l_1_2))
          for ii = 1,  skillTips do
            if skillIconBg[ii]:boundingBox():containsPoint(point) then
              skillTips[ii]:setVisible(true)
            else
              skillTips[ii]:setVisible(false)
            end
          end
          if l_1_0 ~= "began" and l_1_0 ~= "moved" then
            for ii = 1,  skillTips do
              skillTips[ii]:setVisible(false)
            end
          end
          return true
            end
        herolayer:registerScriptTouchHandler(onTouch)
        herolayer:setTouchEnabled(true)
        herolayer:setTouchSwallowEnabled(false)
        return herolayer
      end
    end
    if l_1_1 == 4 and cfghero[l_1_0].nId == nil then
      local redstar = l_1_1
      local sx1 = w_board / 2 - 15 * (redstar - 1)
      local dx = 30
      do
        if redstar == MAXWAKE + 1 then
          do return end
        end
        do
          for i = 1, redstar do
            local starIcon1 = img.createUISprite(img.ui.hero_star_orange)
            do
              starIcon1:setScale(0.9)
              starIcon1:setPosition(sx1 + (i - 1) * dx, 407)
              herolayer:addChild(starIcon1)
            end
          end
        end
        local wakefullStr = i18n.global.hero_wake_wake_full.string
        local wakefulltip = lbl.createMixFont1(16, wakefullStr, ccc3(218, 206, 176))
        do
          wakefulltip:setPosition(w_board / 2, 324)
          herolayer:addChild(wakefulltip)
          if heroData.wake >= 4 then
            wakefullStr = i18n.global.hero_talen_talen_full.string
            wakefulltip:setString(wakefullStr)
            wakefulltip:setPosition(w_board / 2, 310)
          end
          local costbg = img.createUI9Sprite(img.ui.hero_evolve_cost_bg)
          costbg:setPreferredSize(CCSize(186, 32))
          costbg:setPosition(w_board / 2, 118)
          herolayer:addChild(costbg)
          local stoneIcon = img.createItemIcon(ITEM_ID_EVOLVE_EXP)
          stoneIcon:setScale(0.55)
          stoneIcon:setPosition(7, costbg:getContentSize().height / 2)
          costbg:addChild(stoneIcon)
          local evolvenum = 0
          if bag.items.find(ITEM_ID_EVOLVE_EXP) then
            evolvenum = bag.items.find(ITEM_ID_EVOLVE_EXP).num
          end
          local showEvolveAll = lbl.createFont2(16, string.format("%d/%d", evolvenum, 0), ccc3(255, 247, 229))
          showEvolveAll:setPosition(costbg:getContentSize().width / 2 + 5, costbg:getContentSize().height / 2 + 2)
          costbg:addChild(showEvolveAll)
          for i = 1, 4 do
            local btnHero = img.createUISprite(img.ui.select_hero_hero_bg)
            btnHero:setScale(0.67)
            btnHero:setPosition(86 + (i - 1) * 80, 196)
            herolayer:addChild(btnHero)
          end
          return herolayer
        end
      end
      initHeros(l_1_2)
      getCondition(l_1_0, l_1_1)
      if l_1_1 >= 5 then
        json.load(json.ui.lv10plus_hero)
        local energizeStar = DHSkeletonAnimation:createWithKey(json.ui.lv10plus_hero)
        energizeStar:scheduleUpdateLua()
        energizeStar:playAnimation("animation", -1)
        energizeStar:setPosition(w_board / 2, 400)
        herolayer:addChild(energizeStar)
        local energizeStarLab = lbl.createFont2(26, l_1_1 - 4)
        energizeStarLab:setPosition(energizeStar:getContentSize().width / 2, 0)
        energizeStar:addChild(energizeStarLab)
        energizeStar:setScale(0.72)
        if l_1_1 == MAXWAKE + 1 then
          energizeStarLab:setString(l_1_1 - 4 - 1)
        end
        line:setPosition(w_board / 2, 360)
        local iconleFlower = img.createUISprite(img.ui.hero_energize_flower)
        iconleFlower:setScale(0.86)
        iconleFlower:setFlipX(true)
        iconleFlower:setPosition(w_board / 2 - 85, 400)
        herolayer:addChild(iconleFlower)
        local iconRFlower = img.createUISprite(img.ui.hero_energize_flower)
        iconRFlower:setScale(0.86)
        iconRFlower:setPosition(w_board / 2 + 85, 400)
        herolayer:addChild(iconRFlower)
        local skillDetail = img.createUISprite(img.ui.hero_energize_skillbtn)
        local skillDetailBtn = SpineMenuItem:create(json.ui.button, skillDetail)
        skillDetailBtn:setPosition(CCPoint(w_board / 2 + 138, 395))
        local skillDetailMenu = CCMenu:createWithItem(skillDetailBtn)
        skillDetailMenu:setPosition(0, 0)
        herolayer:addChild(skillDetailMenu)
        skillDetailBtn:registerScriptTapHandler(function()
          audio.play(audio.button)
          local talenSkill = require("ui.hero.talenskill")
          superlayer:addChild(talenSkill.create(exstar - 4 - 1), 2000)
            end)
        line:setPosition(w_board / 2, 362)
        local levelLab = lbl.createMixFont1(16, i18n.global.hero_wake_level_up.string, ccc3(253, 235, 135))
        levelLab:setAnchorPoint(1, 0.5)
        levelLab:setPosition(w_board / 2 - 40, 337)
        herolayer:addChild(levelLab)
        local levelCap = lbl.createFont1(16, cfgtalen[l_1_1 - 4].addMaxLv, ccc3(157, 244, 38))
        levelCap:setAnchorPoint(0, 0.5)
        levelCap:setPosition(CCPoint(levelLab:boundingBox():getMaxX() + 15, 337))
        herolayer:addChild(levelCap)
        for ii = 1,  cfgtalen[l_1_1 - 4].base do
          local cfgvalue = math.abs(cfgtalen[l_1_1 - 4].base[ii].num)
          if l_1_1 - 4 > 1 then
            cfgvalue = math.abs(cfgtalen[l_1_1 - 4].base[ii].num) - math.abs(cfgtalen[l_1_1 - 5].base[ii].num)
          end
          local name1, value1 = buffString(cfgtalen[l_1_1 - 4].base[ii].type, cfgvalue)
          local attrLab1 = lbl.createMixFont1(16, name1 .. ":", ccc3(253, 235, 135))
          attrLab1:setAnchorPoint(1, 0.5)
          attrLab1:setPosition(w_board / 2 - 40, 337 - 28 * ii)
          herolayer:addChild(attrLab1)
          local attrNum1 = lbl.createFont1(16, "+" .. value1, ccc3(157, 244, 38))
          attrNum1:setAnchorPoint(0, 0.5)
          attrNum1:setPosition(CCPoint(attrLab1:boundingBox():getMaxX() + 15, 337 - 28 * ii))
          herolayer:addChild(attrNum1)
        end
        local unlockLab = lbl.createMixFont1(16, i18n.global.hero_unlock.string, ccc3(253, 235, 135))
        unlockLab:setPosition(315, 337)
        herolayer:addChild(unlockLab)
        local levelCap = lbl.createFont1(16, cfgtalen[l_1_1 - 4].addMaxLv, ccc3(157, 244, 38))
        local skillId = cfgtalen[l_1_1 - 4].talenSkills[l_1_1 - 4]
        local skillIconBg = img.createUISprite(img.ui.hero_skill_bg)
        skillIconBg:setScale(0.75)
        skillIconBg:setPosition(315, 295)
        herolayer:addChild(skillIconBg, 100)
        local skillIcon = img.createSkill(skillId)
        skillIcon:setPosition(skillIconBg:getContentSize().width / 2, skillIconBg:getContentSize().height / 2)
        skillIconBg:addChild(skillIcon)
        local skillTips = require("ui.tips.skill").create(skillId)
        skillTips:setAnchorPoint(ccp(1, 0))
        skillTips:setPosition(409, skillIconBg:boundingBox():getMaxY())
        herolayer:addChild(skillTips)
        skillTips:setVisible(false)
        local selectsx = 95
        if  operData.condition == 3 then
          selectsx = selectsx + 40
        end
        if  operData.condition == 2 then
          selectsx = selectsx + 80
        end
        if  operData.condition == 1 then
          selectsx = selectsx + 120
        end
        for i,v in ipairs(operData.condition) do
          local btnSp = nil
          btnSp = img.createHeroHead(v.id, nil, true, true)
          local btnHero = CCMenuItemSprite:create(btnSp, nil)
          btnHero:setScale(0.67)
          btnHero:setPosition(selectsx + (i - 1) * 80, 196)
          local menuHero = CCMenu:createWithItem(btnHero)
          menuHero:setPosition(0, 0)
          herolayer:addChild(menuHero)
          local showNum = lbl.createFont2(16, "0/" .. v.num)
          showNum:setPosition(btnHero:boundingBox():getMidX(), 154)
          herolayer:addChild(showNum)
          setShader(btnHero, SHADER_GRAY, true)
          json.load(json.ui.sheng_xing2)
          showAnim[i] = DHSkeletonAnimation:createWithKey(json.ui.sheng_xing2)
          showAnim[i]:scheduleUpdateLua()
          showAnim[i]:stopAnimation()
          showAnim[i]:setPosition(btnHero:boundingBox():getMidX(), btnHero:boundingBox():getMidY())
          herolayer:addChild(showAnim[i], 1001)
          local icon = img.createUISprite(img.ui.hero_equip_add)
          icon:setScale(0.8)
          icon:setPosition(btnHero:boundingBox():getMaxX() - 18, btnHero:boundingBox():getMaxY() - 18)
          herolayer:addChild(icon)
          icon:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(0.5, 76.5), CCFadeTo:create(0.5, 255))))
          btnHero:registerScriptTapHandler(function()
            local func = function()
              showNum:setString( v.select .. "/" .. v.num)
              if  v.select < v.num then
                setShader(btnHero, SHADER_GRAY, true)
                showNum:setColor(ccc3(255, 255, 255))
              else
                clearShader(btnHero, true)
                showNum:setColor(ccc3(195, 255, 66))
              end
                  end
            superlayer:addChild(createSelectBoard(v, func), 2000)
               end)
        end
        local costbg = img.createUI9Sprite(img.ui.hero_evolve_cost_bg)
        costbg:setPreferredSize(CCSize(185, 32))
        costbg:setPosition(w_board / 2, 118)
        herolayer:addChild(costbg)
        local stoneIcon = img.createItemIcon(ITEM_ID_EVOLVE_EXP)
        stoneIcon:setScale(0.55)
        stoneIcon:setPosition(7, costbg:getContentSize().height / 2)
        costbg:addChild(stoneIcon)
        local evolvenum = 0
        if bag.items.find(ITEM_ID_EVOLVE_EXP) then
          evolvenum = bag.items.find(ITEM_ID_EVOLVE_EXP).num
        end
        local stoneMaterial = 0
        stoneMaterial = cfgtalen[l_1_1 - 4].stoneMaterial
        local showEvolveAll = lbl.createFont2(16, string.format("%d/%d", evolvenum, stoneMaterial), ccc3(255, 247, 229))
        showEvolveAll:setPosition(costbg:getContentSize().width / 2 + 5, costbg:getContentSize().height / 2)
        costbg:addChild(showEvolveAll)
        local onTouch = function(l_4_0, l_4_1, l_4_2)
          local point = herolayer:convertToNodeSpace(ccp(l_4_1, l_4_2))
          if skillIconBg:boundingBox():containsPoint(point) then
            skillTips:setVisible(true)
          else
            skillTips:setVisible(false)
          end
          if l_4_0 ~= "began" and l_4_0 ~= "moved" then
            skillTips:setVisible(false)
          end
          return true
            end
        herolayer:registerScriptTouchHandler(onTouch)
        herolayer:setTouchEnabled(true)
        herolayer:setTouchSwallowEnabled(false)
        return herolayer
      end
      local sx1 = 90
      local dx = 25
      local sx2 = 265
      for i = 1, l_1_1 do
        local starIcon1 = img.createUISprite(img.ui.hero_star_orange)
        starIcon1:setScale(0.9)
        starIcon1:setPosition(sx1 + (i - 1) * dx, 407)
        herolayer:addChild(starIcon1)
      end
      for i = l_1_1 + 1, 4 do
        local starIcon1 = img.createUISprite(img.ui.hero_up_nstar)
        starIcon1:setPosition(sx1 + (i - 1) * dx, 407)
        herolayer:addChild(starIcon1)
        if i ~= l_1_1 + 1 then
          local starIcon2 = img.createUISprite(img.ui.hero_up_nstar)
          starIcon2:setPosition(sx2 + (i - 1) * dx, 407)
          herolayer:addChild(starIcon2)
        end
      end
      if l_1_1 == 4 then
        local starIcon2 = img.createUISprite(img.ui.hero_star_ten)
        starIcon2:setScale(0.9)
        starIcon2:setPosition(sx2 + dx, 407)
        herolayer:addChild(starIcon2)
      else
        for i = 1, l_1_1 + 1 do
          local starIcon2 = img.createUISprite(img.ui.hero_star_orange)
          starIcon2:setScale(0.9)
          starIcon2:setPosition(sx2 + (i - 1) * dx, 407)
          herolayer:addChild(starIcon2)
        end
      end
      local starraw = img.createUISprite(img.ui.hero_btn_raw)
      starraw:setScale(0.33)
      starraw:setPosition(w_board / 2, 407)
      herolayer:addChild(starraw)
      local skillraw = img.createUISprite(img.ui.hero_btn_raw)
      skillraw:setScale(0.75)
      skillraw:setPosition(w_board / 2, 337)
      herolayer:addChild(skillraw)
      local skillId1 = cfghero[l_1_0].actSkillId
      local skillId2 = cfghero[l_1_0].actSkillId
      local nextId = nil
      if l_1_1 >= 4 then
        nextId = cfghero[l_1_0].nId
        skillId2 = cfghero[nextId].actSkillId
      else
        if heroData.wake then
          skillId1 = cfghero[l_1_0].disillusSkill[heroData.wake].disi[1]
        end
        if skillId1 ~= cfghero[l_1_0].disillusSkill[l_1_1].disi[1] then
          skillId2 = cfghero[l_1_0].disillusSkill[l_1_1].disi[1]
        end
        if skillId1 == skillId2 then
          for i = 1, 3 do
            if heroData.wake then
              skillId1 = cfghero[l_1_0].disillusSkill[heroData.wake].disi[i + 1]
            else
              skillId1 = cfghero[l_1_0].pasSkill" .. i .. "Id
            end
            if skillId1 ~= cfghero[l_1_0].disillusSkill[l_1_1].disi[i + 1] then
              skillId2 = cfghero[l_1_0].disillusSkill[l_1_1].disi[i + 1]
          else
            end
          end
        end
      end
      local skillIconBg1 = img.createUISprite(img.ui.hero_skill_bg)
      skillIconBg1:setScale(0.75)
      skillIconBg1:setPosition(130, 337)
      herolayer:addChild(skillIconBg1, 100)
      local skillIcon1 = img.createSkill(skillId1)
      skillIcon1:setPosition(skillIconBg1:getContentSize().width / 2, skillIconBg1:getContentSize().height / 2)
      skillIconBg1:addChild(skillIcon1)
      json.load(json.ui.sheng_xing1)
      aniskill[1] = DHSkeletonAnimation:createWithKey(json.ui.sheng_xing1)
      aniskill[1]:scheduleUpdateLua()
      aniskill[1]:setPosition(skillIconBg1:boundingBox():getMidX(), skillIconBg1:boundingBox():getMidY())
      aniskill[1]:setVisible(false)
      herolayer:addChild(aniskill[1], 100)
      local skillTips1 = require("ui.tips.skill").create(skillId1)
      skillTips1:setAnchorPoint(ccp(1, 0))
      skillTips1:setPosition(409, skillIconBg1:boundingBox():getMaxY())
      herolayer:addChild(skillTips1)
      skillTips1:setVisible(false)
      local skillIconBg2 = img.createUISprite(img.ui.hero_skill_bg)
      skillIconBg2:setScale(0.75)
      skillIconBg2:setPosition(297, 337)
      herolayer:addChild(skillIconBg2, 100)
      local skillIcon2 = img.createSkill(skillId2)
      skillIcon2:setPosition(skillIconBg2:getContentSize().width / 2, skillIconBg2:getContentSize().height / 2)
      skillIconBg2:addChild(skillIcon2)
      if l_1_1 < 4 then
        local skillLB1 = img.createUISprite(img.ui.hero_skilllevel_bg)
        skillLB1:setPosition(skillIconBg1:getContentSize().width - 15, skillIconBg1:getContentSize().height - 15)
        skillIconBg1:addChild(skillLB1)
        local skilllab1 = lbl.createFont1(18, "2", ccc3(255, 246, 223))
        skilllab1:setPosition(skillLB1:getContentSize().width / 2, skillLB1:getContentSize().height / 2)
        skillLB1:addChild(skilllab1)
        local skillLB2 = img.createUISprite(img.ui.hero_skilllevel_bg)
        skillLB2:setPosition(skillIconBg2:getContentSize().width - 15, skillIconBg2:getContentSize().height - 15)
        skillIconBg2:addChild(skillLB2)
        local skilllab2 = lbl.createFont1(18, "3", ccc3(255, 246, 223))
        skilllab2:setPosition(skillLB2:getContentSize().width / 2, skillLB2:getContentSize().height / 2)
        skillLB2:addChild(skilllab2)
      end
      aniskill[2] = DHSkeletonAnimation:createWithKey(json.ui.sheng_xing1)
      aniskill[2]:scheduleUpdateLua()
      aniskill[2]:setVisible(false)
      aniskill[2]:setPosition(skillIconBg2:boundingBox():getMidX(), skillIconBg2:boundingBox():getMidY())
      herolayer:addChild(aniskill[2], 100)
      local skillTips2 = require("ui.tips.skill").create(skillId2)
      skillTips2:setAnchorPoint(ccp(1, 0))
      skillTips2:setPosition(409, skillIconBg2:boundingBox():getMaxY())
      herolayer:addChild(skillTips2)
      skillTips2:setVisible(false)
      local onTouch = function(l_5_0, l_5_1, l_5_2)
        local point = herolayer:convertToNodeSpace(ccp(l_5_1, l_5_2))
        if skillIconBg1:boundingBox():containsPoint(point) then
          skillTips1:setVisible(true)
        else
          skillTips1:setVisible(false)
        end
        if skillIconBg2:boundingBox():containsPoint(point) then
          skillTips2:setVisible(true)
        else
          skillTips2:setVisible(false)
        end
        if l_5_0 ~= "began" and l_5_0 ~= "moved" then
          skillTips1:setVisible(false)
          skillTips2:setVisible(false)
        end
        return true
         end
      herolayer:registerScriptTouchHandler(onTouch)
      herolayer:setTouchEnabled(true)
      herolayer:setTouchSwallowEnabled(false)
      local attrlab = lbl.createMixFont1(14, i18n.global.hero_wake_attr_up_out.string, ccc3(255, 246, 223))
      attrlab:setPosition(w_board / 2 - 22, 289)
      herolayer:addChild(attrlab)
      local toattr = lbl.createFont1(14, "20%", ccc3(157, 244, 38))
      toattr:setAnchorPoint(0, 0.5)
      toattr:setPosition(CCPoint(attrlab:boundingBox():getMaxX() + 10, 288))
      herolayer:addChild(toattr)
      if not cfghero[heroData.id].starLv" .. heroData.star +  then
        local lvMax = cfghero[heroData.id].maxLv
      end
      if heroData.wake then
        lvMax = lvMax + heroData.wake * 20
      end
      local lvlab = lbl.createMixFont1(14, i18n.global.hero_wake_level_up_out.string, ccc3(255, 246, 223))
      lvlab:setPosition(w_board / 2 - 21, 270)
      herolayer:addChild(lvlab)
      local tolv = lbl.createFont1(14, lvMax + 20, ccc3(157, 244, 38))
      tolv:setAnchorPoint(0, 0.5)
      tolv:setPosition(CCPoint(lvlab:boundingBox():getMaxX() + 10, 269))
      herolayer:addChild(tolv)
      if l_1_1 == 4 then
        toattr:setString("30%")
        tolv:setString(lvMax + 50)
      end
      local selectsx = 95
      if  operData.condition == 3 then
        selectsx = selectsx + 40
      end
      if  operData.condition == 2 then
        selectsx = selectsx + 80
      end
      if  operData.condition == 1 then
        selectsx = selectsx + 120
      end
      for i,v in ipairs(operData.condition) do
        local btnSp = nil
        btnSp = img.createHeroHead(v.id, nil, true, true)
        local btnHero = CCMenuItemSprite:create(btnSp, nil)
        btnHero:setScale(0.67)
        btnHero:setPosition(selectsx + (i - 1) * 80, 196)
        local menuHero = CCMenu:createWithItem(btnHero)
        menuHero:setPosition(0, 0)
        herolayer:addChild(menuHero)
        local showNum = lbl.createFont2(16, "0/" .. v.num)
        showNum:setPosition(btnHero:boundingBox():getMidX(), 154)
        herolayer:addChild(showNum)
        setShader(btnHero, SHADER_GRAY, true)
        json.load(json.ui.sheng_xing2)
        showAnim[i] = DHSkeletonAnimation:createWithKey(json.ui.sheng_xing2)
        showAnim[i]:scheduleUpdateLua()
        showAnim[i]:stopAnimation()
        showAnim[i]:setPosition(btnHero:boundingBox():getMidX(), btnHero:boundingBox():getMidY())
        herolayer:addChild(showAnim[i], 1001)
        local icon = img.createUISprite(img.ui.hero_equip_add)
        icon:setScale(0.8)
        icon:setPosition(btnHero:boundingBox():getMaxX() - 18, btnHero:boundingBox():getMaxY() - 18)
        herolayer:addChild(icon)
        icon:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(0.5, 76.5), CCFadeTo:create(0.5, 255))))
        btnHero:registerScriptTapHandler(function()
          local func = function()
            showNum:setString( v.select .. "/" .. v.num)
            if  v.select < v.num then
              setShader(btnHero, SHADER_GRAY, true)
              showNum:setColor(ccc3(255, 255, 255))
            else
              clearShader(btnHero, true)
              showNum:setColor(ccc3(195, 255, 66))
            end
               end
          superlayer:addChild(createSelectBoard(v, func), 2000)
            end)
      end
      local costbg = img.createUI9Sprite(img.ui.hero_evolve_cost_bg)
      costbg:setPreferredSize(CCSize(185, 32))
      costbg:setPosition(w_board / 2, 118)
      herolayer:addChild(costbg)
      local stoneIcon = img.createItemIcon(ITEM_ID_EVOLVE_EXP)
      stoneIcon:setScale(0.55)
      stoneIcon:setPosition(7, costbg:getContentSize().height / 2)
      costbg:addChild(stoneIcon)
      local evolvenum = 0
      if bag.items.find(ITEM_ID_EVOLVE_EXP) then
        evolvenum = bag.items.find(ITEM_ID_EVOLVE_EXP).num
      end
      local stoneMaterial = 0
      if l_1_1 >= 4 then
        stoneMaterial = cfghero[nextId].stoneMaterial[1]
      else
        stoneMaterial = cfghero[l_1_0].stoneMaterial[l_1_1]
      end
      do
        local showEvolveAll = lbl.createFont2(16, string.format("%d/%d", evolvenum, stoneMaterial), ccc3(255, 247, 229))
        showEvolveAll:setPosition(costbg:getContentSize().width / 2 + 5, costbg:getContentSize().height / 2)
        costbg:addChild(showEvolveAll)
        return herolayer
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local wake = 0
  if l_4_0.wake then
    wake = l_4_0.wake
  end
  upherolayer = createupherolayer(l_4_0.id, wake + 1, l_4_0.hid)
  board:addChild(upherolayer)
  local advancedSprite = img.createLogin9Sprite(img.login.button_9_small_green)
  advancedSprite:setPreferredSize(CCSizeMake(150, 51))
  advancedBtn = SpineMenuItem:create(json.ui.button, advancedSprite)
  advancedBtn:setPosition(CCPoint(w_board / 2 + 80, 60))
  local receiptallMenu = CCMenu:createWithItem(advancedBtn)
  receiptallMenu:setPosition(0, 0)
  board:addChild(receiptallMenu)
  if wake == MAXWAKE then
    advancedBtn:setVisible(false)
  end
  local advancedStr = i18n.global.hero_wake_btn.string
  if wake >= 4 then
    advancedStr = i18n.global.hero_btn_talenl.string
  end
  local advancedIcon = img.createUISprite(img.ui.hero_enegy_btn)
  advancedIcon:setPosition(CCPoint(24, advancedBtn:getContentSize().height / 2))
  advancedSprite:addChild(advancedIcon)
  local advancedLab = lbl.createFont1(18, advancedStr, ccc3(29, 103, 0))
  advancedLab:setPosition(CCPoint(88, advancedBtn:getContentSize().height / 2))
  advancedSprite:addChild(advancedLab)
  advancedBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if wake == 3 and cfghero[heroData.id].nId == nil then
      showToast(i18n.global.hero_wake_wake_full.string)
      return 
    end
    if wake == MAXWAKE then
      showToast(i18n.global.hero_talen_talen_full.string)
      return 
    end
    local evolvenum = 0
    if bag.items.find(ITEM_ID_EVOLVE_EXP) then
      evolvenum = bag.items.find(ITEM_ID_EVOLVE_EXP).num
    end
    if wake >= 4 then
      if evolvenum < cfgtalen[wake - 3].stoneMaterial then
        showToast(i18n.global.toast_hero_need_evolve.string)
        return 
      end
      local hids = {}
      do
        if not operData.condition then
          return 
        end
        for i,v in ipairs(operData.condition) do
          if v.num <=  v.select then
            for j,k in ipairs(v.select) do
              hids[ hids + 1] = k
            end
            for i,v in (for generator) do
            end
            showToast(i18n.global.hero_wake_no_hero.string)
            return 
          end
          local params = {sid = player.sid, hid = heroData.hid, source = hids}
          tbl2string(params)
          addWaitNet()
          net:hero_talen(params, function(l_1_0)
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
            for i = 1,  operData.condition do
              showAnim[i]:playAnimation("animation")
            end
            local exp = heros.decomposeForwake(hids)
            bag.items.add({id = ITEM_ID_HERO_EXP, num = exp})
            bag.items.sub({id = ITEM_ID_EVOLVE_EXP, num = cfgtalen[wake - 3].stoneMaterial})
            local preHero = clone(heroData)
            heros.wakeUp(heroData.hid, heroData.id)
            upvalue_3584 = wake + 1
            local achieveData = require("data.achieve")
            if wake == 7 then
              achieveData.add(ACHIEVE_TYPE_WAKE13, 1)
            end
            for i,v in ipairs(hids) do
              local heroData = heros.find(v)
              if heroData then
                for j,k in ipairs(heroData.equips) do
                  if cfgequip[k].pos == EQUIP_POS_JADE then
                    bag.items.addAll(cfgequip[k].jadeUpgAll)
                  end
                end
              end
              heros.del(v)
            end
            callfuncstar(hids)
            schedule(board, 2, function()
              if upherolayer then
                upherolayer:removeFromParentAndCleanup()
                upherolayer = nil
              end
              local talentips = require("ui.hero.talentips")
              superlayer:addChild(talentips.create(heroData, preHero), 2000)
              upherolayer = createupherolayer(heroData.id, wake + 1, heroData.hid)
              board:addChild(upherolayer)
              ban:removeFromParent()
                  end)
               end)
          return 
        end
      end
       -- DECOMPILER ERROR: unhandled construct in 'if'

      if wake == 3 and evolvenum < cfghero[cfghero[heroData.id].nId].stoneMaterial[1] then
        showToast(i18n.global.toast_hero_need_evolve.string)
        return 
        do return end
        if evolvenum < cfghero[heroData.id].stoneMaterial[wake + 1] then
          showToast(i18n.global.toast_hero_need_evolve.string)
          return 
        end
      end
      local hids = {}
      if not operData.condition then
        return 
      end
      for i,v in ipairs(operData.condition) do
        if v.num <=  v.select then
          for j,k in ipairs(v.select) do
            hids[ hids + 1] = k
          end
          for i,v in (for generator) do
          end
          showToast(i18n.global.hero_wake_no_hero.string)
          return 
        end
        do
          local params = {sid = player.sid, hid = heroData.hid, source = hids}
          tbl2string(params)
          addWaitNet()
          net:hero_wake(params, function(l_2_0)
          delWaitNet()
          tbl2string(l_2_0)
          if l_2_0.status < 0 then
            showToast("status:" .. l_2_0.status)
            return 
          end
          local activityData = require("data.activity")
          local IDS = activityData.IDS
          local ban = CCLayer:create()
          ban:setTouchEnabled(true)
          ban:setTouchSwallowEnabled(true)
          layer:addChild(ban, 2000)
          for i = 1,  operData.condition do
            showAnim[i]:playAnimation("animation")
          end
          for i = 1, 2 do
            aniskill[i]:setVisible(true)
            aniskill[i]:playAnimation("animation")
          end
          local exp = heros.decomposeForwake(hids)
          bag.items.add({id = ITEM_ID_HERO_EXP, num = exp})
          if wake == 3 then
            bag.items.sub({id = ITEM_ID_EVOLVE_EXP, num = cfghero[cfghero[heroData.id].nId].stoneMaterial[1]})
          else
            bag.items.sub({id = ITEM_ID_EVOLVE_EXP, num = cfghero[heroData.id].stoneMaterial[wake + 1]})
          end
          local preHero = clone(heroData)
          heros.wakeUp(heroData.hid, heroData.id)
          upvalue_3584 = wake + 1
          local achieveData = require("data.achieve")
          if wake == 3 then
            achieveData.add(ACHIEVE_TYPE_WAKE9, 1)
          end
          if wake == 4 then
            achieveData.add(ACHIEVE_TYPE_WAKE10, 1)
          end
          if wake >= 3 then
            local tmp_status = activityData.getStatusById(IDS.AWAKING_GLORY_2.ID)
            if cfghero[heroData.id].maxStar == 10 then
              tmp_status = activityData.getStatusById(IDS.AWAKING_GLORY_1.ID)
            end
            if tmp_status and tmp_status.limits and tmp_status.limits > 0 then
              tmp_status.limits = tmp_status.limits - 1
            end
            local mactivityData = require("data.monthlyactivity")
            local mIDS = mactivityData.IDS
            local mtmp_status = mactivityData.getStatusById(mIDS.FORGE_3.ID)
            if cfghero[heroData.id].maxStar == 10 then
              mtmp_status = mactivityData.getStatusById(mIDS.FORGE_4.ID)
            end
            mactivityData.addScore(mtmp_status.id)
          end
          for i,v in ipairs(hids) do
            local heroData = heros.find(v)
            if heroData then
              for j,k in ipairs(heroData.equips) do
                if cfgequip[k].pos == EQUIP_POS_JADE then
                  bag.items.addAll(cfgequip[k].jadeUpgAll)
                end
              end
            end
            heros.del(v)
          end
          callfuncstar(hids)
          if wake == 4 then
            titleShade:setString(i18n.global.hero_talen_title.string)
            title:setString(i18n.global.hero_talen_title.string)
            advancedLab:setString(i18n.global.hero_btn_talenl.string)
          end
          schedule(board, 2, function()
            if upherolayer then
              upherolayer:removeFromParentAndCleanup()
              upherolayer = nil
            end
            local upherotips = require("ui.hero.upherotips")
            superlayer:addChild(upherotips.create(heroData, preHero), 2000)
            upherolayer = createupherolayer(heroData.id, wake + 1, heroData.hid)
            board:addChild(upherolayer)
            ban:removeFromParent()
               end)
            end)
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end)
  local transchangeSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
  transchangeSprite:setPreferredSize(CCSizeMake(150, 51))
  transchangeBtn = SpineMenuItem:create(json.ui.button, transchangeSprite)
  transchangeBtn:setPosition(CCPoint(w_board / 2 - 80, 60))
  local transIcon = img.createUISprite(img.ui.hero_trans_btn)
  transIcon:setPosition(CCPoint(24, transchangeBtn:getContentSize().height / 2))
  transchangeSprite:addChild(transIcon)
  local transchangeLab = lbl.createFont1(18, i18n.global.tips_recast.string, ccc3(115, 59, 5))
  transchangeLab:setPosition(CCPoint(88, transchangeBtn:getContentSize().height / 2))
  transchangeSprite:addChild(transchangeLab)
  local transchangeMenu = CCMenu:createWithItem(transchangeBtn)
  transchangeMenu:setPosition(0, 0)
  board:addChild(transchangeMenu)
  if wake == MAXWAKE then
    transchangeBtn:setPosition(CCPoint(w_board / 2, 56))
  end
  if wake < 4 then
    transchangeBtn:setVisible(false)
    advancedBtn:setPosition(CCPoint(w_board / 2, 60))
  end
  transchangeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    if heroData.flag and heroData.flag > 0 then
      local count = 0
      local text = ""
      if heroData.flag % 2 == 1 then
        text = text .. i18n.global.toast_devour_arena.string
        count = count + 1
      end
      if math.floor(heroData.flag / 2) % 2 == 1 then
        if count >= 1 then
          text = text .. "\n"
        end
        text = text .. i18n.global.toast_devour_lock.string
        count = count + 1
      end
      if math.floor(heroData.flag / 4) % 2 % 2 == 1 then
        if count >= 1 then
          text = text .. "\n"
        end
        text = text .. i18n.global.toast_devour_3v3arena.string
        count = count + 1
      end
      if math.floor(heroData.flag / 8) % 2 % 2 % 2 == 1 then
        if count >= 1 then
          text = text .. "\n"
        end
        text = text .. i18n.global.toast_devour_frdarena.string
        count = count + 1
      end
      showToast(text)
      return 
    end
    local transchangeLayer = require("ui.hero.transchange")
    superlayer:addChild(transchangeLayer.create(heroData.hid), 2000)
   end)
  return layer
end

return uphero


-- Command line was: E:\github\dhgametool\scripts\ui\heroforge\main.lua 

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
local tmpheros = {}
local operData = {}
local createBoardForRewards = function(l_1_0, l_1_1)
  local heroData = heros.find(l_1_0)
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
  local hero = img.createHeroHeadByHid(l_1_0)
  heroBtn = SpineMenuItem:create(json.ui.button, hero)
  heroBtn:setScale(0.85)
  heroBtn:setPosition(dialog.board:getContentSize().width / 2, 185)
  local iconMenu = CCMenu:createWithItem(heroBtn)
  iconMenu:setPosition(0, 0)
  dialog.board:addChild(iconMenu)
  heroBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local herotips = require("ui.tips.hero")
    local heroInfo = clone(heroData.attr())
    heroInfo.lv = heroData.lv
    heroInfo.star = heroData.star
    heroInfo.id = heroData.id
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

local initHeros = function()
  local tmpheros = {}
  for i,v in ipairs(heros) do
    tmpheros[#tmpheros + 1] = {hid = v.hid, id = v.id, lv = v.lv, isUsed = false, flag = v.flag or 0}
  end
  operData.heros = tmpheros
end

local getCondition = function(l_3_0)
  local condition = {1 = {id = cfghero[l_3_0].host, num = 1, select = {}}}
  for i,v in ipairs(cfghero[l_3_0].material) do
    local isFind = false
    for j,k in ipairs(condition) do
      if k.id == v and j ~= 1 then
        k.num = k.num + 1
        isFind = true
    else
      end
    end
    if not isFind then
      condition[#condition + 1] = {id = v, num = 1, select = {}}
    end
  end
  operData.condition = condition
end

local numforhero = function(l_4_0)
  local headData = {}
  for i,v in ipairs(operData.heros) do
    if v.id == l_4_0.id and v.isUsed == false then
      headData[#headData + 1] = v
      for i,v in (for generator) do
      end
      if v.isUsed == false and l_4_0.id % 100 == 99 then
        if cfghero[v.id].group == (l_4_0.id - 4099) / 100 and cfghero[v.id].qlt == 4 and v.id < 5000 then
          headData[#headData + 1] = v
          for i,v in (for generator) do
          end
          if cfghero[v.id].group == (l_4_0.id - 5099) / 100 and cfghero[v.id].qlt == 5 and v.id >= 5000 then
            headData[#headData + 1] = v
            for i,v in (for generator) do
            end
            for j,k in ipairs(l_4_0.select) do
              if k == v.hid then
                headData[#headData + 1] = v
                for i,v in (for generator) do
                end
              end
            end
          end
          do
            local surenum = #headData
            for i,v in ipairs(headData) do
              if v.isUsed == true then
                surenum = surenum - 1
              end
            end
            return surenum
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

local createSelectBoard = function(l_5_0, l_5_1)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 210))
  local headData = {}
  for i,v in ipairs(operData.heros) do
    if v.id == l_5_0.id and v.isUsed == false then
      headData[#headData + 1] = v
      for i,v in (for generator) do
      end
      if v.isUsed == false and l_5_0.id % 100 == 99 then
        if cfghero[v.id].group == (l_5_0.id - 4099) / 100 and cfghero[v.id].qlt == 4 and v.id < 5000 then
          headData[#headData + 1] = v
          for i,v in (for generator) do
          end
          if cfghero[v.id].group == (l_5_0.id - 5099) / 100 and cfghero[v.id].qlt == 5 and v.id >= 5000 then
            headData[#headData + 1] = v
            for i,v in (for generator) do
            end
            for j,k in ipairs(l_5_0.select) do
              if k == v.hid then
                headData[#headData + 1] = v
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
          board:setPosition(scalep(480, 288))
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
              if #tmpSelect == 0 and #curSelect ~= 0 then
                for z = i, #curSelect do
                  if v.hid == curSelect[z] then
                    v.isUsed = true
                else
                  end
                end
              end
              for j = 1, #tmpSelect do
                if v.hid == tmpSelect[j] then
                  local curflag = false
                  for z = i, #curSelect do
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
            local param = {id = v.id, lv = v.lv, showGroup = true, showStar = true, wake = nil, orangeFx = nil, petID = nil, hid = v.hid}
            showHeads[i] = img.createHeroHeadByParam(param)
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
          for i,v in ipairs(headData) do
            for j,k in ipairs(l_5_0.select) do
              if k == v.hid then
                onSelect(i)
                curSelect[#curSelect + 1] = v.hid
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
                  if not headData[i].isUsed and #tmpSelect < condition.num then
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
          board:setScale(0.5)
          do
            local anim_arr = CCArray:create()
            anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
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
end

ui.create = function()
  local layer = (CCLayer:create())
  local hostId = nil
  img.load(img.packedOthers.ui_hero_forge_bg)
  img.load(img.packedOthers.ui_hero_forge)
  local bgg = img.createUISprite(img.ui.hero_forge_bg)
  bgg:setScale(view.minScale)
  bgg:setPosition(view.midX, view.midY)
  layer:addChild(bgg)
  local bg = CCSprite:create()
  bg:setContentSize(CCSizeMake(960, 576))
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
  local lefTitleBg = img.createUISprite(img.ui.hero_forge_titlebg)
  lefTitleBg:setScaleX(view.physical.w / lefTitleBg:getContentSize().width / view.minScale * 0.5)
  lefTitleBg:setAnchorPoint(ccp(1, 1))
  lefTitleBg:setPosition(480, 576)
  bg:addChild(lefTitleBg)
  local rigTitleBg = img.createUISprite(img.ui.hero_forge_titlebg)
  rigTitleBg:setScaleX(view.physical.w / rigTitleBg:getContentSize().width / view.minScale * 0.5)
  rigTitleBg:setAnchorPoint(ccp(0, 1))
  rigTitleBg:setFlipX(true)
  rigTitleBg:setPosition(480, 576)
  bg:addChild(rigTitleBg)
  local showTitle = lbl.createFont2(22, i18n.global.heroforge_title.string, ccc3(246, 214, 108))
  showTitle:setPosition(480, 560)
  bg:addChild(showTitle)
  autoLayoutShift(lefTitleBg, true, false, false, false)
  autoLayoutShift(rigTitleBg, true, false, false, false)
  autoLayoutShift(showTitle)
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = HHMenuItem:create(btnBackSprite)
  btnBack:setPosition(35, 546)
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  bg:addChild(menuBack, 1000)
  layer.back = btnBack
  btnBack:registerScriptTapHandler(function()
    audio.play(audio.button)
    replaceScene(require("ui.town.main").create())
   end)
  autoLayoutShift(btnBack)
  local btnDetailSprite = img.createUISprite(img.ui.fight_hurts)
  local btnDetail = SpineMenuItem:create(json.ui.button, btnDetailSprite)
  btnDetail:setPosition(408, 465)
  local menuDetail = CCMenu:createWithItem(btnDetail)
  menuDetail:setPosition(0, 0)
  bg:addChild(menuDetail)
  btnDetail:registerScriptTapHandler(function()
    audio.play(audio.button)
    if hostId then
      layer:addChild(require("ui.tips.hero").create(hostId), 1000)
    end
   end)
  btnDetail:setVisible(false)
  local btnInfoSprite = img.createUISprite(img.ui.btn_help)
  local btnInfo = SpineMenuItem:create(json.ui.button, btnInfoSprite)
  btnInfo:setPosition(930, 550)
  local menuInfo = CCMenu:createWithItem(btnInfo)
  menuInfo:setPosition(0, 0)
  bg:addChild(menuInfo, 100)
  btnInfo:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:addChild(require("ui.help").create(i18n.global.help_heroforge.string, i18n.global.help_title.string), 1000)
   end)
  autoLayoutShift(btnInfo)
  local rigAnim = json.create(json.ui.yingxiong_hecheng_animation_in)
  rigAnim:setPosition(480, 274)
  bg:addChild(rigAnim)
  local board = img.createUI9Sprite(img.ui.dialog_2)
  board:setPreferredSize(CCSize(425, 480))
  rigAnim:addChildFollowSlot("code_rightplane", board)
  rigAnim:playAnimation("animation")
  local avllab = lbl.createMixFont1(16, i18n.global.heroforge_available_hero.string, ccc3(111, 76, 56))
  avllab:setPosition(213, 454)
  board:addChild(avllab)
  local innerBg = img.createUI9Sprite(img.ui.hero_forge_inner)
  innerBg:setPreferredSize(CCSize(376, 354))
  innerBg:setPosition(213, 256)
  board:addChild(innerBg)
  local SCROLLVIEW_WIDTH = 357
  local SCROLLVIEW_HEIGHT = 332
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(ccp(0, 0))
  scroll:setPosition(10, 13)
  scroll:setViewSize(CCSize(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT))
  innerBg:addChild(scroll)
  local blackBatch, selectBatch = nil, nil
  local headIcons = {}
  local heroTable = {}
  local showAnim = {}
  local btnHero = {}
  local reddot = {}
  local defaultGroup = nil
  local showHeroLayer = CCLayer:create()
  bg:addChild(showHeroLayer)
  local anim = json.create(json.ui.yingxiong_hecheng)
  anim:setPosition(258, 222)
  anim:playAnimation("animation3")
  showHeroLayer:addChild(anim, 1000)
  local loadHero = function(l_4_0)
    btnDetail:setVisible(true)
    initHeros()
    getCondition(l_4_0)
    upvalue_1536 = l_4_0
    showHeroLayer:removeAllChildrenWithCleanup(true)
    blackBatch:removeAllChildrenWithCleanup(true)
    selectBatch:removeAllChildrenWithCleanup(true)
    upvalue_3584 = json.create(json.ui.yingxiong_hecheng)
    anim:setPosition(258, 222)
    anim:playAnimation("animation4", -1)
    showHeroLayer:addChild(anim, 1000)
    if layer.heroBody then
      layer.heroBody:removeFromParent()
      layer.heroBody = nil
    end
    local heroBody = json.createSpineHero(l_4_0)
    heroBody:setScale(0.7)
    heroBody:setVisible(false)
    layer:addChild(heroBody)
    layer.heroBody = heroBody
    local rdWidth = 512
    local rdHeight = 512
    local rdPosY = 100
    local render = cc.RenderTexture:create(rdWidth, rdHeight)
    render:setVisible(false)
    render:scheduleUpdateWithPriorityLua(function()
      render:beginWithClear(0, 0, 0, 0)
      heroBody:setVisible(true)
      heroBody:setPosition(rdWidth * 0.5, rdPosY - 8)
      heroBody:visit()
      heroBody:setVisible(false)
      render:endToLua()
      end, 0)
    local sprite = render:getSprite()
    sprite:setOpacityModifyRGB(true)
    local texture = sprite:getTexture()
    texture:setAntiAliasTexParameters()
    local newSprite = cc.Sprite:createWithTexture(texture)
    newSprite:setScaleY(-1)
    newSprite:setPosition(0, rdHeight * 0.5 - rdPosY)
    anim:addChildFollowSlot("code_hero", newSprite)
    heroBody:addChild(render)
    for i,v in ipairs(operData.condition) do
      do
        local btnSp = nil
        do
          btnSp = img.createHeroHead(v.id, nil, true, true)
          btnHero[i] = CCMenuItemSprite:create(btnSp, nil)
          btnHero[i]:setAnchorPoint(ccp(1, 0))
          if i == 1 then
            btnHero[i]:setPosition(175, 112)
          else
            btnHero[i]:setScale(0.8)
            btnHero[i]:setPosition(258 + (i - 2) * 83, 112)
          end
          local menuHero = CCMenu:createWithItem(btnHero[i])
          menuHero:setPosition(0, 0)
          showHeroLayer:addChild(menuHero)
          local showNum = lbl.createFont2(16, "0/" .. v.num)
          showNum:setPosition(btnHero[i]:boundingBox():getMidX(), 100)
          showHeroLayer:addChild(showNum)
          setShader(btnHero[i], SHADER_GRAY, true)
          showAnim[i] = json.create(json.ui.yingxiong_hecheng2)
          showAnim[i]:setPosition(btnHero[i]:boundingBox():getMidX(), btnHero[i]:boundingBox():getMidY())
          showAnim[i]:setScale(btnHero[i]:getScale())
          showHeroLayer:addChild(showAnim[i], 1001)
          reddot[i] = img.createUISprite(img.ui.main_red_dot)
          reddot[i]:setPosition(btnHero[i]:boundingBox():getMaxX() - 6, btnHero[i]:boundingBox():getMaxY() - 6)
          reddot[i]:setVisible(false)
          showHeroLayer:addChild(reddot[i])
          if v.num <= numforhero(v) then
            reddot[i]:setVisible(true)
          end
          local icon = img.createUISprite(img.ui.hero_equip_add)
          icon:setPosition(btnHero[i]:boundingBox():getMaxX() - 23, btnHero[i]:boundingBox():getMinY() + 23)
          showHeroLayer:addChild(icon)
          icon:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(0.5, 76.5), CCFadeTo:create(0.5, 255))))
          btnHero[i]:registerScriptTapHandler(function()
            local func = function()
              showNum:setString(#v.select .. "/" .. v.num)
              if #v.select < v.num then
                setShader(btnHero[i], SHADER_GRAY, true)
                showNum:setColor(ccc3(255, 255, 255))
              else
                clearShader(btnHero[i], true)
                showNum:setColor(ccc3(195, 255, 66))
              end
              for j,vv in ipairs(operData.condition) do
                if vv.num - #vv.select <= numforhero(vv) then
                  reddot[j]:setVisible(true)
                  for j,vv in (for generator) do
                  end
                  reddot[j]:setVisible(false)
                end
                 -- Warning: missing end command somewhere! Added here
              end
                  end
            layer:addChild(createSelectBoard(v, func), 1000)
               end)
        end
      end
    end
   end
  local onSelect = function(l_5_0)
    loadHero(heroTable[l_5_0].id)
    local blackBoard = img.createUISprite(img.ui.hero_head_shade)
    blackBoard:setScale(0.85106382978723)
    blackBoard:setOpacity(120)
    blackBoard:setPosition(headIcons[l_5_0]:getPositionX(), headIcons[l_5_0]:getPositionY())
    blackBatch:addChild(blackBoard, 0, l_5_0)
    local selectIcon = img.createUISprite(img.ui.hook_btn_sel)
    selectIcon:setPosition(headIcons[l_5_0]:getPositionX(), headIcons[l_5_0]:getPositionY())
    selectBatch:addChild(selectIcon, 0, l_5_0)
   end
  local herosCountMap = {}
  local herosGroupCountMap = {{}, {}, {}, {}, {}, {}}
  local initHerosCount = function()
    for _,v in ipairs(heros) do
      herosCountMap[v.id] = (herosCountMap[v.id] or 0) + 1
      if not herosGroupCountMap[4][cfghero[v.id].group] then
        herosGroupCountMap[4][cfghero[v.id].group] = (cfghero[v.id].qlt ~= 4 or v.id >= 5000 or 0) + 1
        for _,v in (for generator) do
          if not herosGroupCountMap[5][cfghero[v.id].group] then
            herosGroupCountMap[5][cfghero[v.id].group] = (cfghero[v.id].qlt ~= 5 or v.id < 5000 or 0) + 1
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  initHerosCount()
  local createHerolist = function()
    arrayclear(headIcons)
    arrayclear(heroTable)
    scroll:getContainer():removeAllChildrenWithCleanup(true)
    for _,v in pairs(cfghero) do
      if v.showInForge and v.showInForge == 1 and (not defaultGroup or v.group == defaultGroup) then
        heroTable[#heroTable + 1] = {id = _, qlt = v.qlt, group = v.group}
      end
    end
    for i = 1, #heroTable do
      for j = i + 1, #heroTable do
        if heroTable[i].qlt < heroTable[j].qlt then
          heroTable[i], heroTable[j] = heroTable[j], heroTable[i]
        end
      end
    end
    local SCROLLCONTENT_HEIGHT = math.ceil(#heroTable / 4) * 84 + 10
    scroll:setContentSize(CCSizeMake(SCROLLVIEW_WIDTH, SCROLLCONTENT_HEIGHT))
    scroll:setContentOffset(ccp(0, SCROLLVIEW_HEIGHT - SCROLLCONTENT_HEIGHT))
    local iconBgBatch = img.createBatchNodeForUI(img.ui.herolist_head_bg)
    scroll:getContainer():addChild(iconBgBatch, 1)
    local groupBgBatch = img.createBatchNodeForUI(img.ui.herolist_group_bg)
    scroll:getContainer():addChild(groupBgBatch, 3)
    local starBatch = img.createBatchNodeForUI(img.ui.star_s)
    scroll:getContainer():addChild(starBatch, 3)
    local star1Batch = img.createBatchNodeForUI(img.ui.hero_star_orange)
    scroll:getContainer():addChild(star1Batch, 3)
    upvalue_4096 = img.createBatchNodeForUI(img.ui.hero_head_shade)
    scroll:getContainer():addChild(blackBatch, 4)
    upvalue_4608 = img.createBatchNodeForUI(img.ui.hook_btn_sel)
    scroll:getContainer():addChild(selectBatch, 5)
    for i,v in ipairs(heroTable) do
      local x, y = 53 + (i - 1) % 4 * 84, SCROLLCONTENT_HEIGHT - math.ceil(i / 4) * 84 + 30
      local heroBg = img.createUISprite(img.ui.herolist_head_bg)
      heroBg:setScale(0.8)
      heroBg:setPosition(x, y)
      iconBgBatch:addChild(heroBg)
      local headIcon = img.createHeroHeadIcon(v.id)
      headIcons[i] = headIcon
      headIcons[i]:setScale(0.8)
      headIcons[i]:setPosition(x, y)
      scroll:getContainer():addChild(headIcons[i], 2)
      local groupBg = img.createUISprite(img.ui.herolist_group_bg)
      groupBg:setScale(0.336)
      groupBg:setPosition(x - 24, y + 24)
      groupBgBatch:addChild(groupBg)
      local groupIcon = img.createUISprite(img.ui.herolist_group_" .. v.grou)
      groupIcon:setScale(0.336)
      groupIcon:setPosition(x - 24, y + 25)
      scroll:getContainer():addChild(groupIcon, 3)
      local qlt = v.qlt
      if qlt <= 5 then
        for i = qlt, 1, -1 do
          local star = img.createUISprite(img.ui.star_s)
          star:setScale(0.8)
          star:setPosition(x + (i - (qlt + 1) / 2) * 12 * 0.8, y - 26)
          starBatch:addChild(star)
        end
      elseif qlt == 6 then
        local star = img.createUISprite(img.ui.hero_star_orange)
        star:setScale(0.6)
        star:setPosition(x, y - 24)
        star1Batch:addChild(star)
      end
      if hostId and v.id == hostId then
        onSelect(i)
      end
      getCondition(v.id)
      local redDotFlag = true
      for _,cv in ipairs(operData.condition) do
        do
          if not herosCountMap[cv.id] then
            local count = not cfghero[cv.id] or 0
          end
          if count < cv.num then
            redDotFlag = false
          end
          herosCountMap[cv.id] = (herosCountMap[cv.id] or 0) - cv.num
          herosGroupCountMap[cfghero[cv.id].qlt][cfghero[cv.id].group] = (herosGroupCountMap[cfghero[cv.id].qlt][cfghero[cv.id].group] or 0) - cv.num
        end
        for _,cv in (for generator) do
          if cv.id % 100 == 99 then
            local qlt = math.floor(cv.id / 1000)
            local group = (cv.id - 99 - qlt * 1000) / 100
            if herosGroupCountMap[qlt][group] or 0 < cv.num then
              redDotFlag = false
            end
            herosGroupCountMap[qlt][group] = (herosGroupCountMap[qlt][group] or 0) - cv.num
          end
        end
        if redDotFlag then
          local icon = img.createUISprite(img.ui.main_red_dot)
          headIcon:addChild(icon, 100)
          icon:setPosition(headIcon:getContentSize().width, headIcon:getContentSize().height)
        end
        for _,cv in ipairs(operData.condition) do
          if not herosCountMap[cv.id] then
            herosCountMap[cv.id] = (not cfghero[cv.id] or 0) + cv.num
            herosGroupCountMap[cfghero[cv.id].qlt][cfghero[cv.id].group] = (herosGroupCountMap[cfghero[cv.id].qlt][cfghero[cv.id].group] or 0) + cv.num
            for _,cv in (for generator) do
              if cv.id % 100 == 99 then
                local qlt = math.floor(cv.id / 1000)
                local group = (cv.id - 99 - qlt * 1000) / 100
                herosGroupCountMap[qlt][group] = (herosGroupCountMap[qlt][group] or 0) + cv.num
              end
            end
          end
          if hostId then
            loadHero(hostId)
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
   end
  local btnGroup = {}
  for i = 1, 6 do
    do
      local btnGroupSp = img.createUISprite(img.ui.devour_circle_bg)
      local starIcon = img.createUISprite(img.ui.herolist_group_" .. )
      starIcon:setPosition(btnGroupSp:getContentSize().width / 2, btnGroupSp:getContentSize().height / 2 + 2)
      starIcon:setScale(0.74)
      btnGroupSp:addChild(starIcon)
      btnGroup[i] = CCMenuItemSprite:create(btnGroupSp, nil)
      local menuGroup = CCMenu:createWithItem(btnGroup[i])
      menuGroup:setPosition(0, 0)
      board:addChild(menuGroup)
      btnGroup[i]:setPosition(38 + 50 * i, 46)
      btnGroup[i].select = img.createUISprite(img.ui.bag_dianji)
      btnGroup[i].select:setPosition(btnGroup[i]:getContentSize().width / 2, btnGroup[i]:getContentSize().height / 2 + 2)
      btnGroup[i]:addChild(btnGroup[i].select)
      btnGroup[i].select:setVisible(false)
      btnGroup[i]:registerScriptTapHandler(function()
        defaultGroup = i
        for j = 1, 6 do
          btnGroup[j].select:setVisible(false)
        end
        btnGroup[defaultGroup].select:setVisible(true)
        createHerolist()
         end)
    end
  end
  defaultGroup = 1
  btnGroup[1].select:setVisible(true)
  createHerolist()
  local lasty = nil
  local onTouchBegin = function(l_9_0, l_9_1)
    lasty = l_9_1
    return true
   end
  local onTouchMoved = function(l_10_0, l_10_1)
    return true
   end
  local onTouchEnd = function(l_11_0, l_11_1)
    if math.abs(l_11_1 - lasty) > 10 then
      return 
    end
    local pointOnScroll = scroll:getContainer():convertToNodeSpace(ccp(l_11_0, l_11_1))
    for i,v in ipairs(headIcons) do
      if v:boundingBox():containsPoint(pointOnScroll) then
        onSelect(i)
      end
    end
    return true
   end
  local onTouch = function(l_12_0, l_12_1, l_12_2)
    if l_12_0 == "began" then
      return onTouchBegin(l_12_1, l_12_2)
    elseif l_12_0 == "moved" then
      return onTouchMoved(l_12_1, l_12_2)
    else
      return onTouchEnd(l_12_1, l_12_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  local btnForgeSp = img.createLogin9Sprite(img.login.button_9_gold)
  btnForgeSp:setPreferredSize(CCSize(155, 55))
  local labForge = lbl.createFont1(20, i18n.global.heroforge_btn_text.string, ccc3(106, 61, 37))
  labForge:setPosition(btnForgeSp:getContentSize().width / 2, btnForgeSp:getContentSize().height / 2)
  btnForgeSp:addChild(labForge)
  local btnForge = SpineMenuItem:create(json.ui.button, btnForgeSp)
  btnForge:setPosition(253, 52)
  local menuForge = CCMenu:createWithItem(btnForge)
  menuForge:setPosition(0, 0)
  bg:addChild(menuForge)
  btnForge:registerScriptTapHandler(function()
    local hids = {}
    if not operData.condition then
      return 
    end
    for i,v in ipairs(operData.condition) do
      if v.num <= #v.select then
        for j,k in ipairs(v.select) do
          hids[#hids + 1] = k
        end
        for i,v in (for generator) do
        end
        return 
      end
      do
        local params = {sid = player.sid, id = hostId, hids = hids}
        addWaitNet()
        net:hero_mix(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        audio.play(audio.hero_forge)
        if l_1_0.status < 0 then
          showToast("status:" .. l_1_0.status)
          return 
        end
        local activityData = require("data.activity")
        local mactivityData = require("data.monthlyactivity")
        local IDS = activityData.IDS
        local mIDS = mactivityData.IDS
        local cfgmactivity = require("config.monthlyactivity")
        local mtmp_status = mactivityData.getStatusById(mIDS.FORGE_2.ID)
        if cfghero[l_1_0.hero.id].qlt == 5 then
          mtmp_status = mactivityData.getStatusById(mIDS.FORGE_1.ID)
        end
        mactivityData.addScore(mtmp_status.id)
        if cfghero[l_1_0.hero.id].qlt == 5 then
          local tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_1.ID)
          if cfghero[l_1_0.hero.id].group == 2 then
            tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_2.ID)
          end
          if cfghero[l_1_0.hero.id].group == 3 then
            tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_3.ID)
          end
          if cfghero[l_1_0.hero.id].group == 4 then
            tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_4.ID)
          end
          if cfghero[l_1_0.hero.id].group == 5 then
            tmp_status = activityData.getStatusById(IDS.HERO_SUMMON_5.ID)
          end
          if cfghero[l_1_0.hero.id].group == 6 then
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
        require("data.christmas").onGetHeroes({l_1_0.hero})
        heros.add(l_1_0.hero)
        local heroData = heros.find(l_1_0.hero.hid)
        local hostHero = heros.find(hids[1])
        heroData.equips = hostHero.equips
        local tmpHids = {}
        for i = 2, #hids do
          tmpHids[#tmpHids + 1] = hids[i]
        end
        local exp, evolve, rune = heros.decompose(tmpHids)
        bag.items.add({id = ITEM_ID_HERO_EXP, num = exp})
        bag.items.add({id = ITEM_ID_EVOLVE_EXP, num = evolve})
        do
          local reward = {items = {}, equips = {}}
          if exp > 0 then
            table.insert(reward.items, {id = ITEM_ID_HERO_EXP, num = exp})
          end
          if evolve > 0 then
            table.insert(reward.items, {id = ITEM_ID_EVOLVE_EXP, num = evolve})
          end
          for i,v in ipairs(hids) do
            if i == 1 then
              heros.del(v, true)
              for i,v in (for generator) do
              end
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
              anim:playAnimation("animation")
              for i = 1, #showAnim do
                showAnim[i]:playAnimation("animation")
              end
              showHeroLayer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1.5), CCCallFunc:create(function()
              layer:addChild(createBoardForRewards(heroData.hid, reward), 1002)
              loadHero(hostId)
              createHerolist()
                  end)))
              upvalue_7680 = {}
              upvalue_8192 = {}
              initHerosCount()
            end
             -- Warning: missing end command somewhere! Added here
          end
           -- Warning: missing end command somewhere! Added here
        end
         end)
      end
       -- Warning: missing end command somewhere! Added here
    end
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    replaceScene(require("ui.town.main").create())
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_17_0)
    if l_17_0 == "enter" then
      onEnter()
    elseif l_17_0 == "exit" then
      onExit()
    elseif l_17_0 == "cleanup" then
      img.unload(img.packedOthers.ui_hero_forge_bg)
      img.load(img.packedOthers.ui_hero_forge)
    end
   end)
  return layer
end

return ui


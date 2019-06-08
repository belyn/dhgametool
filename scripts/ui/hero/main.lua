-- Command line was: E:\github\dhgametool\scripts\ui\hero\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local cfgskill = require("config.skill")
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
local helper = (require("common.helper"))
local showBoardLayer, heroData = nil, nil
ui.create = function(l_1_0, l_1_1, l_1_2, l_1_3)
  local layer = CCLayer:create()
  local model = "Hero"
  heroData = heros.find(l_1_0)
  local createShare = function()
    local layer = CCLayer:create()
    local board = img.createUI9Sprite(img.ui.tips_bg)
    board:setPreferredSize(CCSize(358, 272))
    board:setScale(view.minScale)
    board:setPosition(scalep(480, 288))
    layer:addChild(board)
    local showText = lbl.createMix({font = 1, size = 16, text = i18n.global.hero_share_text.string, color = ccc3(255, 246, 223), width = 312, align = kCCTextAlignmentLeft})
    showText:setAnchorPoint(ccp(0, 1))
    showText:setPosition(24, 255)
    board:addChild(showText)
    local btnBg = img.createUI9Sprite(img.ui.smith_drop_bg)
    btnBg:setPreferredSize(CCSize(314, 168))
    btnBg:setPosition(179, 108)
    board:addChild(btnBg)
    local btnWorldChatSp = img.createLogin9Sprite(img.login.button_9_small_mwhite)
    btnWorldChatSp:setPreferredSize(CCSize(290, 68))
    local labWorldChat = lbl.createFont1(20, i18n.global.hero_btn_share_world.string, ccc3(118, 37, 5))
    labWorldChat:setPosition(btnWorldChatSp:getContentSize().width / 2, btnWorldChatSp:getContentSize().height / 2)
    btnWorldChatSp:addChild(labWorldChat)
    local btnWorldChat = SpineMenuItem:create(json.ui.button, btnWorldChatSp)
    btnWorldChat:setPosition(btnBg:getContentSize().width / 2, 122)
    local menuWorldChat = CCMenu:createWithItem(btnWorldChat)
    menuWorldChat:setPosition(0, 0)
    btnBg:addChild(menuWorldChat)
    local btnGuildChatSp = img.createLogin9Sprite(img.login.button_9_small_mwhite)
    btnGuildChatSp:setPreferredSize(CCSize(290, 68))
    local labGuildChat = lbl.createFont1(20, i18n.global.hero_btn_share_guild.string, ccc3(118, 37, 5))
    labGuildChat:setPosition(btnGuildChatSp:getContentSize().width / 2, btnGuildChatSp:getContentSize().height / 2)
    btnGuildChatSp:addChild(labGuildChat)
    local btnGuildChat = SpineMenuItem:create(json.ui.button, btnGuildChatSp)
    btnGuildChat:setPosition(btnBg:getContentSize().width / 2, 45)
    local menuGuildChat = CCMenu:createWithItem(btnGuildChat)
    menuGuildChat:setPosition(0, 0)
    btnBg:addChild(menuGuildChat)
    local onTouch = function(l_1_0, l_1_1, l_1_2)
      local point = layer:convertToNodeSpace(ccp(l_1_1, l_1_2))
      if not board:boundingBox():containsPoint(point) then
        layer:removeFromParentAndCleanup(true)
        return 
      end
      end
    layer:registerScriptTouchHandler(onTouch)
    layer:setTouchEnabled(true)
    local onShare = function(l_2_0)
      if l_2_0 and l_2_0 == 2 and (not player.gid or player.gid <= 0) then
        showToast(i18n.global.gboss_fight_st1.string)
        return 
      end
      local params = {sid = player.sid, hid = hid, type = l_2_0}
      net:chat(params, function(l_1_0)
         end)
      showToast(i18n.global.toast_share_success.string)
      layer:removeFromParentAndCleanup(true)
      end
    btnWorldChat:registerScriptTapHandler(function()
      onShare(1)
      end)
    btnGuildChat:registerScriptTapHandler(function()
      onShare(2)
      end)
    return layer
   end
  local createHeroLayer = function(l_2_0)
    local hlayer = CCLayer:create()
    hid = herolist[l_2_0].hid
    upvalue_1024 = heros.find(hid)
    local bgPlistName = img.packedOthers.ui_hero_bg" .. cfghero[heroData.id].grou
    img.load(bgPlistName)
    local bgg = img.createUISprite(img.ui.hero_bg" .. cfghero[heroData.id].grou)
    bgg:setScale(view.minScale)
    bgg:setPosition(view.midX, view.midY)
    hlayer:addChild(bgg)
    local bg = CCSprite:create()
    bg:setContentSize(CCSizeMake(960, 576))
    bg:setScale(view.minScale)
    bg:setPosition(view.midX, view.midY)
    hlayer:addChild(bg)
    json.load(json.ui.hero_bg" .. cfghero[heroData.id].grou)
    local anim = DHSkeletonAnimation:createWithKey(json.ui.hero_bg" .. cfghero[heroData.id].grou)
    anim:scheduleUpdateLua()
    anim:setPosition(480, 288)
    anim:playAnimation("animation", -1)
    bg:addChild(anim)
    if cfghero[heroData.id].group == 2 then
      local part = particle.create("hero_bg2_d")
      part:setPosition(480, 0)
      bg:addChild(part)
    else
      if cfghero[heroData.id].group == 3 then
        local part = particle.create("hero_bg3_d")
        part:setPosition(480, 0)
        bg:addChild(part)
        local part = particle.create("hero_bg3_2d")
        part:setPosition(480, 0)
        bg:addChild(part)
      else
        if cfghero[heroData.id].group == 5 then
          local part = particle.create("hero_bg5_d")
          part:setPosition(480, 0)
          bg:addChild(part)
          local part = particle.create("hero_bg5_u")
          part:setPosition(480, 576)
          bg:addChild(part)
        else
          if cfghero[heroData.id].group == 6 then
            local part = particle.create("hero_bg6_rd")
            part:setPosition(960, 0)
            bg:addChild(part)
            local part = particle.create("hero_bg6_2rd")
            part:setPosition(960, 0)
            bg:addChild(part)
          end
        end
      end
    end
    local heroBg = img.createUISprite(img.ui.hero_pedestal)
    heroBg:setAnchorPoint(ccp(0.5, 0))
    heroBg:setPosition(230, 38)
    bg:addChild(heroBg)
    local heroBody = nil
    if getHeroSkin(heroData.hid) then
      heroBody = json.createSpineHeroSkin(getHeroSkin(heroData.hid))
      heroBody:setScale(0.9)
      heroBody:setPosition(230, 160)
      bg:addChild(heroBody)
    else
      heroBody = json.createSpineHero(heroData.id)
      heroBody:setScale(0.9)
      heroBody:setPosition(230, 160)
      bg:addChild(heroBody)
    end
    local heroName = lbl.createFont2(20, i18n.hero[heroData.id].heroName)
    heroName:setPosition(230, 527)
    bg:addChild(heroName, 1)
    local showGroup = img.createUISprite(img.ui.herolist_group_" .. cfghero[heroData.id].grou)
    showGroup:setScale(0.68)
    showGroup:setPosition(heroName:boundingBox():getMinX() - 30, heroName:getPositionY() + 2)
    bg:addChild(showGroup, 1)
    local star = cfghero[heroData.id].maxStar
    local starlayer = nil
    local createstar = function()
      local starlayer1 = CCLayer:create()
      if star <= 5 then
        baseX = 245 - 15 * star
        for i = 1, star do
          local starIcon = img.createUISprite(img.ui.star)
          starIcon:setScale(0.64)
          starIcon:setPosition(baseX + 29 * (i - 1), 492)
          starlayer1:addChild(starIcon, 101)
        end
      else
        local redstar = 1
        if heroData.wake then
          redstar = heroData.wake + 1
        end
        baseX = 245 - 15 * (redstar)
        if redstar >= 6 then
          json.load(json.ui.lv10plus_hero)
          local star = DHSkeletonAnimation:createWithKey(json.ui.lv10plus_hero)
          star:scheduleUpdateLua()
          star:playAnimation("animation", -1)
          star:setPosition(230, 492)
          bg:addChild(star, 100)
          local energizeStarLab = lbl.createFont2(26, redstar - 5)
          energizeStarLab:setPosition(star:getContentSize().width / 2, 0)
          star:addChild(energizeStarLab)
          star:setScale(0.6)
        elseif redstar >= 5 then
          local starIcon2 = img.createUISprite(img.ui.hero_star_ten)
          starIcon2:setPosition(baseX + 58, 492)
          starlayer1:addChild(starIcon2, 101)
        else
          for i = 1, redstar do
            local starIcon = img.createUISprite(img.ui.hero_star_orange)
            starIcon:setPosition(baseX + 29 * (i - 1), 492)
            starlayer1:addChild(starIcon, 101)
          end
        end
      end
      return starlayer1
      end
    local callfuncSkin = function(l_2_0, l_2_1, l_2_2)
      if heroBody then
        if l_2_1 then
          heroBody:removeFromParentAndCleanup()
          heroBody = nil
          heroBody = json.createSpineHeroSkin(cfghero[l_2_0].skinId[l_2_2])
          heroBody:setScale(0.9)
          heroBody:setPosition(230, 160)
          bg:addChild(heroBody)
        else
          heroBody:removeFromParentAndCleanup()
          heroBody = nil
          heroBody = json.createSpineHero(l_2_0)
          heroBody:setScale(0.9)
          heroBody:setPosition(230, 160)
          bg:addChild(heroBody)
        end
      end
      end
    local callfuncstar = function(l_3_0)
      for j,v in ipairs(l_3_0) do
        for jj,k in ipairs(herolist) do
          if k.hid == v then
            table.remove(herolist, jj)
            for j,v in (for generator) do
            end
          end
        end
        if starlayer then
          starlayer:removeAllChildrenWithCleanup()
          upvalue_512 = nil
          upvalue_512 = createstar()
          bg:addChild(starlayer, 101)
        end
        if heroBody then
          json.load(json.ui.bianshen)
          local aniBianshen = DHSkeletonAnimation:createWithKey(json.ui.bianshen)
          aniBianshen:scheduleUpdateLua()
          aniBianshen:playAnimation("animation")
          aniBianshen:setPosition(480, 288)
          bg:addChild(aniBianshen, 100)
          aniBianshen:registerLuaHandler(function(l_1_0)
            if l_1_0 == "fx" then
              heroBody:removeFromParentAndCleanup()
              heroBody = nil
              if getHeroSkin(heroData.hid) then
                heroBody = json.createSpineHeroSkin(getHeroSkin(heroData.hid))
                heroBody:setScale(0.9)
                heroBody:setPosition(230, 160)
                bg:addChild(heroBody)
              else
                heroBody = json.createSpineHero(heroData.id)
                heroBody:setScale(0.9)
                heroBody:setPosition(230, 160)
                bg:addChild(heroBody)
              end
            end
               end)
        end
         -- Warning: missing end command somewhere! Added here
      end
      end
    starlayer = createstar()
    bg:addChild(starlayer, 101)
    upvalue_5632 = CCLayer:create()
    bg:addChild(showBoardLayer, 1001)
    local btnLockSp = img.createUISprite(img.ui.hero_unlock)
    local btnLock = SpineMenuItem:create(json.ui.button, btnLockSp)
    local menuLock = CCMenu:createWithItem(btnLock)
    menuLock:setPosition(0, 0)
    btnLock:setPosition(415, 512)
    bg:addChild(menuLock, 1002)
    local btnUnlockSp = img.createUISprite(img.ui.hero_lock)
    local btnUnlock = SpineMenuItem:create(json.ui.button, btnUnlockSp)
    local menuUnlock = CCMenu:createWithItem(btnUnlock)
    menuUnlock:setPosition(0, 0)
    btnUnlock:setPosition(415, 512)
    bg:addChild(menuUnlock, 1002)
    if heroData.flag and bit.band(heroData.flag, 2) ~= 0 then
      btnLock:setVisible(false)
    else
      btnUnlock:setVisible(false)
    end
    btnLock:registerScriptTapHandler(function()
      local params = {sid = player.sid, hid = heroData.hid, lock = 1}
      addWaitNet()
      net:hero_lock(params, function(l_1_0)
        delWaitNet()
        if l_1_0.status < 0 then
          showToast("server status:" .. l_1_0.status)
          return 
        end
        if not heroData.flag then
          heroData.flag = 0
        end
        heroData.flag = heroData.flag + 2
        btnLock:setVisible(false)
        btnUnlock:setVisible(true)
         end)
      end)
    btnUnlock:registerScriptTapHandler(function()
      local params = {sid = player.sid, hid = heroData.hid, lock = 2}
      tbl2string(params)
      addWaitNet()
      net:hero_lock(params, function(l_1_0)
        delWaitNet()
        if l_1_0.status < 0 then
          showToast("server status:" .. l_1_0.status)
          return 
        end
        heroData.flag = heroData.flag - 2
        btnLock:setVisible(true)
        btnUnlock:setVisible(false)
         end)
      end)
    local btnShareSprite = img.createUISprite(img.ui.hero_btn_share)
    local btnShare = SpineMenuItem:create(json.ui.button, btnShareSprite)
    btnShare:setPosition(415, 441)
    local menuShare = CCMenu:createWithItem(btnShare)
    menuShare:setPosition(0, 0)
    bg:addChild(menuShare, 1002)
    btnShare:registerScriptTapHandler(function()
      if player.lv() < 15 then
        showToast(string.format(i18n.global.func_need_lv.string, 15))
        return 
      end
      layer:addChild(createShare(), 1000)
      audio.play(audio.button)
      end)
    local btnHeroSprite0 = img.createUISprite(img.ui.hero_btn_info_nselect)
    local btnHeroSprite1 = img.createUISprite(img.ui.hero_btn_info_select)
    local btnHero = CCMenuItemSprite:create(btnHeroSprite0, btnHeroSprite1, btnHeroSprite0)
    local btnHeroMenu = CCMenu:createWithItem(btnHero)
    btnHero:setAnchorPoint(ccp(0, 0))
    btnHero:setPosition(879, 357)
    btnHeroMenu:setPosition(0, 0)
    bg:addChild(btnHeroMenu, 1002)
    local btnEquipSprite0 = img.createUISprite(img.ui.hero_btn_equip_nselect)
    local btnEquipSprite1 = img.createUISprite(img.ui.hero_btn_equip_select)
    local btnEquip = CCMenuItemSprite:create(btnEquipSprite0, btnEquipSprite1, btnEquipSprite0)
    local btnEquipMenu = CCMenu:createWithItem(btnEquip)
    btnEquip:setAnchorPoint(ccp(0, 0))
    btnEquip:setPosition(879, 265)
    btnEquipMenu:setPosition(0, 0)
    bg:addChild(btnEquipMenu, 1002)
    local btnUpstarSprite0 = img.createUISprite(img.ui.hero_btn_up_nselect)
    local btnUpstarSprite1 = img.createUISprite(img.ui.hero_btn_up_select)
    local btnUpstar = CCMenuItemSprite:create(btnUpstarSprite0, btnUpstarSprite1, btnUpstarSprite0)
    local btnUpstarMenu = CCMenu:createWithItem(btnUpstar)
    btnUpstar:setPosition(879, 173)
    btnUpstar:setAnchorPoint(ccp(0, 0))
    btnUpstarMenu:setPosition(0, 0)
    bg:addChild(btnUpstarMenu, 1002)
    local btnSkinSprite0 = img.createUISprite(img.ui.hero_btn_skin_nselect)
    local btnSkinSprite1 = img.createUISprite(img.ui.hero_btn_skin_select)
    local btnSkin = CCMenuItemSprite:create(btnSkinSprite0, btnSkinSprite1, btnSkinSprite0)
    local btnSkinMenu = CCMenu:createWithItem(btnSkin)
    btnSkin:setPosition(879, 81)
    btnSkin:setAnchorPoint(ccp(0, 0))
    btnSkinMenu:setPosition(0, 0)
    bg:addChild(btnSkinMenu, 1002)
    btnSkin:setVisible(false)
    if cfghero[heroData.id].skinId then
      btnSkin:setVisible(true)
    end
    if star < 6 then
      btnUpstar:setVisible(false)
      btnSkin:setPosition(879, 173)
    end
    local coinBg = img.createUI9Sprite(img.ui.main_coin_bg)
    coinBg:setPreferredSize(CCSizeMake(174, 40))
    coinBg:setAnchorPoint(CCPoint(1, 0.5))
    coinBg:setPosition(CCPoint(677, 540))
    bg:addChild(coinBg)
    local coinAll = img.createItemIcon2(ITEM_ID_COIN)
    coinAll:setPosition(12, 24)
    coinBg:addChild(coinAll)
    local showCoinAll = lbl.createFont2(16, "", ccc3(255, 247, 229))
    showCoinAll:setPosition(coinBg:getContentSize().width / 2 + 5, coinBg:getContentSize().height / 2 + 2)
    coinBg:addChild(showCoinAll)
    local expBg = img.createUI9Sprite(img.ui.main_coin_bg)
    expBg:setPreferredSize(CCSizeMake(174, 40))
    expBg:setAnchorPoint(CCPoint(0, 0.5))
    expBg:setPosition(CCPoint(684, 540))
    bg:addChild(expBg, 1000)
    local expAll = img.createItemIcon(ITEM_ID_HERO_EXP)
    expAll:setScale(0.5)
    expAll:setPosition(12, 23)
    expBg:addChild(expAll)
    local showExpAll = lbl.createFont2(16, "", ccc3(255, 247, 229))
    showExpAll:setPosition(expBg:getContentSize().width / 2 + 5, expBg:getContentSize().height / 2 + 2)
    expBg:addChild(showExpAll)
    if model == "Hero" then
      btnHero:selected()
      showBoardLayer:addChild(require("ui.hero.info").create(heroData, layer))
    elseif model == "Equip" then
      btnEquip:selected()
      showBoardLayer:addChild(require("ui.hero.equip").create(heroData, layer))
    elseif model == "Skin" then
      if getHeroSkin(heroData.hid) then
        btnSkin:selected()
        showBoardLayer:addChild(require("ui.hero.skin").create(heroData, callfuncSkin, layer))
      else
        btnHero:selected()
        showBoardLayer:addChild(require("ui.hero.info").create(heroData, layer))
        upvalue_8704 = "Hero"
      end
    elseif star < 6 or heroData.star < cfghero[heroData.id].qlt then
      btnHero:selected()
      showBoardLayer:addChild(require("ui.hero.info").create(heroData, layer))
      upvalue_8704 = "Hero"
    else
      if cfghero[heroData.id].noWake == 1 then
        btnHero:selected()
        showBoardLayer:addChild(require("ui.hero.info").create(heroData, layer))
        upvalue_8704 = "Hero"
      else
        btnUpstar:selected()
        showBoardLayer:addChild(require("ui.hero.uphero").create(heroData, callfuncstar, layer))
      end
    end
  end
  btnHero:registerScriptTapHandler(function()
    if model ~= "Hero" then
      btnHero:setEnabled(false)
      btnUpstar:setEnabled(true)
      btnEquip:setEnabled(true)
      btnSkin:setEnabled(true)
      audio.play(audio.button)
      btnHero:selected()
      btnEquip:unselected()
      btnUpstar:unselected()
      btnSkin:unselected()
      if showBoardLayer and not tolua.isnull(showBoardLayer) then
        showBoardLayer:removeAllChildrenWithCleanup(true)
        showBoardLayer:addChild(require("ui.hero.info").create(heroData, layer))
      end
      model = "Hero"
    end
   end)
  btnEquip:registerScriptTapHandler(function()
    if model ~= "Equip" then
      btnHero:setEnabled(true)
      btnEquip:setEnabled(false)
      btnUpstar:setEnabled(true)
      btnSkin:setEnabled(true)
      audio.play(audio.button)
      btnHero:unselected()
      btnUpstar:unselected()
      btnEquip:selected()
      btnSkin:unselected()
      if showBoardLayer and not tolua.isnull(showBoardLayer) then
        showBoardLayer:removeAllChildrenWithCleanup(true)
        showBoardLayer:addChild(require("ui.hero.equip").create(heroData, layer))
      end
      model = "Equip"
    end
   end)
  btnUpstar:registerScriptTapHandler(function()
    tbl2string(heroData)
    if cfghero[heroData.id].noWake == 1 then
      showToast(i18n.global.toast_terhero_noop.string)
      return 
    end
    if heroData.star < cfghero[heroData.id].qlt then
      showToast(i18n.global.hero_wake_no_star.string)
      return 
    end
    if model ~= "Upstar" then
      btnHero:setEnabled(true)
      btnEquip:setEnabled(true)
      btnUpstar:setEnabled(false)
      btnSkin:setEnabled(true)
      btnHero:unselected()
      btnEquip:unselected()
      btnUpstar:selected()
      btnSkin:unselected()
      if showBoardLayer and not tolua.isnull(showBoardLayer) then
        showBoardLayer:removeAllChildrenWithCleanup(true)
        showBoardLayer:addChild(require("ui.hero.uphero").create(heroData, callfuncstar, layer))
      end
      upvalue_1536 = "Upstar"
    end
   end)
  btnSkin:registerScriptTapHandler(function()
    if model ~= "Skin" then
      btnHero:setEnabled(true)
      btnEquip:setEnabled(true)
      btnUpstar:setEnabled(true)
      btnSkin:setEnabled(false)
      btnHero:unselected()
      btnEquip:unselected()
      btnUpstar:unselected()
      btnSkin:selected()
      if showBoardLayer and not tolua.isnull(showBoardLayer) then
        showBoardLayer:removeAllChildrenWithCleanup(true)
        showBoardLayer:addChild(require("ui.hero.skin").create(heroData, callfuncSkin, layer))
      end
      model = "Skin"
    end
   end)
  local heroBodySp = CCSprite:create()
  heroBodySp:setContentSize(CCSize(270, 310))
  local btnHeroBodySp = HHMenuItem:createWithScale(heroBodySp, 1)
  btnHeroBodySp:setPosition(230, 310)
  local menuHeroBodySp = CCMenu:createWithItem(btnHeroBodySp)
  menuHeroBodySp:setPosition(0, 0)
  bg:addChild(menuHeroBodySp, 1002)
  btnHeroBodySp:registerScriptTapHandler(function()
    if cfghero[heroData.id].words then
      audio.playHeroTalk(cfghero[heroData.id].words)
    end
    heroBody:playAnimation("attack")
    heroBody:appendNextAnimation("stand", -1)
   end)
  hlayer:setTouchEnabled(true)
  hlayer:scheduleUpdateWithPriorityLua(function()
    local exp = 0
    local coin = 0
    if bag.items.find(ITEM_ID_HERO_EXP) then
      exp = bag.items.find(ITEM_ID_HERO_EXP).num
    end
    if bag.items.find(ITEM_ID_COIN) then
      coin = bag.items.find(ITEM_ID_COIN).num
    end
    showCoinAll:setString(num2KM(coin))
    showExpAll:setString(num2KM(exp))
   end)
  return hlayer
   end
  local herolayer = createHeroLayer(l_1_3)
  layer:addChild(herolayer)
  if l_1_2 then
    local leftraw = img.createUISprite(img.ui.hero_raw)
    do
      local btnLeftraw = SpineMenuItem:create(json.ui.button, leftraw)
      btnLeftraw:setScale(view.minScale)
      btnLeftraw:setPosition(scalep(36, 286))
      local menuLeftraw = CCMenu:createWithItem(btnLeftraw)
      menuLeftraw:setPosition(0, 0)
      layer:addChild(menuLeftraw, 1)
      if l_1_3 <= 1 then
        setShader(btnLeftraw, SHADER_GRAY, true)
        btnLeftraw:setEnabled(false)
      end
      local rightraw = img.createUISprite(img.ui.hero_raw)
      rightraw:setFlipX(true)
      local btnRightraw = SpineMenuItem:create(json.ui.button, rightraw)
      btnRightraw:setScale(view.minScale)
      btnRightraw:setPosition(scalep(428, 286))
      local menuRightraw = CCMenu:createWithItem(btnRightraw)
      menuRightraw:setPosition(0, 0)
      layer:addChild(menuRightraw, 1)
      if  l_1_2 <= l_1_3 then
        setShader(btnRightraw, SHADER_GRAY, true)
        btnRightraw:setEnabled(false)
      end
      btnLeftraw:registerScriptTapHandler(function()
        audio.play(audio.button)
        if pos <= 1 then
          return 
        end
        upvalue_512 = pos - 1
        if pos <= 1 then
          setShader(btnLeftraw, SHADER_GRAY, true)
          btnLeftraw:setEnabled(false)
        end
        if pos ==  herolist - 1 then
          clearShader(btnRightraw, true)
          btnRightraw:setEnabled(true)
        end
        herolayer:removeFromParentAndCleanup(true)
        if helper.isLowMem() then
          json.unloadUnit(cfghero[heroData.id].heroBody)
        end
        if cfghero[heroData.id].anims then
          for i = 1,  cfghero[heroData.id].anims do
            local jsonname = "spinejson/unit/" .. cfghero[heroData.id].anims[i] .. ".json"
            json.unload(jsonname)
          end
        end
        upvalue_2560 = createHeroLayer(pos)
        layer:addChild(herolayer)
         end)
      btnRightraw:registerScriptTapHandler(function()
        audio.play(audio.button)
        if  herolist <= pos then
          return 
        end
        upvalue_512 = pos + 1
        if  herolist <= pos then
          setShader(btnRightraw, SHADER_GRAY, true)
          btnRightraw:setEnabled(false)
        end
        if pos == 2 then
          clearShader(btnLeftraw, true)
          btnLeftraw:setEnabled(true)
        end
        herolayer:removeFromParentAndCleanup(true)
        if helper.isLowMem() then
          json.unloadUnit(cfghero[heroData.id].heroBody)
        end
        if cfghero[heroData.id].anims then
          for i = 1,  cfghero[heroData.id].anims do
            local jsonname = "spinejson/unit/" .. cfghero[heroData.id].anims[i] .. ".json"
            json.unload(jsonname)
          end
        end
        upvalue_2560 = createHeroLayer(pos)
        layer:addChild(herolayer)
         end)
    end
  end
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = SpineMenuItem:create(json.ui.button, btnBackSprite)
  btnBack:setScale(view.minScale)
  btnBack:setPosition(scalep(35, 546))
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  layer:addChild(menuBack, 500)
  layer.back = btnBack
  btnBack:registerScriptTapHandler(function()
    audio.stopAllEffects()
    audio.play(audio.button)
    layer:getParent().needFresh = true
    layer:removeFromParentAndCleanup(true)
   end)
  autoLayoutShift(btnBack)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    layer:getParent().needFresh = true
    layer:removeFromParentAndCleanup(true)
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
    img.load(img.packedOthers.spine_ui_baoshihecheng)
    img.load(img.packedOthers.spine_ui_yingxiongmianban)
   end
  local onExit = function()
    img.unload(img.packedOthers.spine_ui_baoshihecheng)
    img.unload(img.packedOthers.spine_ui_yingxiongmianban)
    if helper.isLowMem() then
      json.unloadUnit(cfghero[heroData.id].heroBody)
    end
    if cfghero[heroData.id].anims then
      for i = 1,  cfghero[heroData.id].anims do
        local jsonname = "spinejson/unit/" .. cfghero[heroData.id].anims[i] .. ".json"
        json.unload(jsonname)
      end
    end
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_9_0)
    if l_9_0 == "enter" then
      onEnter()
    elseif l_9_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui


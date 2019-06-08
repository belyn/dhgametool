-- Command line was: E:\github\dhgametool\scripts\ui\friends\main.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local particle = require("res.particle")
local i18n = require("res.i18n")
local net = require("net.netClient")
local player = require("data.player")
local bag = require("data.bag")
local friend = require("data.friend")
local friendboss = require("data.friendboss")
local cfgfriendstage = require("config.friendstage")
local cfgmonster = require("config.monster")
local reward = require("ui.reward")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local selecthero = require("ui.selecthero.main")
local TAB = {LIST = 1, FIND = 2, APPL = 3, NPC = 4}
local currentTab = TAB.LIST
local titles = {TAB.LIST = i18n.global.friend_friend_list.global, TAB.FIND = i18n.global.friend_friend_apply.global, TAB.APPL = i18n.global.friend_apply_list.global, TAB.NPC = i18n.global.friend_apply_list.global}
local frdBoss = {}
local createPopupPieceBatchSummonResult = function(l_1_0, l_1_1, l_1_2)
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
  if l_1_0 == "item" then
    local item = img.createItem(l_1_1, l_1_2)
    itemBtn = SpineMenuItem:create(json.ui.button, item)
    itemBtn:setScale(0.85)
    itemBtn:setPosition(dialog.board:getContentSize().width / 2, 185)
    local iconMenu = CCMenu:createWithItem(itemBtn)
    iconMenu:setPosition(0, 0)
    dialog.board:addChild(iconMenu)
    itemBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if dialog.board.tipsTag == false then
        dialog.board.tipsTag = true
        tips = tipsitem.createForShow({id = id, num = count})
        dialog:addChild(tips, 200)
        tips.setClickBlankHandler(function()
          tips:removeFromParent()
          dialog.board.tipsTag = false
            end)
      end
      end)
  else
    local equip = img.createEquip(l_1_1, l_1_2)
    equipBtn = SpineMenuItem:create(json.ui.button, equip)
    equipBtn:setScale(0.85)
    equipBtn:setPosition(dialog.board:getContentSize().width / 2, 185)
    local iconMenu = CCMenu:createWithItem(equipBtn)
    iconMenu:setPosition(0, 0)
    dialog.board:addChild(iconMenu)
    equipBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if dialog.board.tipsTag == false then
        dialog.board.tipsTag = true
        tips = tipsequip.createForShow({id = id})
        dialog:addChild(tips, 200)
        tips.setClickBlankHandler(function()
          tips:removeFromParent()
          dialog.board.tipsTag = false
            end)
      end
      end)
  end
  backBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    dialog:removeFromParentAndCleanup()
   end)
  return dialog
end

ui.create = function(l_2_0)
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local borders = {}
  local icons = {}
  local LIMIT_FRIEND = 30
  local showFriends = nil
  currentTab = TAB.LIST
  if l_2_0 and l_2_0.from_layer == "frdboss_self" then
    currentTab = TAB.NPC
  end
  local board_w = 682
  local board_h = 515
  local board = img.createUI9Sprite(img.ui.dialog_1)
  board:setPreferredSize(CCSizeMake(board_w, board_h))
  board:setScale(view.minScale)
  board:setPosition(view.physical.w / 2, view.physical.h / 2)
  layer:addChild(board)
  board:setScale(0.5 * view.minScale)
  board:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  local bottom = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  bottom:setPreferredSize(CCSizeMake(636, 422))
  bottom:setAnchorPoint(0, 0)
  bottom:setPosition(CCPoint(23, 29))
  board:addChild(bottom)
  local listTab0 = img.createUISprite(img.ui.friends_tab_list_0)
  local listTab1 = img.createUISprite(img.ui.friends_tab_list_1)
  local listTab = CCMenuItemSprite:create(listTab0, nil, listTab1)
  listTab:setAnchorPoint(0, 0)
  listTab:setPosition(CCPoint(655, 329))
  listTab:setEnabled(currentTab ~= TAB.LIST)
  local listMenu = CCMenu:createWithItem(listTab)
  listMenu:setPosition(0, 0)
  board:addChild(listMenu, 3)
  local findTab0 = img.createUISprite(img.ui.friends_tab_query_0)
  local findTab1 = img.createUISprite(img.ui.friends_tab_query_1)
  local findTab = CCMenuItemSprite:create(findTab0, nil, findTab1)
  findTab:setAnchorPoint(0, 0)
  findTab:setPosition(CCPoint(655, 237))
  findTab:setEnabled(currentTab ~= TAB.FIND)
  local findMenu = CCMenu:createWithItem(findTab)
  findMenu:setPosition(0, 0)
  board:addChild(findMenu, 3)
  local applyTab0 = img.createUISprite(img.ui.friends_tab_req_0)
  local applyTab1 = img.createUISprite(img.ui.friends_tab_req_1)
  local applyTab = CCMenuItemSprite:create(applyTab0, nil, applyTab1)
  applyTab:setAnchorPoint(0, 0)
  applyTab:setPosition(CCPoint(655, 145))
  applyTab:setEnabled(currentTab ~= TAB.APPL)
  local applyMenu = CCMenu:createWithItem(applyTab)
  applyMenu:setPosition(0, 0)
  board:addChild(applyMenu, 3)
  local inputBg = img.createUI9Sprite(img.ui.input_box)
  local inputFind = CCEditBox:create(CCSizeMake(350 * view.minScale, 38 * view.minScale), inputBg)
  inputFind:setInputFlag(kEditBoxInputFlagInitialCapsSentence)
  inputFind:setReturnType(kKeyboardReturnTypeDone)
  inputFind:setMaxLength(50)
  inputFind:setFont("", 16 * view.minScale)
  inputFind:setPlaceHolder(i18n.global.friend_find_id.string)
  inputFind:setFontColor(ccc3(128, 124, 112))
  inputFind:setFontSize(20)
  inputFind:setAnchorPoint(0, 0)
  inputFind:setPosition(scalep(217, 420))
  layer:addChild(inputFind)
  local npcTab0 = img.createUISprite(img.ui.friends_tab_help_0)
  local npcTab1 = img.createUISprite(img.ui.friends_tab_help_1)
  local npcTab = CCMenuItemSprite:create(npcTab0, nil, npcTab1)
  npcTab:setAnchorPoint(0, 0)
  npcTab:setPosition(CCPoint(655, 53))
  npcTab:setEnabled(currentTab ~= TAB.NPC)
  addRedDot(npcTab, {px = npcTab:getContentSize().width - 15, py = npcTab:getContentSize().height - 15})
  delRedDot(npcTab)
  local npcMenu = CCMenu:createWithItem(npcTab)
  npcMenu:setPosition(0, 0)
  board:addChild(npcMenu, 3)
  local init = function(l_1_0)
    l_1_0()
   end
  local enegyToast = img.createUI9Sprite(img.ui.tips_bg)
  enegyToast:setPreferredSize(CCSizeMake(410, 68))
  enegyToast:setPosition(board:getContentSize().width / 2, 485)
  enegyToast:setVisible(false)
  board:addChild(enegyToast, 1000)
  frdBoss.showenegyTimeLab = lbl.createFont2(16, "", ccc3(165, 253, 71))
  frdBoss.showenegyTimeLab:setAnchorPoint(0, 0.5)
  frdBoss.showenegyTimeLab:setPosition(enegyToast:getContentSize().width / 2 + 30, enegyToast:getContentSize().height / 2)
  enegyToast:addChild(frdBoss.showenegyTimeLab)
  frdBoss.tlrecoverlab = lbl.createFont1(16, i18n.global.friendboss_enegy_recovery.string, ccc3(255, 246, 223))
  frdBoss.tlrecoverlab:setAnchorPoint(1, 0.5)
  frdBoss.tlrecoverlab:setPosition(CCPoint(frdBoss.showenegyTimeLab:boundingBox():getMinX() - 10, enegyToast:getContentSize().height / 2))
  enegyToast:addChild(frdBoss.tlrecoverlab)
  frdBoss.enegyFull = lbl.createMixFont1(16, i18n.global.friendboss_enegy_full.string, ccc3(255, 246, 223))
  frdBoss.enegyFull:setPosition(enegyToast:getContentSize().width / 2, enegyToast:getContentSize().height / 2)
  frdBoss.enegyFull:setVisible(false)
  enegyToast:addChild(frdBoss.enegyFull)
  local enegyFlag = false
  local enegyNum = friendboss.enegy
  local onUpdate = function(l_2_0)
    if currentTab == TAB.LIST then
      local tmp_list_msg = friend.fetchListMsg()
      local tmp_loved_msg = friend.fetchLovedMsg()
      if enegyFlag == true then
        if friendboss.tcd then
          cd = math.max(0, friendboss.tcd + friendboss.pull_tcd_time - os.time())
          if cd > 0 then
            local timeLab = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
            frdBoss.showenegyTimeLab:setString(timeLab)
          else
            if friendboss.enegy <= 9 then
              friendboss.tcd = friendboss.tcd + 7200
              friendboss.addEnegy()
              frdBoss.enegylab:setString(string.format("%d/10", friendboss.enegy))
              if friendboss.tcd == nil then
                frdBoss.showenegyTimeLab:setVisible(false)
                frdBoss.tlrecoverlab:setVisible(false)
                frdBoss.enegyFull:setVisible(true)
              else
                frdBoss.showenegyTimeLab:setVisible(false)
                frdBoss.tlrecoverlab:setVisible(false)
                frdBoss.enegyFull:setVisible(true)
              end
            else
              frdBoss.showenegyTimeLab:setVisible(false)
              frdBoss.tlrecoverlab:setVisible(false)
              frdBoss.enegyFull:setVisible(true)
            end
          end
        end
      end
    end
    if enegyNum ~= friendboss.enegy and frdBoss.enegylab then
      upvalue_3072 = friendboss.enegy
      frdBoss.enegylab:setString(string.format("%d/10", friendboss.enegy))
    else
      if currentTab == TAB.APPL then
        local tmp_apply_msg = friend.fetchApplyMsg()
      else
        if currentTab == TAB.NPC and friendboss.scd and friendboss.pull_scd_time and frdBoss.showTimeLab and not tolua.isnull(frdBoss.showTimeLab) then
          cd = math.max(0, friendboss.scd + friendboss.pull_scd_time - os.time())
          if cd > 0 then
            local timeLab = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
            frdBoss.showTimeLab:setString(timeLab)
          else
            frdBoss.recoverlab:setVisible(false)
            frdBoss.showTimeLab:setVisible(false)
            frdBoss.searchBtn:setEnabled(true)
            clearShader(frdBoss.searchBtn, true)
          end
        end
      end
    end
  end
  if friendboss.showBossRedDot() then
    addRedDot(npcTab, {px = npcTab:getContentSize().width - 15, py = npcTab:getContentSize().height - 15})
  else
    delRedDot(npcTab)
  end
   end
  local container_w = 560
  local container_h = 462
  local container = CCSprite:create()
  container:setContentSize(CCSizeMake(container_w, container_h))
  container:setPosition(CCPoint(42 + container_w / 2, 38 + container_h / 2))
  board:addChild(container, 2)
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  local VIEW_WIDTH = 596
  local VIEW_HEIGHT = 340
  local BORDER_HEIGHT = 88
  local MARGIN_TOP = 4
  local GAP_VERTICAL = 6
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setAnchorPoint(0, 0)
  scroll:setPosition(CCPoint(48, 42))
  scroll:setViewSize(CCSizeMake(VIEW_WIDTH, VIEW_HEIGHT))
  board:addChild(scroll)
  local initcontainer = function()
    container:removeAllChildrenWithCleanup(true)
   end
  local initScroll = function(l_4_0, l_4_1)
    if l_4_0 < 4 then
      l_4_0 = 4
    end
    for i,_ in pairs(icons) do
      if icons[i].lvbottom then
        icons[i].lvbottom:removeFromParent()
      end
      if icons[i].name then
        icons[i].name:removeFromParent()
      end
      if icons[i].sendloveMenu then
        icons[i].sendloveMenu:removeFromParent()
      end
      if icons[i].recvloveMenu then
        icons[i].recvloveMenu:removeFromParent()
      end
      if icons[i].applyAgreMenu then
        icons[i].applyAgreMenu:removeFromParent()
      end
      if icons[i].applyNotagreMenu then
        icons[i].applyNotagreMenu:removeFromParent()
      end
      icons[i]:removeFromParent()
      icons[i].sendloveMenu = nil
      icons[i].recvloveMenu = nil
      icons[i].applyAgreMenu = nil
      icons[i].applyNotagreMenu = nil
      icons[i].lvbottom = nil
      icons[i].name = nil
      icons[i] = nil
    end
    local height = MARGIN_TOP + BORDER_HEIGHT * l_4_0 + GAP_VERTICAL * (l_4_0 - 1) - BORDER_HEIGHT / 2.5 + 20
    local contentOffsetY = scroll:getContentOffset().y
    contentOffsetY = VIEW_HEIGHT - height
    if not l_4_1 then
      contentOffsetY = VIEW_HEIGHT - height
    elseif contentOffsetY > 0 then
      contentOffsetY = 0
    else
      if contentOffsetY < VIEW_HEIGHT - height then
        contentOffsetY = VIEW_HEIGHT - height
      end
    end
    if currentTab == TAB.FIND then
      contentOffsetY = contentOffsetY - 35
      scroll:setViewSize(CCSizeMake(VIEW_WIDTH, VIEW_HEIGHT - 35))
    else
      scroll:setViewSize(CCSizeMake(VIEW_WIDTH, VIEW_HEIGHT))
    end
    scroll:setContentSize(CCSize(VIEW_WIDTH, height))
    scroll:setContentOffset(ccp(0, contentOffsetY))
   end
  local getPositionY = function(l_5_0)
    local y0 = scroll:getContentSize().height - BORDER_HEIGHT
    y = y0
    y = y - (l_5_0 - 1) * (BORDER_HEIGHT + MARGIN_TOP)
    return y
   end
  local initBorder = function(l_6_0)
    for i = 1, math.max( borders, l_6_0) do
      if borders[i] ~= nil and l_6_0 < i then
        borders[i]:removeFromParent()
        borders[i] = nil
      else
        if borders[i] == nil and i <= l_6_0 then
          borders[i] = img.createUI9Sprite(img.ui.botton_fram_2)
          borders[i]:setPreferredSize(CCSizeMake(578, 88))
          borders[i]:setAnchorPoint(CCPoint(0, 0))
          scroll:getContainer():addChild(borders[i])
        end
      end
      if borders[i] ~= nil then
        local y = getPositionY(i)
        borders[i]:setPosition(4, y)
      end
    end
   end
  local noFriends = function()
    local empty = require("ui.empty")
    local emptyBox = empty.create({text = i18n.global.friend_not_have_frd.string})
    emptyBox:setPosition(container_w / 2, container_w / 2 - 65)
    container:addChild(emptyBox)
   end
  local enegyBottom, enegyIcon = nil, nil
  local showList = function()
    initcontainer()
    local zhezhaodown = img.createUI9Sprite(img.ui.friends_zhezhao)
    zhezhaodown:setPreferredSize(CCSize(616, 33))
    zhezhaodown:setAnchorPoint(0.5, 0)
    zhezhaodown:setPosition(board_w / 2 - 42, 2)
    container:addChild(zhezhaodown)
    local title = lbl.createFont1(24, i18n.global.friend_friend_list.string, ccc3(230, 208, 174))
    title:setPosition(CCPoint(container:getContentSize().width / 2 - 20, 448))
    container:addChild(title, 1)
    local title_shadowD = lbl.createFont1(24, i18n.global.friend_friend_list.string, ccc3(89, 48, 27))
    title_shadowD:setPosition(CCPoint(container:getContentSize().width / 2 - 20, 446))
    container:addChild(title_shadowD)
    local valueBottom = img.createUI9Sprite(img.ui.main_coin_bg)
    valueBottom:setPreferredSize(CCSizeMake(138, 40))
    valueBottom:setPosition(CCPoint(90, 371))
    container:addChild(valueBottom)
    local lovelab = lbl.createFont2(16, string.format("%d", bag.items.find(ITEM_ID_LOVE).num), ccc3(248, 242, 226))
    lovelab:setPosition(CCPoint(valueBottom:getContentSize().width / 2, valueBottom:getContentSize().height / 2 + 2))
    valueBottom:addChild(lovelab)
    local friendGift = img.createItemIcon2(ITEM_ID_LOVE)
    friendGift:setPosition(5, valueBottom:getContentSize().height / 2 + 2)
    valueBottom:addChild(friendGift)
    upvalue_3584 = img.createUI9Sprite(img.ui.main_coin_bg)
    enegyBottom:setPreferredSize(CCSizeMake(138, 40))
    enegyBottom:setPosition(CCPoint(250, 371))
    container:addChild(enegyBottom)
    upvalue_4096 = friendboss.enegy
    frdBoss.enegylab = lbl.createFont2(16, string.format("%d/10", enegyNum), ccc3(248, 242, 226))
    frdBoss.enegylab:setPosition(CCPoint(enegyBottom:getContentSize().width / 2, enegyBottom:getContentSize().height / 2 + 2))
    enegyBottom:addChild(frdBoss.enegylab)
    upvalue_5632 = img.createUISprite(img.ui.friends_enegy)
    enegyIcon:setPosition(8, enegyBottom:getContentSize().height / 2 + 4)
    enegyBottom:addChild(enegyIcon)
    initScroll(0)
    initBorder(0)
    if friend.friends.friendsList == nil or  friend.friends.friendsList == 0 then
      title:setPosition(CCPoint(container:getContentSize().width / 2, 448))
      title_shadowD:setPosition(CCPoint(container:getContentSize().width / 2, 446))
      noFriends()
      return 
    end
    local recvallUids = {}
    local sendallUids = {}
    local friendsLimitlab = lbl.createFont2(22, string.format("%d/%d",  friend.friends.friendsList, LIMIT_FRIEND))
    friendsLimitlab:setAnchorPoint(CCPoint(0, 0.5))
    friendsLimitlab:setPosition(CCPoint(title:boundingBox():getMaxX() + 10, 448))
    container:addChild(friendsLimitlab)
    initScroll( friend.friends.friendsList, true)
    initBorder( friend.friends.friendsList)
    for i,obj in ipairs(friend.friends.friendsList) do
      do
        if obj.flag == 2 or obj.flag == 3 then
          recvallUids[ recvallUids + 1] = obj.uid
        end
        if obj.flag == 0 or obj.flag == 2 or obj.flag == 4 or obj.flag == 6 then
          sendallUids[ sendallUids + 1] = obj.uid
        end
        icons[i] = img.createPlayerHead(obj.logo)
        icons[i].frdBtn = SpineMenuItem:create(json.ui.button, icons[i])
        icons[i].frdBtn:setScale(0.7)
        icons[i].frdBtn:setAnchorPoint(CCPoint(0, 0.5))
        icons[i].frdBtn:setPosition(CCPoint(15, 46))
        local frdMenu = CCMenu:createWithItem(icons[i].frdBtn)
        frdMenu:setPosition(0, 0)
        borders[i]:addChild(frdMenu)
        icons[i].frdBtn:registerScriptTapHandler(function()
          audio.play(audio.button)
          local params = {}
          params.logo = obj.logo
          params.uid = obj.uid
          params.name = obj.name
          params.frd = obj
          layer:addChild(require("ui.tips.player1").create(params, "del", showFriends), 100)
            end)
        icons[i].lvbottom = img.createUISprite(img.ui.main_lv_bg)
        icons[i].lvbottom:setPosition(CCPoint(107, 46))
        borders[i]:addChild(icons[i].lvbottom)
        local lvlab = lbl.createFont1(14, string.format("%d", obj.lv), ccc3(255, 246, 223))
        lvlab:setPosition(CCPoint(icons[i].lvbottom:getContentSize().width / 2, icons[i].lvbottom:getContentSize().height / 2))
        icons[i].lvbottom:addChild(lvlab)
        icons[i].name = lbl.create({kind = "ttf", size = 18, text = obj.name, color = ccc3(81, 39, 18)})
        icons[i].name:setAnchorPoint(CCPoint(0, 0.5))
        icons[i].name:setPosition(CCPoint(137, 58))
        borders[i]:addChild(icons[i].name)
        if obj.last then
          local last = obj.last
          if obj.last ~= 0 then
            last = os.time() - obj.last
          end
          local lbl_mem_status = lbl.createFont1(14, friend.onlineStatus(last), ccc3(138, 96, 76))
          lbl_mem_status:setAnchorPoint(CCPoint(0, 0.5))
          lbl_mem_status:setPosition(CCPoint(137, 34))
          borders[i]:addChild(lbl_mem_status)
        end
        if obj.boss == true and player.lv() >= 36 then
          local bossIcon = img.createUISprite(img.ui.friends_boss_btn)
          icons[i].bossBtn = SpineMenuItem:create(json.ui.button, bossIcon)
          icons[i].bossBtn:setPosition(CCPoint(315, 44))
          icons[i].bossMenu = CCMenu:createWithItem(icons[i].bossBtn)
          icons[i].bossMenu:setPosition(CCPoint(0, 0))
          borders[i]:addChild(icons[i].bossMenu)
          icons[i].bossBtn:registerScriptTapHandler(function()
            audio.play(audio.button)
            local enemyline = require("ui.friends.enemyline")
            layer:addChild(enemyline.create(obj.uid))
               end)
        end
        local fight = img.createUISprite(img.ui.friends_fight)
        icons[i].fightBtn = SpineMenuItem:create(json.ui.button, fight)
        icons[i].fightBtn:setPosition(CCPoint(388, 44))
        icons[i].fightMenu = CCMenu:createWithItem(icons[i].fightBtn)
        icons[i].fightMenu:setPosition(CCPoint(0, 0))
        borders[i]:addChild(icons[i].fightMenu)
        icons[i].fightBtn:registerScriptTapHandler(function()
          audio.play(audio.button)
          tbl2string(obj)
          layer:addChild(require("ui.selecthero.main").create({type = "frdpk", info = obj}))
            end)
        local bottom1 = img.createUISprite(img.ui.friends_circle_botton)
        json.load(json.ui.haoyou_heart)
        local aniheartLz = DHSkeletonAnimation:createWithKey(json.ui.haoyou_heart)
        aniheartLz:playAnimation("loop", -1)
        aniheartLz:scheduleUpdateLua()
        aniheartLz:setPosition(bottom1:getContentSize().width / 2, bottom1:getContentSize().height / 2)
        bottom1:addChild(aniheartLz)
        icons[i].aniheartLz = aniheartLz
        local recvlove1 = img.createItemIcon2(ITEM_ID_LOVE)
        local recvlove2 = img.createItemIcon2(ITEM_ID_LOVE)
        icons[i].aniheartLz:addChildFollowSlot("code_heart2", recvlove1)
        icons[i].aniheartLz:addChildFollowSlot("code_heart", recvlove2)
        icons[i].recvloveBtn = SpineMenuItem:create(json.ui.button, bottom1)
        icons[i].recvloveBtn:setPosition(CCPoint(464, 44))
        if obj.flag >= 4 then
          setShader(icons[i].recvloveBtn, SHADER_GRAY, true)
          icons[i].aniheartLz:stopAnimation()
          icons[i].recvloveBtn:setEnabled(false)
        elseif obj.flag == 0 or obj.flag == 1 then
          icons[i].recvloveBtn:setVisible(false)
        end
        icons[i].recvloveMenu = CCMenu:createWithItem(icons[i].recvloveBtn)
        icons[i].recvloveMenu:setPosition(CCPoint(0, 0))
        borders[i]:addChild(icons[i].recvloveMenu)
        local bottom2 = img.createUISprite(img.ui.friends_circle_botton)
        local sendlove = img.createUISprite(img.ui.friends_gift_1)
        sendlove:setPosition(CCPoint(bottom2:getContentSize().width / 2, bottom2:getContentSize().height / 2))
        bottom2:addChild(sendlove)
        icons[i].sendloveBtn = SpineMenuItem:create(json.ui.button, bottom2)
        icons[i].sendloveBtn:setPosition(CCPoint(528, 44))
        icons[i].sendloveMenu = CCMenu:createWithItem(icons[i].sendloveBtn)
        icons[i].sendloveMenu:setPosition(CCPoint(0, 0))
        borders[i]:addChild(icons[i].sendloveMenu)
        if obj.flag == 1 or obj.flag == 3 or obj.flag == 5 or obj.flag == 7 then
          setShader(icons[i].sendloveBtn, SHADER_GRAY, true)
          icons[i].sendloveBtn:setEnabled(false)
        end
        icons[i].recvloveBtn:registerScriptTapHandler(function()
          if LIMIT_FRIEND <= friend.love then
            showToast(string.format(i18n.global.friend_love_limit.string, LIMIT_FRIEND))
            return 
          end
          local pbbag = {}
          pbbag.items = {}
          local param = {}
          param.sid = player.sid
          local uids = {}
          uids[ uids + 1] = obj.uid
          param.recv = uids
          addWaitNet()
          net:frd_love(param, function(l_1_0)
            delWaitNet()
            tbl2string(l_1_0)
            if l_1_0.status == -1 then
              showToast(i18n.global.friend_not_friends.string)
              return 
            end
            if l_1_0.status == -2 then
              showToast(string.format(i18n.global.friend_love_limit.string, LIMIT_FRIEND))
              return 
            end
            if l_1_0.status < -1 then
              showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
              return 
            end
            obj.flag = obj.flag + 4
            for ii = 1,  recvallUids do
              if recvallUids[ii] == obj.uid then
                table.remove(recvallUids, ii)
            else
              end
            end
            bag.items.add({id = ITEM_ID_LOVE, num = 1})
            lovelab:setString(string.format("%d", bag.items.find(ITEM_ID_LOVE).num))
            friend.love = friend.love + 1
            setShader(icons[i].recvloveBtn, SHADER_GRAY, true)
            icons[i].recvloveBtn:setEnabled(false)
            icons[i].aniheartLz:stopAnimation()
            pbbag.items[ pbbag.items + 1] = {id = ITEM_ID_LOVE, num = 1}
            local rewardlayer = reward.createFloating(pbbag, 1000)
            layer:addChild(rewardlayer, 1000)
               end)
          audio.play(audio.get_heart)
            end)
        icons[i].sendloveBtn:registerScriptTapHandler(function()
          audio.play(audio.button)
          icons[i].sendloveBtn:setEnabled(false)
          setShader(icons[i].sendloveBtn, SHADER_GRAY, true)
          local param = {}
          param.sid = player.sid
          param.send = obj.uid
          addWaitNet()
          net:frd_love(param, function(l_1_0)
            delWaitNet()
            tbl2string(l_1_0)
            if l_1_0.status == -2 then
              return 
            end
            if l_1_0.status == -1 then
              showToast(i18n.global.friend_not_friends.string)
              return 
            end
            if l_1_0.status ~= 0 then
              showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
              return 
            end
            if friend.friends.friendsList[i] then
              friend.friends.friendsList[i].flag = friend.friends.friendsList[i].flag + 1
            end
            for ii = 1,  sendallUids do
              if sendallUids[ii] == obj.uid then
                table.remove(sendallUids, ii)
            else
              end
            end
            local task = require("data.task")
            task.increment(task.TaskType.FRIEND_HEART)
            showToast(i18n.global.friend_send_seccese.string)
               end)
            end)
      end
    end
    local recvallSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    recvallSprite:setPreferredSize(CCSizeMake(208, 42))
    local recvallBtn = SpineMenuItem:create(json.ui.button, recvallSprite)
    recvallBtn:setAnchorPoint(0, 0)
    recvallBtn:setPosition(CCPoint(380, 351))
    local receiptallMenu = CCMenu:createWithItem(recvallBtn)
    receiptallMenu:setPosition(0, 0)
    container:addChild(receiptallMenu)
    local recvallLab = lbl.createFont1(16, i18n.global.friend_batch_receipt.string, ccc3(115, 59, 5))
    recvallLab:setPosition(CCPoint(recvallBtn:getContentSize().width / 2, recvallBtn:getContentSize().height / 2 + 1))
    recvallSprite:addChild(recvallLab)
    recvallBtn:registerScriptTapHandler(function()
      if  recvallUids == 0 and  sendallUids == 0 then
        showToast(i18n.global.friend_no_sendandrec_love.string)
        return 
      end
      if LIMIT_FRIEND < friend.love +  recvallUids and  sendallUids == 0 then
        showToast(string.format(i18n.global.friend_love_limit.string, LIMIT_FRIEND))
        return 
      end
      local quicksend = function()
        local pbbag = {}
        pbbag.items = {}
        local param = {}
        param.sid = player.sid
        param.send = 10000
        addWaitNet()
        net:frd_love(param, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          if l_1_0.status ~= 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            return 
          end
          local sendlovecount = 0
          for ii,obj in ipairs(friend.friends.friendsList) do
            if obj.flag == 0 or obj.flag == 2 or obj.flag == 4 or obj.flag == 6 then
              friend.friends.friendsList[ii].flag = friend.friends.friendsList[ii].flag + 1
              sendlovecount = sendlovecount + 1
              if icons[ii] and icons[ii].sendloveBtn and not tolua.isnull(icons[ii].sendloveBtn) then
                setShader(icons[ii].sendloveBtn, SHADER_GRAY, true)
                icons[ii].sendloveBtn:setEnabled(false)
              end
            end
          end
          local task = require("data.task")
          task.increment(task.TaskType.FRIEND_HEART, sendlovecount)
          upvalue_1536 = {}
            end)
         end
      if  recvallUids ~= 0 and friend.love +  recvallUids <= LIMIT_FRIEND then
        local pbbag = {}
        do
          pbbag.items = {}
          local param = {}
          param.sid = player.sid
          param.recv = recvallUids
          addWaitNet()
          net:frd_love(param, function(l_2_0)
            delWaitNet()
            tbl2string(l_2_0)
            if l_2_0.status == -1 then
              showToast(i18n.global.friend_not_friends.string)
              return 
            end
            if l_2_0.status == -2 then
              showToast(string.format(i18n.global.friend_love_limit.string, LIMIT_FRIEND))
              return 
            end
            for i,obj in ipairs(friend.friends.friendsList) do
              if obj.flag == 2 or obj.flag == 3 then
                friend.friends.friendsList[i].flag = friend.friends.friendsList[i].flag + 4
                if icons[i] and icons[i].recvloveBtn then
                  setShader(icons[i].recvloveBtn, SHADER_GRAY, true)
                  icons[i].aniheartLz:stopAnimation()
                  icons[i].recvloveBtn:setEnabled(false)
                end
              end
            end
            bag.items.add({id = ITEM_ID_LOVE, num = l_2_0.status})
            lovelab:setString(string.format("%d", bag.items.find(ITEM_ID_LOVE).num))
            pbbag.items[ pbbag.items + 1] = {id = ITEM_ID_LOVE, num = l_2_0.status}
            local rewardlayer = reward.createFloating(pbbag, 1000)
            layer:addChild(rewardlayer, 1000)
            upvalue_4608 = {}
            if  sendallUids ~= 0 then
              quicksend()
            end
               end)
        end
      else
        if  sendallUids ~= 0 then
          quicksend()
        end
      end
      audio.play(audio.get_heart)
      end)
   end
  local showFind = function()
    initcontainer()
    initScroll(0)
    initBorder(0)
    if friend.friends.friendsRecmd then
      initScroll( friend.friends.friendsRecmd, true)
      initBorder( friend.friends.friendsRecmd)
      for i,obj in ipairs(friend.friends.friendsRecmd) do
        do
          icons[i] = img.createPlayerHead(obj.logo)
          icons[i].frdBtn = SpineMenuItem:create(json.ui.button, icons[i])
          icons[i].frdBtn:setScale(0.7)
          icons[i].frdBtn:setAnchorPoint(CCPoint(0, 0.5))
          icons[i].frdBtn:setPosition(CCPoint(15, 46))
          local frdMenu = CCMenu:createWithItem(icons[i].frdBtn)
          frdMenu:setPosition(0, 0)
          borders[i]:addChild(frdMenu)
          icons[i].frdBtn:registerScriptTapHandler(function()
            audio.play(audio.button)
            local params = {}
            params.logo = obj.logo
            params.uid = obj.uid
            params.name = obj.name
            params.frd = obj
            layer:addChild(require("ui.tips.player1").create(params, "add", showFriends), 100)
               end)
          local lvbottom = img.createUISprite(img.ui.main_lv_bg)
          lvbottom:setPosition(CCPoint(107, 46))
          borders[i]:addChild(lvbottom)
          local lvlab = lbl.createFont1(14, string.format("%d", obj.lv), ccc3(255, 246, 223))
          lvlab:setPosition(CCPoint(lvbottom:getContentSize().width / 2, lvbottom:getContentSize().height / 2))
          lvbottom:addChild(lvlab)
          local name = lbl.create({kind = "ttf", size = 18, text = obj.name, color = ccc3(81, 39, 18)})
          name:setAnchorPoint(CCPoint(0, 0.5))
          name:setPosition(CCPoint(137, 46))
          borders[i]:addChild(name)
          local addbtn = img.createLogin9Sprite(img.login.button_9_small_gold)
          addbtn:setPreferredSize(CCSizeMake(100, 42))
          local addlab = lbl.createFont1(16, i18n.global.friend_apply.string, ccc3(115, 59, 5))
          addlab:setPosition(CCPoint(addbtn:getContentSize().width / 2, addbtn:getContentSize().height / 2 + 1))
          addbtn:addChild(addlab)
          icons[i].findAddBtn = SpineMenuItem:create(json.ui.button, addbtn)
          icons[i].findAddBtn:setAnchorPoint(0, 0)
          icons[i].findAddBtn:setPosition(CCPoint(460, 24))
          local findAddMenu = CCMenu:createWithItem(icons[i].findAddBtn)
          findAddMenu:setPosition(CCPoint(0, 0))
          borders[i]:addChild(findAddMenu)
          icons[i].findAddBtn:registerScriptTapHandler(function()
            audio.play(audio.button)
            local param = {}
            param.sid = player.sid
            param.apply = obj.uid
            addWaitNet()
            net:frd_op(param, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status == -1 then
                showToast(i18n.global.friend_are_friend.string)
                return 
              end
              if l_1_0.status ~= 0 then
                showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
                return 
              end
              friend.delFriendsRecmd(obj)
              showFriends()
                  end)
               end)
        end
      end
    end
    local title = lbl.createFont1(24, i18n.global.friend_friend_apply.string, ccc3(230, 208, 174))
    title:setPosition(CCPoint(container:getContentSize().width / 2, 448))
    container:addChild(title, 1)
    local title_shadowD = lbl.createFont1(24, i18n.global.friend_friend_apply.string, ccc3(89, 48, 27))
    title_shadowD:setPosition(CCPoint(container:getContentSize().width / 2, 446))
    container:addChild(title_shadowD)
    local recommdlab = lbl.createFont1(16, i18n.global.friend_recommend.string, ccc3(73, 38, 4))
    recommdlab:setAnchorPoint(CCPoint(0, 0.5))
    recommdlab:setPosition(CCPoint(10, 325))
    container:addChild(recommdlab)
    local addtoSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    addtoSprite:setPreferredSize(CCSizeMake(138, 46))
    local addtoBtn = SpineMenuItem:create(json.ui.button, addtoSprite)
    addtoBtn:setAnchorPoint(0, 0)
    addtoBtn:setPosition(CCPoint(407, 346))
    local addtoMenu = CCMenu:createWithItem(addtoBtn)
    addtoMenu:setPosition(0, 0)
    container:addChild(addtoMenu)
    local addtoLab = lbl.createFont1(16, i18n.global.friend_apply.string, ccc3(115, 59, 5))
    addtoLab:setPosition(CCPoint(addtoSprite:getContentSize().width / 2, addtoSprite:getContentSize().height / 2 + 1))
    addtoSprite:addChild(addtoLab)
    addtoBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if inputFind:getText() == "" then
        showToast(i18n.global.friend_id_empty.string)
        return 
      end
      if  inputFind:getText() ~= 8 then
        showToast(i18n.global.friend_no_id.string)
        return 
      end
      if tonumber(inputFind:getText()) == nil then
        showToast(i18n.global.friend_input_id.string)
        return 
      end
      if tonumber(inputFind:getText()) == player.uid then
        showToast(i18n.global.friend_not_yourself.string)
        return 
      end
      local param = {}
      param.sid = player.sid
      param.apply = tonumber(inputFind:getText())
      addWaitNet()
      net:frd_op(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status == -2 then
          showToast(i18n.global.friend_no_id.string)
          return 
        end
        if l_1_0.status == -1 then
          showToast(i18n.global.friend_are_friend.string)
          return 
        end
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        showToast(i18n.global.friend_apply_succese.string)
         end)
      end)
   end
  local showApply = function()
    initcontainer()
    initScroll(0)
    initBorder(0)
    local applyUids = {}
    local requestsNum = 0
    if friend.friends.friendsApply then
      initScroll( friend.friends.friendsApply, true)
      initBorder( friend.friends.friendsApply)
      requestsNum =  friend.friends.friendsApply
      for i,obj in ipairs(friend.friends.friendsApply) do
        do
          applyUids[ applyUids + 1] = obj.uid
          icons[i] = img.createPlayerHead(obj.logo)
          icons[i].frdBtn = SpineMenuItem:create(json.ui.button, icons[i])
          icons[i].frdBtn:setScale(0.7)
          icons[i].frdBtn:setAnchorPoint(CCPoint(0, 0.5))
          icons[i].frdBtn:setPosition(CCPoint(15, 46))
          local frdMenu = CCMenu:createWithItem(icons[i].frdBtn)
          frdMenu:setPosition(0, 0)
          borders[i]:addChild(frdMenu)
          icons[i].frdBtn:registerScriptTapHandler(function()
            audio.play(audio.button)
            local params = {}
            params.logo = obj.logo
            params.uid = obj.uid
            params.name = obj.name
            layer:addChild(require("ui.tips.player1").create(params, "none"), 100)
               end)
          icons[i].lvbottom = img.createUISprite(img.ui.main_lv_bg)
          icons[i].lvbottom:setPosition(CCPoint(107, 46))
          borders[i]:addChild(icons[i].lvbottom)
          local lvlab = lbl.createFont1(14, string.format("%d", obj.lv), ccc3(255, 246, 223))
          lvlab:setPosition(CCPoint(icons[i].lvbottom:getContentSize().width / 2, icons[i].lvbottom:getContentSize().height / 2))
          icons[i].lvbottom:addChild(lvlab)
          icons[i].name = lbl.create({kind = "ttf", size = 18, text = obj.name, color = ccc3(81, 39, 18)})
          icons[i].name:setAnchorPoint(CCPoint(0, 0.5))
          icons[i].name:setPosition(CCPoint(137, 46))
          borders[i]:addChild(icons[i].name)
          local tickbtn = img.createLogin9Sprite(img.login.button_9_small_green)
          tickbtn:setPreferredSize(CCSizeMake(90, 42))
          local applyAgre = img.createUISprite(img.ui.friends_tick)
          applyAgre:setPosition(CCPoint(tickbtn:getContentSize().width / 2, tickbtn:getContentSize().height / 2))
          tickbtn:addChild(applyAgre)
          local applyAgreBtn = SpineMenuItem:create(json.ui.button, tickbtn)
          applyAgreBtn:setAnchorPoint(0, 0)
          applyAgreBtn:setPosition(CCPoint(372, 24))
          icons[i].applyAgreMenu = CCMenu:createWithItem(applyAgreBtn)
          icons[i].applyAgreMenu:setPosition(CCPoint(0, 0))
          borders[i]:addChild(icons[i].applyAgreMenu)
          local xbtn = img.createLogin9Sprite(img.login.button_9_small_orange)
          xbtn:setPreferredSize(CCSizeMake(90, 42))
          local applyNotagrebtn1 = img.createUISprite(img.ui.friends_x)
          applyNotagrebtn1:setPosition(CCPoint(xbtn:getContentSize().width / 2, xbtn:getContentSize().height / 2))
          xbtn:addChild(applyNotagrebtn1)
          local applyNotagrebtn = SpineMenuItem:create(json.ui.button, xbtn)
          applyNotagrebtn:setAnchorPoint(0, 0)
          applyNotagrebtn:setPosition(CCPoint(474, 24))
          icons[i].applyNotagreMenu = CCMenu:createWithItem(applyNotagrebtn)
          icons[i].applyNotagreMenu:setPosition(CCPoint(0, 0))
          borders[i]:addChild(icons[i].applyNotagreMenu)
          applyNotagrebtn:registerScriptTapHandler(function()
            audio.play(audio.button)
            local param = {}
            param.sid = player.sid
            local uids = {}
            uids[ uids + 1] = obj.uid
            param.disagree = uids
            addWaitNet()
            net:frd_op(param, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status ~= 0 then
                showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
                return 
              end
              friend.delFriendsApply(obj)
              showFriends()
                  end)
               end)
          applyAgreBtn:registerScriptTapHandler(function()
            audio.play(audio.button)
            local param = {}
            param.sid = player.sid
            param.agree = obj.uid
            addWaitNet()
            net:frd_op(param, function(l_1_0)
              delWaitNet()
              tbl2string(l_1_0)
              if l_1_0.status == -4 or l_1_0.status == -1 then
                showToast(i18n.global.friend_are_friend.string)
                friend.delFriendsApply(obj)
                showFriends()
                return 
              end
              if l_1_0.status == -5 then
                showToast(string.format(i18n.global.friend_other_frd_full.string, LIMIT_FRIEND))
                return 
              end
              if l_1_0.status == -3 then
                showToast(string.format(i18n.global.friend_friends_limit.string, LIMIT_FRIEND))
                return 
              end
              if l_1_0.status ~= 0 then
                showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
                return 
              end
              friend.addFriendsList(obj)
              friend.delFriendsApply(obj)
              showFriends()
                  end)
               end)
        end
      end
    end
    local title = lbl.createFont1(24, i18n.global.friend_apply_list.string, ccc3(230, 208, 174))
    title:setPosition(CCPoint(container:getContentSize().width / 2, 448))
    container:addChild(title, 1)
    local title_shadowD = lbl.createFont1(24, i18n.global.friend_apply_list.string, ccc3(89, 48, 27))
    title_shadowD:setPosition(CCPoint(container:getContentSize().width / 2, 446))
    container:addChild(title_shadowD)
    local requestslab = lbl.createFont1(16, string.format(i18n.global.friend_requesrs_rcvd.string, requestsNum), ccc3(73, 38, 4))
    requestslab:setAnchorPoint(CCPoint(0, 0.5))
    requestslab:setPosition(CCPoint(10, 372))
    container:addChild(requestslab)
    local deleteallSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    deleteallSprite:setPreferredSize(CCSizeMake(208, 42))
    local deleteallBtn = SpineMenuItem:create(json.ui.button, deleteallSprite)
    deleteallBtn:setAnchorPoint(0, 0)
    deleteallBtn:setPosition(CCPoint(380, 351))
    local deleteallMenu = CCMenu:createWithItem(deleteallBtn)
    deleteallMenu:setPosition(0, 0)
    container:addChild(deleteallMenu)
    local deleteallLab = lbl.createFont1(16, i18n.global.friend_apply_delete.string, ccc3(115, 59, 5))
    deleteallLab:setPosition(CCPoint(deleteallSprite:getContentSize().width / 2, deleteallSprite:getContentSize().height / 2 + 1))
    deleteallSprite:addChild(deleteallLab)
    deleteallBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      if friend.friends.friendsApply == nil or  friend.friends.friendsApply == 0 then
        showToast(i18n.global.friend_no_application.string)
        return 
      end
      local param = {}
      param.sid = player.sid
      param.disagree = applyUids
      addWaitNet()
      net:frd_op(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        for _ = 1,  friend.friends.friendsApply do
          friend.delFriendsApply(friend.friends.friendsApply[1])
        end
        showFriends()
         end)
      end)
   end
  local progressLabel, powerProgress = nil, nil
  local showNPC = function()
    initcontainer()
    initScroll(0)
    initBorder(0)
    local title = lbl.createFont1(24, i18n.global.friend_assist.string, ccc3(230, 208, 174))
    title:setPosition(CCPoint(container:getContentSize().width / 2, 448))
    container:addChild(title, 1)
    local title_shadowD = lbl.createFont1(24, i18n.global.friend_assist.string, ccc3(89, 48, 27))
    title_shadowD:setPosition(CCPoint(container:getContentSize().width / 2, 446))
    container:addChild(title_shadowD)
    local callBackself = function(l_1_0)
      progressLabel:setString(string.format("%d%%", l_1_0))
      powerProgress:setPercentage(l_1_0 / 100 * 100)
      end
    local createBoss = function(l_2_0, l_2_1)
      local info = cfgmonster[cfgfriendstage[l_2_0].monster[1]]
      local boss = img.createHeroHead(info.heroLink, info.lvShow, true, info.star)
      boss:setPosition(283, 270)
      container:addChild(boss)
      local powerBar = img.createUI9Sprite(img.ui.fight_hurts_bar_bg)
      powerBar:setPreferredSize(CCSize(290, 22))
      powerBar:setPosition(283, 198)
      container:addChild(powerBar)
      local progress0 = img.createUISprite(img.ui.friends_boss_blood)
      upvalue_2048 = createProgressBar(progress0)
      powerProgress:setPosition(powerBar:getContentSize().width / 2, powerBar:getContentSize().height / 2)
      powerProgress:setPercentage(l_2_1 / 100 * 100)
      powerBar:addChild(powerProgress)
      local progressStr = string.format("%d%%", l_2_1)
      upvalue_2560 = lbl.createFont2(16, progressStr, ccc3(255, 246, 223))
      progressLabel:setPosition(CCPoint(powerBar:getContentSize().width / 2, powerBar:getContentSize().height / 2 + 5))
      powerBar:addChild(progressLabel)
      local injurySprite = img.createUISprite(img.ui.fight_hurts)
      local injuryBtn = SpineMenuItem:create(json.ui.button, injurySprite)
      injuryBtn:setPosition(CCPoint(518, 305))
      local injuryMenu = CCMenu:createWithItem(injuryBtn)
      injuryMenu:setPosition(0, 0)
      container:addChild(injuryMenu)
      injuryBtn:registerScriptTapHandler(function()
        audio.play(audio.button)
        local injuryrank = require("ui.friends.injuryrank")
        layer:addChild(injuryrank.create())
         end)
      local combatLab = lbl.createFont1(16, i18n.global.friendboss_battle_reward.string, ccc3(115, 59, 5))
      combatLab:setPosition(281, 142)
      container:addChild(combatLab)
      local rewardObj = cfgfriendstage[l_2_0].finalReward
      local offset_x = 281
      for i = 1,  rewardObj do
        local tmp_item = nil
        do
          local itemObj = rewardObj[i]
          if itemObj.type == 1 then
            local tmp_item0 = img.createItem(itemObj.id, itemObj.num)
            tmp_item = SpineMenuItem:create(json.ui.button, tmp_item0)
          elseif itemObj.type == 2 then
            local tmp_item0 = img.createEquip(itemObj.id, itemObj.num)
            tmp_item = SpineMenuItem:create(json.ui.button, tmp_item0)
          end
          tmp_item:setScale(0.7)
          tmp_item:setPosition(CCPoint(offset_x + (i - 1) * 70, 100))
          local tmp_item_menu = CCMenu:createWithItem(tmp_item)
          tmp_item_menu:setPosition(CCPoint(0, 0))
          container:addChild(tmp_item_menu)
          tmp_item:registerScriptTapHandler(function()
            audio.play(audio.button)
            local tmp_tip = nil
            if itemObj.type == 1 then
              tmp_tip = tipsitem.createForShow({id = itemObj.id})
              layer:addChild(tmp_tip, 100)
            else
              if itemObj.type == 2 then
                tmp_tip = tipsequip.createById(itemObj.id)
                layer:addChild(tmp_tip, 100)
              end
            end
            tmp_tip.setClickBlankHandler(function()
              tmp_tip:removeFromParentAndCleanup(true)
                  end)
               end)
        end
      end
      local battleSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
      battleSprite:setPreferredSize(CCSizeMake(174, 54))
      local battlelab = lbl.createFont1(18, i18n.global.trial_stage_btn_battle.string, lbl.buttonColor)
      battlelab:setPosition(CCPoint(battleSprite:getContentSize().width / 2, battleSprite:getContentSize().height / 2))
      battleSprite:addChild(battlelab)
      local battleBtn = SpineMenuItem:create(json.ui.button, battleSprite)
      battleBtn:setAnchorPoint(0.5, 0)
      battleBtn:setPosition(CCPoint(281, 12))
      local battleMenu = CCMenu:createWithItem(battleBtn)
      battleMenu:setPosition(0, 0)
      container:addChild(battleMenu)
      battleBtn:registerScriptTapHandler(function()
        disableObjAWhile(battleBtn)
        audio.play(audio.button)
        layer:addChild(require("ui.friends.enemyline").create(player.uid, callBackself))
         end)
      end
    local initFrdboss = function()
      local gParams = {sid = player.sid, uid = player.uid}
      addWaitNet()
      net:frd_boss_st(gParams, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status == -2 then
          showToast(i18n.global.friendboss_boss_die.string)
          friendboss.upscd()
          frdBoss.recoverlab:setVisible(false)
          frdBoss.showTimeLab:setVisible(false)
          return 
        end
        createBoss(l_1_0.id, l_1_0.hpp)
        frdBoss.recoverlab:setVisible(false)
        frdBoss.showTimeLab:setVisible(false)
        frdBoss.searchIcon:setVisible(false)
        frdBoss.searchmap:setVisible(false)
        frdBoss.searchBtn:setVisible(false)
         end)
      end
    local detailSprite = img.createUISprite(img.ui.btn_help)
    local detailBtn = SpineMenuItem:create(json.ui.button, detailSprite)
    detailBtn:setPosition(570, 370)
    local detailMenu = CCMenu:create()
    detailMenu:setPosition(0, 0)
    container:addChild(detailMenu)
    detailMenu:addChild(detailBtn)
    detailBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:addChild(require("ui.help").create(i18n.global.friendboss_help.string), 1000)
      end)
    local rankSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    rankSprite:setPreferredSize(CCSizeMake(206, 42))
    local ranklab = lbl.createFont1(16, i18n.global.friendboss_integral_rank.string, lbl.buttonColor)
    ranklab:setPosition(CCPoint(rankSprite:getContentSize().width / 2, rankSprite:getContentSize().height / 2 + 1))
    rankSprite:addChild(ranklab)
    local rankBtn = SpineMenuItem:create(json.ui.button, rankSprite)
    rankBtn:setAnchorPoint(0, 0.5)
    rankBtn:setPosition(CCPoint(2, 370))
    local rankMenu = CCMenu:createWithItem(rankBtn)
    rankMenu:setPosition(0, 0)
    container:addChild(rankMenu)
    rankBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:addChild(require("ui.friends.scorerank").create())
      end)
    local rewardSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    rewardSprite:setPreferredSize(CCSizeMake(206, 42))
    local rewardlab = lbl.createFont1(16, i18n.global.friendboss_integral_reward.string, lbl.buttonColor)
    rewardlab:setPosition(CCPoint(rewardSprite:getContentSize().width / 2, rewardSprite:getContentSize().height / 2 + 1))
    rewardSprite:addChild(rewardlab)
    local rewardBtn = SpineMenuItem:create(json.ui.button, rewardSprite)
    rewardBtn:setAnchorPoint(0, 0.5)
    rewardBtn:setPosition(CCPoint(216, 370))
    local rewardMenu = CCMenu:createWithItem(rewardBtn)
    rewardMenu:setPosition(0, 0)
    container:addChild(rewardMenu)
    rewardBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:addChild(require("ui.friends.scorereward").create())
      end)
    local npcboard = img.createUI9Sprite(img.ui.botton_fram_2)
    npcboard:setPreferredSize(CCSizeMake(592, 178))
    npcboard:setAnchorPoint(CCPoint(0, 0))
    npcboard:setPosition(3, 160)
    container:addChild(npcboard)
    local searchSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    searchSprite:setPreferredSize(CCSizeMake(174, 54))
    local searchlab = lbl.createFont1(18, i18n.global.friendboss_btn_search.string, lbl.buttonColor)
    searchlab:setPosition(CCPoint(searchSprite:getContentSize().width / 2, searchSprite:getContentSize().height / 2))
    searchSprite:addChild(searchlab)
    frdBoss.searchBtn = SpineMenuItem:create(json.ui.button, searchSprite)
    frdBoss.searchBtn:setAnchorPoint(0.5, 0)
    frdBoss.searchBtn:setPosition(CCPoint(301, 12))
    local searchMenu = CCMenu:createWithItem(frdBoss.searchBtn)
    searchMenu:setPosition(0, 0)
    container:addChild(searchMenu)
    frdBoss.searchmap = img.createUISprite(img.ui.friends_search)
    frdBoss.searchmap:setPosition(303, 250)
    container:addChild(frdBoss.searchmap)
    json.load(json.ui.haoyouzhuzhan)
    frdBoss.searchIcon = DHSkeletonAnimation:createWithKey(json.ui.haoyouzhuzhan)
    frdBoss.searchIcon:scheduleUpdateLua()
    frdBoss.searchIcon:setPosition(303, 215)
    container:addChild(frdBoss.searchIcon)
    local timeLab = string.format("%02d:%02d:%02d", math.floor(0), math.floor(0), math.floor(0))
    frdBoss.showTimeLab = lbl.createFont2(16, "", ccc3(165, 253, 71))
    frdBoss.showTimeLab:setAnchorPoint(0, 0.5)
    frdBoss.showTimeLab:setPosition(319, 85)
    container:addChild(frdBoss.showTimeLab)
    frdBoss.recoverlab = lbl.createFont1(16, i18n.global.friendboss_next_search.string, ccc3(255, 246, 223))
    frdBoss.recoverlab:setAnchorPoint(1, 0.5)
    frdBoss.recoverlab:setPosition(CCPoint(frdBoss.showTimeLab:boundingBox():getMinX() - 10, 85))
    container:addChild(frdBoss.recoverlab)
    local bossIcon = nil
    if friendboss.scd == nil then
      initFrdboss()
    else
      if friendboss.scd == 0 then
        frdBoss.recoverlab:setVisible(false)
        frdBoss.showTimeLab:setVisible(false)
      else
        frdBoss.searchIcon:setVisible(true)
        frdBoss.searchmap:setVisible(true)
        frdBoss.searchBtn:setVisible(true)
        frdBoss.searchBtn:setEnabled(false)
        setShader(frdBoss.searchBtn, SHADER_GRAY, true)
      end
    end
    frdBoss.searchBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      local gParams = {sid = player.sid}
      frdBoss.searchIcon:playAnimation("animation")
      do
        local ban = CCLayer:create()
        ban:setTouchEnabled(true)
        ban:setTouchSwallowEnabled(true)
        layer:addChild(ban, 1000)
        layer:runAction(createSequence({}))
        schedule(layer, 1, function()
        addWaitNet()
        net:frd_boss_search(gParams, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          if l_1_0.status == -2 then
            showToast(i18n.global.toast_frdboss_notdie.string)
            return 
          elseif l_1_0.status == -3 then
            showToast(i18n.global.event_processing.string)
            return 
          end
          if l_1_0.status == -1 then
            return 
          end
          if l_1_0.status ~= 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            return 
          end
          if l_1_0.id then
            frdBoss.searchBtn:setVisible(false)
            frdBoss.searchIcon:setVisible(false)
            frdBoss.searchmap:setVisible(false)
            createBoss(l_1_0.id, 100)
            local achieveData = require("data.achieve")
            achieveData.add(ACHIEVE_TYPE_FRDBOSS, 1)
            friendboss.scd = nil
          else
            friendboss.scd = 28800
            friendboss.pull_scd_time = os.time()
            frdBoss.recoverlab:setVisible(true)
            frdBoss.showTimeLab:setVisible(true)
            if l_1_0.reward.equips then
              bag.equips.addAll(l_1_0.reward.equips)
              local pop = createPopupPieceBatchSummonResult("equip", l_1_0.reward.equips[1].id, l_1_0.reward.equips[1].num)
              layer:addChild(pop, 100)
            end
            if l_1_0.reward.items then
              bag.items.addAll(l_1_0.reward.items)
              local pop = createPopupPieceBatchSummonResult("item", l_1_0.reward.items[1].id, l_1_0.reward.items[1].num)
              layer:addChild(pop, 100)
            end
            setShader(frdBoss.searchBtn, SHADER_GRAY, true)
            frdBoss.searchBtn:setEnabled(false)
          end
            end)
         end)
      end
       -- Warning: undefined locals caused missing assignments!
      end)
   end
  local setTabstatus = function()
    listTab:setEnabled(currentTab ~= TAB.LIST)
    findTab:setEnabled(currentTab ~= TAB.FIND)
    applyTab:setEnabled(currentTab ~= TAB.APPL)
    npcTab:setEnabled(currentTab ~= TAB.NPC)
    inputFind:setVisible(currentTab == TAB.FIND)
   end
  showFriends = function()
    setTabstatus()
    if currentTab == TAB.LIST then
      showList()
    else
      if currentTab == TAB.FIND then
        showFind()
      else
        if currentTab == TAB.APPL then
          showApply()
        else
          showNPC()
        end
      end
    end
   end
  listTab:registerScriptTapHandler(function()
    audio.play(audio.button)
    upvalue_512 = TAB.LIST
    showFriends()
   end)
  findTab:registerScriptTapHandler(function()
    audio.play(audio.button)
    upvalue_512 = TAB.FIND
    showFriends()
   end)
  applyTab:registerScriptTapHandler(function()
    audio.play(audio.button)
    upvalue_512 = TAB.APPL
    showFriends()
   end)
  npcTab:registerScriptTapHandler(function()
    audio.play(audio.button)
    if player.lv() < 36 then
      showToast(string.format(i18n.global.func_need_lv.string, 36))
      return 
    end
    upvalue_1536 = TAB.NPC
    showFriends()
   end)
  local backEvent = function()
    audio.play(audio.button)
    if uiParams and uiParams.from_layer == "task" then
      replaceScene(require("ui.town.main").create({from_layer = "task"}))
    else
      layer:removeFromParentAndCleanup()
    end
   end
  local close0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, close0)
  closeBtn:setPosition(CCPoint(654, 486))
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  board:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    backEvent()
   end)
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_20_0, l_20_1)
    touchbeginx, upvalue_512 = l_20_0, l_20_1
    upvalue_1024 = true
    if enegyBottom and currentTab == TAB.LIST then
      local p0 = enegyBottom:convertToNodeSpace(ccp(l_20_0, l_20_1))
      if p0 and enegyIcon:boundingBox():containsPoint(p0) then
        upvalue_3584 = true
        audio.play(audio.button)
        enegyToast:setVisible(true)
        upvalue_5120 = enegyIcon
        last_touch_sprite._scale = 0.8
        playAnimTouchBegin(last_touch_sprite)
      end
    end
    return true
   end
  local onTouchMoved = function(l_21_0, l_21_1)
    return true
   end
  local onTouchEnded = function(l_22_0, l_22_1)
    if isclick and enegyFlag == true then
      upvalue_512 = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        playAnimTouchEnd(last_touch_sprite)
        upvalue_1024 = nil
      end
      enegyToast:setVisible(false)
    end
   end
  local onTouch = function(l_23_0, l_23_1, l_23_2)
    if l_23_0 == "began" then
      return onTouchBegan(l_23_1, l_23_2)
    elseif l_23_0 == "moved" then
      return onTouchMoved(l_23_1, l_23_2)
    else
      return onTouchEnded(l_23_1, l_23_2)
    end
   end
  layer:registerScriptTouchHandler(function()
    return true
   end)
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  layer:setTouchEnabled(true)
  layer.onAndroidBack = function()
    backEvent()
   end
  addBackEvent(layer)
  local onEnter = function()
    layer.notifyParentLock()
    init(showFriends)
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_28_0)
    if l_28_0 == "enter" then
      onEnter()
    elseif l_28_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui


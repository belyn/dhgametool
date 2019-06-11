-- Command line was: E:\github\dhgametool\scripts\ui\skin\main.lua 

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
local heros = require("data.heros")
local cfgvip = require("config.vip")
local bag = require("data.bag")
local player = require("data.player")
local cfgherBag = require("config.herobag")
local cfgequip = require("config.equip")
local cfgitem = require("config.item")
local tipsitem = require("ui.tips.item")
local tipsequip = require("ui.tips.equip")
local tipsforge = require("ui.skin.forgetips")
local tipsskin = require("ui.tips.skin")
local createPopupPieceBatchSummonResult = function(l_1_0, l_1_1)
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
  backBtn:setPosition(CCPoint(dialog.board:getContentSize().width / 2, 65))
  local menu = CCMenu:createWithItem(backBtn)
  menu:setPosition(0, 0)
  dialog.board:addChild(menu)
  dialog.board.tipsTag = false
  local x = dialog.board:getContentSize().width / 2
  local y = 180
  local skinhead = img.createSkinIcon(l_1_0)
  local skinheadBtn = CCMenuItemSprite:create(skinhead, nil)
  skinheadBtn:setScale(0.7)
  skinheadBtn:setPosition(x, y)
  if cfgequip[l_1_0].powerful and cfgequip[l_1_0].powerful == 1 then
    local framBg = img.createUISprite(img.ui.skin_frame_sp)
    framBg:setScale(0.7)
    framBg:setPosition(x, y)
    dialog.board:addChild(framBg, 1)
  else
    local framBg = img.createUISprite(img.ui.skin_frame)
    framBg:setScale(0.7)
    framBg:setPosition(x, y)
    dialog.board:addChild(framBg, 1)
  end
  local groupBg = img.createUISprite(img.ui.skin_circle)
  groupBg:setPosition(x - 43, y + 61)
  dialog.board:addChild(groupBg, 1)
  local groupIcon = img.createUISprite(img.ui.herolist_group_" .. cfghero[cfgequip[l_1_0].heroId[1]].grou)
  groupIcon:setScale(0.48)
  groupIcon:setPosition(x - 43, y + 61)
  dialog.board:addChild(groupIcon, 1)
  local iconMenu = CCMenu:createWithItem(skinheadBtn)
  iconMenu:setPosition(0, 0)
  dialog.board:addChild(iconMenu)
  skinheadBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    dialog:addChild(require("ui.skin.preview").create(id, i18n.equip[id].name), 10000)
   end)
  backBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    dialog:removeFromParentAndCleanup()
   end)
  return dialog
end

ui.create = function(l_2_0)
  local layer = CCLayer:create()
  layer.needFresh = false
  if not l_2_0 then
    local params = {}
  end
  local bg = img.createUISprite(img.ui.bag_bg)
  bg:setScale(view.minScale)
  bg:setPosition(view.midX, view.midY)
  layer:addChild(bg)
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
    if not params.back then
      replaceScene(require("ui.town.main").create())
    else
      if params.back == "hook" then
        replaceScene(require("ui.hook.map").create())
      end
    end
   end)
  autoLayoutShift(btnBack)
  local title = lbl.createFont2(30, i18n.global.main_skinlist_title.string, ccc3(250, 216, 105))
  title:setScale(view.minScale)
  title:setPosition(scalep(480, 545))
  layer:addChild(title, 100)
  local showHeroLayer = nil
  local model = params.model or "Skin"
  local sortType = nil
  local group = params.group
  local board = img.createUISprite(img.ui.herolist_bg)
  board:setScale(view.minScale)
  board:setPosition(scalep(467, 272))
  layer:addChild(board)
  local btnHeroSprite0 = img.createUISprite(img.ui.skin_select1)
  local btnHeroSprite1 = img.createUISprite(img.ui.skin_select0)
  local btnHero = CCMenuItemSprite:create(btnHeroSprite0, btnHeroSprite1, btnHeroSprite0)
  local btnHeroMenu = CCMenu:createWithItem(btnHero)
  btnHero:setPosition(847, 334)
  btnHeroMenu:setPosition(0, 0)
  board:addChild(btnHeroMenu, 10)
  local btnSkinpieceSprite0 = img.createUISprite(img.ui.skin_piece_select1)
  local btnSkinpieceSprite1 = img.createUISprite(img.ui.skin_piece_select0)
  local btnSkinpiece = CCMenuItemSprite:create(btnSkinpieceSprite0, btnSkinpieceSprite1, btnSkinpieceSprite0)
  local btnSkinpieceMenu = CCMenu:createWithItem(btnSkinpiece)
  btnSkinpiece:setPosition(847, 240)
  btnSkinpieceMenu:setPosition(0, 0)
  board:addChild(btnSkinpieceMenu, 10)
  local btnBookSprite0 = img.createUISprite(img.ui.skin_book_select1)
  local btnBookSprite1 = img.createUISprite(img.ui.skin_book_select0)
  local btnBook = CCMenuItemSprite:create(btnBookSprite0, btnBookSprite1, btnBookSprite0)
  local btnBookMenu = CCMenu:createWithItem(btnBook)
  btnBook:setPosition(847, 146)
  btnBookMenu:setPosition(0, 0)
  board:addChild(btnBookMenu, 10)
  local btnGroupList = {}
  local getDataAndCreateList = nil
  if model == "Skin" then
    btnHero:selected()
  elseif model == "Piece" then
    btnSkinpiece:selected()
  else
    btnBook:selected()
  end
  btnHero:registerScriptTapHandler(function()
    audio.play(audio.button)
    if model ~= "Skin" then
      btnHero:setEnabled(false)
      btnSkinpiece:setEnabled(true)
      btnBook:setEnabled(true)
      title:setString(i18n.global.main_skinlist_title.string)
      btnHero:selected()
      btnSkinpiece:unselected()
      btnBook:unselected()
      upvalue_512 = "Skin"
      for i = 1, 6 do
        btnGroupList[i]:setVisible(true)
      end
      if group then
        btnGroupList[group]:unselected()
        upvalue_4096 = nil
      end
      getDataAndCreateList()
    end
   end)
  btnSkinpiece:registerScriptTapHandler(function()
    audio.play(audio.button)
    if model ~= "Piece" then
      btnHero:setEnabled(true)
      btnBook:setEnabled(true)
      btnSkinpiece:setEnabled(false)
      title:setString(i18n.global.main_skinpiece_title.string)
      btnHero:unselected()
      btnSkinpiece:selected()
      btnBook:unselected()
      upvalue_512 = "Piece"
      if group then
        btnGroupList[group]:unselected()
        upvalue_3584 = nil
      end
      for i = 1, 6 do
        btnGroupList[i]:setVisible(false)
      end
      getDataAndCreateList()
    end
   end)
  btnBook:registerScriptTapHandler(function()
    audio.play(audio.button)
    if model ~= "Book" then
      btnHero:setEnabled(true)
      btnBook:setEnabled(false)
      btnSkinpiece:setEnabled(true)
      title:setString(i18n.global.main_skinbook_title.string)
      btnHero:unselected()
      btnSkinpiece:unselected()
      btnBook:selected()
      upvalue_512 = "Book"
      if group then
        btnGroupList[group]:unselected()
        upvalue_3584 = nil
      end
      for i = 1, 6 do
        btnGroupList[i]:setVisible(true)
      end
      getDataAndCreateList()
    end
   end)
  for i = 1, 6 do
    do
      local btnGroupSpriteFg = img.createUISprite(img.ui.herolist_group_" .. )
      local btnGroupSpriteBg = img.createUISprite(img.ui.herolist_group_bg)
      btnGroupSpriteFg:setPosition(btnGroupSpriteBg:getContentSize().width / 2, btnGroupSpriteBg:getContentSize().height / 2 + 2)
      btnGroupSpriteBg:addChild(btnGroupSpriteFg)
      btnGroupList[i] = HHMenuItem:createWithScale(btnGroupSpriteBg, 1)
      local btnGroupMenu = CCMenu:createWithItem(btnGroupList[i])
      btnGroupMenu:setPosition(0, 0)
      board:addChild(btnGroupMenu, 10)
      btnGroupList[i]:setPosition(183 + 66 * i, 460)
      local showSelect = img.createUISprite(img.ui.herolist_select_icon)
      showSelect:setPosition(btnGroupList[i]:getContentSize().width / 2, btnGroupList[i]:getContentSize().height / 2 + 2)
      btnGroupList[i]:addChild(showSelect)
      btnGroupList[i].showSelect = showSelect
      showSelect:setVisible(false)
      btnGroupList[i]:registerScriptTapHandler(function()
        audio.play(audio.button)
        for j = 1, 6 do
          btnGroupList[j]:unselected()
          btnGroupList[j].showSelect:setVisible(false)
        end
        if not group or i ~= group then
          upvalue_1024 = i
          btnGroupList[i]:selected()
          btnGroupList[i].showSelect:setVisible(true)
        else
          upvalue_1024 = nil
        end
        getDataAndCreateList()
         end)
    end
  end
  if group then
    btnGroupList[group]:selected()
    btnGroupList[group].showSelect:setVisible(true)
  end
  local onClickPieceForge = function(l_6_0)
    if layer.tipsTag then
      layer.tips:removeFromParent()
      layer.tipsTag = false
    end
    if layer.tipssTag then
      if layer.tipss then
        layer.tipss:removeFromParent()
        layer.tipss = nil
      end
      layer.tipssTag = false
    end
    local costCount = cfgitem[l_6_0.id].equip.count
    local forgeNum = math.floor(l_6_0.num / costCount)
    local param = {}
    param.sid = player.sid
    param.item_id = l_6_0.id
    param.num = forgeNum * costCount
    tbl2string(param)
    addWaitNet()
    net:hero_skin_mix(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. l_1_0.status)
        return 
      end
      for i = 1, #l_1_0.skin do
        bag.equips.add(l_1_0.skin[i])
      end
      bag.items.sub({id = piece.id, num = forgeNum * costCount})
      getDataAndCreateList()
      if #l_1_0.skin == 1 and l_1_0.skin[1].num == 1 then
        local pop = createPopupPieceBatchSummonResult(l_1_0.skin[1].id, 1)
        layer:addChild(pop, 1000)
      else
        bg:getParent():addChild(require("ui.skin.skinshow").create(l_1_0.skin, i18n.global.spesummon_gain.string), 1000)
      end
      end)
   end
  local onClickPieceFoegeShow = function(l_7_0)
    if layer.tipsTag then
      layer.tips:removeFromParent()
      layer.tipsTag = false
    end
    layer.tipssTag = true
    layer.tipss = tipsforge.create("items", l_7_0, onClickPieceForge)
    layer:addChild(layer.tipss, 1000)
   end
  local createPieceList = function(l_8_0)
    local curlayer = CCLayer:create()
    local SCROLLVIEW_WIDTH = 710
    local SCROLLVIEW_HEIGHT = 411
    local SCROLLCONTENT_HEIGHT = 23 + 100 * math.ceil(#l_8_0 / 7)
    local scroll = CCScrollView:create()
    scroll:setDirection(kCCScrollViewDirectionVertical)
    scroll:setAnchorPoint(ccp(0, 0))
    scroll:setPosition(66, 29)
    scroll:setViewSize(CCSize(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT))
    scroll:setContentSize(CCSize(SCROLLVIEW_WIDTH, SCROLLCONTENT_HEIGHT))
    scroll:setContentOffset(ccp(0, SCROLLVIEW_HEIGHT - SCROLLCONTENT_HEIGHT))
    curlayer:addChild(scroll)
    local headIcons = {}
    local createItem = function(l_1_0, l_1_1)
      local y, x = SCROLLCONTENT_HEIGHT - math.ceil(l_1_0 / 7) * 118 + 55, (l_1_0 - math.ceil(l_1_0 / 7) * 7 + 7) * 101 - 49
      headIcons[l_1_0] = img.createItem(pieces[l_1_0].id)
      headIcons[l_1_0]:setPosition(x, y)
      scroll:getContainer():addChild(headIcons[l_1_0])
      headIcons[l_1_0].data = pieces[l_1_0]
      local progressBg = img.createUISprite(img.ui.bag_heropiece_progr)
      progressBg:setPosition(x, y - 55)
      scroll:getContainer():addChild(progressBg)
      local progressFgSprite = nil
      local costCount = cfgitem[pieces[l_1_0].id].equip.count
      if pieces[l_1_0].num < costCount then
        progressFgSprite = img.createUISprite(img.ui.bag_heropiece_progr_0)
      else
        progressFgSprite = img.createUISprite(img.ui.bag_heropiece_progr_1)
      end
      local progressFg = createProgressBar(progressFgSprite)
      progressFg:setPosition(x, y - 55)
      progressFg:setPercentage(pieces[l_1_0].num / costCount * 100)
      scroll:getContainer():addChild(progressFg)
      local str = string.format("%d/%d", pieces[l_1_0].num, costCount)
      local label = lbl.createFont2(14, str, ccc3(255, 246, 223))
      label:setPosition(x, y - 55)
      scroll:getContainer():addChild(label)
      end
    for i,v in ipairs(l_8_0) do
      createItem(i, v)
    end
    if #l_8_0 == 0 then
      local empty = require("ui.empty").create({text = i18n.global.skin_nopiece.string, color = ccc3(217, 187, 157)})
      empty:setPosition(board:getContentSize().width / 2, board:getContentSize().height / 2)
      curlayer:addChild(empty)
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
      local pointOnBoard = curlayer:convertToNodeSpace(ccp(l_4_0, l_4_1))
      if math.abs(l_4_1 - lasty) > 10 or not scroll:boundingBox():containsPoint(pointOnBoard) then
        return true
      end
      local point = scroll:getContainer():convertToNodeSpace(ccp(l_4_0, l_4_1))
      for i,v in ipairs(headIcons) do
        if v:boundingBox():containsPoint(point) then
          layer.tipsTag = true
          audio.play(audio.button)
          if v.data.id == ITEM_ID_PIECE_SKIN then
            local costCount = math.floor(v.data.num / cfgitem[v.data.id].equip.count)
            if costCount == 0 then
              layer.tips = tipsitem.createForShow(v.data)
            elseif costCount <= 1 then
              layer.tips = tipsitem.createForBag(v.data, onClickPieceForge)
            else
              layer.tips = tipsskin.create("items", v.data, onClickPieceForge)
            end
          else
            local costCount = math.floor(v.data.num / cfgitem[v.data.id].equip.count)
            if costCount <= 1 then
              layer.tips = tipsitem.createForBag(v.data, onClickPieceForge)
            else
              layer.tips = tipsitem.createForBag(v.data, onClickPieceFoegeShow)
            end
          end
          layer:addChild(layer.tips, 1000)
          layer.tips.setClickBlankHandler(function()
            layer.tips:removeFromParent()
            layer.tipsTag = false
               end)
      else
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
    curlayer:registerScriptTouchHandler(onTouch)
    curlayer:setTouchEnabled(true)
    return curlayer
   end
  local onClickSkinBreakdown = function(l_9_0)
    audio.play(audio.button)
    if layer.tipsTag then
      layer.tips:removeFromParent()
      layer.tipsTag = false
    end
    if layer.tipssTag then
      if layer.tipss then
        layer.tipss:removeFromParent()
        layer.tipss = nil
      end
      layer.tipssTag = false
    end
    local params = {}
    params.btn_count = 0
    params.title = string.format(i18n.global.skinbreak_title.string, 20)
    params.board_w = 504
    params.board_h = 350
    local dialoglayer = require("ui.dialog").create(params)
    local lbl_body = lbl.createMix({font = 1, size = 18, text = string.format(i18n.global.skinbreak_sure.string, 20), color = ccc3(120, 70, 39), width = 400, align = kCCTextAlignmentLeftt})
    lbl_body:setAnchorPoint(CCPoint(0.5, 1))
    lbl_body:setPosition(CCPoint(params.board_w / 2, params.board_h - 85))
    dialoglayer.board:addChild(lbl_body)
    local item = img.createItem(ITEM_ID_PIECE_SKIN, 5)
    local btnItem = CCMenuItemSprite:create(item, nil)
    local menu = CCMenu:createWithItem(btnItem)
    menu:setPosition(0, 0)
    dialoglayer.board:addChild(menu)
    btnItem:setPosition(params.board_w / 2, 162)
    btnItem:registerScriptTapHandler(function()
      local tips = require("ui.tips.item").createForShow({id = ITEM_ID_PIECE_SKIN, num = 5})
      dialoglayer:addChild(tips, 100)
      end)
    local btnYesSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnYesSprite:setPreferredSize(CCSize(153, 50))
    local btnYes = SpineMenuItem:create(json.ui.button, btnYesSprite)
    btnYes:setPosition(params.board_w / 2 + 95, 74)
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
    btnNo:setPosition(params.board_w / 2 - 95, 74)
    local labNo = lbl.createFont1(18, i18n.global.board_confirm_no.string, ccc3(115, 59, 5))
    labNo:setPosition(btnNo:getContentSize().width / 2, btnNo:getContentSize().height / 2)
    btnNoSprite:addChild(labNo)
    local menuNo = CCMenu:create()
    menuNo:setPosition(0, 0)
    menuNo:addChild(btnNo)
    dialoglayer.board:addChild(menuNo)
    btnYes:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      audio.play(audio.button)
      local param = {}
      param.sid = player.sid
      param.skin_id = skin.id
      tbl2string(param)
      addWaitNet()
      net:hero_skin_breakdown(param, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. l_1_0.status)
          return 
        end
        bag.equips.sub({id = skin.id, num = 1})
        bag.items.add({id = ITEM_ID_PIECE_SKIN, num = 5})
        getDataAndCreateList()
        local reward = {}
        reward.items = {}
        reward.items[#reward.items + 1] = {id = ITEM_ID_PIECE_SKIN, num = 5}
        layer:addChild(require("ui.tips.reward").create(reward), 1000)
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
    dialoglayer:registerScriptHandler(function(l_8_0)
      if l_8_0 == "enter" then
        onEnter()
      elseif l_8_0 == "exit" then
        onExit()
      end
      end)
    return dialoglayer
   end
  local createHeroList = function(l_10_0)
    local curlayer = CCLayer:create()
    local SCROLLVIEW_WIDTH = 710
    local SCROLLVIEW_HEIGHT = 411
    local SCROLLCONTENT_HEIGHT = 23 + 174 * math.ceil(#l_10_0 / 5)
    local scroll = CCScrollView:create()
    scroll:setDirection(kCCScrollViewDirectionVertical)
    scroll:setAnchorPoint(ccp(0, 0))
    scroll:setPosition(66, 29)
    scroll:setViewSize(CCSize(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT))
    scroll:setContentSize(CCSize(SCROLLVIEW_WIDTH, SCROLLCONTENT_HEIGHT))
    scroll:setContentOffset(ccp(0, SCROLLVIEW_HEIGHT - SCROLLCONTENT_HEIGHT))
    curlayer:addChild(scroll)
    local headIcons = {}
    local createItem = function(l_1_0, l_1_1)
      local y, x = SCROLLCONTENT_HEIGHT - math.ceil(l_1_0 / 5) * 174 + 70, (l_1_0 - math.ceil(l_1_0 / 5) * 5 + 5) * 140 - 65
      headIcons[l_1_0] = img.createSkinIcon(skinlist[l_1_0].id)
      headIcons[l_1_0]:setPosition(x, y)
      headIcons[l_1_0]:setScale(0.7)
      scroll:getContainer():addChild(headIcons[l_1_0])
      headIcons[l_1_0].data = skinlist[l_1_0]
      local bgsize = (headIcons[l_1_0]:getContentSize())
      local framBg = nil
      if cfgequip[skinlist[l_1_0].id].powerful and cfgequip[skinlist[l_1_0].id].powerful == 1 then
        framBg = img.createUISprite(img.ui.skin_frame_sp)
      else
        framBg = img.createUISprite(img.ui.skin_frame)
      end
      framBg:setPosition(bgsize.width / 2, bgsize.height / 2)
      headIcons[l_1_0]:addChild(framBg)
      local groupBg = img.createUISprite(img.ui.skin_circle)
      groupBg:setPosition(x - 43, y + 61)
      scroll:getContainer():addChild(groupBg)
      local groupIcon = img.createUISprite(img.ui.herolist_group_" .. cfghero[cfgequip[skinlist[l_1_0].id].heroId[1]].grou)
      groupIcon:setScale(0.48)
      groupIcon:setPosition(x - 43, y + 61)
      scroll:getContainer():addChild(groupIcon, 1)
      if skinlist[l_1_0].flag == false then
        local blackBoard = img.createUISprite(img.ui.skin_black)
        blackBoard:setScale(0.7)
        blackBoard:setOpacity(120)
        blackBoard:setPosition(headIcons[l_1_0]:getPositionX(), headIcons[l_1_0]:getPositionY())
        scroll:getContainer():addChild(blackBoard, 0, l_1_0)
        local tickIcon = img.createUISprite(img.ui.login_month_finish)
        tickIcon:setPosition(x + 35, y + 52)
        scroll:getContainer():addChild(tickIcon, 2)
      end
      end
    local initShowCount = 60
    for i,v in ipairs(l_10_0) do
      if initShowCount < i then
        do return end
      end
      createItem(i, v)
    end
    local skinCount = #l_10_0
    local showAfter = function()
      if initShowCount < skinCount then
        initShowCount = initShowCount + 1
        createItem(initShowCount, skinlist[initShowCount])
        return true
      end
      end
    if skinCount == 0 then
      local empty = require("ui.empty").create({text = i18n.global.skin_noskin.string, color = ccc3(217, 187, 157)})
      empty:setPosition(board:getContentSize().width / 2, board:getContentSize().height / 2)
      curlayer:addChild(empty)
    elseif initShowCount < skinCount then
      curlayer:scheduleUpdateWithPriorityLua(function(l_3_0)
      if showAfter() and showAfter() then
        showAfter()
      end
      end, 0)
    end
    local lasty = nil
    local onTouchBegin = function(l_4_0, l_4_1)
      lasty = l_4_1
      return true
      end
    local onTouchMoved = function(l_5_0, l_5_1)
      return true
      end
    local onTouchEnd = function(l_6_0, l_6_1)
      local pointOnBoard = curlayer:convertToNodeSpace(ccp(l_6_0, l_6_1))
      if math.abs(l_6_1 - lasty) > 10 or not scroll:boundingBox():containsPoint(pointOnBoard) then
        return true
      end
      local point = scroll:getContainer():convertToNodeSpace(ccp(l_6_0, l_6_1))
      do
        for i,v in ipairs(headIcons) do
          do
            if v:boundingBox():containsPoint(point) then
              audio.play(audio.button)
              layer.tipsTag = true
              if model == "Skin" then
                layer.tips = tipsequip.createForSkin(v.data, function()
                if layer.tipsTag then
                  layer.tips:removeFromParent()
                  layer.tipsTag = false
                end
                bg:getParent():addChild(require("ui.skin.preview").create(v.data.id, i18n.equip[v.data.id].name), 10000)
                     end, function()
                local sureBreakdown = onClickSkinBreakdown(v.data)
                bg:getParent():addChild(sureBreakdown, 10000)
                     end)
              else
                layer.tips = tipsequip.createForSkin(v.data, function()
                if layer.tipsTag then
                  layer.tips:removeFromParent()
                  layer.tipsTag = false
                end
                bg:getParent():addChild(require("ui.skin.preview").create(v.data.id, i18n.equip[v.data.id].name), 10000)
                     end)
              end
              layer:addChild(layer.tips, 1000)
              layer.tips.setClickBlankHandler(function()
                if layer.tipsTag then
                  layer.tips:removeFromParent()
                  layer.tipsTag = false
                end
                     end)
          else
            end
          end
        end
      end
      return true
      end
    local onTouch = function(l_7_0, l_7_1, l_7_2)
      if l_7_0 == "began" then
        return onTouchBegin(l_7_1, l_7_2)
      elseif l_7_0 == "moved" then
        return onTouchMoved(l_7_1, l_7_2)
      else
        return onTouchEnd(l_7_1, l_7_2)
      end
      end
    curlayer:registerScriptTouchHandler(onTouch)
    curlayer:setTouchEnabled(true)
    return curlayer
   end
  getDataAndCreateList = function()
    local skinlist = {}
    if model == "Skin" then
      skinlist = bag.equips.skin(group)
      for _,v in ipairs(heros) do
        if not group or cfghero[v.id].group == group then
          for i,vv in ipairs(v.equips) do
            if cfgequip[vv].pos == EQUIP_POS_SKIN then
              skinlist[#skinlist + 1] = {id = vv, num = 1, flag = false}
            end
          end
        end
      end
      if showHeroLayer then
        showHeroLayer:removeFromParentAndCleanup(true)
        upvalue_3072 = nil
      end
      upvalue_3072 = createHeroList(skinlist)
      board:addChild(showHeroLayer)
    elseif model == "Piece" then
      local pieces = {}
      for _,v in ipairs(bag.items) do
        if cfgitem[v.id].type == 9 then
          pieces[#pieces + 1] = v
        end
      end
      if showHeroLayer then
        showHeroLayer:removeFromParentAndCleanup(true)
        upvalue_3072 = nil
      end
      upvalue_3072 = createPieceList(pieces)
      board:addChild(showHeroLayer)
    else
      for _,v in pairs(cfgequip) do
        if v.pos == EQUIP_POS_SKIN and (not group or cfghero[v.heroId[1]].group == group) then
          skinlist[#skinlist + 1] = {id = _, num = 1}
        end
      end
      if showHeroLayer then
        showHeroLayer:removeFromParentAndCleanup(true)
        upvalue_3072 = nil
      end
      upvalue_3072 = createHeroList(skinlist)
      board:addChild(showHeroLayer)
    end
   end
  getDataAndCreateList()
  layer:scheduleUpdateWithPriorityLua(function()
    if layer.needFresh == true then
      layer.needFresh = false
      getDataAndCreateList()
    end
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    if not params.back then
      replaceScene(require("ui.town.main").create())
    else
      if params.back == "hook" then
        replaceScene(require("ui.hook.map").create())
      end
    end
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_16_0)
    if l_16_0 == "enter" then
      onEnter()
    elseif l_16_0 == "exit" then
      onExit()
    end
   end)
  require("ui.tutorial").show("ui.hero.main", layer)
  return layer
end

return ui


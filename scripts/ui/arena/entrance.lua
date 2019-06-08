-- Command line was: E:\github\dhgametool\scripts\ui\arena\entrance.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local player = require("data.player")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local dialog = require("ui.dialog")
local net = require("net.netClient")
local arena = require("data.arena")
local arena33 = require("data.3v3arena")
local frdarenaData = require("data.frdarena")
local getItems = function()
  return {1 = {id = 1, icon = img.ui.friend_pvp_icon_putong, description = i18n.arena[1].name}, 2 = {id = 2, icon = img.ui.friend_pvp_icon, description = i18n.arena[2].name}, 3 = {id = 4, icon = img.ui.friend_pvp_icon_zudui, description = i18n.arena[4].name}}
end

ui.create = function(l_2_0)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local kind = l_2_0 or 1
  local all_items = getItems()
  local activity_items = {}
  local touch_items = {}
  local item_count = 0
  local padding = 5
  local item_width = 290
  local item_height = 70
  local init = function()
    local groups = {}
    for _,tmp_item in pairs(all_items) do
    end
   end
  init()
  local bg = img.createUI9Sprite(img.ui.dialog_2)
  bg:setPreferredSize(CCSizeMake(905, 462))
  bg:setScale(view.minScale)
  bg:setPosition(CCPoint(view.midX, view.midY - 20 * view.minScale))
  layer:addChild(bg)
  local bg_w = bg:getContentSize().width
  local bg_h = bg:getContentSize().height
  local ltitle = img.createUISprite(img.ui.friend_pvp_biaotiban)
  ltitle:setAnchorPoint(1, 0)
  ltitle:setPosition(bg_w / 2, bg_h - 5)
  bg:addChild(ltitle)
  local rtitle = img.createUISprite(img.ui.friend_pvp_biaotiban)
  rtitle:setFlipX(true)
  rtitle:setAnchorPoint(0, 0)
  rtitle:setPosition(bg_w / 2, bg_h - 5)
  bg:addChild(rtitle)
  local lblTitil = lbl.createFont1(24, i18n.global.town_building_arena.string, ccc3(250, 216, 105))
  lblTitil:setPosition(bg_w / 2, bg_h + 20)
  bg:addChild(lblTitil)
  local scroll_bg = img.createUI9Sprite(img.ui.inner_bg)
  scroll_bg:setPreferredSize(CCSizeMake(302, 398))
  scroll_bg:setAnchorPoint(CCPoint(0, 0))
  scroll_bg:setPosition(CCPoint(28, 36))
  bg:addChild(scroll_bg)
  local lineScroll = require("ui.lineScroll")
  local scroll_params = {width = 290, height = 390}
  local scroll = lineScroll.create(scroll_params)
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(5, 0))
  scroll_bg:addChild(scroll)
  layer.scroll = scroll
  local createItem = function(l_2_0)
    local tmp_item = img.createUISprite(img.ui.activity_item_bg)
    local tmp_item_w = tmp_item:getContentSize().width
    local tmp_item_h = tmp_item:getContentSize().height
    local tmp_item_sel = img.createUISprite(img.ui.activity_item_bg_sel)
    tmp_item_sel:setPosition(CCPoint(tmp_item_w / 2, tmp_item_h / 2))
    tmp_item:addChild(tmp_item_sel)
    tmp_item.sel = tmp_item_sel
    tmp_item_sel:setVisible(false)
    local item_icon = img.createUISprite(l_2_0.icon)
    item_icon:setPosition(CCPoint(40, tmp_item_h / 2))
    tmp_item:addChild(item_icon, 10)
    local lbl_description = lbl.create({font = 1, size = 16, text = l_2_0.description, color = ccc3(115, 59, 5), width = 200})
    lbl_description:setAnchorPoint(CCPoint(0, 0.5))
    lbl_description:setPosition(CCPoint(88, tmp_item_h / 2))
    tmp_item:addChild(lbl_description, 2)
    return tmp_item
   end
  local showList = function(l_3_0)
    for ii = 1,  l_3_0 do
      local tmp_item = createItem(l_3_0[ii])
      touch_items[ touch_items + 1] = tmp_item
      tmp_item.obj = l_3_0[ii]
      tmp_item.ax = 0.5
      tmp_item.px = 145
      scroll.addItem(tmp_item)
      if ii ~= item_count then
        scroll.addSpace(padding - 3)
      end
    end
   end
  showList(all_items)
  bg:setScale(0.5 * view.minScale)
  local anim_arr = CCArray:create()
  anim_arr:addObject(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  bg:runAction(CCSequence:create(anim_arr))
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(bg_w - 25, bg_h - 20))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_close_menu, 100)
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local nodeNormal = cc.Node:create()
  nodeNormal:setPosition(CCPoint(0, 0))
  nodeNormal:setVisible(false)
  bg:addChild(nodeNormal, 1)
  local node3v3 = cc.Node:create()
  node3v3:setPosition(CCPoint(0, 0))
  node3v3:setVisible(false)
  bg:addChild(node3v3, 1)
  local nodeFriends = cc.Node:create()
  nodeFriends:setPosition(CCPoint(0, 0))
  nodeFriends:setVisible(false)
  bg:addChild(nodeFriends, 1)
  local barBg = img.createUI9Sprite(img.ui.botton_fram_2)
  barBg:setPreferredSize(CCSizeMake(535, 155))
  barBg:setPosition(611, 110)
  bg:addChild(barBg)
  local upboard = img.createUI9Sprite(img.ui.hero_up_bottom)
  upboard:setPreferredSize(CCSize(550, 240))
  upboard:setPosition(611, 315)
  bg:addChild(upboard)
  local onShop = function()
    local shop = require("ui.arena.shop")
    layer:addChild(shop.create(), 1000)
   end
  if nodeNormal then
    local nodeBg = img.createUI9Sprite(img.ui.anrea_entrance_bg2)
    do
      nodeBg:setPosition(CCPoint(611, 315))
      nodeNormal:addChild(nodeBg)
      local lblDes = lbl.createMix({size = 16, text = i18n.arena[1].des, color = ccc3(115, 59, 5), width = 450})
      lblDes:setPosition(CCPoint(611, 150))
      nodeNormal:addChild(lblDes)
      local shopBg = img.createUI9Sprite(img.ui.friend_pvp_shopbg)
      shopBg:setAnchorPoint(1, 0)
      shopBg:setPosition(872, 201)
      nodeNormal:addChild(shopBg)
      local btn_shop0 = img.createUI9Sprite(img.ui.friend_pvp_shop)
      local btn_shop = SpineMenuItem:create(json.ui.button, btn_shop0)
      btn_shop:setPosition(CCPoint(838, 236))
      local btn_shop_menu = CCMenu:createWithItem(btn_shop)
      btn_shop_menu:setPosition(CCPoint(0, 0))
      nodeNormal:addChild(btn_shop_menu)
      btn_shop:registerScriptTapHandler(function()
        audio.play(audio.button)
        onShop()
         end)
      local btn_join0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
      btn_join0:setPreferredSize(CCSizeMake(176, 48))
      local btn_join_sel = img.createLogin9Sprite(img.login.button_9_small_gold)
      btn_join_sel:setPreferredSize(CCSizeMake(176, 48))
      btn_join_sel:setPosition(CCPoint(btn_join0:getContentSize().width / 2, btn_join0:getContentSize().height / 2))
      btn_join0:addChild(btn_join_sel)
      local lbl_join = lbl.createFont1(18, i18n.global.arena_btn_join.string, ccc3(115, 59, 5))
      lbl_join:setPosition(CCPoint(btn_join0:getContentSize().width / 2, btn_join0:getContentSize().height / 2))
      btn_join0:addChild(lbl_join)
      local btn_join = SpineMenuItem:create(json.ui.button, btn_join0)
      btn_join:setPosition(CCPoint(611, 83))
      local btn_join_menu = CCMenu:createWithItem(btn_join)
      btn_join_menu:setPosition(CCPoint(0, 0))
      nodeNormal:addChild(btn_join_menu)
      btn_join:registerScriptTapHandler(function()
        disableObjAWhile(btn_join)
        audio.play(audio.button)
        local params = {sid = player.sid}
        addWaitNet()
        net:joinpvp_sync(params, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          if l_1_0.status == -1 then
            layer:addChild(require("ui.selecthero.main").create({type = "ArenaDef"}), 1000)
            layer:addChild(require("ui.selecthero.info").create(), 10000)
          elseif l_1_0.status == -2 then
            showToast(i18n.global.event_processing.string)
          else
            local arenaData = require("data.arena")
            arenaData.init(l_1_0)
            replaceScene(require("ui.arena.main").create())
          end
            end)
         end)
    end
  end
  if node3v3 then
    local nodeBg = img.createUI9Sprite(img.ui.anrea_entrance_bg1)
    nodeBg:setPosition(CCPoint(611, 315))
    node3v3:addChild(nodeBg)
    local lblDes = lbl.createMix({size = 16, text = i18n.arena[2].des, color = ccc3(115, 59, 5), width = 520})
    lblDes:setPosition(CCPoint(611, 150))
    node3v3:addChild(lblDes)
    local shopBg = img.createUI9Sprite(img.ui.friend_pvp_shopbg)
    shopBg:setAnchorPoint(1, 0)
    shopBg:setPosition(872, 201)
    node3v3:addChild(shopBg)
    local btn_shop0 = img.createUI9Sprite(img.ui.friend_pvp_shop)
    local btn_shop = SpineMenuItem:create(json.ui.button, btn_shop0)
    btn_shop:setPosition(CCPoint(838, 236))
    local btn_shop_menu = CCMenu:createWithItem(btn_shop)
    btn_shop_menu:setPosition(CCPoint(0, 0))
    node3v3:addChild(btn_shop_menu)
    btn_shop:registerScriptTapHandler(function()
      audio.play(audio.button)
      onShop()
      end)
    local btn_join0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
    btn_join0:setPreferredSize(CCSizeMake(176, 48))
    local btn_join_sel = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn_join_sel:setPreferredSize(CCSizeMake(176, 48))
    btn_join_sel:setPosition(CCPoint(btn_join0:getContentSize().width / 2, btn_join0:getContentSize().height / 2))
    btn_join0:addChild(btn_join_sel)
    local lbl_join = lbl.createFont1(18, i18n.global.arena_btn_join.string, ccc3(115, 59, 5))
    lbl_join:setPosition(CCPoint(btn_join0:getContentSize().width / 2, btn_join0:getContentSize().height / 2))
    btn_join0:addChild(lbl_join)
    local btn_join = SpineMenuItem:create(json.ui.button, btn_join0)
    btn_join:setPosition(CCPoint(611, 83))
    local btn_join_menu = CCMenu:createWithItem(btn_join)
    btn_join_menu:setPosition(CCPoint(0, 0))
    node3v3:addChild(btn_join_menu)
    btn_join:registerScriptTapHandler(function()
      disableObjAWhile(btn_join)
      audio.play(audio.button)
      if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_ARENA_3v3_LEVEL then
        showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_ARENA_3v3_LEVEL))
        return 
      end
      local params = {sid = player.sid}
      addWaitNet()
      net:joinp3p_sync(net, params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status == -1 then
          layer:addChild(require("ui.3v3arena.select").create({type = "3v3arenaDef"}), 1000)
        elseif l_1_0.status == 0 then
          local arena3v3Data = require("data.3v3arena")
          arena3v3Data.init(l_1_0)
          replaceScene(require("ui.3v3arena.main").create())
        else
          local btn = layer.btnJoin3v3
          btn:setEnabled(false)
          setShader(btn, SHADER_GRAY, true)
        end
         end)
      end)
    btn_join:setEnabled(false)
    layer.btnJoin3v3 = btn_join
    setShader(btn_join, SHADER_GRAY, true)
    local refreshTime = lbl.createFont2(16, "00:00:00", ccc3(165, 253, 71))
    refreshTime:setAnchorPoint(0, 0.5)
    refreshTime:setPosition(623, 230)
    node3v3:addChild(refreshTime)
    layer.refreshTime = refreshTime
    local desLabel = lbl.createFont2(16, "", ccc3(255, 246, 216))
    desLabel:setAnchorPoint(1, 0.5)
    desLabel:setPosition(623, 230)
    node3v3:addChild(desLabel)
    layer.desLabel = desLabel
    local btn_rank0 = img.createUISprite(img.ui.btn_rank)
    local btn_rank = SpineMenuItem:create(json.ui.button, btn_rank0)
    btn_rank:setPosition(385, 230)
    local btn_rank_menu = CCMenu:createWithItem(btn_rank)
    btn_rank_menu:setPosition(CCPoint(0, 0))
    node3v3:addChild(btn_rank_menu)
    btn_rank:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:addChild(require("ui.3v3arena.rank").create(), 1000)
      end)
    layer.btn_rank = btn_rank
  end
  if nodeFriends then
    local nodeBg = img.createUI9Sprite(img.ui.anrea_entrance_bg3)
    nodeBg:setPosition(CCPoint(611, 315))
    nodeFriends:addChild(nodeBg)
    local lblDes = lbl.createMix({size = 16, text = i18n.arena[4].des, color = ccc3(115, 59, 5), width = 520})
    lblDes:setPosition(CCPoint(611, 150))
    nodeFriends:addChild(lblDes)
    local btn_join0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
    btn_join0:setPreferredSize(CCSizeMake(176, 48))
    local btn_join_sel = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn_join_sel:setPreferredSize(CCSizeMake(176, 48))
    btn_join_sel:setPosition(CCPoint(btn_join0:getContentSize().width / 2, btn_join0:getContentSize().height / 2))
    btn_join0:addChild(btn_join_sel)
    local lbl_join = lbl.createFont1(18, i18n.global.arena_btn_join.string, ccc3(115, 59, 5))
    lbl_join:setPosition(CCPoint(btn_join0:getContentSize().width / 2, btn_join0:getContentSize().height / 2))
    btn_join0:addChild(lbl_join)
    local btn_join = SpineMenuItem:create(json.ui.button, btn_join0)
    btn_join:setPosition(CCPoint(611, 83))
    local btn_join_menu = CCMenu:createWithItem(btn_join)
    btn_join_menu:setPosition(CCPoint(0, 0))
    nodeFriends:addChild(btn_join_menu)
    btn_join:registerScriptTapHandler(function()
      disableObjAWhile(btn_join)
      audio.play(audio.button)
      if BUILD_ENTRIES_ENABLE and player.lv() < UNLOCK_ARENA_FRIEND_LEVEL then
        showToast(string.format(i18n.global.func_need_lv.string, UNLOCK_ARENA_FRIEND_LEVEL))
        return 
      end
      local params = {sid = player.sid}
      addWaitNet()
      net:gpvp_sync(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        frdarenaData.init(l_1_0)
        if l_1_0.camp == nil then
          layer:addChild(require("ui.selecthero.main").create({type = "FrdArena"}), 1000)
          layer:addChild(require("ui.selecthero.info").create(), 10000)
        else
          replaceScene(require("ui.frdarena.main").create())
        end
         end)
      end)
    btn_join:setEnabled(false)
    layer.btnJoinFriend = btn_join
    setShader(btn_join, SHADER_GRAY, true)
    local refreshTime1 = lbl.createFont2(16, "00:00:00", ccc3(165, 253, 71))
    refreshTime1:setAnchorPoint(0, 0.5)
    refreshTime1:setPosition(623, 230)
    nodeFriends:addChild(refreshTime1)
    layer.refreshTime1 = refreshTime1
    local desLabel1 = lbl.createFont2(16, "", ccc3(255, 246, 216))
    desLabel1:setAnchorPoint(1, 0.5)
    desLabel1:setPosition(623, 230)
    nodeFriends:addChild(desLabel1)
    layer.desLabel1 = desLabel1
    local btn_rank0 = img.createUISprite(img.ui.btn_rank)
    local btn_rank = SpineMenuItem:create(json.ui.button, btn_rank0)
    btn_rank:setPosition(385, 230)
    local btn_rank_menu = CCMenu:createWithItem(btn_rank)
    btn_rank_menu:setPosition(CCPoint(0, 0))
    nodeFriends:addChild(btn_rank_menu)
    btn_rank:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer:addChild(require("ui.frdarena.rank").create(), 1000)
      end)
    layer.btn_rank1 = btn_rank
  end
  local onNormal = function()
    nodeNormal:setVisible(true)
    nodeFriends:setVisible(false)
    node3v3:setVisible(false)
   end
  local on3V3 = function()
    nodeNormal:setVisible(false)
    nodeFriends:setVisible(false)
    node3v3:setVisible(true)
   end
  local onFriends = function()
    nodeNormal:setVisible(false)
    node3v3:setVisible(false)
    nodeFriends:setVisible(true)
   end
  onNormal()
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
  layer:registerScriptHandler(function(l_20_0)
    if l_20_0 == "enter" then
      onEnter()
    elseif l_20_0 == "exit" then
      onExit()
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  local initData = function()
    local params = {sid = player.sid}
    addWaitNet()
    net:pvp_sync(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      layer.__data = l_1_0
      layer.startTime = os.time()
      arena.initTime(layer.__data.infos[1])
      arena33.initTime(layer.__data.infos[2])
      frdarenaData.initTime(layer.__data.infos[3])
      if not layer.isUpdateingFlag then
        layer.isUpdateingFlag = true
        if not layer or tolua.isnull(layer) then
          return 
        end
        layer:scheduleUpdateWithPriorityLua(function()
          local __data = layer.__data
          local startTime = layer.startTime
          local passTime = os.time() - startTime
          local remainCd = math.max(0, __data.infos[2].season_cd - passTime)
          layer.refreshTime:setString(time2string(remainCd))
          local remainCd1 = math.max(0, __data.infos[3].season_cd - passTime)
          layer.refreshTime1:setString(time2string(remainCd1))
          if remainCd <= 0 then
            layer:unscheduleUpdate()
            local anim_arr = CCArray:create()
            anim_arr:addObject(CCDelayTime:create(1))
            anim_arr:addObject(CCCallFunc:create(function()
              initData()
                  end))
            layer:runAction(CCSequence:create(anim_arr))
            return 
          end
          local desc = nil
          if __data.infos[2].status == 0 then
            desc = i18n.global.arena3v3_open_cd.string
            layer.btn_rank:setVisible(true)
          else
            desc = i18n.global.arena3v3_end_cd.string
            layer.btn_rank:setVisible(false)
          end
          if layer.desLabel:getString() ~= desc then
            layer.desLabel:setString(desc)
          end
          local btn = layer.btnJoin3v3
           -- DECOMPILER ERROR: unhandled construct in 'if'

          if btn:isEnabled() and __data.infos[2].status == 0 then
            btn:setEnabled(false)
            setShader(btn, SHADER_GRAY, true)
            do return end
            if __data.infos[2].status ~= 0 then
              btn:setEnabled(true)
              clearShader(btn, true)
            end
          end
          if remainCd1 <= 0 then
            layer:unscheduleUpdate()
            local anim_arr = CCArray:create()
            anim_arr:addObject(CCDelayTime:create(1))
            anim_arr:addObject(CCCallFunc:create(function()
              initData()
                  end))
            layer:runAction(CCSequence:create(anim_arr))
            return 
          end
          local desc = nil
          if __data.infos[3].status == 0 then
            desc = i18n.global.arena3v3_open_cd.string
            layer.btn_rank1:setVisible(true)
          else
            desc = i18n.global.arena3v3_end_cd.string
            layer.btn_rank1:setVisible(false)
          end
          if layer.desLabel1:getString() ~= desc then
            layer.desLabel1:setString(desc)
          end
          local btn = layer.btnJoinFriend
           -- DECOMPILER ERROR: unhandled construct in 'if'

          if btn:isEnabled() and __data.infos[3].status == 0 then
            btn:setEnabled(false)
            setShader(btn, SHADER_GRAY, true)
            do return end
            if __data.infos[3].status ~= 0 then
              btn:setEnabled(true)
              clearShader(btn, true)
            end
          end
            end)
      else
        layer:scheduleUpdate()
      end
      end)
   end
  initData()
  local touchbeginx, touchbeginy, isclick = nil, nil, nil
  local onTouchBegan = function(l_22_0, l_22_1)
    touchbeginx, upvalue_512 = l_22_0, l_22_1
    upvalue_1024 = true
    if not scroll or tolua.isnull(scroll) then
      return true
    end
    local p1 = scroll.content_layer:convertToNodeSpace(ccp(l_22_0, l_22_1))
    for ii = 1,  touch_items do
      if touch_items[ii]:boundingBox():containsPoint(p1) then
        playAnimTouchBegin(touch_items[ii])
        last_touch_sprite = touch_items[ii]
      end
    end
    return true
   end
  local onTouchMoved = function(l_23_0, l_23_1)
    if isclick and (math.abs(touchbeginx - l_23_0) > 10 or math.abs(touchbeginy - l_23_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        playAnimTouchEnd(last_touch_sprite)
        last_touch_sprite = nil
      end
    end
   end
  local onTouchEnded = function(l_24_0, l_24_1)
    if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
      playAnimTouchEnd(last_touch_sprite)
      last_touch_sprite = nil
    end
    local p0 = layer:convertToNodeSpace(ccp(l_24_0, l_24_1))
    if isclick and not bg:boundingBox():containsPoint(p0) then
      backEvent()
    elseif isclick then
      local p1 = scroll.content_layer:convertToNodeSpace(ccp(l_24_0, l_24_1))
      for ii = 1,  touch_items do
        if touch_items[ii]:boundingBox():containsPoint(p1) then
          if last_sel_sprite and last_sel_sprite == touch_items[ii] then
            return 
          elseif last_sel_sprite and not tolua.isnull(last_sel_sprite) and last_sel_sprite.sel and not tolua.isnull(last_sel_sprite.sel) then
            last_sel_sprite.sel:setVisible(false)
          end
          audio.play(audio.button)
          touch_items[ii].sel:setVisible(true)
          if ii == 1 then
            onNormal()
          elseif ii == 2 then
            on3V3()
          else
            onFriends()
          end
          last_sel_sprite = touch_items[ii]
        end
      end
    end
   end
  local onTouch = function(l_25_0, l_25_1, l_25_2)
    if l_25_0 == "began" then
      return onTouchBegan(l_25_1, l_25_2)
    elseif l_25_0 == "moved" then
      return onTouchMoved(l_25_1, l_25_2)
    else
      return onTouchEnded(l_25_1, l_25_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  if  touch_items > 0 then
    if touch_items[kind].sel and not tolua.isnull(touch_items[kind].sel) then
      touch_items[kind].sel:setVisible(true)
    end
    last_sel_sprite = touch_items[kind]
    if kind == 2 then
      on3V3()
    else
      onNormal()
    end
  end
  return layer
end

return ui


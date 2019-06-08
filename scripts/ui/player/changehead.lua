-- Command line was: E:\github\dhgametool\scripts\ui\player\changehead.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local player = require("data.player")
local net = require("net.netClient")
local oheadData = require("data.head")
local cfghead = require("config.head")
local audio = require("res.audio")
ui.create = function()
  local layer = CCLayerColor:create(ccc4(0, 0, 0, 210))
  local headData = oheadData
  local bagdata = require("data.bag")
  local itemHead = headData.getItemhead()
  for i,v in pairs(itemHead) do
    if not bagdata.items.find(i) then
      headData[v].hide = true
      for i,v in (for generator) do
      end
      headData[v].hide = nil
    end
    local hidePetHead = function()
      local cfgpet = require("config.pet")
      for k,v in pairs(cfgpet) do
        for ii = 1,  v.petIcon do
          if headData[v.petIcon[ii]] then
            headData[v.petIcon[ii]].hide = true
          end
        end
      end
      end
    hidePetHead()
    local board = img.createUI9Sprite(img.ui.tips_bg)
    board:setPreferredSize(CCSize(662, 450))
    board:setScale(view.minScale)
    board:setPosition(view.midX, view.midY)
    layer:addChild(board)
    local closeBtn0 = img.createUISprite(img.ui.close)
    local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
    closeBtn:setPosition(board:getContentSize().width - 20, board:getContentSize().height - 24)
    local closeMenu = CCMenu:createWithItem(closeBtn)
    closeMenu:setPosition(0, 0)
    board:addChild(closeMenu)
    closeBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      layer.onAndroidBack()
      end)
    local TABS = {}
    local currentTab = 0
    local onTabSel = nil
    local createTitle = function(l_3_0, l_3_1, l_3_2)
      local bg = img.createLogin9Sprite(img.login.button_9_small_mwhite)
      bg:setPreferredSize(CCSizeMake(172, 47))
      local hl = img.createLogin9Sprite(img.login.button_9_small_gold)
      hl:setPreferredSize(CCSizeMake(172, 47))
      hl:setPosition(CCPoint(bg:getContentSize().width / 2, bg:getContentSize().height / 2))
      bg:addChild(hl)
      local label = lbl.create({font = 1, size = 20, text = l_3_0, color = ccc3(115, 59, 5), fr = {size = 18}, de = {size = 18}})
      label:setPosition(CCPoint(bg:getContentSize().width / 2, bg:getContentSize().height / 2))
      bg:addChild(label)
      local title = SpineMenuItem:create(json.ui.button, bg)
      title:setPosition(CCPoint(l_3_1, l_3_2))
      title:registerScriptTapHandler(function()
        audio.play(audio.button)
        onTabSel(title)
         end)
      title.hl = hl
      local title_menu = CCMenu:createWithItem(title)
      title_menu:setPosition(CCPoint(0, 0))
      board:addChild(title_menu)
      TABS[ TABS + 1] = title
      return title
      end
    createTitle(i18n.global.head_hero.string, 149, 400)
    createTitle(i18n.global.head_skin.string, 331, 400)
    createTitle(i18n.global.head_other.string, 513, 400)
    local showFgline = img.createUI9Sprite(img.ui.hero_enchant_info_fgline)
    showFgline:setPreferredSize(CCSize(606, 1))
    showFgline:setPosition(331, 357)
    board:addChild(showFgline)
    local scroll = CCScrollView:create()
    scroll:setDirection(kCCScrollViewDirectionVertical)
    scroll:setAnchorPoint(ccp(0, 0))
    scroll:setPosition(-2, 6)
    scroll:setViewSize(CCSize(660, 350))
    scroll:setContentSize(CCSize(662, 0))
    board:addChild(scroll)
    local addSel = function(l_4_0)
      local icon_sel = img.createUISprite(img.ui.hook_btn_sel)
      icon_sel:setScale(0.65)
      icon_sel:setAnchorPoint(CCPoint(1, 0))
      icon_sel:setPosition(CCPoint(l_4_0:getContentSize().width, 0))
      l_4_0:addChild(icon_sel)
      end
    local showHeads = {}
    local count = 1
    local createListView = function()
      arrayclear(showHeads)
      showHeads = {}
      upvalue_512 = 1
      scroll:getContainer():removeAllChildrenWithCleanup(true)
      local headnum = 0
      for i,v in ipairs(headData) do
        if not headData[i].hide and currentTab == headData[i].type then
          headnum = headnum + 1
        end
      end
      do
        local height = 101 * math.ceil((headnum) / 6)
        for i,v in ipairs(headData) do
          if currentTab == v.type then
            if not headData[i].hide then
              local x = math.ceil(count / 6)
              do
                local y = count - (x - 1) * 6
                upvalue_512 = count + 1
                if i <=  cfghead then
                  showHeads[i] = img.createPlayerHead(i)
                  if player.logo == i then
                    addSel(showHeads[i])
                  else
                    showHeads[i] = img.createPlayerHead(v.iconId)
                    if player.logo == v.iconId then
                      addSel(showHeads[i])
                    end
                  end
                end
                if headData[i].isNew then
                  print("isNew", i, headData[i].isNew)
                end
                if headData[i].isNew and headData[i].isNew == true then
                  addRedDot(showHeads[i], {px = showHeads[i]:getContentSize().width - 10, py = showHeads[i]:getContentSize().height - 10})
                end
                showHeads[i]:setAnchorPoint(ccp(0, 0))
                showHeads[i]:setPosition(40 + 101 * (y - 1), height - 99 * x - 5)
                scroll:getContainer():addChild(showHeads[i])
              end
              for i,v in (for generator) do
              end
              if i <=  cfghead then
                showHeads[i] = img.createPlayerHead(i)
              else
                showHeads[i] = img.createPlayerHead(v.iconId)
              end
              showHeads[i]:setAnchorPoint(ccp(0, 0))
              showHeads[i]:setPosition(-1000, 1000)
              showHeads[i]:setVisible(false)
              scroll:getContainer():addChild(showHeads[i])
            end
          end
          for i = 1,  headData do
            if headData[i] and headData[i].isNew and headData[i].type == currentTab then
              headData[i].isNew = false
            end
          end
          scroll:setContentSize(CCSize(662, height))
          scroll:setContentOffset(ccp(0, 350 - height))
        end
         -- Warning: missing end command somewhere! Added here
      end
      end
    onTabSel = function(l_6_0)
      for k,v in ipairs(TABS) do
        if l_6_0 == v then
          upvalue_512 = k
          createListView()
          l_6_0:setEnabled(false)
          l_6_0.hl:setVisible(true)
          for k,v in (for generator) do
          end
          v:setEnabled(true)
          v.hl:setVisible(false)
        end
         -- Warning: missing end command somewhere! Added here
      end
      end
    onTabSel(TABS[1])
    local onSelect = function(l_7_0)
      audio.play(audio.button)
      local params = {sid = player.sid, logo = l_7_0}
      if  cfghead < l_7_0 then
        params.logo = headData[l_7_0].iconId
      end
      addWaitNet()
      net:change_logo(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast("server status:" .. l_1_0.status)
          return 
        end
        player.logo = params.logo
        if layer and not tolua.isnull(layer) then
          layer:removeFromParentAndCleanup(true)
        end
         end)
      end
    local lasty = nil
    local onTouchBegin = function(l_8_0, l_8_1)
      lasty = l_8_1
      return true
      end
    local onTouchMoved = function(l_9_0, l_9_1)
      return true
      end
    local onTouchEnd = function(l_10_0, l_10_1)
      local point = layer:convertToNodeSpace(ccp(l_10_0, l_10_1))
      local pointOnScroll = scroll:getContainer():convertToNodeSpace(ccp(l_10_0, l_10_1))
      if math.abs(l_10_1 - lasty) > 10 then
        return 
      end
      if not board:boundingBox():containsPoint(point) then
        layer:removeFromParentAndCleanup(true)
        return 
      end
      for i,v in pairs(showHeads) do
        if v:boundingBox():containsPoint(pointOnScroll) then
          onSelect(i)
        end
      end
      return true
      end
    local onTouch = function(l_11_0, l_11_1, l_11_2)
      if l_11_0 == "began" then
        return onTouchBegin(l_11_1, l_11_2)
      elseif l_11_0 == "moved" then
        return onTouchMoved(l_11_1, l_11_2)
      else
        return onTouchEnd(l_11_1, l_11_2)
      end
      end
    layer:registerScriptTouchHandler(onTouch)
    layer:setTouchEnabled(true)
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
    layer:registerScriptHandler(function(l_15_0)
      if l_15_0 == "enter" then
        onEnter()
      elseif l_15_0 == "exit" then
        onExit()
      end
      end)
    do
      local onUpdate = function()
      for k,v in ipairs(TABS) do
        local isNew = false
        for k1,v2 in ipairs(headData) do
          if v2.type == k and v2.isNew then
            isNew = true
        else
          end
        end
        if isNew then
          addRedDot(v, {px = v:getContentSize().width - 5, py = v:getContentSize().height - 5})
          for k,v in (for generator) do
          end
          delRedDot(v)
        end
         -- Warning: missing end command somewhere! Added here
      end
      end
      layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
      return layer
    end
     -- Warning: missing end command somewhere! Added here
  end
end

return ui


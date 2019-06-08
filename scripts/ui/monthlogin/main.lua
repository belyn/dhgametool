-- Command line was: E:\github\dhgametool\scripts\ui\monthlogin\main.lua 

local ui = {}
require("common.func")
local cjson = json
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
local monthlogin = require("data.monthlogin")
local cfgmonthlogin = require("config.monthlogin")
local tipsitem = require("ui.tips.item")
local tipsequip = require("ui.tips.equip")
local shortcut = require("common.shortcutmgr")
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

ui.create = function()
  layer = CCLayer:create()
  local board = CCSprite:create()
  board:setContentSize(CCSize(556, 430))
  board:setScale(view.minScale)
  board:setAnchorPoint(ccp(0, 0))
  board:setPosition(scalep(360, 58))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local chat = img.createLogin9Sprite(img.login.toast_bg)
  chat:setPreferredSize(CCSize(550, 75))
  chat:setAnchorPoint(CCPoint(0.5, 0))
  chat:setPosition(board_w / 2, 10)
  board:addChild(chat, 10)
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setPosition(0, 83)
  scroll:setViewSize(CCSize(550, 348))
  scroll:setContentSize(CCSize(510, 648))
  board:addChild(scroll)
  scroll:setContentOffset(ccp(0, -294))
  if monthlogin.recvdays >= 15 then
    scroll:setContentOffset(ccp(0, 0))
  end
  local getposition = function(l_1_0)
    local x0 = 61
    local y0 = scroll:getContentSize().height - 60
    local x = x0 + math.floor((l_1_0 - 1) % 5) * 108
    local y = y0
    y = y - math.floor((l_1_0 - 1) / 5) * 106
    return x, y
   end
  local todayNum = nil
  local borderBg = {}
  local borderItem = {}
  local cdFlag = false
  local cd = nil
  local offset_idx = monthlogin.idx - 1
  for i = 1, 30 do
    local x, y = getposition(i)
    if cfgmonthlogin[i + offset_idx].shine == 1 then
      borderBg[i] = img.createUI9Sprite(img.ui.arena_frame5)
    else
      borderBg[i] = img.createUI9Sprite(img.ui.botton_fram_2)
    end
    borderBg[i]:setPreferredSize(CCSize(105, 105))
    borderBg[i]:setPosition(x, y)
    scroll:getContainer():addChild(borderBg[i])
    if cfgmonthlogin[i + offset_idx].rewards[1].type == 1 then
      borderItem[i] = img.createItem(cfgmonthlogin[i + offset_idx].rewards[1].id, cfgmonthlogin[i + offset_idx].rewards[1].num)
    else
      borderItem[i] = img.createEquip(cfgmonthlogin[i + offset_idx].rewards[1].id, cfgmonthlogin[i + offset_idx].rewards[1].num)
    end
    borderItem[i]:setScale(0.8)
    borderItem[i]:setPosition(x, y + 1)
    scroll:getContainer():addChild(borderItem[i], 1)
    if monthlogin.daily[i] == 3 then
      local _mask = img.createUISprite(img.ui.hook_btn_mask)
      _mask:setPosition(CCPoint(borderItem[i]:getContentSize().width / 2, borderItem[i]:getContentSize().height / 2))
      borderItem[i]:addChild(_mask, 100)
      local tickIcon = img.createUISprite(img.ui.login_month_finish)
      tickIcon:setPosition(x - 23, y - 23)
      scroll:getContainer():addChild(tickIcon, 2)
      borderItem[i].tickIcon = tickIcon
    else
      if monthlogin.daily[i] == 1 then
        json.load(json.ui.huodong)
        borderItem[i].aniHuodong = DHSkeletonAnimation:createWithKey(json.ui.huodong)
        borderItem[i].aniHuodong:scheduleUpdateLua()
        borderItem[i].aniHuodong:playAnimation("animation", -1)
        borderItem[i].aniHuodong:setPosition(x, y)
        scroll:getContainer():addChild(borderItem[i].aniHuodong)
      else
        if monthlogin.daily[i - 1] ~= 0 then
          todayNum = i
          cd = math.max(0, monthlogin.cd - os.time())
          if todayNum <= 30 then
            local timeLab = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
            borderItem[i].cd = lbl.createFont2(16, "", ccc3(165, 253, 71))
            borderItem[i].cd:setString(timeLab)
            borderItem[i].cd:setPosition(borderItem[i]:getContentSize().width / 2, -5)
            borderItem[i]:addChild(borderItem[i].cd)
            cdFlag = true
          end
        end
      end
    end
  end
  local onUpdate = function()
    cd = math.max(0, monthlogin.cd - os.time())
    if cd > 0 and todayNum and todayNum <= 30 and cdFlag == true then
      local timeLab = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
      assert(borderItem)
      assert(todayNum)
      assert(borderItem[todayNum], "todayNum:" .. todayNum .. " #borderItem:" ..  borderItem)
      borderItem[todayNum].cd:setString(timeLab)
    end
    if cd <= 0 and todayNum and todayNum <= 30 then
      local x, y = getposition(todayNum)
      borderItem[todayNum].cd:setVisible(false)
      json.load(json.ui.huodong)
      borderItem[todayNum].aniHuodong = DHSkeletonAnimation:createWithKey(json.ui.huodong)
      borderItem[todayNum].aniHuodong:scheduleUpdateLua()
      borderItem[todayNum].aniHuodong:playAnimation("animation", -1)
      borderItem[todayNum].aniHuodong:setPosition(x, y)
      scroll:getContainer():addChild(borderItem[todayNum].aniHuodong)
      monthlogin.daily[todayNum] = 1
      upvalue_1024 = todayNum + 1
      monthlogin.cd = os.time() + 86400
      if todayNum <= 30 then
        local timeLab = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
        borderItem[todayNum].cd = lbl.createFont2(14, "", ccc3(165, 253, 71))
        borderItem[todayNum].cd:setString(timeLab)
        borderItem[todayNum].cd:setPosition(borderItem[todayNum]:getContentSize().width / 2, -5)
        borderItem[todayNum]:addChild(borderItem[todayNum].cd)
      end
    end
   end
  local isCheckin = function()
    for i = 1, 30 do
      if monthlogin.daily[i] == 1 then
        return i
      end
    end
    return 0
   end
  local progresslab = lbl.createFont1(16, monthlogin.recvdays .. "/" .. 30, ccc3(204, 244, 42))
  progresslab:setAnchorPoint(1, 0.5)
  progresslab:setPosition(388, chat:getContentSize().height / 2 + 1)
  chat:addChild(progresslab, 10)
  local progressdes = lbl.createMixFont1(14, i18n.global.month_login_checkinnum.string, ccc3(255, 246, 223))
  progressdes:setAnchorPoint(1, 0.5)
  progressdes:setPosition(progresslab:boundingBox():getMinX() - 10, chat:getContentSize().height / 2)
  chat:addChild(progressdes, 10)
  local detailSprite = img.createUISprite(img.ui.btn_detail)
  local detailBtn = SpineMenuItem:create(json.ui.button, detailSprite)
  detailBtn:setScale(0.9)
  detailBtn:setAnchorPoint(1, 0.5)
  detailBtn:setPosition(progressdes:boundingBox():getMinX() - 6, chat:getContentSize().height / 2)
  local detailMenu = CCMenu:createWithItem(detailBtn)
  detailMenu:setPosition(0, 0)
  chat:addChild(detailMenu, 10)
  detailBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():getParent():addChild(require("ui.help").create(i18n.global.month_login_help.string), 1000)
   end)
  local checkinSprite = img.createLogin9Sprite(img.login.button_9_small_green)
  checkinSprite:setPreferredSize(CCSize(140, 50))
  local checkinBtn = SpineMenuItem:create(json.ui.button, checkinSprite)
  local checkinlab = lbl.createFont1(12, i18n.global.month_login_checkin.string, ccc3(29, 103, 0))
  checkinlab:setPosition(CCPoint(checkinSprite:getContentSize().width / 2, checkinSprite:getContentSize().height / 2))
  checkinSprite:addChild(checkinlab)
  checkinBtn:setAnchorPoint(CCPoint(0, 0.5))
  checkinBtn:setPosition(405, chat:getContentSize().height / 2)
  local checkinMenu = CCMenu:createWithItem(checkinBtn)
  checkinMenu:setPosition(0, 0)
  chat:addChild(checkinMenu, 10)
  checkinBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local i = isCheckin()
    if i == 0 then
      checkinBtn:setEnabled(false)
      setShader(checkinBtn, SHADER_GRAY, true)
      return 
    end
    local param = {}
    param.sid = player.sid
    param.id = i + offset_idx
    addWaitNet()
    local pbdata = {}
    net:alogin(param, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      shortcut.donateShortcut(shortcut.ActionEnum.SIGN)
      if cfgmonthlogin[i + offset_idx].rewards[1].type == 1 then
        bag.items.add({id = cfgmonthlogin[i + offset_idx].rewards[1].id, num = cfgmonthlogin[i + offset_idx].rewards[1].num})
        local pop = createPopupPieceBatchSummonResult("item", cfgmonthlogin[i + offset_idx].rewards[1].id, cfgmonthlogin[i + offset_idx].rewards[1].num)
        layer:getParent():getParent():addChild(pop, 100)
      else
        if cfgmonthlogin[i + offset_idx].rewards[1].type == 2 and l_1_0.bag.equips then
          bag.equips.addAll(l_1_0.bag.equips)
          local pop = createPopupPieceBatchSummonResult("equip", cfgmonthlogin[i + offset_idx].rewards[1].id, cfgmonthlogin[i + offset_idx].rewards[1].num)
          layer:getParent():getParent():addChild(pop, 100)
        end
      end
      local _mask = img.createUISprite(img.ui.hook_btn_mask)
      _mask:setPosition(CCPoint(borderItem[i]:getContentSize().width / 2, borderItem[i]:getContentSize().height / 2))
      borderItem[i]:addChild(_mask, 100)
      monthlogin.daily[i] = 3
      monthlogin.recvdays = monthlogin.recvdays + 1
      progresslab:setString(monthlogin.recvdays .. "/" .. 30)
      if isCheckin() == 0 then
        checkinBtn:setEnabled(false)
        setShader(checkinBtn, SHADER_GRAY, true)
      end
      local nowx, nowy = getposition(i)
      borderItem[i].aniHuodong:removeFromParent()
      local tickIcon = img.createUISprite(img.ui.login_month_finish)
      tickIcon:setPosition(nowx - 23, nowy - 23)
      scroll:getContainer():addChild(tickIcon, 2)
      end)
   end)
  if isCheckin() == 0 then
    checkinBtn:setEnabled(false)
    setShader(checkinBtn, SHADER_GRAY, true)
  end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_6_0, l_6_1)
    touchbeginx, upvalue_512 = l_6_0, l_6_1
    upvalue_1024 = true
    local p0 = scroll:getContainer():convertToNodeSpace(ccp(l_6_0, l_6_1))
    for _,bg in ipairs(borderItem) do
      if p0 and bg:boundingBox():containsPoint(p0) then
        upvalue_2560 = bg
        last_touch_sprite._scale = 0.8
        playAnimTouchBegin(last_touch_sprite)
      end
    end
    return true
   end
  local onTouchMoved = function(l_7_0, l_7_1)
    if isclick and (math.abs(touchbeginx - l_7_0) > 10 or math.abs(touchbeginy - l_7_1) > 10) then
      isclick = false
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        playAnimTouchEnd(last_touch_sprite)
        upvalue_1536 = nil
      end
    end
   end
  local onTouchEnded = function(l_8_0, l_8_1)
    if isclick then
      if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
        playAnimTouchEnd(last_touch_sprite)
        upvalue_512 = nil
      end
      local p0 = scroll:getContainer():convertToNodeSpace(ccp(l_8_0, l_8_1))
      for i = 1, 30 do
        if p0 and borderItem[i]:boundingBox():containsPoint(p0) then
          audio.play(audio.button)
          layer.tipsTag = false
          local tips = nil
          do
            local pbdata = {}
            if layer.tipsTag == false then
              layer.tipsTag = true
              if cfgmonthlogin[i + offset_idx].rewards[1].type == 1 then
                tips = tipsitem.createForShow({id = cfgmonthlogin[i + offset_idx].rewards[1].id, num = cfgmonthlogin[i + offset_idx].rewards[1].num})
                layer:getParent():getParent():addChild(tips, 200)
                tips.setClickBlankHandler(function()
                  tips:removeFromParent()
                  layer.tipsTag = false
                        end)
              else
                if cfgmonthlogin[i + offset_idx].rewards[1].type == 2 then
                  pbdata.id = cfgmonthlogin[i + offset_idx].rewards[1].id
                  tips = tipsequip.createForShow(pbdata)
                  layer:getParent():getParent():addChild(tips, 200)
                  tips.setClickBlankHandler(function()
                    tips:removeFromParent()
                    layer.tipsTag = false
                           end)
                end
              end
            end
            return 
          end
        end
      end
    end
   end
  local onTouch = function(l_9_0, l_9_1, l_9_2)
    if l_9_0 == "began" then
      return onTouchBegan(l_9_1, l_9_2)
    elseif l_9_0 == "moved" then
      return onTouchMoved(l_9_1, l_9_2)
    else
      return onTouchEnded(l_9_1, l_9_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  layer:setTouchEnabled(true)
  require("ui.activity.ban").addBan(layer, scroll, chat)
  return layer
end

return ui


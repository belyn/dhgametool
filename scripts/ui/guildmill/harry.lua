-- Command line was: E:\github\dhgametool\scripts\ui\guildmill\harry.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local cfgmill = require("config.mill")
local cfgmilllv = require("config.milllv")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local selecthero = require("ui.selecthero.main")
local player = require("data.player")
local guildmill = require("data.guildmill")
local bag = require("data.bag")
local net = require("net.netClient")
ui.create = function()
  local layer = CCLayer:create()
  local title = lbl.createFont1(24, i18n.global.gmill_harry_title.string, ccc3(230, 208, 174))
  title:setPosition(CCPoint(360, 492))
  layer:addChild(title, 1)
  local title_shadowD = lbl.createFont1(24, i18n.global.gmill_harry_title.string, ccc3(89, 48, 27))
  title_shadowD:setPosition(CCPoint(360, 490))
  layer:addChild(title_shadowD)
  local npcboard = img.createUI9Sprite(img.ui.botton_fram_2)
  npcboard:setPreferredSize(CCSizeMake(610, 175))
  npcboard:setAnchorPoint(CCPoint(0, 0))
  npcboard:setPosition(54, 210)
  layer:addChild(npcboard)
  local valueBottom = img.createUI9Sprite(img.ui.main_coin_bg)
  valueBottom:setPreferredSize(CCSizeMake(138, 40))
  valueBottom:setPosition(CCPoint(130, 408))
  layer:addChild(valueBottom)
  local enegy = bag.items.find(ITEM_ID_BREAD).num
  local breadlab = lbl.createFont2(16, string.format("%d/10", enegy), ccc3(248, 242, 226))
  breadlab:setPosition(CCPoint(valueBottom:getContentSize().width / 2, valueBottom:getContentSize().height / 2 + 3))
  valueBottom:addChild(breadlab)
  local breadIcon = img.createItemIcon2(ITEM_ID_BREAD)
  breadIcon:setPosition(5, valueBottom:getContentSize().height / 2 + 2)
  valueBottom:addChild(breadIcon)
  json.load(json.ui.clock)
  local clockIcon = DHSkeletonAnimation:createWithKey(json.ui.clock)
  clockIcon:scheduleUpdateLua()
  clockIcon:playAnimation("animation", -1)
  clockIcon:setPosition(224, 408)
  if enegy == 10 then
    clockIcon:setVisible(false)
  end
  layer:addChild(clockIcon, 100)
  local timeLab = string.format("%02d:%02d:%02d", math.floor(0), math.floor(0), math.floor(0))
  local showTimeLab = lbl.createFont2(16, "", ccc3(165, 253, 71))
  showTimeLab:setAnchorPoint(0, 0.5)
  showTimeLab:setPosition(244, 408)
  layer:addChild(showTimeLab)
  local recoverlab = lbl.createFont1(16, i18n.global.friendboss_enegy_recovery.string, ccc3(81, 39, 18))
  recoverlab:setAnchorPoint(0, 0.5)
  recoverlab:setPosition(CCPoint(320, 408))
  layer:addChild(recoverlab)
  local onUpdate = function(l_1_0)
    if guildmill.ecd and guildmill.pull_ecd_time and showTimeLab and not tolua.isnull(showTimeLab) then
      cd = math.max(0, guildmill.ecd + guildmill.pull_ecd_time - os.time())
      if cd > 0 then
        local timeLab = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
        showTimeLab:setString(timeLab)
      elseif enegy <= 9 then
        guildmill.ecd = guildmill.ecd + 7200
        guildmill.addEnegy()
        upvalue_1024 = bag.items.find(ITEM_ID_BREAD).num
        breadlab:setString(string.format("%d/10", enegy))
        if guildmill.ecd == nil then
          recoverlab:setVisible(false)
          showTimeLab:setVisible(false)
          clockIcon:setVisible(false)
        else
          recoverlab:setVisible(false)
          showTimeLab:setVisible(false)
          clockIcon:setVisible(false)
        end
      end
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  local isorder, orderlayer = nil, nil
  local noorder = function()
    local noorderlayer = CCLayer:create()
    local searchmap = img.createUISprite(img.ui.friends_search)
    searchmap:setPosition(360, 300)
    noorderlayer:addChild(searchmap)
    json.load(json.ui.haoyouzhuzhan)
    local searchIcon = DHSkeletonAnimation:createWithKey(json.ui.haoyouzhuzhan)
    searchIcon:scheduleUpdateLua()
    searchIcon:setPosition(360, 260)
    noorderlayer:addChild(searchIcon)
    local declab = lbl.createMixFont1(18, i18n.global.gmill_tip_harry.string, ccc3(81, 52, 28))
    declab:setPosition(CCPoint(360, 185))
    noorderlayer:addChild(declab)
    local recvorderSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    recvorderSprite:setPreferredSize(CCSizeMake(160, 52))
    local recvorderlab = lbl.createFont1(18, i18n.global.friendboss_btn_search.string, lbl.buttonColor)
    recvorderlab:setPosition(CCPoint(recvorderSprite:getContentSize().width / 2, recvorderSprite:getContentSize().height / 2))
    recvorderSprite:addChild(recvorderlab)
    local recvorderBtn = SpineMenuItem:create(json.ui.button, recvorderSprite)
    recvorderBtn:setAnchorPoint(0.5, 0)
    recvorderBtn:setPosition(CCPoint(360, 58))
    local recvorderMenu = CCMenu:createWithItem(recvorderBtn)
    recvorderMenu:setPosition(0, 0)
    noorderlayer:addChild(recvorderMenu)
    recvorderBtn:registerScriptTapHandler(function()
      audio.play(audio.button)
      do
        local ban = CCLayer:create()
        ban:setTouchEnabled(true)
        ban:setTouchSwallowEnabled(true)
        layer:addChild(ban, 1000)
        layer:runAction(createSequence({}))
        searchIcon:playAnimation("animation")
        schedule(layer, 1.5, function()
        if enegy == 0 then
          showToast(i18n.global.gmill_no_bread.string)
          return 
        end
        local param = {}
        param.sid = player.sid
        addWaitNet()
        net:gmill_search(param, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          if l_1_0.status == -2 then
            showToast(i18n.global.gmill_no_horder.string)
            return 
          end
          if l_1_0.status == -1 then
            showToast(i18n.global.gmill_no_bread.string)
            return 
          end
          if l_1_0.status ~= 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            return 
          end
          bag.items.sub({id = ITEM_ID_BREAD, num = 1})
          if enegy == 10 then
            clockIcon:setVisible(true)
            showTimeLab:setVisible(true)
            recoverlab:setVisible(true)
            guildmill.ecd = 7200
            guildmill.pull_ecd_time = os.time()
          end
          upvalue_1024 = enegy - 1
          if breadlab and not tolua.isnull(breadlab) then
            breadlab:setString(string.format("%d/10", enegy))
          end
          if searchIcon and not tolua.isnull(searchIcon) then
            searchIcon:setVisible(false)
          end
          orderlayer:removeFromParentAndCleanup(true)
          upvalue_4608 = nil
          upvalue_4608 = isorder(l_1_0)
          layer:addChild(orderlayer)
            end)
         end)
      end
       -- Warning: undefined locals caused missing assignments!
      end)
    return noorderlayer
   end
  isorder = function(l_3_0)
    local isorderlayer = CCLayer:create()
    local orderlv = l_3_0.lv
    local millicon = img.createUISprite(img.ui.guild_mill_" .. cfgmilllv[orderlv].resI)
    millicon:setPosition(170, 315)
    isorderlayer:addChild(millicon)
    local lowlvlab = lbl.createFont1(14, "Lv:" .. orderlv, ccc3(255, 246, 223))
    lowlvlab:setPosition(CCPoint(millicon:getContentSize().width / 2, 14))
    millicon:addChild(lowlvlab)
    local guildname = lbl.createMixFont1(16, l_3_0.gud, ccc3(81, 39, 18))
    guildname:setPosition(170, 240)
    isorderlayer:addChild(guildname)
    local sevbg = img.createUISprite(img.ui.anrea_server_bg)
    sevbg:setPosition(262, 315)
    isorderlayer:addChild(sevbg)
    local sevlab = lbl.createFont1(16, getSidname(l_3_0.svr_id), ccc3(247, 234, 209))
    sevlab:setPosition(sevbg:getContentSize().width / 2, sevbg:getContentSize().height / 2)
    sevbg:addChild(sevlab)
    local orderbg = img.createUI9Sprite(img.ui.hero_icon_bg)
    orderbg:setPreferredSize(CCSizeMake(225, 52))
    orderbg:setAnchorPoint(1, 0.5)
    orderbg:setPosition(622, 330)
    isorderlayer:addChild(orderbg)
    local orderitembg = img.createUISprite(img.ui.hook_rate_bg)
    orderitembg:setPosition(10, orderbg:getContentSize().height / 2)
    orderbg:addChild(orderitembg)
    local ordericon = img.createUISprite(img.ui.guild_mill_order" .. cfgmill[l_3_0.id].resI)
    ordericon:setScale(0.42)
    ordericon:setPosition(orderitembg:getContentSize().width / 4, orderitembg:getContentSize().height / 2)
    orderbg:addChild(ordericon)
    for i = 1, 6 do
      local startbg = img.createUISprite(img.ui.guild_mill_bottom_star)
      startbg:setPosition(64 + (i - 1) * 27, orderbg:getContentSize().height / 2)
      orderbg:addChild(startbg)
      if i <= l_3_0.id then
        local start = img.createUISprite(img.ui.star)
        start:setScale(0.65)
        start:setPosition(64 + (i - 1) * 27, orderbg:getContentSize().height / 2)
        orderbg:addChild(start)
      end
    end
    local enegybg = img.createUI9Sprite(img.ui.hero_icon_bg)
    enegybg:setPreferredSize(CCSizeMake(225, 52))
    enegybg:setAnchorPoint(1, 0.5)
    enegybg:setPosition(622, 265)
    isorderlayer:addChild(enegybg)
    local enegyitembg = img.createUISprite(img.ui.hook_rate_bg)
    enegyitembg:setPosition(10, enegybg:getContentSize().height / 2)
    enegybg:addChild(enegyitembg)
    local enegyicon = img.createUISprite(img.ui.power_icon)
    enegyicon:setScale(0.65)
    enegyicon:setPosition(enegyitembg:getContentSize().width / 4 - 2, enegyitembg:getContentSize().height / 2)
    enegybg:addChild(enegyicon)
    local enegyStr = lbl.createFont2(22, string.format("%d", l_3_0.power), ccc3(255, 253, 244))
    enegyStr:setPosition(enegybg:getContentSize().width / 2 + 10, enegybg:getContentSize().height / 2)
    enegybg:addChild(enegyStr)
    local declab = lbl.createFont1(16, i18n.global.friendboss_battle_reward.string, ccc3(90, 46, 4))
    declab:setPosition(360, 195)
    isorderlayer:addChild(declab)
    local rewardObj = l_3_0.rewards
    do
      local offset_x = 324
      if rewardObj.items then
        for i = 1, #rewardObj.items do
          local itemObj = rewardObj.items[i]
          local tmp_item0 = img.createItem(itemObj.id, itemObj.num)
          local tmp_item = SpineMenuItem:create(json.ui.button, tmp_item0)
          tmp_item:setScale(0.7)
          tmp_item:setPosition(CCPoint(offset_x + (i - 1) * 70, 150))
          local tmp_item_menu = CCMenu:createWithItem(tmp_item)
          tmp_item_menu:setPosition(CCPoint(0, 0))
          layer:addChild(tmp_item_menu)
          tmp_item:registerScriptTapHandler(function()
            audio.play(audio.button)
            local tmp_tip = nil
            tmp_tip = tipsitem.createForShow({id = itemObj.id})
            isorderlayer:getParent():getParent():getParent():addChild(tmp_tip, 10000)
            tmp_tip.setClickBlankHandler(function()
              tmp_tip:removeFromParentAndCleanup(true)
                  end)
               end)
        end
      end
      if rewardObj.equips then
        for i = 1, #rewardObj.equips do
          local itemObj = rewardObj.equips[i]
          local tmp_item0 = img.createEquip(itemObj.id, itemObj.num)
          local tmp_item = SpineMenuItem:create(json.ui.button, tmp_item0)
          tmp_item:setScale(0.7)
          tmp_item:setPosition(CCPoint(offset_x + (#rewardObj.items + i - 1) * 70, 150))
          local tmp_item_menu = CCMenu:createWithItem(tmp_item)
          tmp_item_menu:setPosition(CCPoint(0, 0))
          layer:addChild(tmp_item_menu)
          tmp_item:registerScriptTapHandler(function()
            audio.play(audio.button)
            local tmp_tip = nil
            tmp_tip = tipsequip.createById(itemObj.id)
            isorderlayer:getParent():getParent():getParent():addChild(tmp_tip, 10000)
            tmp_tip.setClickBlankHandler(function()
              tmp_tip:removeFromParentAndCleanup(true)
                  end)
               end)
        end
      end
      local harrySprite = img.createLogin9Sprite(img.login.button_9_small_gold)
      harrySprite:setPreferredSize(CCSizeMake(160, 52))
      local harrylab = lbl.createFont1(18, i18n.global.gmill_btn_harry.string, lbl.buttonColor)
      harrylab:setPosition(CCPoint(harrySprite:getContentSize().width / 2, harrySprite:getContentSize().height / 2))
      harrySprite:addChild(harrylab)
      local harryBtn = SpineMenuItem:create(json.ui.button, harrySprite)
      harryBtn:setAnchorPoint(0.5, 0)
      harryBtn:setPosition(CCPoint(360, 58))
      local harryMenu = CCMenu:createWithItem(harryBtn)
      harryMenu:setPosition(0, 0)
      isorderlayer:addChild(harryMenu)
      harryBtn:registerScriptTapHandler(function()
        disableObjAWhile(harryBtn)
        audio.play(audio.button)
        camplayer = selecthero.create({type = "guildmillharry"})
        isorderlayer:getParent():getParent():getParent():addChild(camplayer, 10011)
         end)
      return isorderlayer
    end
   end
  if guildmill.porder then
    orderlayer = isorder(guildmill.porder)
  else
    orderlayer = noorder()
  end
  layer:addChild(orderlayer)
  return layer
end

return ui


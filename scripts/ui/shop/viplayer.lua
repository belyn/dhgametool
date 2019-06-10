-- Command line was: E:\github\dhgametool\scripts\ui\shop\viplayer.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local json = require("res.json")
local lbl = require("res.lbl")
local audio = require("res.audio")
local i18n = require("res.i18n")
local player = require("data.player")
local bag = require("data.bag")
local cfgstore = require("config.store")
local cfgvip = require("config.vip")
local cfgitem = require("config.item")
local tipsitem = require("ui.tips.item")
local tipsequip = require("ui.tips.equip")
local net = require("net.netClient")
local shop = require("data.shop")
local reward = require("ui.reward")
ui.create = function(l_1_0, l_1_1, l_1_2)
  local propertyLayer = CCLayer:create()
  local infoVipLv = (player.vipLv())
  local createVIPinfo = nil
  if infoVipLv == 0 then
    infoVipLv = 1
  end
  local leftDecorBg = img.createUISprite(img.ui.gemstore_decoration)
  leftDecorBg:setAnchorPoint(ccp(0, 1))
  leftDecorBg:setPosition(16, 390)
  propertyLayer:addChild(leftDecorBg)
  local rightDecorBg = img.createUISprite(img.ui.gemstore_decoration)
  rightDecorBg:setAnchorPoint(ccp(1, 1))
  rightDecorBg:setPosition(846, 390)
  rightDecorBg:setFlipX(true)
  propertyLayer:addChild(rightDecorBg)
  local propertyBg = img.createUI9Sprite(img.ui.vip_paper)
  propertyBg:setPreferredSize(CCSize(580, 345))
  propertyBg:setPosition(432, 202)
  propertyLayer:addChild(propertyBg)
  local lefMenu = CCMenu:create()
  lefMenu:setPosition(0, 0)
  propertyLayer:addChild(lefMenu)
  local lefBtnSprite = img.createUISprite(img.ui.gemstore_next_icon1)
  local lefBtn = HHMenuItem:create(lefBtnSprite)
  lefBtn:setScale(-1)
  lefBtn:setPosition(85, 215)
  lefMenu:addChild(lefBtn)
  lefBtn:registerScriptTapHandler(function()
    if infoVipLv > 1 then
      infoVipLv = infoVipLv - 1
    end
    createVIPinfo(infoVipLv)
    audio.play(audio.button)
   end)
  local rigMenu = CCMenu:create()
  rigMenu:setPosition(0, 0)
  propertyLayer:addChild(rigMenu)
  local rigBtnSprite = img.createUISprite(img.ui.gemstore_next_icon1)
  local rigBtn = HHMenuItem:create(rigBtnSprite)
  rigBtn:setPosition(780, 215)
  rigMenu:addChild(rigBtn)
  rigBtn:registerScriptTapHandler(function()
    if infoVipLv < #cfgvip then
      infoVipLv = infoVipLv + 1
    end
    createVIPinfo(infoVipLv)
    audio.play(audio.button)
   end)
  json.load(json.ui.ic_vip)
  local vip_bg = CCSprite:create()
  vip_bg:setContentSize(CCSizeMake(58, 58))
  vip_bg:setScale(0.7)
  vip_bg:setPosition(CCPoint(propertyBg:getContentSize().width / 2 - 50, propertyBg:getContentSize().height - 33))
  propertyBg:addChild(vip_bg)
  local ic_vip = DHSkeletonAnimation:createWithKey(json.ui.ic_vip)
  ic_vip:scheduleUpdateLua()
  ic_vip:playAnimation("" .. l_1_1[8], -1)
  ic_vip:setPosition(CCPoint(29, 29))
  vip_bg:addChild(ic_vip)
  local useless_node = CCNode:create()
  local lbl_player_vip = lbl.createFont2(18, 8, ccc3(255, 220, 130))
  lbl_player_vip:setColor(l_1_2[8])
  useless_node:addChild(lbl_player_vip)
  ic_vip:addChildFollowSlot("code_num", useless_node)
  local provilegeLab = lbl.createFont1(22, i18n.global.shop_privilege.string, ccc3(81, 39, 18))
  provilegeLab:setAnchorPoint(0, 0.5)
  provilegeLab:setPosition(vip_bg:boundingBox():getMaxX() + 5, propertyBg:getContentSize().height - 33)
  propertyBg:addChild(provilegeLab)
  local line = img.createUI9Sprite(img.ui.gemstore_fgline)
  line:setPreferredSize(CCSize(530, 2))
  line:setPosition(CCPoint(propertyBg:getContentSize().width / 2, propertyBg:getContentSize().height - 60))
  propertyBg:addChild(line)
  local KSCROLL_CONTAINER_SIZE = math.max(345, 280)
  local Kscroll = CCScrollView:create()
  Kscroll:setDirection(kCCScrollViewDirectionVertical)
  Kscroll:setAnchorPoint(ccp(0, 0))
  Kscroll:setPosition(40, 18)
  Kscroll:setViewSize(CCSize(650, 260))
  Kscroll:setContentSize(CCSize(650, KSCROLL_CONTAINER_SIZE))
  propertyBg:addChild(Kscroll)
  local onKScroll = function()
    if Kscroll:getContainer():getPositionY() > 0 then
      Kscroll:getContainer():setPositionY(0)
    end
    if Kscroll:getContainer():getPositionY() < 300 - KSCROLL_CONTAINER_SIZE then
      Kscroll:getContainer():setPositionY(300 - KSCROLL_CONTAINER_SIZE)
    end
   end
  Kscroll:registerScriptHandler(onKScroll, CCScrollView.kScrollViewScroll)
  Kscroll:setContentOffset(ccp(0, 300 - KSCROLL_CONTAINER_SIZE))
  createVIPinfo = function(l_4_0)
    Kscroll:getContainer():removeAllChildrenWithCleanup(true)
    ic_vip:stopAnimation()
    ic_vip:playAnimation("" .. vip_a[l_4_0], -1)
    lbl_player_vip:setString(l_4_0)
    lbl_player_vip:setColor(vip_c[l_4_0])
    if l_4_0 <= 1 then
      lefBtn:setVisible(false)
    else
      lefBtn:setVisible(true)
    end
    if l_4_0 == #cfgvip then
      rigBtn:setVisible(false)
    else
      rigBtn:setVisible(true)
    end
    local prolab = {}
    local idx = 1
    local offsetY = 30
    if cfgvip[l_4_0].speed and cfgvip[l_4_0].speed > 1 then
      local circle = img.createUISprite(img.ui.gemstore_point)
      do
        circle:setAnchorPoint(ccp(0, 0))
        circle:setPosition(5, offsetY + 6)
        Kscroll:addChild(circle)
        local str = i18n.vipdes.dareTime.string1 .. " "
        prolab[idx] = lbl.createMix({font = 1, size = 18, text = str, color = ccc3(81, 39, 18), fr = {size = 14}, es = {size = 14}, pt = {size = 14}, jp = {size = 14}})
        prolab[idx]:setPosition(20, offsetY)
        prolab[idx]:setAnchorPoint(ccp(0, 0))
        Kscroll:addChild(prolab[idx])
        local contentlab = lbl.createMixFont1(18, string.format(i18n.vipdes.dareTime.string2, cfgvip[l_4_0].dareTime), ccc3(174, 73, 33))
        contentlab:setAnchorPoint(ccp(0, 0.5))
        contentlab:setPosition(prolab[idx]:boundingBox():getMaxX(), prolab[idx]:getPositionY())
        Kscroll:addChild(contentlab)
        idx = idx + 1
        offsetY = offsetY + 30
      end
    end
    if cfgvip[l_4_0].speed and cfgvip[l_4_0].speed > 1 then
      local circle = img.createUISprite(img.ui.gemstore_point)
      circle:setAnchorPoint(ccp(0, 0))
      circle:setPosition(5, offsetY + 6)
      Kscroll:addChild(circle)
      local str = i18n.vipdes.speed2.string1 .. ""
      prolab[idx] = lbl.createMix({font = 1, size = 18, text = str, color = ccc3(81, 39, 18), fr = {size = 14}, es = {size = 14}, pt = {size = 14}, jp = {size = 14}})
      prolab[idx]:setPosition(20, offsetY)
      prolab[idx]:setAnchorPoint(ccp(0, 0))
      Kscroll:addChild(prolab[idx])
      idx = idx + 1
      offsetY = offsetY + 30
    end
    if cfgvip[l_4_0].heroTask and cfgvip[l_4_0].heroTask > 0 then
      local circle = img.createUISprite(img.ui.gemstore_point)
      circle:setAnchorPoint(ccp(0, 0))
      circle:setPosition(5, offsetY + 6)
      Kscroll:addChild(circle)
      local str = i18n.vipdes.heroTaskMax.string1 .. " "
      prolab[idx] = lbl.createMix({font = 1, size = 18, text = str, color = ccc3(81, 39, 18), fr = {size = 14}, es = {size = 14}, pt = {size = 14}, jp = {size = 14}})
      prolab[idx]:setPosition(20, offsetY)
      prolab[idx]:setAnchorPoint(ccp(0, 0))
      Kscroll:addChild(prolab[idx])
      local contentlab = lbl.createMixFont1(18, string.format(i18n.vipdes.heroTaskMax.string2, cfgvip[l_4_0].heroTask), ccc3(174, 73, 33))
      contentlab:setAnchorPoint(ccp(0, 0.5))
      contentlab:setPosition(prolab[idx]:boundingBox():getMaxX(), prolab[idx]:getPositionY())
      Kscroll:addChild(contentlab)
      idx = idx + 1
      offsetY = offsetY + 30
    end
    if cfgvip[l_4_0].hook and cfgvip[l_4_0].hook > 0 then
      local circle = img.createUISprite(img.ui.gemstore_point)
      circle:setAnchorPoint(ccp(0, 0))
      circle:setPosition(5, offsetY + 6)
      Kscroll:addChild(circle)
      local str = i18n.vipdes.hookVip.string1 .. " "
      prolab[idx] = lbl.createMix({font = 1, size = 18, text = str, color = ccc3(81, 39, 18), fr = {size = 14}, es = {size = 14}, pt = {size = 14}, jp = {size = 14}})
      prolab[idx]:setPosition(20, offsetY)
      prolab[idx]:setAnchorPoint(ccp(0, 0))
      Kscroll:addChild(prolab[idx])
      local contentlab = lbl.createMixFont1(18, string.format(i18n.vipdes.hookVip.string2 .. "%%", cfgvip[l_4_0].hook * 100), ccc3(174, 73, 33))
      contentlab:setAnchorPoint(ccp(0, 0.5))
      contentlab:setPosition(prolab[idx]:boundingBox():getMaxX(), offsetY)
      Kscroll:addChild(contentlab)
      idx = idx + 1
      offsetY = offsetY + 30
    end
    if cfgvip[l_4_0].midas and cfgvip[l_4_0].midas > 0 then
      local circle = img.createUISprite(img.ui.gemstore_point)
      circle:setAnchorPoint(ccp(0, 0))
      circle:setPosition(5, offsetY + 6)
      Kscroll:addChild(circle)
      local str = i18n.vipdes.midasVip.string1 .. " "
      prolab[idx] = lbl.createMix({font = 1, size = 18, text = str, color = ccc3(81, 39, 18), fr = {size = 14}, es = {size = 14}, pt = {size = 14}, jp = {size = 14}})
      prolab[idx]:setPosition(20, offsetY)
      prolab[idx]:setAnchorPoint(ccp(0, 0))
      Kscroll:addChild(prolab[idx])
      local contentlab = lbl.createMixFont1(18, string.format(i18n.vipdes.midasVip.string2 .. "%%", cfgvip[l_4_0].midas * 100), ccc3(174, 73, 33))
      contentlab:setPosition(prolab[idx]:boundingBox():getMaxX(), offsetY)
      contentlab:setAnchorPoint(ccp(0, 0))
      Kscroll:addChild(contentlab)
      idx = idx + 1
      offsetY = offsetY + 30
    end
    if cfgvip[l_4_0].heroes and cfgvip[l_4_0].heroes > 0 then
      local circle = img.createUISprite(img.ui.gemstore_point)
      circle:setAnchorPoint(ccp(0, 0))
      circle:setPosition(5, offsetY + 6)
      Kscroll:addChild(circle)
      local str = i18n.vipdes.heroLimit.string1 .. " "
      prolab[idx] = lbl.createMix({font = 1, size = 18, text = str, color = ccc3(81, 39, 18), fr = {size = 14}, es = {size = 14}, pt = {size = 14}, jp = {size = 14}})
      prolab[idx]:setPosition(20, offsetY)
      prolab[idx]:setAnchorPoint(ccp(0, 0))
      Kscroll:addChild(prolab[idx])
      local contentlab = lbl.createMixFont1(18, string.format(i18n.vipdes.heroLimit.string2, cfgvip[l_4_0].heroes - cfgvip[l_4_0 - 1].heroes), ccc3(174, 73, 33))
      contentlab:setAnchorPoint(ccp(0, 0.5))
      contentlab:setPosition(prolab[idx]:boundingBox():getMaxX(), prolab[idx]:getPositionY())
      Kscroll:addChild(contentlab)
      idx = idx + 1
      offsetY = offsetY + 30
    end
    if cfgvip[l_4_0].gamble and cfgvip[l_4_0].gamble > 0 then
      local circle = img.createUISprite(img.ui.gemstore_point)
      circle:setAnchorPoint(ccp(0, 0))
      circle:setPosition(5, offsetY + 6)
      Kscroll:addChild(circle)
      local str = i18n.vipdes.gamble10.string1 .. ""
      prolab[idx] = lbl.createMix({font = 1, size = 18, text = str, color = ccc3(81, 39, 18), fr = {size = 14}, es = {size = 14}, pt = {size = 14}, jp = {size = 14}})
      prolab[idx]:setPosition(20, offsetY)
      prolab[idx]:setAnchorPoint(ccp(0, 0))
      Kscroll:addChild(prolab[idx])
      idx = idx + 1
      offsetY = offsetY + 30
    end
    if cfgvip[l_4_0].gacha and cfgvip[l_4_0].gacha > 0 then
      local circle = img.createUISprite(img.ui.gemstore_point)
      circle:setAnchorPoint(ccp(0, 0))
      circle:setPosition(5, offsetY + 6)
      Kscroll:addChild(circle)
      local str = i18n.vipdes.gachaPower.string1 .. ""
      prolab[idx] = lbl.createMix({font = 1, size = 18, text = str, color = ccc3(81, 39, 18), fr = {size = 14}, es = {size = 14}, pt = {size = 14}, jp = {size = 14}})
      prolab[idx]:setPosition(20, offsetY)
      prolab[idx]:setAnchorPoint(ccp(0, 0))
      Kscroll:addChild(prolab[idx])
      idx = idx + 1
      offsetY = offsetY + 30
    end
    if cfgvip[l_4_0].monthCard then
      if cfgvip[l_4_0].monthCard[1] then
        local iconId = cfgvip[l_4_0].monthCard[1].id
        local iconNum = cfgvip[l_4_0].monthCard[1].num
        local icon = nil
        if cfgvip[l_4_0].monthCard[1].type == 1 then
          icon = img.createItem(iconId, iconNum)
        else
          icon = img.createEquip(iconId, iconNum)
        end
        local monthCardIcon = CCMenuItemSprite:create(icon, nil)
        monthCardIcon:setScale(0.7)
        monthCardIcon:setAnchorPoint(ccp(0, 0))
        monthCardIcon:setPosition(20, offsetY)
        local monthCardmenu = CCMenu:createWithItem(monthCardIcon)
        monthCardmenu:setPosition(0, 0)
        Kscroll:addChild(monthCardmenu)
        monthCardIcon:registerScriptTapHandler(function()
          audio.play(audio.button)
          if not layer.tipsTag then
            layer.tipsTag = true
            if cfgvip[viplv].monthCard[1].type == 1 then
              layer.tips = tipsitem.createForShow({id = iconId})
            else
              layer.tips = tipsequip.createForShow({id = iconId})
            end
            layer:addChild(layer.tips, 100)
            layer.tips.setClickBlankHandler(function()
              layer.tipsTag = false
              layer.tips:removeFromParent()
                  end)
          end
            end)
      end
      if cfgvip[l_4_0].monthCard[2] then
        local iconId = cfgvip[l_4_0].monthCard[2].id
        local iconNum = cfgvip[l_4_0].monthCard[2].num
        local icon = nil
        if cfgvip[l_4_0].monthCard[2].type == 1 then
          icon = img.createItem(iconId, iconNum)
        else
          icon = img.createEquip(iconId, iconNum)
        end
        local monthCardIcon = CCMenuItemSprite:create(icon, nil)
        monthCardIcon:setScale(0.7)
        monthCardIcon:setAnchorPoint(ccp(0, 0))
        monthCardIcon:setPosition(90, offsetY)
        local monthCardmenu = CCMenu:createWithItem(monthCardIcon)
        monthCardmenu:setPosition(0, 0)
        Kscroll:addChild(monthCardmenu)
        monthCardIcon:registerScriptTapHandler(function()
          audio.play(audio.button)
          if not layer.tipsTag then
            layer.tipsTag = true
            if cfgvip[viplv].monthCard[2].type == 1 then
              layer.tips = tipsitem.createForShow({id = iconId})
            else
              layer.tips = tipsequip.createForShow({id = iconId})
            end
            layer:addChild(layer.tips, 100)
            layer.tips.setClickBlankHandler(function()
              layer.tipsTag = false
              layer.tips:removeFromParent()
                  end)
          end
            end)
      end
      if cfgvip[l_4_0].monthCard[3] then
        local iconId = cfgvip[l_4_0].monthCard[3].id
        local iconNum = cfgvip[l_4_0].monthCard[3].num
        local icon = nil
        if cfgvip[l_4_0].monthCard[3].type == 1 then
          icon = img.createItem(iconId, iconNum)
        else
          icon = img.createEquip(iconId, iconNum)
        end
        local monthCardIcon = CCMenuItemSprite:create(icon, nil)
        monthCardIcon:setScale(0.7)
        monthCardIcon:setAnchorPoint(ccp(0, 0))
        monthCardIcon:setPosition(160, offsetY)
        local monthCardmenu = CCMenu:createWithItem(monthCardIcon)
        monthCardmenu:setPosition(0, 0)
        Kscroll:addChild(monthCardmenu)
        monthCardIcon:registerScriptTapHandler(function()
          audio.play(audio.button)
          if not layer.tipsTag then
            layer.tipsTag = true
            if cfgvip[viplv].monthCard[3].type == 1 then
              layer.tips = tipsitem.createForShow({id = iconId})
            else
              layer.tips = tipsequip.createForShow({id = iconId})
            end
            layer:addChild(layer.tips, 100)
            layer.tips.setClickBlankHandler(function()
              layer.tipsTag = false
              layer.tips:removeFromParent()
                  end)
          end
            end)
      end
      idx = idx + 2
      offsetY = offsetY + 60
      local circle = img.createUISprite(img.ui.gemstore_point)
      circle:setAnchorPoint(ccp(0, 0))
      circle:setPosition(5, offsetY + 6)
      Kscroll:addChild(circle)
      local str = i18n.vipdes.vipMouth.string1 .. " "
      prolab[idx] = lbl.createMix({font = 1, size = 18, text = str, color = ccc3(81, 39, 18), fr = {size = 14}, es = {size = 14}, pt = {size = 14}, jp = {size = 14}})
      prolab[idx]:setPosition(20, offsetY)
      prolab[idx]:setAnchorPoint(ccp(0, 0))
      Kscroll:addChild(prolab[idx])
      idx = idx + 1
      offsetY = offsetY + 30
    end
    if cfgvip[l_4_0].vipRewards then
      if cfgvip[l_4_0].vipRewards[1] then
        local iconId = cfgvip[l_4_0].vipRewards[1].id
        local iconNum = cfgvip[l_4_0].vipRewards[1].num
        local icon = nil
        if cfgvip[l_4_0].vipRewards[1].type == 1 then
          icon = img.createItem(iconId, iconNum)
        else
          icon = img.createEquip(iconId, iconNum)
        end
        local rewardIcon = CCMenuItemSprite:create(icon, nil)
        rewardIcon:setScale(0.7)
        rewardIcon:setAnchorPoint(ccp(0, 0))
        rewardIcon:setPosition(20, offsetY)
        local rewardmenu = CCMenu:createWithItem(rewardIcon)
        rewardmenu:setPosition(0, 0)
        Kscroll:addChild(rewardmenu)
        rewardIcon:registerScriptTapHandler(function()
          audio.play(audio.button)
          if not layer.tipsTag then
            layer.tipsTag = true
            if cfgvip[viplv].vipRewards[1].type == 1 then
              layer.tips = tipsitem.createForShow({id = iconId})
            else
              layer.tips = tipsequip.createForShow({id = iconId})
            end
            layer:addChild(layer.tips, 100)
            layer.tips.setClickBlankHandler(function()
              layer.tipsTag = false
              layer.tips:removeFromParent()
                  end)
          end
            end)
      end
      if cfgvip[l_4_0].vipRewards[2] then
        local iconId = cfgvip[l_4_0].vipRewards[2].id
        local iconNum = cfgvip[l_4_0].vipRewards[2].num
        local icon = nil
        if cfgvip[l_4_0].vipRewards[2].type == 1 then
          icon = img.createItem(iconId, iconNum)
        else
          icon = img.createEquip(iconId, iconNum)
        end
        local rewardIcon = CCMenuItemSprite:create(icon, nil)
        rewardIcon:setScale(0.7)
        rewardIcon:setAnchorPoint(ccp(0, 0))
        rewardIcon:setPosition(90, offsetY)
        local rewardmenu = CCMenu:createWithItem(rewardIcon)
        rewardmenu:setPosition(0, 0)
        Kscroll:addChild(rewardmenu)
        rewardIcon:registerScriptTapHandler(function()
          audio.play(audio.button)
          if not layer.tipsTag then
            layer.tipsTag = true
            if cfgvip[viplv].vipRewards[2].type == 1 then
              layer.tips = tipsitem.createForShow({id = iconId})
            else
              layer.tips = tipsequip.createForShow({id = iconId})
            end
            layer:addChild(layer.tips, 100)
            layer.tips.setClickBlankHandler(function()
              layer.tipsTag = false
              layer.tips:removeFromParent()
                  end)
          end
            end)
      end
      idx = idx + 2
      offsetY = offsetY + 60
      local circle = img.createUISprite(img.ui.gemstore_point)
      circle:setAnchorPoint(ccp(0, 0))
      circle:setPosition(5, offsetY + 6)
      Kscroll:addChild(circle)
      local str = i18n.vipdes.vipRewards.string1 .. " "
      prolab[idx] = lbl.createMix({font = 1, size = 18, text = str, color = ccc3(81, 39, 18), fr = {size = 14}, es = {size = 14}, pt = {size = 14}, jp = {size = 14}})
      prolab[idx]:setPosition(20, offsetY)
      prolab[idx]:setAnchorPoint(ccp(0, 0))
      Kscroll:addChild(prolab[idx])
      idx = idx + 1
      offsetY = offsetY + 30
    end
    upvalue_7680 = (idx) * 33
    if idx == 14 then
      upvalue_7680 = (idx) * 33 + 3
    end
    if idx == 11 then
      upvalue_7680 = (idx) * 33 + 9
    end
    if idx == 10 then
      upvalue_7680 = (idx) * 33 + 15
    end
    if idx == 2 then
      upvalue_7680 = (idx) * 33 + 36
    end
    Kscroll:setContentSize(CCSize(650, KSCROLL_CONTAINER_SIZE))
    Kscroll:setContentOffset(ccp(0, 300 - KSCROLL_CONTAINER_SIZE))
   end
  createVIPinfo(infoVipLv)
  return propertyLayer
end

return ui


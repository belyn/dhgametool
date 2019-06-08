-- Command line was: E:\github\dhgametool\scripts\ui\guildFight\teamDetail.lua 

local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local i18n = require("res.i18n")
local json = require("res.json")
local audio = require("res.audio")
local droidhangComponents = require("dhcomponents.DroidhangComponents")
local teamDetail = class("teamDetail", function()
  return cc.LayerColor:create(cc.c4b(0, 0, 0, POPUP_DARK_OPACITY))
end
)
teamDetail.create = function(l_2_0)
  return teamDetail.new(l_2_0)
end

teamDetail.ctor = function(l_3_0, l_3_1)
  local BG_WIDTH = 680
  local BG_HEIGHT = 278
  l_3_0:setScale(view.minScale)
  l_3_0:ignoreAnchorPointForPosition(false)
  l_3_0:setAnchorPoint(cc.p(0.5, 0.5))
  l_3_0:setPosition(scalep(480, 288))
  local bg = img.createUI9Sprite(img.ui.bag_outer)
  bg:setPreferredSize(CCSizeMake(BG_WIDTH, BG_HEIGHT))
  bg:setAnchorPoint(0.5, 0.5)
  bg:setPosition(l_3_0:getContentSize().width * 0.5, l_3_0:getContentSize().height * 0.5)
  bg:setScale(0.1)
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, 1)))
  l_3_0:addChild(bg)
  l_3_0.bg = bg
  local innerBg = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  innerBg:setPreferredSize(CCSizeMake(634, 228))
  bg:addChild(innerBg)
  droidhangComponents:mandateNode(innerBg, "7I2p_uVsW9Y")
  local closeBtn0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(BG_WIDTH - 26, BG_HEIGHT - 30)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    self.onAndroidBack()
   end)
  addBackEvent(l_3_0)
  l_3_0.onAndroidBack = function()
    self:removeFromParent()
   end
  l_3_0:registerScriptHandler(function(l_3_0)
    if l_3_0 == "enter" then
      self.notifyParentLock()
    elseif l_3_0 == "exit" then
      self.notifyParentUnlock()
    end
   end)
  l_3_0:setTouchEnabled(true)
  l_3_0:setTouchSwallowEnabled(true)
  local boardTab = img.createUI9Sprite(img.ui.select_tab_tab_bg)
  boardTab:setPreferredSize(CCSizeMake(604, 38))
  innerBg:addChild(boardTab)
  droidhangComponents:mandateNode(boardTab, "UBAg_zboAjG")
  local powerBg = img.createUISprite(img.ui.select_hero_power_bg)
  powerBg:setAnchorPoint(CCPoint(0, 0.5))
  powerBg:setPosition(CCPoint(0, boardTab:getContentSize().height / 2))
  boardTab:addChild(powerBg)
  local powerIcon = img.createUISprite(img.ui.power_icon)
  powerIcon:setScale(0.5)
  powerIcon:setPosition(CCPoint(30, powerBg:getContentSize().height / 2))
  powerBg:addChild(powerIcon)
  local lblPower = lbl.createFont2(20, string.format("%d", l_3_1.power))
  lblPower:setAnchorPoint(CCPoint(0, 0.5))
  lblPower:setPosition(CCPoint(55, powerBg:getContentSize().height / 2))
  powerBg:addChild(lblPower)
  local hids = {}
  if not l_3_1.camp then
    local pheroes = {}
  end
  for i,v in ipairs(pheroes) do
    hids[v.pos] = v
  end
  for i = 1, 6 do
    if hids[i] then
      local param = {id = hids[i].id, lv = hids[i].lv, showGroup = true, showStar = true, wake = hids[i].wake, orangeFx = nil, petID = require("data.pet").getPetID(hids), skin = hids[i].skin}
      showHero = img.createHeroHeadByParam(param)
      showHero:setAnchorPoint(ccp(0.5, 0.5))
      showHero:setScale(82 / showHero:getContentSize().width)
      innerBg:addChild(showHero)
      droidhangComponents:mandateNode(showHero, string.format("KWYr_Ppsxdg_%d", i))
    else
      local showHero = img.createUI9Sprite(img.ui.herolist_withouthero_bg)
      showHero:setPreferredSize(CCSize(82, 82))
      innerBg:addChild(showHero)
      droidhangComponents:mandateNode(showHero, string.format("KWYr_Ppsxdg_%d", i))
    end
  end
  local frontLabel = lbl.createFont1(16, i18n.global.select_hero_front.string, ccc3(115, 59, 5))
  bg:addChild(frontLabel)
  droidhangComponents:mandateNode(frontLabel, "h6KW_Q4ri12")
  local behindLabel = lbl.createFont1(16, i18n.global.select_hero_behind.string, ccc3(115, 59, 5))
  bg:addChild(behindLabel)
  droidhangComponents:mandateNode(behindLabel, "h6KW_dYWcHk")
end

return teamDetail


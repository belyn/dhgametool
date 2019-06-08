-- Command line was: E:\github\dhgametool\scripts\ui\guildFight\final_16.lua 

local final_16 = class("final_16", function()
  return cc.LayerColor:create(cc.c4b(0, 0, 0, POPUP_DARK_OPACITY))
end
)
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local i18n = require("res.i18n")
local json = require("res.json")
local audio = require("res.audio")
local player = require("data.player")
local net = require("net.netClient")
local lineCreate = require("ui.guildFight.lineCreate")
local droidhangComponents = require("dhcomponents.DroidhangComponents")
final_16.create = function(l_2_0)
  return final_16.new(l_2_0)
end

local space_height = 0
final_16.ctor = function(l_3_0, l_3_1)
  local BG_WIDTH = 786
  local BG_HEIGHT = 470
  local bg = img.createUI9Sprite(img.ui.tips_bg)
  bg:setPreferredSize(CCSize(BG_WIDTH, BG_HEIGHT))
  bg:setScale(0.1 * view.minScale)
  bg:setAnchorPoint(ccp(0.5, 0.5))
  bg:setPosition(view.midX, view.midY)
  bg:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, view.minScale)))
  l_3_0:addChild(bg)
  l_3_0.bg = bg
  local closeBtn0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, closeBtn0)
  closeBtn:setPosition(BG_WIDTH - 23, BG_HEIGHT - 26)
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(0, 0)
  bg:addChild(closeMenu)
  closeBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    self.onAndroidBack()
   end)
  local title = i18n.global.guildFight_final_16_8.string
  local titleLabel = lbl.createFont1(24, title, ccc3(255, 227, 134))
  titleLabel:setPosition(BG_WIDTH / 2, BG_HEIGHT - 36)
  bg:addChild(titleLabel)
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
  local findGuild = function(l_4_0)
    if not resData.guilds[l_4_0] then
      return {}
    end
   end
  local data = {teams = {}, wins = {}, logIds = {}}
  if not l_3_1.align1 then
    local align = {}
  end
  if align then
    for i,info in ipairs(align) do
      data.teams[i * 2 - 1] = findGuild(align[i].atk)
      data.teams[i * 2] = findGuild(align[i].def)
      data.wins[i] = align[i].win
      data.logIds[i] = align[i].logid
    end
  end
  local batCount = 8
  if  align < batCount then
    local hashMap = {}
    for _,info in ipairs(align) do
      hashMap[info.atk] = true
      hashMap[info.def] = true
    end
    for i =  align + 1, batCount do
      local itemId = nil
      for idx = 1, batCount * 2 do
        if not hashMap[idx] then
          itemId = idx
      else
        end
      end
      if itemId then
        hashMap[itemId] = true
        table.insert(data.teams, findGuild(itemId))
        table.insert(data.teams, {})
        table.insert(data.wins, true)
      else
        table.insert(data.teams, {})
        table.insert(data.teams, {})
      end
    end
  end
  local createScroll = function()
    local scroll_params = {width = 760, height = 400}
    local lineScroll = require("ui.lineScroll")
    return lineScroll.create(scroll_params)
   end
  local createItem = function(l_6_0)
    local item = img.createUISprite(img.ui.fight_hurts_bg_2)
    local item_w = item:getContentSize().width
    local item_h = item:getContentSize().height
    local item1 = CCSprite:create()
    local item2 = img.createUISprite(img.ui.fight_hurts_bg_2)
    item2:setAnchorPoint(0, 0.5)
    item2:setPosition(352, item_h / 2)
    item2:setFlipX(true)
    item:addChild(item2)
    if l_6_0 % 2 == 0 then
      item:setOpacity(70)
      item2:setOpacity(70)
    end
    local line = img.createUISprite(img.ui.guildFight_line168)
    line:setPosition(344, item_h / 2)
    item:addChild(line)
    local llogo = img.createGFlag(data.teams[l_6_0 * 2 - 1].logo)
    llogo:setScale(0.8)
    llogo:setPosition(44, item_h / 2)
    item:addChild(llogo)
    if data.teams[l_6_0 * 2].logo then
      local rlogo = img.createGFlag(data.teams[l_6_0 * 2].logo)
      rlogo:setScale(0.8)
      rlogo:setPosition(644, item_h / 2)
      item:addChild(rlogo)
      local rname = lbl.createMixFont1(16, data.teams[l_6_0 * 2].name, ccc3(255, 246, 223))
      rname:setAnchorPoint(1, 0.5)
      rname:setPosition(593, 56)
      item:addChild(rname)
      local rsevbg = img.createUISprite(img.ui.anrea_server_bg)
      rsevbg:setScale(0.9)
      rsevbg:setPosition(574, 30)
      item:addChild(rsevbg)
      local rsevlab = lbl.createFont1(16, getSidname(data.teams[l_6_0 * 2].sid), ccc3(247, 234, 209))
      rsevlab:setPosition(rsevbg:getContentSize().width / 2, rsevbg:getContentSize().height / 2)
      rsevbg:addChild(rsevlab)
    end
    local lname = lbl.createMixFont1(16, data.teams[l_6_0 * 2 - 1].name, ccc3(255, 246, 223))
    lname:setAnchorPoint(0, 0.5)
    lname:setPosition(92, 56)
    item:addChild(lname)
    local lsevbg = img.createUISprite(img.ui.anrea_server_bg)
    lsevbg:setScale(0.9)
    lsevbg:setPosition(114, 30)
    item:addChild(lsevbg)
    local lsevlab = lbl.createFont1(16, string.format("S%d", data.teams[l_6_0 * 2 - 1].sid), ccc3(247, 234, 209))
    lsevlab:setPosition(lsevbg:getContentSize().width / 2, lsevbg:getContentSize().height / 2)
    lsevbg:addChild(lsevlab)
    local lshowResult, rshowResult = nil, nil
    if data.wins[l_6_0] == true then
      lshowResult = img.createUISprite(img.ui.arena_icon_win)
      rshowResult = img.createUISprite(img.ui.arena_icon_lost)
    else
      lshowResult = img.createUISprite(img.ui.arena_icon_lost)
      rshowResult = img.createUISprite(img.ui.arena_icon_win)
    end
    lshowResult:setPosition(300, item_h / 2)
    item:addChild(lshowResult)
    if data.teams[l_6_0 * 2].logo then
      rshowResult:setPosition(388, item_h / 2)
      item:addChild(rshowResult)
    end
    if data.teams[l_6_0 * 2].logo and data.logIds[l_6_0] then
      local btnVideoSprite = img.createUISprite(img.ui.arena_button_video)
      local btnVideo = SpineMenuItem:create(json.ui.button, btnVideoSprite)
      btnVideo:setPosition(714, item_h / 2)
      local menuVideo = CCMenu:createWithItem(btnVideo)
      menuVideo:setPosition(0, 0)
      item:addChild(menuVideo, 100)
      btnVideo:registerScriptTapHandler(function()
        audio.play(audio.button)
        local params = {sid = player.sid, log_id = data.logIds[_idx]}
        addWaitNet()
        net:guild_fight_log(params, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          self:addChild(require("ui.guildFight.videoDetail").create(data.wins[_idx], data.teams[_idx * 2 - 1], data.teams[_idx * 2], l_1_0), 100)
            end)
         end)
    end
    return item
   end
  local tlayer = CCLayer:create()
  local scroll = createScroll()
  scroll:setAnchorPoint(CCPoint(0, 0))
  scroll:setPosition(CCPoint(0, 8))
  bg:addChild(scroll)
  scroll.addSpace(4)
  for i = 1, batCount do
    if data.teams[i * 2 - 1].logo then
      local tmp_item = createItem(i)
      tmp_item.ax = 1
      tmp_item.px = 365
      scroll.addItem(tmp_item)
      if ii ~= batCount then
        scroll.addSpace(space_height)
      end
    end
  end
  scroll.setOffsetBegin()
end

return final_16


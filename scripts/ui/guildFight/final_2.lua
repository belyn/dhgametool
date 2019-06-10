-- Command line was: E:\github\dhgametool\scripts\ui\guildFight\final_2.lua 

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
local final_2 = class("final_2", function()
  return cc.LayerColor:create(cc.c4b(0, 0, 0, POPUP_DARK_OPACITY))
end
)
final_2.create = function(l_2_0)
  return final_2.new(l_2_0)
end

final_2.ctor = function(l_3_0, l_3_1)
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
  local title = i18n.global.guildFight_final_2_1.string
  local titleLabel = lbl.createFont1(24, title, ccc3(255, 227, 134))
  titleLabel:setPosition(BG_WIDTH / 2, BG_HEIGHT - 36)
  bg:addChild(titleLabel)
  local line = img.createUISprite(img.ui.help_line)
  line:setScaleX(730 / line:getContentSize().width)
  line:setPosition(BG_WIDTH / 2, BG_HEIGHT - 64)
  bg:addChild(line)
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
  local championBg = img.createUI9Sprite(img.ui.guildFight_champion_bg)
  bg:addChild(championBg, 10)
  droidhangComponents:mandateNode(championBg, "vf8U_66TWCh")
  local teamLeftBg = img.createUI9Sprite(img.ui.guildFight_bar_bg)
  teamLeftBg:setPreferredSize(CCSizeMake(286, 124))
  bg:addChild(teamLeftBg, 10)
  droidhangComponents:mandateNode(teamLeftBg, "zFFL_7ohsyz")
  local teamRightBg = img.createUI9Sprite(img.ui.guildFight_bar_bg)
  teamRightBg:setPreferredSize(CCSizeMake(286, 124))
  bg:addChild(teamRightBg, 10)
  droidhangComponents:mandateNode(teamRightBg, "Va4x_U08qgH")
  local showItem = function(l_4_0, l_4_1)
    if not l_4_1 or not l_4_1.logo then
      return 
    end
    local showHead = img.createGFlag(l_4_1.logo)
    showHead:setScale(0.8)
    l_4_0:addChild(showHead)
    droidhangComponents:mandateNode(showHead, "rMQ4_tvyxAT")
    local showName = lbl.createFontTTF(18, l_4_1.name, ccc3(114, 72, 53))
    showName:setAnchorPoint(ccp(0, 0.5))
    l_4_0:addChild(showName)
    droidhangComponents:mandateNode(showName, "rMQ4_A269NH")
    local serverBg = img.createUISprite(img.ui.anrea_server_bg)
    l_4_0:addChild(serverBg)
    droidhangComponents:mandateNode(serverBg, "rMQ4_Xu1oZv")
    local serverLabel = lbl.createFont1(16, getSidname(l_4_1.sid), ccc3(255, 251, 215))
    serverLabel:setPosition(serverBg:getContentSize().width * 0.5, serverBg:getContentSize().height * 0.5)
    serverBg:addChild(serverLabel)
   end
  local data = {}
  local findGuild = function(l_5_0)
    return resData.guilds[l_5_0]
   end
  if not l_3_1.align4 then
    local align4 = {}
  end
   -- DECOMPILER ERROR: Overwrote pending register.

  if align4 then
    do return end
  end
  data.logIds, data.wins, data.teams = {align4[1].logid}, {findGuild(align4[1].atk).win}, {}
  data.teams = {{}, {}}
  if data.wins[1] then
    showItem(championBg, data.teams[1])
  else
    showItem(championBg, data.teams[2])
  end
  showItem(teamLeftBg, data.teams[1])
  showItem(teamRightBg, data.teams[2])
  local vecArray = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  local lineLeft = cc.p(0, 0).create(cc.p(0, 26), cc.p(180, 26)[1] == true)
   -- DECOMPILER ERROR: Overwrote pending register.

  bg:addChild(cc.p(180, 52))
  droidhangComponents:mandateNode(lineLeft, "I4xM_WAmyZ2_xx")
  local vecArray = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  local lineRight = cc.p(0, 0).create(cc.p(0, 26), cc.p(-180, 26)[1] ~= true)
   -- DECOMPILER ERROR: Overwrote pending register.

  bg:addChild(cc.p(-180, 52))
  droidhangComponents:mandateNode(lineRight, "I4xM_abvjvi")
  if data.logIds then
    local btnVideoSprite = img.createUISprite(img.ui.arena_button_video)
    local btnVideo = SpineMenuItem:create(json.ui.button, btnVideoSprite)
    btnVideo:setPosition(52, 49)
    local menuVideo = CCMenu:createWithItem(btnVideo)
    menuVideo:setPosition(0, 0)
    bg:addChild(menuVideo, 100)
    btnVideo:registerScriptTapHandler(function()
      audio.play(audio.button)
      local params = {sid = player.sid, log_id = data.logIds[1]}
      addWaitNet()
      net:guild_fight_log(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        self:addChild(require("ui.guildFight.videoDetail").create(data.wins[1], data.teams[1], data.teams[2], l_1_0), 100)
         end)
      end)
    droidhangComponents:mandateNode(btnVideo, "TTxM_abvjvi")
  end
end

return final_2


-- Command line was: E:\github\dhgametool\scripts\ui\guildFight\final_4.lua 

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
local final_4 = class("final_4", function()
  return cc.LayerColor:create(cc.c4b(0, 0, 0, POPUP_DARK_OPACITY))
end
)
final_4.create = function(l_2_0)
  return final_4.new(l_2_0)
end

final_4.ctor = function(l_3_0, l_3_1)
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
  local title = i18n.global.guildFight_final_4_2.string
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
  local showItem = function(l_4_0, l_4_1)
    if not l_4_1 or not l_4_1.logo then
      return 
    end
    local showHead = img.createGFlag(l_4_1.logo)
    showHead:setScale(0.65)
    l_4_0:addChild(showHead)
    droidhangComponents:mandateNode(showHead, "75J1_5INRa5")
    local showName = lbl.createFontTTF(14, l_4_1.name, ccc3(114, 72, 53))
    showName:setAnchorPoint(ccp(0, 0.5))
    l_4_0:addChild(showName)
    droidhangComponents:mandateNode(showName, "75J1_fVHTuo")
    local serverBg = img.createUISprite(img.ui.anrea_server_bg)
    serverBg:setScale(0.7)
    l_4_0:addChild(serverBg)
    droidhangComponents:mandateNode(serverBg, "75J1_u18pAe")
    local serverLabel = lbl.createFont1(16, getSidname(l_4_1.sid), ccc3(255, 251, 215))
    serverLabel:setPosition(serverBg:getContentSize().width * 0.5, serverBg:getContentSize().height * 0.5)
    serverBg:addChild(serverLabel)
   end
  local findGuild = function(l_5_0)
    return resData.guilds[l_5_0]
   end
  local data = {teams = {}, wins = {}, logIds = {}}
  if not l_3_1.align3 then
    local align = {}
  end
  if align then
    for i,info in ipairs(align) do
      do
        data.teams[i * 2 - 1] = findGuild(align[i].atk)
        data.teams[i * 2] = findGuild(align[i].def)
        data.wins[i] = align[i].win
        data.logIds[i] = align[i].logid
      end
    end
  end
  local batCount = 2
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
  for i = 1, batCount do
    local championBg = img.createUI9Sprite(img.ui.guildFight_bar_bg)
    championBg:setPreferredSize(CCSizeMake(214, 100))
    bg:addChild(championBg, 10)
    droidhangComponents:mandateNode(championBg, string.format("MqqO_7GRb9f%d", i))
    local teamLeftBg = img.createUI9Sprite(img.ui.botton_fram_2)
    teamLeftBg:setPreferredSize(CCSizeMake(214, 100))
    bg:addChild(teamLeftBg, 10)
    droidhangComponents:mandateNode(teamLeftBg, string.format("MqqO_rNjEqr%d", i))
    local teamRightBg = img.createUI9Sprite(img.ui.botton_fram_2)
    teamRightBg:setPreferredSize(CCSizeMake(214, 100))
    bg:addChild(teamRightBg, 10)
    droidhangComponents:mandateNode(teamRightBg, string.format("MqqO_GKVyIc%d", i))
    if data.wins[i] then
      showItem(championBg, data.teams[i * 2 - 1])
    else
      showItem(championBg, data.teams[i * 2])
    end
    showItem(teamLeftBg, data.teams[i * 2 - 1])
    showItem(teamRightBg, data.teams[i * 2])
    if data.logIds[i] then
      local btnVideoSprite = img.createUISprite(img.ui.arena_button_video)
      local btnVideo = SpineMenuItem:create(json.ui.button, btnVideoSprite)
      btnVideo:setPosition(52, 49)
      local menuVideo = CCMenu:createWithItem(btnVideo)
      menuVideo:setPosition(0, 0)
      bg:addChild(menuVideo, 100)
      btnVideo:registerScriptTapHandler(function()
        audio.play(audio.button)
        local params = {sid = player.sid, log_id = data.logIds[i]}
        addWaitNet()
        net:guild_fight_log(params, function(l_1_0)
          delWaitNet()
          tbl2string(l_1_0)
          self:addChild(require("ui.guildFight.videoDetail").create(data.wins[i], data.teams[i * 2 - 1], data.teams[i * 2], l_1_0), 100)
            end)
         end)
      droidhangComponents:mandateNode(btnVideo, "TTxM_abvjvi_4_%d" .. i)
    end
  end
  local vecArray = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  local line0 = cc.p(0, 0).create(cc.p(10, 0), cc.p(10, -100)[1] == true)
   -- DECOMPILER ERROR: Overwrote pending register.

  bg:addChild(cc.p(22, -100))
   -- DECOMPILER ERROR: Overwrote pending register.

  droidhangComponents:mandateNode(line0, cc.p(22, -36))
   -- DECOMPILER ERROR: Overwrote pending register.

  local vecArray = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  local line1 = cc.p(0, 0).create(cc.p(10, cc.p(32, -36)), cc.p(10, 100)[1] ~= true)
   -- DECOMPILER ERROR: Overwrote pending register.

  bg:addChild(cc.p(22, 100))
   -- DECOMPILER ERROR: Overwrote pending register.

  droidhangComponents:mandateNode(line1, cc.p(22, 164))
   -- DECOMPILER ERROR: Overwrote pending register.

  local vecArray = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  local line2 = cc.p(0, 0).create(cc.p(-10, cc.p(32, 164)), cc.p(-10, -100)[2] == true)
   -- DECOMPILER ERROR: Overwrote pending register.

  bg:addChild(cc.p(-22, -100))
   -- DECOMPILER ERROR: Overwrote pending register.

  droidhangComponents:mandateNode(line2, cc.p(-22, -164))
   -- DECOMPILER ERROR: Overwrote pending register.

  local vecArray = {}
   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

   -- DECOMPILER ERROR: Overwrote pending register.

  do
    local line3 = cc.p(0, 0).create(cc.p(-10, cc.p(-32, -164)), cc.p(-10, 100)[2] ~= true)
     -- DECOMPILER ERROR: Overwrote pending register.

    bg:addChild(cc.p(-22, 100))
     -- DECOMPILER ERROR: Overwrote pending register.

    droidhangComponents:mandateNode(line3, cc.p(-22, 36))
  end
   -- Warning: undefined locals caused missing assignments!
end

return final_4


-- Command line was: E:\github\dhgametool\scripts\ui\guildFight\guildFightMain.lua 

local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local i18n = require("res.i18n")
local json = require("res.json")
local audio = require("res.audio")
local dataGuild = require("data.guild")
local dataPlayer = require("data.player")
local dataHeros = require("data.heros")
local net = require("net.netClient")
local ENEGY_MAX = 40
local ENEGY_DURATION = 10800
local FIGHT_DURATION = 20
local droidhangComponents = require("dhcomponents.DroidhangComponents")
local guildFightMain = class("guildFightMain", function()
  return cc.LayerColor:create(cc.c4b(0, 0, 0, POPUP_DARK_OPACITY))
end
)
guildFightMain.create = function(l_2_0)
  return guildFightMain.new(l_2_0)
end

guildFightMain.ctor = function(l_3_0)
  img.load(img.packedOthers.spine_ui_baoshihecheng)
  img.load(img.packedOthers.ui_guild_fight)
  img.load(img.packedOthers.spine_ui_guildwar_ui)
  l_3_0:registerScriptHandler(function(l_1_0)
    if l_1_0 == "cleanup" then
      img.unload(img.packedOthers.spine_ui_baoshihecheng)
      img.unload(img.packedOthers.ui_guild_fight)
      img.unload(img.packedOthers.spine_ui_guildwar_ui)
    end
   end)
  local bg = img.createUI9Sprite(img.ui.bag_outer)
  bg:setPreferredSize(CCSizeMake(930, 550))
  bg:setAnchorPoint(0.5, 0.5)
  bg:setPosition(scalep(480, 288))
  bg:setScale(view.minScale)
  l_3_0:addChild(bg)
  l_3_0.bg = bg
  local detailSprite = img.createUISprite(img.ui.btn_help)
  local detailBtn = SpineMenuItem:create(json.ui.button, detailSprite)
  detailBtn:setPosition(710, 505)
  local detailMenu = CCMenu:create()
  detailMenu:setPosition(0, 0)
  bg:addChild(detailMenu, 20)
  detailMenu:addChild(detailBtn)
  detailBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    self:addChild(require("ui.help").create(i18n.global.help_guildFight.string), 1000)
   end)
  local btn_tabLeft0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
  btn_tabLeft0:setPreferredSize(CCSizeMake(200, 48))
  local btn_tabLeft_sel = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_tabLeft_sel:setPreferredSize(CCSizeMake(200, 48))
  btn_tabLeft_sel:setPosition(CCPoint(btn_tabLeft0:getContentSize().width / 2, btn_tabLeft0:getContentSize().height / 2))
  btn_tabLeft0:addChild(btn_tabLeft_sel)
  local lbl_tabLeft = lbl.createFont1(18, i18n.global.guildFight_tab_1.string, ccc3(115, 59, 5))
  lbl_tabLeft:setPosition(CCPoint(btn_tabLeft0:getContentSize().width / 2, btn_tabLeft0:getContentSize().height / 2))
  btn_tabLeft0:addChild(lbl_tabLeft)
  local btn_tabLeft = SpineMenuItem:create(json.ui.button, btn_tabLeft0)
  droidhangComponents:mandateNode(btn_tabLeft, "Bz4W_74Fa95")
  local btn_tabLeft_menu = CCMenu:createWithItem(btn_tabLeft)
  btn_tabLeft_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_tabLeft_menu, 1)
  local btn_tabRight0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
  btn_tabRight0:setPreferredSize(CCSizeMake(200, 48))
  local btn_tabRight_sel = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_tabRight_sel:setPreferredSize(CCSizeMake(200, 48))
  btn_tabRight_sel:setPosition(CCPoint(btn_tabRight0:getContentSize().width / 2, btn_tabRight0:getContentSize().height / 2))
  btn_tabRight0:addChild(btn_tabRight_sel)
  local lbl_tabRight = lbl.createFont1(18, i18n.global.guildFight_tab_2.string, ccc3(115, 59, 5))
  lbl_tabRight:setPosition(CCPoint(btn_tabRight0:getContentSize().width / 2, btn_tabRight0:getContentSize().height / 2))
  btn_tabRight0:addChild(lbl_tabRight)
  local btn_tabRight = SpineMenuItem:create(json.ui.button, btn_tabRight0)
  droidhangComponents:mandateNode(btn_tabRight, "wpnE_wchUX5")
  local btn_tabRightmenu = CCMenu:createWithItem(btn_tabRight)
  btn_tabRightmenu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_tabRightmenu, 1)
  btn_tabLeft_sel:setVisible(false)
  btn_tabRight_sel:setVisible(false)
  local touchbeginx, touchbeginy, isclick, enegyFlag, last_touch_sprite = nil, nil, nil, nil, nil
  local onTouchBegan = function(l_3_0, l_3_1)
    touchbeginx, upvalue_512 = l_3_0, l_3_1
    upvalue_1024 = true
    if self.rightTabNode and self.enegyBottom then
      local p0 = self.enegyBottom:getParent():convertToNodeSpace(ccp(l_3_0, l_3_1))
      if p0 and self.enegyBottom:boundingBox():containsPoint(p0) then
        upvalue_2048 = true
        audio.play(audio.button)
        self.enegyToast:setVisible(true)
        upvalue_3072 = self.enegyBottom
        last_touch_sprite._scale = 1
        playAnimTouchBegin(last_touch_sprite)
      end
    end
    return true
   end
  local onTouchMoved = function(l_4_0, l_4_1)
    return true
   end
  local onTouchEnded = function(l_5_0, l_5_1)
    if isclick and enegyFlag == true then
      upvalue_512 = false
      if self.rightTabNode then
        if last_touch_sprite and not tolua.isnull(last_touch_sprite) then
          playAnimTouchEnd(last_touch_sprite)
          upvalue_1536 = nil
        end
        self.enegyToast:setVisible(false)
      end
    end
   end
  local onTouch = function(l_6_0, l_6_1, l_6_2)
    if l_6_0 == "began" then
      return onTouchBegan(l_6_1, l_6_2)
    elseif l_6_0 == "moved" then
      return onTouchMoved(l_6_1, l_6_2)
    else
      return onTouchEnded(l_6_1, l_6_2)
    end
   end
  l_3_0:registerScriptTouchHandler(onTouch, false, -128, false)
  l_3_0:setTouchEnabled(true)
  local backEvent = function()
    self:removeFromParentAndCleanup(true)
   end
  local close0 = img.createUISprite(img.ui.close)
  local closeBtn = SpineMenuItem:create(json.ui.button, close0)
  droidhangComponents:mandateNode(closeBtn, "SCVo_yTQYof")
  local closeMenu = CCMenu:createWithItem(closeBtn)
  closeMenu:setPosition(CCPoint(0, 0))
  bg:addChild(closeMenu, 1)
  closeBtn:registerScriptTapHandler(function()
    backEvent()
   end)
  addBackEvent(l_3_0)
  l_3_0.onAndroidBack = function()
    backEvent()
   end
  local onLeftTab = function()
    btn_tabLeft_sel:setVisible(true)
    btn_tabRight_sel:setVisible(false)
    btn_tabLeft:setEnabled(false)
    btn_tabRight:setEnabled(true)
    if self.demoFightLayer then
      self.demoFightLayer:removeFromParent()
      self.demoFightLayer = nil
    end
    if self.rightTabNode then
      self.rightTabNode:removeFromParent()
      self.rightTabNode = nil
    end
    if self.enegyToast then
      self.enegyToast:removeFromParent()
      self.enegyToast = nil
    end
    local params = {sid = dataPlayer.sid}
    addWaitNet()
    net:guild_fight_sync(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status < 0 then
        showToast("status:" .. l_1_0.status)
        return 
      end
      if not l_1_0.mbrs then
        l_1_0.mbrs = {}
      end
      if not l_1_0.uids then
        l_1_0.uids = {}
      end
      if not l_1_0.mask then
        l_1_0.mask = {}
      end
      if l_1_0.cd and l_1_0.cd < 0 then
        l_1_0.cd = 0
      end
      local uidMap = {}
      for i,uid in ipairs(l_1_0.uids) do
        uidMap[uid] = i
      end
      table.sort(l_1_0.mbrs, function(l_1_0, l_1_1)
        if uidMap[l_1_0.uid] >= uidMap[l_1_1.uid] then
          return not uidMap[l_1_0.uid] or not uidMap[l_1_1.uid]
        end
        do return end
        if not uidMap[l_1_0.uid] and uidMap[l_1_1.uid] then
          return false
        else
          if uidMap[l_1_0.uid] and not uidMap[l_1_1.uid] then
            return true
          else
            return l_1_0.uid < l_1_1.uid
          end
        end
         end)
      l_1_0.pull_time = os.time()
      self:createLeftTab(l_1_0)
      end)
   end
  btn_tabLeft:registerScriptTapHandler(function()
    audio.play(audio.button)
    onLeftTab()
   end)
  local onRightTab = function()
    if self.guildData.status == 1 and not self.guildData.reg then
      showToast(i18n.global.guiidFight_toast_reg.string)
      return 
    end
    btn_tabLeft_sel:setVisible(false)
    btn_tabRight_sel:setVisible(true)
    btn_tabLeft:setEnabled(true)
    btn_tabRight:setEnabled(false)
    if self.leftTabNode then
      self.leftTabNode:removeFromParent()
      self.leftTabNode = nil
    end
    local params = {sid = dataPlayer.sid}
    addWaitNet()
    net:guild_fight_sync_2(net, params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status < 0 then
        showToast("status:" .. l_1_0.status)
        return 
      end
      if not l_1_0.guilds then
        l_1_0.guilds = {}
      end
      if l_1_0.cd and l_1_0.cd < 0 then
        l_1_0.cd = 0
      end
      self:createRightTab(l_1_0)
      end)
   end
  btn_tabRight:registerScriptTapHandler(function()
    audio.play(audio.button)
    onRightTab()
   end)
  onLeftTab()
  l_3_0.onRightTab = onRightTab
  l_3_0.onLeftTab = onLeftTab
end

guildFightMain.createLeftTab = function(l_4_0, l_4_1)
  if l_4_1 then
    l_4_0.guildData = l_4_1
  else
    l_4_1 = l_4_0.guildData
  end
  l_4_1.logo = dataGuild.guildObj.logo
  l_4_1.name = dataGuild.guildObj.name
  l_4_1.sid = dataPlayer.sid
  if l_4_0.leftTabNode then
    l_4_0.leftTabNode:removeFromParent()
    l_4_0.leftTabNode = nil
  end
  local leftTabNode = cc.Node:create()
  l_4_0.leftTabNode = leftTabNode
  l_4_0.bg:addChild(leftTabNode)
  local innerBg = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  innerBg:setPreferredSize(CCSizeMake(560, 440))
  leftTabNode:addChild(innerBg)
  droidhangComponents:mandateNode(innerBg, "m9cS_rw5Zdz")
  local boardTab = img.createUI9Sprite(img.ui.select_tab_tab_bg)
  boardTab:setPreferredSize(CCSizeMake(500, 38))
  innerBg:addChild(boardTab)
  droidhangComponents:mandateNode(boardTab, "Ep8y_s4aqQG")
  local powerBg = img.createUISprite(img.ui.select_hero_power_bg)
  powerBg:setAnchorPoint(CCPoint(0, 0.5))
  powerBg:setPosition(CCPoint(0, boardTab:getContentSize().height / 2))
  boardTab:addChild(powerBg)
  local powerIcon = img.createUISprite(img.ui.power_icon)
  powerIcon:setScale(0.5)
  powerIcon:setPosition(CCPoint(30, powerBg:getContentSize().height / 2))
  powerBg:addChild(powerIcon)
  local powerCount = 0
  for _,mbr in ipairs(l_4_1.mbrs) do
    local selected = false
    for _,uid in ipairs(l_4_1.uids) do
      if uid == mbr.uid then
        selected = true
    else
      end
    end
    powerCount = powerCount + (not selected or mbr.power or 0)
  end
  l_4_0.powerCount = powerCount
  local lblPower = lbl.createFont2(20, string.format("%d", powerCount))
  lblPower:setAnchorPoint(CCPoint(0, 0.5))
  lblPower:setPosition(CCPoint(55, powerBg:getContentSize().height / 2))
  powerBg:addChild(lblPower)
  local btnSettingSprite = img.createLogin9Sprite(img.login.button_9_small_green)
  btnSettingSprite:setPreferredSize(CCSize(150, 42))
  local btnSettingLab = lbl.createFont1(16, i18n.global.arena3v3_btn_setting.string, ccc3(27, 89, 2))
  btnSettingLab:setPosition(btnSettingSprite:getContentSize().width / 2, btnSettingSprite:getContentSize().height / 2)
  btnSettingSprite:addChild(btnSettingLab)
  local btnSetting = SpineMenuItem:create(json.ui.button, btnSettingSprite)
  droidhangComponents:mandateNode(btnSetting, "phOd_uDIpP5")
  local menuSetting = CCMenu:createWithItem(btnSetting)
  menuSetting:setPosition(0, 0)
  boardTab:addChild(menuSetting)
  btnSetting:registerScriptTapHandler(function()
    audio.play(audio.button)
    self:addChild(require("ui.guildFight.settingLineup").create(data, function(l_1_0)
      self:createLeftTab(l_1_0)
      end), 1000)
   end)
  if dataGuild.selfTitle() <= dataGuild.TITLE.RESIDENT then
    btnSetting:setVisible(false)
  end
  local guildTeamTitle = lbl.createFont2(18, i18n.global.guildFight_guild_team.string, ccc3(255, 243, 141))
  guildTeamTitle:setAnchorPoint(0, 0.5)
  innerBg:addChild(guildTeamTitle)
  droidhangComponents:mandateNode(guildTeamTitle, "iFF9_j1MWOF")
  if not l_4_1.uids then
    local teamCount =  {}
  end
  local guildTeamDesc = lbl.createFont2(18, string.format("%d/%d", teamCount,  l_4_1.mbrs))
  guildTeamDesc:setAnchorPoint(0, 0.5)
  guildTeamDesc:setPosition(guildTeamTitle:getPositionX() + guildTeamTitle:getContentSize().width * guildTeamTitle:getScaleX(), guildTeamTitle:getPositionY())
  innerBg:addChild(guildTeamDesc)
  local BG_WIDTH = innerBg:getContentSize().width
  local BG_HEIGHT = 356
  local SCROLL_MARGIN_TOP = 26
  local SCROLL_MARGIN_BOTTOM = 14
  local SCROLL_VIEW_WIDTH = BG_WIDTH
  local SCROLL_VIEW_HEIGHT = BG_HEIGHT - SCROLL_MARGIN_TOP - SCROLL_MARGIN_BOTTOM
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setViewSize(CCSize(SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT))
  scroll:setPosition(0, SCROLL_MARGIN_BOTTOM)
  innerBg:addChild(scroll)
  local createItem = function(l_2_0, l_2_1)
    local bg = img.createUI9Sprite(img.ui.botton_fram_2)
    bg:setPreferredSize(CCSizeMake(504, 100))
    if l_2_1 then
      local numLabel = lbl.createFont1(18, string.format("%d", l_2_1), ccc3(115, 59, 5))
      bg:addChild(numLabel)
      droidhangComponents:mandateNode(numLabel, "Zlpx_yPScHf")
    end
    local playerLogo = img.createPlayerHeadForArena(l_2_0.logo)
    playerLogo:setScale(0.8)
    bg:addChild(playerLogo)
    droidhangComponents:mandateNode(playerLogo, "ICm4_5q9HLP")
    local showName = lbl.createFontTTF(16, l_2_0.name, ccc3(81, 39, 18))
    bg:addChild(showName)
    droidhangComponents:mandateNode(showName, "ICm4_fOxOXZ")
    local player_lv_bg = img.createUISprite(img.ui.main_lv_bg)
    local lbl_player_lv = lbl.createFont2(14, "" .. l_2_0.lv)
    lbl_player_lv:setPosition(CCPoint(player_lv_bg:getContentSize().width / 2, player_lv_bg:getContentSize().height / 2))
    player_lv_bg:addChild(lbl_player_lv)
    playerLogo:addChild(player_lv_bg)
    player_lv_bg:setScale(1.1764705882353)
    droidhangComponents:mandateNode(player_lv_bg, "ICm4_PEFRPi")
    local hids = {}
    if not l_2_0.camp then
      local pheroes = {}
    end
    for i,v in ipairs(pheroes) do
      hids[v.pos] = v
    end
    local dx = 46
    local sx0 = 158
    local sx1 = sx0 + dx + 58
    local sxAry = {sx0, sx0 + dx, sx1, sx1 + dx, sx1 + dx * 2, sx1 + dx * 3}
    for i = 1, 6 do
      local showHero = nil
      if hids[i] then
        local param = {id = hids[i].id, lv = hids[i].lv, showGroup = true, showStar = true, wake = hids[i].wake, orangeFx = nil, petID = require("data.pet").getPetID(hids), skin = hids[i].skin}
        showHero = img.createHeroHeadByParam(param)
      else
        showHero = img.createUISprite(img.ui.herolist_head_bg)
      end
      showHero:setAnchorPoint(ccp(0.5, 0.5))
      showHero:setScale(0.45)
      showHero:setPosition(sxAry[i], 36)
      bg:addChild(showHero)
    end
    local btn_search0 = img.createUISprite(img.ui.guildFight_icon_search)
    local btn_search = SpineMenuItem:create(json.ui.button, btn_search0)
    droidhangComponents:mandateNode(btn_search, "yand_Hu3IhP")
    local btn_search_menu = CCMenu:createWithItem(btn_search)
    btn_search_menu:setPosition(CCPoint(0, 0))
    bg:addChild(btn_search_menu)
    btn_search:registerScriptTapHandler(function()
      audio.play(audio.button)
      self:addChild(require("ui.guildFight.teamDetail").create(player), 1000)
      end)
    return bg
   end
  local height = 0
  local index = 0
  local itemAry = {}
  if not l_4_1.mbrs then
    for _,mbr in ipairs({}) do
    end
    local selected = false
    if not l_4_1.uids then
      for _,uid in ipairs({}) do
      end
      if uid == mbr.uid then
        selected = true
    else
      end
    end
    local item = nil
    if selected then
      index = index + 1
      item = createItem(mbr, index)
    else
      item = createItem(mbr, nil)
    end
    height = height + item:getContentSize().height + 4
    table.insert(itemAry, item)
    scroll:addChild(item)
  end
  local sy = height - 0
  for _,item in ipairs(itemAry) do
    item:setAnchorPoint(0.5, 0.5)
    item:setPosition(SCROLL_VIEW_WIDTH * 0.5, sy - item:getContentSize().height * 0.5)
    sy = sy - item:getContentSize().height - 4
  end
  scroll:setContentSize(CCSize(SCROLL_VIEW_WIDTH, height))
  scroll:setContentOffset(ccp(0, SCROLL_VIEW_HEIGHT - (height)))
  local infoBg = img.createUISprite(img.ui.guildFight_infoBg)
  leftTabNode:addChild(infoBg)
  droidhangComponents:mandateNode(infoBg, "16iU_gCbA6A")
  local infoBgTitle = lbl.createFont2(16, i18n.global.guildFight_points_race_title.string, ccc3(255, 232, 155))
  infoBg:addChild(infoBgTitle)
  droidhangComponents:mandateNode(infoBgTitle, "OSwy_XQutm1")
  local lbranch = img.createUISprite(img.ui.guildFight_branch)
  infoBg:addChild(lbranch)
  droidhangComponents:mandateNode(lbranch, "OSwy_XQuibl")
  local rbranch = img.createUISprite(img.ui.guildFight_branch)
  infoBg:addChild(rbranch)
  rbranch:setFlipX(true)
  droidhangComponents:mandateNode(rbranch, "OSwy_XQuibr")
  local infoRankTitle = lbl.createFont2(14, i18n.global.guildFight_rank.string, ccc3(255, 243, 141))
  infoBg:addChild(infoRankTitle)
  droidhangComponents:mandateNode(infoRankTitle, "OSwy_13uT7b")
  local infoRankDesc = lbl.createFont2(28, "", ccc3(255, 255, 255))
  if l_4_1.rank then
    infoRankDesc:setString(string.format("%d", l_4_1.rank))
  else
    infoRankDesc:setString("--")
  end
  infoBg:addChild(infoRankDesc)
  droidhangComponents:mandateNode(infoRankDesc, "OSwy_ctyPyo")
  local infoCutLine = img.createUISprite(img.ui.guildFight_cut_line)
  infoBg:addChild(infoCutLine)
  droidhangComponents:mandateNode(infoCutLine, "OSwy_gK2J8F")
  local infoScoreTitle = lbl.createFont2(16, i18n.global.guildFight_score.string, ccc3(255, 243, 141))
  infoScoreTitle:setAnchorPoint(0, 0.5)
  infoBg:addChild(infoScoreTitle)
  droidhangComponents:mandateNode(infoScoreTitle, "8dxy_4HDkZK")
  local infoScoreDesc = lbl.createFont2(16, string.format("%d", l_4_1.score or 0))
  infoScoreDesc:setAnchorPoint(0, 0.5)
  infoScoreDesc:setPosition(infoScoreTitle:getPositionX() + infoScoreTitle:getContentSize().width * infoScoreTitle:getScaleX(), infoScoreTitle:getPositionY())
  infoBg:addChild(infoScoreDesc)
  local infoStartTitle = lbl.createFont2(16, i18n.global.guildFight_end_cd.string, ccc3(255, 243, 141))
  infoStartTitle:setAnchorPoint(0, 0.5)
  infoBg:addChild(infoStartTitle)
  droidhangComponents:mandateNode(infoStartTitle, "8dxy_SYZfOK")
  if l_4_1.status == 4 then
    infoStartTitle:setString(i18n.global.guildFight_start_cd.string)
  end
  local infoStartDesc = lbl.createFont2(16, "", ccc3(198, 255, 100))
  infoStartDesc:setString(time2string(l_4_1.cd))
  infoStartDesc:setAnchorPoint(0, 0.5)
  infoStartDesc:setPosition(infoStartTitle:getPositionX() + infoStartTitle:getContentSize().width * infoStartTitle:getScaleX(), infoStartTitle:getPositionY())
  infoBg:addChild(infoStartDesc)
  local startTime = os.time()
  infoStartDesc:scheduleUpdateWithPriorityLua(function()
    local passTime = os.time() - startTime
    local remainCd = math.max(0, data.cd + 3 - passTime)
    infoStartDesc:setString(time2string(remainCd))
    if remainCd <= 0 then
      infoStartDesc:unscheduleUpdate()
      self:onLeftTab()
      return 
    end
   end)
  local btn_rank0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_rank0:setPreferredSize(CCSizeMake(65, 55))
  local icon_rank = img.createUISprite(img.ui.guild_icon_rank)
  icon_rank:setScale(0.9)
  icon_rank:setPosition(CCPoint(33, 28))
  btn_rank0:addChild(icon_rank)
  local btn_rank = SpineMenuItem:create(json.ui.button, btn_rank0)
  droidhangComponents:mandateNode(btn_rank, "lwrC_hFyIKC")
  local btn_rank_menu = CCMenu:createWithItem(btn_rank)
  btn_rank_menu:setPosition(CCPoint(0, 0))
  infoBg:addChild(btn_rank_menu)
  btn_rank:registerScriptTapHandler(function()
    audio.play(audio.button)
    if not self.guildData.reg then
      showToast(i18n.global.guiidFight_toast_reg.string)
      return 
    end
    local params = {sid = dataPlayer.sid}
    addWaitNet()
    net:guild_fight_rank(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.rank then
        data.rank = l_1_0.rank
        infoRankDesc:setString(string.format("%d", data.rank))
      end
      self:addChild(require("ui.guildFight.rank").create(l_1_0.guds, data.rank, data.score), 1000)
      end)
   end)
  local btn_log0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_log0:setPreferredSize(CCSizeMake(65, 55))
  local icon_log = img.createUISprite(img.ui.guild_icon_log)
  icon_log:setScale(0.9)
  icon_log:setPosition(CCPoint(33, 28))
  btn_log0:addChild(icon_log)
  local btn_log = SpineMenuItem:create(json.ui.button, btn_log0)
  droidhangComponents:mandateNode(btn_log, "lwrC_Y5ZJHV")
  local btn_log_menu = CCMenu:createWithItem(btn_log)
  btn_log_menu:setPosition(CCPoint(0, 0))
  infoBg:addChild(btn_log_menu)
  btn_log:registerScriptTapHandler(function()
    audio.play(audio.button)
    self:addChild(require("ui.guildFight.records").create())
   end)
  local btn_award0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_award0:setPreferredSize(CCSizeMake(65, 55))
  local icon_award = img.createUISprite(img.ui.guildFight_icon_award)
  icon_award:setScale(1)
  icon_award:setPosition(CCPoint(33, 28))
  btn_award0:addChild(icon_award)
  local btn_award = SpineMenuItem:create(json.ui.button, btn_award0)
  droidhangComponents:mandateNode(btn_award, "F7RD_C49AOG")
  local btn_award_menu = CCMenu:createWithItem(btn_award)
  btn_award_menu:setPosition(CCPoint(0, 0))
  infoBg:addChild(btn_award_menu)
  btn_award:registerScriptTapHandler(function()
    audio.play(audio.button)
    if not self.guildData.reg then
      showToast(i18n.global.guiidFight_toast_reg.string)
      return 
    end
    self:addChild(require("ui.guildFight.rewards").create(data.rank, data.status, data.cd, data.pull_time))
   end)
  local btn_lrank0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_lrank0:setPreferredSize(CCSizeMake(65, 55))
  local icon_lrank = img.createUISprite(img.ui.guildFight_icon_history)
  icon_lrank:setPosition(CCPoint(33, 28))
  btn_lrank0:addChild(icon_lrank)
  local btn_lrank = SpineMenuItem:create(json.ui.button, btn_lrank0)
  droidhangComponents:mandateNode(btn_lrank, "Uqbk_XNpGem")
  local btn_lrank_menu = CCMenu:createWithItem(btn_lrank)
  btn_lrank_menu:setPosition(CCPoint(0, 0))
  infoBg:addChild(btn_lrank_menu)
  if l_4_0.guildData.reg then
    btn_lrank:setEnabled(false)
    setShader(btn_lrank, SHADER_GRAY, true)
  end
  btn_lrank:setVisible(false)
  btn_lrank:registerScriptTapHandler(function()
    disableObjAWhile(btn_lrank, 2)
    audio.play(audio.button)
    local params = {sid = dataPlayer.sid}
    addWaitNet()
    net:guild_fight_rank(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.rank then
        data.rank = l_1_0.rank
        infoRankDesc:setString(string.format("%d", data.rank))
      end
      self:addChild(require("ui.guildFight.rank").create(l_1_0.guds, data.rank, data.score), 1000)
      end)
   end)
  local btn_ring0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_ring0:setPreferredSize(CCSizeMake(65, 55))
  local icon_ring = img.createUISprite(img.ui.guildFight_icon_ring)
  icon_ring:setPosition(CCPoint(btn_ring0:getContentSize().width / 2, btn_ring0:getContentSize().height / 2))
  btn_ring0:addChild(icon_ring)
  local btn_ring = SpineMenuItem:create(json.ui.button, btn_ring0)
  droidhangComponents:mandateNode(btn_ring, "Uqbk_XNpGem")
  local btn_ring_menu = CCMenu:createWithItem(btn_ring)
  btn_ring_menu:setPosition(CCPoint(0, 0))
  infoBg:addChild(btn_ring_menu)
  btn_ring:registerScriptTapHandler(function()
    audio.play(audio.button)
    if dataGuild.selfTitle() <= dataGuild.TITLE.RESIDENT then
      showToast(i18n.global.permission_denied.string)
      return 
    end
    local dialog = require("ui.dialog")
    local process_dialog = function(l_1_0)
      self:removeChildByTag(dialog.TAG)
      if l_1_0.selected_btn == 2 then
        local params = {sid = dataPlayer.sid, type = 4, gud_imsg = msg}
        addWaitNet()
        netClient:chat(params, function(l_1_0)
          delWaitNet()
          showToast(i18n.global.mail_send_ok.string)
            end)
      elseif l_1_0.selected_btn == 1 then
         -- Warning: missing end command somewhere! Added here
      end
      end
    local params = {title = "", body = i18n.global.guildFight_call_lineup.string, btn_count = 2, btn_color = {1 = dialog.COLOR_BLUE, 2 = dialog.COLOR_GOLD}, btn_text = {1 = i18n.global.dialog_button_cancel.string, 2 = i18n.global.dialog_button_confirm.string}, callback = process_dialog}
    local dialog_ins = dialog.create(params, true)
    dialog_ins:setAnchorPoint(CCPoint(0, 0))
    dialog_ins:setPosition(CCPoint(0, 0))
    self:addChild(dialog_ins, 10000, dialog.TAG)
   end)
  local img_register = img.createLogin9Sprite(img.login.button_9_small_green)
  img_register:setPreferredSize(CCSizeMake(275, 58))
  local lbl_btn_register = lbl.createFont1(18, i18n.global.guildFight_register.string, ccc3(27, 89, 2))
  lbl_btn_register:setPosition(CCPoint(img_register:getContentSize().width / 2, img_register:getContentSize().height / 2))
  img_register:addChild(lbl_btn_register)
  local btn_register = SpineMenuItem:create(json.ui.button, img_register)
  droidhangComponents:mandateNode(btn_register, "2KoT_THySV3")
  local btn_register_menu = CCMenu:createWithItem(btn_register)
  btn_register_menu:setPosition(CCPoint(0, 0))
  leftTabNode:addChild(btn_register_menu)
  if l_4_1.reg then
    btn_register:setEnabled(false)
    setShader(btn_register, SHADER_GRAY, true)
  else
    btn_register:registerScriptTapHandler(function()
    audio.play(audio.button)
    if dataGuild.selfTitle() <= dataGuild.TITLE.RESIDENT then
      showToast(i18n.global.permission_denied.string)
      return 
    end
    local params = {sid = dataPlayer.sid}
    addWaitNet()
    net:guild_fight_reg(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status < 0 then
        if l_1_0.status == -2 then
          showToast(i18n.global.guildFight_mix_teams.string)
        elseif l_1_0.status == -4 then
          showToast(i18n.global.guiidFight_toast_reg_end.string)
        else
          showToast("status:" .. l_1_0.status)
          return 
        end
        showToast(i18n.global.guiidFight_toast_reg_success.string)
        self:onLeftTab()
         -- Warning: missing end command somewhere! Added here
      end
      end)
   end)
  end
  local img_team = img.createLogin9Sprite(img.login.button_9_small_gold)
  img_team:setPreferredSize(CCSizeMake(275, 58))
  local lbl_btn_team = lbl.createFont1(18, i18n.global.guildFight_my_team.string, ccc3(115, 59, 5))
  lbl_btn_team:setPosition(CCPoint(img_team:getContentSize().width / 2, img_team:getContentSize().height / 2))
  img_team:addChild(lbl_btn_team)
  local btn_team = SpineMenuItem:create(json.ui.button, img_team)
  droidhangComponents:mandateNode(btn_team, "2KoT_0itJUH")
  local btn_team_menu = CCMenu:createWithItem(btn_team)
  btn_team_menu:setPosition(CCPoint(0, 0))
  leftTabNode:addChild(btn_team_menu)
  btn_team:registerScriptTapHandler(function()
    disableObjAWhile(btn_team)
    audio.play(audio.button)
    self:addChild(require("ui.selecthero.main").create({type = "guildFight", callBack = function(l_1_0)
      local newCamp = clone(l_1_0)
      local power = 0
      for _,info in ipairs(newCamp) do
        if info.pos and info.pos ~= 7 then
          power = power + dataHeros.power(info.hid)
          local heroInfo = dataHeros.find(info.hid)
          info.id = heroInfo.id
          info.hid = info.hid
          info.lv = heroInfo.lv
        end
      end
      local findFlag = false
      for _,mbr in ipairs(self.guildData.mbrs) do
        if mbr.uid == dataPlayer.uid then
          mbr.camp = newCamp
          findFlag = true
      else
        end
      end
      if not findFlag then
        local mbr = {name = dataPlayer.name, logo = dataPlayer.logo, lv = dataPlayer.lv(), camp = newCamp, uid = dataPlayer.uid, power = power}
        table.insert(self.guildData.mbrs, mbr)
      end
      self:createLeftTab()
      end}), 1000)
   end)
end

guildFightMain.createRightTab = function(l_5_0, l_5_1)
  if l_5_0.demoFightLayer then
    l_5_0.demoFightLayer:removeFromParent()
    l_5_0.demoFightLayer = nil
  end
  if l_5_0.rightTabNode then
    l_5_0.rightTabNode:removeFromParent()
    l_5_0.rightTabNode = nil
  end
  if l_5_0.enegyToast then
    l_5_0.enegyToast:removeFromParent()
    l_5_0.enegyToast = nil
  end
  local rightTabNode = cc.Node:create()
  l_5_0.rightTabNode = rightTabNode
  l_5_0.bg:addChild(rightTabNode)
  local status = l_5_1.status
  if status == 1 or status == 2 or status == 3 then
    if l_5_0.guildData.reg then
      l_5_0:createRightTabFighting(rightTabNode, l_5_1)
    else
      showToast(i18n.global.guiidFight_toast_reg.string)
    end
  elseif status == 4 then
    l_5_0:createRightTabFinals(rightTabNode, l_5_1, true)
  elseif status == 5 then
    l_5_0:createRightTabFinals(rightTabNode, l_5_1, false)
  elseif status == 6 then
    l_5_0:createRightTabFinish(rightTabNode, l_5_1)
  end
end

guildFightMain.createRightTabFinish = function(l_6_0, l_6_1, l_6_2)
  local bg = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  bg:setPreferredSize(CCSizeMake(876, 440))
  l_6_1:addChild(bg)
  droidhangComponents:mandateNode(bg, "VTe0_cU034t")
  local titleLabel = lbl.createFont2(24, i18n.global.guildFight_final_title.string, ccc3(230, 208, 174))
  bg:addChild(titleLabel)
  droidhangComponents:mandateNode(titleLabel, "ITmN_jx6ppy")
  local leftTitleIcon = img.createUISprite(img.ui.guildFight_icon_final)
  bg:addChild(leftTitleIcon)
  droidhangComponents:mandateNode(leftTitleIcon, "ITmN_Jgfkt8")
  local rightTitleIcon = img.createUISprite(img.ui.guildFight_icon_final)
  rightTitleIcon:setFlipX(true)
  bg:addChild(rightTitleIcon)
  droidhangComponents:mandateNode(rightTitleIcon, "ITmN_Aojh61")
  local bar2 = img.createUISprite(img.ui.guildFight_bar_2)
  local bar2Label = lbl.createFont2(22, i18n.global.guildFight_final_2_1.string, ccc3(255, 228, 125))
  bar2:addChild(bar2Label)
  bar2Label:setPosition(bar2:getContentSize().width * 0.5, bar2:getContentSize().height * 0.5 + 2)
  local bar2Btn = SpineMenuItem:create(json.ui.button, bar2)
  local bar2BtnMenu = CCMenu:createWithItem(bar2Btn)
  bar2BtnMenu:setPosition(CCPoint(0, 0))
  bg:addChild(bar2BtnMenu)
  bar2Btn:registerScriptTapHandler(function()
    audio.play(audio.button)
    self:addChild(require("ui.guildFight.final_2").create(data))
   end)
  droidhangComponents:mandateNode(bar2Btn, "ITmN_2TgYlP")
  local bar4 = img.createUISprite(img.ui.guildFight_bar_4)
  local bar4Label = lbl.createFont2(22, i18n.global.guildFight_final_4_2.string, ccc3(250, 218, 244))
  bar4:addChild(bar4Label)
  bar4Label:setPosition(bar4:getContentSize().width * 0.5, bar4:getContentSize().height * 0.5 + 2)
  local bar4Btn = SpineMenuItem:create(json.ui.button, bar4)
  local bar4BtnMenu = CCMenu:createWithItem(bar4Btn)
  bar4BtnMenu:setPosition(CCPoint(0, 0))
  bg:addChild(bar4BtnMenu)
  bar4Btn:registerScriptTapHandler(function()
    audio.play(audio.button)
    self:addChild(require("ui.guildFight.final_4").create(data))
   end)
  droidhangComponents:mandateNode(bar4Btn, "ITmN_RTbaPr")
  local bar8 = img.createUISprite(img.ui.guildFight_bar_8)
  local bar8Label = lbl.createFont2(22, i18n.global.guildFight_final_8_4.string, ccc3(189, 228, 255))
  bar8:addChild(bar8Label)
  bar8Label:setPosition(bar8:getContentSize().width * 0.5, bar8:getContentSize().height * 0.5 + 2)
  local bar8Btn = SpineMenuItem:create(json.ui.button, bar8)
  local bar8BtnMenu = CCMenu:createWithItem(bar8Btn)
  bar8BtnMenu:setPosition(CCPoint(0, 0))
  bg:addChild(bar8BtnMenu)
  bar8Btn:registerScriptTapHandler(function()
    audio.play(audio.button)
    self:addChild(require("ui.guildFight.final_8").create(data))
   end)
  droidhangComponents:mandateNode(bar8Btn, "ITmN_DXII7R")
  local bar16 = img.createUISprite(img.ui.guildFight_bar_16)
  local bar16Label = lbl.createFont2(22, i18n.global.guildFight_final_16_8.string)
  bar16:addChild(bar16Label)
  bar16Label:setPosition(bar16:getContentSize().width * 0.5, bar16:getContentSize().height * 0.5 + 2)
  local bar16Btn = SpineMenuItem:create(json.ui.button, bar16)
  local bar16BtnMenu = CCMenu:createWithItem(bar16Btn)
  bar16BtnMenu:setPosition(CCPoint(0, 0))
  bg:addChild(bar16BtnMenu)
  bar16Btn:registerScriptTapHandler(function()
    audio.play(audio.button)
    self:addChild(require("ui.guildFight.final_16").create(data))
   end)
  droidhangComponents:mandateNode(bar16Btn, "pVLe_3cOPsU")
end

guildFightMain.createRightTabFighting = function(l_7_0, l_7_1, l_7_2)
  local bg = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  bg:setPreferredSize(CCSizeMake(876, 440))
  l_7_1:addChild(bg)
  droidhangComponents:mandateNode(bg, "VTe0_cU034t")
  local teamBgWidth = 480
  local teamBgHeight = 182
  local myTeambg = img.createUI9Sprite(img.ui.guildFight_bar_bg)
  myTeambg:setPreferredSize(CCSizeMake(teamBgWidth, teamBgHeight))
  bg:addChild(myTeambg)
  droidhangComponents:mandateNode(myTeambg, "zFFL_7ohsyz_xx")
  local leftTitleIcon = img.createUISprite(img.ui.guildFight_icon_final)
  bg:addChild(leftTitleIcon)
  droidhangComponents:mandateNode(leftTitleIcon, "zFFL_fDWtbB")
  local rightTitleIcon = img.createUISprite(img.ui.guildFight_icon_final)
  rightTitleIcon:setFlipX(true)
  bg:addChild(rightTitleIcon)
  droidhangComponents:mandateNode(rightTitleIcon, "zFFL_Uty10x")
  local vsIcon = img.createUISprite(img.ui.arena_new_vs)
  bg:addChild(vsIcon)
  droidhangComponents:mandateNode(vsIcon, "IJcm_HuX20g")
  local enemyTeambg = img.createUI9Sprite(img.ui.botton_fram_2)
  enemyTeambg:setPreferredSize(CCSizeMake(teamBgWidth, teamBgHeight))
  bg:addChild(enemyTeambg)
  droidhangComponents:mandateNode(enemyTeambg, "zFFL_vg2kCp")
  local createTeamItem = function(l_1_0, l_1_1, l_1_2)
    local container = cc.Node:create()
    local guildFlag = img.createGFlag(l_1_0.logo or 1)
    guildFlag:setScale(0.6)
    container:addChild(guildFlag)
    droidhangComponents:mandateNode(guildFlag, "sZ25_CyveZF")
    local nameLabel = lbl.createFontTTF(18, l_1_0.name or "unknow", ccc3(108, 62, 53))
    container:addChild(nameLabel)
    droidhangComponents:mandateNode(nameLabel, "8TTW_HkCKyZ")
    local rankdLabel = lbl.createFont1(16, i18n.global.guildvice_dps_rank.string .. ": " .. (l_1_0.rank or "--"), ccc3(160, 81, 66))
    container:addChild(rankdLabel)
    droidhangComponents:mandateNode(rankdLabel, "8TTW_IPpHVj")
    local mylookSprite = img.createUISprite(img.ui.guildFight_icon_search)
    local btnmylook = SpineMenuItem:create(json.ui.button, mylookSprite)
    droidhangComponents:mandateNode(btnmylook, "XawZ_yEzDMB")
    local menumylook = CCMenu:createWithItem(btnmylook)
    menumylook:setPosition(0, 0)
    container:addChild(menumylook)
    btnmylook:registerScriptTapHandler(function()
      audio.play(audio.button)
      local camplayer = require("ui.guildFight.guildFightcamp")
      do
        local mbrss = {}
        if data.uids then
          for i,vm in ipairs(data.mbrs) do
            for j,vu in ipairs(data.uids) do
              if vm.uid == vu then
                mbrss[ mbrss + 1] = vm
                for i,vm in (for generator) do
                end
              end
            end
          else
            mbrss = data.mbrs
          end
          self:addChild(camplayer.create(mbrss, mask), 1000)
        end
         -- Warning: missing end command somewhere! Added here
      end
      end)
    if l_1_2 and l_1_0.rank then
      local idx = math.ceil(l_1_0.rank / 50)
      local text = string.format("%d-%d", 1 + (idx - 1) * 50, 50 + (idx - 1) * 50)
      rankdLabel:setString(i18n.global.guildvice_dps_rank.string .. ": " .. text)
    end
    local splitLine = img.createUISprite(img.ui.split_line)
    container:addChild(splitLine)
    droidhangComponents:mandateNode(splitLine, "WCt8_ruT3zz")
    splitLine:setScaleX(439 / splitLine:getContentSize().width)
    local serverBg = img.createUISprite(img.ui.anrea_server_bg)
    container:addChild(serverBg)
    droidhangComponents:mandateNode(serverBg, "XGbN_wqPpxm")
    local serverLabel = lbl.createFont1(16, getSidname(l_1_0.sid or 1), ccc3(255, 251, 215))
    serverLabel:setPosition(serverBg:getContentSize().width * 0.5, serverBg:getContentSize().height * 0.5)
    serverBg:addChild(serverLabel)
    local BG_WIDTH = teamBgWidth
    local BG_HEIGHT = 114
    local SCROLL_MARGIN_TOP = 4
    local SCROLL_MARGIN_BOTTOM = 12
    local SCROLL_VIEW_WIDTH = BG_WIDTH
    local SCROLL_VIEW_HEIGHT = BG_HEIGHT - SCROLL_MARGIN_TOP - SCROLL_MARGIN_BOTTOM
    local scroll = CCScrollView:create()
    scroll:setDirection(kCCScrollViewDirectionVertical)
    scroll:setViewSize(CCSize(SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT))
    scroll:setPosition(0, SCROLL_MARGIN_BOTTOM)
    container:addChild(scroll)
    local createItem = function(l_2_0, l_2_1)
      local bg = cc.Node:create()
      bg:setContentSize(cc.size(SCROLL_VIEW_WIDTH, 50))
      local numLabel = lbl.createFont1(18, string.format("%d", l_2_0), ccc3(108, 62, 53))
      bg:addChild(numLabel)
      numLabel:setPosition(30, bg:getContentSize().height * 0.5)
      local hids = {}
      if not l_2_1.camp then
        local pheroes = {}
      end
      for i,v in ipairs(pheroes) do
        hids[v.pos] = v
      end
      local dx = 54
      local sx0 = 80
      local sx1 = sx0 + dx + 64
      do
        local sxAry = {sx0, sx0 + dx, sx1, sx1 + dx, sx1 + dx * 2, sx1 + dx * 3}
        for i = 1, 6 do
          local showHero = nil
          local hideFlag = false
          if mask then
            for _,uid in ipairs(mask) do
              if uid == l_2_1.uid then
                hideFlag = true
            else
              end
            end
            if hideFlag then
              showHero = img.createUISprite(img.ui.herolist_head_bg)
              local icon = img.createUISprite(img.ui.arena_new_question)
              icon:setPosition(showHero:getContentSize().width * 0.5, showHero:getContentSize().height * 0.5)
              showHero:addChild(icon)
            elseif hids[i] then
              local param = {id = hids[i].id, lv = hids[i].lv, showGroup = true, showStar = true, wake = hids[i].wake, orangeFx = nil, petID = require("data.pet").getPetID(hids), skin = hids[i].skin}
              showHero = img.createHeroHeadByParam(param)
            else
              showHero = img.createUISprite(img.ui.herolist_head_bg)
            end
            showHero:setAnchorPoint(ccp(0.5, 0.5))
            showHero:setScale(0.55)
            showHero:setPosition(sxAry[i], bg:getContentSize().height * 0.5)
            bg:addChild(showHero)
          end
          return bg
        end
         -- Warning: missing end command somewhere! Added here
      end
      end
    local height = 0
    local itemAry = {}
    if not l_1_0.mbrs then
      for i,mbr in ipairs({}) do
      end
      local selected = false
      if l_1_0.uids then
        if not l_1_0.uids then
          for _,uid in ipairs({}) do
          end
          if uid == mbr.uid then
            selected = true
        else
          end
        end
      else
        selected = true
      end
    end
    if selected then
      local item = createItem(i, mbr)
      height = height + item:getContentSize().height + 6
      table.insert(itemAry, item)
      scroll:addChild(item)
    end
  end
  local sy = height - 6 - 4
  for _,item in ipairs(itemAry) do
    item:setAnchorPoint(0.5, 0.5)
    item:setPosition(SCROLL_VIEW_WIDTH * 0.5, sy - item:getContentSize().height * 0.5 + 4)
    sy = sy - item:getContentSize().height - 6
  end
  scroll:setContentSize(CCSize(SCROLL_VIEW_WIDTH, height))
  scroll:setContentOffset(ccp(0, SCROLL_VIEW_HEIGHT - (height)))
  return container
   end
  myTeambg:addChild(createTeamItem(l_7_0.guildData))
  if l_7_2.status == 1 then
    local container_w = enemyTeambg:getContentSize().width
    local container_h = enemyTeambg:getContentSize().height
    local icon_nomail = img.createUISprite(img.ui.mail_icon_nomail)
    icon_nomail:setScale(0.7)
    icon_nomail:setPosition(CCPoint(container_w / 2, container_h / 2 + 15))
    enemyTeambg:addChild(icon_nomail)
    local lbl_nomail = lbl.createFont1(16, i18n.global.guildFight_enemy_empty.string, ccc3(147, 108, 84))
    lbl_nomail:setAnchorPoint(0.5, 1)
    lbl_nomail:setPosition(CCPoint(container_w / 2, icon_nomail:getPositionY() - icon_nomail:getContentSize().height * icon_nomail:getScale() * 0.5 - 5))
    enemyTeambg:addChild(lbl_nomail)
  elseif l_7_2.enemy then
    enemyTeambg:addChild(createTeamItem(l_7_2.enemy, l_7_2.enemy.mask, true))
  end
  local rightAnimBg = img.createUISprite(img.ui.guildFight_anim_bg)
  do
    bg:addChild(rightAnimBg, 1)
    droidhangComponents:mandateNode(rightAnimBg, "zFFL_JIMnya")
    local enegyBottom = img.createUI9Sprite(img.ui.main_coin_bg)
    do
      enegyBottom:setPreferredSize(CCSizeMake(138, 40))
      rightAnimBg:addChild(enegyBottom)
      droidhangComponents:mandateNode(enegyBottom, "R7uJ_fCwuH9")
      l_7_0.enegyBottom = enegyBottom
      local enegylab = lbl.createFont2(16, string.format("%d/%d", l_7_2.tl, ENEGY_MAX), ccc3(248, 242, 226))
      enegylab:setPosition(CCPoint(enegyBottom:getContentSize().width / 2, enegyBottom:getContentSize().height / 2 + 3))
      enegyBottom:addChild(enegylab)
      enegyIcon = img.createUISprite(img.ui.guildFight_tl)
      enegyIcon:setPosition(8, enegyBottom:getContentSize().height / 2 + 4)
      enegyBottom:addChild(enegyIcon)
      local enegyToast = img.createUI9Sprite(img.ui.tips_bg)
      enegyToast:setPreferredSize(CCSizeMake(410, 68))
      enegyToast:setVisible(false)
      l_7_0.bg:addChild(enegyToast, 1000)
      l_7_0.enegyToast = enegyToast
      droidhangComponents:mandateNode(l_7_0.enegyToast, "iFF6_kF4hVm")
      l_7_0.showenegyTimeLab = lbl.createFont2(16, "", ccc3(165, 253, 71))
      l_7_0.showenegyTimeLab:setAnchorPoint(0, 0.5)
      l_7_0.showenegyTimeLab:setPosition(enegyToast:getContentSize().width / 2 + 30, enegyToast:getContentSize().height / 2)
      enegyToast:addChild(l_7_0.showenegyTimeLab)
      l_7_0.tlrecoverlab = lbl.createFont1(16, i18n.global.friendboss_enegy_recovery.string, ccc3(255, 246, 223))
      l_7_0.tlrecoverlab:setAnchorPoint(1, 0.5)
      l_7_0.tlrecoverlab:setPosition(CCPoint(l_7_0.showenegyTimeLab:boundingBox():getMinX() - 10, enegyToast:getContentSize().height / 2))
      enegyToast:addChild(l_7_0.tlrecoverlab)
      l_7_0.enegyFull = lbl.createMixFont1(16, i18n.global.friendboss_enegy_full.string, ccc3(255, 246, 223))
      l_7_0.enegyFull:setPosition(enegyToast:getContentSize().width / 2, enegyToast:getContentSize().height / 2)
      l_7_0.enegyFull:setVisible(false)
      enegyToast:addChild(l_7_0.enegyFull)
      if l_7_2.tl < ENEGY_MAX then
        local startTime = os.time()
        enegylab:scheduleUpdateWithPriorityLua(function()
          local passTime = os.time() - startTime
          local remainCd = math.max(0, data.tl_cd - passTime)
          if remainCd <= 0 then
            data.tl = data.tl + 1
            data.tl_cd = ENEGY_DURATION
            remainCd = ENEGY_DURATION
            startTime = os.time()
            enegylab:setString(string.format("%d/%d", data.tl, ENEGY_MAX))
          end
          self.showenegyTimeLab:setString(time2string(remainCd))
          if ENEGY_MAX <= data.tl then
            enegylab:unscheduleUpdate()
            self.showenegyTimeLab:setVisible(false)
            self.tlrecoverlab:setVisible(false)
            self.enegyFull:setVisible(true)
            return 
          end
            end)
      else
        l_7_0.showenegyTimeLab:setVisible(false)
        l_7_0.tlrecoverlab:setVisible(false)
        l_7_0.enegyFull:setVisible(true)
      end
      local addTipsLabel = function(l_3_0, l_3_1)
        local textUp = ""
        local textDown = ""
        if l_3_1 then
          if l_3_1[1] then
            textUp = l_3_1[1]
          end
          if l_3_1[2] then
            textDown = l_3_1[2]
          end
        end
        local labelUp = lbl.createFontTTF(18, textUp, ccc3(115, 59, 5))
        l_3_0:addChildFollowSlot("code_text_up", labelUp)
        local labelMiddle = lbl.createFontTTF(22, data.enemy.name, ccc3(115, 59, 5))
        l_3_0:addChildFollowSlot("code_text_middle", labelMiddle)
        local labelDown = lbl.createFontTTF(18, textDown, ccc3(115, 59, 5))
        l_3_0:addChildFollowSlot("code_text_down", labelDown)
         end
      if l_7_2.status == 1 or l_7_2.status == 2 then
        local btnFightSprite = img.createUISprite(img.ui.guildFight_battle_1)
        local btnFightSprite2 = img.createUISprite(img.ui.guildFight_battle_2)
        btnFightSprite2:setPosition(btnFightSprite:getContentSize().width / 2, btnFightSprite:getContentSize().height / 2)
        btnFightSprite:addChild(btnFightSprite2)
        local btnFightLab = lbl.createFont1(24, i18n.global.guildFight_fight.string, ccc3(126, 39, 0))
        btnFightLab:setPosition(btnFightSprite:getContentSize().width / 2, btnFightSprite:getContentSize().height / 2)
        btnFightSprite:addChild(btnFightLab)
        local btnFight = SpineMenuItem:create(json.ui.button, btnFightSprite)
        droidhangComponents:mandateNode(btnFight, "XawZ_yEzDMA")
        local menuFight = CCMenu:createWithItem(btnFight)
        menuFight:setPosition(0, 0)
        bg:addChild(menuFight)
        btnFight:registerScriptTapHandler(function()
          audio.play(audio.button)
          if dataGuild.selfTitle() <= dataGuild.TITLE.RESIDENT then
            showToast(i18n.global.permission_denied.string)
            return 
          end
          local params = {sid = dataPlayer.sid, server_id = data.enemy.sid, gid = data.enemy.gid}
          addWaitNet()
          net:guild_fight_fight(params, function(l_1_0)
            delWaitNet()
            tbl2string(l_1_0)
            if l_1_0.status < 0 then
              if l_1_0.status == -1 then
                showToast(i18n.global.guiidFight_toast_matchOther.string)
              elseif l_1_0.status == -3 then
                showToast(i18n.global.friendboss_no_enegy.string)
              elseif l_1_0.status == -4 then
                showToast(i18n.global.guiidFight_toast_reg_end.string)
              else
                showToast("status:" .. l_1_0.status)
                return 
              end
              do
                local newData = clone(data)
                newData.status = 3
                newData.cd = FIGHT_DURATION
                newData.tl = newData.tl - 1
                newData.fight_win = l_1_0.win
                newData.fight_bats = l_1_0.bats
                self:createRightTab(newData)
              end
               -- Warning: missing end command somewhere! Added here
            end
               end)
            end)
        if not l_7_2.enemy then
          btnFight:setEnabled(false)
          setShader(btnFight, SHADER_GRAY, true)
        end
        local btnMathSprite = img.createUISprite(img.ui.guildFight_find_1)
        local btnMathLab = lbl.createFont1(16, i18n.global.guildFight_math.string, ccc3(27, 89, 2))
        btnMathLab:setPosition(btnMathSprite:getContentSize().width / 2, btnMathSprite:getContentSize().height / 2)
        btnMathSprite:addChild(btnMathLab)
        local btnMatch = SpineMenuItem:create(json.ui.button, btnMathSprite)
        droidhangComponents:mandateNode(btnMatch, "XawZ_PGD3iq")
        local menuMath = CCMenu:createWithItem(btnMatch)
        menuMath:setPosition(0, 0)
        bg:addChild(menuMath)
        local matchSprite = img.createUISprite(img.ui.guildFight_find_2)
        droidhangComponents:mandateNode(matchSprite, "XawZ_PGD3iq")
        matchSprite:setVisible(false)
        bg:addChild(matchSprite)
        local showMathCd = function(l_5_0)
          btnMathLab:setVisible(false)
          matchSprite:setVisible(true)
          btnMatch:setVisible(false)
          local cdLabel = lbl.createFont2(16, "", ccc3(198, 255, 100))
          cdLabel:setString(time2string(l_5_0))
          cdLabel:setPosition(matchSprite:getContentSize().width / 2, matchSprite:getContentSize().height / 2)
          matchSprite:addChild(cdLabel)
          local startTime = os.time()
          cdLabel:scheduleUpdateWithPriorityLua(function()
            local passTime = os.time() - startTime
            local remainCd = math.max(0, cd - passTime)
            cdLabel:setString(time2string(remainCd))
            if remainCd <= 0 then
              cdLabel:unscheduleUpdate()
              btnMatch:setVisible(true)
              matchSprite:setVisible(false)
              cdLabel:setVisible(false)
              btnMathLab:setVisible(true)
              return 
            end
               end)
            end
        btnMatch:registerScriptTapHandler(function()
          if dataGuild.selfTitle() <= dataGuild.TITLE.RESIDENT then
            showToast(i18n.global.permission_denied.string)
            return 
          end
          local params = {sid = dataPlayer.sid}
          addWaitNet()
          net:guild_fight_macth(params, function(l_1_0)
            delWaitNet()
            tbl2string(l_1_0)
            if l_1_0.status < 0 then
              if l_1_0.status == -2 then
                showToast(i18n.global.guiidFight_toast_noOther.string)
              elseif l_1_0.status == -4 then
                showToast(i18n.global.guiidFight_toast_reg_end.string)
              else
                showToast("status:" .. l_1_0.status)
                return 
              end
              data.enemy = l_1_0.enemy
              data.status = 2
              showMathCd(l_1_0.cd or 10)
              self.boardAnim:playAnimation("open", 1, 0)
              self.boardAnim:appendNextAnimation("loop", 1, 0)
              self.boardAnim:appendNextAnimation("end", 1, 0)
              self.boardAnim:removeChildFollowSlot("code_text_up")
              self.boardAnim:removeChildFollowSlot("code_text_middle")
              self.boardAnim:removeChildFollowSlot("code_text_down")
              addTipsLabel(self.boardAnim, l_1_0.name)
              self.boardAnim:registerLuaHandler(function(...)
                enemyTeambg:removeFromParent()
                enemyTeambg = img.createUI9Sprite(img.ui.botton_fram_2)
                enemyTeambg:setPreferredSize(CCSizeMake(teamBgWidth, teamBgHeight))
                bg:addChild(enemyTeambg)
                droidhangComponents:mandateNode(enemyTeambg, "zFFL_vg2kCp")
                enemyTeambg:addChild(createTeamItem(__data.enemy, __data.enemy.mask, true))
                btnFight:setEnabled(true)
                clearShader(btnFight, true)
                 -- DECOMPILER ERROR: Confused about usage of registers for local variables.

                     end)
               -- Warning: missing end command somewhere! Added here
            end
               end)
            end)
        if l_7_2.status == 1 then
          json.load(json.ui.guildwar_ui)
          local boardAnim = DHSkeletonAnimation:createWithKey(json.ui.guildwar_ui)
          boardAnim:scheduleUpdateLua()
          boardAnim:playAnimation("close")
          rightAnimBg:addChild(boardAnim)
          droidhangComponents:mandateNode(boardAnim, "hpcK_UE65ao")
          l_7_0.boardAnim = boardAnim
        elseif l_7_2.status == 2 then
          if l_7_2.cd > 0 then
            showMathCd(l_7_2.cd)
          end
          json.load(json.ui.guildwar_ui)
          local boardAnim = DHSkeletonAnimation:createWithKey(json.ui.guildwar_ui)
          boardAnim:playAnimation("end")
          boardAnim:scheduleUpdateLua()
          boardAnim:update(10)
          rightAnimBg:addChild(boardAnim)
          droidhangComponents:mandateNode(boardAnim, "hpcK_UE65ao")
          l_7_0.boardAnim = boardAnim
          addTipsLabel(boardAnim, l_7_2.names)
        end
      else
        local fightBg = img.createUISprite(img.ui.guildFight_fight_bg)
        rightAnimBg:addChild(fightBg)
        droidhangComponents:mandateNode(fightBg, "BeSu_7bT8fp")
        local btnMathSprite1 = img.createUISprite(img.ui.guildFight_find_2)
        local btnMathLab = lbl.createFont1(16, i18n.global.guildFight_fight_ing.string, ccc3(255, 215, 107))
        btnMathLab:setPosition(btnMathSprite1:getContentSize().width / 2, btnMathSprite1:getContentSize().height / 2)
        btnMathSprite1:addChild(btnMathLab)
        droidhangComponents:mandateNode(btnMathSprite1, "BeSu_30AjBq")
        bg:addChild(btnMathSprite1)
        local timerBg = img.createUISprite(img.ui.guildFight_battle_1)
        bg:addChild(timerBg)
        droidhangComponents:mandateNode(timerBg, "BeSu_uxjby2")
        local timerProgress = createProgressBar(img.createUISprite(img.ui.guildFight_battle_3))
        timerProgress:setPosition(timerBg:getContentSize().width * 0.5, timerBg:getContentSize().height * 0.5)
        timerBg:addChild(timerProgress)
        timerProgress:setPercentage(l_7_2.cd / FIGHT_DURATION * 100)
        local timerDesc = lbl.createFont2(20, time2string(l_7_2.cd), ccc3(255, 247, 229))
        timerDesc:setPosition(timerBg:getContentSize().width * 0.5, timerBg:getContentSize().height * 0.5 - 2)
        timerBg:addChild(timerDesc)
        local startTime = os.time()
        timerDesc:scheduleUpdateWithPriorityLua(function()
          local passTime = os.time() - startTime
          local remainCd = math.max(0, data.cd - passTime)
          timerDesc:setString(time2string(remainCd))
          timerProgress:setPercentage(remainCd / FIGHT_DURATION * 100)
          if remainCd <= 0 then
            timerDesc:unscheduleUpdate()
            local newData = clone(data)
            newData.status = 1
            newData.enemy = nil
            self:createRightTab(newData)
            local selfGuildObj = {logo = dataGuild.guildObj.logo, name = dataGuild.guildObj.name, sid = dataPlayer.sid}
            local enemyGuildObj = {logo = data.enemy.logo, name = data.enemy.name, sid = data.enemy.sid}
            local videoData = {bats = data.fight_bats}
            videoData.atk = {mbrs = self.guildData.mbrs}
            videoData.def = data.enemy
            self:addChild(require("ui.guildFight.videoDetail").create(data.fight_win, selfGuildObj, enemyGuildObj, videoData), 100)
            return 
          end
            end)
        local params = {atkIds = {1101, 1102, 1103, 1201}, defIds = {1202, 1203, 1301, 1302}}
        for _,mbr in ipairs(l_7_0.guildData.mbrs) do
          local findFlag = nil
          for _,uid in ipairs(l_7_0.guildData.uids) do
            if uid == mbr.uid then
              params.atkIds = {}
              for _,info in ipairs(mbr.camp) do
                if info.pos and info.pos == 7 then
                  for _,info in (for generator) do
                  end
                  if info.id then
                    table.insert(params.atkIds, info.id)
                    for _,info in (for generator) do
                    end
                    local heroInfo = dataHeros.find(info.hid)
                    table.insert(params.atkIds, heroInfo.id)
                  end
                  findFlag = true
              else
                end
              end
              if findFlag then
                do return end
              end
            end
            if l_7_2.enemy and l_7_2.enemy.mbrs then
              for _,mbr in ipairs(l_7_2.enemy.mbrs) do
                params.defIds = {}
                for _,info in ipairs(mbr.camp) do
                  if info.pos and info.pos == 7 then
                    for _,info in (for generator) do
                    end
                    if info.id then
                      table.insert(params.defIds, info.id)
                    end
                  end
                  do return end
                end
              end
              l_7_0.demoFightLayer = require("ui.guildFight.demoFight").create(params)
              l_7_0:addChild(l_7_0.demoFightLayer, 1000)
            end
          end
           -- Warning: missing end command somewhere! Added here
        end
         -- Warning: missing end command somewhere! Added here
      end
       -- Warning: missing end command somewhere! Added here
    end
     -- Warning: missing end command somewhere! Added here
  end
end

guildFightMain.createRightTabFinals = function(l_8_0, l_8_1, l_8_2, l_8_3)
  local bg = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  bg:setPreferredSize(CCSizeMake(876, 440))
  l_8_1:addChild(bg)
  droidhangComponents:mandateNode(bg, "VTe0_cU034t")
  local lbl_title = lbl.createFont2(24, i18n.global.guildFight_final_vs.string, ccc3(230, 208, 174))
  bg:addChild(lbl_title, 2)
  droidhangComponents:mandateNode(lbl_title, "3Jrf_t7yuHd")
  local leftTitleIcon = img.createUISprite(img.ui.guildFight_icon_final)
  bg:addChild(leftTitleIcon)
  leftTitleIcon:setAnchorPoint(1, 0.5)
  leftTitleIcon:setPosition(lbl_title:getPositionX() - lbl_title:getContentSize().width * 0.5 * lbl_title:getScaleX() - 40, lbl_title:getPositionY())
  local rightTitleIcon = img.createUISprite(img.ui.guildFight_icon_final)
  rightTitleIcon:setFlipX(true)
  bg:addChild(rightTitleIcon)
  rightTitleIcon:setAnchorPoint(0, 0.5)
  rightTitleIcon:setPosition(lbl_title:getPositionX() + lbl_title:getContentSize().width * 0.5 * lbl_title:getScaleX() + 40, lbl_title:getPositionY())
  local labelNode = cc.Node:create()
  bg:addChild(labelNode)
  local cdLabel = lbl.createFont2(16, "", ccc3(198, 255, 100))
  cdLabel:setString(time2string(l_8_2.cd or 0))
  cdLabel:setAnchorPoint(0, 0.5)
  labelNode:addChild(cdLabel)
  local startTime = os.time()
  cdLabel:scheduleUpdateWithPriorityLua(function()
    local passTime = os.time() - startTime
    local remainCd = math.max(0, (data.cd or 0) + 10 - passTime)
    cdLabel:setString(time2string(remainCd))
    if remainCd <= 0 then
      cdLabel:unscheduleUpdate()
      self:onRightTab()
      return 
    end
   end)
  local descLabel = lbl.createFont2(16, "")
  labelNode:addChild(descLabel)
  if l_8_3 then
    descLabel:setString(i18n.global.guildFight_start_cd.string)
  else
    descLabel:setString(i18n.global.guildFight_end_cd.string)
  end
  descLabel:setAnchorPoint(0, 0.5)
  cdLabel:setPositionX(descLabel:getContentSize().width * descLabel:getScaleX() + 15)
  local offsetX = descLabel:getContentSize().width * descLabel:getScaleX() + cdLabel:getContentSize().width * cdLabel:getScaleX() + 15
  labelNode:setPosition(bg:getContentSize().width * 0.5 - offsetX * 0.5, 365)
  if not l_8_2.guilds then
    return 
  end
  local BG_WIDTH = bg:getContentSize().width
  local BG_HEIGHT = 360
  local SCROLL_MARGIN_TOP = 8
  local SCROLL_MARGIN_BOTTOM = 14
  local SCROLL_VIEW_WIDTH = BG_WIDTH
  local SCROLL_VIEW_HEIGHT = BG_HEIGHT - SCROLL_MARGIN_TOP - SCROLL_MARGIN_BOTTOM
  local scroll = CCScrollView:create()
  scroll:setDirection(kCCScrollViewDirectionVertical)
  scroll:setViewSize(CCSize(SCROLL_VIEW_WIDTH, SCROLL_VIEW_HEIGHT))
  scroll:setPosition(0, SCROLL_MARGIN_BOTTOM)
  bg:addChild(scroll)
  local createItem = function(l_2_0, l_2_1, l_2_2)
    local bg = cc.Node:create()
    bg:setContentSize(cc.size(SCROLL_VIEW_WIDTH, 91))
    local bgName = nil
    if (8 - l_2_2) % 2 == 1 then
      bgName = "guildFight_vs_bg_1.png"
    else
      bgName = "guildFight_vs_bg_2.png"
    end
    local leftBg = img.createUISprite(bgName)
    leftBg:setAnchorPoint(0, 0.5)
    leftBg:setPosition(30, bg:getContentSize().height * 0.5)
    bg:addChild(leftBg)
    if not l_2_0.logo then
      local guildFlag = img.createGFlag(not l_2_0 or 1)
    end
    guildFlag:setScale(0.8)
    leftBg:addChild(guildFlag)
    droidhangComponents:mandateNode(guildFlag, "9eUG_w8WLCh")
    local nameLabel = lbl.createFontTTF(18, l_2_0.name or "unknow", ccc3(108, 62, 53))
    leftBg:addChild(nameLabel)
    droidhangComponents:mandateNode(nameLabel, "9eUG_xft90Y")
    local serverBg = img.createUISprite(img.ui.anrea_server_bg)
    leftBg:addChild(serverBg)
    droidhangComponents:mandateNode(serverBg, "9eUG_JFqvHp")
    do
      local serverLabel = lbl.createFont1(16, getSidname(l_2_0.sid or 1), ccc3(255, 251, 215))
      serverLabel:setPosition(serverBg:getContentSize().width * 0.5, serverBg:getContentSize().height * 0.5)
      serverBg:addChild(serverLabel)
    end
    local rightBg = img.createUISprite(bgName)
    rightBg:setAnchorPoint(1, 0.5)
    rightBg:setFlipX(true)
    rightBg:setPosition(bg:getContentSize().width - 30 + 3, bg:getContentSize().height * 0.5)
    bg:addChild(rightBg)
    if not l_2_1.logo then
      local guildFlag = img.createGFlag(not l_2_1 or 1)
    end
    guildFlag:setScale(0.8)
    rightBg:addChild(guildFlag)
    droidhangComponents:mandateNode(guildFlag, "YX87_kzoYuS")
    local nameLabel = lbl.createFontTTF(18, l_2_1.name or "unknow", ccc3(108, 62, 53))
    rightBg:addChild(nameLabel)
    droidhangComponents:mandateNode(nameLabel, "YX87_8M4Bxj")
    local serverBg = img.createUISprite(img.ui.anrea_server_bg)
    rightBg:addChild(serverBg)
    droidhangComponents:mandateNode(serverBg, "YX87_XeI4cQ")
    do
      local serverLabel = lbl.createFont1(16, getSidname(l_2_1.sid or 1), ccc3(255, 251, 215))
      serverLabel:setPosition(serverBg:getContentSize().width * 0.5, serverBg:getContentSize().height * 0.5)
      serverBg:addChild(serverLabel)
    end
    local vsIcon = img.createUISprite(img.ui.fight_pay_vs)
    bg:addChild(vsIcon)
    droidhangComponents:mandateNode(vsIcon, "YX87_X77I8cQ")
    return bg
   end
  local height = 0
  local itemAry = {}
  for i = 1, 8 do
    local leftGuild = l_8_2.guilds[i]
    local rightGuild = l_8_2.guilds[17 - i]
    if leftGuild or rightGuild then
      local item = createItem(leftGuild, rightGuild, i)
      height = height + item:getContentSize().height + 8
      table.insert(itemAry, item)
      scroll:addChild(item)
    end
  end
  local sy = height - 4
  for _,item in ipairs(itemAry) do
    item:setAnchorPoint(0.5, 0.5)
    item:setPosition(SCROLL_VIEW_WIDTH * 0.5 - 2, sy - item:getContentSize().height * 0.5)
    sy = sy - item:getContentSize().height - 8
  end
  scroll:setContentSize(CCSize(SCROLL_VIEW_WIDTH, height))
  scroll:setContentOffset(ccp(0, SCROLL_VIEW_HEIGHT - (height)))
end

return guildFightMain


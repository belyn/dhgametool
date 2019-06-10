-- Command line was: E:\github\dhgametool\scripts\ui\guildVice\skill.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local player = require("data.player")
local bagdata = require("data.bag")
local skilldata = require("data.gskill")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local job_pos = {}
local arrow_pos = {}
local init = function()
  local cx, cy = 180, 180
  local radius = 145
  local job_start = 112.5
  local arrow_start = 135
  local step = 45
  for ii = 1, 8 do
    job_pos[ii] = {}
    job_pos[ii].x = cx + radius * math.cos(math.rad(job_start + step * (ii - 1)))
    job_pos[ii].y = cy + radius * math.sin(math.rad(job_start + step * (ii - 1)))
    arrow_pos[ii] = {}
    arrow_pos[ii].x = cx + radius * math.cos(math.rad(arrow_start + step * (ii - 1)))
    arrow_pos[ii].y = cx + radius * math.sin(math.rad(arrow_start + step * (ii - 1)))
  end
end

init()
local JOBS = {JOB1 = 1, JOB2 = 2, JOB3 = 3, JOB4 = 4, JOB5 = 5}
local createSkillItem = function(l_2_0)
  local icon0 = img.createGSkill(l_2_0.idx)
  local icon_bg = img.createUISprite(img.ui.hero_skill_bg)
  icon_bg:setPosition(CCPoint(icon0:getContentSize().width / 2, icon0:getContentSize().height / 2))
  icon0:addChild(icon_bg, -1)
  local icon = CCMenuItemSprite:create(icon0, nil)
  local icon_sel = img.createUISprite(img.ui.guildvice_skill_sel)
  icon_sel:setPosition(CCPoint(icon:getContentSize().width / 2, icon:getContentSize().height / 2))
  icon:addChild(icon_sel)
  icon_sel:setVisible(false)
  icon.sel = icon_sel
  local mask = img.createUISprite(img.ui.guildvice_skill_mask)
  mask:setOpacity(127.5)
  mask:setPosition(CCPoint(icon:getContentSize().width / 2, icon:getContentSize().height / 2))
  icon:addChild(mask)
  icon.mask = mask
  if skilldata.isLighten(l_2_0.idx) then
    mask:setVisible(false)
    icon:setEnabled(true)
  else
    mask:setVisible(false)
    setShader(icon, SHADER_GRAY, true)
  end
  local lbl_lv = lbl.createFont2(18, l_2_0.lv .. "/" .. l_2_0.lvMax)
  lbl_lv:setPosition(CCPoint(icon:getContentSize().width / 2, 0))
  icon:addChild(lbl_lv)
  icon.lbl = lbl_lv
  if l_2_0.lvMax <= l_2_0.lv then
    lbl_lv:setColor(ccc3(165, 253, 71))
  end
  return icon
end

local showSkill, last_sel_skill = nil, nil
local onClickSkill = function(l_3_0)
  audio.play(audio.button)
  if last_sel_skill and not tolua.isnull(last_sel_skill) then
    last_sel_skill.sel:setVisible(false)
    upvalue_512 = nil
  end
  showSkill(l_3_0)
  clearShader(l_3_0.sel)
  l_3_0.sel:setVisible(true)
  upvalue_512 = l_3_0
end

local btn_jobs = {}
local arrow_ls = {}
local arrow_hs = {}
local job_icons = {1 = img.ui.gskill_job_1, 2 = img.ui.gskill_job_2, 3 = img.ui.gskill_job_3, 4 = img.ui.gskill_job_4, 5 = img.ui.gskill_job_5}
local showList = function(l_4_0, l_4_1)
  if not l_4_0 or tolua.isnull(l_4_0) then
    return 
  end
  l_4_0:removeAllChildrenWithCleanup()
  local job_icon = img.createUISprite(job_icons[l_4_1])
  job_icon:setPosition(CCPoint(180, 180))
  l_4_0:addChild(job_icon)
  local jobdata = skilldata.jobs[l_4_1]
  for ii = 1, 8 do
    local btn_icon = createSkillItem(jobdata[ii])
    do
      btn_icon:setScale(0.8)
      btn_icon.obj = jobdata[ii]
      btn_icon:setPosition(CCPoint(job_pos[ii].x, job_pos[ii].y))
      local btn_icon_menu = CCMenu:createWithItem(btn_icon)
      btn_icon_menu:setPosition(CCPoint(0, 0))
      l_4_0:addChild(btn_icon_menu)
      btn_icon.ii = ii
      btn_jobs[ii] = btn_icon
      btn_icon:registerScriptTapHandler(function()
        onClickSkill(btn_icon)
         end)
      local arr_l = img.createUISprite(img.ui.gskill_arrow_l)
      arr_l:setPosition(CCPoint(arrow_pos[ii].x, arrow_pos[ii].y))
      arr_l:setRotation(-45 * (ii - 1))
      l_4_0:addChild(arr_l)
      local arr_h = img.createUISprite(img.ui.gskill_arrow_h)
      arr_h:setPosition(CCPoint(arrow_pos[ii].x, arrow_pos[ii].y))
      arr_h:setRotation(-45 * (ii - 1))
      l_4_0:addChild(arr_h)
      if ii < 8 and skilldata.isLighten(jobdata[ii + 1].idx) then
        arr_l:setVisible(false)
        arr_h:setVisible(true)
      else
        arr_l:setVisible(true)
        arr_h:setVisible(false)
      end
      arrow_ls[ii] = arr_l
      arrow_hs[ii] = arr_h
    end
  end
  arrow_ls[8]:setVisible(false)
  arrow_hs[8]:setVisible(false)
end

ui.create = function()
  local boardlayer = require("ui.guildVice.board")
  local layer = boardlayer.create({_anim = true})
  local board = layer.inner_board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  layer.setTitle(i18n.global.gskill_board_title.string)
  local mcontainer = CCSprite:create()
  mcontainer:setContentSize(CCSizeMake(374, 40))
  mcontainer:setScale(view.minScale)
  mcontainer:setAnchorPoint(CCPoint(0.5, 1))
  mcontainer:setPosition(scalep(480, 568))
  layer:addChild(mcontainer)
  layer.mcontainer = mcontainer
  local mcontainer_w = mcontainer:getContentSize().width
  local mcontainer_h = mcontainer:getContentSize().height
  local coin_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  coin_bg:setPreferredSize(CCSizeMake(174, 40))
  coin_bg:setAnchorPoint(CCPoint(1, 0.5))
  coin_bg:setPosition(CCPoint(mcontainer_w / 2 - 13, mcontainer_h / 2))
  mcontainer:addChild(coin_bg)
  local gem_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  gem_bg:setPreferredSize(CCSizeMake(174, 40))
  gem_bg:setAnchorPoint(CCPoint(0, 0.5))
  gem_bg:setPosition(CCPoint(mcontainer_w / 2 + 13, mcontainer_h / 2))
  mcontainer:addChild(gem_bg)
  local icon_coin = img.createItemIcon2(ITEM_ID_COIN)
  icon_coin:setPosition(CCPoint(5, coin_bg:getContentSize().height / 2 + 2))
  coin_bg:addChild(icon_coin)
  local icon_gem = img.createItemIcon(ITEM_ID_GUILD_COIN)
  icon_gem:setScale(0.5)
  icon_gem:setPosition(CCPoint(5, gem_bg:getContentSize().height / 2 + 2))
  gem_bg:addChild(icon_gem)
  local coin_num = bagdata.coin()
  local lbl_coin = lbl.createFont2(16, num2KM(coin_num), ccc3(255, 246, 223))
  lbl_coin:setPosition(CCPoint(coin_bg:getContentSize().width / 2 - 10, coin_bg:getContentSize().height / 2 + 3))
  coin_bg:addChild(lbl_coin)
  lbl_coin.num = coin_num
  local gcoins = function()
    return bagdata.items.find(ITEM_ID_GUILD_COIN).num
   end
  local gem_num = gcoins()
  local lbl_gem = lbl.createFont2(16, gem_num, ccc3(255, 246, 223))
  lbl_gem:setPosition(CCPoint(gem_bg:getContentSize().width / 2 - 10, gem_bg:getContentSize().height / 2 + 3))
  gem_bg:addChild(lbl_gem)
  lbl_gem.num = gem_num
  local updateLabels = function()
    local coinnum = bagdata.coin()
    if lbl_coin.num ~= coinnum then
      lbl_coin:setString(num2KM(coinnum))
      lbl_coin.num = coinnum
    end
    local gemnum = gcoins()
    if lbl_gem.num ~= gemnum then
      lbl_gem:setString(gemnum)
      lbl_gem.num = gemnum
    end
   end
  local skl_board = img.createUI9Sprite(img.ui.botton_fram_2)
  skl_board:setPreferredSize(CCSizeMake(300, 361))
  skl_board:setAnchorPoint(CCPoint(1, 0))
  skl_board:setPosition(CCPoint(board_w - 22, 22))
  board:addChild(skl_board)
  local skl_board_w = skl_board:getContentSize().width
  local skl_board_h = skl_board:getContentSize().height
  local btn_reset0 = img.createUISprite(img.ui.btn_reset)
  local btn_reset = SpineMenuItem:create(json.ui.button, btn_reset0)
  btn_reset:setPosition(CCPoint(45, board_h - 45))
  local btn_reset_menu = CCMenu:createWithItem(btn_reset)
  btn_reset_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_reset_menu)
  upvalue_3072 = function(l_3_0)
    local skillObj = l_3_0.obj
    if skl_board.container and not tolua.isnull(skl_board.container) then
      skl_board.container:removeFromParentAndCleanup(true)
    end
    local container = CCSprite:create()
    container:setContentSize(CCSizeMake(skl_board_w, skl_board_h))
    container:setPosition(CCPoint(skl_board_w / 2, skl_board_h / 2))
    skl_board:addChild(container)
    skl_board.container = container
    local container_w = container:getContentSize().width
    local container_h = container:getContentSize().height
    local tmp_icon = img.createGSkill(skillObj.idx)
    tmp_icon:setScale(0.8)
    tmp_icon:setPosition(CCPoint(container_w / 2, 305))
    container:addChild(tmp_icon)
    local tmp_icon_bg = img.createUISprite(img.ui.hero_skill_bg)
    tmp_icon_bg:setPosition(CCPoint(tmp_icon:getContentSize().width / 2, tmp_icon:getContentSize().height / 2))
    tmp_icon:addChild(tmp_icon_bg, -1)
    local tmp_name = lbl.createMixFont1(18, i18n.guildskill[skillObj.idx].name, ccc3(148, 98, 66))
    tmp_name:setPosition(CCPoint(container_w / 2, 255))
    container:addChild(tmp_name)
    local split_line = img.createUI9Sprite(img.ui.split_line)
    split_line:setPreferredSize(CCSizeMake(255, 2))
    split_line:setPosition(CCPoint(container_w / 2, 235))
    container:addChild(split_line)
    local b_offset_x = 26
    local b_offset_y = 204
    local b_step_y = -26
    local buffs = skilldata.getBuffs(skillObj)
    for ii = 1, #buffs do
      local lbl_cur = lbl.createFont1(14, buffs[ii].name .. "  +" .. buffs[ii].value, ccc3(130, 71, 35))
      lbl_cur:setAnchorPoint(CCPoint(0, 0))
      lbl_cur:setPosition(CCPoint(23, 204 + (ii - 1) * b_step_y))
      container:addChild(lbl_cur)
      if buffs[ii].gvalue then
        local icon_arrow = img.createUISprite(img.ui.arrow)
        icon_arrow:setScale(0.7)
        icon_arrow:setAnchorPoint(CCPoint(0, 0.5))
        icon_arrow:setPosition(CCPoint(lbl_cur:boundingBox():getMaxX() + 8, lbl_cur:boundingBox():getMidY()))
        container:addChild(icon_arrow)
        local lbl_growth = lbl.createFont1(14, "  +" .. buffs[ii].gvalue, ccc3(8, 141, 14))
        lbl_growth:setAnchorPoint(CCPoint(0, 0.5))
        lbl_growth:setPosition(CCPoint(icon_arrow:boundingBox():getMaxX(), lbl_cur:boundingBox():getMidY()))
        container:addChild(lbl_growth)
      end
    end
    local cost_coin_bg = img.createUI9Sprite(img.ui.setting_dark_bg)
    cost_coin_bg:setPreferredSize(CCSizeMake(109, 30))
    cost_coin_bg:setPosition(CCPoint(container_w / 2 - 56, 113))
    container:addChild(cost_coin_bg)
    local cost_gcoin_bg = img.createUI9Sprite(img.ui.setting_dark_bg)
    cost_gcoin_bg:setPreferredSize(CCSizeMake(109, 30))
    cost_gcoin_bg:setPosition(CCPoint(container_w / 2 + 68, 113))
    container:addChild(cost_gcoin_bg)
    local tmp_icon_coin = img.createItemIcon2(ITEM_ID_COIN)
    tmp_icon_coin:setPosition(CCPoint(5, cost_coin_bg:getContentSize().height / 2 + 0))
    cost_coin_bg:addChild(tmp_icon_coin)
    local tmp_icon_gem = img.createItemIcon(ITEM_ID_GUILD_COIN)
    tmp_icon_gem:setScale(0.5)
    tmp_icon_gem:setPosition(CCPoint(5, cost_gcoin_bg:getContentSize().height / 2 + 0))
    cost_gcoin_bg:addChild(tmp_icon_gem)
    local cost_coin_num, cost_gcoin_num = skilldata.getCost(skillObj)
    local lbl_coin_cost = lbl.createFont2(16, cost_coin_num, ccc3(255, 246, 223))
    lbl_coin_cost:setPosition(CCPoint(cost_coin_bg:getContentSize().width / 2, cost_coin_bg:getContentSize().height / 2 + 0))
    cost_coin_bg:addChild(lbl_coin_cost)
    if bagdata.coin() < cost_coin_num then
      lbl_coin_cost:setColor(ccc3(212, 0, 0))
    end
    local lbl_gcoin_cost = lbl.createFont2(16, cost_gcoin_num, ccc3(255, 246, 223))
    lbl_gcoin_cost:setPosition(CCPoint(cost_gcoin_bg:getContentSize().width / 2 + 3, cost_gcoin_bg:getContentSize().height / 2 + 0))
    cost_gcoin_bg:addChild(lbl_gcoin_cost)
    if gcoins() < cost_gcoin_num then
      lbl_gcoin_cost:setColor(ccc3(212, 0, 0))
    end
    local btn_up0 = img.createLogin9Sprite(img.login.button_9_small_gold)
    btn_up0:setPreferredSize(CCSizeMake(172, 52))
    local lbl_btn_up = lbl.createFont1(18, i18n.global.gskill_btn_up.string, ccc3(130, 71, 35))
    lbl_btn_up:setPosition(CCPoint(btn_up0:getContentSize().width / 2, btn_up0:getContentSize().height / 2))
    btn_up0:addChild(lbl_btn_up)
    local btn_up = SpineMenuItem:create(json.ui.button, btn_up0)
    btn_up:setPosition(CCPoint(container_w / 2, 54))
    local btn_up_menu = CCMenu:createWithItem(btn_up)
    btn_up_menu:setPosition(CCPoint(0, 0))
    container:addChild(btn_up_menu)
    if not skilldata.isLighten(skillObj.idx) then
      btn_up:setEnabled(false)
      setShader(btn_up, SHADER_GRAY, true)
      local buffs_count = #buffs
      local lbl_require = lbl.createFont1(14, string.format(i18n.global.need_pre_skill_lv.string, skillObj.lvReq), ccc3(212, 0, 0))
      lbl_require:setAnchorPoint(CCPoint(0, 0))
      lbl_require:setPosition(CCPoint(23, 204 + (buffs_count - 0) * b_step_y))
      container:addChild(lbl_require)
    end
    btn_up:registerScriptTapHandler(function()
      if skillObj.lvMax <= skillObj.lv then
        showToast(i18n.global.gskill_max_lv.string)
        return 
      end
      if bagdata.coin() < cost_coin_num then
        showToast(i18n.global.blackmarket_coin_lack.string)
        return 
      end
      if gcoins() < cost_gcoin_num then
        showToast(i18n.global.guild_shop_coin_lack.string)
        return 
      end
      local nParam = {sid = player.sid, id = skillObj.idx}
      addWaitNet()
      netClient:gskl_up(nParam, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        skillObj.lv = skillObj.lv + 1
        if skillObj.lvMax < skillObj.lv then
          skillObj.lv = skillObj.lvMax
        end
        bagdata.subCoin(cost_coin_num)
        bagdata.items.sub({id = ITEM_ID_GUILD_COIN, num = cost_gcoin_num})
        btnObj.lbl:setString(skillObj.lv .. "/" .. skillObj.lvMax)
        if btn_jobs[btnObj.ii + 1] then
          local next_btnObj = btn_jobs[btnObj.ii + 1]
          if skilldata.testLock(next_btnObj.obj.idx) then
            next_btnObj.mask:setVisible(false)
            clearShader(next_btnObj, true)
            next_btnObj:setEnabled(true)
            json.load(json.ui.gonghui_jiesuo)
            local ani_jiesuo = DHSkeletonAnimation:createWithKey(json.ui.gonghui_jiesuo)
            ani_jiesuo:setScale(0.8)
            ani_jiesuo:scheduleUpdateLua()
            ani_jiesuo:setPosition(CCPoint(next_btnObj:boundingBox():getMidX(), next_btnObj:boundingBox():getMidY()))
            btnObj:getParent():getParent():addChild(ani_jiesuo, 1000)
            ani_jiesuo:playAnimation("animation", 1)
            arrow_ls[btnObj.ii]:setVisible(false)
            arrow_hs[btnObj.ii]:setVisible(true)
          end
        end
        audio.play(audio.guild_skill_upgrade)
        showSkill(btnObj)
        json.load(json.ui.gonghui_shengji)
        local ani_shengji = DHSkeletonAnimation:createWithKey(json.ui.gonghui_shengji)
        ani_shengji:scheduleUpdateLua()
        ani_shengji:setPosition(CCPoint(container_w / 2, 305))
        skl_board:addChild(ani_shengji, 1000)
        ani_shengji:playAnimation("animation", 1)
         end)
      end)
    if skillObj.lvMax <= skillObj.lv then
      l_3_0.lbl:setColor(ccc3(165, 253, 71))
      cost_coin_bg:setVisible(false)
      cost_gcoin_bg:setVisible(false)
      btn_up:setVisible(false)
    end
   end
  local onClickSkill = function(l_4_0)
    audio.play(audio.button)
    if last_sel_skill and not tolua.isnull(last_sel_skill) then
      last_sel_skill.sel:setVisible(false)
      upvalue_512 = nil
    end
    showSkill(l_4_0)
    clearShader(l_4_0.sel)
    l_4_0.sel:setVisible(true)
    upvalue_512 = l_4_0
   end
  local job_bg = img.createUISprite(img.ui.gskill_bg)
  job_bg:setPosition(CCPoint(217, 202))
  board:addChild(job_bg)
  local job_container = CCSprite:create()
  job_container:setContentSize(CCSizeMake(360, 360))
  job_container:setPosition(CCPoint(job_bg:getContentSize().width / 2, job_bg:getContentSize().height / 2))
  job_bg:addChild(job_container)
  local current_job = nil
  local gskill_tabs = {}
  local onTab = function(l_5_0)
    current_job = l_5_0
    for ii = 1, 5 do
      gskill_tabs[ii]:setEnabled(ii ~= l_5_0)
      gskill_tabs[ii].hl:setVisible(ii == l_5_0)
    end
    showList(job_container, l_5_0)
    showSkill(btn_jobs[1])
    btn_jobs[1].sel:setVisible(true)
    upvalue_3072 = btn_jobs[1]
   end
  for ii = 1, 5 do
    do
      local gskill_tabl = img.createUISprite("gskill_tabl" .. ii .. ".png")
      local gskill_tabh = img.createUISprite("gskill_tabh" .. ii .. ".png")
      gskill_tabh:setPosition(CCPoint(gskill_tabl:getContentSize().width / 2, gskill_tabl:getContentSize().height / 2))
      gskill_tabl:addChild(gskill_tabh)
      local gskill_tab = CCMenuItemSprite:create(gskill_tabl, nil)
      gskill_tab:setAnchorPoint(CCPoint(0, 1))
      gskill_tab:setPosition(CCPoint(board_w - 3, 388 - (ii - 1) * 71))
      local gskill_tab_menu = CCMenu:createWithItem(gskill_tab)
      gskill_tab_menu:setPosition(CCPoint(0, 0))
      board:addChild(gskill_tab_menu)
      gskill_tab.hl = gskill_tabh
      gskill_tabs[ii] = gskill_tab
      gskill_tabs[ii]:registerScriptTapHandler(function()
        audio.play(audio.button)
        onTab(ii)
         end)
    end
  end
  onTab(JOBS.JOB1)
  btn_reset:registerScriptTapHandler(function()
    audio.play(audio.button)
    if not skilldata.isLearned(current_job) then
      showToast(i18n.global.gskill_reset_learn.string)
      return 
    end
    layer:addChild(ui.showReset(current_job, onTab), 1000)
   end)
  local last_update_time = os.time()
  local onUpdate = function(l_8_0)
    if os.time() - last_update_time < 0.5 then
      return 
    end
    last_update_time = os.time()
    updateLabels()
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  local touchbeginx, touchbeginy, isclick, last_touch_sprite = nil, nil, nil, nil
  local onTouchBegan = function(l_9_0, l_9_1)
    touchbeginx, upvalue_512 = l_9_0, l_9_1
    upvalue_1024 = true
    local p0 = board:convertToNodeSpace(ccp(l_9_0, l_9_1))
    if not board:boundingBox():containsPoint(p0) then
      upvalue_1024 = false
    end
    return true
   end
  local onTouchMoved = function(l_10_0, l_10_1)
    if isclick and (math.abs(touchbeginx - l_10_0) > 10 or math.abs(touchbeginy - l_10_1) > 10) then
      isclick = false
    end
   end
  local onTouchEnded = function(l_11_0, l_11_1)
    if not isclick then
      return 
    end
   end
  local onTouch = function(l_12_0, l_12_1, l_12_2)
    if l_12_0 == "began" then
      return onTouchBegan(l_12_1, l_12_2)
    elseif l_12_0 == "moved" then
      return onTouchMoved(l_12_1, l_12_2)
    else
      return onTouchEnded(l_12_1, l_12_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch, false, -128, false)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

ui.showReset = function(l_6_0, l_6_1)
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board = img.createLogin9Sprite(img.login.dialog)
  local board_w = 520
  local board_h = 345
  local scale_factor = view.minScale
  board:setPreferredSize(CCSize(board_w, board_h))
  board:setScale(scale_factor)
  board:setAnchorPoint(CCPoint(0.5, 0.5))
  board:setPosition(CCPoint(view.physical.w / 2, view.physical.h / 2))
  layer:addChild(board, 100)
  layer.board = board
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(board_w - 25, board_h - 28))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_close_menu, 100)
  layer.btn_close = btn_close
  btn_close:registerScriptTapHandler(function()
    layer.onAndroidBack()
   end)
  board:setScale(0.1 * scale_factor)
  board:runAction(CCEaseBackOut:create(CCScaleTo:create(0.3, scale_factor)))
  local lbl_title = lbl.createMixFont1(24, i18n.global.gskill_reset_title.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_w / 2, board_h - 29))
  board:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createMixFont1(24, i18n.global.gskill_reset_title.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_w / 2, board_h - 31))
  board:addChild(lbl_title_shadowD)
  local lbl_body = lbl.createMix({font = 1, size = 18, text = i18n.global.gskill_reset_tips.string, color = ccc3(120, 70, 39), width = 400, align = kCCTextAlignmentLeftt})
  lbl_body:setAnchorPoint(CCPoint(0.5, 1))
  lbl_body:setPosition(CCPoint(board_w / 2, board_h - 100))
  board:addChild(lbl_body)
  layer.bodyLabel = lbl_body
  local sCode = skilldata.getCode(math.pow(2, l_6_0 - 1))
  local cost_gem = 2000
  if sCode == 0 then
    cost_gem = 0
  end
  local btn_reset0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_reset0:setPreferredSize(CCSizeMake(150, 60))
  local icon_gem = img.createItemIcon(ITEM_ID_GEM)
  icon_gem:setScale(0.5)
  icon_gem:setPosition(CCPoint(40, 30))
  btn_reset0:addChild(icon_gem)
  local lbl_price = lbl.createFont2(22, cost_gem)
  lbl_price:setPosition(CCPoint(100, 30))
  btn_reset0:addChild(lbl_price)
  local btn_reset = SpineMenuItem:create(json.ui.button, btn_reset0)
  btn_reset:setPosition(CCPoint(board_w / 2, 87))
  local btn_reset_menu = CCMenu:createWithItem(btn_reset)
  btn_reset_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_reset_menu)
  btn_reset:registerScriptTapHandler(function()
    audio.play(audio.button)
    if cost_gem > 0 and bagdata.gem() < 2000 then
      showToast(i18n.global.summon_gem_lack.string)
      return 
    end
    local gParams = {sid = player.sid, id = which}
    addWaitNet()
    netClient:gskl_reset(gParams, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.summon_gem_lack.string)
        return 
      end
      bagdata.subGem(cost_gem)
      bagdata.addRewards(l_1_0.reward)
      skilldata.resetJob(which)
      layer.onAndroidBack()
      if handler then
        handler(which)
      end
      local rewards = require("ui.reward")
      CCDirector:sharedDirector():getRunningScene():addChild(rewards.createFloating(l_1_0.reward), 100000)
      end)
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  layer.onAndroidBack = function()
    layer:removeFromParentAndCleanup(true)
   end
  addBackEvent(layer)
  local onEnter = function()
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_6_0)
    if l_6_0 == "enter" then
      onEnter()
    elseif l_6_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui


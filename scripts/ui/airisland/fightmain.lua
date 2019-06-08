-- Command line was: E:\github\dhgametool\scripts\ui\airisland\fightmain.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local particle = require("res.particle")
local i18n = require("res.i18n")
local net = require("net.netClient")
local player = require("data.player")
local bagdata = require("data.bag")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local tipsitem = require("ui.tips.item")
local tipsequip = require("ui.tips.equip")
local reward = require("ui.reward")
local selecthero = require("ui.selecthero.main")
local herosdata = require("data.heros")
local airData = require("data.airisland")
local cfgfloatland = require("config.floatland")
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
    local equip = img.createEquip(l_1_1)
    equipBtn = SpineMenuItem:create(json.ui.button, equip)
    equipBtn:setScale(0.85)
    equipBtn:setPosition(dialog.board:getContentSize().width / 2, 185)
    local iconMenu = CCMenu:createWithItem(equipBtn)
    iconMenu:setPosition(0, 0)
    dialog.board:addChild(iconMenu)
    local countLbl = lbl.createFont2(20, string.format("X%d", l_1_2), ccc3(255, 246, 223))
    countLbl:setAnchorPoint(ccp(0, 0.5))
    countLbl:setPosition(equipBtn:boundingBox():getMaxX() + 10, 185)
    dialog.board:addChild(countLbl)
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
  local layer = CCLayer:create()
  airData.count = airData.count + 1
  local bg = CCNode:create()
  bg:setContentSize(CCSizeMake(view.logical.w, view.logical.h))
  bg:setScale(view.minScale)
  bg:setPosition(CCPoint(view.midX, view.midY))
  layer:addChild(bg)
  local itembar = require("ui.airisland.itembar")
  layer:addChild(itembar.create(), 1000)
  local animBg = json.create(json.ui.kongzhan_map)
  animBg:setScale(view.minScale)
  animBg:setPosition(view.midX, view.midY)
  animBg:playAnimation("animation", -1)
  if airData.count == 1 then
    local animYun = json.create(json.ui.kongzhan_map_yun)
    do
      animYun:setScale(view.minScale)
      animYun:setPosition(view.midX, view.midY)
      animYun:playAnimation("in")
      layer:addChild(animYun, 1020)
      local aniban = CCLayer:create()
      aniban:setTouchEnabled(true)
      aniban:setTouchSwallowEnabled(true)
      layer:addChild(aniban, 1000)
      schedule(layer, 1.5, function()
        aniban:removeFromParent()
         end)
    end
  end
  layer:addChild(animBg)
  local boLand = {}
  local iconCd = {}
  local flagRefresh = {}
  local buildingObjs = {}
  local buildingType = {}
  local last_selected_sprite = 0
  local bossChage = function(l_2_0)
    if l_2_0 == 0 then
      buildingObjs[2]:playAnimation("animation2", -1)
    else
      buildingObjs[l_2_0 + 2]:playAnimation("loop", -1)
    end
   end
  local onSelfClicked = function(l_3_0)
    audio.play(audio.button)
    upvalue_512 = 0
    if l_3_0 and not tolua.isnull(l_3_0) then
      clearShader(l_3_0, true)
    end
    local params = {sid = player.sid}
    addWaitNet()
    net:island_sync(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      local airData = require("data.airisland")
      airData.setData(l_1_0)
      replaceScene(require("ui.airisland.main1").create(l_1_0))
      end)
   end
  local onBossClicked = function(l_4_0)
    audio.play(audio.button)
    upvalue_512 = 0
    if l_4_0 and not tolua.isnull(l_4_0) then
      clearShader(l_4_0, true)
      local bossline = require("ui.airisland.bossline")
      layer:addChild(bossline.create(bossChage), 1000)
    end
   end
  local onSkinIslandClicked = function(l_5_0)
    audio.play(audio.button)
    upvalue_512 = 0
    if l_5_0 and not tolua.isnull(l_5_0) then
      clearShader(l_5_0, true)
      local npcline = require("ui.airisland.npcline")
      layer:addChild(npcline.create(l_5_0.pos, l_5_0.cdk, bossChage), 1000)
    end
   end
  local onIslandClicked = function(l_6_0)
    audio.play(audio.button)
    upvalue_512 = 0
    if l_6_0 and not tolua.isnull(l_6_0) then
      clearShader(l_6_0, true)
      local npcline = require("ui.airisland.npcline")
      layer:addChild(npcline.create(l_6_0.pos, l_6_0.cdk, bossChage), 1000)
    end
   end
  local onBoxClicked = function(l_7_0)
    audio.play(audio.button)
    upvalue_512 = 0
    if l_7_0 and not tolua.isnull(l_7_0) then
      clearShader(l_7_0, true)
      local params = {sid = player.sid, pos = l_7_0.pos}
      addWaitNet()
      net:island_box(params, function(l_1_0)
        delWaitNet()
        tbl2string(l_1_0)
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        if l_1_0.land then
          boLand[l_1_0.land.pos]:stopAnimation()
          boLand[l_1_0.land.pos]:playAnimation("open")
        end
        local ban = CCLayer:create()
        ban:setTouchEnabled(true)
        ban:setTouchSwallowEnabled(true)
        layer:addChild(ban, 1000)
        schedule(layer, 1, function()
          local to = buildingType[cfgfloatland[__data.land.id].type + 1]
          boLand[__data.land.pos]:removeChildFollowSlot("code_label")
          animBg:removeChildFollowSlot(to.code_name .. __data.land.pos)
          iconCd[__data.land.pos] = nil
          boLand[__data.land.pos] = nil
          airData.data.land.land[__data.land.pos] = __data.land
          airData.data.land.land[__data.land.pos].cd = __data.land.cd + os.time()
          local cd = math.max(0, __data.land.cd - os.time())
          local timeLab = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
          boLand[__data.land.pos] = json.create(to.jsonName)
          boLand[__data.land.pos].data = to
          buildingObjs[__data.land.pos + 2] = boLand[__data.land.pos]
          boLand[__data.land.pos]:playAnimation("animation", -1)
          animBg:addChildFollowSlot(to.code_name .. __data.land.pos, boLand[__data.land.pos])
          iconCd[__data.land.pos] = lbl.createFont2(16, timeLab, ccc3(165, 253, 71))
          boLand[__data.land.pos]:addChildFollowSlot("code_label", iconCd[__data.land.pos])
          if __data.reward.equips then
            bagdata.equips.add(__data.reward.equips[1])
            local pop = createPopupPieceBatchSummonResult("equip", __data.reward.equips[1].id, __data.reward.equips[1].num)
            layer:addChild(pop, 1000)
          else
            bagdata.items.add(__data.reward.items[1])
            local pop = createPopupPieceBatchSummonResult("item", __data.reward.items[1].id, __data.reward.items[1].num)
            layer:addChild(pop, 1000)
          end
          ban:removeFromParent()
            end)
         end)
    end
   end
  local building_lbl_color = ccc3(251, 230, 126)
  buildingType = {1 = {name = "self", jsonName = json.ui.kongzhan_dao1, code_name = "code_position_self", lbl = i18n.global.floatland_maintown_name.string, tapFunc = onSelfClicked}, 2 = {name = "boss", jsonName = json.ui.kongzhan_dragon, code_name = "code_position_boss", lbl = i18n.global.floatland_boss_name.string, tapFunc = onBossClicked}, 3 = {name = "island", jsonName = json.ui.kongzhan_golem, code_name = "code_position", tapFunc = onIslandClicked}, 4 = {name = "box", jsonName = json.ui.kongzhan_dao3, code_name = "code_position", tapFunc = onBoxClicked}, 5 = {name = "diaoluo", jsonName = json.ui.kongzhan_diaoluo, code_name = "code_position", tapFunc = onSkinIslandClicked}, 6 = {name = "xuanwo", jsonName = json.ui.kongzhan_xuanwo, code_name = "code_position"}}
  local createBuildings = function()
    buildingObjs = {}
    for i = 1, 2 do
      local to = buildingType[i]
      local bo = json.create(to.jsonName)
      bo.data = to
      buildingObjs[i] = bo
      local info = airData.data.land
      if i == 2 and info.dead and info.dead == true then
        bo:playAnimation("animation2", -1)
      else
        bo:playAnimation("animation", -1)
      end
      animBg:addChildFollowSlot(to.code_name, bo)
      local lbl_xxx = lbl.createFont2(18, to.lbl, building_lbl_color)
      local building_lbl_xxx = img.createUI9Sprite(img.ui.main_building_lbl)
      local bd_size = lbl_xxx:boundingBox().size
      if bd_size.width < 160 then
        bd_size.width = 160
      end
      building_lbl_xxx:setPreferredSize(CCSizeMake(bd_size.width, 40))
      lbl_xxx:setPosition(CCPoint(building_lbl_xxx:getContentSize().width / 2, building_lbl_xxx:getContentSize().height / 2))
      building_lbl_xxx:addChild(lbl_xxx)
      bo:addChildFollowSlot("code_label", building_lbl_xxx)
    end
    for i = 1,  airData.data.land.land do
      flagRefresh[i] = false
      local info = airData.data.land
      local to = buildingType[cfgfloatland[info.land[i].id].type + 1]
      boLand[i] = json.create(to.jsonName)
      boLand[i].data = to
      buildingObjs[i + 2] = boLand[i]
      if info.land[i].dead then
        boLand[i]:playAnimation("loop", -1)
      else
        boLand[i]:playAnimation("animation", -1)
      end
      animBg:addChildFollowSlot(to.code_name .. info.land[i].pos, boLand[i])
      if info.land[i].cd then
        iconCd[i] = lbl.createFont2(16, "", ccc3(165, 253, 71))
        boLand[i]:addChildFollowSlot("code_label", iconCd[i])
      end
    end
    for i = 1, 27 -  airData.data.land.land do
      local to = buildingType[6]
      local bo = json.create(json.ui.kongzhan_xuanwo)
      bo.data = to
      buildingObjs[i + 2 +  airData.data.land.land] = bo
      bo:playAnimation("animation", -1)
      animBg:addChildFollowSlot(to.code_name .. i +  airData.data.land.land, bo)
    end
   end
  createBuildings()
  local help = img.createUISprite(img.ui.btn_help)
  local helpBtn = SpineMenuItem:create(json.ui.button, help)
  helpBtn:setScale(view.minScale)
  helpBtn:setPosition(scalep(926, 546))
  local helpMenu = CCMenu:createWithItem(helpBtn)
  helpMenu:setPosition(ccp(0, 0))
  layer:addChild(helpMenu, 10)
  helpBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local helpLayer = require("ui.help").create(i18n.global.floatland_help.string)
    layer:addChild(helpLayer, 1000)
   end)
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = SpineMenuItem:create(json.ui.button, btnBackSprite)
  btnBack:setScale(view.minScale)
  btnBack:setPosition(scalep(35, 546))
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  layer:addChild(menuBack, 10)
  btnBack:registerScriptTapHandler(function()
    local params = {sid = player.sid}
    addWaitNet()
    net:island_sync(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      local airData = require("data.airisland")
      airData.setData(l_1_0)
      replaceScene(require("ui.airisland.main1").create(l_1_0))
      end)
   end)
  local npcChanges = function(l_11_0)
    for i = 1,  l_11_0 do
      buildingObjs[l_11_0[i] + 2]:playAnimation("loop", -1)
    end
   end
  local createSurebuy = function()
    local params = {}
    params.btn_count = 0
    params.body = string.format(i18n.global.island_sweep_sure.string, 20)
    local board_w = 474
    local dialoglayer = require("ui.dialog").create(params)
    local btnYesSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnYesSprite:setPreferredSize(CCSize(153, 50))
    local btnYes = SpineMenuItem:create(json.ui.button, btnYesSprite)
    btnYes:setPosition(board_w / 2 + 95, 100)
    local labYes = lbl.createFont1(18, i18n.global.board_confirm_yes.string, ccc3(115, 59, 5))
    labYes:setPosition(btnYes:getContentSize().width / 2, btnYes:getContentSize().height / 2)
    btnYesSprite:addChild(labYes)
    local menuYes = CCMenu:create()
    menuYes:setPosition(0, 0)
    menuYes:addChild(btnYes)
    dialoglayer.board:addChild(menuYes)
    local btnNoSprite = img.createLogin9Sprite(img.login.button_9_small_gold)
    btnNoSprite:setPreferredSize(CCSize(153, 50))
    local btnNo = SpineMenuItem:create(json.ui.button, btnNoSprite)
    btnNo:setPosition(board_w / 2 - 95, 100)
    local labNo = lbl.createFont1(18, i18n.global.board_confirm_no.string, ccc3(115, 59, 5))
    labNo:setPosition(btnNo:getContentSize().width / 2, btnNo:getContentSize().height / 2)
    btnNoSprite:addChild(labNo)
    local menuNo = CCMenu:create()
    menuNo:setPosition(0, 0)
    menuNo:addChild(btnNo)
    dialoglayer.board:addChild(menuNo)
    local showRewardlayer = function(l_1_0, l_1_1)
      if l_1_0 then
        layer:getParent():addChild(require("ui.hook.drops").create(l_1_0, i18n.global.mail_rewards.string), 1000)
      end
      dialoglayer:removeFromParentAndCleanup(true)
      end
    btnYes:registerScriptTapHandler(function()
      audio.play(audio.button)
      dialoglayer:addChild(selecthero.create({type = "sweepforcomisland", callback = showRewardlayer, callback2 = npcChanges}), 1000)
      end)
    btnNo:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      audio.play(audio.button)
      end)
    local diabackEvent = function()
      dialoglayer:removeFromParentAndCleanup(true)
      end
    dialoglayer.onAndroidBack = function()
      diabackEvent()
      end
    addBackEvent(dialoglayer)
    local onEnter = function()
      dialoglayer.notifyParentLock()
      end
    local onExit = function()
      dialoglayer.notifyParentUnlock()
      end
    dialoglayer:registerScriptHandler(function(l_8_0)
      if l_8_0 == "enter" then
        onEnter()
      elseif l_8_0 == "exit" then
        onExit()
      end
      end)
    return dialoglayer
   end
  local sweep = img.createUISprite(img.ui.airisland_sweep_bg)
  local sweepBtn = SpineMenuItem:create(json.ui.button, sweep)
  sweepBtn:setScale(view.minScale)
  sweepBtn:setPosition(scalep(895, 65))
  local sweepMenu = CCMenu:createWithItem(sweepBtn)
  sweepMenu:setPosition(ccp(0, 0))
  layer:addChild(sweepMenu, 10)
  json.load(json.ui.cannon)
  local animSweep = DHSkeletonAnimation:createWithKey(json.ui.cannon)
  animSweep:scheduleUpdateLua()
  animSweep:playAnimation("animation", -1)
  animSweep:setPosition(sweep:getContentSize().width / 2, sweep:getContentSize().height / 2)
  sweep:addChild(animSweep)
  local sweepLbl = lbl.createFont2(20, i18n.global.act_bboss_sweep.string, ccc3(255, 246, 223))
  sweepLbl:setPosition(sweep:getContentSize().width / 2, 5)
  sweep:addChild(sweepLbl)
  sweepBtn:registerScriptTapHandler(function()
    disableObjAWhile(sweepBtn)
    audio.play(audio.button)
    if airData.data.vit.vit <= 0 then
      showToast(i18n.global.airisland_toast_noflr.string)
      return 
    end
    animSweep:playAnimation("animation2")
    schedule(layer, 0.5, function()
      local surebuy = createSurebuy()
      layer:addChild(surebuy, 1001)
      end)
   end)
  autoLayoutShift(btnBack)
  autoLayoutShift(helpBtn)
  autoLayoutShift(sweepBtn)
  local beginX = 0
  local beginY = 0
  local isClick = false
  local currenX = 0
  local currenY = 0
  local speed = 2
  local minPosx = view.physical.w * 0.5 - (748 * view.minScale - view.physical.w * 0.5)
  local maxPosx = view.physical.w * 0.5 + (748 * view.minScale - view.physical.w * 0.5)
  local minPosy = view.physical.h * 0.5 - (564 * view.minScale - view.physical.h * 0.5)
  local maxPosy = view.physical.h * 0.5 + (564 * view.minScale - view.physical.h * 0.5)
  local inRange = function(l_14_0, l_14_1)
    if l_14_0 < minPosx or maxPosx < l_14_0 or l_14_1 < minPosy or maxPosy < l_14_1 then
      return false
    end
    return true
   end
  local onTouchBegan = function(l_15_0, l_15_1)
    local po = bg:convertToNodeSpace(CCPoint(l_15_0, l_15_1))
    upvalue_512 = po.x
    upvalue_1024 = po.y
    upvalue_1536 = true
    upvalue_2048 = po.x
    upvalue_2560 = po.y
    for ii = 1,  buildingObjs do
      local tObj = buildingObjs[ii]
      if tObj and tObj.data.tapFunc and tObj:getAabbBoundingBox():containsPoint(CCPoint(l_15_0, l_15_1)) then
        setShader(tObj, SHADER_HIGHLIGHT, true)
        upvalue_3584 = tObj
    else
      end
    end
    return true
   end
  local onTouchMoved = function(l_16_0, l_16_1)
    local po = bg:convertToNodeSpace(CCPoint(l_16_0, l_16_1))
    if isClick and (math.abs(po.x - beginX) > 15 or math.abs(po.y - beginY) > 15) and last_selected_sprite ~= 0 then
      clearShader(last_selected_sprite, true)
      upvalue_2048 = 0
      upvalue_512 = false
    end
    local px, py = animBg:getPosition()
    local deltaX = (po.x - currenX) * speed
    local deltaY = (po.y - currenY) * speed
    upvalue_4096 = po.y
    upvalue_3072 = po.x
    if (px + deltaX < minPosx or maxPosx < px + deltaX) and minPosy <= py + deltaY and py + deltaY <= maxPosy then
      animBg:setPosition(px, py + deltaY)
      return 
    end
    if (py + deltaY < minPosy or maxPosy < py + deltaY) and minPosx <= px + deltaX and px + deltaX <= maxPosx then
      animBg:setPosition(px + deltaX, py)
      return 
    end
    if inRange(px + deltaX, py + deltaY) == true then
      animBg:setPosition(px + deltaX, py + deltaY)
    end
   end
  local onTouchEnded = function(l_17_0, l_17_1)
    if not isClick then
      return 
    end
    if last_selected_sprite == 0 then
      return 
    end
    for ii = 1, 2 +  airData.data.land.land do
      local tObj = buildingObjs[ii]
      tObj.pos = ii - 2
      if tObj.pos >= 1 and airData.data.land.land[tObj.pos].cdk then
        tObj.cdk = airData.data.land.land[tObj.pos].cdk
      end
      if tObj:getAabbBoundingBox():containsPoint(CCPoint(l_17_0, l_17_1)) then
        print("you clicked " .. tObj.data.name)
        if tObj.data.tapFunc then
          tObj.data.tapFunc(tObj)
      else
        end
      end
    end
    if last_selected_sprite ~= 0 then
      upvalue_512 = 0
    end
   end
  local onTouch = function(l_18_0, l_18_1, l_18_2)
    if l_18_0 == "began" then
      return onTouchBegan(l_18_1, l_18_2)
    elseif l_18_0 == "moved" then
      return onTouchMoved(l_18_1, l_18_2)
    else
      return onTouchEnded(l_18_1, l_18_2)
    end
   end
  layer:registerScriptTouchHandler(onTouch)
  layer:setTouchEnabled(true)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    replaceScene(require("ui.town.main").create())
   end
  local onEnter = function()
    layer.notifyParentLock()
   end
  local onExit = function()
    json.unload(json.ui.kongzhan_map)
    json.unload(json.ui.kongzhan_map_yun)
    json.unload(json.ui.kongzhan_dao1)
    json.unload(json.ui.kongzhan_dragon)
    json.unload(json.ui.kongzhan_golem)
    json.unload(json.ui.kongzhan_dao3)
    json.unload(json.ui.kongzhan_diaoluo)
    json.unload(json.ui.kongzhan_xuanwo)
    json.unload(json.ui.cannon)
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_22_0)
    if l_22_0 == "enter" then
      onEnter()
    elseif l_22_0 == "exit" then
      onExit()
    elseif l_22_0 == "cleanup" then
       -- Warning: missing end command somewhere! Added here
    end
   end)
  local last_update = os.time()
  local onUpdate = function(l_23_0)
    if os.time() - last_update < 1 then
      return 
    end
    last_update = os.time()
    for i = 1, 27 do
      do
        if airData.data.land.land[i] and airData.data.land.land[i].cd then
          local cd = math.max(0, airData.data.land.land[i].cd - os.time())
          do
            if cd > 0 then
              local timeLab = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
              if iconCd[i] then
                iconCd[i]:setString(timeLab)
              else
                if flagRefresh[i] == false then
                  flagRefresh[i] = true
                  iconCd[i]:setVisible(false)
                  local params = {sid = player.sid, pos = airData.data.land.land[i].pos}
                  tbl2string(params)
                  addWaitNet()
                  net:island_land(params, function(l_1_0)
                    delWaitNet()
                    tbl2string(l_1_0)
                    if boLand[i] then
                      local to = buildingType[cfgfloatland[l_1_0.land[1].id].type + 1]
                      boLand[l_1_0.land[1].pos]:removeChildFollowSlot("code_label")
                      animBg:removeChildFollowSlot(to.code_name .. l_1_0.land[1].pos)
                      iconCd[l_1_0.land[1].pos] = nil
                      boLand[l_1_0.land[1].pos] = nil
                      airData.data.land.land[l_1_0.land[1].pos] = l_1_0.land[1]
                      airData.data.land.land[l_1_0.land[1].pos].cd = l_1_0.land[1].cd + os.time()
                      upvalue_3584 = math.max(0, l_1_0.land[1].cd - os.time())
                      local timeLab = string.format("%02d:%02d:%02d", math.floor(cd / 3600), math.floor(cd % 3600 / 60), math.floor(cd % 60))
                      flagRefresh[l_1_0.land[1].pos] = false
                      boLand[l_1_0.land[1].pos] = json.create(to.jsonName)
                      boLand[l_1_0.land[1].pos].data = to
                      buildingObjs[l_1_0.land[1].pos + 2] = boLand[l_1_0.land[1].pos]
                      boLand[l_1_0.land[1].pos]:playAnimation("animation", -1)
                      animBg:addChildFollowSlot(to.code_name .. l_1_0.land[1].pos, boLand[l_1_0.land[1].pos])
                      iconCd[l_1_0.land[1].pos] = lbl.createFont2(16, timeLab, ccc3(165, 253, 71))
                      boLand[l_1_0.land[1].pos]:addChildFollowSlot("code_label", iconCd[l_1_0.land[1].pos])
                    end
                           end)
                end
              end
            end
          end
        end
      end
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  return layer
end

return ui


-- Command line was: E:\github\dhgametool\scripts\ui\summonspe\replacehero.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local player = require("data.player")
local bag = require("data.bag")
local net = require("net.netClient")
local cfghero = require("config.hero")
local cfgequip = require("config.equip")
local cfgdisplace = require("config.displace")
local heros = require("data.heros")
local selecthero = require("ui.summonspe.selecthero")
local createPopupPieceBatchSummonResult = function(l_1_0, l_1_1)
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
  local param = {id = l_1_0, lv = l_1_1.lv, showGroup = true, showStar = true, wake = nil, orangeFx = nil, petID = nil}
  local hero = img.createHeroHeadByParam(param)
  hero:setPosition(dialog.board:getContentSize().width / 2, 185)
  dialog.board:addChild(hero)
  backBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    dialog:removeFromParentAndCleanup()
   end)
  return dialog
end

ui.create = function(l_2_0)
  local layer = CCLayer:create()
  local bg_w = 846
  local bg_h = 396
  local layer = CCLayer:create()
  json.load(json.ui.zhihuan)
  local aniZhihuan = DHSkeletonAnimation:createWithKey(json.ui.zhihuan)
  aniZhihuan:scheduleUpdateLua()
  aniZhihuan:playAnimation("1loop", -1)
  aniZhihuan:setPosition(bg_w / 2, bg_h / 2 + 45)
  layer:addChild(aniZhihuan)
  local detailSprite = img.createUISprite(img.ui.btn_help)
  local detailBtn = SpineMenuItem:create(json.ui.button, detailSprite)
  detailBtn:setPosition(bg_w - 45, bg_h - 40)
  local detailMenu = CCMenu:create()
  detailMenu:setPosition(0, 0)
  layer:addChild(detailMenu, 20)
  detailMenu:addChild(detailBtn)
  detailBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    layer:getParent():getParent():getParent():getParent():addChild(require("ui.help").create(i18n.global.help_summon_replace.string), 1000)
   end)
  local pleaseLab = lbl.createMixFont1(16, i18n.global.space_summon_please.string, ccc3(255, 246, 223))
  pleaseLab:setPosition(bg_w / 2, bg_h - 40)
  layer:addChild(pleaseLab)
  local lefenter = img.createUISprite(img.ui.summontree_click)
  local lefenterbtn = SpineMenuItem:create(json.ui.button, lefenter)
  lefenterbtn:setPosition(CCPoint(265, 200))
  local lefentermenu = CCMenu:createWithItem(lefenterbtn)
  lefentermenu:setPosition(CCPoint(0, 0))
  layer:addChild(lefentermenu, 100)
  local change = img.createLogin9Sprite(img.login.button_9_gold)
  change:setPreferredSize(CCSizeMake(172, 60))
  local cgicon = img.createItemIcon2(ITEM_ID_SP_REPLACE)
  cgicon:setScale(0.9)
  cgicon:setPosition(CCPoint(30, change:getContentSize().height / 2 + 2))
  change:addChild(cgicon)
  local cgcountLable = lbl.createFont2(16, "", ccc3(255, 246, 223))
  cgcountLable:setPosition(CCPoint(cgicon:getContentSize().width / 2, 5))
  cgicon:addChild(cgcountLable)
  local changeLabel = lbl.createFont1(18, i18n.global.space_summon_replace.string, ccc3(115, 59, 5))
  changeLabel:setPosition(change:getContentSize().width * 3 / 5, change:getContentSize().height / 2)
  change:addChild(changeLabel)
  local changebtn = SpineMenuItem:create(json.ui.button, change)
  changebtn:setPosition(CCPoint(bg_w / 2, 55))
  changebtn:setVisible(false)
  local changemenu = CCMenu:createWithItem(changebtn)
  changemenu:setPosition(CCPoint(0, 0))
  layer:addChild(changemenu, 100)
  local cancel = img.createLogin9Sprite(img.login.button_9_gold)
  cancel:setPreferredSize(CCSizeMake(158, 58))
  local cancelLabel = lbl.createFont1(18, i18n.global.dialog_button_cancel.string, ccc3(115, 59, 5))
  cancelLabel:setPosition(cancel:getContentSize().width / 2, cancel:getContentSize().height / 2)
  cancel:addChild(cancelLabel)
  local cancelbtn = SpineMenuItem:create(json.ui.button, cancel)
  cancelbtn:setPosition(CCPoint(332, 53))
  cancelbtn:setVisible(false)
  local cancelmenu = CCMenu:createWithItem(cancelbtn)
  cancelmenu:setPosition(CCPoint(0, 0))
  layer:addChild(cancelmenu, 100)
  local ok = img.createUI9Sprite(img.ui.btn_7)
  ok:setPreferredSize(CCSizeMake(158, 58))
  local okLabel = lbl.createFont1(18, i18n.global.crystal_btn_save.string, ccc3(29, 103, 0))
  okLabel:setPosition(ok:getContentSize().width / 2, ok:getContentSize().height / 2)
  ok:addChild(okLabel)
  local okbtn = SpineMenuItem:create(json.ui.button, ok)
  okbtn:setPosition(CCPoint(bg_w - 317 - 15, 53))
  okbtn:setVisible(false)
  local okmenu = CCMenu:createWithItem(okbtn)
  okmenu:setPosition(CCPoint(0, 0))
  layer:addChild(okmenu, 100)
  local heroinfoLayer, lefheroinfo, rigid, uphero, heroBody = nil, nil, nil, nil, nil
  local upcount = function(l_2_0, l_2_1)
    for i = 1, #cfgdisplace do
      if cfgdisplace[i].group == l_2_0 and cfgdisplace[i].qlt == l_2_1 then
        return cfgdisplace[i].cost
      end
    end
    return 0
   end
  local createherolayer = function(l_3_0, l_3_1)
    local herolayer = CCLayer:create()
    changebtn:setEnabled(true)
    local heroName = lbl.createFont2(14, i18n.hero[l_3_0.id].heroName)
    heroName:setPosition(270, 342)
    herolayer:addChild(heroName)
    local herogroup = img.createUISprite(img.ui.herolist_group_" .. cfghero[l_3_0.id].grou)
    herogroup:setScale(0.55)
    herogroup:setPosition(heroName:boundingBox():getMinX() - 30, heroName:getPositionY())
    herolayer:addChild(herogroup)
    local heroLv = lbl.createFont2(14, string.format("Lv: %d", l_3_0.lv))
    heroLv:setPosition(270, 300)
    herolayer:addChild(heroLv)
    local star = cfghero[l_3_0.id].qlt
    local baseX = 225
    for i = 1, star do
      local starIcon = img.createUISprite(img.ui.star)
      starIcon:setScale(0.5)
      starIcon:setPosition(baseX + 24 * (i - 1), 320)
      herolayer:addChild(starIcon)
    end
    local righeroName = nil
    local riginfo = clone(l_3_0)
    do
      riginfo.id = l_3_1
      if l_3_1 then
        righeroName = lbl.createFont2(14, i18n.hero[l_3_1].heroName)
        local btnDetailSprite = img.createUISprite(img.ui.fight_hurts)
        local btnDetail = SpineMenuItem:create(json.ui.button, btnDetailSprite)
        btnDetail:setPosition(bg_w - 170, 280)
        local menuDetail = CCMenu:createWithItem(btnDetail)
        menuDetail:setPosition(0, 0)
        herolayer:addChild(menuDetail)
        btnDetail:registerScriptTapHandler(function()
          audio.play(audio.button)
          local herotips = require("ui.tips.hero")
          local tips = require("ui.tips.hero").create(righeroid)
          layer:getParent():getParent():getParent():getParent():addChild(tips, 1001)
            end)
      else
        righeroName = lbl.createMixFont1(14, "????")
      end
      righeroName:setPosition(bg_w - 225 - 45, 342)
      herolayer:addChild(righeroName)
      local righerogroup = img.createUISprite(img.ui.herolist_group_" .. cfghero[l_3_0.id].grou)
      righerogroup:setScale(0.55)
      righerogroup:setPosition(righeroName:boundingBox():getMinX() - 30, righeroName:getPositionY())
      herolayer:addChild(righerogroup)
      local righeroLv = lbl.createFont2(14, string.format("Lv: %d", l_3_0.lv))
      righeroLv:setPosition(bg_w - 225 - 45, 300)
      herolayer:addChild(righeroLv)
      local rigstar = cfghero[l_3_0.id].qlt
      local rigbaseX = bg_w - 262 - 45
      for i = 1, rigstar do
        local starIcon = img.createUISprite(img.ui.star)
        starIcon:setScale(0.5)
        starIcon:setPosition(rigbaseX + 24 * (i - 1), 320)
        herolayer:addChild(starIcon)
      end
      if l_3_1 == nil then
        local clickenter = img.createUISprite(img.ui.summontree_click)
        local clickenterbtn = SpineMenuItem:create(json.ui.button, clickenter)
        clickenterbtn:setPosition(CCPoint(265, 200))
        local clickentermenu = CCMenu:createWithItem(clickenterbtn)
        clickentermenu:setPosition(CCPoint(0, 0))
        herolayer:addChild(clickentermenu, 100)
        clickenterbtn:registerScriptTapHandler(function()
          disableObjAWhile(clickenterbtn)
          audio.play(audio.button)
          local selectherolayer = nil
          selectherolayer = selecthero.create(uphero)
          layer:getParent():getParent():getParent():getParent():addChild(selectherolayer, 1000)
          local ban = CCLayer:create()
          ban:setTouchEnabled(true)
          ban:setTouchSwallowEnabled(true)
          layer:addChild(ban, 1000)
          schedule(layer, 1, function()
            ban:removeFromParent()
               end)
            end)
      end
      return herolayer
    end
   end
  uphero = function(l_4_0, l_4_1)
    if heroinfoLayer then
      heroinfoLayer:removeFromParent()
      heroinfoLayer = nil
    end
    if l_4_0 == nil then
      if heroBody then
        heroBody:removeFromParent()
        upvalue_512 = nil
      end
      aniZhihuan:playAnimation("1loop", -1)
      lefenterbtn:setVisible(true)
      pleaseLab:setVisible(true)
      changebtn:setVisible(false)
      cancelbtn:setVisible(false)
      okbtn:setVisible(false)
      return 
    end
    upvalue_4096 = l_4_0
    if l_4_1 == nil then
      lefenterbtn:setVisible(false)
      pleaseLab:setVisible(false)
      changebtn:setVisible(true)
      cancelbtn:setVisible(false)
      okbtn:setVisible(false)
      aniZhihuan:playAnimation("2start")
      local ban = CCLayer:create()
      do
        ban:setTouchEnabled(true)
        ban:setTouchSwallowEnabled(true)
        layer:addChild(ban, 1000)
        if heroBody then
          heroBody:removeFromParent()
          upvalue_512 = nil
        end
        schedule(layer, 0.2, function()
          if getHeroSkin(lefhero.hid) then
            upvalue_512 = json.createSpineHeroSkin(getHeroSkin(lefhero.hid))
          else
            upvalue_512 = json.createSpineHero(lefhero.id)
          end
          heroBody:setScale(0.5)
          heroBody:setPosition(268, 114)
          layer:addChild(heroBody, 1)
          cgcountLable:setString(string.format("%d", upcount(cfghero[lefheroinfo.id].group, cfghero[lefheroinfo.id].qlt)))
            end)
        schedule(layer, 1, function()
          aniZhihuan:playAnimation("2loop", -1)
          ban:removeFromParent()
          upvalue_1024 = createherolayer(lefhero)
          layer:addChild(heroinfoLayer)
            end)
      end
    end
    if l_4_1 then
      aniZhihuan:playAnimation("3start")
      changebtn:setVisible(false)
      cancelbtn:setVisible(true)
      okbtn:setVisible(true)
      local shadowicon = json.createSpineHero(l_4_1)
      shadowicon:setScale(0.5)
      shadowicon:setAnchorPoint(0.5, 0.5)
      aniZhihuan:addChildFollowSlot("code_hero2", shadowicon)
      local ban = CCLayer:create()
      ban:setTouchEnabled(true)
      ban:setTouchSwallowEnabled(true)
      layer:addChild(ban, 1000)
      schedule(layer, 1, function()
        aniZhihuan:playAnimation("3loop", -1)
        ban:removeFromParent()
        upvalue_1024 = createherolayer(lefhero, righeroid)
        layer:addChild(heroinfoLayer)
         end)
    end
   end
  lefenterbtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local selectherolayer = nil
    selectherolayer = selecthero.create(uphero)
    layer:getParent():getParent():getParent():getParent():addChild(selectherolayer, 1000)
   end)
  changebtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local summonNum = 0
    if bag.items.find(ITEM_ID_SP_REPLACE) then
      summonNum = bag.items.find(ITEM_ID_SP_REPLACE).num
    end
    if summonNum < upcount(cfghero[lefheroinfo.id].group, cfghero[lefheroinfo.id].qlt) then
      showToast(i18n.global.space_summon_no_replace.string)
      return 
    end
    local params = {}
    params.sid = player.sid
    params.hid = lefheroinfo.hid
    addWaitNet()
    net:transform_hero(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status < 0 then
        showToast("status:" .. l_1_0.status)
        return 
      end
      mainlayer.replaceFlag = true
      uphero(lefheroinfo, l_1_0.hero_id)
      upvalue_1536 = l_1_0.hero_id
      bag.items.sub({id = ITEM_ID_SP_REPLACE, num = upcount(cfghero[lefheroinfo.id].group, cfghero[lefheroinfo.id].qlt)})
      end)
   end)
  cancelbtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local params = {}
    params.sid = player.sid
    params.type = 0
    addWaitNet()
    net:transform_ok(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status < 0 then
        showToast("status:" .. l_1_0.status)
        return 
      end
      mainlayer.replaceFlag = false
      uphero(lefheroinfo)
      end)
   end)
  okbtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local params = {}
    params.sid = player.sid
    params.type = 1
    addWaitNet()
    net:transform_ok(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status < 0 then
        showToast("status:" .. l_1_0.status)
        return 
      end
      local heroData = heros.find(lefheroinfo.hid)
      for _,v in ipairs(heroData.equips) do
        if cfgequip[v].pos == EQUIP_POS_SKIN then
          bag.equips.returnbag({id = getHeroSkin(lefheroinfo.hid), num = 1})
          table.remove(heroData.equips, _)
        end
      end
      mainlayer.replaceFlag = false
      heros.changeID(lefheroinfo.hid, rigid)
      uphero()
      local reward = createPopupPieceBatchSummonResult(rigid, lefheroinfo)
      layer:getParent():getParent():getParent():getParent():addChild(reward, 1000)
      end)
   end)
  return layer
end

return ui


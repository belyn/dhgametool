-- Command line was: E:\github\dhgametool\scripts\ui\summonspe\main.lua 

local ui = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local player = require("data.player")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local dialog = require("ui.dialog")
local net = require("net.netClient")
local bag = require("data.bag")
ui.create = function()
  local layer = CCLayer:create()
  img.load(img.packedOthers.ui_summontree)
  img.load(img.packedOthers.ui_summontree_bg)
  img.load(img.packedOthers.spine_ui_shengmingzhishu)
  img.load(img.packedOthers.spine_ui_zhihuan)
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  layer.replaceFlag = false
  local bg = img.createUI9Sprite(img.ui.dialog_2)
  bg:setPreferredSize(CCSizeMake(898, 500))
  bg:setScale(view.minScale)
  bg:setPosition(CCPoint(view.midX, view.midY - 30 * view.minScale))
  layer:addChild(bg)
  local bg_w = bg:getContentSize().width
  local bg_h = bg:getContentSize().height
  local container = CCSprite:create()
  container:setContentSize(CCSizeMake(374, 40))
  container:setScale(view.minScale)
  container:setAnchorPoint(CCPoint(0.5, 1))
  container:setPosition(scalep(480, 568))
  layer:addChild(container)
  layer.container = container
  local container_w = container:getContentSize().width
  local container_h = container:getContentSize().height
  local coin_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  coin_bg:setPreferredSize(CCSizeMake(174, 40))
  coin_bg:setAnchorPoint(CCPoint(1, 0.5))
  coin_bg:setPosition(CCPoint(container_w / 2 - 13, container_h / 2))
  container:addChild(coin_bg)
  local gem_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  gem_bg:setPreferredSize(CCSizeMake(174, 40))
  gem_bg:setAnchorPoint(CCPoint(0, 0.5))
  gem_bg:setPosition(CCPoint(container_w / 2 + 13, container_h / 2))
  container:addChild(gem_bg)
  local icon_coin = img.createItemIcon2(ITEM_ID_SP_SUMMON)
  icon_coin:setPosition(CCPoint(5, coin_bg:getContentSize().height / 2 + 2))
  coin_bg:addChild(icon_coin)
  local icon_gem = img.createItemIcon2(ITEM_ID_SP_REPLACE)
  icon_gem:setPosition(CCPoint(5, gem_bg:getContentSize().height / 2 + 2))
  gem_bg:addChild(icon_gem)
  local coin_num = 0
  if bag.items.find(ITEM_ID_SP_SUMMON) then
    coin_num = bag.items.find(ITEM_ID_SP_SUMMON).num
  end
  local lbl_coin = lbl.createFont2(16, num2KM(coin_num), ccc3(255, 246, 223))
  lbl_coin:setPosition(CCPoint(coin_bg:getContentSize().width / 2 - 10, coin_bg:getContentSize().height / 2 + 3))
  coin_bg:addChild(lbl_coin)
  lbl_coin.num = coin_num
  local gem_num = 0
  if bag.items.find(ITEM_ID_SP_REPLACE) then
    gem_num = bag.items.find(ITEM_ID_SP_REPLACE).num
  end
  local lbl_gem = lbl.createFont2(16, gem_num, ccc3(255, 246, 223))
  lbl_gem:setPosition(CCPoint(gem_bg:getContentSize().width / 2 - 10, gem_bg:getContentSize().height / 2 + 3))
  gem_bg:addChild(lbl_gem)
  lbl_gem.num = gem_num
  local updateLabels = function()
    local coinnum = 0
    if bag.items.find(ITEM_ID_SP_SUMMON) then
      coinnum = bag.items.find(ITEM_ID_SP_SUMMON).num
    end
    if lbl_coin.num ~= coinnum then
      lbl_coin:setString(num2KM(coinnum))
      lbl_coin.num = coinnum
    end
    local gemnum = 0
    if bag.items.find(ITEM_ID_SP_REPLACE) then
      gemnum = bag.items.find(ITEM_ID_SP_REPLACE).num
    end
    if lbl_gem.num ~= gemnum then
      lbl_gem:setString(gemnum)
      lbl_gem.num = gemnum
    end
   end
  local onUpdate = function(l_2_0)
    updateLabels()
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local createSureoff = function()
    local params = {}
    params.btn_count = 0
    params.body = string.format(i18n.global.replacehero_close_sure.string, 20)
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
    btnYes:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      backEvent()
      end)
    btnNo:registerScriptTapHandler(function()
      dialoglayer:removeFromParentAndCleanup(true)
      audio.play(audio.button)
      end)
    local diabackEvent = function()
      diadialoglayer:removeFromParentAndCleanup(true)
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
    return dialoglayer
   end
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(bg_w - 25, bg_h - 28))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_close_menu, 100)
  btn_close:registerScriptTapHandler(function()
    if layer.replaceFlag == false then
      backEvent()
    else
      local dialog = createSureoff()
      layer:addChild(dialog, 300)
    end
   end)
  local board = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  board:setPreferredSize(CCSizeMake(846, 396))
  board:setAnchorPoint(CCPoint(0.5, 0))
  board:setPosition(CCPoint(bg_w / 2, 34))
  bg:addChild(board)
  layer.board = board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  local upicon1 = img.createUISprite(img.ui.summontree_icon1)
  upicon1:setAnchorPoint(0, 1)
  upicon1:setPosition(-6, board_h + 3)
  board:addChild(upicon1, 99)
  local upicon2 = img.createUISprite(img.ui.summontree_icon1)
  upicon2:setAnchorPoint(1, 1)
  upicon2:setPosition(board_w + 6, board_h + 3)
  upicon2:setFlipX(true)
  board:addChild(upicon2, 99)
  local downicon1 = img.createUISprite(img.ui.summontree_icon2)
  downicon1:setAnchorPoint(0, 0)
  downicon1:setPosition(3, -5)
  board:addChild(downicon1, 99)
  local downicon2 = img.createUISprite(img.ui.summontree_icon2)
  downicon2:setAnchorPoint(1, 0)
  downicon2:setPosition(board_w - 3, -5)
  downicon2:setFlipX(true)
  board:addChild(downicon2, 99)
  local nodeNormal = cc.Node:create()
  nodeNormal:setPosition(CCPoint(0, 0))
  nodeNormal:setVisible(false)
  board:addChild(nodeNormal, 1)
  local noderphero = cc.Node:create()
  noderphero:setPosition(CCPoint(0, 0))
  noderphero:setVisible(false)
  board:addChild(noderphero, 1)
  local btn_normal0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
  btn_normal0:setPreferredSize(CCSizeMake(240, 46))
  local btn_normal_sel = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_normal_sel:setPreferredSize(CCSizeMake(240, 46))
  btn_normal_sel:setPosition(CCPoint(btn_normal0:getContentSize().width / 2, btn_normal0:getContentSize().height / 2))
  btn_normal0:addChild(btn_normal_sel)
  local lbl_normal = lbl.createFont1(18, i18n.global.space_summon_leteg.string, ccc3(115, 59, 5))
  lbl_normal:setPosition(CCPoint(btn_normal0:getContentSize().width / 2, btn_normal0:getContentSize().height / 2))
  btn_normal0:addChild(lbl_normal)
  local btn_normal = SpineMenuItem:create(json.ui.button, btn_normal0)
  btn_normal:setPosition(CCPoint(bg_w / 2 - 125, bg_h - 38))
  local btn_normal_menu = CCMenu:createWithItem(btn_normal)
  btn_normal_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_normal_menu)
  local btn_rphero0 = img.createLogin9Sprite(img.login.button_9_small_mwhite)
  btn_rphero0:setPreferredSize(CCSizeMake(240, 46))
  local btn_rphero_sel = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_rphero_sel:setPreferredSize(CCSizeMake(240, 46))
  btn_rphero_sel:setPosition(CCPoint(btn_rphero0:getContentSize().width / 2, btn_rphero0:getContentSize().height / 2))
  btn_rphero0:addChild(btn_rphero_sel)
  local lbl_rphero = lbl.createFont1(18, i18n.global.space_summon_riteg.string, ccc3(115, 59, 5))
  lbl_rphero:setPosition(CCPoint(btn_rphero0:getContentSize().width / 2, btn_rphero0:getContentSize().height / 2))
  btn_rphero0:addChild(lbl_rphero)
  local btn_rphero = SpineMenuItem:create(json.ui.button, btn_rphero0)
  btn_rphero:setPosition(CCPoint(bg_w / 2 + 125, bg_h - 38))
  local btn_rphero_menu = CCMenu:createWithItem(btn_rphero)
  btn_rphero_menu:setPosition(CCPoint(0, 0))
  bg:addChild(btn_rphero_menu)
  btn_normal_sel:setVisible(false)
  btn_rphero_sel:setVisible(false)
  if nodeNormal then
    local spsummon = require("ui.summonspe.spsummon")
    nodeNormal:addChild(spsummon.create())
  end
  if noderphero then
    local replacehero = require("ui.summonspe.replacehero")
    noderphero:addChild(replacehero.create(layer))
  end
  local onNormal = function()
    nodeNormal:setVisible(true)
    noderphero:setVisible(false)
    btn_normal_sel:setVisible(true)
    btn_rphero_sel:setVisible(false)
    btn_normal:setEnabled(false)
    btn_rphero:setEnabled(true)
   end
  btn_normal:registerScriptTapHandler(function()
    audio.play(audio.button)
    onNormal()
   end)
  local onrphero = function()
    nodeNormal:setVisible(false)
    noderphero:setVisible(true)
    btn_normal_sel:setVisible(false)
    btn_rphero_sel:setVisible(true)
    btn_normal:setEnabled(true)
    btn_rphero:setEnabled(false)
   end
  btn_rphero:registerScriptTapHandler(function()
    audio.play(audio.button)
    onrphero()
   end)
  onNormal()
  addBackEvent(layer)
  layer.onAndroidBack = function()
    backEvent()
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_13_0)
    if l_13_0 == "enter" then
      onEnter()
    elseif l_13_0 == "exit" then
      onExit()
    elseif l_13_0 == "cleanup" then
      img.unload(img.packedOthers.spine_ui_zhihuan)
      img.unload(img.packedOthers.spine_ui_shengmingzhishu)
      img.unload(img.packedOthers.ui_summontree)
      img.unload(img.packedOthers.ui_summontree_bg)
    end
   end)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  return layer
end

return ui


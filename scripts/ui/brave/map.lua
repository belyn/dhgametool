-- Command line was: E:\github\dhgametool\scripts\ui\brave\map.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local net = require("net.netClient")
local heros = require("data.heros")
local cfghero = require("config.hero")
local player = require("data.player")
local cfgbrave = require("config.brave")
local databrave = require("data.brave")
local particle = require("res.particle")
ui.create = function()
  local layer = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  local btnBackSprite = img.createUISprite(img.ui.back)
  local btnBack = SpineMenuItem:create(json.ui.button, btnBackSprite)
  btnBack:setScale(view.minScale)
  btnBack:setPosition(scalep(35, 546))
  local menuBack = CCMenu:createWithItem(btnBack)
  menuBack:setPosition(0, 0)
  layer:addChild(menuBack, 10)
  layer.back = btnBack
  btnBack:registerScriptTapHandler(function()
    replaceScene(require("ui.town.main").create())
   end)
  autoLayoutShift(btnBack)
  img.load(img.packedOthers.ui_brave)
  img.load(img.packedOthers.ui_brave_bg)
  img.load(img.packedOthers.spine_ui_yuanzheng_jiemian)
  img.load(img.packedOthers.spine_ui_yuanzheng_baoxiang)
  local animBg = json.create(json.ui.yuanzheng_jiemian)
  animBg:setScale(view.minScale)
  animBg:setPosition(view.midX, view.midY)
  animBg:playAnimation("animation", -1)
  layer:addChild(animBg)
  local bgg = img.createUISprite(img.ui.brave_bg)
  animBg:addChildFollowSlot("code_bg", bgg)
  local bg = CCSprite:create()
  bg:setContentSize(CCSizeMake(960, 576))
  bg:setPosition(CCPoint(bgg:getContentSize().width / 2, bgg:getContentSize().height / 2))
  bgg:addChild(bg)
  local rewardlevel = {3, 6, 9, 12, 15}
  local judgeboxstatus = function(l_2_0)
    print("*****", databrave.stage, rewardlevel[l_2_0])
    if rewardlevel[l_2_0] < databrave.stage then
      if databrave.nodes then
        for i = 1,  databrave.nodes do
          if databrave.nodes[i] == rewardlevel[l_2_0] then
            return "3"
          end
        end
        return "2"
      else
        return "2"
      end
    else
      return "1"
    end
   end
  local judge = function()
    for i = 1, 5 do
      if judgeboxstatus(i) == "2" then
        return true
      end
    end
    return false
   end
  local grid = img.createUISprite(img.ui.brave_level_battalbo)
  local levelreBtn = SpineMenuItem:create(json.ui.button, grid)
  levelreBtn:setPosition(912, 47)
  local lrewardMenu = CCMenu:createWithItem(levelreBtn)
  lrewardMenu:setPosition(0, 0)
  bg:addChild(lrewardMenu)
  autoLayoutShift(levelreBtn)
  json.load(json.ui.yuanzheng_baoxiang)
  local bravebox = DHSkeletonAnimation:createWithKey(json.ui.yuanzheng_baoxiang)
  bravebox:scheduleUpdateLua()
  bravebox:playAnimation("1")
  bravebox:setPosition(grid:getContentSize().width / 2, grid:getContentSize().height / 2)
  grid:addChild(bravebox, 1000)
  if judge() then
    levelreBtn:setEnabled(true)
    bravebox:playAnimation("2", -1)
  else
    bravebox:playAnimation("1")
  end
  local refreshBox = function()
    bravebox:stopAnimation()
    bravebox:playAnimation("1")
   end
  levelreBtn:registerScriptTapHandler(function()
    audio.play(audio.button)
    local levelreward = require("ui.brave.levelrewards")
    layer:addChild(levelreward.create(refreshBox), 10000)
   end)
  local path = json.create(json.ui.yuanzheng_path)
  path:setPosition(0, 0)
  if databrave.stage > 1 then
    if databrave.stage < cfgbrave[databrave.id].num then
      path:playAnimation(databrave.stage)
    else
      path:playAnimation(cfgbrave[databrave.id].num)
      path:update(1000)
    end
  end
  animBg:addChild(path)
  for i = 1, math.min(databrave.stage, cfgbrave[databrave.id].num) do
    do
      local btnStartSprite = nil
      local les = 20
      if i == cfgbrave[databrave.id].num then
        les = 38
        if databrave.stage <= cfgbrave[databrave.id].num then
          btnStartSprite = img.createUISprite(img.ui.brave_fort_2)
        else
          btnStartSprite = img.createUISprite(img.ui.brave_fort3)
        end
      else
        if databrave.stage <= i then
          btnStartSprite = img.createUISprite(img.ui.brave_fort_1)
        else
          btnStartSprite = img.createUISprite(img.ui.brave_fort_0)
        end
      end
      local labStart = lbl.createFont2(16, i)
      labStart:setPosition(btnStartSprite:getContentSize().width / 2, btnStartSprite:getContentSize().height - les)
      btnStartSprite:addChild(labStart)
      local btnStart = SpineMenuItem:create(json.ui.button, btnStartSprite)
      local menuStart = CCMenu:createWithItem(btnStart)
      menuStart:setPosition(0, 0)
      btnStart:setPosition(0, 0)
      path:addChildFollowSlot("code_" .. i, menuStart)
      btnStart:registerScriptTapHandler(function()
        if databrave.enemys[i] then
          layer:addChild(require("ui.brave.gateinfo").create(i), 1000)
        else
          local params = {sid = player.sid, stage = i}
          addWaitNet()
          net:brave_pull(params, function(l_1_0)
            delWaitNet()
            if l_1_0.enemy then
              databrave.enemys[i] = l_1_0.enemy
              layer:addChild(require("ui.brave.gateinfo").create(i), 1000)
            end
               end)
        end
         end)
    end
  end
  local shopBg = img.createUISprite(img.ui.brave_shopbg)
  shopBg:setScale(view.minScale)
  shopBg:setAnchorPoint(CCPoint(1, 1))
  shopBg:setPosition(scalep(980, 582))
  layer:addChild(shopBg)
  autoLayoutShift(shopBg)
  local particle_scale = view.minScale
  local particle_shop = particle.create("ui_shop")
  particle_shop:setScale(particle_scale)
  particle_shop:setPosition(scalep(910, 530))
  layer:addChild(particle_shop, 100)
  autoLayoutShift(particle_shop)
  local btnShop0 = img.createUISprite(img.ui.brave_store_icon)
  local btnShop = HHMenuItem:createWithScale(btnShop0, 1)
  btnShop:setPosition(CCPoint(shopBg:getContentSize().width - 70, shopBg:getContentSize().height - 51))
  local btnShopMenu = CCMenu:createWithItem(btnShop)
  btnShopMenu:setPosition(CCPoint(0, 0))
  shopBg:addChild(btnShopMenu)
  btnShop:registerScriptTapHandler(function()
    audio.play(audio.button)
    local shop = require("ui.braveshop.main")
    layer:addChild(shop.create(), 1000)
   end)
  addBackEvent(layer)
  layer.onAndroidBack = function()
    replaceScene(require("ui.town.main").create())
   end
  local onEnter = function()
    print("onEnter")
    layer.notifyParentLock()
   end
  local onExit = function()
    layer.notifyParentUnlock()
   end
  layer:registerScriptHandler(function(l_11_0)
    if l_11_0 == "enter" then
      onEnter()
    elseif l_11_0 == "exit" then
      onExit()
    elseif l_11_0 == "cleanup" then
      img.unload(img.packedOthers.ui_brave)
      img.unload(img.packedOthers.ui_brave_bg)
      img.unload(img.packedOthers.spine_ui_yuanzheng_jiemian)
    end
   end)
  return layer
end

return ui


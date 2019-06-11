-- Command line was: E:\github\dhgametool\scripts\ui\airisland\itembar.lua 

local bar = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local bag = require("data.bag")
local midasdata = require("data.midas")
local midas = require("ui.midas.main")
local gemshop = require("ui.shop.main")
local airData = require("data.airisland")
local cfgHomeworld = require("config.homeworld")
bar.create = function()
  local layer = CCLayer:create()
  local container = CCSprite:create()
  container:setContentSize(CCSizeMake(374, 40))
  container:setScale(view.minScale)
  container:setAnchorPoint(CCPoint(0.5, 1))
  container:setPosition(scalep(480, 568))
  layer:addChild(container)
  layer.container = container
  autoLayoutShift(container)
  local container_w = container:getContentSize().width
  local container_h = container:getContentSize().height
  local coin_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  coin_bg:setPreferredSize(CCSizeMake(174, 40))
  coin_bg:setAnchorPoint(CCPoint(1, 0.5))
  coin_bg:setPosition(CCPoint(container_w / 2 - 198, container_h / 2))
  container:addChild(coin_bg)
  local gem_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  gem_bg:setPreferredSize(CCSizeMake(174, 40))
  gem_bg:setAnchorPoint(CCPoint(1, 0.5))
  gem_bg:setPosition(CCPoint(container_w / 2 - 2, container_h / 2))
  container:addChild(gem_bg)
  local enegy_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  enegy_bg:setPreferredSize(CCSizeMake(174, 40))
  enegy_bg:setAnchorPoint(CCPoint(1, 0.5))
  enegy_bg:setPosition(CCPoint(container_w / 2 + 192, container_h / 2))
  container:addChild(enegy_bg)
  local bstone_bg = img.createUI9Sprite(img.ui.main_coin_bg)
  bstone_bg:setPreferredSize(CCSizeMake(174, 40))
  bstone_bg:setAnchorPoint(CCPoint(1, 0.5))
  bstone_bg:setPosition(CCPoint(container_w / 2 + 388, container_h / 2))
  container:addChild(bstone_bg)
  local icon_coin = img.createItemIcon2(ITEM_ID_COIN)
  icon_coin:setPosition(CCPoint(5, coin_bg:getContentSize().height / 2 + 2))
  coin_bg:addChild(icon_coin)
  local icon_gem = img.createItemIcon2(ITEM_ID_GEM)
  icon_gem:setPosition(CCPoint(5, gem_bg:getContentSize().height / 2 + 2))
  gem_bg:addChild(icon_gem)
  local icon_enegy = img.createItemIconForId(4302)
  icon_enegy:setPosition(CCPoint(5, enegy_bg:getContentSize().height / 2 + 2))
  enegy_bg:addChild(icon_enegy)
  local icon_bstone = img.createItemIcon2(ITEM_ID_BUILD_STONE)
  icon_bstone:setPosition(CCPoint(5, bstone_bg:getContentSize().height / 2 + 2))
  bstone_bg:addChild(icon_bstone)
  local reddot_offset = 5
  local btn_coin0 = img.createUISprite(img.ui.main_icon_plus)
  addRedDot(btn_coin0, {px = btn_coin0:getContentSize().width - reddot_offset, py = btn_coin0:getContentSize().height - reddot_offset})
  delRedDot(btn_coin0)
  local btn_coin = HHMenuItem:create(btn_coin0)
  btn_coin:setPosition(CCPoint(coin_bg:getContentSize().width - 18, coin_bg:getContentSize().height / 2 + 2))
  local btn_coin_menu = CCMenu:createWithItem(btn_coin)
  btn_coin_menu:setPosition(CCPoint(0, 0))
  coin_bg:addChild(btn_coin_menu)
  btn_coin:registerScriptTapHandler(function()
    audio.play(audio.midas)
    local midasdlg = midas.create()
    layer:getParent():addChild(midasdlg, 1001)
   end)
  local btn_gem0 = img.createUISprite(img.ui.main_icon_plus)
  local btn_gem = HHMenuItem:create(btn_gem0)
  btn_gem:setPosition(CCPoint(gem_bg:getContentSize().width - 18, gem_bg:getContentSize().height / 2 + 2))
  local btn_gem_menu = CCMenu:createWithItem(btn_gem)
  btn_gem_menu:setPosition(CCPoint(0, 0))
  gem_bg:addChild(btn_gem_menu)
  btn_gem:registerScriptTapHandler(function()
    audio.play(audio.button)
    local gemShop = gemshop.create()
    layer:getParent():addChild(gemShop, 1001)
   end)
  local btn_enegy0 = img.createUISprite(img.ui.main_icon_plus)
  local btn_enegy = HHMenuItem:create(btn_enegy0)
  btn_enegy:setPosition(CCPoint(enegy_bg:getContentSize().width - 18, enegy_bg:getContentSize().height / 2 + 2))
  local btn_enegy_menu = CCMenu:createWithItem(btn_enegy)
  btn_enegy_menu:setPosition(CCPoint(0, 0))
  enegy_bg:addChild(btn_enegy_menu)
  btn_enegy:registerScriptTapHandler(function()
    audio.play(audio.button)
    local buy = require("ui.airisland.enegybuy")
    local enegybuy = buy.create()
    layer:getParent():addChild(enegybuy, 1001)
   end)
  local coin_num = bag.coin()
  local lbl_coin = lbl.createFont2(16, num2KM(coin_num), ccc3(255, 246, 223))
  lbl_coin:setPosition(CCPoint(coin_bg:getContentSize().width / 2 - 10, coin_bg:getContentSize().height / 2 + 3))
  coin_bg:addChild(lbl_coin)
  lbl_coin.num = coin_num
  local gem_num = bag.gem()
  local lbl_gem = lbl.createFont2(16, gem_num, ccc3(255, 246, 223))
  lbl_gem:setPosition(CCPoint(gem_bg:getContentSize().width / 2 - 10, gem_bg:getContentSize().height / 2 + 3))
  gem_bg:addChild(lbl_gem)
  lbl_gem.num = gem_num
  local enegy_num = airData.data.vit.vit
  local enegy_limit = cfgHomeworld[airData.data.id].xMax
  local lbl_enegy = lbl.createFont2(16, string.format("%d/%d", enegy_num, enegy_limit), ccc3(255, 246, 223))
  lbl_enegy:setPosition(CCPoint(gem_bg:getContentSize().width / 2 - 10, enegy_bg:getContentSize().height / 2 + 3))
  enegy_bg:addChild(lbl_enegy)
  lbl_enegy.num = enegy_num
  lbl_enegy.limit = enegy_limit
  local bstone_num = bag.items.find(ITEM_ID_BUILD_STONE).num
  local lbl_bstone = lbl.createFont2(16, bstone_num, ccc3(255, 246, 223))
  lbl_bstone:setPosition(CCPoint(bstone_bg:getContentSize().width / 2 - 10, bstone_bg:getContentSize().height / 2 + 3))
  bstone_bg:addChild(lbl_bstone)
  lbl_bstone.num = bstone_num
  local updateLabels = function()
    local coinnum = bag.coin()
    if lbl_coin.num ~= coinnum then
      lbl_coin:setString(num2KM(coinnum))
      lbl_coin.num = coinnum
    end
    local gemnum = bag.gem()
    if lbl_gem.num ~= gemnum then
      lbl_gem:setString(gemnum)
      lbl_gem.num = gemnum
    end
    local enegynum = airData.data.vit.vit
    local enegylimit = cfgHomeworld[airData.data.id].xMax
    if lbl_enegy.num ~= enegynum or lbl_enegy.limit ~= enegylimit then
      lbl_enegy:setString(string.format("%d/%d", enegynum, enegylimit))
      lbl_enegy.num = enegynum
      lbl_enegy.limit = enegylimit
    end
    local bstonenum = bag.items.find(ITEM_ID_BUILD_STONE).num
    if lbl_bstone.num ~= bstonenum then
      lbl_bstone:setString(bstonenum)
      lbl_bstone.num = bstonenum
    end
   end
  local onUpdate = function(l_5_0)
    updateLabels()
    if midasdata.showRedDot() then
      addRedDot(btn_coin0, {px = btn_coin0:getContentSize().width - reddot_offset, py = btn_coin0:getContentSize().height - reddot_offset})
    else
      delRedDot(btn_coin0)
    end
   end
  layer:scheduleUpdateWithPriorityLua(onUpdate, 0)
  return layer
end

return bar


-- Command line was: E:\github\dhgametool\scripts\ui\tips\reward.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local i18n = require("res.i18n")
local net = require("net.netClient")
local player = require("data.player")
local bag = require("data.bag")
local cfgequip = require("config.equip")
local cfgitem = require("config.item")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
ui.create = function(l_1_0)
  local params = {}
  params.title = i18n.global.reward_will_get.string
  params.btn_count = 0
  local dialog = require("ui.dialog").create(params)
  local back = img.createLogin9Sprite(img.login.button_9_small_gold)
  back:setPreferredSize(CCSize(153, 50))
  local comfirlab = lbl.createFont1(18, i18n.global.summon_comfirm.string, lbl.buttonColor)
  comfirlab:setPosition(CCPoint(back:getContentSize().width / 2, back:getContentSize().height / 2))
  back:addChild(comfirlab)
  local backBtn = SpineMenuItem:create(json.ui.button, back)
  backBtn:setPosition(CCPoint(dialog.board:getContentSize().width / 2, 80))
  local menu = CCMenu:createWithItem(backBtn)
  menu:setPosition(0, 0)
  dialog.board:addChild(menu)
  backBtn:registerScriptTapHandler(function()
    dialog:removeFromParentAndCleanup()
   end)
  local items = {}
  if l_1_0.items then
    for i,v in ipairs(l_1_0.items) do
      do
        items[ items + 1] = {type = 1, id = v.id, num = v.num}
      end
    end
  end
  if l_1_0.equips then
    for i,v in ipairs(l_1_0.equips) do
      items[ items + 1] = {type = 2, id = v.id, num = v.num}
    end
  end
  local offset = dialog.board:getContentSize().width / 2 - 45 *  items + 4
  for i,v in ipairs(items) do
    local item = nil
    if v.type == 1 then
      item = img.createItem(v.id, v.num)
    else
      item = img.createEquip(v.id, v.num)
    end
    local btnItem = CCMenuItemSprite:create(item, nil)
    local menu = CCMenu:createWithItem(btnItem)
    menu:setPosition(0, 0)
    dialog.board:addChild(menu)
    btnItem:setAnchorPoint(ccp(0, 0.5))
    btnItem:setPosition(offset + 90 * (i - 1), 185)
    btnItem:registerScriptTapHandler(function()
      if v.type == 1 then
        local tips = require("ui.tips.item").createForShow(v)
        dialog:addChild(tips, 100)
      else
        local tips = require("ui.tips.equip").createById(v.id)
        dialog:addChild(tips, 100)
      end
      end)
  end
  return dialog
end

return ui


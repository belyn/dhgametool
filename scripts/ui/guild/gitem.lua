-- Command line was: E:\github\dhgametool\scripts\ui\guild\gitem.lua 

local gitem = {}
require("common.func")
require("common.const")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local audio = require("res.audio")
local cfgitem = require("config.item")
local cfgequip = require("config.equip")
local cfgguildexp = require("config.guildexp")
local player = require("data.player")
local gdata = require("data.guild")
local i18n = require("res.i18n")
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local dialog = require("ui.dialog")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local itembg = {0 = img.ui.botton_fram_3, 1 = img.ui.botton_fram_2}
gitem.createItem = function(l_1_0, l_1_1)
  if not l_1_1 then
    l_1_1 = 1
  end
  local item = img.createUI9Sprite(itembg[l_1_1 % 2])
  item:setPreferredSize(CCSizeMake(575, 88))
  local item_w = item:getContentSize().width
  local item_h = item:getContentSize().height
  local flag = img.createGFlag(l_1_0.logo)
  flag:setScale(0.7)
  flag:setPosition(CCPoint(48, item_h / 2))
  item:addChild(flag)
  local lbl_name = lbl.createFontTTF(20, l_1_0.name, ccc3(81, 39, 18))
  lbl_name:setAnchorPoint(CCPoint(0, 0))
  lbl_name:setPosition(CCPoint(91, 46))
  item:addChild(lbl_name)
  local icon_mem = img.createUISprite(img.ui.guild_icon_mem)
  icon_mem:setAnchorPoint(CCPoint(0, 0))
  icon_mem:setPosition(CCPoint(94, 22))
  item:addChild(icon_mem)
  local lbl_num = lbl.createFont1(16, l_1_0.members .. "/" .. gdata.maxMember(l_1_0.exp), ccc3(122, 83, 52))
  lbl_num:setAnchorPoint(CCPoint(0, 0))
  lbl_num:setPosition(CCPoint(120, 19))
  item:addChild(lbl_num)
  local lbl_lv_des = lbl.createFont1(14, i18n.global.guild_col_level.string, ccc3(160, 124, 96))
  lbl_lv_des:setPosition(CCPoint(322, 56))
  item:addChild(lbl_lv_des)
  local lbl_lv = lbl.createFont1(24, "" .. gdata.Lv(l_1_0.exp), ccc3(122, 83, 52))
  lbl_lv:setPosition(CCPoint(322, 34))
  item:addChild(lbl_lv)
  local btn_apply0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_apply0:setPreferredSize(CCSizeMake(140, 45))
  local lbl_apply = lbl.createFont1(18, i18n.global.guild_btn_apply.string, ccc3(115, 59, 5))
  lbl_apply:setPosition(CCPoint(btn_apply0:getContentSize().width / 2, btn_apply0:getContentSize().height / 2))
  btn_apply0:addChild(lbl_apply)
  local btn_apply = SpineMenuItem:create(json.ui.button, btn_apply0)
  btn_apply:setPosition(CCPoint(487, item_h / 2))
  local btn_apply_menu = CCMenu:createWithItem(btn_apply)
  btn_apply_menu:setPosition(CCPoint(0, 0))
  item:addChild(btn_apply_menu)
  btn_apply:registerScriptTapHandler(function()
    audio.play(audio.button)
    local params = {sid = player.sid, gid = guildObj.id}
    addWaitNet()
    netClient:guild_apply(params, function(l_1_0)
      delWaitNet()
      tbl2string(l_1_0)
      if l_1_0.status ~= 0 then
        showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
        return 
      end
      btn_apply:setEnabled(false)
      lbl_apply:setString(i18n.global.guild_applied.string)
      setShader(btn_apply, SHADER_GRAY, true)
      end)
   end)
  return item
end

return gitem


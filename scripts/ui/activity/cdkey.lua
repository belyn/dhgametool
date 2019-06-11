-- Command line was: E:\github\dhgametool\scripts\ui\activity\cdkey.lua 

local ui = {}
require("common.func")
local view = require("common.view")
local i18n = require("res.i18n")
local lbl = require("res.lbl")
local img = require("res.img")
local audio = require("res.audio")
local json = require("res.json")
local cfgactivity = require("config.activity")
local player = require("data.player")
local activityData = require("data.activity")
local NetClient = require("net.netClient")
local netClient = NetClient:getInstance()
local tipsequip = require("ui.tips.equip")
local tipsitem = require("ui.tips.item")
local IDS = activityData.IDS
local ItemType = {Item = 1, Equip = 2}
ui.create = function()
  local layer = CCLayer:create()
  local HMIDS = {25, 26}
  local act = activityData.getStatusById(IDS.CDKEY.ID)
  local toasts = {0 = "\229\133\145\230\141\162\230\136\144\229\138\159\239\188\140\232\175\183\229\137\141\229\190\128\233\130\174\228\187\182\233\162\134\229\143\150", -1 = "\229\133\145\230\141\162\231\160\129\228\184\141\229\173\152\229\156\168", -2 = "\232\175\165\229\133\145\230\141\162\231\160\129\229\183\178\231\187\143\232\162\171\228\189\191\231\148\168", -3 = "\232\175\165\229\133\145\230\141\162\231\160\129\229\183\178\231\187\143\232\191\135\230\156\159", -4 = "\229\144\140\228\184\128\231\167\141\231\177\187\229\158\139\231\154\132\231\164\188\229\140\133\231\160\129\229\144\140\228\184\128\228\184\170\231\142\169\229\174\182\229\143\170\232\131\189\233\162\134\229\143\150\228\184\128\230\172\161", -5 = "\232\191\152\230\156\170\232\190\190\229\136\176\233\162\134\229\143\150\230\151\182\233\151\180", -7 = "\232\175\165\231\177\187\231\164\188\229\140\133\231\160\129\229\176\154\230\156\170\230\155\180\230\150\176", -8 = "\232\174\190\231\189\174\229\133\145\230\141\162\231\160\129\231\138\182\230\128\129\229\164\177\232\180\165", unknown = "\230\156\170\231\159\165\233\148\153\232\175\175"}
  if isOnestore() then
    toasts = {0 = "\236\136\152\235\160\185\237\149\156 \236\149\132\236\157\180\237\133\156\236\157\128 \235\169\148\236\157\188\237\149\168\236\151\144\236\132\156 \237\153\149\236\157\184\234\176\128\235\138\165\237\149\169\235\139\136\235\139\164.", -1 = "\237\149\180\235\139\185 \236\191\160\237\143\176\236\157\128 \236\130\172\236\154\169\236\157\180 \235\182\136\234\176\128\235\138\165\237\149\169\235\139\136\235\139\164", -2 = "\236\157\180\235\175\184 \236\130\172\236\154\169\235\144\156 \236\191\160\237\143\176\236\158\133\235\139\136\235\139\164", -3 = "\236\156\160\237\154\168\234\184\176\234\176\132\236\157\180 \236\167\128\235\130\156 \236\191\160\237\143\176\236\158\133\235\139\136\235\139\164", -4 = "\235\143\153\236\157\188\237\149\156 \236\156\160\237\152\149\236\157\152 \236\132\160\235\172\188 \237\140\168\237\130\164\236\167\128 \236\189\148\235\147\156\235\138\148 \235\143\153\236\157\188\237\149\156 \236\156\160\236\160\128\234\176\128 \237\149\156 \235\178\136\235\167\140 \236\136\152\235\160\185 \234\176\128\235\138\165\237\149\169\235\139\136\235\139\164", -5 = "\236\151\133\235\141\176\236\157\180\237\138\184 \237\155\132 \235\139\164\236\139\156 \234\181\144\237\153\152\237\149\180\236\163\188\236\132\184\236\154\148", -7 = "\237\140\168\237\130\164\236\167\128 \236\189\148\235\147\156\234\176\128 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164", -8 = "\237\153\156\236\132\177\237\153\148 \236\189\148\235\147\156 \236\131\129\237\131\156 \236\132\164\236\160\149 \236\139\164\237\140\168", unknown = "\236\139\156\236\138\164\237\133\156 \236\151\144\235\159\172"}
  end
  local board = CCSprite:create()
  board:setContentSize(CCSizeMake(576, 436))
  board:setScale(view.minScale)
  board:setAnchorPoint(CCPoint(0, 0))
  board:setPosition(scalep(363, 9))
  layer:addChild(board)
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  img.load(img.packedOthers.ui_activity_cdkey)
  local banner = img.createUISprite(img.ui.activity_cdkey_board)
  banner:setAnchorPoint(CCPoint(0.5, 1))
  banner:setPosition(CCPoint(board_w / 2, board_h))
  board:addChild(banner)
  local title = nil
  if isOnestore() then
    title = img.createUISprite("activity_cdkey_board_kr.png")
  else
    title = img.createUISprite("activity_cdkey_board_cn.png")
  end
  title:setPosition(164, 122)
  banner:addChild(title)
  local cboard = img.createUI9Sprite(img.ui.bottom_border_2)
  cboard:setPreferredSize(CCSizeMake(574, 201))
  cboard:setAnchorPoint(CCPoint(0, 0))
  cboard:setPosition(CCPoint(0, 4))
  board:addChild(cboard)
  local cboard_w = cboard:getContentSize().width
  local cboard_h = cboard:getContentSize().height
  local txt_des = "please input a 12-digit redemption code"
  local txt_go = "EXCHANGE"
  txt_des = "\232\175\183\232\190\147\229\133\165\231\164\188\229\140\133\229\133\145\230\141\162\231\160\129"
  txt_go = "\229\133\145\230\141\162"
  if isOnestore() then
    txt_des = "\236\191\160\237\143\176 \235\178\136\237\152\184\235\165\188 \236\158\133\235\160\165\237\149\180\236\163\188\236\132\184\236\154\148"
    txt_go = "\234\181\144\237\153\152"
  else
    if i18n.getCurrentLanguage() == kLanguageChinese or i18n.getCurrentLanguage() == kLanguageChineseTW then
      txt_des = "\232\175\183\232\190\147\229\133\165\231\164\188\229\140\133\229\133\145\230\141\162\231\160\129"
      txt_go = "\229\133\145\230\141\162"
    end
  end
  local lbl_des = lbl.createMixFont1(16, txt_des, ccc3(115, 59, 5))
  lbl_des:setPosition(CCPoint(cboard_w / 2, 166))
  cboard:addChild(lbl_des)
  local edit_bg = img.createLogin9Sprite(img.login.input_border)
  local edit_msg = CCEditBox:create(CCSizeMake(350, 44), edit_bg)
  edit_msg:setReturnType(kKeyboardReturnTypeDone)
  edit_msg:setFont("", 18)
  edit_msg:setFontColor(ccc3(0, 0, 0))
  edit_msg:setPlaceHolder("")
  edit_msg:setPosition(CCPoint(cboard_w / 2, 113))
  cboard:addChild(edit_msg, 100)
  local btn_go0 = img.createLogin9Sprite(img.login.button_9_small_gold)
  btn_go0:setPreferredSize(CCSizeMake(152, 45))
  local lbl_go = lbl.createMixFont1(16, txt_go, ccc3(115, 59, 5))
  lbl_go:setPosition(CCPoint(btn_go0:getContentSize().width / 2, btn_go0:getContentSize().height / 2))
  btn_go0:addChild(lbl_go)
  local btn_go = SpineMenuItem:create(json.ui.button, btn_go0)
  btn_go:setPosition(CCPoint(cboard_w / 2, 50))
  local btn_go_menu = CCMenu:createWithItem(btn_go)
  btn_go_menu:setPosition(CCPoint(0, 0))
  cboard:addChild(btn_go_menu)
  btn_go:registerScriptTapHandler(function()
    disableObjAWhile(btn_go)
    audio.play(audio.button)
    local code = edit_msg:getText()
    code = string.trim(code)
    local params = {sid = player.sid, key = code}
    addWaitNet()
    netClient:cdkey(params, function(l_1_0)
      tbl2string(l_1_0)
      delWaitNet()
      local ss = l_1_0.status .. ""
      if toasts[ss] then
        showToast(toasts[ss])
      else
        showToast(toasts.unknown)
      end
      end)
   end)
  img.unload(img.packedOthers.ui_activity_cdkey)
  layer:setTouchSwallowEnabled(false)
  layer:setTouchEnabled(true)
  return layer
end

return ui


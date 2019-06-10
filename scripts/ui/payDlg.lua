-- Command line was: E:\github\dhgametool\scripts\ui\payDlg.lua 

local ui = {}
local cjson = json
require("common.func")
local view = require("common.view")
local img = require("res.img")
local lbl = require("res.lbl")
local json = require("res.json")
local i18n = require("res.i18n")
local audio = require("res.audio")
local cfgstore = require("config.store")
local player = require("data.player")
local bag = require("data.bag")
local getOrder = function(l_1_0, l_1_1)
  l_1_0.sid = player.sid
  l_1_0.storeid = l_1_0.productId
  l_1_0.device_info = HHUtils:getAdvertisingId() or ""
  l_1_0.body = "\230\184\184\230\136\143\231\164\188\229\140\133"
  l_1_0.subject = "\230\184\184\230\136\143\231\164\188\229\140\133"
  if cfgstore[l_1_0.productId] then
    l_1_0.body = cfgstore[l_1_0.productId].commodityName
    l_1_0.subject = cfgstore[l_1_0.productId].commodityName
  end
  local net = require("net.netClient")
  net:gorder(l_1_0, function(l_1_0)
    tbl2string(l_1_0)
    if l_1_0.status ~= 0 then
      delWaitNet()
      showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
      return 
    end
    if callback then
      callback(l_1_0)
    end
   end)
end

local payWx = function(l_2_0, l_2_1)
  local orderInfo = cjson.encode(l_2_0)
  DHPayment:getInstance():payWx(orderInfo, l_2_1)
end

local payAli = function(l_3_0, l_3_1)
  local orderInfo = l_3_0.paystr
  DHPayment:getInstance():payAli(orderInfo, l_3_1)
end

ui.create = function(l_4_0)
  local productId = l_4_0.productId
  local callback = l_4_0.callback
  local layer = CCLayer:create()
  local darkbg = CCLayerColor:create(ccc4(0, 0, 0, POPUP_DARK_OPACITY))
  layer:addChild(darkbg)
  local board = img.createUI9Sprite(img.ui.dialog_1)
  board:setPreferredSize(CCSizeMake(562, 384))
  board:setScale(view.minScale)
  board:setPosition(view.midX - 5 * view.minScale, view.midY)
  layer:addChild(board)
  layer.board = board
  local board_w = board:getContentSize().width
  local board_h = board:getContentSize().height
  if _anim then
    board:setScale(0.5 * view.minScale)
    board:runAction(CCScaleTo:create(0.15, 1 * view.minScale, 1 * view.minScale))
  end
  local lbl_title = lbl.createFont1(24, i18n.global.setting_board_title.string, ccc3(230, 208, 174))
  lbl_title:setPosition(CCPoint(board_w / 2, board_h - 29))
  board:addChild(lbl_title, 2)
  local lbl_title_shadowD = lbl.createFont1(24, i18n.global.setting_board_title.string, ccc3(89, 48, 27))
  lbl_title_shadowD:setPosition(CCPoint(board_w / 2, board_h - 31))
  board:addChild(lbl_title_shadowD)
  layer.setTitle = function(l_1_0)
    lbl_title:setString(l_1_0)
    lbl_title_shadowD:setString(l_1_0)
   end
  local backEvent = function()
    audio.play(audio.button)
    layer:removeFromParentAndCleanup(true)
   end
  local btn_close0 = img.createUISprite(img.ui.close)
  local btn_close = SpineMenuItem:create(json.ui.button, btn_close0)
  btn_close:setPosition(CCPoint(board_w - 25, board_h - 28))
  local btn_close_menu = CCMenu:createWithItem(btn_close)
  btn_close_menu:setPosition(CCPoint(0, 0))
  board:addChild(btn_close_menu, 100)
  layer.btn_close = btn_close
  btn_close:registerScriptTapHandler(function()
    backEvent()
   end)
  local inner_board = img.createUI9Sprite(img.ui.bag_btn_inner_bg)
  inner_board:setPreferredSize(CCSizeMake(510, 288))
  inner_board:setAnchorPoint(CCPoint(0.5, 0))
  inner_board:setPosition(CCPoint(board_w / 2, 35))
  board:addChild(inner_board)
  layer.inner_board = inner_board
  local inner_board_w = inner_board:getContentSize().width
  local inner_board_h = inner_board:getContentSize().height
  local btn_wx0 = img.createUISprite(img.ui.pay_wx)
  local btn_wx = SpineMenuItem:create(json.ui.button, btn_wx0)
  btn_wx:setPosition(CCPoint(145, inner_board_h / 2))
  local btn_wx_menu = CCMenu:createWithItem(btn_wx)
  btn_wx_menu:setPosition(CCPoint(0, 0))
  inner_board:addChild(btn_wx_menu)
  local btn_ali0 = img.createUISprite(img.ui.pay_ali)
  local btn_ali = SpineMenuItem:create(json.ui.button, btn_ali0)
  btn_ali:setPosition(CCPoint(366, inner_board_h / 2))
  local btn_ali_menu = CCMenu:createWithItem(btn_ali)
  btn_ali_menu:setPosition(CCPoint(0, 0))
  inner_board:addChild(btn_ali_menu)
  layer:setTouchEnabled(true)
  layer:setTouchSwallowEnabled(true)
  btn_wx:registerScriptTapHandler(function()
    audio.play(audio.button)
    local params = {productId = productId, type = PAY_METHOD.WX}
    addWaitNet(function()
      delWaitNet()
      showToast("\230\148\175\228\187\152\232\182\133\230\151\182")
      end, 90)
    getOrder(params, function(l_2_0)
      tbl2string(l_2_0)
      local netOrder = cjson.decode(l_2_0.order_info)
      local wxParams = {appid = "wxfd23210e2c64a0f3", partnerid = "1441277802", prepayid = netOrder.prepayid, package = "Sign=WXPay", noncestr = netOrder.noncestr, timestamp = netOrder.timestamp, sign = netOrder.sign}
      payWx(wxParams, function(l_1_0)
        if l_1_0 ~= "ok" then
          schedule(layer, 0.8, function()
          showToast("\230\148\175\228\187\152\232\162\171\229\143\150\230\182\136\230\136\150\229\164\177\232\180\165.")
            end)
          delWaitNet()
          return 
        end
        schedule(layer, 0.8, function()
          showToast("\230\148\175\228\187\152\230\136\144\229\138\159.")
            end)
        local gParams = {sid = player.sid, orderid = netOrder.orderid or "", appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
        local net = require("net.netClient")
        net:gpay(gParams, function(l_3_0)
          tbl2string(l_3_0)
          delWaitNet()
          if l_3_0.status ~= 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_3_0.status))
            return 
          end
          if (l_3_0.reward.equips and #l_3_0.reward.equips > 0) or l_3_0.reward.items and #l_3_0.reward.items > 0 then
            require("data.activity").pay()
          end
          layer:removeFromParentAndCleanup(true)
          if callback then
            callback(l_3_0.reward)
          end
          local price = cfgstore[params.productId].priceCn % 19 + 13
          require("data.toutiao").eventPurchase(params.subject, params.productId, price .. "")
            end)
         end)
      end)
   end)
  btn_ali:registerScriptTapHandler(function()
    audio.play(audio.button)
    local params = {productId = productId, type = PAY_METHOD.ALI}
    addWaitNet(function()
      delWaitNet()
      showToast("\230\148\175\228\187\152\232\182\133\230\151\182")
      end, 90)
    getOrder(params, function(l_2_0)
      tbl2string(l_2_0)
      local netOrder = cjson.decode(l_2_0.order_info)
      local aliParams = {paystr = netOrder.paystr}
      payAli(aliParams, function(l_1_0)
        if l_1_0 ~= "ok" then
          showToast("\230\148\175\228\187\152\232\162\171\229\143\150\230\182\136\230\136\150\229\164\177\232\180\165.")
          delWaitNet()
          return 
        end
        showToast("\230\148\175\228\187\152\230\136\144\229\138\159.")
        local gParams = {sid = player.sid, orderid = netOrder.orderid or "", appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
        local net = require("net.netClient")
        net:gpay(gParams, function(l_1_0)
          tbl2string(l_1_0)
          delWaitNet()
          if l_1_0.status ~= 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            return 
          end
          if (l_1_0.reward.equips and #l_1_0.reward.equips > 0) or l_1_0.reward.items and #l_1_0.reward.items > 0 then
            require("data.activity").pay()
          end
          layer:removeFromParentAndCleanup(true)
          if callback then
            callback(l_1_0.reward)
          end
          local price = cfgstore[params.productId].priceCn % 19 + 13
          require("data.toutiao").eventPurchase(params.subject, params.productId, price .. "")
            end)
         end)
      end)
   end)
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
  layer:registerScriptHandler(function(l_9_0)
    if l_9_0 == "enter" then
      onEnter()
    elseif l_9_0 == "exit" then
      onExit()
    end
   end)
  return layer
end

return ui


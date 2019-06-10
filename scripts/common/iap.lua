-- Command line was: E:\github\dhgametool\scripts\common\iap.lua 

local iap = {}
require("common.const")
require("common.func")
iap.pull = function(l_1_0)
  if APP_CHANNEL and APP_CHANNEL == "IAS" then
    l_1_0()
  else
    if isChannel() then
      l_1_0()
    else
      DHPayment:getInstance():pull(function(l_1_0, l_1_1)
      print("iap pull {")
      print("status", l_1_0)
      if l_1_0 ~= "ok" or #l_1_1 == 0 then
        print("iap pull }")
        handler()
        return 
      end
      iap.verify(l_1_1, function(l_1_0)
        print("iap pull }")
        handler(l_1_0)
         end)
      end)
    end
  end
end

iap.pay = function(l_2_0, l_2_1)
  if APP_CHANNEL and APP_CHANNEL ~= "" then
    iap.rpay(l_2_0, l_2_1)
    return 
  end
  local playerdata = require("data.player")
  local params = {sid = playerdata.sid, storeid = iap.convertId(l_2_0)}
  local net = require("net.netClient")
  net:chpay(params, function(l_1_0)
    if l_1_0.status ~= 0 then
      delWaitNet()
      if l_1_0.status == -1 then
        local i18n = require("res.i18n")
        showToast(i18n.global.pay_ban.string)
        return 
      elseif l_1_0.status == -2 then
        local i18n = require("res.i18n")
        showToast(i18n.global.toast_buy_herolist_full.string)
        return 
      else
        local i18n = require("res.i18n")
        showToast(i18n.global.pay_ban2.string)
        return 
      end
    else
      iap.rpay(productId, handler)
    end
  end
   end)
end

iap.rpay = function(l_3_0, l_3_1)
  local _productId = iap.convertId(l_3_0)
  if APP_CHANNEL and APP_CHANNEL == "IAS" then
    delWaitNet()
    local payDlg = require("ui.payDlg")
    CCDirector:sharedDirector():getRunningScene():addChild(payDlg.create({productId = _productId, callback = l_3_1}), 10000)
    return 
  else
    if isChannel() then
      local sdkcfg = require("common.sdkcfg")
      if sdkcfg[APP_CHANNEL] and sdkcfg[APP_CHANNEL].pay then
        sdkcfg[APP_CHANNEL].pay({productId = _productId}, l_3_1)
      end
      return 
    end
  end
  local refId = l_3_0
  if device.platform == "android" and refId then
    local android_refId_suffix = string.sub(refId, -3, -1)
    if android_refId_suffix == "d36" or android_refId_suffix == "d37" or android_refId_suffix == "d38" then
      refId = refId .. "_subs"
    end
  end
  local pay_callback = function(l_1_0, l_1_1)
    print("iap pay {")
    print("status", l_1_0)
    if l_1_0 == "sub0" then
      local refId_suffix = string.sub(refId, -3, -1)
      if refId_suffix == "d36" or refId_suffix == "d37" or refId_suffix == "d38" then
        local freward = {items = {1 = {id = ITEM_ID_SP_SUB, num = 10}}}
        handler(freward)
      else
        print("iap pay }")
        handler()
      end
      return 
    elseif l_1_0 ~= "ok" then
      print("iap pay }")
      handler()
      return 
    end
    iap.verify({l_1_1}, function(l_1_0)
      print("iap pay }")
      handler(l_1_0)
      end)
   end
  if device.platform == "android" and DHPayment:getInstance().isSupportedGoogleReplaceSubs then
    local playerdata = require("data.player")
    local extraData = {}
    extraData.payload = {user_id = playerdata.uid, server_id = playerdata.sid}
    local shop = require("data.shop")
    local subId = shop.subId()
    if subId > 0 then
      local store = require("config.store")
      extraData.oldSubs = store[subId].payId .. "_subs"
    end
    local cjson = require("cjson")
    DHPayment:getInstance():pay(refId, cjson.encode(extraData), pay_callback)
  else
    DHPayment:getInstance():pay(refId, pay_callback)
  end
end

iap.verify = function(l_4_0, l_4_1)
  local purchasesCopy = {}
  local playerdata = require("data.player")
  local params = {sid = playerdata.sid, order = {}, id = {}, token = {}, package = l_4_0[1].packageName, platform = DHPayment:getInstance():getTypeString(), appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
  local anySub, last_sub_purchase = nil, nil
  for _,purchase in ipairs(l_4_0) do
    local is_sub = false
    if string.sub(purchase.productId or "", -3, -1) == "d36" then
      anySub = true
      is_sub = true
      last_sub_purchase = purchase
    else
      if string.sub(purchase.productId or "", -3, -1) == "d37" then
        anySub = true
        is_sub = true
        last_sub_purchase = purchase
      else
        if string.sub(purchase.productId or "", -3, -1) == "d38" then
          anySub = true
          is_sub = true
          last_sub_purchase = purchase
        end
      end
    end
    print("iap verify: productId", purchase.productId, "orderId", purchase.orderId, "token", purchase.token)
    if is_sub and device.platform == "ios" then
      do return end
    end
    table.insert(params.order, purchase.orderId)
    table.insert(params.id, iap.convertId(purchase.productId))
    table.insert(params.token, purchase.token)
    table.insert(purchasesCopy, purchase:clone())
  end
  if last_sub_purchase and device.platform == "ios" then
    local purchase = last_sub_purchase
    table.insert(params.order, purchase.orderId)
    table.insert(params.id, iap.convertId(purchase.productId))
    table.insert(params.token, purchase.token)
  end
  local net = require("net.netClient")
  net:pay2(net, params, function(l_1_0)
    if l_1_0.status ~= 0 then
      DHPayment:getInstance():consume(purchasesCopy, function()
      handler()
      end)
      return 
    end
    if not l_1_0.reward and anySub then
      l_1_0.reward = {items = {1 = {id = ITEM_ID_SP_SUB, num = 10}}}
    end
    DHPayment:getInstance():consume(purchasesCopy, function()
      handler(data.reward)
      end)
    if (l_1_0.reward.equips and #l_1_0.reward.equips > 0) or l_1_0.reward.items and #l_1_0.reward.items > 0 then
      require("data.activity").pay()
      local money = 0
      local cfgstore = require("config.store")
      for _,id in ipairs(params.id) do
        money = money + cfgstore[id].price
      end
      if money > 0 then
        iap.track(money)
      end
    end
   end)
end

iap.convertId = function(l_5_0)
  local cfgstore = require("config.store")
  for id,cfg in ipairs(cfgstore) do
    if cfg.payId == l_5_0 then
      return id
    end
  end
  return nil
end

iap.track = function(l_6_0)
  if APP_CHANNEL and APP_CHANNEL == "LT" then
    return 
  end
  if DHPayment:getInstance():isReleasePayment() then
    HHUtils:trackPaymentFacebook(tonumber(l_6_0), "USD")
  end
end

return iap


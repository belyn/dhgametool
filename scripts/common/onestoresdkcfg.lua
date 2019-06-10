-- Command line was: E:\github\dhgametool\scripts\common\onestoresdkcfg.lua 

local cfg = {}
cfg.upName = "onestore"
local cjson = json
require("common.func")
require("common.const")
local netClient = require("net.netClient")
local i18n = require("res.i18n")
local player = require("data.player")
local userdata = require("data.userdata")
local director = CCDirector:sharedDirector()
local bcfg = require("common.basesdkcfg")
local jsonEncode = bcfg.jsonEncode
local jsonDecode = bcfg.jsonDecode
local getOrder = function(l_1_0, l_1_1)
  l_1_0.sid = player.sid
  l_1_0.storeid = l_1_0.productId
  l_1_0.device_info = HHUtils:getAdvertisingId() or ""
  l_1_0.body = l_1_0.body or "\230\184\184\230\136\143\231\164\188\229\140\133"
  l_1_0.subject = "\230\184\184\230\136\143\231\164\188\229\140\133"
  netClient:gorder(l_1_0, function(l_1_0)
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

local processPrice = function()
  local cfgstore = require("config.store")
  for id,cfg in ipairs(cfgstore) do
    cfg.price = cfg.krPrice
    cfg.priceCn = cfg.krPrice
    cfg.priceStr = cfg.priceKrStr
    cfg.priceCnStr = cfg.priceKrStr
  end
end

cfg.init = function()
  processPrice()
  SDKHelper:getInstance():initGame("", function(l_1_0)
    print("initGame:", l_1_0)
    local params = {sid = player.sid}
    netClient:oneforum(params, function(l_1_0)
      tbl2string(l_1_0)
      end)
   end)
end

cfg.login = nil
cfg.logout = function(l_4_0, l_4_1)
  SDKHelper:getInstance():logout("", function(l_1_0)
    schedule(director:getRunningScene(), function()
      replaceScene(require("ui.login.home").create())
      end)
   end)
end

cfg.exit = nil
local getSku = function(l_5_0)
  local cfgstore = require("config.store")
  for id,cfg in ipairs(cfgstore) do
    if id == l_5_0 then
      return cfg.pid
    end
  end
  return nil
end

local getPrice = function(l_6_0)
  local cfgstore = require("config.store")
  for id,cfg in ipairs(cfgstore) do
    if id == l_6_0 then
      return "" .. cfg.krPrice
    end
  end
  return "0"
end

local trackPayment = function(l_7_0)
  HHUtils:trackPaymentAppsFlyer(tonumber(l_7_0), "USD")
end

local updateReceipts = {}
local handleUpdateReceipts = function(l_8_0)
end

local fullfill = function(l_9_0)
  SDKHelper:getInstance():submitRoleData(l_9_0, function(l_1_0)
   end)
end

local checking = nil
cfg.initGame = nil
cfg.pay = function(l_10_0, l_10_1)
  local sku = getSku(l_10_0.productId)
  print("get sku:", sku)
  if not sku then
    delWaitNet()
    showToast("get sku failed.")
    return 
  end
  local oparams = {productId = l_10_0.productId, pid = sku, type = 25}
  addWaitNet()
  getOrder(oparams, function(l_1_0)
    tablePrint(l_1_0)
    local netOrder = jsonDecode(l_1_0.order_info)
    local ucParams = {tid = netOrder.cpOrderId, pid = oparams.pid}
    local paramStr = jsonEncode(ucParams)
    SDKHelper:getInstance():pay(paramStr, function(l_1_0)
      local tdata = jsonDecode(l_1_0)
      tablePrint(tdata)
      if not tdata or not tdata.errcode or tdata.errcode ~= 0 then
        if callback then
          callback()
        end
        return 
      end
      local gParams = {sid = player.sid, orderid = ucParams.tid, txid = tdata.txid, productid = tdata.sign, appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
      schedule(director:getRunningScene(), 0.5, function()
        netClient:gpay(gParams, function(l_1_0)
          tablePrint(l_1_0)
          delWaitNet()
          if l_1_0.status ~= 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            return 
          end
          if (l_1_0.reward.equips and #l_1_0.reward.equips > 0) or l_1_0.reward.items and #l_1_0.reward.items > 0 then
            require("data.activity").pay()
          end
          if callback then
            callback(l_1_0.reward)
          end
            end)
         end)
      end)
   end)
end

return cfg


-- Command line was: E:\github\dhgametool\scripts\common\samsungsdkcfg.lua 

local cfg = {}
cfg.upName = "samsung"
cfg.support_takingdata = true
local cjson = json
require("common.func")
require("common.const")
local netClient = require("net.netClient")
local i18n = require("res.i18n")
local player = require("data.player")
local userdata = require("data.userdata")
local director = CCDirector:sharedDirector()
local bcfg = require("common.basesdkcfg")
local getOrder = function(l_1_0, l_1_1)
  local cfgstore = require("config.store")
  l_1_0.sid = player.sid
  l_1_0.storeid = l_1_0.productId
  l_1_0.device_info = HHUtils:getAdvertisingId() or ""
  l_1_0.body = l_1_0.body or "\230\184\184\230\136\143\231\164\188\229\140\133"
  l_1_0.subject = "\230\184\184\230\136\143\231\164\188\229\140\133"
  if cfgstore[l_1_0.productId] then
    l_1_0.body = cfgstore[l_1_0.productId].commodityName
    l_1_0.subject = cfgstore[l_1_0.productId].commodityName
  end
  netClient:gorder(l_1_0, function(l_1_0)
    tablePrint(l_1_0)
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

local jsonEncode = bcfg.jsonEncode
local jsonDecode = bcfg.jsonDecode
cfg.init = function()
  local params = {server_id = player.sid, role_name = player.name}
  local jsonstr = jsonEncode(params)
  SDKHelper:getInstance():initGame(jsonstr, function(l_1_0)
   end)
end

cfg.login = function(l_3_0, l_3_1)
  addWaitNet()
  cfg.logout()
  SDKHelper:getInstance():login("", function(l_1_0)
    print("sdklogin\239\188\154", l_1_0)
    local __data = jsonDecode(l_1_0)
    if __data and __data.errcode and __data.errcode ~= 0 then
      delWaitNet()
      showToast(__data.desc or "\231\153\187\229\189\149\229\164\177\232\180\165")
      schedule(director:getRunningScene(), 1, function()
        replaceScene(require("ui.login.home").create())
         end)
    else
      local jparams = {token = __data.signValue}
      local jsonstr = jsonEncode(jparams)
      local nparams = {sid = 0}
      nparams.jsonStr = jsonstr
      nparams.platform = "samsung"
      netClient:thirdlogin(nparams, function(l_2_0)
        tablePrint(l_2_0)
        delWaitNet()
        if callback then
          callback(l_2_0)
        end
         end)
    end
   end)
end

cfg.logout = function(l_4_0, l_4_1)
  SDKHelper:getInstance():logout("", function(l_1_0)
    schedule(director:getRunningScene(), function()
      replaceScene(require("ui.login.home").create())
      end)
   end)
end

cfg.exit = function(l_5_0, l_5_1)
  SDKHelper:getInstance():exitGame("", function(l_1_0)
    print("exitGame data:", l_1_0)
    local __data = jsonDecode(l_1_0)
    if __data and __data.errcode == 1 then
      return 
    end
    if callback then
      callback()
    end
   end)
end

cfg.pay = function(l_6_0, l_6_1)
  local oparams = {productId = l_6_0.productId, type = 28}
  addWaitNet()
  getOrder(oparams, function(l_1_0)
    tablePrint(l_1_0)
    local netOrder = jsonDecode(l_1_0.order_info)
    local wfParams = {app_name = "\230\148\190\231\189\174\229\165\135\229\133\181", app_order_id = netOrder.app_order_id, product_name = netOrder.product_name, productId = netOrder.productId .. "", money_amount = netOrder.money_amount, transid = netOrder.transid, appid = netOrder.appid, price = netOrder.price, cpOrderId = netOrder.cpOrderId}
    require("data.takingdata").onChargeReq(wfParams.app_order_id, netOrder.productId, netOrder.money_amount, "CNY", 0, "third")
    local paramStr = "transid=" .. netOrder.transid .. "&appid=" .. netOrder.appid
    print("paramStr", paramStr)
    SDKHelper:getInstance():pay(paramStr, function(l_1_0)
      local tdata = jsonDecode(l_1_0)
      if not tdata or not tdata.errcode or tdata.errcode ~= 0 then
        if callback then
          callback()
        end
        return 
      end
      require("data.takingdata").onChargeSuc(netOrder.app_order_id)
      local gParams = {sid = player.sid, orderid = netOrder.app_order_id or "", appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
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


-- Command line was: E:\github\dhgametool\scripts\common\baidusdkcfg.lua 

local cfg = {}
cfg.upName = "baidu"
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
  l_1_0.sid = player.sid
  l_1_0.storeid = l_1_0.productId
  l_1_0.device_info = HHUtils:getAdvertisingId() or ""
  l_1_0.body = l_1_0.body or "\230\184\184\230\136\143\231\164\188\229\140\133"
  l_1_0.subject = "\230\184\184\230\136\143\231\164\188\229\140\133"
  local cfgstore = require("config.store")
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
cfg.init = nil
cfg.login = function(l_2_0, l_2_1)
  addWaitNet()
  cfg.logout()
  SDKHelper:getInstance():login("", function(l_1_0)
    print("sdklogin\239\188\154", l_1_0)
    local __data = jsonDecode(l_1_0)
    if __data and __data.errcode and __data.errcode ~= 0 then
      delWaitNet()
      showToast("\231\153\187\229\189\149\229\164\177\232\180\165")
      schedule(director:getRunningScene(), 1, function()
        replaceScene(require("ui.login.home").create())
         end)
    else
      local lparams = {uid = __data.uid, access_token = __data.atoken}
      local jsonstr = jsonEncode(lparams)
      local nparams = {sid = 0}
      nparams.jsonStr = jsonstr
      nparams.platform = "baidu"
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

cfg.logout = function(l_3_0, l_3_1)
  SDKHelper:getInstance():logout("", function(l_1_0)
    schedule(director:getRunningScene(), function()
      replaceScene(require("ui.login.home").create())
      end)
   end)
end

cfg.exit = function(l_4_0, l_4_1)
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

cfg.pay = function(l_5_0, l_5_1)
  local oparams = {productId = l_5_0.productId, type = 14}
  addWaitNet()
  getOrder(oparams, function(l_1_0)
    tablePrint(l_1_0)
    local netOrder = jsonDecode(l_1_0.order_info)
    local ucParams = {cpOrderId = netOrder.CooperatorOrderSerial, productName = netOrder.productName, uid = netOrder.uid, price = netOrder.price}
    require("data.takingdata").onChargeReq(ucParams.cpOrderId, oparams.productId, netOrder.price / 100, "CNY", 0, "third")
    local paramStr = jsonEncode(ucParams)
    SDKHelper:getInstance():pay(paramStr, function(l_1_0)
      print(l_1_0)
      local tdata = jsonDecode(l_1_0)
      if not tdata.desc then
        showToast(tdata and tdata.errcode and tdata.errcode >= 0 or "\230\148\175\228\187\152\229\164\177\232\180\165")
      end
      if callback then
        callback()
      end
      return 
      if tdata.errcode == 0 then
        showToast("\230\148\175\228\187\152\230\136\144\229\138\159.")
      elseif tdata.errcode == 10000 then
        showToast(tdata.desc or "")
      end
      require("data.takingdata").onChargeSuc(ucParams.cpOrderId)
      local gParams = {sid = player.sid, orderid = netOrder.orderid or "", appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
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

cfg.submitRoleData = nil
return cfg


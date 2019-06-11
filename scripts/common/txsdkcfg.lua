-- Command line was: E:\github\dhgametool\scripts\common\txsdkcfg.lua 

local cfg = {}
cfg.upName = "tx"
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
cfg.login = function(l_2_0, l_2_1)
  local whichtx = userdata.getString(userdata.keys.txwhich, "qq")
  addWaitNet()
  local txparams = {which = whichtx}
  local txparamsstr = jsonEncode(txparams)
  print("tx sdk login, param is ", whichtx)
  cfg.logout("false")
  SDKHelper:getInstance():login(txparamsstr, function(l_1_0)
    print("tx sdklogin\239\188\154", l_1_0)
    local __data = jsonDecode(l_1_0)
    tablePrint(__data)
    delWaitNet()
    if __data and __data.errcode and __data.errcode ~= 0 then
      showToast("\231\153\187\229\189\149\229\164\177\232\180\165")
      schedule(director:getRunningScene(), 1, function()
        replaceScene(require("ui.login.home").create())
         end)
    else
      local jparams = {platform = whichtx, openkey = __data.openkey, openid = __data.openid, pf = __data.pf, pfkey = __data.pf_key, paytoken = __data.payToken}
      local jsonstr = jsonEncode(jparams)
      local nparams = {sid = 0, jsonStr = jsonstr, platform = "tx"}
      print("tx22222 jsonstr:", nparams.jsonStr)
      netClient:thirdlogin(nparams, function(l_2_0)
        delWaitNet()
        print("tx login finish, data is:")
        tablePrint(l_2_0)
        if callback then
          callback(l_2_0)
        end
         end)
    end
   end)
end

cfg.logout = function(l_3_0, l_3_1)
  SDKHelper:getInstance():logout(l_3_0, function(l_1_0)
    schedule(director:getRunningScene(), function()
      replaceScene(require("ui.login.home").create())
      end)
   end)
end

cfg.pay = function(l_4_0, l_4_1)
  local oparams = {productId = l_4_0.productId, type = 5, body = userdata.getString(userdata.keys.txwhich, "qq")}
  getOrder(oparams, function(l_1_0)
    print("tx pay, order info is:")
    tablePrint(l_1_0)
    local netOrder = jsonDecode(l_1_0.order_info)
    local txParams = {zoneId = "1", saveValue = netOrder.price, isCanChange = false, ysdkExtInfo = ""}
    require("data.takingdata").onChargeReq(netOrder.id, params.productId, netOrder.price / 10, "CNY", 0, "third")
    local paramStr = jsonEncode(txParams)
    SDKHelper:getInstance():pay(paramStr, function(l_1_0)
      print("pay data:", l_1_0)
      local tdata = jsonDecode(l_1_0)
      if not tdata or not tdata.errcode or tdata.errcode ~= 0 then
        if tdata and tdata.desc then
          showToast("\230\148\175\228\187\152\229\164\177\232\180\165")
        else
          showToast("\230\148\175\228\187\152\229\164\177\232\180\165")
        end
        if callback then
          callback()
        end
        return 
      end
      showToast("\230\148\175\228\187\152\230\136\144\229\138\159.")
      require("data.takingdata").onChargeSuc(netOrder.id)
      local gParams = {sid = player.sid, orderid = netOrder.id or "", appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
      print("client gpay, param is:")
      tablePrint(gParams)
      netClient:gpay(gParams, function(l_1_0)
        print("client gpay back, data is:")
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
end

return cfg


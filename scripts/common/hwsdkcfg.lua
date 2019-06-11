-- Command line was: E:\github\dhgametool\scripts\common\hwsdkcfg.lua 

local cfg = {}
cfg.upName = "hw"
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
local jsonEncode = bcfg.jsonEncode
local jsonDecode = bcfg.jsonDecode
local getOrder = function(l_1_0, l_1_1)
  l_1_0.sid = player.sid
  l_1_0.storeid = l_1_0.productId
  l_1_0.subject = "\230\184\184\230\136\143\231\164\188\229\140\133"
  l_1_0.body = "\230\184\184\230\136\143\231\164\188\229\140\133"
  l_1_0.device_info = HHUtils:getAdvertisingId() or ""
  l_1_0.extInfo = jsonEncode({is_new = "1"})
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

cfg.login = function(l_2_0, l_2_1)
  SDKHelper:getInstance():login("", function(l_1_0)
    print("sdklogin\239\188\154", l_1_0)
    local __data = jsonDecode(l_1_0)
    if not __data or not __data.errcode or __data.errcode ~= 0 then
      delWaitNet()
      if __data and __data.errcode then
        if __data.errcode == 3 or __data.errcode == 7 or __data.errcode == 10 then
          showToast("\232\175\183\229\174\137\232\163\133\230\136\150\230\155\180\230\150\176\230\184\184\230\136\143\228\184\173\229\191\131")
        else
          showToast("\232\175\183\233\135\141\230\150\176\231\153\187\229\189\149")
        end
      else
        showToast("\232\175\183\233\135\141\230\150\176\231\153\187\229\189\149")
      end
      schedule(director:getRunningScene(), 1, function()
        replaceScene(require("ui.login.home").create())
         end)
    else
      local hparams = {gameAuthSign = __data.sign, playerId = __data.playerId, playerLevel = __data.playerLevel, appId = __data.appId, ts = __data.ts, is_new = "1"}
      local jsonstr = jsonEncode(hparams)
      local nparams = {}
      nparams.jsonStr = jsonstr
      nparams.sid = 0
      nparams.platform = "hw"
      print("----------------------hw params---------------------")
      tablePrint(nparams)
      print("----------------------hw params---------------------")
      netClient:thirdlogin(nparams, function(l_2_0)
        tablePrint(l_2_0)
        cfg.need_submit = true
        delWaitNet()
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
  local oparams = {productId = l_4_0.productId, type = 4}
  addWaitNet()
  getOrder(oparams, function(l_1_0)
    tablePrint(l_1_0)
    local netOrder = jsonDecode(l_1_0.order_info)
    local txParams = {price = netOrder.amount, productName = netOrder.productName, productDesc = netOrder.productDesc, requestId = netOrder.requestId or "", userName = netOrder.merchantName or "", userID = netOrder.merchantId or "", sdkChannel = netOrder.sdkChannel or "", serviceCatalog = netOrder.serviceCatalog or "", extReserved = netOrder.extReserved or "", url = netOrder.url or "", applicationID = netOrder.applicationID or "", sign = netOrder.sign or ""}
    require("data.takingdata").onChargeReq(txParams.requestId, oparams.productId, txParams.price, "CNY", 0, "third")
    local paramStr = jsonEncode(txParams)
    SDKHelper:getInstance():pay(paramStr, function(l_1_0)
      print("hw pay ret:", l_1_0)
      local tdata = jsonDecode(l_1_0)
      if not tdata or not tdata.errcode or tdata.errcode ~= 0 then
        if tdata and tdata.desc then
          showToast(tdata.desc)
        else
          showToast("\230\148\175\228\187\152\229\164\177\232\180\165")
        end
        if callback then
          callback()
        end
        return 
      end
      require("data.takingdata").onChargeSuc(txParams.requestId)
      showToast("\230\148\175\228\187\152\230\136\144\229\138\159.")
      local gParams = {sid = player.sid, orderid = netOrder.requestId or "", appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
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
end

cfg.submitRoleData = function(l_5_0, l_5_1)
  local sparams = {role_name = l_5_0.roleName .. "", role_level = checkint(l_5_0.roleLevel), server_name = l_5_0.zoneName .. "", party_name = player.gname or ""}
  local paramStr = jsonEncode(sparams)
  SDKHelper:getInstance():submitRoleData(paramStr, function(l_1_0)
   end)
end

return cfg


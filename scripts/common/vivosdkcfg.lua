-- Command line was: E:\github\dhgametool\scripts\common\vivosdkcfg.lua 

local cfg = {}
cfg.upName = "vivo"
cfg.support_takingdata = true
local cjson = json
require("common.func")
require("common.const")
local netClient = require("net.netClient")
local i18n = require("res.i18n")
local player = require("data.player")
local userdata = require("data.userdata")
local bcfg = require("common.basesdkcfg")
local ERR_MSG = {-1 = "\230\148\175\228\187\152\229\143\150\230\182\136", -2 = "\229\133\182\228\187\150\233\148\153\232\175\175", -3 = "\229\143\130\230\149\176\233\148\153\232\175\175", -4 = "\230\148\175\228\187\152\231\187\147\230\158\156\232\175\183\230\177\130\232\182\133\230\151\182", -5 = "\233\157\158\232\182\179\233\162\157\230\148\175\228\187\152\239\188\136\229\133\133\229\128\188\230\136\144\229\138\159\239\188\140\230\156\170\229\174\140\230\136\144\230\148\175\228\187\152\239\188\137", -6 = "\229\136\157\229\167\139\229\140\150\229\164\177\232\180\165", -7 = "\232\175\183\233\135\141\232\175\149"}
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
  local txparams = {which = "vivo"}
  local txparamsstr = jsonEncode(txparams)
  cfg.logout()
  SDKHelper:getInstance():login(txparamsstr, function(l_1_0)
    print("vivo sdklogin\239\188\154", l_1_0)
    local __data = jsonDecode(l_1_0)
    tablePrint(__data)
    if __data and __data.errcode and __data.errcode ~= 0 then
      delWaitNet()
      showToast("\231\153\187\229\189\149\229\164\177\232\180\165")
      schedule(director:getRunningScene(), 1, function()
        replaceScene(require("ui.login.home").create())
         end)
    else
      local jparams = {userName = __data.userName, openId = __data.openId, authToken = __data.authToken}
      local jsonstr = jsonEncode(jparams)
      local nparams = {sid = 0, jsonStr = jsonstr, platform = "vivo"}
      print("vivo jsonstr:", nparams.jsonStr)
      netClient:thirdlogin(nparams, function(l_2_0)
        tablePrint(l_2_0)
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

cfg.pay = function(l_4_0, l_4_1)
  local oparams = {productId = l_4_0.productId, type = 7}
  addWaitNet()
  getOrder(oparams, function(l_1_0)
    tablePrint(l_1_0)
    local netOrder = jsonDecode(l_1_0.order_info)
    local txParams = {productPrice = netOrder.productPrice, vivoSignature = netOrder.vivoSignature, productName = netOrder.productName, productDes = netOrder.productDes, transNo = netOrder.transNo, openId = netOrder.openId, extInfo = netOrder.extInfo or ""}
    require("data.takingdata").onChargeReq(txParams.transNo, params.productId, netOrder.productPrice / 100, "CNY", 0, "third")
    local paramStr = jsonEncode(txParams)
    SDKHelper:getInstance():pay(paramStr, function(l_1_0)
      local tdata = jsonDecode(l_1_0)
      if not tdata or not tdata.errcode or tdata.errcode ~= 0 then
        if ERR_MSG["" .. tdata.errcode] then
          showToast(ERR_MSG["" .. tdata.errcode])
        else
          showToast("\230\148\175\228\187\152\229\164\177\232\180\165:" + tdata.desc)
        end
        if callback then
          callback()
        end
        delWaitNet()
        return 
      end
      showToast("\230\148\175\228\187\152\230\136\144\229\138\159.")
      require("data.takingdata").onChargeSuc(netOrder.transNo)
      local gParams = {sid = player.sid, orderid = netOrder.orderid or "", appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
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

cfg.submitRoleData = function(l_6_0, l_6_1)
  local sparams = {role_id = l_6_0.roleId .. "", name = l_6_0.roleName .. "", level = checkint(l_6_0.roleLevel), serverid = l_6_0.zoneId .. "", servername = l_6_0.zoneName .. ""}
  local paramStr = jsonEncode(sparams)
  SDKHelper:getInstance():submitRoleData(paramStr, function(l_1_0)
   end)
end

return cfg


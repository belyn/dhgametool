-- Command line was: E:\github\dhgametool\scripts\common\chudongsdkcfg.lua 

local cfg = {}
cfg.upName = "chudong"
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
      showToast(__data.desc or "\231\153\187\229\189\149\229\164\177\232\180\165")
      schedule(director:getRunningScene(), 1, function()
        replaceScene(require("ui.login.home").create())
         end)
    else
      local jparams = {uid = __data.uid, username = __data.username, signkey = __data.signkey}
      local jsonstr = jsonEncode(jparams)
      local nparams = {sid = 0}
      nparams.jsonStr = jsonstr
      nparams.platform = "chudong"
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
    if callback then
      callback()
    end
   end)
end

cfg.pay = function(l_5_0, l_5_1)
  local oparams = {productId = l_5_0.productId, type = 23}
  addWaitNet()
  getOrder(oparams, function(l_1_0)
    schedule(director:getRunningScene(), 2, function()
      delWaitNet()
      end)
    tablePrint(l_1_0)
    local netOrder = jsonDecode(l_1_0.order_info)
    local ucParams = {productId = netOrder.productId .. "", productName = netOrder.productName, amount = netOrder.amount or "100000", num = netOrder.num or "1", zone = player.sid .. "", zoneName = "S" .. player.sid, roleName = player.name or "", roleId = (player.uid or "") .. "", callBackInfo = netOrder.callBackInfo or ""}
    require("data.takingdata").onChargeReq(ucParams.callBackInfo, oparams.productId, ucParams.amount / 100, "CNY", 0, "third")
    local paramStr = jsonEncode(ucParams)
    SDKHelper:getInstance():pay(paramStr, function(l_2_0)
      local tdata = jsonDecode(l_2_0)
      if not tdata or not tdata.errcode or tdata.errcode ~= 0 then
        delWaitNet()
        if tdata.errcode == -1 then
          showToast("\230\148\175\228\187\152\229\164\177\232\180\165")
        elseif tdata.errcode == -2 then
          showToast("\230\148\175\228\187\152\229\143\150\230\182\136")
        end
        if callback then
          callback()
        end
        return 
      end
      require("data.takingdata").onChargeSuc(ucParams.callBackInfo)
      local gParams = {sid = player.sid, orderid = netOrder.cp_order_id or "", appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
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

cfg.submitRoleData = function(l_6_0, l_6_1)
  local sparams = {roleid = (player.uid or "") .. "", rolelevel = player.lv() .. "", rolename = player.name or "", role_vip = player.vipLv() .. "", zoneid = player.sid .. "", zonename = "S" .. player.sid}
  local paramStr = jsonEncode(sparams)
  SDKHelper:getInstance():submitRoleData(paramStr, function(l_1_0)
   end)
end

return cfg


-- Command line was: E:\github\dhgametool\scripts\common\kaopusdkcfg.lua 

local cfg = {}
cfg.upName = "kaopu"
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
      schedule(director:getRunningScene(), 1, function()
        replaceScene(require("ui.login.home").create())
         end)
    else
      local jparams = {verifyurl = __data.verifyurl}
      local jsonstr = jsonEncode(jparams)
      local nparams = {sid = 0}
      nparams.jsonStr = jsonstr
      nparams.platform = "kaopu"
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
  local oparams = {productId = l_5_0.productId, type = 21}
  addWaitNet()
  getOrder(oparams, function(l_1_0)
    tablePrint(l_1_0)
    local cfgstore = require("config.store")
    local netOrder = jsonDecode(l_1_0.order_info)
    local ucParams = {productPrice = netOrder.Amount, server_name = netOrder.GameServer, role_id = player.uid, role_name = netOrder.Rolename, role_level = player.lv(), order_id = netOrder.Orderid, product_id = cfgstore[netOrder.goodsId].payId, product_desc = netOrder.CustomText}
    require("data.takingdata").onChargeReq(ucParams.order_id, oparams.productId, ucParams.productPrice, "CNY", 0, "third")
    local paramStr = jsonEncode(ucParams)
    SDKHelper:getInstance():pay(paramStr, function(l_1_0)
      local tdata = jsonDecode(l_1_0)
      if not tdata or not tdata.errcode or tdata.errcode ~= 0 then
        if not tdata or not tdata.desc or callback then
          callback()
        end
        return 
      end
      require("data.takingdata").onChargeSuc(ucParams.order_id)
      showToast("\230\148\175\228\187\152\230\136\144\229\138\159.")
      local gParams = {sid = player.sid, orderid = netOrder.orderid or "", appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
      schedule(director:getRunningScene(), 0.5, function()
        netClient:gpay(gParams, function(l_1_0)
          tablePrint(l_1_0)
          delWaitNet()
          if l_1_0.status ~= 0 then
            showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
            return 
          end
          if (l_1_0.reward.equips and  l_1_0.reward.equips > 0) or l_1_0.reward.items and  l_1_0.reward.items > 0 then
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
  local sparams = {roleId = l_6_0.roleId .. "", roleName = l_6_0.roleName .. "", roleLevel = checkint(l_6_0.roleLevel), roleCTime = l_6_0.roleCTime .. "", serverId = l_6_0.zoneId .. "", serverName = l_6_0.zoneName .. "", gameRoleBalance = require("data.bag").gem() .. "", vipLevel = player.vipLv() .. "", partyName = player.gname or "\230\151\160", roleLevelMTime = "0", guildId = (player.gid or "0") .. "", guildName = player.gname or "\230\151\160", guildLevel = 1, guildLeader = "unknown", power = 100}
  local paramStr = jsonEncode(sparams)
  SDKHelper:getInstance():submitRoleData(paramStr, function(l_1_0)
   end)
end

return cfg


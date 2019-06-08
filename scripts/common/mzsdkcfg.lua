-- Command line was: E:\github\dhgametool\scripts\common\mzsdkcfg.lua 

local cfg = {}
cfg.upName = "mz"
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
cfg.init = function(l_2_0, l_2_1)
  SDKHelper:getInstance():initGame("", function(l_1_0)
    print("initGame\239\188\154", l_1_0)
    if callback then
      callback(l_1_0)
    end
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
      showToast("\231\153\187\229\189\149\229\164\177\232\180\165")
      schedule(director:getRunningScene(), 1, function()
        replaceScene(require("ui.login.home").create())
         end)
    else
      print("\229\190\151\229\136\176\231\187\147\230\158\156\239\188\140\231\153\187\229\189\149")
      local jparams = {uid = __data.uid, session = __data.session}
      local jsonstr = jsonEncode(jparams)
      local nparams = {sid = 0, jsonStr = jsonstr, platform = "mz"}
      print("\229\144\145\230\156\141\229\138\161\229\153\168\229\143\145\233\128\129\230\149\176\230\141\174")
      netClient:thirdlogin(nparams, function(l_2_0)
        print("\230\148\182\229\136\176\230\156\141\229\138\161\229\153\168\229\155\158\229\164\141\230\182\136\230\129\175")
        delWaitNet()
        if callback then
          callback(l_2_0)
        end
         end)
    end
   end)
end

cfg.logout = function(l_4_0, l_4_1)
  SDKHelper:getInstance():logout(l_4_0, function(l_1_0)
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
  local oparams = {productId = l_6_0.productId, type = 8}
  addWaitNet()
  getOrder(oparams, function(l_1_0)
    tablePrint(l_1_0)
    local netOrder = jsonDecode(l_1_0.order_info)
    local ucParams = {cp_order_id = netOrder.cp_order_id, sign = netOrder.sign, sign_type = netOrder.sign_type .. "", buy_amount = netOrder.buy_amount .. "", user_info = netOrder.user_info .. "", total_price = netOrder.total_price .. "", product_id = netOrder.product_id .. "", product_subject = netOrder.product_subject .. "", product_body = netOrder.product_body .. "", product_unit = netOrder.product_unit .. "", app_id = netOrder.app_id .. "", uid = netOrder.uid .. "", product_per_price = netOrder.product_per_price .. "", create_time = netOrder.create_time .. "", pay_type = netOrder.pay_type .. ""}
    require("data.takingdata").onChargeReq(netOrder.cp_order_id, ucParams.product_id, netOrder.total_price, "CNY", 0, "third")
    local paramStr = jsonEncode(ucParams)
    SDKHelper:getInstance():pay(paramStr, function(l_1_0)
      local tdata = jsonDecode(l_1_0)
      if not tdata or not tdata.errcode or tdata.errcode ~= 0 then
        showToast("\230\148\175\228\187\152\231\149\140\233\157\162\232\162\171\229\133\179\233\151\173")
        if callback then
          callback()
        end
        return 
      end
      showToast("\230\148\175\228\187\152\230\136\144\229\138\159.")
      require("data.takingdata").onChargeSuc(netOrder.cp_order_id)
      local gParams = {sid = player.sid, orderid = netOrder.cp_order_id or "", appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
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

cfg.submitRoleData = function(l_7_0, l_7_1)
  local sparams = {role_id = l_7_0.roleId .. "", role_name = l_7_0.roleName .. "", role_zone = l_7_0.zoneName .. "", role_level = l_7_0.roleLevel .. "", role_vip = player.vipLv() .. ""}
  local paramStr = jsonEncode(sparams)
  SDKHelper:getInstance():submitRoleData(paramStr, function(l_1_0)
   end)
end

return cfg


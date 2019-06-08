-- Command line was: E:\github\dhgametool\scripts\common\6kwsdkcfg.lua 

local cfg = {}
cfg.upName = "6kw"
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

cfg.init = nil
cfg.login = function(l_2_0, l_2_1)
  addWaitNet()
  cfg.logout("")
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
      local jsonstr = jsonEncode({id = __data.id, name = __data.name, data = __data.data})
      local nparams = {sid = 0}
      nparams.jsonStr = jsonstr
      nparams.platform = "6kw"
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
    replaceScene(require("ui.login.home").create())
   end)
end

cfg.pay = function(l_4_0, l_4_1)
  local oparams = {productId = l_4_0.productId, type = 35}
  addWaitNet()
  getOrder(oparams, function(l_1_0)
    delWaitNet()
    tablePrint(l_1_0)
    local netOrder = jsonDecode(l_1_0.order_info)
    local ucParams = {product_id = netOrder.product_id, product_name = netOrder.product_name, product_desc = netOrder.product_desc, server_name = netOrder.server_name, server_id = "" .. player.sid, role_id = "" .. player.uid, role_name = player.name, role_level = player.lv(), vip_lv = player.vipLv(), order_id = netOrder.orderID, extradata = netOrder.extradata, notify_url = netOrder.notifyurl, channel = "1", price = netOrder.order_money, buy_num = netOrder.buy_num, extension = netOrder.extension or ""}
    require("data.takingdata").onChargeReq(ucParams.order_id, ucParams.product_id, ucParams.price, "CNY", 0, "third")
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
      showToast("\228\186\164\230\152\147\230\173\163\229\156\168\229\164\132\231\144\134...")
      require("data.takingdata").onChargeSuc(ucParams.order_id)
      local gParams = {sid = player.sid, orderid = netOrder.cp_order_id or "", appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
      addWaitNet()
      schedule(director:getRunningScene(), 0.5, function()
        netClient:gpay(gParams, function(l_1_0)
          tablePrint(l_1_0)
          delWaitNet()
          if l_1_0.status ~= 0 then
            showToast("\232\174\162\229\141\149\229\188\130\229\184\184\239\188\140\232\175\183\231\161\174\232\174\164\230\148\175\228\187\152\229\174\140\230\136\144\228\186\134\239\188\140\232\129\148\231\179\187\229\174\162\230\156\141")
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

cfg.exit = function(l_5_0, l_5_1)
  SDKHelper:getInstance():exitGame("", function(l_1_0)
    print("exitGame data:", l_1_0)
    if callback then
      callback()
    end
   end)
end

cfg.submitRoleData = function(l_6_0, l_6_1)
  if not l_6_0 or l_6_0.stype ~= "enterServer" then
    return 
  end
  local sparams = {stype = l_6_0.stype or "1", role_id = l_6_0.roleId .. "", role_name = l_6_0.roleName .. "", role_level = checkint(l_6_0.roleLevel), server_id = l_6_0.zoneId .. "", server_name = l_6_0.zoneName .. "", balance = require("data.bag").gem() .. "", vip_level = player.vipLv() .. "", party_name = player.gname or "None", role_c_time = l_6_0.roleCTime}
  cfg.need_submit = nil
  local paramStr = jsonEncode(sparams)
  SDKHelper:getInstance():submitRoleData(paramStr, function(l_1_0)
   end)
end

return cfg


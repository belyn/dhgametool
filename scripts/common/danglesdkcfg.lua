-- Command line was: E:\github\dhgametool\scripts\common\danglesdkcfg.lua 

local cfg = {}
cfg.upName = "dangle"
cfg.support_takingdata = true
local cjson = json
require("common.func")
require("common.const")
local netClient = require("net.netClient")
local i18n = require("res.i18n")
local player = require("data.player")
local userdata = require("data.userdata")
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
  local txparams = {which = "dangle"}
  local txparamsstr = jsonEncode(txparams)
  print("dangle\232\191\155\229\133\165login\229\137\141\231\154\132\230\156\128\229\144\142\228\184\128\230\173\165")
  cfg.logout()
  SDKHelper:getInstance():login(txparamsstr, function(l_1_0)
    local __data = jsonDecode(l_1_0)
    tablePrint(__data)
    if __data and __data.errcode and __data.errcode ~= 0 then
      showToast("\231\153\187\233\153\134\229\164\177\232\180\165")
      schedule(director:getRunningScene(), 1, function()
        replaceScene(require("ui.login.home").create())
         end)
      return 
    end
    local jparams = {umid = __data.umid, token = __data.token}
    local jsonstr = jsonEncode(jparams)
    local nparams = {sid = 0, jsonStr = jsonstr, platform = "dangle"}
    print("\231\189\145\231\187\156\232\175\183\230\177\130\229\143\145\232\181\183 = " .. jsonstr)
    netClient:thirdlogin(nparams, function(l_2_0)
      print("\231\189\145\231\187\156\230\148\182\229\136\176\229\155\158\228\191\161")
      if callback then
        callback(l_2_0)
      end
      end)
   end)
end

cfg.logout = function(l_3_0, l_3_1)
  SDKHelper:getInstance():logout("", function(l_1_0)
    schedule(director:getRunningScene(), function()
      replaceScene(require("ui.login.home").create())
      end)
   end)
end

cfg.exit = nil
cfg.pay = function(l_4_0, l_4_1)
  local oparams = {productId = l_4_0.productId, type = 17}
  addWaitNet()
  getOrder(oparams, function(l_1_0)
    tablePrint(l_1_0)
    local netOrder = jsonDecode(l_1_0.order_info)
    local txParams = {cpOrderId = netOrder.cpOrderId, cpUserInfo = netOrder.cpUserInfo, price = netOrder.price .. "", productId = netOrder.productId or "", productName = netOrder.productName, productDes = netOrder.productDes, cpSign = netOrder.cpSign or "", ext = netOrder.ext or "", zoneId = player.sid .. "", zoneName = "S" .. player.sid, roleId = player.uid .. "", roleName = player.name}
    require("data.takingdata").onChargeReq(txParams.cpOrderId, oparams.productId, txParams.price, "CNY", 0, "third")
    local paramStr = jsonEncode(txParams)
    SDKHelper:getInstance():pay(paramStr, function(l_1_0)
      local tdata = jsonDecode(l_1_0)
      if not tdata or not tdata.errcode or tdata.errcode ~= 0 then
        delWaitNet()
        showToast("\230\148\175\228\187\152\229\143\150\230\182\136\230\136\150\229\164\177\232\180\165:" .. (tdata.desc or ""))
        if callback then
          callback()
        end
        return 
      end
      require("data.takingdata").onChargeSuc(txParams.cpOrderId)
      showToast("\230\148\175\228\187\152\230\136\144\229\138\159.")
      local gParams = {sid = player.sid, orderid = netOrder.cpOrderId, appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
      local director = CCDirector:sharedDirector()
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

cfg.submitRoleData = function(l_5_0, l_5_1)
  local sparams = {roleId = l_5_0.roleId .. "", roleName = l_5_0.roleName .. "", roleLevel = l_5_0.roleLevel .. "", roleCTime = l_5_0.roleCTime .. "", roleLevelMTime = l_5_0.roleCTime .. "", zoneId = l_5_0.zoneId .. "", zoneName = l_5_0.zoneName .. "", eventType = "1"}
  if l_5_0.stype == "levelUp" then
    sparams.eventType = "3"
  end
  local paramStr = jsonEncode(sparams)
  SDKHelper:getInstance():submitRoleData(paramStr, function(l_1_0)
   end)
end

return cfg


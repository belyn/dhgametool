-- Command line was: E:\github\dhgametool\scripts\common\amazonsdkcfg.lua 

local cfg = {}
cfg.upName = "amazon"
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
local login_error = "refresh"
cfg.login = function(l_2_0, l_2_1)
  addWaitNet()
  cfg.logout()
  cfg.initGame()
  SDKHelper:getInstance():login(login_error, function(l_1_0)
    print("sdklogin\239\188\154", l_1_0)
    local __data = jsonDecode(l_1_0)
    if __data and __data.errcode and __data.errcode ~= 0 then
      delWaitNet()
      showToast(__data.desc or "\231\153\187\229\189\149\229\164\177\232\180\165")
      schedule(director:getRunningScene(), 1, function()
        replaceScene(require("ui.login.home").create())
         end)
    else
      local jparams = {token = __data.token}
      local jsonstr = jsonEncode(jparams)
      local nparams = {sid = 0}
      nparams.jsonStr = jsonstr
      nparams.platform = "amazon"
      netClient:thirdlogin(nparams, function(l_2_0)
        tablePrint(l_2_0)
        if not l_2_0 or l_2_0.status ~= 0 then
          login_error = "refresh"
        else
          login_error = ""
        end
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

cfg.exit = nil
local getSku = function(l_4_0)
  local cfgstore = require("config.store")
  for id,cfg in ipairs(cfgstore) do
    if id == l_4_0 then
      return cfg.payId
    end
  end
  return nil
end

local getPrice = function(l_5_0)
  local cfgstore = require("config.store")
  for id,cfg in ipairs(cfgstore) do
    if id == l_5_0 then
      return "" .. cfg.price
    end
  end
  return "0"
end

local trackPayment = function(l_6_0)
  HHUtils:trackPaymentAppsFlyer(tonumber(l_6_0), "USD")
end

local updateReceipts = {}
local amazon_userid = ""
local handleUpdateReceipts = function(l_7_0)
  if not l_7_0 or string.trim(l_7_0) == "" then
    return 
  end
  local tdata = jsonDecode(l_7_0)
  local rts = tdata.receiptids or ""
  upvalue_512 = tdata.userid
  local arr = string.split(rts, "|")
  for _,rt in ipairs(arr) do
    local tmpObj = string.trim(rt)
    updateReceipts[#updateReceipts + 1] = tmpObj
  end
end

local fullfill = function(l_8_0)
  SDKHelper:getInstance():submitRoleData(l_8_0, function(l_1_0)
   end)
end

local checking = nil
cfg.checkRts = function()
  if checking then
    return 
  end
  if #updateReceipts < 1 then
    checking = nil
    return 
  end
  checking = true
  local rts_cp = arraycp(updateReceipts)
  local vParams = {sid = player.sid, receiptid = updateReceipts, userid = amazon_userid}
  netClient:amznpay(vParams, function(l_1_0)
    tbl2string(l_1_0)
    for ii = 1, #rts_cp do
      fullfill(rts_cp[ii])
    end
    if l_1_0.money then
      trackPayment(l_1_0.money)
    end
   end)
  arrayclear(updateReceipts)
  upvalue_512 = {}
end

cfg.initGame = function()
  SDKHelper:getInstance():initGame("", function(l_1_0)
    print("rts:", l_1_0)
    handleUpdateReceipts(l_1_0)
   end)
end

cfg.pay = function(l_11_0, l_11_1)
  local sku = getSku(l_11_0.productId)
  if not sku then
    delWaitNet()
    showToast("get sku failed.")
    return 
  end
  addWaitNet()
  local ucParams = {sku = sku}
  local paramStr = jsonEncode(ucParams)
  SDKHelper:getInstance():pay(paramStr, function(l_1_0)
    local tdata = jsonDecode(l_1_0)
    if not tdata or not tdata.errcode or tdata.errcode ~= 0 then
      if callback then
        callback()
      end
      return 
    end
    local gParams = {sid = player.sid, orderid = tdata.receiptid, userid = tdata.userid, productid = "" .. params.productId, appsflyer = HHUtils:getAppsFlyerId(), advertising = HHUtils:getAdvertisingId()}
    schedule(director:getRunningScene(), 0.5, function()
      netClient:gpay(gParams, function(l_1_0)
        tablePrint(l_1_0)
        delWaitNet()
        if l_1_0.status ~= 0 then
          showToast(i18n.global.error_server_status_wrong.string .. tostring(l_1_0.status))
          return 
        end
        fullfill(tdata.receiptid)
        if (l_1_0.reward.equips and #l_1_0.reward.equips > 0) or l_1_0.reward.items and #l_1_0.reward.items > 0 then
          require("data.activity").pay()
        end
        trackPayment(getPrice(params.productId))
        if callback then
          callback(l_1_0.reward)
        end
         end)
      end)
   end)
end

return cfg

